import assert from 'node:assert/strict';
import fs from 'node:fs';

const migration = fs.readFileSync(
  new URL('../supabase/migrations/20260826140000_deep_audit_book1_full_sharh.sql', import.meta.url),
  'utf8'
);

for (const fragment of [
  'أَمَامَ، خَلْفَ: ظَرْفُ مَكَانٍ.',
  'сыновья Мухаммада',
  'его сыновья',
  'твои сыновья',
  'моя книга',
  'الْعَدَدُ مِنْ (٣ إِلَى ١٠) يُخَالِفُ الْمَعْدُودَ',
  'если считаемое слово мужского рода, числительное имеет форму женского рода',
  "'هَذَا الرَّجُلُ تَاجِرٌ'",
  "'أَيْنَ بَيْتُكَ ؟ أَيْنَ بَيْتُكُمْ ؟ أَيْنَ بَيْتُكُنَّ ؟'",
]) {
  assert.ok(migration.includes(fragment), 'missing deep-audit safeguard: ' + fragment);
}

assert.ok(
  migration.includes("and source_text like '%بَيْتُ كَ%'") &&
    migration.includes("raise exception 'Book 1 page 26 source archive still differs from the PDF'"),
  'the migration must reject the phantom separated pronoun form after correction'
);
assert.ok(migration.includes('<> 70'), 'the migration must preserve all 70 full-sharh cards');
assert.ok(migration.includes('<> 147'), 'the migration must preserve all 147 source fragments');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rules/iu, 'the audit must not create rule cards');
assert.doesNotMatch(migration, /delete\s+from\s+public\.rules/iu, 'the audit must not delete rule cards');
assert.doesNotMatch(migration, /insert\s+into\s+public\.rule_sources/iu, 'the audit must not invent source fragments');
assert.doesNotMatch(migration, /delete\s+from\s+public\.rule_sources/iu, 'the audit must not delete source fragments');

console.log('Book 1 complete deep sharh audit checks passed.');