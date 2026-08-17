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
  ErrorLog: { capture(error) { throw error; } },
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
assert.match(quizSource, /updateWordLevel\(curWord\.ar, false\)/u, 'quiz errors must use the shared difficult-word path');
assert.match(htmlSource, /id="star-btn"[^>]+onclick="toggleStar\(\)"/u, 'the manual difficult-word button must remain in the quiz card');
assert.match(htmlSource, /id="type-format-hint"/u, 'the writing mode must contain the format hint');

console.log('Training regression tests passed.');
