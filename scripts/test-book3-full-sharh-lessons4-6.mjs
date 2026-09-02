import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902160000_full_book3_lessons04_06_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(4|5|6)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 4, 'all four lesson 4-6 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 4, 'marker IDs must be unique');

for (const fragment of [
  'قَاوِلٌ؛ قُلِبَتِ الْوَاوُ هَمْزَةً',
  'مُطْمَئِنٌّ',
  'مَبْيُوعٌ؛ نُقِلَتْ حَرَكَةُ الْيَاءِ',
  'مَهْدُوْيٌ؛ اجْتَمَعَتِ الْوَاوُ وَالْيَاءُ',
  'وَمَا ٱللَّهُ بِغَٰفِلٍ عَمَّا تَعۡمَلُونَ',
  'مَا أَنَا بِتَاجِرٍ',
  'مَطَافٌ',
  'الْقِيَاسُ مَفْعَلٌ',
  'مَهْبِطُ الْوَحْيِ فِي مَكَّةَ الْمُكَرَّمَةِ',
  'مُعَسْكَرٌ',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 89'), 'Book 3 counts must be guarded');
assert.match(migration, /book3-full-sharh-batch02/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.(?:rules|rule_sources)/iu, 'must not duplicate rules or sources');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 3 lessons 4-6 full sharh checks passed.');
