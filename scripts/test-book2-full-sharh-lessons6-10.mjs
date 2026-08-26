import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260826193000_full_book2_lessons06_10_sharh_ru.sql', import.meta.url),
  'utf8'
);

const markerRows = [...migration.matchAll(/^\s*\((\d+),\s*'(6|7|8|9|10)',\s*'[^']+'\)[,;]$/gmu)];
assert.equal(markerRows.length, 30, 'all 30 lesson 6-10 cards must be guarded and marked');
assert.equal(new Set(markerRows.map((match) => Number(match[1]))).size, 30, 'marker IDs must be unique');

for (const fragment of [
  'إِسْنَادُ الْفِعْلِ الْمُضَارِعِ',
  'تَذْهَبِينَ',
  'تَذْهَبُونَ',
  'تَذْهَبْنَ',
  'يَذْهَبُونَ',
  'يَذْهَبْنَ',
  'الفرق بين "ما" و"لا" النافيتين',
  'مَا شَرِبَ أَبِي الْقَهْوَةَ أَمْسِ',
  'لَا يَشْرَبُ أَبِي الشَّايَ',
  'مَا أَشْرَبُ الشَّايَ',
]) {
  assert.ok(migration.includes(fragment), `missing source-backed fragment: ${fragment}`);
}

assert.ok(migration.includes("source_document = 'Podrobny_Sharkh_2_tom.pdf'"), 'full sharh provenance must be explicit');
assert.ok(migration.includes("source_document = 'Sharkh_na_2_tom_Med_kursa.pdf'"), 'supplementary provenance must be explicit');
assert.ok(migration.includes('v_count <> 148'), 'public Book 2 card count must be guarded');
assert.ok(migration.includes('v_count <> 291'), 'restored Book 2 source-row count must be guarded');
assert.match(migration, /insert\s+into\s+public\.rule_sources/iu, 'missing full-sharh page 29 must be restored');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rules/iu, 'must not duplicate public cards');
assert.doesNotMatch(migration, /delete\s+from\s+public\.rules/iu, 'must not delete public cards');
assert.doesNotMatch(migration, /delete\s+from\s+public\.rule_sources/iu, 'must not delete source rows');

console.log('Book 2 lessons 6-10 full sharh checks passed.');
