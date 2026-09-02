import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260902153000_full_book3_lessons01_03_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(1|2|3)',\s*'Полный шарх: с\. [^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 24, 'all 24 lesson 1-3 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 24, 'marker IDs must be unique');

for (const fragment of [
  'سَلَّمْتُ عَلَى هَؤُلَاءِ',
  'هَيْهَاتَ، شَتَّانَ',
  'هَذَا أُبَيٌّ وَأُخَيٌّ',
  'وَأَنْ تَصُومُوا خَيْرٌ لَكُمْ',
  'اشْتِغَالُ الْمَحَلِّ بِحَرَكَةِ الْمُنَاسَبَةِ',
  'خَبَرُ لَا النَّافِيَةِ لِلْجِنْسِ',
  'تَوْكِيدُ الْمَجْرُورِ',
  'الْمَفْعُولُ لِأَجْلِهِ',
  'بَدَلُ غَلَطٍ',
  'حَذْفُ حَرْفِ الْعِلَّةِ',
  'لَمْ أَحْجُجْ',
  'وَقَدْ غَرَبَتِ الشَّمْسُ',
  'لَعَلِّي لَا أَحُجُّ',
  'يَنُوبُ عَنْ خُذُوا',
  'أَشْيِئَاءُ',
  'لَا شَفَاهُ اللَّهُ',
  'تُفِيدُ النَّصَّ عَلَى الْعُمُومِ',
  'وَلَدَيۡنَا كِتَٰبٞ',
  'عِشْتُ لَيَالِيَ سَعِيدَةً',
  'ظُنَّ الْمُدَرِّسُ غَائِبًا',
  'أَبَوِيٌّ',
  'الْإِبْهَامُ',
  'أَرْبَعَمِائَةِ رِيَالٍ',
  'حَبَّةٌ',
]) {
  assert.ok(migration.includes(fragment), 'missing source-backed guard: ' + fragment);
}

assert.ok(migration.includes('v_count <> 89'), 'Book 3 rule and source counts must be guarded');
assert.match(migration, /book3-full-sharh-batch01/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rules/iu, 'must not duplicate public cards');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rule_sources/iu, 'must not duplicate source rows');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 3 lessons 1-3 full sharh checks passed.');
