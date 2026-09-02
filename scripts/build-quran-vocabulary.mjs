import fs from 'node:fs/promises';
export function standardArabic(value) {
  // QAC's combining U+0653 is a recitation prolongation mark, not hamza.
  // Remove BEFORE NFC, which would otherwise compose alif + mark into آ.
  return value.replace(/\u0653/g, '').normalize('NFC')
    .replace(/ـ/g, '').replace(/ٱ/g, 'ا')
    .replace(/^ءَا/, 'آ')
    .replace(/ىٰ/g, 'ى').replace(/وٰ/g, 'ا').replace(/ٰ/g, 'ا')
    .replace(/[\u0653\u06d6-\u06ed]/g, '')
    .replace(/^([\u0621-\u064a])([َُِ]?)ّ/, '$1$2')
    .replace(/ى(?=[\u0621-\u064a])/g, 'ي')
    .normalize('NFC');
}
const source = JSON.parse(await fs.readFile('data/quran-frequency-source.json', 'utf8'));
const context = JSON.parse(await fs.readFile('data/quran-frequency-context.json', 'utf8'));
const ru = new Map((await fs.readFile('data/quran-vocabulary-ru.txt','utf8')).split(/\r?\n/).filter(s=>s && !s.startsWith('#')).map(s=>{
  const [rank, russian, arabic] = s.split('|');
  return [Number(rank),{russian,arabic}];
}));
const entries = source.words.map(w=>({
  sourceRank:w.rank, ar:ru.get(w.rank)?.arabic || standardArabic(w.sourceArabic),
  ru:ru.get(w.rank)?.russian || '', frequency:w.frequency, kind:w.kind,
  sourceRecords:[{sourceRank:w.rank, url:w.source, rawFrequency:w.frequency}],
  note:'', example:context.words[w.rank-1].occurrences[0].location
}));
for (const entry of entries) {
  // Standalone past-tense forms VII–X start with kasra on hamzat al-wasl.
  const original = source.words[entry.sourceRank-1];
  if (original.kind === 'verb' && ['VII','VIII','IX','X'].includes(original.grammar)) {
    entry.ar = entry.ar.replace(/^ا(?=[^َُِ])/u,'اِ');
  }
}
// Published table groupings with demonstrably different Arabic lexical forms.
// Correct by explicit occurrence locations, never by guessing from an English gloss.
const corrections = [];
const at = n => entries[n-1];
function removeLocations(rank, locations, note) {
  const evidence = context.words[rank-1].occurrences;
  if (!locations.every(l=>evidence.some(o=>o.location===l))) throw new Error('Missing correction evidence ' + rank);
  at(rank).frequency -= locations.length;
  at(rank).note = note;
  corrections.push({sourceRank:rank, excludedLocations:locations, note});
}
const sons = context.words[131].occurrences;
if (sons.length !== 80) throw new Error('Complete 80-token group is required');
const sonny = sons.filter(o=>o.form.includes('بُنَي')).map(o=>o.location);
if (!sonny.length) throw new Error('Diminutive form not found');
removeLocations(132, sonny, 'В таблице QAC сыновья и уменьшительное «сынок» объединены. Здесь посчитаны только формы со значением «сыновья».');
const prosperLocations = ['7:92:6','10:24:37','11:68:3','11:95:3'];
const enrich = context.words[626].occurrences.filter(o=>!prosperLocations.includes(o.location));
if (enrich.length !== 11 || !enrich.every(o=>o.form.includes('أَغْن'))) throw new Error('Unexpected غني group');
at(627).frequency = 4;
at(382).frequency += 11;
at(382).sourceRecords.push(...at(627).sourceRecords);
at(382).note = '11 форм أَغْنَى из группы I породы QAC отнесены к أَغْنَى (IV). Формы غَنِيَ не включены.';
corrections.push({sourceRank:627,movedTo:382,locations:enrich.map(o=>o.location),retainedLocations:prosperLocations});
removeLocations(777,['14:43:9'],'Из группы исключено هَوَاء «пустота» (14:43); здесь هَوَى «страсть».');
const chains = context.words[887].occurrences.filter(o=>o.form.includes('أَغْلَال')).map(o=>o.location);
if(chains.length !== 6) throw new Error('Unexpected غل group');
removeLocations(888,chains,'Из группы غِلّ «злоба» исключены шесть форм أَغْلَال «оковы». Обе группы ниже порога этой тысячи.');
removeLocations(1010,['2:87:22','5:70:14','53:23:19','53:53:2'],'Из группы هَوَى исключены три формы هَوِيَ «желать» и одна أَهْوَى (IV); оставлены четыре формы «падать; склоняться».');
// Homographs count as one study card, with combined senses and source links.
const grouped = new Map();
for (const e of entries) {
  const key = e.ar.normalize('NFC');
  if (!grouped.has(key)) grouped.set(key,e);
  else {
    const target=grouped.get(key);
    target.frequency+=e.frequency;
    target.sourceRecords.push(...e.sourceRecords);
    if (target.kind !== e.kind) target.kind = 'mixed';
    if (e.note) target.note = [target.note,e.note].filter(Boolean).join(' ');
    target.ru=[target.ru,e.ru].filter(Boolean).join('; ');
    corrections.push({mergedSourceRank:e.sourceRank,into:target.sourceRank,arabic:e.ar});
  }
}
const words=[...grouped.values()].sort((a,b)=>b.frequency-a.frequency || a.sourceRank-b.sourceRank).slice(0,1000).map((e,i)=>({...e,rank:i+1,block:Math.floor(i/50)+1}));
const missing=words.flatMap(w=>w.sourceRecords.filter(r=>!ru.get(r.sourceRank)?.russian).map(r=>entries[r.sourceRank-1]));
if(missing.length) {
  console.log('Translation required:', missing.map(w=>({sourceRank:w.sourceRank,ar:w.ar,frequency:w.frequency,source:source.words[w.sourceRank-1].gloss,occurrences:context.words[w.sourceRank-1].occurrences.slice(0,3)})));
  process.exitCode=1;
} else {
  const result={
    course:'1000 самых частых слов Корана',
    source:'https://corpus.quran.com/lemmas.jsp?group=1',
    verbsSource:'https://corpus.quran.com/verbs.jsp',
    method:'Частоты словарных групп QAC: объединены таблицы имён/частиц и глаголов; одинаковые написания объединены, документированные смешения форм исправлены по вхождениям. Аффиксы и местоимения без отдельной записи в этих таблицах не включены. Это учебная лексическая тысяча, не рейтинг всех отдельных словоформ текста.',
    russian:'Краткие русские учебные значения подготовлены по арабским формам и контекстным глоссам QAC. Это не перевод аятов и не тафсир.',
    copyright:source.copyright,
    corrections, words
  };
  await fs.writeFile('data/quran-vocabulary.json',JSON.stringify(result,null,2)+'\n');
  console.log('Built',words.length,'unique cards;',corrections.length,'documented grouping corrections;',words.at(-1).frequency,'minimum frequency.');
}
