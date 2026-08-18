import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const setupSource = fs.readFileSync(new URL('src/training-setup.js', root), 'utf8');
const mainSource = fs.readFileSync(new URL('src/main.js', root), 'utf8');
const dictSource = fs.readFileSync(new URL('src/dict.js', root), 'utf8');
const courseSource = fs.readFileSync(new URL('src/course.js', root), 'utf8');
const quizSource = fs.readFileSync(new URL('src/quiz.js', root), 'utf8');
const stateSource = fs.readFileSync(new URL('src/state.js', root), 'utf8');
const lbSource = fs.readFileSync(new URL('src/lb.js', root), 'utf8');
const streakSource = fs.readFileSync(new URL('src/streak.js', root), 'utf8');
const htmlSource = fs.readFileSync(new URL('index.html', root), 'utf8');
const cssSource = fs.readFileSync(new URL('src/training-setup.css', root), 'utf8');

const V1 = 'Мединский курс (Том 1)';
const V2 = 'Мединский курс (Том 2)';
const V3 = 'Мединский курс (Том 3)';
const V4 = 'Мединский курс (Том 4)';
const volumes = [V1, V2, V3, V4].map((id, index) => ({ id, label: `Том ${index + 1}` }));
const storage = new Map();

const context = {
  console,
  Date,
  Math,
  Map,
  Set,
  Promise,
  crypto,
  App: { username: 'tester', password: null, volume: V1, favorites: [], wordStats: {} },
  Settings: { mode: 'learn', answerCheck: 'learning', qtyNormal: 15, qtyFast: 50 },
  VOLUMES: { med: volumes },
  Dict: {
    byLesson: {
      '1': [{ ar: 'أَوَّلٌ', ru: 'первый', volume: V1, lesson: '1' }],
      '2': [{ ar: 'ثَانٍ', ru: 'второй', volume: V1, lesson: '2' }],
    },
    allWords: [],
  },
  findVolumeById(id) { return volumes.find((volume) => volume.id === id) || null; },
  localStorage: {
    getItem(key) { return storage.get(key) ?? null; },
    setItem(key, value) { storage.set(key, String(value)); },
    removeItem(key) { storage.delete(key); },
  },
  ErrorLog: {
    capture(error) { throw error; },
    invariant(condition, code) { assert.equal(condition, true, code); },
    diagnostic() {},
  },
  document: {
    getElementById() { return null; },
    querySelectorAll() { return []; },
    querySelector() { return null; },
    createElement() { return { classList: { toggle() {} } }; },
  },
  window: { addEventListener() {}, scrollTo() {} },
  alert() {},
  confirm() { return true; },
  setTimeout() { return 1; },
  clearTimeout() {},
  setInterval() { return 1; },
  clearInterval() {},
  shuf(items) { return [...items]; },
  rmH(value) { return String(value || '').normalize('NFD').replace(/[\u064B-\u065F\u0670]/g, ''); },
  esc(value) { return String(value ?? ''); },
  renderFavoriteButton() {},
  setIconLabel() {},
  showScreen() {},
  updateUI() {},
  showXP() {},
  addDailyWord() {},
  Api: { async call() { return {}; } },
};

vm.createContext(context);
vm.runInContext(setupSource, context, { filename: 'src/training-setup.js' });
vm.runInContext(quizSource, context, { filename: 'src/quiz.js' });

vm.runInContext(`
  TrainingSetup.loadedFor = 'tester';
  TrainingSetup.normalSelections = {
    [${JSON.stringify(V1)}]: { learn: ['1'], review: ['2'] }
  };
  TrainingSetup.fastCatalogLoaded = true;
  TrainingSetup.fastCatalog = {
    [${JSON.stringify(V1)}]: buildTrainingVolumeCatalog([
      { ar: 'أَوَّلٌ', ru: 'первый', volume: ${JSON.stringify(V1)}, lesson: '1' },
      { ar: 'مُشْتَرَكٌ', ru: 'общий', volume: ${JSON.stringify(V1)}, lesson: '1' }
    ]),
    [${JSON.stringify(V2)}]: buildTrainingVolumeCatalog([
      { ar: 'ثَانٍ', ru: 'второй', volume: ${JSON.stringify(V2)}, lesson: '1' },
      { ar: 'مُشْتَرَكٌ', ru: 'общий', volume: ${JSON.stringify(V2)}, lesson: '1' }
    ]),
    [${JSON.stringify(V3)}]: buildTrainingVolumeCatalog([]),
    [${JSON.stringify(V4)}]: buildTrainingVolumeCatalog([])
  };
  TrainingSetup.fastSelections = {
    [${JSON.stringify(V1)}]: ['1'],
    [${JSON.stringify(V2)}]: ['1']
  };
  TrainingSetup.quantities = { learn: 1, review: 'all', fast: 3 };
`, context);

const learnWords = vm.runInContext("getTrainingSelectedWords('learn').map((word) => [word.volume, word.lesson, word.ar])", context);
assert.deepEqual(JSON.parse(JSON.stringify(learnWords)), [[V1, '1', 'أَوَّلٌ']], 'ordinary modes must use only the active volume and their own lesson selection');

const reviewWords = vm.runInContext("getTrainingSelectedWords('review').map((word) => word.ar)", context);
assert.deepEqual(Array.from(reviewWords), ['ثَانٍ'], 'each ordinary mode must retain its own lesson selection');

const fastWords = vm.runInContext("getTrainingSelectedWords('fast')", context);
assert.equal(fastWords.length, 3, 'fast selection must combine volumes and remove only exact duplicates');
assert.deepEqual(new Set(Array.from(fastWords, (word) => word.volume)), new Set([V1, V2]), 'fast selection must preserve both source volumes');
assert.equal(vm.runInContext("getTrainingSelectedLessonCount('fast')", context), 2, 'same lesson numbers in different volumes must remain distinct');
assert.equal(vm.runInContext("getTrainingModeLimit('fast', 3)", context), 3, 'the mode-specific quantity must be applied');
vm.runInContext("TrainingSetup.quantities.fast = 'all'", context);
assert.equal(vm.runInContext("getTrainingModeLimit('fast', 137)", context), 137, 'the all-words slider position must track the available pool');

const balanced = vm.runInContext("getBalancedFastQueue(getTrainingSelectedWords('fast'), 3)", context);
assert.equal(balanced.length, 3, 'balanced fast queue must honor the requested quantity');
assert.notEqual(balanced[0].volume, balanced[1].volume, 'fast queue must alternate selected volume/lesson groups when possible');

assert.match(htmlSource, /src\/training-setup\.js/u, 'the training setup module must be loaded');
assert.match(htmlSource, /src\/training-setup\.css/u, 'the training setup stylesheet must be loaded');
assert.match(cssSource, /#tab-train \.sc:has\(#lesson-grid\)/u, 'the old global lesson selector must be hidden before JavaScript initialization');
assert.doesNotMatch(htmlSource, /setLbFilter\('type','streak'/u, 'the separate streak leaderboard control must be absent');
assert.doesNotMatch(lbSource, /type === 'streak'/u, 'the retired streak leaderboard branch must be removed');
assert.match(streakSource, /loadLeaderboardCacheBy\('daily_goals_completed'\)/u, 'the banner rank must use completed daily goals');
assert.match(streakSource, /if \(isDailyGoalSort\) query = query\.order\('streak'/u, 'daily-goal rank ties must use the same streak tiebreaker as the leaderboard');
const resetAppSource = stateSource.match(/function resetApp\(\) \{([\s\S]*?)\n\}/u)?.[1] || '';
assert.match(resetAppSource, /resetDailyGoalState/u, 'logout must clear the previous account daily-goal state');

assert.match(setupSource, /mode === 'fast'.*renderFastTrainingPicker/su, 'fast mode must have a dedicated multi-volume picker');
assert.match(setupSource, /function openTrainingModeSetup\(\)/u, 'the next action must open a dedicated setup page');
assert.match(setupSource, /function closeTrainingModeSetup\(\)/u, 'the setup page must have an explicit return path');
assert.match(setupSource, /training-mode-page-head/u, 'the dedicated setup page must render its own header');
assert.match(setupSource, /tab\.appendChild\(root\)/u, 'the setup page must be a direct child of the training tab, not an inline mode-card panel');
assert.doesNotMatch(setupSource, /insertAdjacentElement\('afterend', root\)/u, 'the setup page must not be inserted below the mode buttons');
assert.match(setupSource, /actions\.appendChild\(startButton\)/u, 'the start action must live inside the selected mode page');
assert.match(setupSource, /difficultCount[\s\S]*favorite\.disabled = unavailable \|\| !difficultCount/u, 'difficult-only start must show its selected-lesson count and disable at zero');
assert.match(htmlSource, /id="training-mode-next"[^>]*hidden[^>]*onclick="openTrainingModeSetup\(\)"/u, 'the mode menu must provide a hidden next action that opens setup');
assert.match(mainSource, /training-mode-next[\s\S]*classList\.remove\('hidden'\)/u, 'selecting a mode must reveal the next action');
assert.doesNotMatch(mainSource, /function setMode[\s\S]*openTrainingModeSetup\(\)/u, 'selecting a mode must wait for the explicit next action');
assert.match(dictSource, /t !== 'train'.*closeTrainingModeSetup/su, 'leaving the training tab must close its setup page');
assert.match(courseSource, /selectVolume[\s\S]*closeTrainingModeSetup/u, 'changing volume must close stale mode setup state');
assert.match(quizSource, /backToMenu[\s\S]*closeTrainingModeSetup/u, 'returning from results must restore the mode menu');
assert.match(cssSource, /#tab-train\.training-mode-page-open > :not\(#training-mode-config\)/u, 'only the setup page must remain visible while a mode is open');
assert.match(cssSource, /#tab-train:not\(\.training-mode-page-open\) > #btn-start/u, 'start controls must not flash on the mode menu before JavaScript moves them');
assert.match(cssSource, /\.training-mode-next[\s\S]*min-height: 48px/u, 'the next action must be visibly tappable on mobile');
assert.match(cssSource, /@media \(max-width: 520px\)[\s\S]*training-mode-page-head/u, 'the dedicated setup page must have a mobile layout');

console.log('Training mode setup regression tests passed.');
