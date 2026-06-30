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
import bcrypt from "bcryptjs";

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

// Legacy client-side hash, kept ONLY to verify (and then retire) old accounts.
async function legacySha256(pw: string): Promise<string> {
  const buf = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode("alfazi_2024" + pw),
  );
  return Array.from(new Uint8Array(buf))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

function isValidUsername(u: unknown): u is string {
  return typeof u === "string" && u.trim().length >= 2 && u.trim().length <= 32;
}
function isValidPassword(p: unknown): p is string {
  return typeof p === "string" && p.length >= 4 && p.length <= 128;
}

// Verifies {username, password} against the DB, transparently migrating
// a legacy sha256 account to bcrypt on success. Returns the user row
// (sans password fields) on success, or null on failure.
async function authenticate(username: string, password: string) {
  const { data: user, error } = await db
    .from("users")
    .select("*")
    .eq("username", username)
    .maybeSingle();
  if (error || !user) return null;

  // Case 1: already migrated — bcrypt is authoritative.
  if (user.password_hash_bcrypt) {
    const ok = await bcrypt.compare(password, user.password_hash_bcrypt);
    return ok ? user : null;
  }

  // Case 2: legacy account — verify against the old client-side hash,
  // then migrate transparently.
  if (user.password_hash) {
    const legacyHash = await legacySha256(password);
    if (legacyHash !== user.password_hash) return null;
    const newHash = await bcrypt.hash(password, 10);
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
        return json({ ok: true, username });
      }

      // ---------------------------------------------------------------
      case "login": {
        const username = typeof body.username === "string" ? body.username.trim().toLowerCase() : "";
        const password = body.password;
        if (!isValidUsername(username) || !isValidPassword(password)) {
          return unauthorized("Неверный логин или пароль");
        }
        const user = await authenticate(username, password as string);
        if (!user) return unauthorized("Неверный логин или пароль");
        return json({ ok: true, user: stripSecrets(user) });
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
        if (!isValidUsername(username) || !isValidPassword(password)) {
          return unauthorized("Неверный логин или пароль");
        }
        const user = await authenticate(username, password as string);
        if (!user) return unauthorized("Неверный логин или пароль");

        switch (action) {
          case "get-state": {
            const { data: stats } = await db
              .from("word_stats")
              .select("*")
              .eq("username", username);
            return json({ ok: true, user: stripSecrets(user), wordStats: stats || [] });
          }

          case "update-word-stat": {
            const wordAr = body.word_ar;
            if (typeof wordAr !== "string" || !wordAr) return badRequest("word_ar required");
            const update: Record<string, unknown> = { username, word_ar: wordAr };
            if (typeof body.seen_count === "number") update.seen_count = body.seen_count;
            if (typeof body.level === "number") update.level = body.level;
            if (typeof body.next_review === "string") update.next_review = body.next_review;
            if (typeof body.is_favorite === "boolean") update.is_favorite = body.is_favorite;
            const { error } = await db.from("word_stats").upsert(update, {
              onConflict: "username,word_ar",
            });
            if (error) return badRequest(error.message);
            return json({ ok: true });
          }

          case "log-score": {
            const points = body.points;
            const courseName = body.course_name;
            if (typeof points !== "number" || !Number.isFinite(points)) return badRequest("points required");
            const { error: insErr } = await db.from("score_history").insert({
              username,
              course_name: typeof courseName === "string" ? courseName : null,
              points,
            });
            if (insErr) return badRequest(insErr.message);
            const newTotal = (user.total_score || 0) + points;
            const { error: updErr } = await db
              .from("users")
              .update({ total_score: newTotal })
              .eq("username", username);
            if (updErr) return badRequest(updErr.message);
            return json({ ok: true, total_score: newTotal });
          }

          case "update-survival-record": {
            const val = body.survival_record;
            if (typeof val !== "number") return badRequest("survival_record required");
            if (val <= (user.survival_record || 0)) return json({ ok: true, unchanged: true });
            const { error } = await db
              .from("users")
              .update({ survival_record: val })
              .eq("username", username);
            if (error) return badRequest(error.message);
            return json({ ok: true });
          }

          case "update-streak": {
            // Server recomputes streak from last_activity rather than
            // trusting a client-supplied streak number directly, to
            // avoid letting a tampered client award itself days.
            const today = new Date().toISOString().split("T")[0];
            const last = user.last_activity as string | null;
            let streak = (user.streak as number) || 0;
            if (last !== today) {
              const yesterday = new Date();
              yesterday.setDate(yesterday.getDate() - 1);
              const yStr = yesterday.toISOString().split("T")[0];
              streak = last === yStr ? streak + 1 : 1;
            }
            const maxStreak = Math.max(streak, (user.max_streak as number) || 0);
            const { error } = await db
              .from("users")
              .update({ streak, last_activity: today, max_streak: maxStreak })
              .eq("username", username);
            if (error) return badRequest(error.message);
            return json({ ok: true, streak, max_streak: maxStreak });
          }

          case "update-daily-count": {
            const count = body.daily_words;
            if (typeof count !== "number") return badRequest("daily_words required");
            const today = new Date().toISOString().split("T")[0];
            const { error } = await db
              .from("users")
              .update({ daily_words: count, last_count_date: today })
              .eq("username", username);
            if (error) return badRequest(error.message);
            return json({ ok: true });
          }

          default:
            return badRequest("Unknown action: " + action);
        }
      }
    }
  } catch (e) {
    return json({ error: "Internal error: " + (e instanceof Error ? e.message : String(e)) }, 500);
  }
});
