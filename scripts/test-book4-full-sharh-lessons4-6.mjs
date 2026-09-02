import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902190000_full_book4_lessons04_06_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(4|5|6)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 21, 'all 21 lesson 4-6 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 21, 'marker IDs must be unique');

for (const fragment of [
  'إِظْهَارُ مَا لَيْسَ فِي الْبَاطِنِ',
  'بِأَنْ نُصَلِّيَ',
  'إِيَّاكَ أَنْ تَكْذِبَ',
  'عِدَةٌ',
  'لَيْتَ الشَّبَابَ يَعُودُ',
  'الشَّبِيهُ بِالْمُضَافِ',
  'بَدَلُ الْمُبَايِنِ',
  'لَا تُحْذَفُ إِلَّا نَادِرًا',
  'هَؤُلَاءِ النِّسَاءُ عُرْجٌ',
  'لَا يَكُونُ إِلَّا لَازِمًا',
  'حَرْفُ امْتِنَاعٍ لِوُجُودٍ',
  'اللَّامُ حَرْفُ جَوَابٍ وَرَبْطٍ',
  'أَرِنِي سَاعَتَكَ هَذِهِ',
  'الْقَمَرَانِ',
  'يَوْمَ زَارَ الْوَزِيرُ الْجَامِعَةَ',
  'رَفَعْتُ الصَّوْتَ، فَارْتَفَعَ الصَّوْتُ',
  'أَخَذَ ← اِتَّخَذَ',
  'حُدُوثُ أَمْرٍ غَيْرِ مُتَوَقَّعٍ',
  'سَدَّ مَسَدَّ مَفْعُولَيْ ظَنَّ',
  'مِفْعَالٌ',
  'دَخَلْتُ فِي الِامْتِحَانِ',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 106'), 'Book 4 counts must be guarded');
assert.match(migration, /book4-full-sharh-batch02/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.(?:rules|rule_sources)/iu, 'must not duplicate rules or sources');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 4 lessons 4-6 full sharh checks passed.');
