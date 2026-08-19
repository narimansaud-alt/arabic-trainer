import assert from 'node:assert/strict';
import fs from 'node:fs';

const sql = fs.readFileSync(
  new URL('../supabase/migrations/20260819113000_full_book1_lesson10_sharh_ru.sql', import.meta.url),
  'utf8'
);
const htmlBlocks = [...sql.matchAll(/\$html\$([\s\S]*?)\$html\$/gu)].map((match) => match[1]);
const publicHtml = htmlBlocks.join('\n');

assert.equal(htmlBlocks.length, 4, 'lesson 10 must keep all four existing rule cards');
assert.equal((publicHtml.match(/Полный текст шарха · страница/gu) || []).length, 4, 'every lesson 10 card must name its PDF page');
assert.ok((publicHtml.match(/Полный перевод:/gu) || []).length >= 4, 'every main author block must have a Russian translation');
assert.doesNotMatch(publicHtml, /موضع غير واضح/u, 'PDF pages 14-15 contain no unreadable public fragment');

for (const fragment of [
  'الضَّمَائِرُ ثَلَاثَةٌ، هِيَ',
  'أَبُوهَا وَأُمُّهَا فِي الْبَيْتِ.',
  'عِنْدِي: لِغَيْرِ الْعَاقِلِ',
  'لِي: لِلْعَاقِلِ',
  'مَعُ خَالِدٍ ✕',
  'عَائِشَةُ مَعُهَا زَوْجُهَا ✕',
  'مَنْ مَعُكَ يَا عَلِيُّ؟ مَعُكَ زَمِيلِي. ✕',
  'مَعَ: ظَرْفُ مَكَانٍ، الِاسْمُ الَّذِي بَعْدَهُ مَجْرُورٌ بِالْكَسْرَةِ.',
  'الْعَلَمُ الْمُذَكَّرُ الْمَخْتُومُ بِتَاءِ التَّأْنِيثِ لَا يُنَوَّنُ.',
]) {
  assert.ok(publicHtml.includes(fragment), `missing source fragment: ${fragment}`);
}

assert.doesNotMatch(publicHtml, /مَعَ خَالِدٌ/u, 'the old invented invalid case ending must not remain');
assert.doesNotMatch(publicHtml, /عَائِشَةُ مَعَهُ زَوْجُهَا/u, 'the old invented masculine-pronoun error must not remain');
assert.match(
  sql,
  /source_text = \$source\$مَعَ خَالِدٍ ✓ مَعُ خَالِدٍ ✕[\s\S]*عَائِشَةُ مَعَهَا زَوْجُهَا ✓ عَائِشَةُ مَعُهَا زَوْجُهَا ✕[\s\S]*مَنْ مَعَكَ يَا عَلِيُّ ؟ مَعِي زَمِيلِي ✓ مَنْ مَعُكَ يَا عَلِيُّ ؟ مَعُكَ زَمِيلِي ✕\$source\$/u,
  'private source_text must reproduce the three printed مَعَ contrasts from PDF page 15'
);
assert.ok((publicHtml.match(/<div class="tbl-wrap"><table/gu) || []).length >= 4, 'all wide lesson 10 tables must scroll inside their cards');

for (const html of htmlBlocks) {
  assert.match(html, /class="rule-study"/u, 'every card must use the shared rule design');
  assert.match(html, /dir="rtl" lang="ar"/u, 'every card must keep explicit Arabic RTL markup');
}

console.log('Book 1 lesson 10 full sharh checks passed.');
