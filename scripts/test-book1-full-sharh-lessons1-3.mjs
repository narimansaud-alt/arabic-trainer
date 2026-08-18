import assert from 'node:assert/strict';
import fs from 'node:fs';

const migrationUrl = new URL(
  '../supabase/migrations/20260818130000_full_book1_lessons01_03_sharh_ru.sql',
  import.meta.url
);
const sql = fs.readFileSync(migrationUrl, 'utf8');
const htmlBlocks = [...sql.matchAll(/\$html\$([\s\S]*?)\$html\$/gu)].map((match) => match[1]);
const publicHtml = htmlBlocks.join('\n');

assert.equal(htmlBlocks.length, 10, 'lessons 1-3 must keep all ten existing rule cards');
assert.equal((publicHtml.match(/Полный перевод:/gu) || []).length, 15, 'all fifteen author explanation blocks must have Russian translations');
assert.doesNotMatch(sql, /موضع غير واضح/u, 'no source passage in PDF pages 3-7 is unreadable');
assert.doesNotMatch(publicHtml, /الْغِذَاءُ/u, 'the public source example must not be changed from lunch to food');
assert.match(publicHtml, /الْغَدَاءُ/gu, 'the PDF source form for lunch must be preserved');

const requiredArabic = [
  'هَذَا: اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْقَرِيبِ، الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ.',
  'مَا: اِسْمُ اِسْتِفْهَامٍ لِغَيْرِ الْعَاقِلِ.',
  'مَا هَذَا؟ هَذَا رَجُلٌ. ✕',
  'مَا هَذَا؟ هَذَا وَلَدٌ. ✕',
  'أَهَذَا رَجُلٌ؟ نَعَمْ. هَذَا رَجُلٌ.',
  'أَهَذَا وَلَدٌ؟ لَا. هَذَا رَجُلٌ.',
  'أَهَذَا كَلْبٌ؟ نَعَمْ. هَذَا كَلْبٌ.',
  'أَهَذَا قِطٌّ؟ لَا. هَذَا كَلْبٌ.',
  'مَنْ: اِسْمُ اِسْتِفْهَامٍ لِلْعَاقِلِ.',
  'مَنْ هَذَا؟ هَذَا كِتَابٌ. ✕',
  'مَنْ هَذَا؟ هَذَا قَلَمٌ. ✕',
  'ذَلِكَ: اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْبَعِيدِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ.',
  'مَنْ ذَلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ الْعَاقِلِ.',
  'مَا ذَلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ غَيْرِ الْعَاقِلِ.',
  'أَلْ: حَرْفُ تَعْرِيفٍ.',
  'يُحْذَفُ التَّنْوِينُ عِنْدَ دُخُولِ أَلْ.',
  'الْقَلَمٌ. ✕',
  'قَلَمُ. ✕',
  'الْوَلَدٌ جَالِسٌ. ✕',
  'النَّكِرَةُ: شَيْءٌ غَيْرُ مُعَيَّنٍ، نَحْوُ: بَيْتٌ، قَلَمٌ، رَجُلٌ، بِنْتٌ.',
  'الْمَعْرِفَةُ: شَيْءٌ مُعَيَّنٌ، نَحْوُ: الْبَيْتُ، الْقَلَمُ، الرَّجُلُ، الْبِنْتُ.',
  'بَيْتٌ: يَشْمَلُ كُلَّ الْبُيُوتِ، وَلَيْسَ بَيْتًا مُعَيَّنًا.',
  'الْبَيْتُ: يَدُلُّ عَلَى بَيْتٍ مُعَيَّنٍ بِذَاتِهِ.',
  'الْحُرُوفُ الْقَمَرِيَّةُ: يُنْطَقُ السُّكُونُ عَلَى اللَّامِ (الْقَمَرُ).',
  'الْحُرُوفُ الشَّمْسِيَّةُ: لَا يُنْطَقُ السُّكُونُ عَلَى اللَّامِ، وَتُوضَعُ شَدَّةٌ عَلَى الْحَرْفِ الَّذِي بَعْدَهُ (الشَّمْسُ).',
];

for (const fragment of requiredArabic) {
  assert.ok(htmlBlocks.some((html) => html.includes(fragment)), `missing source fragment: ${fragment}`);
}

const yesNoBlock = htmlBlocks.find((html) => html.includes('هَمْزَةُ الِاسْتِفْهَامِ'));
assert.ok(yesNoBlock, 'question-hamza card must exist');
assert.equal((yesNoBlock.match(/أَهَذَا/gu) || []).length, 8, 'all eight yes/no examples from PDF pages 3-4 must be visible');

const lunarSolarBlock = htmlBlocks.find((html) => html.includes('الْحُرُوفُ الْقَمَرِيَّةُ'));
assert.ok(lunarSolarBlock, 'lunar/solar card must exist');
assert.equal((lunarSolarBlock.match(/<tbody>/gu) || []).length, 2, 'both source letter lists must remain tables');
assert.equal((lunarSolarBlock.match(/<tr>/gu) || []).length, 30, 'the two headers and all 28 source letter examples must be present');
assert.match(lunarSolarBlock, /<div class="tbl-wrap"><table/u, 'wide tables must scroll inside their cards');

for (const html of htmlBlocks) {
  assert.match(html, /class="rule-study"/u, 'every card must use the shared rule design');
  assert.match(html, /dir="rtl" lang="ar"/u, 'every card must keep explicit Arabic RTL markup');
}

assert.match(sql, /source_text = \$source\$[\s\S]*الْقَلَمٌ ✕[\s\S]*قَلَمُ ✕[\s\S]*الْوَلَدٌ جَالِسٌ ✕\$source\$/u, 'private source_text must restore all three invalid forms verbatim');
assert.match(sql, /replace\(source_text, 'غ : الْغِذَاءُ', 'غ : الْغَدَاءُ'\)/u, 'private source_text must be corrected against the visible PDF');

console.log('Book 1 lessons 1-3 full sharh checks passed.');
