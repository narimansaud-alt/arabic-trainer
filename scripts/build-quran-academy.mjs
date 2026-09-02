import fs from 'node:fs';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';

const nouns = JSON.parse(fs.readFileSync('data/quran-academy-study-source.json', 'utf8'));
const verbs = JSON.parse(fs.readFileSync('data/quran-academy-verb-source.json', 'utf8'));
const revision = 'uqa-85-2020-ru-v1';
const course = '1000 самых частых слов Корана'; // immutable historical DB ID, not the public title
const sourceURL = nouns.source;
const ordinary = (ar, verb = false) => {
  let text = ar.normalize('NFC').replace(/ـ/g, '').replace(/\s+/g, ' ').trim();
  if (verb && /^ا[^\u064b-\u065f]/u.test(text)) text = 'اِ' + text.slice(1);
  return text.normalize('NFC');
};
const entries = nouns.rows.map(([page, ar, ru, kind], index) => ({
  page, ar: ordinary(ar, kind === 'verb-phrase'), ru, kind,
  key: 'word-' + (index + 1), inputForm: kind === 'verb-phrase' ? 'past-phrase' : kind === 'construction' ? 'construction' : 'lemma',
}));
for (const [index, row] of verbs.rows.entries()) {
  const [page, past, present, imperative, active, passive, masdar, ru] = row;
  // The source's six columns are a grammar table, not six independently
  // counted Quranic words. Keep one lexical card; preserve the evidence.
  const exceptional = past === 'وَذَرَ';
  entries.push({page, ar: ordinary(exceptional ? present : past, true), ru, kind: 'verb',
    key: 'verb-' + (index + 1), inputForm: exceptional ? 'present' : 'past',
    forms: {past: ordinary(past, true), present: ordinary(present), imperative: ordinary(imperative),
      active: ordinary(active), passive: ordinary(passive), masdar: ordinary(masdar)},
  });
}
entries.sort((a, b) => a.page - b.page);
const merged = new Map();
for (const entry of entries) {
  assert.ok(entry.page >= 7 && entry.page <= 44);
  assert.ok(entry.ar && entry.ru);
  const existing = merged.get(entry.ar);
  const reference = {key: entry.key, page: entry.page, pdfPage: entry.page + 2};
  if (existing) {
    if (existing.ru !== entry.ru) existing.ru += '; ' + entry.ru[0].toLowerCase() + entry.ru.slice(1);
    existing.sourceRows.push(reference);
    if (entry.forms) existing.verbForms.push(entry.forms);
    if (entry.kind !== existing.kind) existing.kind = 'mixed';
  } else {
    merged.set(entry.ar, {ar: entry.ar, ru: entry.ru, kind: entry.kind, inputForm: entry.inputForm,
      sourceRows: [reference], verbForms: entry.forms ? [entry.forms] : []});
  }
}
const words = [...merged.values()].map((word, i) => ({...word, rank: i + 1, block: Math.floor(i / 50) + 1}));
const content = {
  revision, course, title: 'Частые слова Корана', blockSize: 50,
  source: {title: "85% of Qur’anic Words", author: 'Dr. Abdulazeez Abdulraheem', publisher: 'Understand Al-Qur’an Academy',
    url: sourceURL, landingPage: 'https://understandquran.com/e-books/', printedVocabularyPages: [7, 43], printedContextPage: 44,
    editorialNote: 'Independent Russian study meanings for Arabic lexical facts from the official selection. Not an official Russian translation, tafsir, or a claim that these cards alone confer 85% comprehension. Introductory prose, layout, illustrations and full conjugation appendices are not reproduced.',
  },
  sourceCounts: {wordRows: nouns.rows.length, verbRows: verbs.rows.length, mergedRows: entries.length - words.length},
  words,
};
content.sha256 = crypto.createHash('sha256').update(JSON.stringify(words)).digest('hex');
fs.writeFileSync('data/quran-academy-vocabulary.json', JSON.stringify(content, null, 2) + '\n');
console.log(JSON.stringify({cards: words.length, blocks: Math.ceil(words.length / 50), sourceCounts: content.sourceCounts, sha256: content.sha256}));
