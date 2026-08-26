import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260826220000_full_book2_lessons11_15_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(11|12|13|14|15)',\s*'[^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 17, 'all 17 lesson 11-15 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 17, 'marker IDs must be unique');

for (const fragment of [
  'أَنَا أَذْهَبُ',
  'هُنَّ يَذْهَبْنَ',
  'فَأَمَّا ٱلۡيَتِيمَ فَلَا تَقۡهَرۡ',
  'يَوْمُ السَّبْتِ',
  'يَوْمُ الْجُمُعَةِ',
  'أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ',
  'حَذْفُ حَرْفِ الْعِلَّةِ',
  'أَحْرُفُ الْمُضَارَعَةِ أَرْبَعَةٌ',
  'اِشْرَبِ الْقَهْوَةَ',
  'اُخْرُجْ وَالْعَبْ',
  'لَا تَذْهَبْنَ',
  'فِي مَحَلِّ نَصْبٍ خَبَرُ كَادَ',
  'مَا أَصْغَرَ السَّيَّارَةَ',
]) {
  assert.ok(migration.includes(fragment), `missing source-backed guard: ${fragment}`);
}

assert.ok(migration.includes('v_count <> 148'), 'public Book 2 card count must be guarded');
assert.ok(migration.includes('v_count <> 291'), 'Book 2 source-row count must be guarded');
assert.match(migration, /book2-full-sharh-batch03/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rules/iu, 'must not duplicate public cards');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rule_sources/iu, 'already complete source rows must not be duplicated');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 2 lessons 11-15 full sharh checks passed.');
