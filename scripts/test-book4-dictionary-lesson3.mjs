import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const migrationPath = new URL('supabase/migrations/20260822061000_import_book4_dictionary_lesson03.sql', root);
const migration = fs.readFileSync(migrationPath, 'utf8');
const dictSource = fs.readFileSync(new URL('src/dict.js', root), 'utf8');

const tuplePattern = /\('Мединский курс \(Том 4\)', '3', '([^']*)', '([^']*)', (\d+), '(single|singular|plural)'\)/gu;
const records = [...migration.matchAll(tuplePattern)].map((match) => ({
  ar: match[1],
  ru: match[2],
  lesson: '3',
  dictionaryRow: Number(match[3]),
  dictionaryForm: match[4],
}));

assert.equal(records.length, 81, 'lesson 3 must contain 81 list/training records');
assert.equal(new Set(records.map((record) => record.dictionaryRow)).size, 65, 'the five photos contain 65 source rows');
assert.equal(records.filter((record) => record.dictionaryForm === 'single').length, 49);
assert.equal(records.filter((record) => record.dictionaryForm === 'singular').length, 16);
assert.equal(records.filter((record) => record.dictionaryForm === 'plural').length, 16);
assert.equal(records.some((record) => /^[تعص]$/u.test(record.ar) && record.ru === 'َ'), false, 'old technical placeholders must not survive the replacement');

const byRow = new Map();
for (const record of records) {
  if (!byRow.has(record.dictionaryRow)) byRow.set(record.dictionaryRow, []);
  byRow.get(record.dictionaryRow).push(record);
}
assert.deepEqual([...byRow.keys()], Array.from({ length: 65 }, (_, index) => index + 1), 'source rows must remain in exact photographed order');
const pairedRows = [...byRow.values()].filter((items) => items.some((item) => item.dictionaryForm === 'singular') && items.some((item) => item.dictionaryForm === 'plural'));
assert.equal(pairedRows.length, 16, 'all 16 printed singular/plural pairs must remain paired');

const expectedPluralRussian = new Map([
  [6, ['أَلْعَابٌ', 'Игры']],
  [17, ['أَلْقَابٌ', 'Прозвища, титулы']],
  [18, ['حُجُرَاتٌ', 'Комнаты']],
  [21, ['أَفْكَارٌ', 'Мысли']],
  [26, ['أَنْبَاءٌ', 'Вести']],
  [32, ['آثَامٌ', 'Грехи']],
  [34, ['شُعُوبٌ', 'Народы']],
  [35, ['قَبَائِلُ', 'Племена']],
  [38, ['أَجْنِحَةٌ', 'Крылья']],
  [41, ['أَضْرَارٌ', 'Виды вреда']],
  [44, ['عُرْجٌ', 'Хромые']],
  [45, ['عُرْجٌ', 'Хромые']],
  [56, ['خُطُوَاتٌ', 'Шаги']],
  [57, ['شُرَفٌ', 'Балконы']],
  [58, ['أَسَالِيبُ', 'Способы, стили, манеры']],
  [64, ['أَنْكَالٌ', 'Оковы; удила']],
]);
for (const [dictionaryRow, [arabic, russian]] of expectedPluralRussian) {
  const record = byRow.get(dictionaryRow)?.find((item) => item.dictionaryForm === 'plural');
  assert.ok(record, `missing plural in source row ${dictionaryRow}`);
  assert.equal(record.ar, arabic, `source row ${dictionaryRow} must retain its printed plural`);
  assert.equal(record.ru, russian, `${arabic} must have a Russian plural meaning in list mode`);
}

function extractFunction(source, name) {
  const start = source.indexOf(`function ${name}(`);
  assert.notEqual(start, -1, `missing ${name}`);
  const bodyStart = source.indexOf('{', start);
  let depth = 0;
  for (let index = bodyStart; index < source.length; index++) {
    if (source[index] === '{') depth++;
    if (source[index] === '}') {
      depth--;
      if (depth === 0) return source.slice(start, index + 1);
    }
  }
  throw new Error(`unterminated ${name}`);
}

const context = { Number };
vm.createContext(context);
vm.runInContext(extractFunction(dictSource, 'makeDictBookRows'), context, { filename: 'src/dict.js#makeDictBookRows' });
context.records = records;
const tableRows = vm.runInContext('makeDictBookRows(records)', context);
assert.equal(tableRows.length, 65, 'table mode must reproduce all 65 photographed rows');
assert.equal(tableRows[43]?.plural, 'عُرْجٌ', 'masculine adjective row must retain عُرْجٌ');
assert.equal(tableRows[44]?.plural, 'عُرْجٌ', 'feminine adjective row must retain the same printed plural عُرْجٌ');
assert.match(migration, /pages 169-173/u, 'migration must retain the controlling photo page range');
assert.match(migration, /they belong to lesson 3/u, 'migration must document the owner-approved lesson mapping');

const dailySource = fs.readFileSync(new URL('src/daily.js', root), 'utf8');
const priorWords = Array.from({ length: 160 }, (_, index) => ({ ar: `سَابِقٌ-${index + 1}`, ru: `прежнее слово ${index + 1}`, lesson: '1' }));
const dailyContext = {
  console,
  Date,
  Math,
  Set,
  Promise,
  App: {
    username: 'tester',
    volume: 'Мединский курс (Том 4)',
    dailyGoalMinutes: 30,
    dailyGoalSelected: true,
    favorites: [],
    wordStats: Object.fromEntries(priorWords.map((word) => [word.ar, { seen: 3, level: 3, next: null }])),
  },
  Dict: { allWords: [...priorWords, ...records] },
  Api: { async call() { return {}; } },
  ErrorLog: {
    capture(error) { throw error; },
    invariant(condition, code) { assert.equal(condition, true, code); return condition; },
    diagnostic() {},
  },
  localStorage: { getItem() { return null; }, setItem() {}, removeItem() {} },
  document: { getElementById() { return null; }, querySelectorAll() { return []; } },
  window: { addEventListener() {} },
  alert() {},
  appDateKey() { return '2026-08-22'; },
  getDaysLabel(value) { return String(value); },
  loadStreakRank() {},
  updateUI() {},
  loadDict: async () => {},
  initQuiz() {},
};
vm.createContext(dailyContext);
vm.runInContext(dailySource, dailyContext, { filename: 'src/daily.js' });
const dailyRow = vm.runInContext(`normalizeDailyGoalRow({
  ...dailyGoalTargets(30),
  username: 'tester',
  goal_date: '2026-08-22',
  course_name: App.volume,
})`, dailyContext);
dailyContext.__dailyRow = dailyRow;
const dailyPlan = vm.runInContext('buildDailyGoalPlan(__dailyRow)', dailyContext);
assert.equal(dailyPlan.tasks.length, 120, 'a 30-minute day must still contain 120 tasks after the import');
assert.equal(new Set(dailyPlan.tasks.map((task) => task.word.ar)).size, 120, 'daily tasks must not duplicate words when the vocabulary is sufficient');
assert.deepEqual(
  ['new', 'review', 'typing'].map((category) => dailyPlan.tasks.filter((task) => task.category === category).length),
  [40, 40, 40],
  'a 30-minute day must split evenly among new, review, and typing tasks'
);
const freshTasks = dailyPlan.tasks.filter((task) => task.category === 'new');
assert.equal(freshTasks.every((task) => task.word.lesson === '3'), true, 'unseen lesson 3 words must enter the new-word category');
const pluralDailyTask = freshTasks.find((task) => task.word.ar === 'أَلْعَابٌ');
assert.ok(pluralDailyTask, 'the lesson 3 plural أَلْعَابٌ must be eligible for the daily plan');
assert.equal(pluralDailyTask.word.ru, 'Игры', 'daily tasks must retain the Russian plural meaning');

console.log('Book 4 lesson 3 dictionary migration tests passed.');
