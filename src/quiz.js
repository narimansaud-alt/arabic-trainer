// quiz.js — quiz engine for type-ar / review / mix / fast modes, plus
// shared state and helpers used by both this file and learn.js
// (the Memrise-style 'learn' mode lives in its own module since its
// state machine is substantially different).

// Shared mutable quiz state (used by quiz.js and learn.js together)
let queue = [],
  qi = 0,
  curWord = null,
  activeMode = 'ar-ru';
let roundScore = 0,
  roundWords = [],
  roundWrong = [],
  roundCorrect = 0,
  roundAttempts = 0;
let sessionIntervalRaised = new Set();
let hstack = [],
  hidx = -1,
  isHist = false;
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
  roundAttempts++;
  const s = App.wordStats[ar] || {};
  const cur = s.level || 1;
  const nl = ok ? Math.min(cur + 1, 5) : Math.max(cur - 1, 1);
  const reviewLevel = ok && sessionIntervalRaised.has(ar) ? cur : nl;
  const nr = getNextReview(reviewLevel, ok);
  if (ok) sessionIntervalRaised.add(ar);
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
  roundCorrect = 0;
  roundAttempts = 0;
  sessionIntervalRaised = new Set();
  if (typeof learnCards !== 'undefined') learnCards = [];
  if (typeof learnDoneWords !== 'undefined') learnDoneWords = [];
  if (typeof learnCardIdx !== 'undefined') learnCardIdx = 0;
  clearProgress();
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
  const effectiveMode = onlyFav ? 'learn' : Settings.mode;
  const limit = effectiveMode === 'fast' ? Settings.qtyFast : Settings.qtyNormal;
  if (effectiveMode === 'review' && !onlyFav) {
    const now = new Date().toISOString();
    const due = words.filter((w) => {
      const s = App.wordStats[w.ar];
      return !s || !s.next || s.next <= now;
    });
    if (!due.length) {
      alert('На сегодня нечего повторять из выбранных уроков.\nВыберите другие уроки или вернитесь позже.');
      return;
    }
    initQuiz(getSmartQueue(due, limit), effectiveMode, onlyFav);
  } else {
    initQuiz(getSmartQueue(words, limit), effectiveMode, onlyFav);
  }
}

function initQuiz(words, effectiveMode, isFav) {
  if (!words.length) {
    alert('Нет слов для тренировки');
    return;
  }
  if (effectiveMode && effectiveMode !== Settings.mode) Settings.mode = effectiveMode;
  queue = words;
  qi = 0;
  roundScore = 0;
  roundWords = [...words];
  roundWrong = [];
  roundCorrect = 0;
  roundAttempts = 0;
  sessionIntervalRaised = new Set();
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
  };
  const qModeEl = quizGetEl('q-mode');
  if (qModeEl) qModeEl.textContent = isFav ? 'Избранные слова' : mNames[Settings.mode] || Settings.mode;
  const fastStats = quizGetEl('fast-stats');
  if (fastStats) fastStats.classList.toggle('hidden', Settings.mode !== 'fast');
  const fastLeader = quizGetEl('fast-leader');
  if (fastLeader) fastLeader.classList.toggle('hidden', Settings.mode !== 'fast');
  if (Settings.mode === 'fast') {
    updFastUI();
    loadFastLeader().catch(() => {});
  }
  if (Settings.mode === 'learn') {
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

  if (Settings.mode === 'fast') {
    activeMode = 'ru-ar-fast';
  } else if (Settings.mode === 'mix') {
    activeMode = ['ar-ru', 'ru-ar', 'type-ar'][Math.floor(Math.random() * 3)];
  } else if (Settings.mode === 'review') {
    activeMode = ['ar-ru', 'ru-ar'][Math.floor(Math.random() * 2)];
  } else {
    activeMode = Settings.mode;
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
  opts.innerHTML = '';

  if (isHist) quizGetEl('feedback').innerHTML = '<span class="feedback-note">Просмотр ответа</span>';

  quizGetEl('word-card').style.minHeight = '100px';

  if (activeMode === 'type-ar') {
    hintCount = 0;
    quizGetEl('word-display').innerHTML = `<div class="w-ru">${esc(curWord.ru)}</div>`;
    typeArea.classList.remove('hidden');
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
    addDailyWord();
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
  const fullWord = rmH(curWord.ar.replace(/\s*\(.*?\)\s*/g, ''));
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
  if (Settings.mode === 'learn') {
    checkTypedLearn();
    return;
  }
  const val = quizGetEl('type-input').value.trim();
  const correct = curWord.ar.replace(/\s*\(.*?\)\s*/g, '');
  const fb = quizGetEl('feedback');
  quizGetEl('type-input').disabled = true;
  const hintBtn = quizGetEl('btn-hint');
  if (hintBtn) hintBtn.style.display = 'none';
  const hintLbl = quizGetEl('hint-cost-label');
  if (hintLbl) hintLbl.textContent = '';
  if (isArabicAnswerCorrect(val, correct, Settings.answerCheck)) {
    const penalty = hintCount * 5;
    const pts = Math.max(0, 20 - penalty);
    fb.className = 'feedback ok';
    fb.textContent = hintCount > 0 ? 'Правильно! +' + pts + ' (−' + penalty + ' за подсказки)' : 'Правильно! +20';
    roundScore += pts;
    roundCorrect++;
    if (pts > 0) logPts(pts);
    updateWordLevel(curWord.ar, true);
    addDailyWord();
    if (qi >= queue.length - 1) clearProgress();
    pauseTmo = setTimeout(() => nextWord(true), 800);
  } else {
    fb.className = 'feedback err';
    fb.innerHTML =
      'Ошибка. Правильно: <span class="answer-ar" dir="rtl">' + esc(curWord.ar) + '</span>';
    curWord.userAnswer = val;
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
  clearTimers();
  document.querySelectorAll('.opt').forEach((b) => {
    b.disabled = true;
    if (b.textContent === correct) b.classList.add('ok');
    else if (b === btn) b.classList.add('err');
  });
  updateWordLevel(curWord.ar, ok);
  const fb = quizGetEl('feedback');
  if (ok) {
    fastWords++;
    bestStreak = Math.max(bestStreak, fastWords);
    updFastUI();
    fb.className = 'feedback ok';
    fb.textContent = 'Серия: ' + fastWords;
    addDailyWord();
    pauseTmo = setTimeout(() => nextWord(true), 700);
  } else {
    lives--;
    updFastUI();
    addFav(curWord.ar);
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
  if (Settings.mode === 'fast' && lives <= 0) {
    finishQuiz();
    return;
  }
  if (Settings.mode === 'learn') {
    goNextLearn();
    return;
  }
  nextWord(true);
}
function confirmExit() {
  if (confirm('Завершить тренировку?')) finishQuiz();
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

  if (Settings.mode === 'learn') {
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
      username: App.username,
      answerCheck: Settings.answerCheck,
      mode: Settings.mode,
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
    username: App.username,
    answerCheck: Settings.answerCheck,
    mode: Settings.mode,
    activeMode,
    volume: App.volume,
    lives,
    fastWords,
    bestStreak,
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
    const mNames = {
      learn: 'Учить новые слова',
      'type-ar': 'Арабский ввод',
      review: 'Обычное повторение',
      mix: 'Микс',
      fast: 'Быстрое повторение',
    };
    if (p.isLearn) {
      const safeLearnCards = toSafeWordList(p.learnCards, []);
      const safeLearnDoneWords = toSafeWordList(p.learnDoneWords, []);
      const safeRoundWords = toSafeWordList(p.roundWords, []);
      const safeLearnCardIdx = clampNum(p.learnCardIdx, 0, 0, Math.max(0, safeLearnCards.length - 1));
      if (p.volume && !findVolumeById(p.volume)) {
        clearProgress();
        return false;
      }
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
      Settings.mode = 'learn';
      learnCards = safeLearnCards;
      learnCardIdx = safeLearnCardIdx;
      learnDoneWords = safeLearnDoneWords;
      roundScore = clampNum(p.roundScore, 0);
      roundWords = safeRoundWords;
      roundWrong = toSafeWordList(p.roundWrong, []);
      roundCorrect = clampNum(p.roundCorrect, 0);
      roundAttempts = clampNum(p.roundAttempts, 0);
      Settings.answerCheck = p.answerCheck === 'strict' ? 'strict' : 'learning';
      updateAnswerCheckUI();
      if (p.volume) App.volume = p.volume;
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
    if (p.volume && !findVolumeById(p.volume)) {
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
    roundWords = safeQueue;
    roundWrong = toSafeWordList(p.roundWrong, []);
    roundCorrect = clampNum(p.roundCorrect, 0);
    roundAttempts = clampNum(p.roundAttempts, 0);
    Settings.answerCheck = p.answerCheck === 'strict' ? 'strict' : 'learning';
    updateAnswerCheckUI();
    Settings.mode = ['learn', 'type-ar', 'review', 'mix', 'fast'].includes(p.mode) ? p.mode : Settings.mode;
    lives = clampNum(p.lives, 3, 0, 3);
    fastWords = clampNum(p.fastWords, 0, 0, 10000);
    bestStreak = clampNum(p.bestStreak, 0, 0, 10000);
    if (p.volume) App.volume = p.volume;
    learnPhase = 'test';
    quizGetEl('q-mode').textContent = mNames[Settings.mode] || Settings.mode;
    quizGetEl('fast-stats').classList.toggle('hidden', Settings.mode !== 'fast');
    quizGetEl('fast-leader').classList.toggle('hidden', Settings.mode !== 'fast');
    if (Settings.mode === 'fast') {
      updFastUI();
      loadFastLeader().catch(() => {});
    }
    curWord = queue[qi];
    if (!curWord) {
      clearProgress();
      return false;
    }
    const hasSavedMode = ['ar-ru', 'ru-ar', 'type-ar', 'ru-ar-fast'].includes(p.activeMode);
    const fallbackMode =
      Settings.mode === 'fast'
        ? 'ru-ar-fast'
        : Settings.mode === 'mix'
        ? ['ar-ru', 'ru-ar', 'type-ar'][Math.floor(Math.random() * 3)]
        : Settings.mode === 'review'
        ? ['ar-ru', 'ru-ar'][Math.floor(Math.random() * 2)]
        : Settings.mode;
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
  queue = [];
  learnCards = [];
  learnCardIdx = 0;
  if (Settings.mode === 'fast' && fastWords > (App.survivalRecord || 0)) {
    App.survivalRecord = fastWords;
    try {
      await Api.call('update-survival-record', { username: App.username, password: App.password, survival_record: fastWords });
    } catch (e) {
      ErrorLog.capture(e, { source: 'quiz', action: 'finish-fast-record' });
    }
  }
  quizGetEl('r-pts').textContent = roundScore;
  quizGetEl('r-total').textContent = roundWords.length;
  quizGetEl('r-correct').textContent = roundCorrect;
  const attemptsEl = quizGetEl('r-attempts');
  if (attemptsEl) attemptsEl.textContent = roundAttempts;
  setIconLabel(quizGetEl('res-title'), Settings.mode === 'fast' ? 'bolt' : 'success', Settings.mode === 'fast' ? 'Быстрое повторение завершено' : 'Урок завершён');
  const box = quizGetEl('res-word-list');
  const wrongArs = new Set(roundWrong.map((w) => w.ar));
  const wrongItems = roundWords.filter((w) => wrongArs.has(w.ar));
  const correctItems = roundWords.filter((w) => !wrongArs.has(w.ar));
  let html = '<div class="wl-hdr">Слова урока — ' + roundWords.length + '</div>';
  if (wrongItems.length) {
    html +=
      '<div style="padding:8px 14px;font-size:11px;font-weight:700;color:var(--red);background:#fff5f5;text-transform:uppercase;letter-spacing:0.5px;">Ошибки — ' +
      wrongItems.length +
      ' слов</div>';
    html += wrongItems
      .map((w) => {
        const typed = w.userAnswer ? '<div style="font-size:12px;color:#888;margin-top:4px;">Вы вводили: <b>' + esc(w.userAnswer) + '</b></div>' : '';
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
  showScreen('screen-results');
}
function backToMenu() {
  showScreen('screen-app');
  switchTab('train');
}
function restartQuiz() {
  startQuiz(false);
}

// FAVORITES / SCORING
async function addFav(ar) {
  if (!App.favorites.includes(ar)) {
    App.favorites.push(ar);
    if (App.username) {
      try {
        await Api.call('update-word-stat', {
          username: App.username,
          password: App.password,
          word_ar: ar,
          is_favorite: true,
          seen_count: App.wordStats[ar]?.seen || 0,
          level: App.wordStats[ar]?.level || 1,
        });
      } catch (e) {
        ErrorLog.capture(e, { source: 'quiz', action: 'add-favorite', word: ar });
      }
    }
  }
}
async function toggleStar() {
  if (!curWord) return;
  const ar = curWord.ar,
    was = App.favorites.includes(ar);
  if (was) App.favorites = App.favorites.filter((w) => w !== ar);
  else App.favorites.push(ar);
  renderFavoriteButton(quizGetEl('star-btn'), !was);
  try {
    await Api.call('update-word-stat', {
      username: App.username,
      password: App.password,
      word_ar: ar,
      is_favorite: !was,
      seen_count: App.wordStats[ar]?.seen || 0,
      level: App.wordStats[ar]?.level || 1,
    });
  } catch (e) {
    ErrorLog.capture(e, { source: 'quiz', action: 'toggle-favorite', word: ar });
  }
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
