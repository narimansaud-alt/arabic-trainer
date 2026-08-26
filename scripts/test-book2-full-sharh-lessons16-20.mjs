import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260826233000_full_book2_lessons16_20_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(16|17|18|19|20)',\s*'[^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 23, 'all 23 lesson 16-20 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 23, 'marker IDs must be unique');

for (const fragment of [
  'أَرَدْتُنَّ',
  'يُرِدْنَ',
  'عَمْرًا',
  'مَا الْمَوْصُولَةُ',
  'مُضَافٌ إِلَيْهِ مَجْرُورٌ',
  'حَذْفُ النُّونِ',
  'مَصْدَرٌ مُؤَوَّلٌ',
  'وَظَرْفَانِ',
  'رَأَيْتُنَّ',
  'تَفْعَلَانِ',
  'بِالْأَلِفِ الْفَارِقَةِ',
  'نُونُ النِّسْوَةِ',
  'أَنْ + لَا النَّافِيَةُ',
  'اِذْهَبْ إِلَى السُّوقِ',
  'لَنْ تُسَافِرِي',
  'لَنْ أَذْهَبَ إِلَى السُّوقِ',
  'الطَّالِبَيْنِ: مَفْعُولٌ بِهِ مَنْصُوبٌ',
  'إِحْدَاهُمَا',
  'ذَاتِ',
]) {
  assert.ok(migration.includes(fragment), `missing source-backed guard: ${fragment}`);
}

assert.ok(migration.includes('v_count <> 148'), 'public Book 2 card count must be guarded');
assert.ok(migration.includes('v_count <> 291'), 'Book 2 source-row count must be guarded');
assert.match(migration, /book2-full-sharh-batch04/iu, 'batch marker must be present');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rules/iu, 'must not duplicate public cards');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rule_sources/iu, 'already complete source rows must not be duplicated');
assert.doesNotMatch(migration, /delete\s+from\s+public\.(?:rules|rule_sources)/iu, 'must not delete rules or sources');

console.log('Book 2 lessons 16-20 full sharh checks passed.');
