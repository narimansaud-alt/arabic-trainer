import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902180000_full_book3_lessons16_17_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(16|17)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 15, 'all 15 lesson 16-17 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 15, 'marker IDs must be unique');

for (const fragment of [
  'مَا كَانَتْ جَمِيعُ أَحْرُفِهِ أَصْلِيَّةً',
  'دَخَلَ: يَدْخُلُ',
  'مَزِيدٌ بِثَلَاثَةِ أَحْرُفٍ',
  'مَصْدَرُهُ غَيْرُ مُسْتَعْمَلٍ',
  'الْقَرِينَةُ اللَّفْظِيَّةُ أَوِ الْمَعْنَوِيَّةُ',
  'أَحْرُفُ الْمُضَارَعَةِ',
  'قُلِبَتِ الْيَاءُ هَمْزَةً',
  'كَرَاهَةُ اجْتِمَاعِ هَمْزَتَيْنِ',
  'لَيْسَ أَصْلُهُمَا الْمُبْتَدَأَ وَالْخَبَرَ',
  'قَدْ تَأْتِي',
  'الْمَصْدَرُ الْمُؤَوَّلُ فِي مَحَلِّ نَصْبٍ خَبَرُ أَوْشَكَ',
  'جُمْلَةُ الشَّرْطِ فِي مَحَلِّ نَصْبٍ حَالًا',
  'وَفَائِدَتُهُ',
  'اِسْمٌ مَبْنِيٌّ عَلَى السُّكُونِ يَقَعُ',
  'حُذِفَ تَنْوِينُهُ تَخْفِيفًا',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 89'), 'Book 3 counts must be guarded');
assert.match(migration, /book3-full-sharh-batch06/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.(?:rules|rule_sources)/iu, 'must not duplicate rules or sources');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 3 lessons 16-17 full sharh checks passed.');
