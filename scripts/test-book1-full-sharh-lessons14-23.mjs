import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260826120000_full_book1_lessons14_23_sharh_ru.sql', import.meta.url),
  'utf8'
);

const sourceMigrations = [
  '20260812173000_verify_book1_lesson14_from_sharh.sql',
  '20260812180000_verify_book1_lesson15_from_sharh.sql',
  '20260812183000_verify_book1_lessons16_17_from_sharh.sql',
  '20260812190000_verify_book1_lesson18_from_sharh.sql',
  '20260812193000_verify_book1_lessons19_20_from_sharh.sql',
  '20260812200000_verify_book1_lesson21_from_sharh.sql',
  '20260812203000_verify_book1_lessons22_23_from_sharh.sql',
].map((name) => fs.readFileSync(new URL(`../supabase/migrations/${name}`, import.meta.url), 'utf8'));

const sourceSql = sourceMigrations.join('\n');

assert.equal(
  (migration.match(/Полный текст шарха ·/gu) || []).length,
  23,
  'the migration must contain 21 source labels plus two guarded marker checks'
);

for (const [id, pageLabel] of [
  [1525, 'страница 23'], [1526, 'страница 23'], [1530, 'страница 24'],
  [1527, 'страницы 24–25'], [1528, 'страница 25'], [1531, 'страницы 26–27'],
  [1532, 'страница 26'], [1533, 'страница 27'], [1534, 'страница 27'],
  [1535, 'страница 28'], [1537, 'страница 29'], [1538, 'страница 29'],
  [1540, 'страница 30'], [1884, 'страница 30'], [1541, 'страница 31'],
  [1543, 'страница 32'], [1544, 'страница 32'], [1545, 'страницы 33–34'],
  [1546, 'страницы 35–36'], [1547, 'страница 36'], [1548, 'страница 36'],
]) {
  assert.ok(
    migration.includes(`(${id}::bigint, 'Полный текст шарха · ${pageLabel}')`),
    `missing full-sharh source marker for rule ${id}`
  );
}

assert.match(
  migration,
  /replace\(\s*replace\(content, '<table', '<div class="tbl-wrap"><table'\),\s*'<\/table>',\s*'<\/table><\/div>'\s*\)/u,
  'all existing tables must receive internal scroll wrappers'
);

assert.ok(
  migration.includes('<strong>Полный перевод:</strong> Этот урок — повторение некоторых предыдущих уроков.'),
  'lesson 21 must use the direct Russian translation of the author heading'
);
assert.ok(
  migration.includes('<strong>Полный перевод:</strong> к Зайнаб; для Ахмада; из Пакистана; в Лондоне; в Мекке.'),
  'lesson 23 must translate the repeated prepositional examples in place'
);

for (const fragment of [
  'إِضَافَةُ الْأَسْمَاءِ إِلَى ضَمِيرَيِ الْمُخَاطَبِينَ وَالْمُتَكَلِّمِينَ',
  'أَيُّ الطُّلَّابِ',
  'جَدْوَلٌ لِلضَّمَائِرِ الْمُنْفَصِلَةِ',
  'قَبْلَ وَبَعْدَ',
  'الْمُبْتَدَأُ وَالْخَبَرُ',
  'جَمْعُ غَيْرِ الْعَاقِلِ',
  'الْمُثَنَّى',
  'كَمْ : اِسْمُ اسْتِفْهَامٍ',
  'الْعَدَدُ مِنْ ثَلَاثَةٍ إِلَى عَشَرَةٍ',
  'مُرَاجَعَةٌ لِبَعْضِ الدُّرُوسِ السَّابِقَةِ',
  'أَنْوَاعُ الْأَسْمَاءِ الْمَمْنُوعَةِ مِنَ الصَّرْفِ',
  'الْمَجْرُورُ نَوْعَانِ',
]) {
  assert.ok(sourceSql.includes(fragment), `missing source-backed lessons 14-23 fragment: ${fragment}`);
}

assert.doesNotMatch(migration, /insert\s+into\s+public\.rules/iu, 'the completion pass must not create duplicate rule cards');
assert.doesNotMatch(migration, /delete\s+from\s+public\.rules/iu, 'the completion pass must not delete existing rule cards');

console.log('Book 1 lessons 14-23 full sharh checks passed.');
