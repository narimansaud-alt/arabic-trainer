import assert from 'node:assert/strict';
import fs from 'node:fs';

const sql = fs.readFileSync(new URL('../supabase/migrations/20260819115000_full_book1_lesson12_sharh_ru.sql', import.meta.url), 'utf8');
const htmlBlocks = [...sql.matchAll(/\$html\$([\s\S]*?)\$html\$/gu)].map((match) => match[1]);
const publicHtml = htmlBlocks.join('\n');

assert.equal(htmlBlocks.length, 5, 'lesson 12 must keep all five existing rule cards');
assert.equal((publicHtml.match(/Полный текст шарха · страница/gu) || []).length, 5, 'all lesson 12 cards must name their PDF page');
assert.doesNotMatch(publicHtml, /موضع غير واضح/u, 'PDF pages 17-18 contain no unreadable public fragment');
assert.doesNotMatch(publicHtml, /اَلْ/u, 'the connected-reading scheme must not retain a fatha over hamzat al-wasl');

for (const fragment of [
  'كَافُ الْمُخَاطَبِ: ضَمِيرٌ لِلْمُخَاطَبِ.',
  'أَلَكِ هَذَا الْقَلَمُ يَا فَاطِمَةُ؟',
  'أَنَا: ضَمِيرٌ لِلْمُتَكَلِّمِ.',
  'الْفَاعِلُ: هُوَ الَّذِي يَقَعُ بَعْدَ الْفِعْلِ.',
  'ذَهَبَتِ الطَّالِبَةُ.',
  'الَّذِي: اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ.',
  'الَّتِي: اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُؤَنَّثِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ.',
  'ذَهَبَتْ + الْـ ← ذَهَبَتِ الْـ',
]) {
  assert.ok(publicHtml.includes(fragment), `missing source fragment: ${fragment}`);
}

const relativeBlock = htmlBlocks.find((html) => html.includes('الِاسْمُ الْمَوْصُولُ الْمُذَكَّرُ الْعَاقِلُ'));
assert.ok(relativeBlock, 'relative-pronoun card must exist');
assert.equal((relativeBlock.match(/rule-example-card/gu) || []).length, 8, 'all eight relative-pronoun examples must be visible');
assert.match(sql, /source_text = \$source\$ذَهَبَتِ الطَّالِبَةُ[\s\S]*ذَهَبَتْ \+ الْ ذَهَبَتِ الْ \.\$source\$/u, 'private source_text must also omit the stray fatha');

for (const html of htmlBlocks) {
  assert.match(html, /class="rule-study"/u, 'every card must use the shared rule design');
  assert.match(html, /dir="rtl" lang="ar"/u, 'every card must keep explicit Arabic RTL markup');
}

console.log('Book 1 lesson 12 full sharh checks passed.');
