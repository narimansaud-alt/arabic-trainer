// streak.js вЂ” daily streak banner and the "30 words before midnight" counter.
//
// The actual streak increment is now computed server-side (see the
// Edge Function's 'update-streak' action) from `last_activity`,
// rather than trusting a client-calculated streak number вЂ” this
// closes the "tampered client claims itself extra days" gap that
// existed when `users` was directly writable from the browser.

async function updateStreak(doIncrement) {
  if (!App.username) {
    updateUI();
    return;
  }
  if (!doIncrement) {
    // Local-only check: if the user skipped a day, show 0 until the
    // server recomputes on their next 'update-streak' call.
    updateUI();
    return;
  }
  try {
    const { streak, max_streak } = await Api.call('update-streak', {
      username: App.username,
      password: App.password,
    }, { timeoutMs: 4000 });
    App.streak = streak;
    App.maxStreak = max_streak;
  } catch (e) {
    ErrorLog.capture(e, { source: 'streak', action: 'update-streak' });
  }
  updateUI();
}

let __dailyIncrementQueue = Promise.resolve();

function addDailyWord() {
  const today = appDateKey();
  if (App.lastCountDate !== today) {
    App.dailyWords = 0;
    App.lastCountDate = today;
  }
  if (App.dailyWords >= 30) return __dailyIncrementQueue;
  App.dailyWords = Math.min((Number.isFinite(App.dailyWords) ? App.dailyWords : 0) + 1, 30);
  updateStreakBanner();
  __dailyIncrementQueue = __dailyIncrementQueue
    .then(async () => {
      const result = await Api.call('increment-daily-count', {}, { timeoutMs: 3000 });
      App.dailyWords = Number(result.daily_words) || 0;
      App.lastCountDate = today;
      if (result.reached_goal) await updateStreak(true);
      updateStreakBanner();
    })
    .catch((e) => ErrorLog.capture(e, { source: 'streak', action: 'increment-daily-count' }));
  return __dailyIncrementQueue;
}

let __midnightResetTimerId = 0;

function checkMidnightReset() {
  const today = appDateKey();
  if (App.lastCountDate && App.lastCountDate !== today) {
    App.dailyWords = 0;
    App.lastCountDate = today;
    updateStreakBanner();
  }
  if (__midnightResetTimerId) {
    clearTimeout(__midnightResetTimerId);
  }
  __midnightResetTimerId = setTimeout(() => {
    __midnightResetTimerId = 0;
    checkMidnightReset();
  }, msUntilNextAppMidnight());
}

let __leaderboardScoreCache = {
  ts: 0,
  rows: null,
};
let __leaderboardStreakCache = {
  ts: 0,
  rows: null,
};
const __LEADERBOARD_CACHE_MS = 25000;

async function loadLeaderboardCacheBy(sortBy) {
  const now = Date.now();
  const isStreakSort = sortBy === 'streak';
  const store = isStreakSort ? __leaderboardStreakCache : __leaderboardScoreCache;
  if (store.rows && now - store.ts < __LEADERBOARD_CACHE_MS) {
    return store.rows;
  }

  const queryPromise = db
    .from('leaderboard')
    .select('nickname,total_score,streak')
    .order(sortBy, { ascending: false })
    .limit(200);
  let timeoutId = 0;
  const timeoutPromise = new Promise((_, reject) => {
    timeoutId = setTimeout(() => reject(new Error('leaderboard-timeout')), 3000);
  });
  let rows = [];
  try {
    const result = await Promise.race([queryPromise, timeoutPromise]);
    const data = result?.data;
    const error = result?.error;
    if (error) throw error;
    rows = data && data.length ? data : [];
  } catch (e) {
    ErrorLog.capture(e, { source: 'streak', action: 'leaderboard-cache', sortBy });
    rows = store.rows || [];
  } finally {
    clearTimeout(timeoutId);
  }

  if (isStreakSort) {
    __leaderboardStreakCache = { ts: now, rows };
  } else {
    __leaderboardScoreCache = { ts: now, rows };
  }
  return rows;
}

function updateStreakBanner() {
  const days = App.streak || 0;
  const cnt = App.dailyWords || 0;
  const pct = Math.min((cnt / 30) * 100, 100);
  const bannerDays = document.getElementById('banner-days');
  const bannerCount = document.getElementById('banner-today-count');
  const streakFill = document.getElementById('streak-bar-fill');
  const hintEl = document.getElementById('banner-hint');
  const doneEl = document.getElementById('streak-done');
  const lbl = document.getElementById('banner-days-label');

  if (bannerDays) bannerDays.textContent = days;
  if (lbl) lbl.textContent = getDaysLabel(days);
  if (bannerCount) bannerCount.textContent = cnt + ' / 30 слов';
  if (streakFill) streakFill.style.width = pct + '%';

  if (cnt >= 30) {
  if (hintEl) hintEl.classList.add('hidden');
    if (doneEl) doneEl.classList.remove('hidden');
  } else {
    if (hintEl) hintEl.classList.remove('hidden');
    if (doneEl) doneEl.classList.add('hidden');
  }

  loadStreakRank();
}

async function loadStreakRank() {
  if (!App.username) return;
  const el = document.getElementById('banner-rank');
  try {
    const data = await loadLeaderboardCacheBy('streak');
    if (!el || !data || !data.length) return;
    const rank = data.findIndex((user) => user.nickname === App.username) + 1;
    if (rank > 0) {
      const place = rank === 1 ? '1-е' : rank === 2 ? '2-е' : rank === 3 ? '3-е' : rank + '-е';
      el.textContent = place + ' место в рейтинге серии дней';
    } else {
      el.textContent = '';
    }
  } catch (e) {
    if (el) el.textContent = '';
    ErrorLog.capture(e, { source: 'streak', action: 'load-streak-rank' });
  }
}

async function updateUI() {
  const rankEl = document.getElementById('app-rank');
  if (!rankEl || !App.username) return;
  try {
    const data = await loadLeaderboardCacheBy('total_score');
    if (!data || !data.length) {
      rankEl.textContent = 'Рейтинг: — · ' + (App.totalScore || 0) + ' баллов';
      return;
    }
    const rank = data.findIndex((user) => user.nickname === App.username) + 1;
    const row = data.find((user) => user.nickname === App.username);
    const score = Math.max(App.totalScore || 0, row?.total_score || 0);
    rankEl.textContent = 'Рейтинг: ' + (rank > 0 ? '#' + rank : '—') + ' · ' + score + ' баллов';
  } catch (e) {
    rankEl.textContent = 'Рейтинг: — · ' + (App.totalScore || 0) + ' баллов';
    ErrorLog.capture(e, { source: 'streak', action: 'update-rank-ui' });
  }
}
