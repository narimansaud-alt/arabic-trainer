// Alfazi API — Supabase Edge Function
//
// This is the ONLY place in the whole system allowed to write to
// `users`, `word_stats`, and `score_history`. It runs with the
// service_role key (server-side only, never exposed to the browser),
// which bypasses RLS by design — that's safe here precisely because
// every write below is gated by an explicit username/ownership check
// written in this file, not left to the database's default-open RLS.
//
// The browser only ever talks to this function (for anything that
// writes or touches a password) and to the public anon key (for
// read-only reference data: words, rules, notifications, leaderboard).
//
// Auth design:
//   - New accounts: password hashed with bcrypt (password_hash_bcrypt).
//   - Legacy accounts (pre-migration): only have the old client-side
//     sha256("alfazi_2024"+pw) hash in `password_hash`. On their next
//     successful login we verify against that legacy hash, then
//     immediately compute + store a bcrypt hash and stop relying on
//     the legacy field for that account from then on.
//   - We deliberately do NOT batch-migrate all passwords at once: we
//     never see anyone's plaintext password except at the moment they
//     log in, so a "lazy" per-login migration is the only safe option
//     that requires zero password resets.

import { createClient } from "jsr:@supabase/supabase-js@2";
import bcrypt from "npm:bcryptjs@3.0.2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const db = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: { persistSession: false },
});

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const MOSCOW_OFFSET_MS = 3 * 60 * 60 * 1000;
const SESSION_TTL_MS = 30 * 24 * 60 * 60 * 1000; // 30 days
const DAILY_STREAK_GOAL = 30;
const MAX_DAILY_WORDS = 1000000;
const MAX_SCORE_POINTS = 500;

function moscowDateKey(offsetDays = 0) {
  return new Date(Date.now() + MOSCOW_OFFSET_MS + offsetDays * 24 * 60 * 60 * 1000)
    .toISOString()
    .split("T")[0];
}

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
  });
}

function badRequest(msg: string) {
  return json({ error: msg }, 400);
}

function unauthorized(msg = "Unauthorized") {
  return json({ error: msg }, 401);
}

async function sha256Hex(value: string): Promise<string> {
  const buf = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(value));
  return Array.from(new Uint8Array(buf))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

// Legacy client-side hash, kept ONLY to verify (and then retire) old accounts.
async function legacySha256(pw: string): Promise<string> {
  return sha256Hex("alfazi_2024" + pw);
}

function isValidUsername(u: unknown): u is string {
  return typeof u === "string" && u.trim().length >= 2 && u.trim().length <= 32;
}
function isValidPassword(p: unknown): p is string {
  return typeof p === "string" && p.length >= 4 && p.length <= 128;
}

function isIntegerInRange(v: unknown, min: number, max: number): v is number {
  return typeof v === "number" && Number.isFinite(v) && Number.isInteger(v) && v >= min && v <= max;
}

async function createSession(username: string): Promise<{ token: string | null; expiresAt: string | null }> {
  try {
    await db.from("user_sessions").delete().eq("username", username).lt("expires_at", new Date().toISOString());
    const token = crypto.randomUUID() + "-" + crypto.randomUUID();
    const tokenHash = await sha256Hex(token);
    const now = new Date();
    const expiresAt = new Date(now.getTime() + SESSION_TTL_MS).toISOString();
    const { error } = await db.from("user_sessions").insert({
      username,
      token_hash: tokenHash,
      created_at: now.toISOString(),
      expires_at: expiresAt,
      last_used_at: now.toISOString(),
    });
    if (error) throw error;
    const { data: sessions } = await db
      .from("user_sessions")
      .select("token_hash")
      .eq("username", username)
      .order("created_at", { ascending: false })
      .range(5, 50);
    const oldHashes = (sessions || []).map((item) => item.token_hash).filter(Boolean);
    if (oldHashes.length) await db.from("user_sessions").delete().in("token_hash", oldHashes);
    return { token, expiresAt };
  } catch {
    return { token: null, expiresAt: null };
  }
}

async function getUserByUsername(username: string) {
  const { data: user, error } = await db
    .from("users")
    .select("*")
    .eq("username", username)
    .maybeSingle();
  if (error || !user) return null;
  return user;
}

// Verifies {username, password} against the DB, transparently migrating
// a legacy sha256 account to bcrypt on success. Returns the user row
// (sans password fields) on success, or null on failure.
async function authenticate(username: string, password: unknown, sessionToken: unknown) {
  const user = await getUserByUsername(username);
  if (!user) return null;

  if (typeof sessionToken === "string" && sessionToken.length > 10) {
    const tokenHash = await sha256Hex(sessionToken);
    const { data: session, error: sessionErr } = await db
      .from("user_sessions")
      .select("expires_at,last_used_at")
      .eq("username", username)
      .eq("token_hash", tokenHash)
      .maybeSingle();
    if (!sessionErr && session?.expires_at) {
      if (new Date(session.expires_at).getTime() > Date.now()) {
        const now = new Date();
        const lastUsed = session.last_used_at ? new Date(session.last_used_at).getTime() : 0;
        if (now.getTime() - lastUsed > 60 * 60 * 1000) {
          const nextExpiresAt = new Date(now.getTime() + SESSION_TTL_MS).toISOString();
          await db
            .from("user_sessions")
            .update({ last_used_at: now.toISOString(), expires_at: nextExpiresAt })
            .eq("username", username)
            .eq("token_hash", tokenHash);
        }
        return user;
      }
      await db.from("user_sessions").delete().eq("username", username).eq("token_hash", tokenHash);
    }
  }

  if (!isValidPassword(password)) return null;

  // Case 1: already migrated — bcrypt is authoritative.
  if (user.password_hash_bcrypt) {
    const ok = await bcrypt.compare(password as string, user.password_hash_bcrypt);
    return ok ? user : null;
  }

  // Case 2: legacy account — verify against the old client-side hash,
  // then migrate transparently.
  if (user.password_hash) {
    const legacyHash = await legacySha256(password as string);
    if (legacyHash !== user.password_hash) return null;
    const newHash = await bcrypt.hash(password as string, 10);
    await db
      .from("users")
      .update({ password_hash_bcrypt: newHash })
      .eq("username", username);
    return user;
  }

  return null;
}

function stripSecrets(user: Record<string, unknown>) {
  const { password_hash, password_hash_bcrypt, ...safe } = user;
  return safe;
}

function shortText(value: unknown, maxLength: number) {
  if (value == null) return null;
  return String(value).slice(0, maxLength);
}

function scrubLogValue(value: unknown): unknown {
  if (value == null) return value;
  if (typeof value === "string") {
    return value
      .replace(/("?(?:password|pass|pw|token|apikey|authorization)"?\s*[:=]\s*)("[^"]*"|[^\s,}]+)/gi, '$1"[redacted]"')
      .slice(0, 4000);
  }
  if (Array.isArray(value)) return value.slice(0, 20).map(scrubLogValue);
  if (typeof value === "object") {
    const out: Record<string, unknown> = {};
    for (const [key, item] of Object.entries(value as Record<string, unknown>).slice(0, 40)) {
      out[key] = /password|pass|pw|token|apikey|authorization/i.test(key) ? "[redacted]" : scrubLogValue(item);
    }
    return out;
  }
  return value;
}

async function logClientError(body: Record<string, unknown>, req: Request) {
  const context = typeof body.context === "object" && body.context !== null ? scrubLogValue(body.context) : null;
  const allowedKinds = new Set(["error", "unhandled-rejection", "resource", "api", "invariant", "pwa", "diagnostic"]);
  const allowedSeverities = new Set(["info", "warning", "error", "fatal"]);
  const kind = typeof body.kind === "string" && allowedKinds.has(body.kind) ? body.kind : "error";
  const severity = typeof body.severity === "string" && allowedSeverities.has(body.severity) ? body.severity : "error";
  const { error } = await db.from("app_error_log").insert({
    username: shortText(body.username, 32),
    source: shortText(body.source, 80),
    message: shortText(body.message, 1000) || "Unknown client error",
    kind,
    severity,
    fingerprint: shortText(body.fingerprint, 300),
    occurred_at: shortText(body.occurred_at, 80),
    stack: shortText(body.stack, 4000),
    url: shortText(body.url, 1000),
    user_agent: shortText(body.user_agent, 1000),
    app_version: shortText(body.app_version, 80),
    context,
    client_ip: shortText(req.headers.get("cf-connecting-ip") || req.headers.get("x-forwarded-for"), 80),
    cf_ray: shortText(req.headers.get("cf-ray"), 80),
  });
  if (error) return badRequest(error.message);
  return json({ ok: true });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  let body: Record<string, unknown>;
  try {
    body = await req.json();
  } catch {
    return badRequest("Invalid JSON body");
  }

  const action = body.action;
  if (typeof action !== "string") return badRequest("Missing action");

  try {
    switch (action) {
      case "log-client-error":
        return await logClientError(body, req);

      // ---------------------------------------------------------------
      case "register": {
        const username = typeof body.username === "string" ? body.username.trim().toLowerCase() : "";
        const password = body.password;
        if (!isValidUsername(username)) return badRequest("Логин минимум 2 символа");
        if (!isValidPassword(password)) return badRequest("Пароль минимум 4 символа");

        const hash = await bcrypt.hash(password as string, 10);
        const { error } = await db.from("users").insert({
          username,
          password_hash_bcrypt: hash,
          total_score: 0,
          survival_record: 0,
        });
        if (error) {
          if ((error as { code?: string }).code === "23505") return badRequest("Логин занят");
          return badRequest("Ошибка регистрации: " + error.message);
        }
        const { token } = await createSession(username);
        return json({ ok: true, username, session_token: token });
      }

      // ---------------------------------------------------------------
      case "login": {
        const username = typeof body.username === "string" ? body.username.trim().toLowerCase() : "";
        const password = body.password;
        if (!isValidUsername(username) || !isValidPassword(password)) {
          return unauthorized("Неверный логин или пароль");
        }
        const user = await authenticate(username, password as string, undefined);
        if (!user) return unauthorized("Неверный логин или пароль");
        const { token } = await createSession(username);
        return json({ ok: true, user: stripSecrets(user), session_token: token });
      }

      // ---------------------------------------------------------------
      // Every action below requires the caller to prove they know the
      // account's current password, since there is no session/JWT layer
      // in front of this lightweight username/password system. This is
      // the same trust boundary the legacy client used (it kept the
      // password hash in localStorage and matched rows by username) —
      // here we just verify it server-side on every write instead of
      // trusting a client-supplied username with no proof at all.
      default: {
        const username = typeof body.username === "string" ? body.username.trim().toLowerCase() : "";
        const password = body.password;
        const sessionToken = body.session_token;
        if (!isValidUsername(username) || (!isValidPassword(password) && typeof sessionToken !== "string")) {
          return unauthorized("Неверный логин или пароль");
        }
        const user = await authenticate(username, password, sessionToken);
        if (!user) return unauthorized("Неверный логин или пароль");

        switch (action) {
          case "get-state": {
            const { data: stats } = await db
              .from("word_stats")
              .select("*")
              .eq("username", username);
            return json({ ok: true, user: stripSecrets(user), wordStats: stats || [] });
          }

          case "get-daily-goal": {
            const courseName = typeof body.course_name === "string" ? body.course_name.slice(0, 64) : "";
            if (!/^Мединский курс \(Том [1-4]\)$/.test(courseName)) return badRequest("Unsupported course");
            const { data, error } = await db.rpc("ensure_user_daily_goal", {
              p_username: username,
              p_course_name: courseName,
            });
            if (error) return badRequest(error.message);
            const refreshed = await getUserByUsername(username);
            return json({
              ok: true,
              goal: data,
              daily_goal_minutes: Number(refreshed?.daily_goal_minutes || 10),
              daily_goal_selected_at: refreshed?.daily_goal_selected_at || null,
              daily_goals_completed: Number(refreshed?.daily_goals_completed || 0),
            });
          }

          case "set-daily-goal-minutes": {
            const minutes = body.minutes;
            if (!isIntegerInRange(minutes, 5, 30) || ![5, 10, 20, 25, 30].includes(minutes)) {
              return badRequest("Unsupported daily goal");
            }
            const { data, error } = await db.rpc("set_user_daily_goal_minutes", {
              p_username: username,
              p_minutes: minutes,
            });
            if (error) return badRequest(error.message);
            return json({ ok: true, ...(data as Record<string, unknown>) });
          }

          case "sync-daily-goal-progress": {
            const courseName = typeof body.course_name === "string" ? body.course_name.slice(0, 64) : "";
            if (!/^Мединский курс \(Том [1-4]\)$/.test(courseName)) return badRequest("Unsupported course");
            const newCompleted = body.new_completed;
            const reviewCompleted = body.review_completed;
            const typingCompleted = body.typing_completed;
            if (
              !isIntegerInRange(newCompleted, 0, 1000000) ||
              !isIntegerInRange(reviewCompleted, 0, 1000000) ||
              !isIntegerInRange(typingCompleted, 0, 1000000)
            ) return badRequest("Daily goal progress invalid");
            const { data, error } = await db.rpc("sync_user_daily_goal_progress", {
              p_username: username,
              p_course_name: courseName,
              p_new_completed: newCompleted,
              p_review_completed: reviewCompleted,
              p_typing_completed: typingCompleted,
            });
            if (error) return badRequest(error.message);
            return json({ ok: true, ...(data as Record<string, unknown>) });
          }

      case "update-word-stat": {
            const wordAr = body.word_ar;
            if (typeof wordAr !== "string" || !wordAr) return badRequest("word_ar required");
            const update: Record<string, unknown> = { username, word_ar: wordAr };
            if ("seen_count" in body) {
              if (!isIntegerInRange(body.seen_count, 0, 1000000)) return badRequest("seen_count out of range");
              update.seen_count = body.seen_count;
            }
            if ("level" in body) {
              if (!isIntegerInRange(body.level, 1, 5)) return badRequest("level out of range");
              update.level = body.level;
            }
            if ("next_review" in body) {
              if (typeof body.next_review !== "string") return badRequest("next_review required");
              update.next_review = body.next_review;
            }
            if ("is_favorite" in body) {
              if (typeof body.is_favorite !== "boolean") return badRequest("is_favorite must be boolean");
              update.is_favorite = body.is_favorite;
            }
            const { error } = await db.from("word_stats").upsert(update, {
              onConflict: "username,word_ar",
            });
            if (error) return badRequest(error.message);
            return json({ ok: true });
          }

          case "log-score": {
            const points = body.points;
            const courseName = body.course_name;
            if (!isIntegerInRange(points, 1, MAX_SCORE_POINTS)) {
              return badRequest("integer points required");
            }
            const normalizedCourse = typeof courseName === "string" ? courseName.slice(0, 64) : "";
            if (!/^Мединский курс \(Том [1-4]\)$/.test(normalizedCourse)) {
              return badRequest("Unsupported course");
            }
            const scoreEventId = typeof body.score_event_id === "string" ? body.score_event_id : crypto.randomUUID();
            const logRes = await db.rpc("log_user_score", {
              p_username: username,
              p_points: points,
              p_course_name: normalizedCourse,
              p_event_id: scoreEventId,
            });
            if (logRes.error) return badRequest(logRes.error.message);
            const newTotal = logRes.data as number;
            if (typeof newTotal !== "number") {
              return badRequest("Failed to update score");
            }
            return json({ ok: true, total_score: newTotal });
          }

          case "revoke-session": {
            if (typeof sessionToken === "string" && sessionToken.length > 0) {
              const tokenHash = await sha256Hex(sessionToken);
              const { error } = await db
                .from("user_sessions")
                .delete()
                .eq("username", username)
                .eq("token_hash", tokenHash);
              if (error) return badRequest(error.message);
              return json({ ok: true, revoked: "token" });
            }

            const { error } = await db.from("user_sessions").delete().eq("username", username);
            if (error) return badRequest(error.message);
            return json({ ok: true, revoked: "all" });
          }

          case "update-survival-record": {
            const val = body.survival_record;
            if (!isIntegerInRange(val, 0, 1000000)) return badRequest("survival_record invalid");
            if (val <= (user.survival_record || 0)) return json({ ok: true, unchanged: true });
            const { error } = await db
              .from("users")
              .update({ survival_record: val })
              .eq("username", username);
            if (error) return badRequest(error.message);
            return json({ ok: true });
          }

          case "update-streak": {
            // Compatibility endpoint for older clients. A streak is now
            // awarded only by sync_user_daily_goal_progress after the full plan.
            const refreshed = await getUserByUsername(username);
            return json({ ok: true, streak: Number(refreshed?.streak || 0), max_streak: Number(refreshed?.max_streak || 0), unchanged: true });
          }

          case "update-daily-count": {
            const count = body.daily_words;
            if (!isIntegerInRange(count, 0, MAX_DAILY_WORDS)) return badRequest("daily_words invalid");
            const { data, error } = await db.rpc("sync_user_daily_words", {
              p_username: username,
              p_count: count,
            });
            if (error) return badRequest(error.message);
            return json({ ok: true, daily_words: Number(data || 0) });
          }

          case "increment-daily-count": {
            const { data, error } = await db.rpc("increment_user_daily_words", { p_username: username });
            if (error) return badRequest(error.message);
            const dailyWords = Number(data || 0);
            return json({ ok: true, daily_words: dailyWords, reached_goal: dailyWords >= DAILY_STREAK_GOAL });
          }

          default:
            return badRequest("Unknown action: " + action);
        }
      }
    }
  } catch (e) {
    const error = e instanceof Error ? e : new Error(String(e));
    await db.from("app_error_log").insert({
      username: shortText(body.username, 32),
      source: "edge-function",
      message: shortText(error.message, 1000) || "Internal error",
      kind: "error",
      severity: "fatal",
      stack: shortText(error.stack, 4000),
      context: scrubLogValue({ action }),
      client_ip: shortText(req.headers.get("cf-connecting-ip") || req.headers.get("x-forwarded-for"), 80),
      cf_ray: shortText(req.headers.get("cf-ray"), 80),
    });
    return json({ error: "Internal server error" }, 500);
  }
});
