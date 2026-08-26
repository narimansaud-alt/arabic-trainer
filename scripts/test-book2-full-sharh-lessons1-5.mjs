import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260826173000_full_book2_lessons01_05_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'([1-5])',\s*'[^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 29, 'all 29 lesson 1-5 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 29, 'marker IDs must be unique');

for (const fragment of [
  'هُنَّ مُسْلِمَاتٌ ← إِنَّهُنَّ مُسْلِمَاتٌ',
  'الْأَسْمَاءُ الْخَمْسَةُ هِيَ: أَبٌ، أَخٌ، حَمٌ، فُو، ذُو',
  'الْكُتُبُ غَالِيَةٌ فِي بَلَدِنَا',
  'قَرَأْتُ أَلْفَ صَفْحَةٍ',
  'أَنْتُمْ لَسْتُمْ عَرَبًا / بِعَرَبٍ',
  'يَجِبُ تَقْدِيمُ خَبَرَيْ إِنَّ وَلَيْسَ',
  'يَجُوزُ تَقْدِيمُ خَبَرِ إِنَّ',
  'لَا نَقُولُ: هُوَ أَذْكَىٌ مِنِّي',
  'الْفَاعِلُ: اسْمٌ مَرْفُوعٌ قَبْلَهُ فِعْلٌ',
]) {
  assert.ok(migration.includes(fragment), `missing source-backed fragment: ${fragment}`);
}

assert.ok(migration.includes('v_count <> 148'), 'public Book 2 card count must be guarded');
assert.ok(migration.includes('v_count <> 290'), 'Book 2 source-row count must be guarded');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rules/iu, 'must not duplicate public cards');
assert.doesNotMatch(migration, /delete\s+from\s+public\.rules/iu, 'must not delete public cards');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rule_sources/iu, 'must preserve source rows');
assert.doesNotMatch(migration, /delete\s+from\s+public\.rule_sources/iu, 'must preserve source rows');

console.log('Book 2 lessons 1-5 full sharh checks passed.');
