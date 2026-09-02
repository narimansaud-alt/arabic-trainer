import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902193000_full_book4_lessons07_09_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(7|8|9)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 22, 'all 22 lesson 7-9 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 22, 'marker IDs must be unique');

for (const fragment of [
  'مُعْوَجِجٌ',
  'مُبْيَاضِضٌ',
  'رَأَى مُحَمَّدٌ الْحَقَّ وَاضِحًا',
  'بِكَوْنِكُمْ كَافِرِينَ',
  'الطَّالِبُ عَسَى أَنْ يَنْجَحَ',
  'اِسْتَرْجَلَتِ الْمَرْأَةُ',
  'لَا أَكَلْتُ وَلَا شَرِبْتُ',
  'قَدْ رَكَعَ الْإِمَامُ',
  'إِذَنْ وَاللَّهِ أَنْتَظِرَكَ',
  'جَعَلَ اللَّهُ الْهَوَاءَ',
  'عَيْنَيَّ',
  'وَسْوَسَةٌ وَوِسْوَاسٌ',
  'دَحْرَجْتُ الْكُرَةَ',
  'حَرْجَمْتُ الْإِبِلَ',
  'اِشْمَأَزَّ',
  'أُولَئِكَ هُنَّ الْمُؤْمِنَاتُ',
  'إِذَا هُمۡ يَقۡنَطُونَ',
  'وَكَيْفَ حَصَلَ ذَلِكَ',
  'مُدَّةَ عَدَمِ إِتْيَانِ صَاحِبِهِ',
  'لَمْ يَشْدُدْ',
  'بَعْضَ الَّذِي رَزَقْنَاهُمْ',
  'يَا رَبَّاهْ',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 106'), 'Book 4 counts must be guarded');
assert.match(migration, /book4-full-sharh-batch03/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.(?:rules|rule_sources)/iu, 'must not duplicate rules or sources');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 4 lessons 7-9 full sharh checks passed.');
