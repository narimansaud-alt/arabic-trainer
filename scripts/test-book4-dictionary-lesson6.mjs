import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const migration = fs.readFileSync(
  new URL('supabase/migrations/20260822090000_import_book4_dictionary_lesson06.sql', root),
  'utf8'
);
const dictSource = fs.readFileSync(new URL('src/dict.js', root), 'utf8');

const tuplePattern = /\('Мединский курс \(Том 4\)', '6', '([^']*)', '([^']*)', (\d+), '(single|singular|plural)'\)/gu;
const records = [...migration.matchAll(tuplePattern)].map((match) => ({
  ar: match[1],
  ru: match[2],
  lesson: '6',
  dictionaryRow: Number(match[3]),
  dictionaryForm: match[4],
}));

const expected = `
1|single|اِقْتِرَاحٌ|Предложение, идея
2|single|تَعْمِيمٌ|Обобщение; распространение
3|single|مُكْتَظٌّ|Переполненный
4|single|اِنْتَقَلَ/يَنْتَقِلُ|Переехать, перейти
5|singular|طَابِقٌ|Этаж
5|plural|طَوَابِقُ|Этажи
6|single|سَدِيدٌ|Правильный, верный
7|single|اِجْتَنَبَ/يَجْتَنِبُ|Сторониться
8|single|اِغْتَابَ/يَغْتَابُ|Сплетничать
9|single|غِيبَةٌ|Сплетня
10|single|اِكْتَفَى/يَكْتَفِي|Ограничиться
11|single|اِقْتَرَبَ/يَقْتَرِبُ|Приблизиться
12|single|فَإِذَا|И вдруг...
13|single|حَقَّ/يَحِقُّ|Надлежать, иметь право
14|single|مُضْطَرٌّ|Вынужденный
15|single|مُفْتَرَقٌ|Место расхождения, перекрёсток
16|single|شَبَّهَ/يُشَبِّهُ|Уподобить
17|single|اِمْتَحَنَ/يَمْتَحِنُ|Испытывать, брать экзамен
18|single|اِجْتَمَعَ/يَجْتَمِعُ|Собраться, встречаться
19|single|اِخْتَارَ/يَخْتَارُ|Выбрать
20|single|اِخْتِيَارٌ|Выбор
21|single|اِنْتَصَرَ/يَنْتَصِرُ|Победить
22|single|وَحَّدَ/يُوَحِّدُ|Быть единым
23|single|وَفَقَ/يَفِقُ|Соответствовать
24|single|اِنْتَشَرَ/يَنْتَشِرُ|Распространиться
25|single|اِرْتَفَعَ/يَرْتَفِعُ|Подняться
26|single|اِمْتَلَأَ/يَمْتَلِئُ|Стать полным
27|single|اِصْطَبَرَ/يَصْطَبِرُ|Терпеть
28|single|اِبْتَسَمَ/يَبْتَسِمُ|Улыбаться
29|single|اِسْتَمَعَ/يَسْتَمِعُ|Слушать, прислушиваться
30|single|الْمُلْتَزَمُ|Место между Черным Камнем и дверью Каабы
31|single|عَابِسٌ|Хмурый
32|single|اِتَّصَلَ/يَتَّصِلُ|Соединиться
33|single|اِتَّجَهَ/يَتَّجِهُ|Направиться
34|single|اِدَّعَى/يَدَّعِي|Притязать, претендовать
35|single|عَضَّ/يَعَضُّ|Кусать
36|singular|خَلِيلٌ|Друг
36|plural|أَخِلَّاءُ|Друзья
37|single|اِصْطَفَى/يَصْطَفِي|Избрать
38|single|اِتَّخَذَ/يَتَّخِذُ|Брать, предпринять, назначать
39|singular|ثُعْبَانٌ|Змея
39|plural|ثَعَابِينُ|Змеи
40|single|مُبِينٌ|Ясный
41|single|حَذِرٌ|Осторожный
42|single|رَزَقَ/يَرْزُقُ|Наделить
43|single|عَبَسَ/يَعْبِسُ|Хмуриться
`.trim().split('\n').map((line) => {
  const [dictionaryRow, dictionaryForm, ar, ru] = line.split('|');
  return { ar, ru, lesson: '6', dictionaryRow: Number(dictionaryRow), dictionaryForm };
});

assert.deepEqual(records, expected, 'lesson 6 migration must exactly match printed lesson 23, pages 177-179');
assert.equal(records.length, 46, 'lesson 6 must contain 46 list/training records');
assert.equal(new Set(records.map((record) => record.dictionaryRow)).size, 43, 'the three photos contain 43 source rows');
assert.equal(records.filter((record) => record.dictionaryForm === 'single').length, 40);
assert.equal(records.filter((record) => record.dictionaryForm === 'singular').length, 3);
assert.equal(records.filter((record) => record.dictionaryForm === 'plural').length, 3);
assert.equal(records.every((record) => record.ar === record.ar.normalize('NFC')), true, 'all Arabic must be NFC-normalized');
assert.equal(records.every((record) => /[\u064B-\u0652]/u.test(record.ar)), true, 'every Arabic entry must retain visible vowel marks');

const expectedPluralRussian = new Map([
  ['طَوَابِقُ', 'Этажи'],
  ['أَخِلَّاءُ', 'Друзья'],
  ['ثَعَابِينُ', 'Змеи'],
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
assert.equal(tableRows.length, 43, 'table mode must reproduce all 43 photographed rows');
assert.deepEqual(
  JSON.parse(JSON.stringify(
    tableRows.filter((row) => row.plural).map((row) => ({ singular: row.singular, plural: row.plural, ru: row.ru }))
  )),
  [
    { singular: 'طَابِقٌ', plural: 'طَوَابِقُ', ru: 'Этаж' },
    { singular: 'خَلِيلٌ', plural: 'أَخِلَّاءُ', ru: 'Друг' },
    { singular: 'ثُعْبَانٌ', plural: 'ثَعَابِينُ', ru: 'Змея' },
  ]
);

assert.match(migration, /pages 177-179/u, 'migration must retain the controlling photo page range');
assert.match(migration, /printed lesson 23[\s\S]*application lesson 6/u, 'migration must document the canonical offset');
assert.match(migration, /where not exists \(/u, 'lesson 6 insertion must be safe on a repeated run');
assert.match(migration, /l1_records <> 109/u, 'migration must verify lesson 1 was not changed');
assert.match(migration, /l2_records <> 77/u, 'migration must verify lesson 2 was not changed');
assert.match(migration, /l3_records <> 45/u, 'migration must verify lesson 3 was not changed');
assert.match(migration, /l4_records <> 81/u, 'migration must verify lesson 4 was not changed');
assert.match(migration, /l5_records <> 34/u, 'migration must verify lesson 5 was not changed');

console.log('Book 4 lesson 6 dictionary migration tests passed.');
