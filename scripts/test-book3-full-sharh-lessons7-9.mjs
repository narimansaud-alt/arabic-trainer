import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902163000_full_book3_lessons07_09_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(7|8|9)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 16, 'all 16 lesson 7-9 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 16, 'marker IDs must be unique');

for (const fragment of [
  'الْبَصْرِيُّونَ يَرَوْنَ',
  'النَّكِرَةُ الْمَقْصُودَةُ بِالنِّدَاءِ',
  'تَقْدِيرُهُ: هِيَ',
  'أَبُو حَامِدٍ',
  'هُنَالِكَ',
  'يُسَمَّى عَائِدًا',
  'الْقَلَمُ',
  'نَكِرَةٌ مُخَصَّصَةٌ',
  'مَعْرِفَةٌ قَبْلَ النِّدَاءِ',
  'اثْنَانِ وَاثْنَتَانِ',
  'غَسَلْتُ رِجْلَيَّ',
  'مُرَاعَاةُ الْمَعْنَى',
  'تَيْنِكَ الطَّالِبَتَيْنِ',
  'أَخَوَيَّ',
  'مُدَرِّسُو النَّحْوِ أَقْوِيَاءُ',
  'فَأۡتِ بِهَا مِنَ ٱلۡمَغۡرِبِ',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 89'), 'Book 3 counts must be guarded');
assert.match(migration, /book3-full-sharh-batch03/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.(?:rules|rule_sources)/iu, 'must not duplicate rules or sources');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 3 lessons 7-9 full sharh checks passed.');
