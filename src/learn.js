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
  if (ok) {
    if (card.stage >= LEARN_STAGE_COUNT - 1) {
      learnDoneWords.push(card.w);
      roundCorrect++;
      learnRemoveAndMaybeReinsert(null, 0);
    } else {
      card.stage++;
      const ahead = card.stage === LEARN_STAGE_COUNT - 1 ? LEARN_REINSERT_OK + 3 : LEARN_REINSERT_OK;
      learnRemoveAndMaybeReinsert(card, ahead);
    }
    updateWordLevel(card.key, true);
  } else {
    if (!roundWrong.find((w) => w.ar === card.key)) roundWrong.push(card.w);
    learnRemoveAndMaybeReinsert(card, LEARN_REINSERT_ERR);
    updateWordLevel(card.key, false);
  }
  addDailyWord();
}

function renderLearnQ() {
  const doneCount = learnDoneWords.length;
  document.getElementById('q-prog').textContent = doneCount + '/' + roundWords.length;
  document.getElementById('q-bar').style.width = (roundWords.length ? (doneCount / roundWords.length) * 100 : 0) + '%';
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

  const stage = curLearnCard.stage;

  if (stage === 0) {
    document.getElementById('word-card').style.minHeight = '140px';
    document.getElementById('word-display').innerHTML = `
      <div style="width:100%">
        <div class="learn-intro-ar">${esc(curWord.ar)}</div>
        <div class="learn-intro-ru">${esc(curWord.ru)}</div>
        <div class="learn-intro-hint">Запомни — дальше будет несколько проверок ✍️</div>
      </div>`;
    document.getElementById('btn-next').classList.remove('hidden');
    document.getElementById('btn-next').textContent = 'Запомнил, дальше →';
    return;
  }

  document.getElementById('word-card').style.minHeight = '100px';

  if (stage === 3) {
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
    setTimeout(() => inp.focus(), 80);
    return;
  }

  const isArQ = stage === 1 || stage === 4;
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
      handleLearnAns(btn, opt === correct, correct, !isArQ);
    };
    opts.appendChild(btn);
  });
}

async function handleLearnAns(btn, ok, correct, isAr) {
  document.querySelectorAll('.opt').forEach((b) => (b.disabled = true));
  const fb = document.getElementById('feedback');
  const stage = curLearnCard.stage;
  if (ok) {
    btn.classList.add('ok');
    let pts = stage === 2 ? 10 : 5;
    roundScore += pts;
    fb.className = 'feedback ok';
    fb.textContent = '✅ Правильно!' + (pts ? ' +' + pts : '');
    if (pts) logPts(pts);
    learnStageAdvance(true);
    pauseTmo = setTimeout(() => nextLearnCard(), 800);
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
    learnStageAdvance(false);
    document.getElementById('btn-next').classList.remove('hidden');
    pauseTmo = setTimeout(() => nextLearnCard(), 3000);
  }
}

function checkTypedLearn() {
  if (isHist) return;
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
    if (pts > 0) logPts(pts);
    learnStageAdvance(true);
    pauseTmo = setTimeout(() => nextLearnCard(), 800);
  } else {
    fb.className = 'feedback err';
    fb.innerHTML =
      '❌ Ошибка. Правильно: <span style="font-family:Times New Roman,serif;font-size:22px;direction:rtl;">' + esc(curWord.ar) + '</span>';
    learnStageAdvance(false);
    document.getElementById('btn-next').classList.remove('hidden');
    pauseTmo = setTimeout(() => nextLearnCard(), 3000);
  }
}

function goNextLearn() {
  clearTimers();
  if (curLearnCard.stage === 0) {
    curLearnCard.stage = 1;
    renderLearnQ();
    return;
  }
  nextLearnCard();
}
