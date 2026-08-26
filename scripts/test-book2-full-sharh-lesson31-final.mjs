import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260827023000_full_book2_lesson31_and_final_audit.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'31',\s*'[^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 3, 'all three lesson 31 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 3, 'marker IDs must be unique');

for (const fragment of [
  'النَّعْتُ',
  'الصِّفَةُ',
  'الْمَنْعُوتُ',
  'الْمَوْصُوفُ',
  'وَلَدٌ صَغِيرٌ',
  'بِنْتٌ صَغِيرَةٌ',
  'الْوَلَدَانِ الصَّغِيرَانِ',
  'الْبَنَاتُ الصَّغِيرَاتُ',
  'هَذِهِ كُتُبٌ جَدِيدَةٌ',
  'هَذَا كِتَابٌ جَدِيدٌ',
  'تَزَوَّجْتُ الْمَرْأَتَيْنِ الصَّالِحَتَيْنِ',
  'مَرْفُوعٌ، مُذَكَّرٌ، مُفْرَدٌ، نَكِرَةٌ',
  'مَنْصُوبٌ، مُؤَنَّثٌ، مُثَنًّى، مَعْرِفَةٌ',
]) {
  assert.ok(migration.includes(fragment), `missing source-backed lesson 31 fragment: ${fragment}`);
}

assert.ok(migration.includes('v_count <> 148'), 'public Book 2 card count must be guarded');
assert.ok(migration.includes('v_count <> 291'), 'Book 2 source-row count must be guarded');
assert.ok(migration.includes('generate_series(1, 31)'), 'all 31 lesson numbers must be audited');
assert.ok(migration.includes("content ~ 'book2-full-sharh-batch0[1-7]'"), 'all seven audit batches must be covered');
assert.match(migration, /book2-full-sharh-batch07/iu, 'final batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rules/iu, 'must not duplicate public cards');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rule_sources/iu, 'existing source rows must not be duplicated');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 2 lesson 31 and final full sharh audit checks passed.');
