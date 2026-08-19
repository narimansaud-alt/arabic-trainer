import assert from 'node:assert/strict';
import fs from 'node:fs';

const files = [
  '../supabase/migrations/20260819110000_full_book1_lesson07_sharh_ru.sql',
  '../supabase/migrations/20260819111000_full_book1_lesson08_sharh_ru.sql',
  '../supabase/migrations/20260819112000_full_book1_lesson09_sharh_ru.sql',
];
const sql = files.map((file) => fs.readFileSync(new URL(file, import.meta.url), 'utf8')).join('\n');
const htmlBlocks = [...sql.matchAll(/\$html\$([\s\S]*?)\$html\$/gu)].map((match) => match[1]);
const publicHtml = htmlBlocks.join('\n');

assert.equal(htmlBlocks.length, 8, 'lessons 7-9 must keep all eight existing rule cards');
assert.equal((publicHtml.match(/Полный текст шарха/gu) || []).length, 8, 'every rule card must name its source page');
assert.ok((publicHtml.match(/Полный перевод:/gu) || []).length >= 8, 'every author explanation must include its Russian translation');
assert.doesNotMatch(publicHtml, /موضع غير واضح/u, 'PDF pages 11-13 contain no unreadable public fragment');
assert.doesNotMatch(publicHtml, /هٰذَا التَّاجِرُ تَاجِرٌ/u, 'the old incorrect lesson 8 example must not return');

for (const fragment of [
  'تِلْكَ سُمَيَّةُ.',
  'هَذَا الرَّجُلُ تَاجِرٌ.',
  'النَّعْتُ يَتْبَعُ الْمَنْعُوتَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَالتَّعْرِيفِ وَالتَّنْكِيرِ، وَالْإِعْرَابِ، وَالْإِفْرَادِ.',
]) {
  assert.match(publicHtml, new RegExp(fragment.replace(/[.*+?^${}()|[\]\\]/gu, '\\$&'), 'u'), `missing source fragment: ${fragment}`);
}

const adjectiveBlock = htmlBlocks.find((html) => html.includes('النَّعْتُ يَتْبَعُ الْمَنْعُوتَ'));
const relativeBlock = htmlBlocks.find((html) => html.includes('الَّذِي: اِسْمٌ مَوْصُولٌ'));
assert.ok(adjectiveBlock, 'adjective card must exist');
assert.ok(relativeBlock, 'relative-pronoun card must exist');
assert.equal((adjectiveBlock.match(/rule-table-invalid/gu) || []).length, 6, 'all six invalid adjective forms must be visible');
assert.equal((relativeBlock.match(/rule-table-invalid/gu) || []).length, 3, 'all three invalid relative-clause forms must be visible');
assert.ok((publicHtml.match(/<div class="tbl-wrap"><table/gu) || []).length >= 5, 'wide tables must scroll inside their cards');

for (const html of htmlBlocks) {
  assert.match(html, /class="rule-study"/u, 'every card must use the shared rule design');
  assert.match(html, /dir="rtl" lang="ar"/u, 'every card must keep explicit Arabic RTL markup');
}

console.log('Book 1 lessons 7-9 full sharh checks passed.');
