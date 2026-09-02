import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902183000_full_book4_lessons01_03_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(1|2|3)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 19, 'all 19 lesson 1-3 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 19, 'marker IDs must be unique');

for (const fragment of [
  'مَسِيرٌ وَرَاءَهُ',
  'مَفْعُولٌ بِهِ غَيْرُ صَرِيحٍ',
  'الْمُبَالَغَةُ',
  'أَرِنِي كِتَابَكَ',
  'لَا يُقَاسُ عَلَيْهِ',
  'مَا الزَّائِدَةُ الْكَافَّةُ',
  'تَقْدِيرُهُ: أُحَذِّرُ',
  'جَوَابُ الْقَسَمِ',
  'أَمْسَتِ الْأُمُّ مَرِيضَةً',
  'مُفَاعَلَةٌ وَفِعَالٌ',
  'الِاحْتِمَالُ وَالشَّكُّ',
  'حَرْفُ ابْتِدَاءٍ وَاسْتِدْرَاكٍ',
  'مُلْحَقَتَانِ بِجَمْعِ الْمُذَكَّرِ السَّالِمِ',
  'إِفْرَادًا وَتَثْنِيَةً وَجَمْعًا',
  'чтобы два усилителя не стояли вместе в начале',
  'يُرْجَعُ فِي ذَلِكَ إِلَى الْمَعَاجِمِ',
  'الْمُطَاوَعَةُ',
  'تَتَضَمَّنُ مَعْنَى الشَّرْطِ',
  'لِفِعْلٍ مَحْذُوفٍ وُجُوبًا',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 106'), 'Book 4 counts must be guarded');
assert.match(migration, /book4-full-sharh-batch01/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.(?:rules|rule_sources)/iu, 'must not duplicate rules or sources');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 4 lessons 1-3 full sharh checks passed.');
