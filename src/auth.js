// auth.js вЂ” login, registration, and local session persistence.
//
// This flow keeps the active password only in memory (for fallback
// compatibility), and stores a short-lived session token in localStorage
// for auto-login and write authorization after successful auth.
// A leaked anon key now grants nothing: there is no anon table access
// to users/word_stats/score_history at all.

const SESSION_STORAGE_KEY = 'arabic_session';
const LEGACY_AUTH_STORAGE_KEY = 'arabic_auth';

let loginMode = 'login';
let __authInFlight = false;

function switchLoginTab(t) {
  loginMode = t;
  document.querySelectorAll('.tab-btn').forEach((b, i) => {
    b.classList.toggle('active', (i === 0 && t === 'login') || (i === 1 && t === 'reg'));
  });
  const loginForm = document.getElementById('login-form');
  const regForm = document.getElementById('reg-form');
  const msgEl = document.getElementById('login-msg');
  if (loginForm) loginForm.classList.toggle('hidden', t !== 'login');
  if (regForm) regForm.classList.toggle('hidden', t !== 'reg');
  if (msgEl) msgEl.textContent = '';
}

function setMsg(t, c) {
  const el = document.getElementById('login-msg');
  if (!el) return;
  el.textContent = t;
  el.className = 'login-msg ' + (c || '');
}

function saveSessionToken(username, token, password) {
  if (username) {
    try {
      if (token) localStorage.setItem(SESSION_STORAGE_KEY, JSON.stringify({ username, token }));
      if (password) localStorage.setItem(LEGACY_AUTH_STORAGE_KEY, JSON.stringify({ username, password }));
    } catch (e) {
      ErrorLog.capture(e, { source: 'auth', action: 'save-auth' });
    }
    return;
  }
  try {
    localStorage.removeItem(SESSION_STORAGE_KEY);
    localStorage.removeItem(LEGACY_AUTH_STORAGE_KEY);
  } catch (e) {
    /* non-fatal */
  }
}

function clearSessionToken() {
  try {
    localStorage.removeItem(SESSION_STORAGE_KEY);
  } catch (e) {
    ErrorLog.capture(e, { source: 'auth', action: 'clear-session-token' });
  }
}

function clearStoredAuth() {
  try {
    localStorage.removeItem(SESSION_STORAGE_KEY);
    localStorage.removeItem(LEGACY_AUTH_STORAGE_KEY);
  } catch (e) {
    /* non-fatal */
  }
}

async function hydrateAfterAuth() {
  await loadUserStats();
  checkAnnouncement().catch(() => {});
}

function createGuestState() {
  return {
    total_score: 0,
    survival_record: 0,
    streak: 0,
    max_streak: 0,
  };
}

async function doLogin() {
  if (__authInFlight) return;
  const unEl = document.getElementById('l-user');
  const pwEl = document.getElementById('l-pass');
  if (!unEl || !pwEl) return setMsg('Форма входа временно недоступна', 'err');

  const un = unEl.value.trim().toLowerCase();
  const pw = pwEl.value;
  if (!un || un.length < 2) return setMsg('Введите логин (минимум 2 символа)', 'err');
  if (!pw || pw.length < 4) return setMsg('Введите пароль (минимум 4 символа)', 'err');

  setMsg('Загрузка...');
  __authInFlight = true;
  try {
    const { user, session_token } = await Api.call('login', { username: un, password: pw }, { timeoutMs: 7000 });
    const safeUser = user || {};
    applyLoggedInUser(un, safeUser, pw, session_token || null);
    saveSessionToken(un, session_token || null, pw);
    await hydrateAfterAuth();
    goToCourse();
  } catch (e) {
    ErrorLog.capture(e, { source: 'auth', action: 'login' });
    setMsg(e.message || 'Неверный логин или пароль', 'err');
  } finally {
    __authInFlight = false;
  }
}

async function doRegister() {
  if (__authInFlight) return;
  const unEl = document.getElementById('r-user');
  const pwEl = document.getElementById('r-pass');
  const pw2El = document.getElementById('r-pass2');
  if (!unEl || !pwEl || !pw2El) return setMsg('Форма регистрации временно недоступна', 'err');

  const un = unEl.value.trim().toLowerCase();
  const pw = pwEl.value;
  const pw2 = pw2El.value;
  if (un.length < 3) return setMsg('Введите логин (мин. 3 символа)', 'err');
  if (pw.length < 4) return setMsg('Введите пароль (мин. 4 символа)', 'err');
  if (pw !== pw2) return setMsg('Пароли не совпадают', 'err');

  setMsg('Регистрируемся...');
  __authInFlight = true;
  try {
    const { user, session_token } = await Api.call('register', { username: un, password: pw }, { timeoutMs: 7000 });
    setMsg('Готово! Пройдём...', 'ok');
    const safeUser = user && Object.keys(user).length ? user : createGuestState();
    applyLoggedInUser(un, safeUser, pw, session_token || null);
    saveSessionToken(un, session_token || null, pw);
    try {
      await hydrateAfterAuth();
    } catch {
      // non-fatal
    }
    setTimeout(goToCourse, 800);
  } catch (e) {
    ErrorLog.capture(e, { source: 'auth', action: 'register' });
    setMsg(e.message || 'Ошибка регистрации', 'err');
  } finally {
    __authInFlight = false;
  }
}

function applyLoggedInUser(username, user, password = null, sessionToken = null) {
  App.username = username;
  App.password = password;
  App.sessionToken = sessionToken;
  App.totalScore = user.total_score || 0;
  App.survivalRecord = user.survival_record || 0;
  App.streak = user.streak || 0;
  App.maxStreak = user.max_streak || 0;
}

async function tryAutoLogin() {
  let sessionData = null;
  try {
    sessionData = localStorage.getItem(SESSION_STORAGE_KEY);
  } catch (e) {
    clearStoredAuth();
    ErrorLog.capture(e, { source: 'auth', action: 'auto-login-session-storage' });
    return false;
  }
  if (sessionData) {
    try {
      const parsed = JSON.parse(sessionData);
      if (!parsed || typeof parsed !== 'object') throw new Error('invalid-session-payload');
      const { username, token } = parsed;
      if (typeof username === 'string' && username && typeof token === 'string' && token) {
        let fallbackPassword = null;
        try {
          const legacy = JSON.parse(localStorage.getItem(LEGACY_AUTH_STORAGE_KEY) || 'null');
          if (legacy?.username === username && typeof legacy.password === 'string') fallbackPassword = legacy.password;
        } catch (e) {
          ErrorLog.capture(e, { source: 'auth', action: 'read-password-fallback' });
        }
        const state = await Api.call('get-state', { username, session_token: token }, { timeoutMs: 3500 });
        const user = (state || {}).user || {};
        applyLoggedInUser(username, user, fallbackPassword, token);
        await loadUserStats(state);
        checkAnnouncement().catch(() => {});
        return true;
      }
    } catch (e) {
      clearSessionToken();
      ErrorLog.capture(e, { source: 'auth', action: 'auto-login-session' });
    }
  }

  let s = null;
  try {
    s = localStorage.getItem(LEGACY_AUTH_STORAGE_KEY);
  } catch (e) {
    ErrorLog.capture(e, { source: 'auth', action: 'auto-login-legacy-storage' });
    return false;
  }
  if (!s) return false;
  try {
    const parsed = JSON.parse(s);
    if (!parsed || typeof parsed !== 'object') throw new Error('invalid-legacy-session-payload');
    const { username, password } = parsed;
    if (!username || !password) {
      throw new Error('invalid-legacy-session-payload');
    }
    const { user, session_token } = await Api.call('login', { username, password }, { timeoutMs: 3500 });
    applyLoggedInUser(username, user, password, session_token || null);
    saveSessionToken(username, session_token || null, password);
    await loadUserStats();
    checkAnnouncement().catch(() => {});
    return true;
  } catch (e) {
    clearStoredAuth();
    ErrorLog.capture(e, { source: 'auth', action: 'auto-login-legacy' });
    return false;
  }
}

async function loadUserStats(state) {
  if (!App.username) return;
  const payload = {
    username: App.username,
  };
  const response = state || (await Api.call('get-state', payload, { timeoutMs: 3500 }));
  const user = response?.user || {};
  const wordStats = Array.isArray(response?.wordStats) ? response.wordStats : [];

  App.favorites = wordStats.filter((w) => w && w.is_favorite && w.word_ar).map((w) => w.word_ar);
  App.wordStats = {};
  wordStats.forEach((w) => {
    if (!w || typeof w !== 'object') return;
    App.wordStats[w.word_ar] = { seen: w.seen_count || 0, level: w.level || 1, next: w.next_review || null };
  });

  App.streak = user.streak || 0;
  App.maxStreak = user.max_streak || 0;

  const today = appDateKey();
  const storedDate = user.last_count_date ? String(user.last_count_date).split('T')[0] : null;
  if (storedDate === today) {
    App.dailyWords = user.daily_words || 0;
  } else {
    App.dailyWords = 0;
  }
  App.lastCountDate = today;
}

async function doLogout() {
  const username = App.username;
  if (username) {
    try {
      await Api.call('revoke-session', { username });
    } catch {
      // non-fatal: local logout is mandatory anyway
    }
  }
  clearStoredAuth();
  resetApp();
  showScreen('screen-login');
}
