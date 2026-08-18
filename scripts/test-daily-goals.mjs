import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const read = (name) => fs.readFileSync(new URL(name, root), 'utf8');
const dailySource = read('src/daily.js');
const stateSource = read('src/state.js');
const streakSource = read('src/streak.js');
const htmlSource = read('index.html');
const swSource = read('sw.js');
const apiSource = read('supabase/functions/api/index.ts');
const migrationSource = read('supabase/migrations/20260817120000_daily_learning_goals_and_diagnostics.sql');
const manifest = JSON.parse(read('manifest.json'));

const context = {
  console,
  Date,
  Math,
  Set,
  Promise,
  App: {
    username: 'tester',
    volume: 'Мединский курс (Том 1)',
    dailyGoalMinutes: 25,
    dailyGoalSelected: true,
    wordStats: {},
    favorites: [],
    streak: 0,
  },
  Dict: { allWords: [] },
  Api: { async call() { return {}; } },
  ErrorLog: {
    capture(error) { throw error; },
    invariant(condition, code) { assert.equal(condition, true, code); return condition; },
    diagnostic() {},
  },
  localStorage: { getItem() { return null; }, setItem() {}, removeItem() {} },
  document: {
    getElementById() { return null; },
    querySelectorAll() { return []; },
  },
  alert() {},
  appDateKey() { return '2026-08-17'; },
  getDaysLabel(value) { return String(value); },
  loadStreakRank() {},
  updateUI() {},
  loadDict: async () => {},
  initQuiz() {},
};
vm.createContext(context);
vm.runInContext(dailySource, context, { filename: 'src/daily.js' });

assert.deepEqual(
  Array.from(vm.runInContext('DAILY_GOAL_MINUTE_OPTIONS', context)),
  [5, 10, 20, 25, 30],
  'daily minute choices must match the approved set'
);
assert.deepEqual(
  JSON.parse(JSON.stringify(vm.runInContext('dailyGoalTargets(5)', context))),
  { goal_minutes: 5, target_tasks: 10, new_target: 2, review_target: 5, typing_target: 3 },
  'five minutes must produce a balanced ten-task plan'
);
assert.deepEqual(
  JSON.parse(JSON.stringify(vm.runInContext('dailyGoalTargets(25)', context))),
  { goal_minutes: 25, target_tasks: 50, new_target: 10, review_target: 25, typing_target: 15 },
  'twenty-five minutes must scale every task category'
);

context.Dict.allWords = [
  { ar: 'أَوَّلٌ', ru: 'первый' },
  { ar: 'ثَانٍ', ru: 'второй' },
  { ar: 'ثَالِثٌ', ru: 'третий' },
  { ar: 'رَابِعٌ', ru: 'четвёртый' },
  { ar: 'خَامِسٌ', ru: 'пятый' },
  { ar: 'سَادِسٌ', ru: 'шестой' },
];
context.Dict.allWords.push(
  ...Array.from({ length: 74 }, (_, index) => ({
    ar: `كَلِمَةٌ-${index + 7}`,
    ru: `слово ${index + 7}`,
  }))
);
context.App.wordStats = {
  'أَوَّلٌ': { seen: 2, level: 2, next: null },
  'ثَانٍ': { seen: 4, level: 4, next: null },
};
context.App.favorites = ['أَوَّلٌ'];
const plan = vm.runInContext('buildDailyGoalPlan(normalizeDailyGoalRow(dailyGoalTargets(5)))', context);
assert.equal(plan.tasks.length, 10, 'daily plan length must equal the target');
assert.equal(plan.tasks.filter((task) => task.category === 'new').length, 2, 'daily plan must include new-word tasks');
assert.equal(plan.tasks.filter((task) => task.category === 'review').length, 5, 'daily plan must include review tasks');
assert.equal(plan.tasks.filter((task) => task.category === 'typing').length, 3, 'daily plan must include typing tasks');
assert.equal(plan.tasks.filter((task) => task.mode === 'type-ar').length, 3, 'typing tasks must use Arabic input');
assert.equal(plan.version, 3, 'daily plan cache version must invalidate the legacy counted flags');
assert.equal(new Set(plan.tasks.map((task) => task.word.ar)).size, 10, 'a ten-task plan must not repeat words when vocabulary is sufficient');

const sixtyRow = vm.runInContext(`normalizeDailyGoalRow({
  ...dailyGoalTargets(30),
  username: 'tester',
  goal_date: '2026-08-17',
  course_name: App.volume,
})`, context);
const sixtyPlan = context.buildDailyGoalPlan(sixtyRow);
assert.equal(sixtyPlan.tasks.length, 60, 'thirty minutes must always build exactly sixty tasks');
assert.equal(new Set(sixtyPlan.tasks.map((task) => task.word.ar)).size, 60, 'the sixty-task plan must not repeat words across categories');

const stuckRow = vm.runInContext(`normalizeDailyGoalRow({
  ...dailyGoalTargets(30),
  username: 'tester',
  goal_date: '2026-08-17',
  course_name: App.volume,
  new_completed: 12,
  review_completed: 30,
  typing_completed: 14,
})`, context);
const stuckPlan = context.buildDailyGoalPlan(stuckRow);
const formerlyStuckTask = stuckPlan.tasks.find((task) => task.category === 'typing' && task.ordinal === 15);
formerlyStuckTask.__counted = true;
context.__testRow = stuckRow;
context.__testPlan = stuckPlan;
context.__testTask = formerlyStuckTask;
vm.runInContext(`
  DailyGoalState.row = __testRow;
  DailyGoalState.plan = __testPlan;
  DailyGoalState.replay = false;
  applyDailyServerProgress(__testPlan, __testRow);
`, context);
assert.equal('__counted' in formerlyStuckTask, false, 'legacy counted flags must be removed from restored tasks');
assert.equal(formerlyStuckTask.done, false, 'task 57 must remain pending at 56 of 60');
vm.runInContext('markDailyGoalTaskCompleted(__testTask, false)', context);
await vm.runInContext('DailyGoalState.syncing', context);
assert.equal(stuckRow.typing_completed, 15, 'the formerly stuck task must advance progress to 57 of 60');
vm.runInContext('markDailyGoalTaskCompleted(__testTask, false)', context);
assert.equal(stuckRow.typing_completed, 15, 'one task must never be counted twice');

const mergedRow = context.mergeDailyGoalRows(
  { ...stuckRow, typing_completed: 14 },
  { ...stuckRow, typing_completed: 15 }
);
assert.equal(mergedRow.typing_completed, 15, 'a delayed server response must not roll local progress backwards');

const dateContext = { Date, localStorage: { getItem() { return null; } } };
vm.createContext(dateContext);
vm.runInContext(stateSource, dateContext, { filename: 'src/state.js' });
assert.equal(
  vm.runInContext("appDateKey(new Date('2026-08-17T20:59:59.999Z'))", dateContext),
  '2026-08-17',
  'one millisecond before Moscow midnight must belong to the old day'
);
assert.equal(
  vm.runInContext("appDateKey(new Date('2026-08-17T21:00:00.000Z'))", dateContext),
  '2026-08-18',
  'Moscow midnight must start the new day immediately'
);
assert.match(streakSource, /resetDailyGoalForNewDay\(today\)/u, 'midnight reset must reload the daily goal');
assert.match(dailySource, /goal_date: expectedDate/u, 'daily sync must carry the plan date');
assert.match(apiSource, /requestedGoalDate !== moscowDateKey\(\)/u, 'server must reject a stale pre-midnight plan');

assert.equal(manifest.name, manifest.short_name, 'PWA full and short names must stay identical');
assert.equal(manifest.id, './', 'PWA identity id must stay stable');
assert.equal((swSource.match(/'\.\/src\/daily\.js'/g) || []).length, 2, 'daily module must be in both service-worker cache strategies');
assert.match(htmlSource, /id="daily-goal-choice-overlay"/u, 'first-login daily-goal dialog must exist');
assert.match(htmlSource, /id="daily-goal-settings"/u, 'daily goal must be changeable in settings');
assert.match(htmlSource, /setLbFilter\('type','daily'/u, 'daily-goal leaderboard control must exist');
assert.doesNotMatch(htmlSource, /data-minutes="15"/u, 'unapproved 15-minute choice must not be shown');
for (const minutes of [5, 10, 20, 25, 30]) {
  assert.match(htmlSource, new RegExp(`data-minutes="${minutes}"`), `${minutes}-minute choice must be shown`);
}
assert.match(apiSource, /\[5, 10, 20, 25, 30\]\.includes\(minutes\)/u, 'Edge API must accept exactly the approved minute choices');
assert.match(migrationSource, /daily_goal_minutes in \(5, 10, 20, 25, 30\)/u, 'database must enforce the approved minute choices');
assert.match(migrationSource, /sync_user_daily_goal_progress/u, 'daily completion must be synchronized atomically');
assert.match(migrationSource, /last_daily_goal_date is distinct from v_today/u, 'one date may increment the streak only once');

console.log('Daily goal regression tests passed.');
