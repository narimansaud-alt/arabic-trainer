import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const migrationPath = new URL('supabase/migrations/20260821060000_import_book4_dictionary_lesson02.sql', root);
const migration = fs.readFileSync(migrationPath, 'utf8');
const dictSource = fs.readFileSync(new URL('src/dict.js', root), 'utf8');

const tuplePattern = /\('Мединский курс \(Том 4\)', '2', '([^']*)', '([^']*)', (\d+), '(single|singular|plural)'\)/gu;
const records = [...migration.matchAll(tuplePattern)].map((match) => ({
  ar: match[1],
  ru: match[2],
  lesson: '2',
  dictionaryRow: Number(match[3]),
  dictionaryForm: match[4],
}));

assert.equal(records.length, 77, 'lesson 2 must contain 77 list/training records');
assert.equal(new Set(records.map((record) => record.dictionaryRow)).size, 64, 'the five photos contain 64 source rows');
assert.equal(records.filter((record) => record.dictionaryForm === 'single').length, 50);
assert.equal(records.filter((record) => record.dictionaryForm === 'singular').length, 13);
assert.equal(records.filter((record) => record.dictionaryForm === 'plural').length, 14);
assert.equal(records.some((record) => /^[فشسقمص]\/َ$/u.test(record.ar)), false, 'old technical placeholders must not survive the replacement');

const byRow = new Map();
for (const record of records) {
  if (!byRow.has(record.dictionaryRow)) byRow.set(record.dictionaryRow, []);
  byRow.get(record.dictionaryRow).push(record);
}
const pairedRows = [...byRow.values()].filter((items) => items.some((item) => item.dictionaryForm === 'singular') && items.some((item) => item.dictionaryForm === 'plural'));
const pluralOnlyRows = [...byRow.values()].filter((items) => items.length === 1 && items[0].dictionaryForm === 'plural');
assert.equal(pairedRows.length, 13, 'all 13 printed singular/plural pairs must remain paired');
assert.deepEqual(pluralOnlyRows.map((items) => items[0].ar), ['أُولُو'], 'أُولُو must remain a plural-only source row');

const expectedPluralRussian = new Map([
  ['مَهَابِطُ', 'Места появления, места посадки'],
  ['ظُنُونٌ', 'Предположения'],
  ['شَاشَاتٌ', 'Экраны, дисплеи'],
  ['بَرَامِجُ', 'Программы'],
  ['خَطَايَا', 'Проступки, грехи'],
  ['مَزَايَا', 'Особенности, привилегии, достоинства'],
  ['زَوَايَا', 'Углы'],
  ['سَرَايَا', 'Отряды'],
  ['ثُلُوجٌ', 'Снега'],
  ['عَنَاكِبُ', 'Пауки'],
  ['عَنَادِلُ', 'Соловьи'],
  ['سَفَارِجُ', 'Айвы'],
  ['عَائِلَاتٌ', 'Семьи'],
  ['أُولُو', 'Обладатели'],
]);
for (const [arabic, russian] of expectedPluralRussian) {
  const record = records.find((item) => item.ar === arabic);
  assert.ok(record, `missing plural ${arabic}`);
  assert.equal(record.dictionaryForm, 'plural', `${arabic} must be marked as plural`);
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
assert.equal(tableRows.length, 64, 'table mode must reproduce all 64 photographed rows');
const pluralOnly = tableRows.find((row) => row.plural === 'أُولُو');
assert.ok(pluralOnly, 'table mode must show أُولُو');
assert.equal(pluralOnly.singular, '', 'plural-only أُولُو must not be invented a singular form');
assert.match(migration, /pages 161-165/u, 'migration must retain the controlling photo page range');
assert.match(migration, /they belong to lesson 2/u, 'migration must document the owner-approved lesson mapping');

const dailySource = fs.readFileSync(new URL('src/daily.js', root), 'utf8');
const priorWords = Array.from({ length: 150 }, (_, index) => ({ ar: `سَابِقٌ-${index + 1}`, ru: `прежнее слово ${index + 1}`, lesson: '1' }));
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
  appDateKey() { return '2026-08-21'; },
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
  goal_date: '2026-08-21',
  course_name: App.volume,
})`, dailyContext);
dailyContext.__dailyRow = dailyRow;
const dailyPlan = vm.runInContext('buildDailyGoalPlan(__dailyRow)', dailyContext);
assert.equal(dailyPlan.tasks.length, 120, 'a 30-minute day must still contain 120 tasks after the import');
assert.equal(new Set(dailyPlan.tasks.map((task) => task.word.ar)).size, 120, 'daily tasks must not duplicate words when the vocabulary is sufficient');
const freshTasks = dailyPlan.tasks.filter((task) => task.category === 'new');
assert.equal(freshTasks.length, 40, 'the balanced 30-minute plan must contain 40 new-word tasks');
assert.equal(freshTasks.every((task) => task.word.lesson === '2'), true, 'unseen lesson 2 words must enter the new-word category');
const pluralDailyTask = freshTasks.find((task) => task.word.ar === 'مَهَابِطُ');
assert.ok(pluralDailyTask, 'the lesson 2 plural مَهَابِطُ must be eligible for the daily plan');
assert.equal(pluralDailyTask.word.ru, 'Места появления, места посадки', 'daily tasks must retain the Russian plural meaning');

console.log('Book 4 lesson 2 dictionary migration tests passed.');