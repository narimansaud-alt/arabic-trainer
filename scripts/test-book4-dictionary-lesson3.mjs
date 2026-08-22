import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const migration = fs.readFileSync(
  new URL('supabase/migrations/20260822080000_import_book4_dictionary_lesson03.sql', root),
  'utf8'
);
const dictSource = fs.readFileSync(new URL('src/dict.js', root), 'utf8');

const tuplePattern = /\('Мединский курс \(Том 4\)', '3', '([^']*)', '([^']*)', (\d+), '(single|singular|plural)'\)/gu;
const records = [...migration.matchAll(tuplePattern)].map((match) => ({
  ar: match[1],
  ru: match[2],
  lesson: '3',
  dictionaryRow: Number(match[3]),
  dictionaryForm: match[4],
}));

const expected = `
1|single|مُتَوَضَّأٌ|Место омовения
2|single|تَلَقَّى/يَتَلَقَّى|Встретить; получить
3|singular|خَلِيفَةٌ|Наместник, халиф
3|plural|خُلَفَاءُ|Наместники, халифы
4|singular|رَاشِدٌ|Праведный; благоразумный
4|plural|رَاشِدُونَ|Праведные; благоразумные
5|single|تَزَوَّجَ/يَتَزَوَّجُ|Жениться
6|single|تَخَلَّفَ/يَتَخَلَّفُ|Отстать, пропустить
7|singular|وَفَاةٌ|Смерть
7|plural|وَفَيَاتٌ|Смерти
8|single|تُوُفِّيَ|Умер
9|single|تَقَبَّلَ/يَتَقَبَّلُ|Принимать
10|singular|مَعْرَكَةٌ|Битва, сражение
10|plural|مَعَارِكُ|Битвы, сражения
11|singular|دَعْوَةٌ|Призыв, приглашение
11|plural|دَعَوَاتٌ|Призывы, приглашения
12|single|مُتَفَوِّقٌ|Отличник
13|single|مَرَّضَ/يُمَرِّضُ|Ухаживать за больным
14|single|زَوَّجَ/يُزَوِّجُ|Женить, выдать замуж
15|single|تَحَدَّثَ/يَتَحَدَّثُ|Говорить, рассказывать
16|single|تَكَلَّمَ/يَتَكَلَّمُ|Разговаривать, говорить
17|single|تَذَكَّرَ/يَتَذَكَّرُ|Вспомнить
18|single|تَغَدَّى/يَتَغَدَّى|Обедать
19|single|تَعَشَّى/يَتَعَشَّى|Ужинать
20|single|تَمَنَّى/يَتَمَنَّى|Желать
21|single|تَأَنَّى/يَتَأَنَّى|Медлить
22|singular|مَوْضُوعٌ|Положенный; тема, вопрос; выдуманный
22|plural|مَوَاضِيعُ، مَوْضُوعَاتٌ|Положенные; темы, вопросы; выдуманные
23|single|تَأَنٍّ|Медленность, осмотрительность
24|single|نَدَامَةٌ|Сожаление
25|single|تَسَلُّقٌ|Восхождение, подъём
26|singular|وَارِثٌ|Наследник
26|plural|وَرَثَةٌ|Наследники
27|single|مُتَنَفَّسٌ|Отдушина, выход
28|single|خِرِّيجٌ|Выпускник
29|single|تَخَرَّجَ/يَتَخَرَّجُ|Закончить учёбу, выпуститься
30|single|تَوَكَّلَ/يَتَوَكَّلُ|Уповать
31|single|تَنَزَّلَ/يَتَنَزَّلُ|Уступить; нисходить
32|single|تَجَسَّسَ/يَتَجَسَّسُ|Шпионить
33|single|لَمَّا|Когда, после того как; пока не
34|single|تَوَجَّهَ/يَتَوَجَّهُ|Направиться
35|single|أَسْرَعَ/يُسْرِعُ|Поспешить
36|singular|مَعْشَرٌ|Собрание, общество
36|plural|مَعَاشِرُ|Собрания, общества
37|single|بَزَغَ/يَبْزُغُ|Восходить (о солнце, луне)
`.trim().split('\n').map((line) => {
  const [dictionaryRow, dictionaryForm, ar, ru] = line.split('|');
  return { ar, ru, lesson: '3', dictionaryRow: Number(dictionaryRow), dictionaryForm };
});

assert.deepEqual(records, expected, 'lesson 3 migration must exactly match printed lesson 20, pages 166-168');
assert.equal(records.length, 45, 'lesson 3 must contain 45 list/training records');
assert.equal(new Set(records.map((record) => record.dictionaryRow)).size, 37, 'the three photos contain 37 source rows');
assert.equal(records.filter((record) => record.dictionaryForm === 'single').length, 29);
assert.equal(records.filter((record) => record.dictionaryForm === 'singular').length, 8);
assert.equal(records.filter((record) => record.dictionaryForm === 'plural').length, 8);
assert.equal(records.every((record) => record.ar === record.ar.normalize('NFC')), true, 'all Arabic must be NFC-normalized');
assert.equal(records.every((record) => /[\u064B-\u0652]/u.test(record.ar)), true, 'every Arabic entry must retain visible vowel marks');

const expectedPluralRussian = new Map([
  ['خُلَفَاءُ', 'Наместники, халифы'],
  ['رَاشِدُونَ', 'Праведные; благоразумные'],
  ['وَفَيَاتٌ', 'Смерти'],
  ['مَعَارِكُ', 'Битвы, сражения'],
  ['دَعَوَاتٌ', 'Призывы, приглашения'],
  ['مَوَاضِيعُ، مَوْضُوعَاتٌ', 'Положенные; темы, вопросы; выдуманные'],
  ['وَرَثَةٌ', 'Наследники'],
  ['مَعَاشِرُ', 'Собрания, общества'],
]);
for (const [arabic, russian] of expectedPluralRussian) {
  const record = records.find((item) => item.ar === arabic);
  assert.ok(record, `missing plural ${arabic}`);
  assert.equal(record.dictionaryForm, 'plural');
  assert.equal(record.ru, russian);
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
assert.equal(tableRows.length, 37, 'table mode must reproduce all 37 photographed rows');
const topics = tableRows.find((row) => row.singular === 'مَوْضُوعٌ');
assert.deepEqual(
  { plural: topics?.plural, ru: topics?.ru },
  { plural: 'مَوَاضِيعُ، مَوْضُوعَاتٌ', ru: 'Положенный; тема, вопрос; выдуманный' }
);

assert.match(migration, /pages 166-168/u, 'migration must retain the controlling photo page range');
assert.match(migration, /printed lesson 20[\s\S]*application lesson 3/u, 'migration must document the canonical offset');
assert.match(migration, /where not exists \(/u, 'lesson 3 insertion must be safe on a repeated run');
assert.match(migration, /l1_records <> 109/u, 'migration must verify lesson 1 was not changed');
assert.match(migration, /l2_records <> 77/u, 'migration must verify lesson 2 was not changed');
assert.match(migration, /l4_records <> 81/u, 'migration must verify lesson 4 was not changed');
assert.match(migration, /l5_records <> 34/u, 'migration must verify lesson 5 was not changed');

console.log('Book 4 lesson 3 dictionary migration tests passed.');
