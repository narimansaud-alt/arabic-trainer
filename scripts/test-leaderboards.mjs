import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const read = (name) => fs.readFileSync(new URL(name, root), 'utf8');
const lbSource = read('src/lb.js');
const stateSource = read('src/state.js');
const streakSource = read('src/streak.js');
const htmlSource = read('index.html');
const docsSource = read('docs/PROJECT_KNOWLEDGE.md');
const migrationSource = read('supabase/migrations/20260819130000_fix_public_leaderboards.sql');

assert.doesNotMatch(lbSource, /\.from\('score_history'\)/u, 'the browser must never aggregate raw score history');
assert.doesNotMatch(lbSource, /\.slice\(0,\s*15\)/u, 'period rankings must not be truncated in the browser');
assert.match(lbSource, /db\.rpc\('get_public_leaderboard'/u, 'all ranking types must use the canonical public RPC');
assert.match(lbSource, /db\.rpc\('get_public_score_chart'/u, 'the personal chart must use its complete server aggregate');
assert.match(streakSource, /db\.rpc\('get_public_leaderboard'/u, 'the daily-goal banner must use the same canonical ranking');
assert.doesNotMatch(streakSource, /isStreakSort/u, 'the undefined legacy cache variable must stay removed');

assert.match(migrationSource, /date_trunc\('week',[\s\S]*Europe\/Moscow/u, 'the database week must use Moscow time');
assert.match(migrationSource, /after insert or update of[\s\S]*daily_goals_completed,[\s\S]*daily_goal_minutes/u, 'daily-goal changes must refresh the compatibility cache');
assert.match(migrationSource, /rank_no <= v_limit[\s\S]*row_is_current/u, 'the RPC must return the top rows plus the current user');
assert.match(migrationSource, /greatest\([\s\S]*completed\.completed_count/u, 'completed daily plans must repair an undercounted counter');
assert.match(migrationSource, /get_public_score_chart/u, 'the chart RPC must be part of the migration');

assert.match(htmlSource, /«Неделя» — в понедельник в 00:00 по Москве/u, 'the user instruction must explain the weekly boundary');
assert.match(htmlSource, /20 лидеров и твоё настоящее место/u, 'the user instruction must explain personal rank outside the top 20');
assert.match(htmlSource, /тот же календарный день и серия второй раз не увеличатся/u, 'the user instruction must explain additional daily practice');
assert.match(docsSource, /Never aggregate raw `score_history` rows in the browser/u, 'project knowledge must preserve the no-client-aggregation invariant');

const fixedNow = Date.parse('2026-08-19T12:00:00.000Z');
class FixedDate extends Date {
  constructor(...args) {
    super(...(args.length ? args : [fixedNow]));
  }
  static now() { return fixedNow; }
  static UTC(...args) { return Date.UTC(...args); }
  static parse(value) { return Date.parse(value); }
}

const dateContext = {
  Date: FixedDate,
  localStorage: { getItem() { return null; } },
};
vm.createContext(dateContext);
vm.runInContext(stateSource, dateContext, { filename: 'src/state.js' });
assert.equal(
  vm.runInContext("appPeriodStart('day').toISOString()", dateContext),
  '2026-08-18T21:00:00.000Z',
  'a Moscow leaderboard day must start at Moscow midnight'
);
assert.equal(
  vm.runInContext("appPeriodStart('week').toISOString()", dateContext),
  '2026-08-16T21:00:00.000Z',
  'a Moscow leaderboard week must start on Monday'
);
assert.equal(
  vm.runInContext("appPeriodStart('month').toISOString()", dateContext),
  '2026-07-31T21:00:00.000Z',
  'a Moscow leaderboard month must start on its first day'
);

const calls = [];
const container = { innerHTML: '' };
const rowsByType = {
  score: [
    { position: 1, nickname: 'leader', score_value: 9000, streak: 4, daily_goal_minutes: 10, is_current: false },
    { position: 27, nickname: 'Nariman', score_value: 2575, streak: 2, daily_goal_minutes: 10, is_current: true },
  ],
  fast: [
    { position: 1, nickname: 'leader', score_value: 600, streak: 4, daily_goal_minutes: 10, is_current: false },
    { position: 9, nickname: 'Nariman', score_value: 499, streak: 2, daily_goal_minutes: 10, is_current: true },
  ],
  daily: [
    { position: 1, nickname: 'leader', score_value: 4, streak: 5, daily_goal_minutes: 20, is_current: false },
    { position: 3, nickname: 'Nariman', score_value: 2, streak: 2, daily_goal_minutes: 30, is_current: true },
  ],
};
const chartRows = [
  { score_date: '2026-08-13', points: 0 },
  { score_date: '2026-08-14', points: 10 },
  { score_date: '2026-08-15', points: 20 },
  { score_date: '2026-08-16', points: 30 },
  { score_date: '2026-08-17', points: 40 },
  { score_date: '2026-08-18', points: 50 },
  { score_date: '2026-08-19', points: 60 },
];
const leaderboardContext = {
  console,
  Date: FixedDate,
  Promise,
  App: { username: 'Nariman' },
  Settings: { lbFilters: { type: 'score', period: 'month' } },
  db: {
    async rpc(name, args) {
      calls.push({ name, args });
      if (name === 'get_public_score_chart') return { data: chartRows, error: null };
      return { data: rowsByType[args.p_type] || [], error: null };
    },
  },
  document: {
    getElementById(id) { return id === 'lb-content' ? container : null; },
    querySelectorAll() { return []; },
  },
  ErrorLog: { capture(error) { throw error; } },
  esc(value) {
    return String(value ?? '').replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
  },
  appDateKey(date = new FixedDate()) {
    return new Date(date.getTime() + 180 * 60 * 1000).toISOString().slice(0, 10);
  },
};
vm.createContext(leaderboardContext);
vm.runInContext(lbSource, leaderboardContext, { filename: 'src/lb.js' });

await vm.runInContext('loadLB()', leaderboardContext);
assert.equal(calls[0].name, 'get_public_leaderboard');
assert.equal(calls[0].args.p_period, 'month', 'score ranking must preserve the selected period');
assert.equal(calls[0].args.p_username, 'Nariman', 'the server must be able to append the current user true rank');
assert.equal(calls[1].name, 'get_public_score_chart');
assert.match(container.innerHTML, />27\.<\/div>/u, 'the rendered row must preserve the true rank returned by the server');
assert.match(container.innerHTML, /Nariman ← ты/u, 'the current user must be clearly marked');
assert.match(container.innerHTML, /lb-rank-gap/u, 'a non-contiguous personal rank must be visually separated from the top list');

calls.length = 0;
container.innerHTML = '';
leaderboardContext.Settings.lbFilters = { type: 'fast', period: 'week' };
await vm.runInContext('loadLB()', leaderboardContext);
assert.equal(calls.length, 1, 'fast ranking must not request the score chart');
assert.equal(calls[0].args.p_period, 'all', 'fast record is an all-time metric');
assert.match(container.innerHTML, /499 слов/u);

calls.length = 0;
container.innerHTML = '';
leaderboardContext.Settings.lbFilters = { type: 'daily', period: 'day' };
await vm.runInContext('loadLB()', leaderboardContext);
assert.equal(calls.length, 1, 'daily-goal ranking must not request the score chart');
assert.equal(calls[0].args.p_period, 'all', 'completed daily goals are an all-time metric');
assert.match(container.innerHTML, /2 дн\./u);
assert.match(container.innerHTML, /цель: 30 мин\./u, 'the selected daily duration must come from the canonical row');

console.log('Leaderboard regression tests passed.');
