// streak.js вЂ” daily streak banner and the "30 words before midnight" counter.
//
// The actual streak increment is now computed server-side (see the
// Edge Function's 'update-streak' action) from `last_activity`,
// rather than trusting a client-calculated streak number вЂ” this
// closes the "tampered client claims itself extra days" gap that
// existed when `users` was directly writable from the browser.

async function updateStreak() {
  const restoredDailyProgress = restoreDailyProgressSnapshot();
  if (restoredDailyProgress) void syncDailyProgress();
  if (App.username && App.volume && typeof loadDailyGoal === 'function') {
    await loadDailyGoal();
  }
  updateUI();
  updateStreakBanner();
}

let __dailyIncrementQueue = Promise.resolve();
const DAILY_PROGRESS_CACHE_KEY = 'arabic_daily_progress_v1';
const DAILY_WORDS_DISPLAY_MAX = 9999;
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
    })
    .catch((e) => ErrorLog.capture(e, { source: 'streak', action: 'sync-daily-count', target, today }));
  return __dailyIncrementQueue;
}

window.flushDailyProgressBeforeUpdate = async function flushDailyProgressBeforeUpdate() {
  saveDailyProgressSnapshot();
  if (App.username && App.dailyWords) await syncDailyProgress();
  if (typeof flushDailyGoalProgress === 'function') await flushDailyGoalProgress();
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
  const dailyGoalDate = typeof DailyGoalState !== 'undefined' ? DailyGoalState.row?.goal_date || null : null;
  if (dailyGoalDate && dailyGoalDate !== today && typeof resetDailyGoalForNewDay === 'function') {
    void resetDailyGoalForNewDay(today);
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
const __leaderboardInflight = {
  score: null,
  streak: null,
};
const __LEADERBOARD_CACHE_MS = 25000;

async function loadLeaderboardCacheBy(sortBy) {
  const now = Date.now();
  const isDailyGoalSort = sortBy === 'daily_goals_completed';
  const store = isDailyGoalSort ? __leaderboardStreakCache : __leaderboardScoreCache;
  if (store.rows && now - store.ts < __LEADERBOARD_CACHE_MS) {
    return store.rows;
  }

  const inflightKey = isDailyGoalSort ? 'streak' : 'score';
  if (__leaderboardInflight[inflightKey]) return __leaderboardInflight[inflightKey];

  const request = (async () => {
    const type = isDailyGoalSort ? 'daily' : 'score';
    const queryPromise = db.rpc('get_public_leaderboard', {
      p_type: type,
      p_period: 'all',
      p_username: App.username || null,
      p_limit: 100,
    });
    let timeoutId = 0;
    const timeoutPromise = new Promise((_, reject) => {
      timeoutId = setTimeout(() => reject(new Error('leaderboard-timeout')), 10000);
    });
    let rows = [];
    try {
      const result = await Promise.race([queryPromise, timeoutPromise]);
      const data = result?.data;
      const error = result?.error;
      if (error) throw error;
      rows = (data || []).map((row) => {
        const score = Number(row.score_value) || 0;
        return {
          nickname: row.nickname,
          rank: Number(row.position) || 0,
          is_current: Boolean(row.is_current),
          total_score: isDailyGoalSort ? 0 : score,
          daily_goals_completed: isDailyGoalSort ? score : 0,
          streak: Number(row.streak) || 0,
          daily_goal_minutes: Number(row.daily_goal_minutes) || 10,
        };
      });
    } catch (e) {
      ErrorLog.capture(e, { source: 'streak', action: 'leaderboard-cache', sortBy });
      rows = store.rows || [];
    } finally {
      clearTimeout(timeoutId);
    }

    if (isDailyGoalSort) {
      __leaderboardStreakCache = { ts: Date.now(), rows };
    } else {
      __leaderboardScoreCache = { ts: Date.now(), rows };
    }
    return rows;
  })();

  __leaderboardInflight[inflightKey] = request;
  try {
    return await request;
  } finally {
    __leaderboardInflight[inflightKey] = null;
  }
}

function updateStreakBanner() {
  if (typeof DailyGoalState !== 'undefined' && DailyGoalState.row && typeof renderDailyGoal === 'function') {
    renderDailyGoal();
    return;
  }
  const days = App.streak || 0;
  const total = (Number(App.dailyGoalMinutes) || 10) * 2;
  const bannerDays = document.getElementById('banner-days');
  const bannerCount = document.getElementById('banner-today-count');
  const streakFill = document.getElementById('streak-bar-fill');
  const hintEl = document.getElementById('banner-hint');
  const doneEl = document.getElementById('streak-done');
  const lbl = document.getElementById('banner-days-label');
  const progressStart = document.getElementById('daily-progress-start');
  const progressGoal = document.getElementById('daily-progress-goal');
  const targets = typeof dailyGoalTargets === 'function' ? dailyGoalTargets(App.dailyGoalMinutes) : null;
  if (bannerDays) bannerDays.textContent = days;
  if (lbl) lbl.textContent = getDaysLabel(days);
  if (bannerCount) bannerCount.textContent = '0 / ' + total + ' заданий';
  if (progressStart) progressStart.textContent = '0 заданий';
  if (progressGoal) progressGoal.textContent = 'Цель: ' + total + ' заданий';
  if (targets) {
    const newEl = document.getElementById('daily-new-progress');
    const reviewEl = document.getElementById('daily-review-progress');
    const typingEl = document.getElementById('daily-typing-progress');
    if (newEl) newEl.textContent = '0 / ' + targets.new_target;
    if (reviewEl) reviewEl.textContent = '0 / ' + targets.review_target;
    if (typingEl) typingEl.textContent = '0 / ' + targets.typing_target;
  }
  if (streakFill) streakFill.style.width = '0%';
  if (hintEl) {
    hintEl.classList.remove('hidden');
    hintEl.textContent = 'Задание дня загрузится после выбора тома.';
  }
  if (doneEl) doneEl.classList.add('hidden');
  loadStreakRank();
}

async function loadStreakRank() {
  if (!App.username) return;
  const el = document.getElementById('banner-rank');
  try {
    const data = await loadLeaderboardCacheBy('daily_goals_completed');
    if (!el || !data || !data.length) return;
    const usernameKey = String(App.username).trim().toLocaleLowerCase();
    const row = data.find((user) =>
      user.is_current || String(user.nickname || '').trim().toLocaleLowerCase() === usernameKey
    );
    const rank = Number(row?.rank) || 0;
    if (rank > 0) {
      const place = rank === 1 ? '1-е' : rank === 2 ? '2-е' : rank === 3 ? '3-е' : rank + '-е';
      el.textContent = place + ' \u043c\u0435\u0441\u0442\u043e \u0432 \u0440\u0435\u0439\u0442\u0438\u043d\u0433\u0435 \u0437\u0430\u0434\u0430\u043d\u0438\u0439 \u0434\u043d\u044f';
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
