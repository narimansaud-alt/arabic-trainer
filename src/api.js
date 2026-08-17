// api.js — single source of truth for all network access.
//
// Two distinct trust levels:
//   1) `db` (Supabase anon client) for public, read-only reference data:
//      words, rules, notifications, leaderboard.
//   2) `Api.call(action, payload)` for all other writes.

const SUPA_URL = 'https://vkdfthrvsafjmcmfcdic.supabase.co';
const SUPA_ANON_KEY =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrZGZ0aHJ2c2Fmam1jbWZjZGljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIyMDc0NDEsImV4cCI6MjA5Nzc4MzQ0MX0.fzj0WRXkl6j1cVKmEOr2ZCBjtATDAbeL220MqKQ6uB0';
const API_URL = SUPA_URL + '/functions/v1/api-v2';
const API_HEADERS = Object.freeze({
  'Content-Type': 'application/json',
  apikey: SUPA_ANON_KEY,
  Authorization: 'Bearer ' + SUPA_ANON_KEY,
});

const { createClient } = supabase;
const db = createClient(SUPA_URL, SUPA_ANON_KEY, { auth: { persistSession: false } });

const ErrorLog = {
  recent: new Set(),
  reportedErrors: new WeakSet(),
  queueKey: 'arabic_error_queue_v1',
  flushing: false,

  scrub(value) {
    if (value == null) return value;
    if (typeof value === 'string') {
      return value
        .replace(
          /("?(?:password|pass|pw|token|apikey|authorization)"?\s*[:=]\s*)("[^"]*"|[^\s,}]+)/gi,
          '$1"[redacted]"'
        )
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

  buildPayload(error, meta) {
    const message = error?.message || String(error || 'Unknown error');
    return {
      action: 'log-client-error',
      username: typeof App !== 'undefined' ? App.username : null,
      message: this.scrub(message),
      stack: this.scrub(error?.stack || null),
      source: meta?.source || 'client',
      kind: meta?.kind || 'error',
      severity: meta?.severity || 'error',
      fingerprint: meta?.fingerprint || null,
      occurred_at: new Date().toISOString(),
      url: location.href,
      user_agent: navigator.userAgent,
      app_version: document.documentElement.dataset.build || 'web',
      context: this.scrub({
        ...meta,
        online: navigator.onLine,
        visibility: document.visibilityState,
        screen: document.querySelector('.screen.active')?.id || null,
        volume: typeof App !== 'undefined' ? App.volume : null,
      }),
    };
  },

  readQueue() {
    try {
      const parsed = JSON.parse(localStorage.getItem(this.queueKey) || '[]');
      return Array.isArray(parsed) ? parsed.slice(-80) : [];
    } catch {
      return [];
    }
  },

  writeQueue(items) {
    try {
      localStorage.setItem(this.queueKey, JSON.stringify(items.slice(-80)));
    } catch {
      // Logging remains non-blocking when storage is unavailable.
    }
  },

  enqueue(payload) {
    const queue = this.readQueue();
    queue.push({ ...payload, queued_at: new Date().toISOString() });
    this.writeQueue(queue);
  },

  async send(payload) {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 6000);
    try {
      const response = await fetch(API_URL, {
        method: 'POST',
        headers: API_HEADERS,
        keepalive: true,
        signal: controller.signal,
        body: JSON.stringify(payload),
      });
      if (!response.ok) throw new Error('error-log-http-' + response.status);
    } finally {
      clearTimeout(timeoutId);
    }
  },

  async flush() {
    if (this.flushing || !navigator.onLine) return;
    const queue = this.readQueue();
    if (!queue.length) return;
    this.flushing = true;
    const remaining = [];
    for (const item of queue) {
      try {
        await this.send(item);
      } catch {
        remaining.push(item);
      }
    }
    this.writeQueue(remaining);
    this.flushing = false;
  },

  async capture(error, meta = {}) {
    try {
      const trackable = error !== null && (typeof error === 'object' || typeof error === 'function');
      if (trackable && this.reportedErrors.has(error)) return;
      if (trackable) this.reportedErrors.add(error);

      const message = error?.message || String(error || 'Unknown error');
      const signature = [meta?.source || 'unknown', meta?.action || '', message].join('|').slice(0, 300);
      if (this.recent.has(signature)) return;
      this.recent.add(signature);
      setTimeout(() => this.recent.delete(signature), 30000);

      const payload = this.buildPayload(error, meta);
      payload.fingerprint = payload.fingerprint || signature;
      try {
        await this.send(payload);
        void this.flush();
      } catch {
        this.enqueue(payload);
      }
    } catch {
      // Logging must never block app flow.
    }
  },

  diagnostic(code, meta = {}, severity = 'warning') {
    const safeCode = String(code || 'unknown-diagnostic').slice(0, 160);
    return this.capture(new Error(safeCode), {
      ...meta,
      source: meta.source || 'client-diagnostic',
      kind: meta.kind || 'diagnostic',
      severity,
      fingerprint: [meta.source || 'client-diagnostic', safeCode].join('|'),
    });
  },

  invariant(condition, code, meta = {}) {
    if (condition) return true;
    void this.diagnostic(code, { ...meta, kind: 'invariant' }, 'error');
    return false;
  },
};

const Api = {
  buildBody(action, payload = {}) {
    const body = { action, ...payload };

    if (action !== 'register' && action !== 'login') {
      if (!body.username && typeof App !== 'undefined' && App?.username) {
        body.username = App.username;
      }
      const hasSessionToken = typeof body.session_token === 'string' && body.session_token.trim().length > 0;
      if (!hasSessionToken && typeof App !== 'undefined' && App?.sessionToken) {
        body.session_token = App.sessionToken;
      }
      if ((body.password === undefined || body.password === null) && typeof App !== 'undefined' && App?.password) {
        body.password = App.password;
      }
      if (body.password == null) {
        delete body.password;
      }
    }

    return body;
  },

  /**
   * Calls the trusted Edge Function. payload should include
   * {username, password} or {session_token} for actions except login/register.
   */
  async call(action, payload, options = {}) {
    const body = this.buildBody(action, payload);
    let res;
    let data;
    let responseText = '';
    const timeoutMs = Number.isFinite(options.timeoutMs) && options.timeoutMs > 0 ? options.timeoutMs : 10000;
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

    try {
      res = await fetch(API_URL, {
        method: 'POST',
        headers: API_HEADERS,
        keepalive: options.keepalive === true,
        signal: controller.signal,
        body: JSON.stringify(body),
      });
      responseText = await res.text().catch(() => '');
      try {
        data = responseText ? JSON.parse(responseText) : {};
      } catch {
        data = { error: responseText || 'Invalid API response format.' };
      }
    } catch (e) {
      clearTimeout(timeoutId);
      if (e?.name === 'AbortError') {
        const error = new ApiError(`Request timeout (${timeoutMs}ms).`, 0);
        ErrorLog.capture(error, { source: 'api-timeout', action, kind: 'api', severity: 'warning' });
        throw error;
      }
      const error = new ApiError('Сеть недоступна. Проверьте подключение.', 0);
      ErrorLog.capture(error, { source: 'api-network', action, kind: 'api', severity: 'warning' });
      throw error;
    }
    clearTimeout(timeoutId);

    if (!res || !res.ok || data?.error) {
      const errorMessage = data?.error || data?.message || responseText || 'Unknown API error';
      if (res?.status === 401 && typeof clearStoredAuth === 'function' && action !== 'login' && action !== 'register') {
        clearStoredAuth();
        if (typeof resetApp === 'function') resetApp();
        if (typeof showScreen === 'function') showScreen('screen-login');
      }
      const error = new ApiError(errorMessage, res?.status || 0);
      const expectedAuthInput = ['login', 'register'].includes(action) && [400, 401, 409].includes(res?.status || 0);
      ErrorLog.capture(error, {
        source: 'api-response',
        action,
        status: res?.status,
        kind: 'api',
        severity: expectedAuthInput ? 'info' : 'error',
      });
      throw error;
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

function uiIcon(name, extraClass = '') {
  const safeName = String(name || '').replace(/[^a-z0-9-]/gi, '');
  const safeClass = String(extraClass || '').replace(/[^a-z0-9 _-]/gi, '');
  return '<span class="ui-icon ' + safeClass + '" aria-hidden="true"><svg><use href="#ui-icon-' + safeName + '"></use></svg></span>';
}

function setIconLabel(el, icon, label) {
  if (!el) return;
  el.innerHTML = uiIcon(icon) + '<span>' + String(label || '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c])) + '</span>';
}

function renderFavoriteButton(btn, active) {
  if (!btn) return;
  btn.innerHTML = uiIcon('star');
  btn.classList.toggle('is-active', Boolean(active));
  btn.setAttribute('aria-pressed', active ? 'true' : 'false');
  btn.setAttribute('aria-label', active ? 'Убрать из трудных слов' : 'Добавить в трудные слова');
}

window.addEventListener('error', (event) => {
  if (event.target && event.target !== window) {
    const target = event.target;
    ErrorLog.capture(new Error('Resource failed to load'), {
      source: 'resource-load',
      kind: 'resource',
      severity: 'error',
      tag: target.tagName || null,
      resource: target.currentSrc || target.src || target.href || null,
    });
    return;
  }
  ErrorLog.capture(event.error || new Error(event.message || 'Window error'), {
    source: 'window-error',
    kind: 'error',
    file: event.filename,
    line: event.lineno,
    column: event.colno,
  });
}, true);
window.addEventListener('unhandledrejection', (event) => {
  const reason = event.reason instanceof Error ? event.reason : new Error(String(event.reason || 'Unhandled promise rejection'));
  ErrorLog.capture(reason, { source: 'unhandled-rejection', kind: 'unhandled-rejection' });
});
(window.__earlyAppErrors || []).forEach(entry => ErrorLog.capture(entry.error, entry.meta));
window.__earlyAppErrors = [];
window.addEventListener('online', () => void ErrorLog.flush());
document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'visible') void ErrorLog.flush();
});
setTimeout(() => void ErrorLog.flush(), 1200);

async function checkPwaDiagnostics() {
  try {
    const response = await fetch('./manifest.json?diagnostic=' + Date.now(), { cache: 'no-store' });
    if (!response.ok) throw new Error('manifest-http-' + response.status);
    const manifest = await response.json();
    const expectedName = 'Мединский курс и глаголы';
    ErrorLog.invariant(manifest.id === './', 'pwa-manifest-id-mismatch', {
      source: 'pwa-identity',
      kind: 'pwa',
      manifest_id: manifest.id,
    });
    ErrorLog.invariant(manifest.name === expectedName, 'pwa-manifest-name-mismatch', {
      source: 'pwa-identity',
      kind: 'pwa',
      manifest_name: manifest.name,
      expected_name: expectedName,
    });
    ErrorLog.invariant(manifest.short_name === expectedName, 'pwa-manifest-short-name-mismatch', {
      source: 'pwa-identity',
      kind: 'pwa',
      manifest_short_name: manifest.short_name,
      expected_name: expectedName,
    });
    ErrorLog.invariant(manifest.name === manifest.short_name, 'pwa-manifest-name-split', {
      source: 'pwa-identity',
      kind: 'pwa',
      manifest_name: manifest.name,
      manifest_short_name: manifest.short_name,
    });
    if ('serviceWorker' in navigator) {
      const registration = await navigator.serviceWorker.getRegistration();
      const standalone = window.matchMedia?.('(display-mode: standalone)')?.matches || navigator.standalone === true;
      if (standalone) {
        ErrorLog.invariant(Boolean(registration), 'pwa-standalone-without-registration', {
          source: 'pwa-service-worker',
          kind: 'pwa',
        });
      }
    }
  } catch (error) {
    ErrorLog.capture(error, { source: 'pwa-diagnostics', kind: 'pwa', severity: 'warning' });
  }
}

setTimeout(() => void checkPwaDiagnostics(), 3500);
