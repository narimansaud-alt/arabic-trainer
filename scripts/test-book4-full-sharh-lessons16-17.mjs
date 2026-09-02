import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902210000_full_book4_lessons16_17_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(16|17)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 9, 'all 9 lesson 16-17 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 9, 'marker IDs must be unique');

for (const fragment of [
  'قَرِيبٌ مِنَ الْوَاجِبِ',
  'وَاللَّهِ لَسَوْفَ أَجْتَهِدُ',
  'أَلِفٍ فَاصِلَةٍ',
  'النُّونُ الْمَحْذُوفَةُ لِتَوَالِي الْأَمْثَالِ',
  'إِضْرَابٌ إِبْطَالِيٌّ',
  'إِضْرَابٌ انْتِقَالِيٌّ',
  'لِعِلَّةٍ وَاحِدَةٍ',
  'مَفَاعِلُ وَمَفَاعِيلُ',
  'حَضْرَمَوْتَ، بَعْلَبَكَّ، مَعْدِيكَرِبَ',
  'مَثْنَى وَثُنَاءَ، وَمَثْلَثَ وَثُلَاثَ',
  'التَّنْوِينُ لِلْعِوَضِ',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 106'), 'Book 4 counts must be guarded');
assert.match(migration, /book4-full-sharh-batch06/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.(?:rules|rule_sources)/iu, 'must not duplicate rules or sources');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 4 lessons 16-17 full sharh checks passed.');
