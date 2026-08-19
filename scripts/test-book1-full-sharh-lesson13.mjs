import assert from 'node:assert/strict';
import fs from 'node:fs';

const sql = fs.readFileSync(new URL('../supabase/migrations/20260819120000_full_book1_lesson13_sharh_ru.sql', import.meta.url), 'utf8');
const sourceMigration = fs.readFileSync(new URL('../supabase/migrations/20260812170000_verify_book1_lesson13_from_sharh.sql', import.meta.url), 'utf8');
const htmlBlocks = [...sql.matchAll(/\$html\$([\s\S]*?)\$html\$/gu)].map((match) => match[1]);

assert.equal(htmlBlocks.length, 2, 'lesson 13 must rebuild only the two previously compressed cards');
assert.equal((sql.match(/<span class="rule-card-kicker">Полный текст шарха ·/gu) || []).length, 9, 'all nine lesson 13 cards must receive source-page markers');
assert.doesNotMatch(sql, /موضع غير واضح/u, 'PDF pages 19-22 contain no unreadable fragment');

for (const fragment of [
  'إِضَافَةُ الْأَسْمَاءِ إِلَى الِاسْمِ الظَّاهِرِ، وَالضَّمِيرِ.',
  'الضَّمِيرُ، نَحْوُ: هُوَ، هُمْ، كَ، كِ (كَافُ الْمُخَاطَبِ)، ي (يَاءُ الْمُتَكَلِّمِ).',
  'أَبْنَاءُ مُحَمَّدٍ',
  'أَبْنَاؤُهُ',
  'أَبْنَاؤُكَ',
  'كِتَابِي',
  'أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ',
  'أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ',
  'الْأَسْمَاءُ الْمَوْصُولَةُ',
  'الطَّالِبَةُ الَّتِي ذَهَبَتْ مِنَ السُّودَانِ',
]) {
  assert.ok(sql.includes(fragment), `missing rebuilt lesson 13 fragment: ${fragment}`);
}

for (const sourceFragment of [
  'هَؤُلَاءِ : اِسْمُ إِشَارَةٍ لِلْجَمْعِ الْقَرِيبِ',
  'هُمْ : ضَمِيرُ جَمْعِ الْغَائِبِ الْمُذَكَّرِ الْعَاقِلِ',
  'وَاوُ الْجَمَاعَةِ : ضَمِيرٌ لِلْمُذَكَّرِ الْعَاقِلِ',
  'هُنَّ : ضَمِيرُ جَمْعِ الْغَائِبِ الْمُؤَنَّثِ الْعَاقِلِ',
  'تَاءُ التَّأْنِيثِ : حَرْفٌ سَاكِنٌ',
  'نُونُ النِّسْوَةِ : ضَمِيرٌ لِلْمُؤَنَّثِ الْعَاقِلِ',
  'أُولَئِكَ : اِسْمُ إِشَارَةٍ لِلْجَمْعِ الْبَعِيدِ',
]) {
  assert.ok(sourceMigration.includes(sourceFragment), `missing source-backed lesson 13 concept: ${sourceFragment}`);
}

assert.match(sql, /replace\(replace\(content, '<table', '<div class="tbl-wrap"><table'\), '<\/table>', '<\/table><\/div>'\)/u, 'all pre-existing wide tables must receive internal scrolling wrappers');
assert.match(sql, /'Неверно: для неразумного множественного «книги» употребляется форма единственного женского рода[\s\S]*'Неверно: <span dir="rtl" lang="ar">أُولَئِكَ<\/span> здесь соединено с неразумным множественным/u, 'the unprinted alternative must be replaced with the source-backed explanation');

for (const html of htmlBlocks) {
  assert.match(html, /class="rule-study"/u, 'rebuilt cards must use the shared rule design');
  assert.match(html, /dir="rtl" lang="ar"/u, 'rebuilt cards must keep explicit Arabic RTL markup');
}

console.log('Book 1 lesson 13 full sharh checks passed.');
