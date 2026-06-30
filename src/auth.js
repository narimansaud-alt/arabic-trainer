// auth.js — login, registration, and local session persistence.
//
// IMPORTANT trust-model note: this app has no Supabase Auth / JWT
// session layer. To keep every write provably tied to the right
// account without one, the client keeps the user's password in
// memory and in localStorage (mirroring exactly what the legacy app
// already did — it stored a sha256 hash there), and the Edge Function
// independently re-verifies the password with bcrypt on every single
// write. A leaked anon key now grants nothing: there is no anon
// table access to users/word_stats/score_history at all (see the RLS
// migration), and the Edge Function never trusts a bare username.

let loginMode = 'login';

function switchLoginTab(t) {
  loginMode = t;
  document.querySelectorAll('.tab-btn').forEach((b, i) => {
    b.classList.toggle('active', (i === 0 && t === 'login') || (i === 1 && t === 'reg'));
  });
  document.getElementById('login-form').classList.toggle('hidden', t !== 'login');
  document.getElementById('reg-form').classList.toggle('hidden', t !== 'reg');
  document.getElementById('login-msg').textContent = '';
}

function setMsg(t, c) {
  const el = document.getElementById('login-msg');
  el.textContent = t;
  el.className = 'login-msg ' + (c || '');
}

async function doLogin() {
  const un = document.getElementById('l-user').value.trim().toLowerCase();
  const pw = document.getElementById('l-pass').value;
  if (!un || un.length < 2) return setMsg('Логин минимум 2 символа', 'err');
  if (!pw || pw.length < 4) return setMsg('Пароль минимум 4 символа', 'err');
  setMsg('Проверяем...');

  try {
    const { user } = await Api.call('login', { username: un, password: pw });
    applyLoggedInUser(un, pw, user);
    localStorage.setItem('arabic_auth', JSON.stringify({ username: un, password: pw }));
    await loadUserStats();
    await checkAnnouncement();
    goToCourse();
  } catch (e) {
    setMsg(e.message || 'Неверный логин или пароль', 'err');
  }
}

async function doRegister() {
  const un = document.getElementById('r-user').value.trim().toLowerCase();
  const pw = document.getElementById('r-pass').value;
  const pw2 = document.getElementById('r-pass2').value;
  if (un.length < 3) return setMsg('Логин минимум 3 символа', 'err');
  if (pw.length < 4) return setMsg('Пароль минимум 4 символа', 'err');
  if (pw !== pw2) return setMsg('Пароли не совпадают', 'err');
  setMsg('Регистрируем...');

  try {
    await Api.call('register', { username: un, password: pw });
    setMsg('Готово! Входим...', 'ok');
    App.username = un;
    App.password = pw;
    localStorage.setItem('arabic_auth', JSON.stringify({ username: un, password: pw }));
    setTimeout(goToCourse, 800);
  } catch (e) {
    setMsg(e.message || 'Ошибка регистрации', 'err');
  }
}

function applyLoggedInUser(username, password, user) {
  App.username = username;
  App.password = password;
  App.totalScore = user.total_score || 0;
  App.survivalRecord = user.survival_record || 0;
  App.streak = user.streak || 0;
  App.maxStreak = user.max_streak || 0;
}

async function tryAutoLogin() {
  const s = localStorage.getItem('arabic_auth');
  if (!s) return false;
  try {
    const { username, password } = JSON.parse(s);
    const { user } = await Api.call('login', { username, password });
    applyLoggedInUser(username, password, user);
    await loadUserStats();
    await checkAnnouncement();
    return true;
  } catch (e) {
    localStorage.removeItem('arabic_auth');
    return false;
  }
}

async function loadUserStats() {
  const { user, wordStats } = await Api.call('get-state', {
    username: App.username,
    password: App.password,
  });

  App.favorites = wordStats.filter((w) => w.is_favorite).map((w) => w.word_ar);
  App.wordStats = {};
  wordStats.forEach((w) => {
    App.wordStats[w.word_ar] = { seen: w.seen_count || 0, level: w.level || 1, next: w.next_review || null };
  });

  App.streak = user.streak || 0;
  App.maxStreak = user.max_streak || 0;

  const today = new Date().toISOString().split('T')[0];
  const storedDate = user.last_count_date ? String(user.last_count_date).split('T')[0] : null;
  if (storedDate === today) {
    App.dailyWords = user.daily_words || 0;
  } else {
    App.dailyWords = 0;
    if (App.username) {
      try {
        await Api.call('update-daily-count', { username: App.username, password: App.password, daily_words: 0 });
      } catch (e) {
        /* non-fatal */
      }
    }
  }
  App.lastCountDate = today;
}

function doLogout() {
  localStorage.removeItem('arabic_auth');
  resetApp();
  showScreen('screen-login');
}
