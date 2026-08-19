import assert from 'node:assert/strict';
import fs from 'node:fs';

const sql = fs.readFileSync(new URL('../supabase/migrations/20260819114000_full_book1_lesson11_sharh_ru.sql', import.meta.url), 'utf8');
const htmlBlocks = [...sql.matchAll(/\$html\$([\s\S]*?)\$html\$/gu)].map((match) => match[1]);
const publicHtml = htmlBlocks.join('\n');

assert.equal(htmlBlocks.length, 2, 'lesson 11 must keep both existing rule cards');
assert.equal((publicHtml.match(/Полный текст шарха · страница 16/gu) || []).length, 2, 'both cards must name PDF page 16');
assert.doesNotMatch(publicHtml, /موضع غير واضح/u, 'PDF page 16 contains no unreadable public fragment');

for (const fragment of [
  'فِي: حَرْفُ جَرٍّ.',
  'ضَمِيرُ الْغَائِبِ الْمُذَكَّرِ: فِيهِ.',
  'ضَمِيرُ الْغَائِبِ الْمُؤَنَّثِ: فِيهَا.',
  'مَنْ فِي الْمَكْتَبِ؟ مَا فِيهِ أَحَدٌ.',
  'مَنْ فِي الْمَكْتَبَةِ؟ مَا فِيهَا أَحَدٌ.',
  'يَاءُ الْمُتَكَلِّمِ: ضَمِيرٌ لِلْمُتَكَلِّمِ.',
  'أُحِبُّ أَبِي وَأُمِّي. أُحِبُّ أَخِي وَأُخْتِي.',
]) {
  assert.ok(publicHtml.includes(fragment), `missing source fragment: ${fragment}`);
}

for (const html of htmlBlocks) {
  assert.match(html, /class="rule-study"/u, 'every card must use the shared rule design');
  assert.match(html, /dir="rtl" lang="ar"/u, 'every card must keep explicit Arabic RTL markup');
}

console.log('Book 1 lesson 11 full sharh checks passed.');
