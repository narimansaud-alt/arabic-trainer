import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const helpersSource = fs.readFileSync(new URL('src/helpers.js', root), 'utf8');
const quizSource = fs.readFileSync(new URL('src/quiz.js', root), 'utf8');
const learnSource = fs.readFileSync(new URL('src/learn.js', root), 'utf8');
const htmlSource = fs.readFileSync(new URL('index.html', root), 'utf8');

function fakeElement() {
  return {
    textContent: '',
    innerHTML: '',
    value: '',
    disabled: false,
    style: {},
    dataset: {},
    className: '',
    classList: { add() {}, remove() {}, toggle() {}, contains() { return false; } },
    setAttribute() {},
    addEventListener() {},
    removeEventListener() {},
    appendChild() {},
    focus() {},
    remove() {},
  };
}

const apiCalls = [];
const alerts = [];
const confirms = [];
const context = {
  console,
  Date,
  Math,
  Set,
  Promise,
  crypto,
  Settings: { answerCheck: 'learning', mode: 'review', qtyNormal: 15, qtyFast: 50 },
  App: { username: 'tester', password: null, favorites: [], wordStats: {} },
  Dict: { allWords: [], byLesson: {} },
  Api: { async call(action, payload) { apiCalls.push({ action, payload }); return {}; } },
  ErrorLog: {
    capture(error) { throw error; },
    invariant(condition, code) { assert.equal(condition, true, code); return condition; },
    diagnostic() {},
  },
  localStorage: { getItem() { return null; }, setItem() {} },
  window: { addEventListener() {}, scrollTo() {} },
  document: {
    querySelectorAll(selector) {
      if (selector === '.lesson-pill.active') return [{ dataset: { lesson: '1' } }];
      return [];
    },
    getElementById() { return null; },
    createElement() { return fakeElement(); },
    body: { appendChild() {} },
  },
  alert(message) { alerts.push(message); },
  confirm(message) { confirms.push(message); return true; },
  setTimeout() { return 1; },
  clearTimeout() {},
  setInterval() { return 1; },
  clearInterval() {},
  renderFavoriteButton() {},
  setIconLabel() {},
  saveProgress() {},
  clearProgress() {},
  showScreen() {},
  updateUI() {},
  showXP() {},
  addDailyWord() {},
};
vm.createContext(context);
vm.runInContext(helpersSource, context, { filename: 'src/helpers.js' });
vm.runInContext(quizSource, context, { filename: 'src/quiz.js' });
vm.runInContext('renderQ = function () {}; saveProgress = function () {}; showScreen = function () {};', context);

const check = context.isArabicAnswerCorrect;

assert.equal(check('كُنَّ', 'كُنَّ ، ـكُنَّ', 'strict'), true, 'one ordinary attached-pronoun form must be enough');
assert.equal(check('ـكُنَّ', 'كُنَّ ، ـكُنَّ', 'strict'), true, 'tatweel must never be required');
assert.equal(check('كن', 'كُنَّ ، ـكُنَّ', 'learning'), true, 'learning mode may omit harakats');
assert.equal(check('كن', 'كُنَّ ، ـكُنَّ', 'strict'), false, 'strict mode must still require harakats');
assert.equal(check('تَلَامِيذُ', 'تَلَامِذَةٌ، تَلَامِيذُ', 'strict'), true, 'either comma-separated alternative is valid');
assert.equal(check('أَسِرَّةٌ', 'سُرُرٌ (أَسِرَّةٌ)', 'strict'), true, 'either Arabic parenthetical alternative is valid');
assert.equal(check('خَرَجَ', 'خَرَجَ (у)', 'strict'), true, 'non-Arabic parenthetical notes are not part of the answer');

assert.equal(check('سَافَرَ / يُسَافِرُ', 'سَافَرَ/يُسَافِرُ', 'strict'), true, 'slash pairs accept spaces around the separator');
assert.equal(check('سَافَرَ', 'سَافَرَ/يُسَافِرُ', 'strict'), false, 'both required verb forms must be entered');
assert.equal(check('سافر/يسافر', 'سَافَرَ/يُسَافِرُ', 'learning'), true, 'learning mode accepts an unvocalized verb pair');
assert.equal(check('سافر/يسافر', 'سَافَرَ/يُسَافِرُ', 'strict'), false, 'strict mode checks harakats in both verb forms');
assert.equal(check('رَجَعَ/يَرْجِعُ', 'رَجَعَ (يَرْجِعُ)', 'strict'), true, 'parenthetical verb pairs use the same slash input format');
assert.equal(check('رَجَعَ', 'رَجَعَ (يَرْجِعُ)', 'strict'), false, 'a parenthetical present form is required for verbs');

assert.match(context.getArabicAnswerInputHint('سَافَرَ/يُسَافِرُ'), /обе формы.*прошедшее \/ настоящее-будущее/u);
assert.match(context.getArabicAnswerInputHint('كُنَّ ، ـكُنَّ'), /один из вариантов/u);
assert.match(context.getArabicAnswerInputHint('كُنَّ ، ـكُنَّ'), /«ـ» вводить не нужно/u);
assert.equal(context.getArabicAnswerHintTarget('كُنَّ ، ـكُنَّ'), 'كُنَّ');

const future = new Date(Date.now() + 7 * 86400000).toISOString();
context.Dict.byLesson['1'] = [
  { ar: 'أَوَّلٌ', ru: 'первый' },
  { ar: 'ثَانٍ', ru: 'второй' },
];
context.Dict.allWords = [...context.Dict.byLesson['1']];
context.App.wordStats = {
  'أَوَّلٌ': { level: 4, next: future, seen: 3 },
  'ثَانٍ': { level: 5, next: future, seen: 4 },
};
context.startQuiz(false);
assert.equal(alerts.length, 0, 'review must not show the old no-due-words blocker');
assert.deepEqual(Array.from(vm.runInContext('queue.map((word) => word.ar)', context)), ['أَوَّلٌ', 'ثَانٍ'], 'review must include already completed words');
context.Settings.mode = 'type-ar';
context.App.favorites = ['ثَانٍ'];
context.startQuiz(true);
assert.equal(vm.runInContext('quizMode', context), 'type-ar', 'difficult-only training must preserve the selected mode');
assert.equal(vm.runInContext('sessionOnlyFavorites', context), true, 'difficult-only filter must be retained for replay');
assert.deepEqual(Array.from(vm.runInContext('queue.map((word) => word.ar)', context)), ['ثَانٍ'], 'difficult-only training must contain only marked words');


apiCalls.length = 0;
context.App.favorites = [];
context.App.wordStats = {};
vm.runInContext("curWord = { ar: 'صَعْبٌ', ru: 'трудный' };", context);
await context.updateWordLevel('صَعْبٌ', false);
assert.deepEqual(context.App.favorites, ['صَعْبٌ'], 'a wrong answer must automatically become difficult');
assert.equal(apiCalls.at(-1)?.payload.is_favorite, true, 'automatic difficult status must be persisted with the attempt');

await context.updateWordLevel('صَعْبٌ', true);
assert.deepEqual(context.App.favorites, ['صَعْبٌ'], 'a later correct answer must not silently remove difficult status');
await context.toggleStar();
assert.deepEqual(context.App.favorites, [], 'the star button must manually remove a difficult word');
assert.equal(apiCalls.at(-1)?.payload.is_favorite, false, 'manual removal must be persisted');
await context.toggleStar();
assert.deepEqual(context.App.favorites, ['صَعْبٌ'], 'the star button must manually add a difficult word');
assert.equal(apiCalls.at(-1)?.payload.is_favorite, true, 'manual addition must be persisted');

assert.match(learnSource, /updateWordLevel\(card\.key, false\)/u, 'learn mode errors must use the shared difficult-word path');
context.App.wordStats = { 'ثَابِتٌ': { level: 1, seen: 0, next: null } };
vm.runInContext('sessionIntervalRaised = new Set(); sessionFailedWords = new Set();', context);
await context.updateWordLevel('ثَابِتٌ', true);
await context.updateWordLevel('ثَابِتٌ', true);
assert.equal(context.App.wordStats['ثَابِتٌ'].level, 2, 'one session may raise the SRS interval only once per word');

const restoredCards = vm.runInContext(
  "toSafeLearnCardList([{w:{ar:'عِلْمٌ',ru:'знание'},stage:3,key:'عِلْمٌ'}])",
  context
);
assert.equal(restoredCards.length, 1, 'saved learn cards with nested words must be restorable');
assert.equal(restoredCards[0].stage, 3, 'the learn stage must survive restoration');
assert.equal(restoredCards[0].key, 'عِلْمٌ', 'the learn card key must survive restoration');

vm.runInContext(`
  quizMode = 'fast';
  currentDailyTask = null;
  roundAttempts = 0;
  roundCorrect = 0;
  roundWrong = [];
  roundAttemptedWords = [];
  roundUserAnswers = {};
  lives = 3;
  fastWords = 0;
  curWord = { ar: 'سَرِيعٌ', ru: 'быстрый' };
`, context);
await context.handleFast(fakeElement(), true, 'سَرِيعٌ', false);
vm.runInContext("curWord = { ar: 'بَطِيءٌ', ru: 'медленный' };", context);
await context.handleFast(fakeElement(), false, 'بَطِيءٌ', false);
assert.equal(vm.runInContext('roundAttempts', context), 2, 'fast mode must count every answered card');
assert.equal(vm.runInContext('roundCorrect', context), 1, 'fast mode must count correct answers');
assert.deepEqual(Array.from(vm.runInContext('roundWrong.map((word) => word.ar)', context)), ['بَطِيءٌ'], 'fast mode must retain wrong answers');

context.__finishCalls = 0;
vm.runInContext(`
  finishQuiz = async function () { globalThis.__finishCalls += 1; };
  quizMode = 'fast';
`, context);
context.confirmExit();
assert.equal(confirms.length, 0, 'fast-mode exit must never open a timer-pausing native dialog');
assert.equal(context.__finishCalls, 1, 'fast-mode exit must finish immediately');
vm.runInContext("quizMode = 'review'", context);
context.confirmExit();
assert.equal(confirms.length, 1, 'ordinary modes must retain the exit confirmation');
assert.equal(context.__finishCalls, 2, 'confirmed ordinary exit must finish the session');

assert.match(quizSource, /updateWordLevel\(curWord\.ar, false\)/u, 'quiz errors must use the shared difficult-word path');
assert.match(htmlSource, /id="star-btn"[^>]+onclick="toggleStar\(\)"/u, 'the manual difficult-word button must remain in the quiz card');
assert.match(htmlSource, /id="type-format-hint"/u, 'the writing mode must contain the format hint');

assert.match(learnSource, /setQuizNextButton\(true\)[\s\S]*setTimeout\(\(\) => nextLearnCard\(\), 3000\)/u, 'a wrong learn answer must always expose an enabled continuation path');
assert.match(learnSource, /if \(!inp \|\| inp\.disabled\) return/u, 'learn typing must ignore a second submit');
assert.match(quizSource, /function setQuizNextButton[\s\S]*classList\.remove\('hidden'\)[\s\S]*button\.disabled = !enabled/u, 'the continuation button must stay visible and only change enabled state');
assert.doesNotMatch(quizSource + learnSource, /\b(?:curWord|w)\.userAnswer\b/u, 'answers must not mutate shared dictionary word objects');
assert.match(quizSource, /completedMode === 'fast' \? toSafeWordList\(roundAttemptedWords/u, 'early fast results must include attempted words only');
assert.match(quizSource, /initQuiz\(previous\.words\.map[\s\S]*previous\.mode, previous\.isFav\)/u, 'repeat must preserve the previous mode and difficult-only filter');
assert.match(quizSource, /mode: quizMode/u, 'saved progress must store the effective session mode');
console.log('Training regression tests passed.');
