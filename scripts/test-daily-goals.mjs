import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const read = (name) => fs.readFileSync(new URL(name, root), 'utf8');
const dailySource = read('src/daily.js');
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
  },
  localStorage: { getItem() { return null; }, setItem() {} },
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
