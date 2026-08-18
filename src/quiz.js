// quiz.js — quiz engine for type-ar / review / mix / fast modes, plus
// shared state and helpers used by both this file and learn.js
// (the Memrise-style 'learn' mode lives in its own module since its
// state machine is substantially different).

// Shared mutable quiz state (used by quiz.js and learn.js together)
let queue = [],
  qi = 0,
  curWord = null,
  activeMode = 'ar-ru';
let quizMode = 'review',
  sessionOnlyFavorites = false,
  sessionInitialWords = [],
  dailyQuizTasks = [],
  currentDailyTask = null,
  dailyQuizReplay = false;
let roundScore = 0,
  roundWords = [],
  roundWrong = [],
  roundAttemptedWords = [],
  roundUserAnswers = {},
  roundCorrect = 0,
  roundAttempts = 0;
let sessionIntervalRaised = new Set();
let hstack = [],
  hidx = -1,
  isHist = false;
let sessionFailedWords = new Set();
let sessionDailyCounted = new Set();
let lastSession = null;
let timerInt = null,
  pauseTmo = null,
  timeLeft = 7,
  lives = 3,
  fastWords = 0,
  bestStreak = 0;
let hintCount = 0;
let learnPhase = 'intro'; // legacy flag kept for hstack/saveProgress compatibility

function quizGetEl(id, required = false) {
  if (!quizGetEl._noop) {
    const noopClass = {
      add() {},
      remove() {},
      toggle() {},
      contains() {
        return false;
      },
    };
    quizGetEl._noop = {
      textContent: '',
      innerHTML: '',
      className: '',
      value: '',
      disabled: false,
      style: {},
      classList: noopClass,
      addEventListener() {},
      removeEventListener() {},
      focus() {},
      remove() {},
      appendChild() {},
    };
  }
  const el = document.getElementById(id);
  if (el) return el;
  return required ? null : quizGetEl._noop;
}

function registerQuizAttempt(word, answer = '') {
  roundAttempts++;
  if (word?.ar && !roundAttemptedWords.some((item) => item.ar === word.ar)) {
    roundAttemptedWords.push({ ar: word.ar, ru: word.ru });
  }
  if (word?.ar && answer) roundUserAnswers[word.ar] = String(answer);
  ErrorLog.invariant(roundAttempts >= roundCorrect, 'quiz-correct-count-exceeds-attempts', {
    source: 'quiz-state',
    mode: quizMode,
    attempts: roundAttempts,
    correct: roundCorrect,
  });
}

function countCompletedWordOnce(ar) {
  if (!ar || sessionDailyCounted.has(ar)) return;
  sessionDailyCounted.add(ar);
  addDailyWord();
}
// SPACED REPETITION
function getDue() {
  const now = new Date().toISOString();
  return Dict.allWords.filter((w) => {
    const s = App.wordStats[w.ar];
    return !s || !s.next || s.next <= now;
  });
}
function getNextReview(level, ok) {
  const days = ok ? [1, 3, 7, 14, 30][Math.min(level - 1, 4)] : 0.5;
  const d = new Date();
  d.setTime(d.getTime() + days * 86400000);
  return d.toISOString();
}
async function updateWordLevel(ar, ok) {
  if (!ok) setWordFavoriteLocal(ar, true);
  const s = App.wordStats[ar] || {};
  const cur = s.level || 1;
  const alreadyChanged = sessionIntervalRaised.has(ar);
  let nl = cur;
  let nr = s.next || null;
  if (ok) {
    if (!alreadyChanged && !sessionFailedWords.has(ar)) {
      nl = Math.min(cur + 1, 5);
      nr = getNextReview(nl, true);
      sessionIntervalRaised.add(ar);
    } else if (!nr) {
      nr = getNextReview(cur, true);
    }
  } else {
    sessionFailedWords.add(ar);
    if (!alreadyChanged) {
      nl = Math.max(cur - 1, 1);
      sessionIntervalRaised.add(ar);
    }
    nr = getNextReview(nl, false);
  }
  App.wordStats[ar] = { ...s, level: nl, next: nr, seen: (s.seen || 0) + 1 };
  try {
    await Api.call('update-word-stat', {
      username: App.username,
      password: App.password,
      word_ar: ar,
      seen_count: (s.seen || 0) + 1,
      level: nl,
      next_review: nr,
      is_favorite: App.favorites.includes(ar),
    });
  } catch (e) {
    ErrorLog.capture(e, { source: 'quiz', action: 'update-word-level', word: ar });
  }
}

// SMART WORD SELECTION — no repeats, prioritize: new → weak → due → others
function getSmartQueue(words, limit) {
  const now = new Date().toISOString();
  const newWords = words.filter((w) => !App.wordStats[w.ar]);
  const weakWords = words.filter(
    (w) => App.wordStats[w.ar] && (App.wordStats[w.ar].level || 1) <= 2 && (!App.wordStats[w.ar].next || App.wordStats[w.ar].next <= now)
  );
  const dueWords = words.filter(
    (w) => App.wordStats[w.ar] && (App.wordStats[w.ar].level || 1) > 2 && (!App.wordStats[w.ar].next || App.wordStats[w.ar].next <= now)
  );
  const otherWords = words.filter((w) => App.wordStats[w.ar] && App.wordStats[w.ar].next && App.wordStats[w.ar].next > now);
  otherWords.sort((a, b) => (App.wordStats[a.ar]?.next || '').localeCompare(App.wordStats[b.ar]?.next || ''));
  let pool = [...shuf(newWords), ...shuf(weakWords), ...shuf(dueWords), ...otherWords];
  const seen = new Set();
  pool = pool.filter((w) => {
    if (seen.has(w.ar)) return false;
    seen.add(w.ar);
    return true;
  });
  if (limit !== 'all' && limit !== 'inf') pool = pool.slice(0, parseInt(limit));
  return pool;
}

function resetQuizState() {
  clearTimers();
  queue = [];
  qi = 0;
  curWord = null;
  roundScore = 0;
  roundWords = [];
  roundWrong = [];
  roundAttemptedWords = [];
  roundUserAnswers = {};
  roundCorrect = 0;
  roundAttempts = 0;
  sessionIntervalRaised = new Set();
  sessionFailedWords = new Set();
  sessionDailyCounted = new Set();
  quizMode = Settings.mode;
  sessionOnlyFavorites = false;
  sessionInitialWords = [];
  dailyQuizTasks = [];
  currentDailyTask = null;
  dailyQuizReplay = false;
  lastSession = null;
  if (typeof learnCards !== 'undefined') learnCards = [];
  if (typeof learnDoneWords !== 'undefined') learnDoneWords = [];
  if (typeof learnCardIdx !== 'undefined') learnCardIdx = 0;
  clearProgress();
}

function stopDailyQuizForNewDay() {
  const activeScreen = document.querySelector?.('.screen.active')?.id || '';
  if (quizMode !== 'daily' || activeScreen !== 'screen-quiz') return false;
  resetQuizState();
  showScreen('screen-app');
  if (typeof switchTab === 'function') switchTab('train');
  alert('Начался новый день по московскому времени. Задание дня обновлено.');
  return true;
}

// QUIZ START
function getSelectedWords() {
  const active = [...document.querySelectorAll('.lesson-pill.active')].map((p) => p.dataset.lesson);
  if (!active.length) {
    alert('Выберите хотя бы один урок');
    return null;
  }
  let words = [];
  active.forEach((k) => {
    if (Dict.byLesson[k]) words = words.concat(Dict.byLesson[k]);
  });
  return words;
}

function startQuiz(onlyFav) {
  let words = getSelectedWords();
  if (!words) return;
  if (onlyFav) words = words.filter((w) => App.favorites.includes(w.ar));
  if (!words.length) return alert(onlyFav ? 'Нет трудных слов в выбранных уроках' : 'Слова не найдены');
  const effectiveMode = Settings.mode;
  const limit = effectiveMode === 'fast' ? Settings.qtyFast : Settings.qtyNormal;
  initQuiz(getSmartQueue(words, limit), effectiveMode, onlyFav);
}

function initQuiz(words, effectiveMode, isFav, options = {}) {
  if (!words.length) {
    alert('Нет слов для тренировки');
    return;
  }
  quizMode = ['learn', 'type-ar', 'review', 'mix', 'fast', 'daily'].includes(effectiveMode) ? effectiveMode : Settings.mode;
  sessionOnlyFavorites = Boolean(isFav);
  sessionInitialWords = words.map((word) => ({ ar: word.ar, ru: word.ru }));
  dailyQuizTasks = Array.isArray(options.dailyTasks) ? options.dailyTasks : [];
  dailyQuizReplay = Boolean(options.dailyReplay);
  queue = sessionInitialWords;
  qi = 0;
  roundScore = 0;
  roundWords = [...words];
  roundWrong = [];
  roundAttemptedWords = [];
  roundUserAnswers = {};
  roundCorrect = 0;
  roundAttempts = 0;
  sessionIntervalRaised = new Set();
  sessionFailedWords = new Set();
  sessionDailyCounted = new Set();
  hstack = [];
  hidx = -1;
  isHist = false;
  lives = 3;
  fastWords = 0;
  bestStreak = 0;
  hintCount = 0;
  learnPhase = 'intro';
  const mNames = {
    learn: 'Учить новые слова',
    'type-ar': 'Арабский ввод',
    review: 'Обычное повторение',
    mix: 'Микс',
    fast: 'Быстрое повторение',
    daily: 'Задание дня',
  };
  lastSession = { kind: quizMode === 'daily' ? 'daily' : 'regular', words: sessionInitialWords, mode: quizMode, isFav: sessionOnlyFavorites, dailyTasks: dailyQuizTasks };
  const qModeEl = quizGetEl('q-mode');
  if (qModeEl) qModeEl.textContent = isFav ? `Трудные слова · ${mNames[quizMode] || quizMode}` : mNames[quizMode] || quizMode;
  const fastStats = quizGetEl('fast-stats');
  if (fastStats) fastStats.classList.toggle('hidden', quizMode !== 'fast');
  const fastLeader = quizGetEl('fast-leader');
  if (fastLeader) fastLeader.classList.toggle('hidden', quizMode !== 'fast');
  if (quizMode === 'fast') {
    updFastUI();
    loadFastLeader().catch(() => {});
  }
  if (quizMode === 'learn') {
    initLearnQueue(words);
    saveProgress();
    showScreen('screen-quiz');
    nextLearnCard(false);
    return;
  }
  saveProgress();
  showScreen('screen-quiz');
  nextWord(false);
}

function nextWord(inc) {
  clearTimers();
  isHist = false;
  if (inc) qi++;
  if (qi >= queue.length) {
    finishQuiz();
    return;
  }
  curWord = queue[qi];
  if (!curWord) {
    clearProgress();
    void finishQuiz();
    return;
  }

  currentDailyTask = quizMode === 'daily' ? dailyQuizTasks[qi] || null : null;
  if (currentDailyTask) {
    activeMode = currentDailyTask.mode;
    const modeLabel = quizGetEl('q-mode');
    if (modeLabel && typeof dailyTaskLabel === 'function') modeLabel.textContent = dailyTaskLabel(currentDailyTask);
  } else if (quizMode === 'fast') {
    activeMode = 'ru-ar-fast';
  } else if (quizMode === 'mix') {
    activeMode = ['ar-ru', 'ru-ar', 'type-ar'][Math.floor(Math.random() * 3)];
  } else if (quizMode === 'review') {
    activeMode = ['ar-ru', 'ru-ar'][Math.floor(Math.random() * 2)];
  } else {
    activeMode = quizMode;
  }

  if (inc) {
    hstack.push({ w: curWord, am: activeMode, idx: qi, phase: learnPhase });
    hidx = hstack.length - 1;
  } else {
    hstack = [{ w: curWord, am: activeMode, idx: 0, phase: learnPhase }];
    hidx = 0;
  }
  saveProgress();
  renderQ();
}

function renderArabicInputFormatHint(expected) {
  const el = quizGetEl('type-format-hint');
  const text = expected ? getArabicAnswerInputHint(expected) : '';
  el.textContent = text;
  el.classList.toggle('hidden', !text);
}

function renderQ() {
  quizGetEl('q-prog').textContent = qi + 1 + '/' + queue.length;
  quizGetEl('q-bar').style.width = ((qi + 1) / queue.length) * 100 + '%';
  renderFavoriteButton(quizGetEl('star-btn'), App.favorites.includes(curWord.ar));
  quizGetEl('feedback').textContent = '';
  quizGetEl('feedback').className = 'feedback';
  quizGetEl('btn-next').classList.add('hidden');
  quizGetEl('btn-next').textContent = 'Дальше →';
  const opts = quizGetEl('opts');
  const typeArea = quizGetEl('type-area');
  opts.classList.add('hidden');
  typeArea.classList.add('hidden');
  renderArabicInputFormatHint('');
  opts.innerHTML = '';

  if (isHist) quizGetEl('feedback').innerHTML = '<span class="feedback-note">Просмотр ответа</span>';

  quizGetEl('word-card').style.minHeight = '100px';

  if (activeMode === 'intro') {
    quizGetEl('word-card').style.minHeight = '140px';
    quizGetEl('word-display').innerHTML = `
      <div style="width:100%">
        <div class="learn-intro-ar">${esc(curWord.ar)}</div>
        <div class="learn-intro-ru">${esc(curWord.ru)}</div>
        <div class="learn-intro-hint">Прочитайте слово и перевод, затем продолжайте.</div>
      </div>`;
    quizGetEl('btn-next').classList.remove('hidden');
    quizGetEl('btn-next').textContent = 'Запомнил, дальше →';
  } else if (activeMode === 'type-ar') {
    hintCount = 0;
    quizGetEl('word-display').innerHTML = `<div class="w-ru">${esc(curWord.ru)}</div>`;
    typeArea.classList.remove('hidden');
    renderArabicInputFormatHint(curWord.ar);
    const inp = quizGetEl('type-input');
    inp.value = '';
    inp.disabled = false;
    const hintBtn = quizGetEl('btn-hint');
    const hintLbl = quizGetEl('hint-cost-label');
    if (hintBtn) {
      hintBtn.style.display = '';
      hintBtn.disabled = false;
    }
    if (hintLbl) hintLbl.textContent = '';
    if (!isHist) setTimeout(() => inp.focus(), 80);
    else {
      inp.value = curWord.ar;
      inp.disabled = true;
      if (hintBtn) hintBtn.style.display = 'none';
    }
  } else if (activeMode === 'ru-ar-fast') {
    quizGetEl('word-display').innerHTML = `<div class="w-ru">${esc(curWord.ru)}</div>`;
    opts.classList.remove('hidden');
    const correct = curWord.ar;
    genOpts(correct, 'ar').forEach((opt) => {
      const btn = document.createElement('button');
      btn.className = 'opt ar';
      btn.textContent = opt;
      btn.onclick = () => {
        if (!isHist) handleFast(btn, opt === correct, correct);
      };
      opts.appendChild(btn);
    });
    if (!isHist) startTimer();
  } else {
    const isArQ = activeMode === 'ar-ru';
    quizGetEl('word-display').innerHTML = isArQ
      ? `<div class="w-ar">${esc(curWord.ar)}</div>`
      : `<div class="w-ru">${esc(curWord.ru)}</div>`;
    opts.classList.remove('hidden');
    const correct = isArQ ? curWord.ru : curWord.ar;
    genOpts(correct, isArQ ? 'ru' : 'ar').forEach((opt) => {
      const btn = document.createElement('button');
      btn.className = 'opt' + (!isArQ ? ' ar' : '');
      btn.textContent = opt;
      btn.onclick = () => {
        if (!isHist) handleAns(btn, opt === correct, correct, !isArQ);
      };
      opts.appendChild(btn);
    });
  }
}

function genOpts(correct, key) {
  const source = Dict.allWords.length ? Dict.allWords : queue;
  const pool = shuf(source.filter((w) => w[key] !== correct && rmH(w[key]) !== rmH(correct)));
  const opts = [correct, ...pool.slice(0, 3).map((w) => w[key])];
  while (opts.length < 4) opts.push('—');
  return shuf(opts);
}

async function handleAns(btn, ok, correct, isAr) {
  registerQuizAttempt(curWord, btn?.textContent || '');
  if (currentDailyTask && typeof markDailyGoalTaskCompleted === 'function') markDailyGoalTaskCompleted(currentDailyTask, dailyQuizReplay);
  document.querySelectorAll('.opt').forEach((b) => (b.disabled = true));
  const fb = quizGetEl('feedback');
  if (ok) {
    btn.classList.add('ok');
    let pts = 0;
    if (activeMode === 'ar-ru') pts = 5;
    else if (activeMode === 'ru-ar') pts = 10;
    roundScore += pts;
    roundCorrect++;
    fb.className = 'feedback ok';
    fb.textContent = 'Правильно' + (pts ? ' +' + pts : '');
    if (pts) logPts(pts);
    updateWordLevel(curWord.ar, true);
    countCompletedWordOnce(curWord.ar);
    if (qi >= queue.length - 1) clearProgress();
    pauseTmo = setTimeout(() => nextWord(true), 800);
  } else {
    btn.classList.add('err');
    document.querySelectorAll('.opt').forEach((b) => {
      if (b.textContent === correct) b.classList.add('ok');
    });
    fb.className = 'feedback err';
    fb.innerHTML =
      'Ошибка. Правильно: <span class="' +
      (isAr ? 'answer-ar' : '') +
      '"' +
      (isAr ? ' dir="rtl"' : '') +
      '>' +
      esc(correct) +
      '</span>';
    updateWordLevel(curWord.ar, false);
    if (!roundWrong.find((w) => w.ar === curWord.ar)) roundWrong.push(curWord);
    quizGetEl('btn-next').classList.remove('hidden');
    pauseTmo = setTimeout(() => nextWord(true), 3000);
  }
}

// HINT for type-ar mode
function showHint() {
  if (!curWord || isHist) return;
  const fullWord = rmH(getArabicAnswerHintTarget(curWord.ar));
  hintCount++;
  const inp = quizGetEl('type-input');
  const revealedPart = fullWord.substring(0, hintCount);
  inp.value = revealedPart;
  inp.focus();
  const penalty = hintCount * 5;
  const remaining = Math.max(0, 20 - penalty);
  const hintBtn = quizGetEl('btn-hint');
  const hintLbl = quizGetEl('hint-cost-label');
  if (hintLbl) hintLbl.textContent = 'Показано букв: ' + hintCount + ' | Штраф: −' + penalty + ' | Получите: ' + remaining + ' очков';
  if (hintCount >= fullWord.length) {
    if (hintBtn) {
      hintBtn.disabled = true;
      setIconLabel(hintBtn, 'bulb', 'Всё показано');
    }
  } else {
    if (hintBtn) setIconLabel(hintBtn, 'bulb', 'Ещё буква (−5 очков)');
  }
}

function checkTyped() {
  if (isHist) return;
  if (quizMode === 'learn') {
    checkTypedLearn();
    return;
  }
  const val = quizGetEl('type-input').value.trim();
  registerQuizAttempt(curWord, val);
  if (currentDailyTask && typeof markDailyGoalTaskCompleted === 'function') markDailyGoalTaskCompleted(currentDailyTask, dailyQuizReplay);
  const fb = quizGetEl('feedback');
  quizGetEl('type-input').disabled = true;
  const hintBtn = quizGetEl('btn-hint');
  if (hintBtn) hintBtn.style.display = 'none';
  const hintLbl = quizGetEl('hint-cost-label');
  if (hintLbl) hintLbl.textContent = '';
  if (isArabicAnswerCorrect(val, curWord.ar, Settings.answerCheck)) {
    const penalty = hintCount * 5;
    const pts = Math.max(0, 20 - penalty);
    fb.className = 'feedback ok';
    fb.textContent = hintCount > 0 ? 'Правильно! +' + pts + ' (−' + penalty + ' за подсказки)' : 'Правильно! +20';
    roundScore += pts;
    roundCorrect++;
    if (pts > 0) logPts(pts);
    updateWordLevel(curWord.ar, true);
    countCompletedWordOnce(curWord.ar);
    if (qi >= queue.length - 1) clearProgress();
    pauseTmo = setTimeout(() => nextWord(true), 800);
  } else {
    fb.className = 'feedback err';
    fb.innerHTML =
      'Ошибка. Правильно: <span class="answer-ar" dir="rtl">' + esc(curWord.ar) + '</span>';
    roundUserAnswers[curWord.ar] = val;
    updateWordLevel(curWord.ar, false);
    if (!roundWrong.find((w) => w.ar === curWord.ar)) roundWrong.push(curWord);
    quizGetEl('btn-next').classList.remove('hidden');
    pauseTmo = setTimeout(() => nextWord(true), 3000);
  }
}

// FAST MODE
function startTimer() {
  clearInterval(timerInt);
  timeLeft = 7;
  updTimer();
  timerInt = setInterval(() => {
    timeLeft--;
    updTimer();
    if (timeLeft <= 0) {
      clearInterval(timerInt);
      handleFast(null, false, curWord.ar, true);
    }
  }, 1000);
}
function updTimer() {
  const el = quizGetEl('fs-timer');
  el.textContent = timeLeft;
  el.className = 'fs-val' + (timeLeft <= 3 ? ' danger' : '');
}
async function loadFastLeader() {
  // Public leaderboard read — see lb.js note on the `leaderboard` view.
  const el = quizGetEl('fast-leader-text', true);
  if (!el) return;
  try {
    const { data, error } = await db
      .from('leaderboard')
      .select('nickname,fast_mode_high_score')
      .order('fast_mode_high_score', { ascending: false })
      .limit(1);
    if (error) throw error;
    if (data && data.length && data[0].fast_mode_high_score > 0) {
      el.textContent = 'Рекорд: ' + data[0].nickname + ' — ' + data[0].fast_mode_high_score + ' слов';
    }
  } catch (e) {
    ErrorLog.capture(e, { source: 'quiz', action: 'load-fast-leader' });
    el.textContent = 'Лидер недоступен';
    setTimeout(() => {
      if (el.textContent === 'Лидер недоступен') el.textContent = 'Рекорд: —';
    }, 2500);
  }
}
function updFastUI() {
  quizGetEl('fs-lives').innerHTML =
    '<span class="life-dots">' +
    Array.from({ length: 3 }, (_, i) => '<span class="life-dot' + (i < lives ? ' is-active' : '') + '"></span>').join('') +
    '</span>';
  quizGetEl('fs-words').textContent = fastWords;
}

async function handleFast(btn, ok, correct, isTimeout) {
  registerQuizAttempt(curWord, btn?.textContent || (isTimeout ? '[время истекло]' : ''));
  if (currentDailyTask && typeof markDailyGoalTaskCompleted === 'function') markDailyGoalTaskCompleted(currentDailyTask, dailyQuizReplay);
  clearTimers();
  document.querySelectorAll('.opt').forEach((b) => {
    b.disabled = true;
    if (b.textContent === correct) b.classList.add('ok');
    else if (b === btn) b.classList.add('err');
  });
  updateWordLevel(curWord.ar, ok);
  const fb = quizGetEl('feedback');
  if (ok) {
    roundCorrect++;
    fastWords++;
    bestStreak = Math.max(bestStreak, fastWords);
    updFastUI();
    fb.className = 'feedback ok';
    fb.textContent = 'Серия: ' + fastWords;
    countCompletedWordOnce(curWord.ar);
    pauseTmo = setTimeout(() => nextWord(true), 700);
  } else {
    if (!roundWrong.find((word) => word.ar === curWord.ar)) roundWrong.push({ ar: curWord.ar, ru: curWord.ru });
    lives--;
    updFastUI();
    fb.className = 'feedback err';
    fb.innerHTML = (isTimeout ? 'Время истекло. ' : 'Ошибка. ') + '<span class="answer-ar" dir="rtl">' + esc(correct) + '</span>';
    if (lives <= 0) {
      if (fastWords > (App.survivalRecord || 0)) {
        App.survivalRecord = fastWords;
        try {
          await Api.call('update-survival-record', { username: App.username, password: App.password, survival_record: fastWords });
        } catch (e) {
          ErrorLog.capture(e, { source: 'quiz', action: 'update-fast-record' });
        }
      }
      fb.innerHTML += '<br><b style="color:var(--red)">Лучшая серия: ' + fastWords + ' слов</b>';
      quizGetEl('btn-next').textContent = 'Результаты →';
      quizGetEl('btn-next').classList.remove('hidden');
      clearProgress();
    } else {
      pauseTmo = setTimeout(() => nextWord(true), 1500);
    }
  }
}

function goNext() {
  clearTimers();
  if (quizMode === 'fast' && lives <= 0) {
    finishQuiz();
    return;
  }
  if (quizMode === 'learn') {
    goNextLearn();
    return;
  }
  if (activeMode === 'intro') {
    if (currentDailyTask && typeof markDailyGoalTaskCompleted === 'function') markDailyGoalTaskCompleted(currentDailyTask, dailyQuizReplay);
    nextWord(true);
    return;
  }
  nextWord(true);
}
function confirmExit() {
  if (quizMode === 'fast') {
    void finishQuiz();
    return;
  }
  if (confirm('Завершить тренировку?')) void finishQuiz();
}
function clearTimers() {
  clearInterval(timerInt);
  clearTimeout(pauseTmo);
}

// PROGRESS SAVE (local only — purely a UX convenience to resume after
// closing the tab; the server is always the source of truth for
// anything that has already been scored)
function saveProgress() {
  const writeProgress = (payload) => {
    try {
      localStorage.setItem('arabic_progress', JSON.stringify(payload));
      return true;
    } catch (e) {
      clearProgress();
      return false;
    }
  };

  if (quizMode === 'learn') {
    if (!learnCards.length) return;
    writeProgress({
      isLearn: true,
      learnCards,
      learnCardIdx,
      learnDoneWords,
      roundScore,
      roundWords,
      roundWrong,
      roundCorrect,
      roundAttempts,
      roundAttemptedWords,
      roundUserAnswers,
      sessionInitialWords,
      sessionOnlyFavorites,
      sessionIntervalRaised: [...sessionIntervalRaised],
      sessionFailedWords: [...sessionFailedWords],
      sessionDailyCounted: [...sessionDailyCounted],
      username: App.username,
      answerCheck: Settings.answerCheck,
      mode: quizMode,
      volume: App.volume,
    });
    return;
  }
  if (!queue.length) return;
  writeProgress({
    queue,
    qi,
    roundScore,
    roundWords,
    roundWrong,
    roundCorrect,
    roundAttempts,
    roundAttemptedWords,
    roundUserAnswers,
    roundWords,
    sessionInitialWords,
    sessionOnlyFavorites,
    sessionIntervalRaised: [...sessionIntervalRaised],
    sessionFailedWords: [...sessionFailedWords],
    sessionDailyCounted: [...sessionDailyCounted],
    username: App.username,
    answerCheck: Settings.answerCheck,
    mode: quizMode,
    activeMode,
    volume: App.volume,
    lives,
    fastWords,
    bestStreak,
    dailyTasks: dailyQuizTasks,
    dailyReplay: dailyQuizReplay,
  });
}
function clearProgress() {
  try {
    localStorage.removeItem('arabic_progress');
  } catch (e) {
    /* non-fatal */
  }
}

function toSafeWordList(items, fallback = []) {
  if (!Array.isArray(items)) return fallback;
  const clean = items.filter(
    (w) =>
      w &&
      typeof w.ar === 'string' &&
      w.ar.trim() &&
      typeof w.ru === 'string' &&
      w.ru.trim()
  );
  return clean.length ? clean : fallback;
}

function toSafeLearnCardList(items) {
  if (!Array.isArray(items)) return [];
  return items
    .map((card) => {
      const word = toSafeWordList([card?.w], [])[0];
      const stage = clampNum(card?.stage, -1, 0, 4);
      if (!word || stage < 0) return null;
      return { w: word, stage, key: typeof card.key === 'string' && card.key ? card.key : word.ar };
    })
    .filter(Boolean);
}

function toSafeDailyTaskList(items) {
  if (!Array.isArray(items)) return [];
  const validCategories = new Set(['new', 'review', 'typing']);
  const validModes = new Set(['intro', 'ar-ru', 'ru-ar', 'type-ar']);
  return items
    .map((task, index) => {
      const word = toSafeWordList([task?.word], [])[0];
      if (!word || !validCategories.has(task?.category) || !validModes.has(task?.mode)) return null;
      const clean = {
        id: typeof task.id === 'string' && task.id ? task.id : `${task.category}-${index}`,
        category: task.category,
        ordinal: clampNum(task.ordinal, index + 1, 1, 10000),
        mode: task.mode,
        word,
        done: Boolean(task.done),
      };
      if (task.__counted) clean.__counted = true;
      return clean;
    })
    .filter(Boolean);
}

function toSafeAnswerMap(value) {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return {};
  return Object.fromEntries(
    Object.entries(value)
      .filter(([key, answer]) => typeof key === 'string' && key && typeof answer === 'string')
      .slice(0, 1000)
  );
}

function toSafeStringSet(value) {
  return new Set(Array.isArray(value) ? value.filter((item) => typeof item === 'string' && item).slice(0, 10000) : []);
}

function clampNum(value, fallback = 0, min = 0, max = Number.MAX_SAFE_INTEGER) {
  const n = Number(value);
  if (!Number.isFinite(n)) return fallback;
  const c = Math.floor(n);
  if (c < min) return min;
  if (c > max) return max;
  return c;
}

async function restoreProgress(options = {}) {
  const { skipPrompt = false } = options || {};
  let s = null;
  try {
    s = localStorage.getItem('arabic_progress');
  } catch (e) {
    return false;
  }
  if (!s) return false;
  try {
    const p = JSON.parse(s);
    if (!p || typeof p !== 'object') {
      clearProgress();
      return false;
    }
    if (!p.username || p.username !== App.username) {
      clearProgress();
      return false;
    }
    if (p.volume && !findVolumeById(p.volume)) {
      clearProgress();
      return false;
    }
    if (p.volume && App.volume && p.volume !== App.volume) {
      return false;
    }
    const mNames = {
      learn: 'Учить новые слова',
      'type-ar': 'Арабский ввод',
      review: 'Обычное повторение',
      mix: 'Микс',
      fast: 'Быстрое повторение',
      daily: 'Задание дня',
    };
    if (p.isLearn) {
      const safeLearnCards = toSafeLearnCardList(p.learnCards);
      const safeLearnDoneWords = toSafeWordList(p.learnDoneWords, []);
      const safeRoundWords = toSafeWordList(p.roundWords, []);
      const safeLearnCardIdx = clampNum(p.learnCardIdx, 0, 0, Math.max(0, safeLearnCards.length - 1));
      if (!safeLearnCards.length) {
        clearProgress();
        return false;
      }
      const doneSoFar = safeLearnDoneWords.length;
      const totalWords = safeRoundWords.length;
      if (!skipPrompt && !confirm('Продолжить незавершённый урок (' + doneSoFar + '/' + totalWords + ' слов выучено, +' + p.roundScore + ' очков)?')) {
        clearProgress();
        return false;
      }
      quizMode = 'learn';
      Settings.mode = 'learn';
      sessionOnlyFavorites = Boolean(p.sessionOnlyFavorites);
      sessionInitialWords = toSafeWordList(p.sessionInitialWords, safeRoundWords);
      learnCards = safeLearnCards;
      learnCardIdx = safeLearnCardIdx;
      learnDoneWords = safeLearnDoneWords;
      roundScore = clampNum(p.roundScore, 0);
      roundWords = safeRoundWords;
      roundWrong = toSafeWordList(p.roundWrong, []);
      roundCorrect = clampNum(p.roundCorrect, 0);
      roundAttempts = clampNum(p.roundAttempts, 0);
      roundAttemptedWords = toSafeWordList(p.roundAttemptedWords, []);
      roundUserAnswers = toSafeAnswerMap(p.roundUserAnswers);
      sessionIntervalRaised = toSafeStringSet(p.sessionIntervalRaised);
      sessionFailedWords = toSafeStringSet(p.sessionFailedWords);
      sessionDailyCounted = toSafeStringSet(p.sessionDailyCounted);
      dailyQuizTasks = [];
      currentDailyTask = null;
      dailyQuizReplay = false;
      Settings.answerCheck = p.answerCheck === 'strict' ? 'strict' : 'learning';
      updateAnswerCheckUI();
      if (p.volume) App.volume = p.volume;
      lastSession = { kind: 'regular', words: sessionInitialWords, mode: 'learn', isFav: sessionOnlyFavorites, dailyTasks: [] };
      quizGetEl('q-mode').textContent = mNames.learn;
      quizGetEl('fast-stats').classList.add('hidden');
      quizGetEl('fast-leader').classList.add('hidden');
      showScreen('screen-quiz');
      nextLearnCard(false);
      return true;
    }
    const safeQueue = toSafeWordList(p.queue, []);
    const safeQueuePos = clampNum(p.qi, 0, 0, Math.max(0, safeQueue.length - 1));
    if (!safeQueue.length || safeQueuePos >= safeQueue.length) {
      clearProgress();
      return false;
    }
    if (!skipPrompt && !confirm('Продолжить незавершённый урок (' + safeQueuePos + '/' + safeQueue.length + ' слов, +' + clampNum(p.roundScore, 0) + ' очков)?')) {
      clearProgress();
      return false;
    }
    queue = safeQueue;
    qi = safeQueuePos;
    roundScore = clampNum(p.roundScore, 0);
    roundWords = toSafeWordList(p.roundWords, safeQueue);
    roundWrong = toSafeWordList(p.roundWrong, []);
    roundAttemptedWords = toSafeWordList(p.roundAttemptedWords, []);
    roundUserAnswers = toSafeAnswerMap(p.roundUserAnswers);
    roundCorrect = clampNum(p.roundCorrect, 0);
    roundAttempts = clampNum(p.roundAttempts, 0);
    sessionIntervalRaised = toSafeStringSet(p.sessionIntervalRaised);
    sessionFailedWords = toSafeStringSet(p.sessionFailedWords);
    sessionDailyCounted = toSafeStringSet(p.sessionDailyCounted);
    Settings.answerCheck = p.answerCheck === 'strict' ? 'strict' : 'learning';
    updateAnswerCheckUI();
    quizMode = ['type-ar', 'review', 'mix', 'fast', 'daily'].includes(p.mode) ? p.mode : Settings.mode;
    if (quizMode !== 'daily') Settings.mode = quizMode;
    sessionOnlyFavorites = Boolean(p.sessionOnlyFavorites);
    sessionInitialWords = toSafeWordList(p.sessionInitialWords, safeQueue);
    dailyQuizTasks = quizMode === 'daily' ? toSafeDailyTaskList(p.dailyTasks) : [];
    if (quizMode === 'daily' && dailyQuizTasks.length !== safeQueue.length) {
      clearProgress();
      return false;
    }
    dailyQuizReplay = quizMode === 'daily' && Boolean(p.dailyReplay);
    currentDailyTask = quizMode === 'daily' ? dailyQuizTasks[qi] || null : null;
    lives = clampNum(p.lives, 3, 0, 3);
    fastWords = clampNum(p.fastWords, 0, 0, 10000);
    bestStreak = clampNum(p.bestStreak, 0, 0, 10000);
    if (p.volume) App.volume = p.volume;
    learnPhase = 'test';
    lastSession = { kind: quizMode === 'daily' ? 'daily' : 'regular', words: sessionInitialWords, mode: quizMode, isFav: sessionOnlyFavorites, dailyTasks: dailyQuizTasks };
    quizGetEl('q-mode').textContent = currentDailyTask && typeof dailyTaskLabel === 'function' ? dailyTaskLabel(currentDailyTask) : mNames[quizMode] || quizMode;
    quizGetEl('fast-stats').classList.toggle('hidden', quizMode !== 'fast');
    quizGetEl('fast-leader').classList.toggle('hidden', quizMode !== 'fast');
    if (quizMode === 'fast') {
      updFastUI();
      loadFastLeader().catch(() => {});
    }
    curWord = queue[qi];
    if (!curWord) {
      clearProgress();
      return false;
    }
    const hasSavedMode = ['intro', 'ar-ru', 'ru-ar', 'type-ar', 'ru-ar-fast'].includes(p.activeMode);
    const fallbackMode =
      currentDailyTask
        ? currentDailyTask.mode
        : quizMode === 'fast'
        ? 'ru-ar-fast'
        : quizMode === 'mix'
        ? ['ar-ru', 'ru-ar', 'type-ar'][Math.floor(Math.random() * 3)]
        : quizMode === 'review'
        ? ['ar-ru', 'ru-ar'][Math.floor(Math.random() * 2)]
        : quizMode;
    activeMode = hasSavedMode ? p.activeMode : fallbackMode;
    hstack = [{ w: curWord, am: activeMode, idx: qi, phase: learnPhase }];
    hidx = 0;
    isHist = false;
    showScreen('screen-quiz');
    renderQ();
    return true;
  } catch (e) {
    clearProgress();
    ErrorLog.capture(e, { source: 'quiz', action: 'restore-progress' });
    return false;
  }
}

// RESULTS
async function finishQuiz() {
  clearTimers();
  clearProgress();
  const completedMode = quizMode;
  const resultWords = completedMode === 'fast' ? toSafeWordList(roundAttemptedWords, []) : toSafeWordList(roundWords, []);
  const resultTotal = completedMode === 'fast' ? roundAttempts : resultWords.length;
  if (completedMode === 'daily' && typeof flushDailyGoalProgress === 'function') await flushDailyGoalProgress();
  if (completedMode === 'fast' && fastWords > (App.survivalRecord || 0)) {
    App.survivalRecord = fastWords;
    try {
      await Api.call('update-survival-record', { username: App.username, password: App.password, survival_record: fastWords });
    } catch (e) {
      ErrorLog.capture(e, { source: 'quiz', action: 'finish-fast-record' });
    }
  }
  quizGetEl('r-pts').textContent = roundScore;
  quizGetEl('r-total').textContent = resultTotal;
  quizGetEl('r-correct').textContent = roundCorrect;
  const attemptsEl = quizGetEl('r-attempts');
  if (attemptsEl) attemptsEl.textContent = roundAttempts;
  const resultTitle = completedMode === 'fast' ? 'Быстрое повторение завершено' : completedMode === 'daily' ? 'Задание дня завершено' : 'Урок завершён';
  setIconLabel(quizGetEl('res-title'), completedMode === 'fast' ? 'bolt' : 'success', resultTitle);
  const box = quizGetEl('res-word-list');
  const wrongArs = new Set(roundWrong.map((w) => w.ar));
  const wrongItems = resultWords.filter((w) => wrongArs.has(w.ar));
  const correctItems = resultWords.filter((w) => !wrongArs.has(w.ar));
  let html = '<div class="wl-hdr">Слова тренировки — ' + resultWords.length + '</div>';
  if (wrongItems.length) {
    html +=
      '<div style="padding:8px 14px;font-size:11px;font-weight:700;color:var(--red);background:#fff5f5;text-transform:uppercase;letter-spacing:0.5px;">Ошибки — ' +
      wrongItems.length +
      ' слов</div>';
    html += wrongItems
      .map((w) => {
        const userAnswer = roundUserAnswers[w.ar];
        const typed = userAnswer ? '<div style="font-size:12px;color:#888;margin-top:4px;">Вы вводили: <b>' + esc(userAnswer) + '</b></div>' : '';
        return `<div class="wl-item" style="background:#fff5f5;border-left:3px solid var(--red);"><div><span class="wl-ar">${esc(w.ar)}</span><span class="wl-ru">${esc(w.ru)}</span>${typed}</div></div>`;
      })
      .join('');
  }
  if (correctItems.length) {
    html +=
      '<div style="padding:8px 14px;font-size:11px;font-weight:700;color:var(--green);background:var(--green-light);text-transform:uppercase;letter-spacing:0.5px;">Правильно — ' +
      correctItems.length +
      ' слов</div>';
    html += correctItems.map((w) => `<div class="wl-item"><span class="wl-ar">${esc(w.ar)}</span><span class="wl-ru">${esc(w.ru)}</span></div>`).join('');
  }
  box.innerHTML = html;
  ErrorLog.invariant(roundCorrect <= roundAttempts, 'quiz-result-correct-count-exceeds-attempts', {
    source: 'quiz-results',
    mode: completedMode,
    attempts: roundAttempts,
    correct: roundCorrect,
  });
  queue = [];
  learnCards = [];
  learnCardIdx = 0;
  currentDailyTask = null;
  showScreen('screen-results');
}
function backToMenu() {
  showScreen('screen-app');
  switchTab('train');
  if (typeof renderDailyGoal === 'function') renderDailyGoal();
}
function restartQuiz() {
  const previous = lastSession;
  if (!previous || !Array.isArray(previous.words) || !previous.words.length) {
    startQuiz(false);
    return;
  }
  if (previous.kind === 'daily') {
    const tasks = toSafeDailyTaskList(previous.dailyTasks).map((task) => ({ ...task, word: { ...task.word }, done: false, __counted: false }));
    if (!tasks.length) return startDailyGoal();
    initQuiz(tasks.map((task) => ({ ...task.word })), 'daily', false, { dailyTasks: tasks, dailyReplay: true });
    return;
  }
  initQuiz(previous.words.map((word) => ({ ...word })), previous.mode, previous.isFav);
}

// FAVORITES / SCORING
function setWordFavoriteLocal(ar, active) {
  const wasActive = App.favorites.includes(ar);
  if (active && !wasActive) App.favorites.push(ar);
  if (!active && wasActive) App.favorites = App.favorites.filter((word) => word !== ar);
  if (curWord && curWord.ar === ar) renderFavoriteButton(quizGetEl('star-btn'), active);
  return wasActive !== active;
}

async function persistWordFavorite(ar, active, action) {
  try {
    await Api.call('update-word-stat', {
      username: App.username,
      password: App.password,
      word_ar: ar,
      is_favorite: active,
      seen_count: App.wordStats[ar]?.seen || 0,
      level: App.wordStats[ar]?.level || 1,
    });
  } catch (e) {
    ErrorLog.capture(e, { source: 'quiz', action, word: ar });
  }
}

async function toggleStar() {
  if (!curWord) return;
  const ar = curWord.ar;
  const active = !App.favorites.includes(ar);
  setWordFavoriteLocal(ar, active);
  if (!App.username) return;
  await persistWordFavorite(ar, active, 'toggle-favorite');
}
async function logPts(pts) {
  if (!App.username) return;
  App.totalScore = (App.totalScore || 0) + pts;
  updateUI();
  showXP(pts);
  try {
    const scoreEventId = typeof crypto.randomUUID === 'function' ? crypto.randomUUID() : null;
    const res = await Api.call('log-score', { username: App.username, password: App.password, points: pts, course_name: App.volume, score_event_id: scoreEventId });
    if (typeof res.total_score === 'number') App.totalScore = res.total_score;
    updateUI();
  } catch (e) {
    App.totalScore = Math.max(0, (App.totalScore || 0) - pts);
    updateUI();
    showScoreSyncError();
    ErrorLog.capture(e, { source: 'quiz', action: 'log-score', points: pts, course: App.volume });
  }
}

function showScoreSyncError() {
  const old = quizGetEl('score-sync-error');
  if (old) old.remove();
  const el = document.createElement('div');
  el.id = 'score-sync-error';
  el.textContent = 'Очки не сохранились. Проверьте интернет и перезайдите.';
  el.style.cssText =
    'position:fixed;left:12px;right:12px;bottom:78px;z-index:9999;background:var(--red);color:white;padding:10px 14px;border-radius:10px;font-weight:700;font-size:13px;text-align:center;box-shadow:0 6px 20px rgba(0,0,0,0.22);';
  document.body.appendChild(el);
  setTimeout(() => el.remove(), 3500);
}
