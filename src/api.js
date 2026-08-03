// api.js — single source of truth for all network access.
//
// Two distinct trust levels:
//   1. `db` (Supabase anon client) — read-only, for genuinely public
//      reference data: words, rules, notifications, leaderboard.
//      The anon key has zero write/sensitive-read permissions now
//      (see the RLS migration); even if this key leaks again, it
//      cannot touch passwords, scores, or word progress.
//   2. `Api.call(action, payload)` — everything else. Talks to the
//      `api` Edge Function, which runs server-side with the
//      service_role key and enforces username+password ownership
//      checks before touching any row.
//
// No other file in this app should import @supabase/supabase-js or
// construct a Supabase client directly.

const SUPA_URL = 'https://vkdfthrvsafjmcmfcdic.supabase.co';
const SUPA_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrZGZ0aHJ2c2Fmam1jbWZjZGljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIyMDc0NDEsImV4cCI6MjA5Nzc4MzQ0MX0.fzj0WRXkl6j1cVKmEOr2ZCBjtATDAbeL220MqKQ6uB0';
const API_URL = SUPA_URL + '/functions/v1/api';

const { createClient } = supabase;
// Public, read-only client — used ONLY for words/rules/notifications/leaderboard.
const db = createClient(SUPA_URL, SUPA_ANON_KEY, { auth: { persistSession: false } });

const ErrorLog = {
  recent: new Set(),

  scrub(value) {
    if (value == null) return value;
    if (typeof value === 'string') {
      return value
        .replace(/("?(?:password|pass|pw|token|apikey|authorization)"?\s*[:=]\s*)("[^"]*"|[^\s,}]+)/gi, '$1"[redacted]"')
        .slice(0, 4000);
    }
    if (Array.isArray(value)) return value.slice(0, 20).map((v) => this.scrub(v));
    if (typeof value === 'object') {
      const out = {};
      Object.entries(value)
        .slice(0, 40)
        .forEach(([k, v]) => {
          out[k] = /password|pass|pw|token|apikey|authorization/i.test(k) ? '[redacted]' : this.scrub(v);
        });
      return out;
    }
    return value;
  },

  async capture(error, meta) {
    try {
      const message = error?.message || String(error || 'Unknown error');
      const signature = [meta?.source || 'unknown', meta?.action || '', message].join('|').slice(0, 300);
      if (this.recent.has(signature)) return;
      this.recent.add(signature);
      setTimeout(() => this.recent.delete(signature), 30000);

      await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'log-client-error',
          username: typeof App !== 'undefined' ? App.username : null,
          message,
          stack: error?.stack || null,
          source: meta?.source || 'client',
          url: location.href,
          user_agent: navigator.userAgent,
          app_version: 'web',
          context: this.scrub(meta || {}),
        }),
      });
    } catch {
      // Logging must never break the app.
    }
  },
};

const Api = {
  /**
   * Calls the trusted Edge Function. `payload` should include
   * {username, password} for any action other than 'register'/'login'
   * themselves, since the function re-verifies the password on every
   * write (there is no separate session/JWT layer).
   */
  async call(action, payload, options = {}) {
    let res, data;
    try {
      res = await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        keepalive: options.keepalive === true,
        body: JSON.stringify({ action, ...payload }),
      });
      data = await res.json();
    } catch (e) {
      ErrorLog.capture(e, { source: 'api-network', action });
      throw new ApiError('Сеть недоступна. Проверьте подключение.', 0);
    }
    if (!res.ok || data.error) {
      ErrorLog.capture(new ApiError(data.error || 'API error', res.status), { source: 'api-response', action, status: res.status });
      throw new ApiError(data.error || 'Неизвестная ошибка сервера', res.status);
    }
    return data;
  },
};

class ApiError extends Error {
  constructor(message, status) {
    super(message);
    this.status = status;
  }
}
