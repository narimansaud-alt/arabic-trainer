import assert from 'node:assert/strict';
import fs from 'node:fs';

const migrationUrl = new URL(
  '../supabase/migrations/20260818160000_full_book1_lessons04_06_sharh_ru.sql',
  import.meta.url
);
const sql = fs.readFileSync(migrationUrl, 'utf8');
const appShell = fs.readFileSync(new URL('../index.html', import.meta.url), 'utf8');
const htmlBlocks = [...sql.matchAll(/\$html\$([\s\S]*?)\$html\$/gu)].map((match) => match[1]);
const publicHtml = htmlBlocks.join('\n');

assert.equal(htmlBlocks.length, 11, 'lessons 4-6 must keep all eleven existing rule cards');
assert.equal(
  (publicHtml.match(/Полный перевод:/gu) || []).length,
  14,
  'all fourteen author explanation blocks must have Russian translations'
);
assert.doesNotMatch(publicHtml, /موضع غير واضح/u, 'no public source passage on PDF pages 8-10 is unreadable');
assert.equal(
  (publicHtml.match(/lang="ar"/gu) || []).length,
  (publicHtml.match(/dir="rtl" lang="ar"/gu) || []).length,
  'every Arabic fragment must use explicit RTL direction'
);
assert.match(
  appShell,
  /#tab-rules \.rule-study \.tbl-wrap td\[dir="rtl"\],[^}]*color:#246076!important;[^}]*font-size:clamp\(20px,4\.8vw,24px\)!important;[^}]*font-weight:850!important;/u,
  'direct Arabic table cells must use the large, bold, colored rule typography'
);

const requiredArabic = [
  'حُرُوفُ الْجَرِّ: يُجَرُّ الِاسْمُ الَّذِي بَعْدَهَا بِالْكَسْرَةِ.',
  'مُحَمَّدٌ فِي الْبَيْتِ.',
  'ذَهَبَ الطَّالِبُ إِلَى الْمِرْحَاضِ.',
  'أَيْنَ فَاطِمَةُ؟ فَاطِمَةُ فِي الْمَطْبَخِ.',
  'مَاذَا عَلَى الْمَكْتَبِ؟ مُحَمَّدٌ عَلَى الْمَكْتَبِ. ✕',
  'الْعَلَمُ الْمُؤَنَّثُ لَا يُنَوَّنُ.',
  'عَمَّارٌ',
  'آمِنَةٌ. ✕',
  'مِنَ الْبَيْتِ.',
  'أَصْلُهُ: مِنْ + ال.',
  'حُرِّكَتِ النُّونُ بِالْفَتْحَةِ مَنْعًا لِالْتِقَاءِ السَّاكِنَيْنِ.',
  'كِتَابٌ: مُحَمَّدٌ ← كِتَابُ مُحَمَّدٍ',
  'كِتَابُ مُحَمَّدٌ ✕',
  'خَالُ حَامِدٍ فَقِيرٌ.',
  'اسْمُ الْبِنْتِ زَيْنَبُ.',
  'يَا شَيْخٌ. ✕',
  'كِتَابُ مَنْ هَذَا؟ سُؤَالٌ عَنِ الْعَاقِلِ',
  'هَذِهِ أُخْتُ الْمُهَنْدِسِ.',
  'هَذِهِ دَرَّاجَةُ أَنَسٍ.',
  'هَذَا أَنْفٌ، وَهَذَا فَمٌ. ✓',
  'الْجُمْلَةُ الِاسْمِيَّةُ: تَتَكَوَّنُ مِنْ كَلِمَتَيْنِ',
  'حَقِيبَةُ مَنْ هَذَا؟ ✕',
  'الْغُرْفَةُ مَفْتُوحَةٌ. ✓',
  'تِلْكَ: مُبْتَدَأٌ',
  'شَمْسٌ: خَبَرٌ',
];

for (const fragment of requiredArabic) {
  assert.ok(htmlBlocks.some((html) => html.includes(fragment)), `missing source fragment: ${fragment}`);
}

const prepositionBlock = htmlBlocks.find((html) => html.includes('حُرُوفُ الْجَرِّ'));
assert.ok(prepositionBlock, 'preposition card must exist');
assert.equal(
  (prepositionBlock.match(/<tbody>[\s\S]*?<\/tbody>/gu)?.[0].match(/<tr>/gu) || []).length,
  12,
  'all twelve preposition examples from PDF page 8 must be visible'
);

const feminineNameBlock = htmlBlocks.find((html) => html.includes('الْعَلَمُ الْمُؤَنَّثُ'));
assert.ok(feminineNameBlock, 'feminine proper-name card must exist');
assert.equal((feminineNameBlock.match(/rule-table-invalid/gu) || []).length, 4, 'all four forbidden tanwin forms must be visible');

const idafaBlock = htmlBlocks.find((html) => html.includes('الْمُضَافُ، وَالْمُضَافُ إِلَيْهِ'));
assert.ok(idafaBlock, 'idafa card must exist');
assert.match(idafaBlock, /خَالُ حَامِدٍ فَقِيرٌ/u, 'additional idafa examples must stay before the vocative card');
assert.match(idafaBlock, /اسْمُ الْبِنْتِ زَيْنَبُ/u, 'all additional idafa examples must be visible');

const ownerBlock = htmlBlocks.find((html) => html.includes('قَلَمُ مَنْ هَذَا؟'));
assert.ok(ownerBlock, 'owner-question card must exist');
assert.doesNotMatch(ownerBlock, /خَالُ حَامِدٍ/u, 'idafa examples must not be misplaced after the vocative block');

const nominalBlock = htmlBlocks.find((html) => html.includes('الْجُمْلَةُ الِاسْمِيَّةُ'));
assert.ok(nominalBlock, 'nominal-sentence card must exist');
assert.equal(
  (nominalBlock.match(/<tbody>[\s\S]*?<\/tbody>/gu)?.[0].match(/<tr>/gu) || []).length,
  10,
  'all ten nominal-sentence examples from PDF page 10 must be visible'
);
assert.equal((nominalBlock.match(/rule-table-invalid/gu) || []).length, 2, 'both invalid agreement examples must be visible');

assert.equal(
  (publicHtml.match(/<div class="tbl-wrap"><table/gu) || []).length,
  5,
  'all five wide tables must scroll inside their cards'
);

for (const html of htmlBlocks) {
  assert.match(html, /class="rule-study"/u, 'every card must use the shared rule design');
  assert.match(html, /dir="rtl" lang="ar"/u, 'every card must keep explicit Arabic RTL markup');
}

assert.match(
  sql,
  /source_text = \$source\$\( الْعَلَمُ الْمُؤَنَّثُ لَا يُنَوَّنُ \)[\s\S]*عَمَّارٌ : آمِنَةُ[\s\S]*مَرْيَمٌ ✕[\s\S]*فَاطِمَةٌ ✕\$source\$/u,
  'private source_text must restore all printed feminine-name pairs and invalid forms verbatim'
);
assert.match(
  sql,
  /source_text = \$source\$حَقِيبَةُ مَنْ هَذَا؟ ✕[\s\S]*حَقِيبَةُ مَنْ هَذِهِ؟ ✓[\s\S]*تِلْكَ شَمْسٌ[\s\S]*شَمْسٌ : خَبَرٌ[\s\S]*\$source\$/u,
  'private source_text must restore the bag examples and both grammatical analyses'
);
assert.match(
  sql,
  /set rule_id = 1483,[\s\S]*where id = 166[\s\S]*and rule_id = 1485/u,
  'the existing idafa source fragment must be attached to the idafa rule without duplication'
);
assert.match(
  sql,
  /set rule_ar = 'كِتَابُ مَنْ هٰذَا؟ سُؤَالٌ عَنِ الْعَاقِلِ الْمَالِكِ لِلْكِتَابِ\.'/u,
  'the owner-question rule must identify the rational owner without the old ambiguity'
);

console.log('Book 1 lessons 4-6 full sharh checks passed.');
