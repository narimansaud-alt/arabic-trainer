// streak.js вЂ” daily streak banner and the "30 words before midnight" counter.
//
// The actual streak increment is now computed server-side (see the
// Edge Function's 'update-streak' action) from `last_activity`,
// rather than trusting a client-calculated streak number вЂ” this
// closes the "tampered client claims itself extra days" gap that
// existed when `users` was directly writable from the browser.

async function updateStreak() {
  const restoredDailyProgress = restoreDailyProgressSnapshot();
  if (!App.username) {
    updateUI();
    return;
  }
  try {
    const { streak, max_streak } = await Api.call('update-streak', {
      username: App.username,
      password: App.password,
    }, { timeoutMs: 7000 });
    App.streak = streak;
    App.maxStreak = max_streak;
  } catch (e) {
    ErrorLog.capture(e, { source: 'streak', action: 'update-streak' });
  }
  updateUI();
  if (restoredDailyProgress) {
    updateStreakBanner();
    void syncDailyProgress();
  }
}

let __dailyIncrementQueue = Promise.resolve();
const DAILY_PROGRESS_CACHE_KEY = 'arabic_daily_progress_v1';
const DAILY_STREAK_GOAL = 30;
const DAILY_WORDS_DISPLAY_MAX = 9999;
let __dailyGoalSyncedDate = null;
let __dailyLastSyncedDate = null;
let __dailyLastSyncedWords = 0;

function normalizedDailyWords(value) {
  return Math.max(0, Math.min(DAILY_WORDS_DISPLAY_MAX, Number(value) || 0));
}

function saveDailyProgressSnapshot() {
  try {
    const date = appDateKey();
    const saved = JSON.parse(localStorage.getItem(DAILY_PROGRESS_CACHE_KEY) || 'null');
    const previous = saved && saved.date === date ? normalizedDailyWords(saved.words) : 0;
    localStorage.setItem(DAILY_PROGRESS_CACHE_KEY, JSON.stringify({
      date,
      words: Math.max(previous, normalizedDailyWords(App.dailyWords))
    }));
  } catch (_) {
    // The server remains the source of truth when local storage is unavailable.
  }
}

function restoreDailyProgressSnapshot() {
  try {
    const saved = JSON.parse(localStorage.getItem(DAILY_PROGRESS_CACHE_KEY) || 'null');
    if (!saved || saved.date !== appDateKey()) return false;
    const words = normalizedDailyWords(saved.words);
    if (words <= App.dailyWords) return false;
    App.dailyWords = words;
    App.lastCountDate = saved.date;
    return true;
  } catch (_) {
    return false;
  }
}

function syncDailyProgress() {
  const target = normalizedDailyWords(App.dailyWords);
  const today = appDateKey();
  if (!App.username || target <= 0) return __dailyIncrementQueue;
  if (__dailyLastSyncedDate !== today) {
    __dailyLastSyncedDate = today;
    __dailyLastSyncedWords = 0;
  }
  if (target <= __dailyLastSyncedWords) return __dailyIncrementQueue;
  __dailyIncrementQueue = __dailyIncrementQueue
    .then(async () => {
      const result = await Api.call('update-daily-count', { daily_words: target }, { timeoutMs: 7000, keepalive: true });
      const savedWords = normalizedDailyWords(result?.daily_words ?? target);
      __dailyLastSyncedWords = Math.max(__dailyLastSyncedWords, savedWords);
      if (savedWords >= DAILY_STREAK_GOAL && __dailyGoalSyncedDate !== today) {
        __dailyGoalSyncedDate = today;
        await updateStreak();
      }
    })
    .catch((e) => ErrorLog.capture(e, { source: 'streak', action: 'sync-daily-count', target, today }));
  return __dailyIncrementQueue;
}

window.flushDailyProgressBeforeUpdate = async function flushDailyProgressBeforeUpdate() {
  saveDailyProgressSnapshot();
  if (!App.username || !App.dailyWords) return;
  await syncDailyProgress();
};

function addDailyWord() {
  const today = appDateKey();
  if (App.lastCountDate !== today) {
    App.dailyWords = 0;
    App.lastCountDate = today;
  }
  if (App.dailyWords >= DAILY_WORDS_DISPLAY_MAX) return __dailyIncrementQueue;
  App.dailyWords = normalizedDailyWords((Number.isFinite(App.dailyWords) ? App.dailyWords : 0) + 1);
  saveDailyProgressSnapshot();
  updateStreakBanner();
  return syncDailyProgress();
}

let __midnightResetTimerId = 0;

function checkMidnightReset() {
  const today = appDateKey();
  if (App.lastCountDate && App.lastCountDate !== today) {
    App.dailyWords = 0;
    App.lastCountDate = today;
    saveDailyProgressSnapshot();
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
    timeoutId = setTimeout(() => reject(new Error('leaderboard-timeout')), 7000);
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
  if (bannerCount) bannerCount.textContent = cnt >= DAILY_STREAK_GOAL ? cnt + ' слов сегодня' : cnt + ' / ' + DAILY_STREAK_GOAL + ' слов';
  if (streakFill) streakFill.style.width = pct + '%';

  if (cnt >= DAILY_STREAK_GOAL) {
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
  rankEl.innerHTML = '<span class="ui-icon"><svg><use href="#ui-icon-trophy"></use></svg></span><span>Рейтинг</span>';
  return;
  try {
    const data = await loadLeaderboardCacheBy('total_score');
    if (!data || !data.length) {
      rankEl.textContent = 'Рейтинг: — · ' + (App.totalScore || 0) + ' баллов';
      return;
    }
    const rank = data.findIndex((user) => user.nickname === App.username) + 1;
    const row = data.find((user) => user.nickname === App.username);
    const score = Math.max(App.totalScore || 0, row?.total_score || 0);
    const place = rank > 0 ? (rank === 1 ? '1-е' : rank === 2 ? '2-е' : rank === 3 ? '3-е' : rank + '-е') + ' место' : '—';
    rankEl.textContent = 'Рейтинг: ' + place + ' · ' + score + ' баллов';
  } catch (e) {
    rankEl.textContent = 'Рейтинг: — · ' + (App.totalScore || 0) + ' баллов';
    ErrorLog.capture(e, { source: 'streak', action: 'update-rank-ui' });
  }
}
