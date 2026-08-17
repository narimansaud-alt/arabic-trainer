// daily.js — daily learning goal, first-login choice, automatic exercise mix,
// local/offline progress, and server synchronization.

const DAILY_GOAL_MINUTE_OPTIONS = [5, 10, 20, 25, 30];
const DAILY_GOAL_CACHE_KEY = 'arabic_daily_goal_v2';
const DAILY_GOAL_PLAN_VERSION = 2;

const DailyGoalState = {
  row: null,
  plan: null,
  pendingChoice: null,
  syncing: Promise.resolve(),
  replay: false,
};

function dailyGoalTargets(minutes) {
  const safeMinutes = DAILY_GOAL_MINUTE_OPTIONS.includes(Number(minutes)) ? Number(minutes) : 10;
  const target = safeMinutes * 2;
  const fresh = Math.round(target * 0.2);
  const review = Math.round(target * 0.5);
  return {
    goal_minutes: safeMinutes,
    target_tasks: target,
    new_target: fresh,
    review_target: review,
    typing_target: target - fresh - review,
  };
}

function normalizeDailyGoalRow(row) {
  if (!row || typeof row !== 'object') return null;
  const targets = dailyGoalTargets(row.goal_minutes || App.dailyGoalMinutes);
  const normalized = {
    username: String(row.username || App.username || ''),
    goal_date: String(row.goal_date || appDateKey()).split('T')[0],
    course_name: String(row.course_name || App.volume || ''),
    goal_minutes: targets.goal_minutes,
    target_tasks: Math.max(1, Number(row.target_tasks) || targets.target_tasks),
    new_target: Math.max(0, Number(row.new_target) || targets.new_target),
    review_target: Math.max(0, Number(row.review_target) || targets.review_target),
    typing_target: Math.max(0, Number(row.typing_target) || targets.typing_target),
    new_completed: Math.max(0, Number(row.new_completed) || 0),
    review_completed: Math.max(0, Number(row.review_completed) || 0),
    typing_completed: Math.max(0, Number(row.typing_completed) || 0),
    completed_at: row.completed_at || null,
  };
  const targetSum = normalized.new_target + normalized.review_target + normalized.typing_target;
  if (targetSum !== normalized.target_tasks) normalized.target_tasks = targetSum;
  normalized.new_completed = Math.min(normalized.new_completed, normalized.new_target);
  normalized.review_completed = Math.min(normalized.review_completed, normalized.review_target);
  normalized.typing_completed = Math.min(normalized.typing_completed, normalized.typing_target);
  return normalized;
}

function dailyGoalDoneCount(row = DailyGoalState.row) {
  if (!row) return 0;
  return Number(row.new_completed || 0) + Number(row.review_completed || 0) + Number(row.typing_completed || 0);
}

function dailyGoalIsComplete(row = DailyGoalState.row) {
  return Boolean(row && (row.completed_at || dailyGoalDoneCount(row) >= Number(row.target_tasks || 0)));
}

function mergeDailyGoalRows(serverRow, cachedRow) {
  const server = normalizeDailyGoalRow(serverRow);
  const cached = normalizeDailyGoalRow(cachedRow);
  if (!server) return cached;
  if (!cached) return server;
  const samePlan =
    server.goal_date === cached.goal_date &&
    server.course_name === cached.course_name &&
    server.goal_minutes === cached.goal_minutes &&
    server.target_tasks === cached.target_tasks &&
    server.new_target === cached.new_target &&
    server.review_target === cached.review_target &&
    server.typing_target === cached.typing_target;
  if (!samePlan) return server;
  return normalizeDailyGoalRow({
    ...server,
    new_completed: Math.max(server.new_completed, cached.new_completed),
    review_completed: Math.max(server.review_completed, cached.review_completed),
    typing_completed: Math.max(server.typing_completed, cached.typing_completed),
    completed_at: server.completed_at || cached.completed_at || null,
  });
}

function readDailyGoalCache() {
  try {
    const cached = JSON.parse(localStorage.getItem(DAILY_GOAL_CACHE_KEY) || 'null');
    if (!cached || cached.username !== App.username || cached.date !== appDateKey()) return null;
    return cached;
  } catch (error) {
    ErrorLog.capture(error, { source: 'daily-goal', action: 'read-cache' });
    return null;
  }
}

function writeDailyGoalCache() {
  try {
    localStorage.setItem(
      DAILY_GOAL_CACHE_KEY,
      JSON.stringify({
        version: DAILY_GOAL_PLAN_VERSION,
        username: App.username,
        date: appDateKey(),
        row: DailyGoalState.row,
        plan: DailyGoalState.plan,
      })
    );
  } catch (error) {
    ErrorLog.capture(error, { source: 'daily-goal', action: 'write-cache' });
  }
}

function updateDailyGoalSettingsUI() {
  document.querySelectorAll('#daily-goal-settings .daily-goal-option').forEach((button) => {
    button.classList.toggle('active', Number(button.dataset.minutes) === Number(App.dailyGoalMinutes));
  });
  const note = document.getElementById('daily-goal-settings-note');
  if (note) note.textContent = `Текущая цель: ${App.dailyGoalMinutes || 10} минут в день.`;
}

function renderDailyGoal() {
  const row = DailyGoalState.row;
  updateDailyGoalSettingsUI();
  if (!row) return;

  const done = dailyGoalDoneCount(row);
  const total = Math.max(1, Number(row.target_tasks || 1));
  const pct = Math.min(100, Math.round((done / total) * 100));
  const complete = dailyGoalIsComplete(row);
  const setText = (id, value) => {
    const element = document.getElementById(id);
    if (element) element.textContent = value;
  };

  setText('banner-days', App.streak || 0);
  setText('banner-days-label', getDaysLabel(App.streak || 0));
  setText('banner-today-count', `${done} / ${total} заданий`);
  setText('daily-progress-start', `${done} заданий`);
  setText('daily-progress-goal', `Цель: ${total} заданий`);
  setText('banner-hint', complete ? 'Дневная цель выполнена. Можно повторить задания ещё раз.' : `План примерно на ${row.goal_minutes} минут — приложение само подобрало виды заданий.`);
  setText('daily-new-progress', `${row.new_completed} / ${row.new_target}`);
  setText('daily-review-progress', `${row.review_completed} / ${row.review_target}`);
  setText('daily-typing-progress', `${row.typing_completed} / ${row.typing_target}`);

  const fill = document.getElementById('streak-bar-fill');
  if (fill) fill.style.width = pct + '%';
  const doneBox = document.getElementById('streak-done');
  if (doneBox) doneBox.classList.toggle('hidden', !complete);
  const hint = document.getElementById('banner-hint');
  if (hint) hint.classList.remove('hidden');
  const button = document.getElementById('btn-daily-goal');
  if (button) {
    button.disabled = false;
    button.textContent = complete ? 'Повторить задания дня' : done > 0 ? 'Продолжить задание дня' : 'Начать задание дня';
  }

  if (typeof loadStreakRank === 'function') void loadStreakRank();
}

function buildOfflineDailyGoalRow() {
  const targets = dailyGoalTargets(App.dailyGoalMinutes);
  return normalizeDailyGoalRow({
    ...targets,
    username: App.username,
    goal_date: appDateKey(),
    course_name: App.volume,
  });
}

async function loadDailyGoal() {
  if (!App.username || !App.volume) return null;
  const cached = readDailyGoalCache();
  const cachedRow = cached?.row && cached.row.course_name === App.volume ? normalizeDailyGoalRow(cached.row) : null;
  if (cached?.row && cached.row.course_name === App.volume) {
    DailyGoalState.row = normalizeDailyGoalRow(cached.row);
    DailyGoalState.plan = cached.plan || null;
    renderDailyGoal();
  }

  try {
    const response = await Api.call('get-daily-goal', { course_name: App.volume }, { timeoutMs: 7000 });
    const serverRow = normalizeDailyGoalRow(response?.goal);
    DailyGoalState.row = mergeDailyGoalRows(serverRow, cachedRow) || DailyGoalState.row || buildOfflineDailyGoalRow();
    const hasUnsyncedProgress = serverRow && dailyGoalDoneCount(DailyGoalState.row) > dailyGoalDoneCount(serverRow);
    App.dailyGoalMinutes = Number(response?.daily_goal_minutes || DailyGoalState.row.goal_minutes || App.dailyGoalMinutes || 10);
    App.dailyGoalSelected = Boolean(response?.daily_goal_selected_at || App.dailyGoalSelected);
    if (response?.daily_goals_completed != null) App.dailyGoalsCompleted = Number(response.daily_goals_completed) || 0;
    if (hasUnsyncedProgress) void syncDailyGoalProgress();
  } catch (error) {
    if (!DailyGoalState.row) DailyGoalState.row = buildOfflineDailyGoalRow();
    ErrorLog.capture(error, { source: 'daily-goal', action: 'load', course: App.volume });
  }
  writeDailyGoalCache();
  renderDailyGoal();
  return DailyGoalState.row;
}

function chooseInitialDailyGoal(minutes, button) {
  if (!DAILY_GOAL_MINUTE_OPTIONS.includes(Number(minutes))) return;
  DailyGoalState.pendingChoice = Number(minutes);
  document.querySelectorAll('#daily-goal-choice-options .daily-goal-option').forEach((item) => item.classList.remove('active'));
  if (button) button.classList.add('active');
  const confirmButton = document.getElementById('daily-goal-choice-confirm');
  if (confirmButton) confirmButton.disabled = false;
}

function maybePromptDailyGoalChoice() {
  if (!App.username || App.dailyGoalSelected) return false;
  DailyGoalState.pendingChoice = null;
  const overlay = document.getElementById('daily-goal-choice-overlay');
  if (!overlay) return false;
  overlay.classList.remove('hidden');
  overlay.setAttribute('aria-hidden', 'false');
  document.querySelectorAll('#daily-goal-choice-options .daily-goal-option').forEach((item) => item.classList.remove('active'));
  const confirmButton = document.getElementById('daily-goal-choice-confirm');
  if (confirmButton) confirmButton.disabled = true;
  return true;
}

async function confirmInitialDailyGoal() {
  const minutes = DailyGoalState.pendingChoice;
  if (!DAILY_GOAL_MINUTE_OPTIONS.includes(minutes)) return;
  const confirmButton = document.getElementById('daily-goal-choice-confirm');
  const status = document.getElementById('daily-goal-choice-status');
  if (confirmButton) confirmButton.disabled = true;
  if (status) status.textContent = 'Сохраняем цель…';
  try {
    const response = await Api.call('set-daily-goal-minutes', { minutes }, { timeoutMs: 7000 });
    App.dailyGoalMinutes = Number(response?.daily_goal_minutes || minutes);
    App.dailyGoalSelected = true;
    const overlay = document.getElementById('daily-goal-choice-overlay');
    if (overlay) {
      overlay.classList.add('hidden');
      overlay.setAttribute('aria-hidden', 'true');
    }
    if (status) status.textContent = '';
    updateDailyGoalSettingsUI();
    showVolumeScreen('Мединский курс', 'med');
  } catch (error) {
    if (status) status.textContent = 'Не удалось сохранить. Проверьте интернет и попробуйте ещё раз.';
    if (confirmButton) confirmButton.disabled = false;
    ErrorLog.capture(error, { source: 'daily-goal', action: 'first-choice', minutes });
  }
}

async function setDailyGoalMinutes(minutes, button) {
  const value = Number(minutes);
  if (!DAILY_GOAL_MINUTE_OPTIONS.includes(value)) return;
  const oldValue = App.dailyGoalMinutes;
  App.dailyGoalMinutes = value;
  updateDailyGoalSettingsUI();
  const note = document.getElementById('daily-goal-settings-note');
  if (note) note.textContent = 'Сохраняем…';
  try {
    const response = await Api.call('set-daily-goal-minutes', { minutes: value }, { timeoutMs: 7000 });
    App.dailyGoalSelected = true;
    App.dailyGoalMinutes = Number(response?.daily_goal_minutes || value);
    if (response?.goal) {
      DailyGoalState.row = normalizeDailyGoalRow(response.goal);
      DailyGoalState.plan = null;
      writeDailyGoalCache();
      renderDailyGoal();
    }
    if (note) note.textContent = response?.applies_today ? `Цель на сегодня изменена: ${value} минут.` : `Новая цель ${value} минут начнёт действовать со следующего дня.`;
  } catch (error) {
    App.dailyGoalMinutes = oldValue;
    updateDailyGoalSettingsUI();
    if (note) note.textContent = 'Не удалось сохранить цель. Проверьте интернет.';
    ErrorLog.capture(error, { source: 'daily-goal', action: 'settings-choice', minutes: value });
  }
}

function dailyReviewPool(words) {
  const now = new Date().toISOString();
  return [...words].sort((a, b) => {
    const aStat = App.wordStats[a.ar];
    const bStat = App.wordStats[b.ar];
    const score = (word, stat) => {
      if (App.favorites.includes(word.ar)) return 0;
      if (stat && (!stat.next || stat.next <= now)) return 1;
      if (stat && (stat.level || 1) <= 2) return 2;
      if (stat) return 3;
      return 4;
    };
    return score(a, aStat) - score(b, bStat);
  });
}

function cycleWord(pool, index, fallback) {
  const source = pool.length ? pool : fallback;
  return source[index % source.length];
}

function buildDailyGoalPlan(row) {
  const unique = [];
  const seen = new Set();
  Dict.allWords.forEach((word) => {
    if (!word?.ar || !word?.ru || seen.has(word.ar)) return;
    seen.add(word.ar);
    unique.push({ ar: word.ar, ru: word.ru });
  });
  if (!unique.length) return null;

  const freshPool = unique.filter((word) => !App.wordStats[word.ar] || !App.wordStats[word.ar].seen);
  const reviewPool = dailyReviewPool(unique.filter((word) => App.wordStats[word.ar]));
  const fallbackPool = dailyReviewPool(unique);
  const tasks = [];

  for (let index = 0; index < row.new_target; index++) {
    const word = cycleWord(freshPool, Math.floor(index / 2), fallbackPool);
    const isFresh = freshPool.length > 0;
    const mode = isFresh && index % 2 === 0 ? 'intro' : index % 4 < 2 ? 'ar-ru' : 'ru-ar';
    tasks.push({ id: `new-${index}`, category: 'new', ordinal: index + 1, mode, word, done: false });
  }
  for (let index = 0; index < row.review_target; index++) {
    const word = cycleWord(reviewPool, index, fallbackPool);
    tasks.push({ id: `review-${index}`, category: 'review', ordinal: index + 1, mode: index % 2 === 0 ? 'ar-ru' : 'ru-ar', word, done: false });
  }
  const typingPool = [...reviewPool, ...freshPool].filter((word, index, arr) => arr.findIndex((item) => item.ar === word.ar) === index);
  for (let index = 0; index < row.typing_target; index++) {
    const word = cycleWord(typingPool, index, fallbackPool);
    tasks.push({ id: `typing-${index}`, category: 'typing', ordinal: index + 1, mode: 'type-ar', word, done: false });
  }

  return {
    version: DAILY_GOAL_PLAN_VERSION,
    username: App.username,
    date: row.goal_date,
    course: row.course_name,
    goalMinutes: row.goal_minutes,
    tasks,
  };
}

function dailyPlanMatches(plan, row) {
  return Boolean(
    plan &&
      plan.version === DAILY_GOAL_PLAN_VERSION &&
      plan.username === App.username &&
      plan.date === row.goal_date &&
      plan.course === row.course_name &&
      Array.isArray(plan.tasks) &&
      plan.tasks.length === row.target_tasks
  );
}

function applyDailyServerProgress(plan, row) {
  const completed = {
    new: row.new_completed,
    review: row.review_completed,
    typing: row.typing_completed,
  };
  plan.tasks.forEach((task) => {
    task.done = Number(task.ordinal || 0) <= Number(completed[task.category] || 0);
  });
}

async function startDailyGoal() {
  if (!App.volume) return alert('Сначала выберите том.');
  if (!Dict.allWords.length) {
    try {
      await loadDict();
    } catch (error) {
      ErrorLog.capture(error, { source: 'daily-goal', action: 'load-dictionary' });
    }
  }
  if (!Dict.allWords.length) return alert('Слова для задания пока недоступны.');
  const row = (await loadDailyGoal()) || buildOfflineDailyGoalRow();
  if (!dailyPlanMatches(DailyGoalState.plan, row)) DailyGoalState.plan = buildDailyGoalPlan(row);
  if (!DailyGoalState.plan) return alert('Не удалось составить задание дня.');

  const replay = dailyGoalIsComplete(row);
  DailyGoalState.replay = replay;
  if (replay) {
    DailyGoalState.plan.tasks.forEach((task) => (task.done = false));
  } else {
    applyDailyServerProgress(DailyGoalState.plan, row);
  }
  const pending = DailyGoalState.plan.tasks.filter((task) => !task.done);
  if (!pending.length) return alert('Задание дня уже выполнено. Нажмите ещё раз для повторения.');
  writeDailyGoalCache();
  initQuiz(
    pending.map((task) => ({ ...task.word })),
    'daily',
    false,
    { dailyTasks: pending, dailyReplay: replay }
  );
}

function markDailyGoalTaskCompleted(task, replay = false) {
  if (!task || task.__counted) return;
  task.__counted = true;
  if (replay || DailyGoalState.replay) return;
  const row = DailyGoalState.row;
  if (!row || !['new', 'review', 'typing'].includes(task.category)) return;
  task.done = true;
  const field = `${task.category}_completed`;
  const targetField = `${task.category}_target`;
  row[field] = Math.min(Number(row[targetField] || 0), Number(row[field] || 0) + 1);
  writeDailyGoalCache();
  renderDailyGoal();
  void syncDailyGoalProgress();
}

function syncDailyGoalProgress() {
  const row = DailyGoalState.row;
  if (!row || !App.username || !App.volume) return DailyGoalState.syncing;
  const payload = {
    course_name: row.course_name,
    new_completed: row.new_completed,
    review_completed: row.review_completed,
    typing_completed: row.typing_completed,
  };
  DailyGoalState.syncing = DailyGoalState.syncing
    .then(async () => {
      const response = await Api.call('sync-daily-goal-progress', payload, { timeoutMs: 7000, keepalive: true });
      if (response?.goal) DailyGoalState.row = normalizeDailyGoalRow(response.goal);
      if (response?.streak != null) App.streak = Number(response.streak) || 0;
      if (response?.max_streak != null) App.maxStreak = Number(response.max_streak) || 0;
      if (response?.daily_goals_completed != null) App.dailyGoalsCompleted = Number(response.daily_goals_completed) || 0;
      writeDailyGoalCache();
      renderDailyGoal();
      updateUI();
      return response;
    })
    .catch((error) => {
      ErrorLog.capture(error, { source: 'daily-goal', action: 'sync-progress', ...payload });
      return null;
    });
  return DailyGoalState.syncing;
}

async function flushDailyGoalProgress() {
  if (!DailyGoalState.replay) await syncDailyGoalProgress();
  await DailyGoalState.syncing;
}

function dailyTaskLabel(task) {
  if (!task) return 'Задание дня';
  if (task.category === 'new') return 'Задание дня · новые слова';
  if (task.category === 'typing') return 'Задание дня · арабский ввод';
  return 'Задание дня · повторение';
}

function resetDailyGoalState() {
  DailyGoalState.row = null;
  DailyGoalState.plan = null;
  DailyGoalState.pendingChoice = null;
  DailyGoalState.replay = false;
}

if (typeof window !== 'undefined') {
  window.addEventListener('online', () => {
    if (DailyGoalState.row && !DailyGoalState.replay) void syncDailyGoalProgress();
  });
}
