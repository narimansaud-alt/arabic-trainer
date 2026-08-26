import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260827003000_full_book2_lessons21_25_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(21|22|23|24|25)',\s*'[^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 19, 'all 19 lesson 21-25 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 19, 'marker IDs must be unique');

for (const fragment of [
  'أَكَتَبْتَ الْوَاجِبَ',
  'اِسْمُ الْجِنْسِ الْجَمْعِيُّ',
  'تَاءَ التَّأْنِيثِ السَّاكِنَةَ',
  'خَبَرٌ جُمْلَةٌ اسْمِيَّةٌ',
  'اللَّائِي',
  'ثُلَاثِيٌّ سَاكِنُ الْوَسَطِ',
  'نَشْرَبُ',
  'نُونُ الْمُثَنَّى مَكْسُورَةٌ',
  'بِسِتِّينَ',
  'فَلَا صَدَّقَ وَلَا صَلَّىٰ',
  'وَاحِدٍ',
  'أَيَّامٍ',
  'اِثْنَيْ عَشَرَ',
  'حَصَلْتُ عَلَى',
  'إِعْرَابٌ تَقْدِيرِيٌّ',
  'مِنْ بَعْدُ',
  'أَخِيكَ',
  'أَبِي بَكْرٍ',
]) {
  assert.ok(migration.includes(fragment), `missing source-backed guard: ${fragment}`);
}

assert.ok(migration.includes('v_count <> 148'), 'public Book 2 card count must be guarded');
assert.ok(migration.includes('v_count <> 291'), 'Book 2 source-row count must be guarded');
assert.match(migration, /book2-full-sharh-batch05/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rules/iu, 'must not duplicate public cards');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rule_sources/iu, 'already complete source rows must not be duplicated');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 2 lessons 21-25 full sharh checks passed.');
