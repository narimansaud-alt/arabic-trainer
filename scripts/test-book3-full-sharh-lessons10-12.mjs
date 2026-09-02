import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902170000_full_book3_lessons10_12_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(10|11|12)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 16, 'all 16 lesson 10-12 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 16, 'marker IDs must be unique');

for (const fragment of [
  'صِيَامُكُمْ خَيْرٌ لَكُمْ',
  'لَا يَكْتَفِي بِمَرْفُوعِهِ',
  'لَا يَقْتَرِنُ بِأَنْ الْمَصْدَرِيَّةِ مُطْلَقًا',
  'سَنَدْرُسُ الْفِعْلَ أَوْشَكَ',
  'وَأَن تَعۡفُوٓاْ أَقۡرَبُ لِلتَّقۡوَىٰ',
  'مَا وَمَنْ وَكَمْ فِي مَحَلِّ رَفْعٍ مُبْتَدَأٌ',
  'لِأَنَّهُ نَكِرَةٌ وَمَا بَعْدَهُ مَعْرِفَةٌ',
  'نَعَمْ، أَنَا طَالِبٌ',
  'يُشْتَرَطُ فِي الْخَبَرِ الْجُمْلَةِ',
  'الظَّرْفُ مَعَ مَجْرُورِهِ',
  'الطَّالِبَاتُ مُتَحَجِّبَاتٌ',
  'وَبَنَيۡنَا فَوۡقَكُمۡ سَبۡعٗا شِدَادٗا',
  'أَيَّانَ',
  'سِرْتُ ثَلَاثَةَ أَمْيَالٍ',
  'الْغَلَبَةُ',
  'تَقْيِيدُ الشَّرْطِيَّةِ بِالزَّمَنِ الْمَاضِي',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 89'), 'Book 3 counts must be guarded');
assert.match(migration, /book3-full-sharh-batch04/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.(?:rules|rule_sources)/iu, 'must not duplicate rules or sources');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 3 lessons 10-12 full sharh checks passed.');
