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
  roundCorrect = 0;
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
  const s = App.wordStats[ar] || {};
  const cur = s.level || 1;
  const nl = ok ? Math.min(cur + 1, 5) : Math.max(cur - 1, 1);
  const nr = getNextReview(nl, ok);
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
    console.log('updateWordLevel failed (will resync on next login)', e);
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
      alert('На сегодня нечего повторять из выбранных уроков! 🎉\nВыберите другие уроки или вернитесь позже.');
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
  hstack = [];
  hidx = -1;
  isHist = false;
  lives = 3;
  fastWords = 0;
  bestStreak = 0;
  hintCount = 0;
  learnPhase = 'intro';
  const mNames = {
    learn: '🌱 Учить новые слова',
    'type-ar': '✍️ Арабский ввод',
    review: '🔄 Обычное повторение',
    mix: '🔀 Микс',
    fast: '⚡ Быстрое повторение',
  };
  document.getElementById('q-mode').textContent = isFav ? '⭐ Трудные слова' : mNames[Settings.mode] || Settings.mode;
  document.getElementById('fast-stats').classList.toggle('hidden', Settings.mode !== 'fast');
  document.getElementById('fast-leader').classList.toggle('hidden', Settings.mode !== 'fast');
  if (Settings.mode === 'fast') {
    updFastUI();
    loadFastLeader();
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
  document.getElementById('q-prog').textContent = qi + 1 + '/' + queue.length;
  document.getElementById('q-bar').style.width = ((qi + 1) / queue.length) * 100 + '%';
  document.getElementById('star-btn').textContent = App.favorites.includes(curWord.ar) ? '⭐' : '☆';
  document.getElementById('feedback').textContent = '';
  document.getElementById('feedback').className = 'feedback';
  document.getElementById('btn-next').classList.add('hidden');
  document.getElementById('btn-next').textContent = 'Дальше →';
  const opts = document.getElementById('opts');
  const typeArea = document.getElementById('type-area');
  opts.classList.add('hidden');
  typeArea.classList.add('hidden');
  opts.innerHTML = '';

  if (isHist) document.getElementById('feedback').innerHTML = '<span style="color:#e67e22">📖 Просмотр</span>';

  document.getElementById('word-card').style.minHeight = '100px';

  if (activeMode === 'type-ar') {
    hintCount = 0;
    document.getElementById('word-display').innerHTML = `<div class="w-ru">${esc(curWord.ru)}</div>`;
    typeArea.classList.remove('hidden');
    const inp = document.getElementById('type-input');
    inp.value = '';
    inp.disabled = false;
    const hintBtn = document.getElementById('btn-hint');
    const hintLbl = document.getElementById('hint-cost-label');
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
    document.getElementById('word-display').innerHTML = `<div class="w-ru">${esc(curWord.ru)}</div>`;
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
    document.getElementById('word-display').innerHTML = isArQ
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
  const pool = shuf(Dict.allWords.filter((w) => w[key] !== correct && rmH(w[key]) !== rmH(correct)));
  const opts = [correct, ...pool.slice(0, 3).map((w) => w[key])];
  while (opts.length < 4) opts.push('—');
  return shuf(opts);
}

async function handleAns(btn, ok, correct, isAr) {
  document.querySelectorAll('.opt').forEach((b) => (b.disabled = true));
  const fb = document.getElementById('feedback');
  if (ok) {
    btn.classList.add('ok');
    let pts = 0;
    if (activeMode === 'ar-ru') pts = 5;
    else if (activeMode === 'ru-ar') pts = 10;
    roundScore += pts;
    roundCorrect++;
    fb.className = 'feedback ok';
    fb.textContent = '✅ Правильно!' + (pts ? ' +' + pts : '');
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
      '❌ Ошибка. Правильно: <span style="' +
      (isAr ? 'font-family:Times New Roman,serif;font-size:22px;direction:rtl;' : '') +
      '">' +
      esc(correct) +
      '</span>';
    updateWordLevel(curWord.ar, false);
    if (!roundWrong.find((w) => w.ar === curWord.ar)) roundWrong.push(curWord);
    document.getElementById('btn-next').classList.remove('hidden');
    pauseTmo = setTimeout(() => nextWord(true), 3000);
  }
}

// HINT for type-ar mode
function showHint() {
  if (!curWord || isHist) return;
  const fullWord = rmH(curWord.ar.replace(/\s*\(.*?\)\s*/g, ''));
  hintCount++;
  const inp = document.getElementById('type-input');
  const revealedPart = fullWord.substring(0, hintCount);
  inp.value = revealedPart;
  inp.focus();
  const penalty = hintCount * 5;
  const remaining = Math.max(0, 20 - penalty);
  const hintBtn = document.getElementById('btn-hint');
  const hintLbl = document.getElementById('hint-cost-label');
  if (hintLbl) hintLbl.textContent = '💡 Показано букв: ' + hintCount + ' | Штраф: −' + penalty + ' | Получите: ' + remaining + ' очков';
  if (hintCount >= fullWord.length) {
    if (hintBtn) {
      hintBtn.disabled = true;
      hintBtn.textContent = '💡 Всё показано';
    }
  } else {
    if (hintBtn) hintBtn.textContent = '💡 Ещё буква (−5 очков)';
  }
}

function checkTyped() {
  if (isHist) return;
  if (Settings.mode === 'learn') {
    checkTypedLearn();
    return;
  }
  const val = rmH(document.getElementById('type-input').value.trim());
  const correct = rmH(curWord.ar.replace(/\s*\(.*?\)\s*/g, ''));
  const fb = document.getElementById('feedback');
  document.getElementById('type-input').disabled = true;
  const hintBtn = document.getElementById('btn-hint');
  if (hintBtn) hintBtn.style.display = 'none';
  const hintLbl = document.getElementById('hint-cost-label');
  if (hintLbl) hintLbl.textContent = '';
  if (val === correct) {
    const penalty = hintCount * 5;
    const pts = Math.max(0, 20 - penalty);
    fb.className = 'feedback ok';
    fb.textContent = hintCount > 0 ? '✅ Правильно! +' + pts + ' (−' + penalty + ' за подсказки)' : '✅ Правильно! +20';
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
      '❌ Ошибка. Правильно: <span style="font-family:Times New Roman,serif;font-size:22px;direction:rtl;">' + esc(curWord.ar) + '</span>';
    updateWordLevel(curWord.ar, false);
    if (!roundWrong.find((w) => w.ar === curWord.ar)) roundWrong.push(curWord);
    document.getElementById('btn-next').classList.remove('hidden');
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
  const el = document.getElementById('fs-timer');
  el.textContent = timeLeft;
  el.className = 'fs-val' + (timeLeft <= 3 ? ' danger' : '');
}
async function loadFastLeader() {
  // Public leaderboard read — see lb.js note on the `leaderboard` view.
  const { data } = await db.from('leaderboard').select('nickname,fast_mode_high_score').order('fast_mode_high_score', { ascending: false }).limit(1);
  if (data && data.length && data[0].fast_mode_high_score > 0) {
    document.getElementById('fast-leader-text').textContent = 'Рекорд: ' + data[0].nickname + ' — ' + data[0].fast_mode_high_score + ' слов';
  }
}
function updFastUI() {
  document.getElementById('fs-lives').textContent = '❤️'.repeat(Math.max(0, lives)) + '🖤'.repeat(Math.max(0, 3 - lives));
  document.getElementById('fs-words').textContent = fastWords;
}

async function handleFast(btn, ok, correct, isTimeout) {
  clearTimers();
  document.querySelectorAll('.opt').forEach((b) => {
    b.disabled = true;
    if (b.textContent === correct) b.classList.add('ok');
    else if (b === btn) b.classList.add('err');
  });
  updateWordLevel(curWord.ar, ok);
  const fb = document.getElementById('feedback');
  if (ok) {
    fastWords++;
    bestStreak = Math.max(bestStreak, fastWords);
    updFastUI();
    fb.className = 'feedback ok';
    fb.textContent = '✅ Серия: ' + fastWords;
    addDailyWord();
    pauseTmo = setTimeout(() => nextWord(true), 700);
  } else {
    lives--;
    updFastUI();
    addFav(curWord.ar);
    fb.className = 'feedback err';
    fb.innerHTML = '❌ ' + (isTimeout ? 'Время!' : 'Ошибка!') + ' <span style="font-family:Times New Roman,serif;font-size:22px;direction:rtl;">' + esc(correct) + '</span>';
    if (lives <= 0) {
      if (fastWords > (App.survivalRecord || 0)) {
        App.survivalRecord = fastWords;
        try {
          await Api.call('update-survival-record', { username: App.username, password: App.password, survival_record: fastWords });
        } catch (e) {
          /* non-fatal */
        }
      }
      fb.innerHTML += '<br><b style="color:var(--red)">💀 Лучшая серия: ' + fastWords + ' слов</b>';
      document.getElementById('btn-next').textContent = 'Результаты →';
      document.getElementById('btn-next').classList.remove('hidden');
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
  if (Settings.mode === 'learn') {
    if (!learnCards.length) return;
    localStorage.setItem(
      'arabic_progress',
      JSON.stringify({
        isLearn: true,
        learnCards,
        learnCardIdx,
        learnDoneWords,
        roundScore,
        roundWords,
        roundWrong,
        roundCorrect,
        mode: Settings.mode,
        volume: App.volume,
      })
    );
    return;
  }
  if (!queue.length) return;
  localStorage.setItem(
    'arabic_progress',
    JSON.stringify({ queue, qi, roundScore, roundWords, roundWrong, roundCorrect, mode: Settings.mode, activeMode, volume: App.volume, lives, fastWords, bestStreak })
  );
}
function clearProgress() {
  localStorage.removeItem('arabic_progress');
}
async function restoreProgress() {
  const s = localStorage.getItem('arabic_progress');
  if (!s) return false;
  try {
    const p = JSON.parse(s);
    const mNames = {
      learn: '🌱 Учить новые слова',
      'type-ar': '✍️ Арабский ввод',
      review: '🔄 Обычное повторение',
      mix: '🔀 Микс',
      fast: '⚡ Быстрое повторение',
    };
    if (p.isLearn) {
      if (!p.learnCards || !p.learnCards.length || p.learnCardIdx >= p.learnCards.length) {
        clearProgress();
        return false;
      }
      const doneSoFar = (p.learnDoneWords || []).length;
      const totalWords = (p.roundWords || []).length;
      if (!confirm('Продолжить незавершённый урок (' + doneSoFar + '/' + totalWords + ' слов выучено, +' + p.roundScore + ' очков)?')) {
        clearProgress();
        return false;
      }
      Settings.mode = 'learn';
      learnCards = p.learnCards;
      learnCardIdx = p.learnCardIdx;
      learnDoneWords = p.learnDoneWords || [];
      roundScore = p.roundScore;
      roundWords = p.roundWords;
      roundWrong = p.roundWrong || [];
      roundCorrect = p.roundCorrect || 0;
      if (p.volume) App.volume = p.volume;
      document.getElementById('q-mode').textContent = mNames.learn;
      document.getElementById('fast-stats').classList.add('hidden');
      document.getElementById('fast-leader').classList.add('hidden');
      showScreen('screen-quiz');
      nextLearnCard(false);
      return true;
    }
    if (!p.queue || !p.queue.length || p.qi >= p.queue.length) {
      clearProgress();
      return false;
    }
    if (!confirm('Продолжить незавершённый урок (' + p.qi + '/' + p.queue.length + ' слов, +' + p.roundScore + ' очков)?')) {
      clearProgress();
      return false;
    }
    queue = p.queue;
    qi = p.qi;
    roundScore = p.roundScore;
    roundWords = p.roundWords;
    roundWrong = p.roundWrong || [];
    roundCorrect = p.roundCorrect;
    Settings.mode = p.mode;
    lives = p.lives || 3;
    fastWords = p.fastWords || 0;
    bestStreak = p.bestStreak || 0;
    if (p.volume) App.volume = p.volume;
    learnPhase = 'test';
    document.getElementById('q-mode').textContent = mNames[Settings.mode] || Settings.mode;
    document.getElementById('fast-stats').classList.toggle('hidden', Settings.mode !== 'fast');
    document.getElementById('fast-leader').classList.toggle('hidden', Settings.mode !== 'fast');
    if (Settings.mode === 'fast') {
      updFastUI();
      loadFastLeader();
    }
    curWord = queue[qi];
    activeMode =
      p.activeMode ||
      (Settings.mode === 'fast'
        ? 'ru-ar-fast'
        : Settings.mode === 'mix'
        ? ['ar-ru', 'ru-ar', 'type-ar'][Math.floor(Math.random() * 3)]
        : Settings.mode === 'review'
        ? ['ar-ru', 'ru-ar'][Math.floor(Math.random() * 2)]
        : Settings.mode);
    hstack = [{ w: curWord, am: activeMode, idx: qi, phase: learnPhase }];
    hidx = 0;
    isHist = false;
    showScreen('screen-quiz');
    renderQ();
    return true;
  } catch (e) {
    clearProgress();
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
      /* non-fatal */
    }
  }
  document.getElementById('r-pts').textContent = roundScore;
  document.getElementById('r-total').textContent = roundWords.length;
  document.getElementById('r-correct').textContent = roundCorrect;
  document.getElementById('res-title').textContent = Settings.mode === 'fast' ? '⚡ Быстрое повторение!' : '🎉 Урок завершён!';
  const box = document.getElementById('res-word-list');
  const wrongArs = new Set(roundWrong.map((w) => w.ar));
  const wrongItems = roundWords.filter((w) => wrongArs.has(w.ar));
  const correctItems = roundWords.filter((w) => !wrongArs.has(w.ar));
  let html = '<div class="wl-hdr">📋 Слова урока — ' + roundWords.length + '</div>';
  if (wrongItems.length) {
    html +=
      '<div style="padding:8px 14px;font-size:11px;font-weight:700;color:var(--red);background:#fff5f5;text-transform:uppercase;letter-spacing:0.5px;">❌ Ошибки — ' +
      wrongItems.length +
      ' слов</div>';
    html += wrongItems
      .map((w) => `<div class="wl-item" style="background:#fff5f5;border-left:3px solid var(--red);"><span class="wl-ar">${esc(w.ar)}</span><span class="wl-ru">${esc(w.ru)}</span></div>`)
      .join('');
  }
  if (correctItems.length) {
    html +=
      '<div style="padding:8px 14px;font-size:11px;font-weight:700;color:var(--green);background:var(--green-light);text-transform:uppercase;letter-spacing:0.5px;">✅ Правильно — ' +
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
        /* non-fatal */
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
  document.getElementById('star-btn').textContent = !was ? '⭐' : '☆';
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
    /* non-fatal */
  }
}
async function logPts(pts) {
  if (!App.username) return;
  App.totalScore = (App.totalScore || 0) + pts;
  updateUI();
  showXP(pts);
  try {
    await Api.call('log-score', { username: App.username, password: App.password, points: pts, course_name: App.volume });
  } catch (e) {
    console.log('logPts failed (score will be out of sync until next login)', e);
  }
}
