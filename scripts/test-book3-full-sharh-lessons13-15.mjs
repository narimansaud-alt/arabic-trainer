import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902173000_full_book3_lessons13_15_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(13|14|15)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 14, 'all 14 lesson 13-15 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 14, 'marker IDs must be unique');

for (const fragment of [
  'لَا تَدْخُلُ عَلَى الْمُتَكَلِّمِ',
  'فِعْلٌ مُضَارِعٌ مَجْزُومٌ بِالطَّلَبِ',
  'حَرْفُ سَكْتٍ مَبْنِيٌّ عَلَى السُّكُونِ',
  'تَنْوِينَ تَنْكِيرٍ',
  'وَالنَّفْسُ رَاغِبَةٌ إِذَا رَغَّبْتَهَا',
  'فِي ثَمَانِيَةِ مَوَاضِعَ',
  'مَدْرَسِيٌّ',
  'لَا تَجْزِمُ إِلَّا إِذَا اتَّصَلَتْ بِهَا مَا الزَّائِدَةُ',
  'مَنْ يَقُمْ لَيْلَةَ الْقَدْرِ',
  'كِلْتَاهُمَا لَهُ الصَّدَارَةُ',
  'أَنْ مُضْمَرَةٌ وُجُوبًا',
  'الْمِيمُ فِي الْآيَةِ حُرِّكَتْ بِالضَّمِّ',
  'السُّكُونُ عَلَى النُّونِ الْمَحْذُوفَةِ',
  'يَاءَ التَّصْغِيرِ',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 89'), 'Book 3 counts must be guarded');
assert.match(migration, /book3-full-sharh-batch05/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.(?:rules|rule_sources)/iu, 'must not duplicate rules or sources');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 3 lessons 13-15 full sharh checks passed.');
