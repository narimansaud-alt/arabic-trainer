import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const printed21Migration = fs.readFileSync(
  new URL('supabase/migrations/20260822061000_import_book4_dictionary_lesson03.sql', root),
  'utf8'
);
const correctionMigration = fs.readFileSync(
  new URL('supabase/migrations/20260822070000_fix_book4_dictionary_numbering_and_import_lesson05.sql', root),
  'utf8'
);
const dictSource = fs.readFileSync(new URL('src/dict.js', root), 'utf8');

function parseRecords(source, lesson) {
  const pattern = new RegExp(
    `\\('Мединский курс \\(Том 4\\)', '${lesson}', '([^']*)', '([^']*)', (\\d+), '(single|singular|plural)'\\)`,
    'gu'
  );
  return [...source.matchAll(pattern)].map((match) => ({
    row: Number(match[3]),
    form: match[4],
    ar: match[1],
    ru: match[2],
  }));
}

const printed21Records = parseRecords(printed21Migration, '3');
assert.equal(printed21Records.length, 81, 'printed lesson 21 source payload must retain all 81 records');
assert.equal(new Set(printed21Records.map((record) => record.row)).size, 65, 'printed lesson 21 must retain 65 source rows');
assert.match(correctionMigration, /printed 18 -> app 1, 19 -> 2, 20 -> 3, 21 -> 4, 22 -> 5/u);
assert.match(correctionMigration, /set lesson_number = '4'[\s\S]*lesson_number = '3'/u, 'printed lesson 21 must move from app lesson 3 to app lesson 4');
assert.match(correctionMigration, /l3_records <> 0/u, 'app lesson 3 must remain empty until printed lesson 20 is supplied');

const lesson5Records = parseRecords(correctionMigration, '5');
const expectedLesson5 = `
1|single|اِنْكَسَرَ/يَنْكَسِرُ|Сломаться, разбиться
2|single|قَبِلَ/يَقْبَلُ|Принять, согласиться
3|single|اِنْقَطَعَ/يَنْقَطِعُ|Быть отрезанным, прерваться
4|single|اِنْقِطَاعٌ|Прекращение, перерыв
5|single|كَهْرَبَاءُ|Электричество
6|single|اِسْتَمَرَّ/يَسْتَمِرُّ|Продолжаться, продолжать
7|single|اِنْقِلَابٌ|Перемена; переворот
8|single|تَوَقَّفَ/يَتَوَقَّفُ|Остановиться
9|single|مُرُورٌ|Движение, течение
10|single|مُنْعَطَفٌ|Переулок; поворот
11|singular|جِسْرٌ|Мост
11|plural|جُسُورٌ|Мосты
12|single|عَنِيفٌ|Жестокий
13|single|اِنْخَلَعَ/يَنْخَلِعُ|Отделиться
14|single|تَكَسَّرَ/يَتَكَسَّرُ|Разбиться
15|single|زُجَاجٌ|Стекло
16|single|اِنْكَسَفَ/يَنْكَسِفُ|Затмеваться
17|single|اِنْجَلَى/يَنْجَلِي|Проясниться
18|single|اِنْصَرَفَ/يَنْصَرِفُ|Удалиться; склоняться (грам.)
19|single|اِنْفَتَحَ/يَنْفَتِحُ|Быть открытым
20|single|اِنْشَقَّ/يَنْشَقُّ|Расколоться
21|single|هَزَمَ/يَهْزِمُ|Разбить, победить
22|single|اِنْهَزَمَ/يَنْهَزِمُ|Проиграть
23|single|اِنْطَفَأَ/يَنْطَفِئُ|Погаснуть
24|single|اِنْفِجَارٌ|Взрыв; извержение
25|single|مُنْصَرِمٌ|Истёкший
26|single|بِضْعَةٌ|Несколько (от 3 до 9 или 10)
27|single|ظَهَرَ/يَظْهَرُ|Появиться
28|single|نَفَعَ/يَنْفَعُ|Принести пользу, быть полезным
29|single|لَوْلَا .... لَـ....|Если бы не..., то бы...
30|single|هَلَكَ/يَهْلِكُ|Погибнуть
31|single|حَيَاءٌ|Стыд, стеснительность
32|single|مُسْتَعْجِلٌ|Спешащий; срочный
33|single|تَوَلَّى/يَتَوَلَّى|Уйти; стать правителем
`.trim().split('\n').map((line) => {
  const [row, form, ar, ru] = line.split('|');
  return { row: Number(row), form, ar, ru };
});

assert.deepEqual(lesson5Records, expectedLesson5, 'lesson 5 migration must exactly match the three supplied photographs');
assert.equal(lesson5Records.length, 34, 'lesson 5 must contain 34 list/training records');
assert.equal(new Set(lesson5Records.map((record) => record.row)).size, 33, 'the three photographs contain 33 source rows');
assert.equal(lesson5Records.filter((record) => record.form === 'single').length, 32);
assert.equal(lesson5Records.filter((record) => record.form === 'singular').length, 1);
assert.equal(lesson5Records.filter((record) => record.form === 'plural').length, 1);
assert.equal(lesson5Records.every((record) => record.ar === record.ar.normalize('NFC')), true, 'all Arabic must be NFC-normalized');
assert.equal(lesson5Records.every((record) => /[\u064B-\u0652]/u.test(record.ar)), true, 'every Arabic entry must retain visible vowel marks');

const bridgePlural = lesson5Records.find((record) => record.form === 'plural');
assert.deepEqual(bridgePlural, { row: 11, form: 'plural', ar: 'جُسُورٌ', ru: 'Мосты' });
assert.equal(
  lesson5Records.some((record) => /^[ابتثجحخدذرزسشصضطظعغفقكلمنهويأإآةى]$/u.test(record.ar) && /^[\u064B-\u0652]$/u.test(record.ru)),
  false,
  'technical letter/haraka placeholders must not survive in lesson 5'
);

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
context.records = lesson5Records.map((record) => ({
  ar: record.ar,
  ru: record.ru,
  lesson: '5',
  dictionaryRow: record.row,
  dictionaryForm: record.form,
}));
const tableRows = vm.runInContext('makeDictBookRows(records)', context);
assert.equal(tableRows.length, 33, 'table mode must reproduce all 33 photographed rows');
assert.equal(tableRows[10].singular, 'جِسْرٌ');
assert.equal(tableRows[10].plural, 'جُسُورٌ');
assert.equal(tableRows[10].ru, 'Мост');

assert.match(correctionMigration, /pages 174-176/u, 'migration must retain the controlling photo page range');
assert.match(correctionMigration, /where not exists \(/u, 'lesson 5 insertion must be safe on a repeated run');
assert.match(correctionMigration, /l1_records <> 109 or l1_rows <> 90/u, 'migration must verify lesson 1 was not changed');
assert.match(correctionMigration, /l2_records <> 77 or l2_rows <> 64/u, 'migration must verify lesson 2 was not changed');

console.log('Book 4 dictionary lesson numbering and lessons 4-5 tests passed.');
