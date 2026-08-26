import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260827013000_full_book2_lessons26_30_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(26|27|28|29|30)',\s*'[^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 27, 'all 27 lesson 26-30 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 27, 'marker IDs must be unique');

for (const fragment of [
  'يَجِبُ عَلَيْكِ أَنْ تَحْفَظِي الْقُرْآنَ',
  'يَجِبُ عَلَيْكُمْ أَنْ تَخْرُجُوا',
  'يَجِبُ عَلَيْكَ أَنْ تَدْرُسَ جَيِّدًا',
  'book2-l28-full-past-paradigms',
  'بَكَوْا',
  'بَقِينَ',
  'book2-l28-full-present-paradigms',
  'لَنْ يَبْكِيَ',
  'لَمْ يَبْكِ',
  'مَبْنِيٌّ عَلَى الضَّمِّ لِاتِّصَالِ وَاوِ الْجَمَاعَةِ',
  'مَبْنِيٌّ عَلَى الْكَسْرِ لِاتِّصَالِ يَاءِ الْمُخَاطَبَةِ',
  'لَنْ أَتْرُكَ الصَّلَاةَ أَبَدًا',
]) {
  assert.ok(migration.includes(fragment), `missing source-backed correction: ${fragment}`);
}

assert.ok(migration.includes('v_count <> 148'), 'public Book 2 card count must be guarded');
assert.ok(migration.includes('v_count <> 291'), 'Book 2 source-row count must be guarded');
assert.match(migration, /book2-full-sharh-batch06/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rules/iu, 'must not duplicate public cards');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rule_sources/iu, 'existing source rows must not be duplicated');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 2 lessons 26-30 full sharh checks passed.');
