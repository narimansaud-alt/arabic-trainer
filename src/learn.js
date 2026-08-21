// learn.js — LEARN MODE: Memrise-style multi-stage engine.
//
// Each word passes through 5 stages before counting as learned:
//   0 = intro card (see ar+ru, "Запомнил")
//   1 = recognition ar→ru (multiple choice)            → +5
//   2 = recognition ru→ar (multiple choice)             → +10
//   3 = typing ar (type the Arabic word)                → +20 minus hint penalty
//   4 = final recall ar→ru, shown last among all words  → +5
//
// Words are interleaved: after a successful stage, the card moves a few
// positions deeper into the queue rather than repeating immediately —
// this mirrors Memrise's spacing-within-session behaviour. A wrong
// answer keeps the card on the same stage and reinserts it a few
// positions ahead so the word is retried, without disturbing other
// words' progress, exactly like Memrise's "try again soon" behaviour.

const LEARN_STAGE_COUNT = 5;
const LEARN_REINSERT_OK = 3; // how many cards ahead to push a word after a correct stage
const LEARN_REINSERT_ERR = 2; // how many cards ahead to push a word after a wrong stage (sooner retry)

let learnCards = [];
let learnDoneWords = [];
let learnCardIdx = 0;
let curLearnCard = null;

function learnGetEl(id) {
  return document.getElementById(id);
}

// QUEUE MODEL: learnCards holds only the work still remaining this
// session. learnCardIdx always points at the slot that should be
// shown next. The index is NEVER incremented on its own — every
// change to "what's current" happens by removing the just-answered
// card from position learnCardIdx (via splice) and, if it still has
// stages left, reinserting it further ahead. Since the array shrinks
// by one whenever a card is removed, whatever was already sitting
// right after it automatically slides into learnCardIdx — so the
// pointer simply stays put and is re-read on the next render. This
// avoids the earlier bug where the index and the array length could
// drift apart (either through duplicate un-removed cards, or through
// an index that kept incrementing past cards the splice had already
// shifted backward).

function initLearnQueue(words) {
  learnCards = shuf(words).map((w) => ({ w, stage: 0, key: w.ar }));
  learnDoneWords = [];
  learnCardIdx = 0;
}

// Removes the card currently at learnCardIdx and, if `card` is given,
// reinserts it `aheadBy` slots further into the (now one-shorter)
// queue. Pass card=null to drop it permanently (used when a word has
// finished all its stages).
function learnRemoveAndMaybeReinsert(card, aheadBy) {
  learnCards.splice(learnCardIdx, 1);
  if (card) {
    const pos = Math.max(0, Math.min(learnCardIdx + aheadBy, learnCards.length));
    learnCards.splice(pos, 0, card);
  }
}

function nextLearnCard() {
  clearTimers();
  isHist = false;
  if (learnCardIdx >= learnCards.length) {
    finishQuiz();
    return;
  }
  curLearnCard = learnCards[learnCardIdx];
  curWord = curLearnCard.w;
  activeMode = ['intro', 'ar-ru', 'ru-ar', 'type-ar', 'final'][curLearnCard.stage];
  learnPhase = curLearnCard.stage === 0 ? 'intro' : 'test';
  hstack = [{ w: curWord, am: activeMode, idx: learnCardIdx, phase: learnPhase, stage: curLearnCard.stage }];
  hidx = 0;
  saveProgress();
  renderLearnQ();
}

function learnStageAdvance(ok) {
  const card = curLearnCard;
  const completedWord = ok && card.stage >= LEARN_STAGE_COUNT - 1;
  if (ok) {
    if (completedWord) {
      learnDoneWords.push(card.w);
      roundCorrect++;
      learnRemoveAndMaybeReinsert(null, 0);
    } else {
      card.stage++;
      const ahead = card.stage === LEARN_STAGE_COUNT - 1 ? LEARN_REINSERT_OK + 3 : LEARN_REINSERT_OK;
      learnRemoveAndMaybeReinsert(card, ahead);
    }
  } else {
    if (!roundWrong.find((w) => w.ar === card.key)) roundWrong.push(card.w);
    learnRemoveAndMaybeReinsert(card, LEARN_REINSERT_ERR);
  }
  if (completedWord) {
    updateWordLevel(card.key, true);
    countCompletedWordOnce(card.key);
  } else if (!ok) updateWordLevel(card.key, false);
}

function renderLearnQ() {
  const doneCount = learnDoneWords.length;
  const qProg = learnGetEl('q-prog');
  const qBar = learnGetEl('q-bar');
  const starBtn = learnGetEl('star-btn');
  const feedback = learnGetEl('feedback');
  const btnNext = learnGetEl('btn-next');
  const opts = learnGetEl('opts');
  const typeArea = learnGetEl('type-area');
  renderQuizWordSource(curWord);
  if (qProg) qProg.textContent = doneCount + '/' + roundWords.length;
  if (qBar) qBar.style.width = (roundWords.length ? (doneCount / roundWords.length) * 100 : 0) + '%';
  if (starBtn) renderFavoriteButton(starBtn, App.favorites.includes(curWord.ar));
  if (feedback) {
    feedback.textContent = '';
    feedback.className = 'feedback';
  }
  if (btnNext) {
    setQuizNextButton(false);
  }
  if (opts) opts.classList.add('hidden');
  if (typeArea) typeArea.classList.add('hidden');
  renderArabicInputFormatHint('');
  if (opts) opts.innerHTML = '';

  const stage = curLearnCard.stage;

  if (stage === 0) {
    const wordCard = learnGetEl('word-card');
    const wordDisplay = learnGetEl('word-display');
    if (wordCard) wordCard.style.minHeight = '140px';
    if (wordDisplay) {
      wordDisplay.innerHTML = `
      <div style="width:100%">
        <div class="learn-intro-ar">${esc(curWord.ar)}</div>
        <div class="learn-intro-ru">${esc(curWord.ru)}</div>
        <div class="learn-intro-hint">Прочитайте слово и перевод, затем продолжайте.</div>
      </div>`;
    }
    if (btnNext) {
      setQuizNextButton(true, 'Запомнил, дальше →');
    }
    return;
  }

  const wordCard = learnGetEl('word-card');
  if (wordCard) wordCard.style.minHeight = '100px';

  if (stage === 3) {
    hintCount = 0;
    const wordDisplay = learnGetEl('word-display');
    if (wordDisplay) wordDisplay.innerHTML = `<div class="w-ru">${esc(curWord.ru)}</div>`;
    if (typeArea) typeArea.classList.remove('hidden');
    renderArabicInputFormatHint(curWord.ar);
    const inp = learnGetEl('type-input');
    if (!inp) return;
    inp.value = '';
    inp.disabled = false;
    const hintBtn = learnGetEl('btn-hint');
    const hintLbl = learnGetEl('hint-cost-label');
    if (hintBtn) {
      hintBtn.style.display = '';
      hintBtn.disabled = false;
    }
    if (hintLbl) hintLbl.textContent = '';
    setTimeout(() => inp.focus(), 80);
    return;
  }

  const wordDisplay = learnGetEl('word-display');
  if (!wordDisplay) return;

  if (stage === 4) {
    wordDisplay.innerHTML = `<div class="w-ar">${esc(curWord.ar)}</div><div class="w-ru">${esc(curWord.ru)}</div>`;
    if (feedback) {
      feedback.className = 'feedback ok';
      feedback.textContent = 'Запомнил!';
    }
    if (btnNext) {
      setQuizNextButton(true, 'Далее');
    }
    return;
  }

  const isArQ = stage === 1;
  const correct = isArQ ? curWord.ru : curWord.ar;
  if (wordCard) {
    wordDisplay.innerHTML = isArQ ? `<div class="w-ar">${esc(curWord.ar)}</div>` : `<div class="w-ru">${esc(curWord.ru)}</div>`;
  }
  if (opts) opts.classList.remove('hidden');
  genOpts(correct, isArQ ? 'ru' : 'ar').forEach((opt) => {
    const btn = document.createElement('button');
    btn.className = 'opt' + (!isArQ ? ' ar' : '');
    btn.textContent = opt;
    btn.onclick = () => {
      if (!isHist) handleLearnAns(btn, opt === correct, correct, stage === 2);
    };
    if (opts) opts.appendChild(btn);
  });
  return;
}

async function handleLearnAns(btn, ok, correct, isAr) {
  registerQuizAttempt(curWord, btn?.textContent || '');
  const optionButtons = document.querySelectorAll('.opt');
  optionButtons.forEach((b) => (b.disabled = true));
  setQuizNextButton(true);
  const fb = learnGetEl('feedback');
  const stage = curLearnCard.stage;
  if (ok) {
    if (btn) btn.classList.add('ok');
    let pts = stage === 2 ? 10 : 5;
    roundScore += pts;
    if (fb) {
      fb.className = 'feedback ok';
      fb.textContent = 'Правильно' + (pts ? ' +' + pts : '');
    }
    if (pts) logPts(pts);
    learnStageAdvance(true);
    pauseTmo = setTimeout(() => nextLearnCard(), 800);
  } else {
    if (btn) btn.classList.add('err');
    optionButtons.forEach((b) => {
      if (b.textContent === correct) b.classList.add('ok');
    });
    if (fb) {
      fb.className = 'feedback err';
      fb.innerHTML =
        'Неправильно. Правильно: <span class="' +
        (isAr ? 'answer-ar' : '') +
        '"' +
        (isAr ? ' dir="rtl"' : '') +
        '>' +
        esc(correct) +
        '</span>';
    }
    roundUserAnswers[curWord.ar] = btn ? btn.textContent : '';
    learnStageAdvance(false);
    setQuizNextButton(true);
    pauseTmo = setTimeout(() => nextLearnCard(), 3000);
  }
}
function checkTypedLearn() {
  if (isHist) return;
  const inp = learnGetEl('type-input');
  if (!inp || inp.disabled) return;
  const val = inp.value.trim();
  registerQuizAttempt(curWord, val);
  const fb = learnGetEl('feedback');
  inp.disabled = true;
  setQuizNextButton(true);
  const hintBtn = learnGetEl('btn-hint');
  if (hintBtn) hintBtn.style.display = 'none';
  const hintLbl = learnGetEl('hint-cost-label');
  if (hintLbl) hintLbl.textContent = '';
  if (isArabicAnswerCorrect(val, curWord.ar, Settings.answerCheck)) {
    const penalty = hintCount * 5;
    const pts = Math.max(0, 20 - penalty);
    if (fb) {
      fb.className = 'feedback ok';
      fb.textContent = hintCount > 0 ? 'Правильно! +' + pts + ' (−' + penalty + ' за подсказки)' : 'Правильно! +20';
    }
    roundScore += pts;
    if (pts > 0) logPts(pts);
    learnStageAdvance(true);
    pauseTmo = setTimeout(() => nextLearnCard(), 800);
  } else {
    if (fb) {
      fb.className = 'feedback err';
      fb.innerHTML = 'Ошибка. Правильно: <span class="answer-ar" dir="rtl">' + esc(curWord.ar) + '</span>';
    }
    roundUserAnswers[curWord.ar] = val;
    learnStageAdvance(false);
    setQuizNextButton(true);
    pauseTmo = setTimeout(() => nextLearnCard(), 3000);
  }
}
function goNextLearn() {
  if (learnGetEl('btn-next')?.disabled) return;
  clearTimers();
  if (curLearnCard.stage === 0) {
    curLearnCard.stage = 1;
    renderLearnQ();
    return;
  }
  if (curLearnCard.stage === 4) {
    learnStageAdvance(true);
    nextLearnCard();
    return;
  }
  nextLearnCard();
}
