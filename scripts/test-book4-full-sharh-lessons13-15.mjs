import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902203000_full_book4_lessons13_15_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(13|14|15)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 19, 'all 19 lesson 13-15 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 19, 'marker IDs must be unique');

for (const fragment of [
  'تَمْيِيزُ النِّسْبَةِ',
  'الْقَفِيزُ مِكْيَالٌ قَدِيمٌ',
  'لَا يَجُوزُ الْجَرُّ بِالْإِضَافَةِ',
  'بَابِ اِفْتَعَلَ',
  'الْفَتْحَةُ الْمُقَدَّرَةُ',
  'الصِّفَةُ الْمُشَبَّهَةُ',
  'نَكِرَةً بِلَا مُسَوِّغٍ',
  'جَمْعُ الْمُؤَنَّثِ السَّالِمُ',
  'وَاوُ الْحَالِ وَحْدَهَا',
  'قِيَامٌ',
  'مُنْقَطِعٌ',
  'بَدَلُ بَعْضٍ مِنْ كُلٍّ',
  'فِي جَمِيعِ أَحْوَالِهِ',
  'إِلَّا مُلْغَاةٌ مِنَ النَّاحِيَةِ الْإِعْرَابِيَّةِ',
  'مَا مَرَرْتُ بِغَيْرِ عَلِيٍّ',
  'ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ هُوَ',
  'أَخْشَى أَنْ أَكُونَ إِيَّاهُ',
  'لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ',
  'دَيَامِيسُ',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 106'), 'Book 4 counts must be guarded');
assert.match(migration, /book4-full-sharh-batch05/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.(?:rules|rule_sources)/iu, 'must not duplicate rules or sources');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 4 lessons 13-15 full sharh checks passed.');
