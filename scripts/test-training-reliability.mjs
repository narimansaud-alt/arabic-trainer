import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const apiSource = fs.readFileSync(new URL('src/api.js', root), 'utf8');
const helpersSource = fs.readFileSync(new URL('src/helpers.js', root), 'utf8');
const quizSource = fs.readFileSync(new URL('src/quiz.js', root), 'utf8');
const mainSource = fs.readFileSync(new URL('src/main.js', root), 'utf8');

function response(status, body) {
  return {
    ok: status >= 200 && status < 300,
    status,
    async text() { return JSON.stringify(body); },
  };
}

const apiContext = {
  console,
  Date,
  Math,
  Set,
  Promise,
  JSON,
  AbortController,
  App: { username: 'tester', password: 'pw', sessionToken: 'session' },
  supabase: { createClient() { return {}; } },
  fetch: async () => response(200, {}),
  navigator: { onLine: true, userAgent: 'test-agent' },
  location: { href: 'https://example.test/' },
  document: {
    documentElement: { dataset: { build: 'test' } },
    visibilityState: 'visible',
    querySelector() { return null; },
    getElementById() { return null; },
    addEventListener() {},
  },
  window: { addEventListener() {}, matchMedia() { return { matches: false }; } },
  localStorage: { getItem() { return null; }, setItem() {} },
  clearStoredAuth() {},
  resetApp() {},
  showScreen() {},
  __runRetryTimers: false,
  setTimeout(callback, delay) {
    if (apiContext.__runRetryTimers && delay <= 1000) queueMicrotask(callback);
    return 1;
  },
  clearTimeout() {},
};
vm.createContext(apiContext);
vm.runInContext(apiSource, apiContext, { filename: 'src/api.js' });
vm.runInContext(`
  globalThis.__capturedErrors = [];
  ErrorLog.capture = function (error, meta) {
    globalThis.__capturedErrors.push({ message: error?.message || String(error), meta });
  };
  ErrorLog.flush = async function () {};
`, apiContext);
apiContext.__runRetryTimers = true;

const retryBodies = [];
apiContext.fetch = async (_url, options) => {
  retryBodies.push(JSON.parse(options.body));
  if (retryBodies.length < 3) throw new Error('temporary network failure');
  return response(200, { total_score: 15 });
};
const retryResult = await vm.runInContext("Api.call('log-score', { points: 5, score_event_id: 'event-fixed' })", apiContext);
assert.equal(retryResult.total_score, 15, 'retry must eventually return the successful response');
assert.equal(retryBodies.length, 3, 'an idempotent score write must retry twice after transient failures');
assert.deepEqual(new Set(retryBodies.map((body) => body.score_event_id)), new Set(['event-fixed']), 'all score retries must retain one event id');
assert.equal(apiContext.__capturedErrors.length, 0, 'transient failures recovered by retry must not pollute the error log');

let attempts = 0;
apiContext.fetch = async () => {
  attempts++;
  return response(400, { error: 'bad input' });
};
await assert.rejects(vm.runInContext("Api.call('update-word-stat', { word_ar: 'كَلِمَةٌ' })", apiContext), /bad input/u);
assert.equal(attempts, 1, 'HTTP 400 must never retry');
assert.equal(apiContext.__capturedErrors.length, 1, 'a final API failure must be logged once');

attempts = 0;
apiContext.fetch = async () => {
  attempts++;
  throw new Error('offline');
};
await assert.rejects(vm.runInContext("Api.call('login', { username: 'tester', password: 'pw' })", apiContext), /Сеть недоступна/u);
assert.equal(attempts, 1, 'login must not be retried automatically');

apiContext.__capturedErrors.length = 0;
attempts = 0;
apiContext.fetch = async () => {
  attempts++;
  throw new Error('temporary');
};
await assert.rejects(vm.runInContext("Api.call('update-word-stat', { word_ar: 'كَلِمَةٌ' })", apiContext), /Сеть недоступна/u);
assert.equal(attempts, 3, 'an idempotent word-stat write must use all three attempts');
assert.equal(apiContext.__capturedErrors.length, 1, 'three failed attempts must still create one final log entry');
assert.equal(apiContext.__capturedErrors[0].meta.attempts, 3, 'the final log must record the retry count');

function makeClassList(initial = []) {
  const values = new Set(initial);
  return {
    add(...items) { items.forEach((item) => values.add(item)); },
    remove(...items) { items.forEach((item) => values.delete(item)); },
    toggle(item, force) {
      if (force === undefined) force = !values.has(item);
      if (force) values.add(item);
      else values.delete(item);
      return force;
    },
    contains(item) { return values.has(item); },
  };
}

function fakeElement(initialClasses = []) {
  return {
    textContent: '',
    innerHTML: '',
    value: '',
    disabled: false,
    style: {},
    dataset: {},
    className: '',
    classList: makeClassList(initialClasses),
    setAttribute() {},
    addEventListener() {},
    removeEventListener() {},
    appendChild() {},
    focus() {},
    remove() {},
  };
}

const elements = new Map([
  ['btn-next', fakeElement(['hidden'])],
  ['type-input', fakeElement()],
  ['star-btn', fakeElement()],
]);
const quizApiCalls = [];
const quizContext = {
  console,
  Date,
  Math,
  Map,
  Set,
  Promise,
  crypto,
  Settings: { answerCheck: 'learning', mode: 'review', qtyNormal: 15, qtyFast: 50 },
  App: { username: 'tester', password: null, totalScore: 0, volume: 'Мединский курс (Том 1)', favorites: [], wordStats: {} },
  Dict: { allWords: [], byLesson: {} },
  Api: { async call(action, payload) { quizApiCalls.push({ action, payload }); return {}; } },
  ErrorLog: {
    capture(error) { throw error; },
    invariant(condition, code) { assert.equal(condition, true, code); return condition; },
    diagnostic() {},
  },
  document: {
    getElementById(id) { return elements.get(id) || null; },
    querySelectorAll() { return []; },
    querySelector() { return null; },
    createElement() { return fakeElement(); },
    body: { appendChild() {} },
  },
  window: { addEventListener() {}, scrollTo() {} },
  localStorage: { getItem() { return null; }, setItem() {}, removeItem() {} },
  alert() {},
  confirm() { return true; },
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
vm.createContext(quizContext);
vm.runInContext(helpersSource, quizContext, { filename: 'src/helpers.js' });
vm.runInContext(quizSource, quizContext, { filename: 'src/quiz.js' });

const future = new Date(Date.now() + 7 * 86400000).toISOString();
const past = new Date(Date.now() - 86400000).toISOString();
const orderedWords = [
  { ar: 'جَدِيدٌ', ru: 'новый' },
  { ar: 'صَعْبٌ', ru: 'трудный' },
  { ar: 'ضَعِيفٌ', ru: 'слабый' },
  { ar: 'مُسْتَحَقٌّ', ru: 'к повторению' },
  { ar: 'مُجَدْوَلٌ', ru: 'запланированный' },
];
quizContext.App.favorites = ['صَعْبٌ'];
quizContext.App.wordStats = {
  'صَعْبٌ': { seen: 3, level: 4, next: future },
  'ضَعِيفٌ': { seen: 2, level: 1, next: future },
  'مُسْتَحَقٌّ': { seen: 4, level: 4, next: past },
  'مُجَدْوَلٌ': { seen: 5, level: 5, next: future },
};
quizContext.__orderedWords = orderedWords;
const reviewOrder = vm.runInContext("getSmartQueue(__orderedWords, 'all', 'review').map((word) => word.ar)", quizContext);
assert.deepEqual(Array.from(reviewOrder), ['صَعْبٌ', 'ضَعِيفٌ', 'مُسْتَحَقٌّ', 'مُجَدْوَلٌ', 'جَدِيدٌ'], 'review must prioritize difficult, weak and due material before unseen words');
const learnOrder = vm.runInContext("getSmartQueue(__orderedWords, 'all', 'learn').map((word) => word.ar)", quizContext);
assert.deepEqual(Array.from(learnOrder), ['جَدِيدٌ', 'صَعْبٌ', 'ضَعِيفٌ', 'مُسْتَحَقٌّ', 'مُجَدْوَلٌ'], 'learning must introduce unseen words first');

quizContext.Dict.allWords = [{ ar: 'ЧУЖОЕ', ru: 'чужой вариант' }];
quizContext.__sessionWords = [
  { ar: 'أ', ru: 'один' },
  { ar: 'ب', ru: 'два' },
  { ar: 'ج', ru: 'три' },
  { ar: 'د', ru: 'четыре' },
  { ar: 'ه', ru: 'два' },
];
vm.runInContext('sessionInitialWords = __sessionWords; roundWords = __sessionWords; queue = __sessionWords;', quizContext);
const options = vm.runInContext("genOpts('один', 'ru')", quizContext);
assert.deepEqual(new Set(Array.from(options)), new Set(['один', 'два', 'три', 'четыре']), 'answer options must be unique and stay inside the selected pool when it is large enough');
assert.equal(Array.from(options).includes('чужой вариант'), false, 'unselected lessons must not leak into answer options');

const nextButton = elements.get('btn-next');
quizContext.setQuizNextButton(false);
assert.equal(nextButton.classList.contains('hidden'), false, 'Next must remain visible before answering');
assert.equal(nextButton.disabled, true, 'Next must be disabled before answering');
assert.equal(nextButton.textContent, 'Ответьте, чтобы продолжить');
quizContext.setQuizNextButton(true);
assert.equal(nextButton.disabled, false, 'Next must become enabled after an answer');

const input = elements.get('type-input');
input.disabled = true;
vm.runInContext("quizMode = 'type-ar'; isHist = false; roundAttempts = 0; curWord = { ar: 'كَلِمَةٌ', ru: 'слово' };", quizContext);
quizContext.checkTyped();
assert.equal(vm.runInContext('roundAttempts', quizContext), 0, 'a second typed submit must be ignored');
assert.match(mainSource, /typeInput && !typeInput\.disabled[\s\S]*!btnNext\.disabled/u, 'Enter must check once, then use the enabled Next button');

const statResolvers = [];
const statCalls = [];
quizContext.Api.call = (action, payload) => new Promise((resolve) => {
  statCalls.push({ action, payload });
  statResolvers.push(resolve);
});
const firstStat = quizContext.persistWordFavorite('مُتَسَلْسِلٌ', true, 'first-write');
const secondStat = quizContext.persistWordFavorite('مُتَسَلْسِلٌ', false, 'second-write');
await new Promise((resolve) => setImmediate(resolve));
assert.equal(statCalls.length, 1, 'writes for one word must not race');
statResolvers.shift()({});
await new Promise((resolve) => setImmediate(resolve));
assert.equal(statCalls.length, 2, 'the next word write must begin after the previous one finishes');
statResolvers.shift()({});
await Promise.all([firstStat, secondStat]);
assert.equal(statCalls[0].payload.is_favorite, true);
assert.equal(statCalls[1].payload.is_favorite, false, 'the newest favorite state must be written last');
assert.equal('next_review' in statCalls[0].payload, false, 'an unseen favorite must not send a null next_review rejected by the API');
quizContext.ErrorLog.capture = () => {};
quizContext.Api.call = async () => { throw new Error('offline'); };
vm.runInContext("curWord = { ar: 'مُتَعَذِّرٌ', ru: 'не сохранившийся' }; App.favorites = [];", quizContext);
await quizContext.toggleStar();
assert.deepEqual(Array.from(quizContext.App.favorites), [], 'a failed manual favorite write must restore the server-backed local state');
assert.equal(elements.get('star-btn').disabled, false, 'the favorite button must recover after a final save failure');

const scoreResolvers = [];
const scoreCalls = [];
quizContext.Api.call = (action, payload) => new Promise((resolve) => {
  scoreCalls.push({ action, payload });
  scoreResolvers.push(resolve);
});
quizContext.App.totalScore = 0;
const firstScore = quizContext.logPts(5);
const secondScore = quizContext.logPts(10);
await new Promise((resolve) => setImmediate(resolve));
assert.equal(scoreCalls.length, 1, 'score writes must be serialized');
assert.equal(quizContext.App.totalScore, 15, 'optimistic points from both answers must remain visible');
scoreResolvers.shift()({ total_score: 5 });
await new Promise((resolve) => setImmediate(resolve));
assert.equal(scoreCalls.length, 2, 'the second score event must wait for the first response');
assert.equal(quizContext.App.totalScore, 15, 'an older server response must not roll back newer optimistic points');
scoreResolvers.shift()({ total_score: 15 });
await Promise.all([firstScore, secondScore]);
assert.equal(new Set(scoreCalls.map((call) => call.payload.score_event_id)).size, 2, 'separate score events must retain separate idempotency ids');

console.log('Training reliability tests passed.');