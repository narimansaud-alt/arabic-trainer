import fs from 'node:fs';

const apiSource = fs.readFileSync('src/api.js', 'utf8');
const url = apiSource.match(/const SUPA_URL = '([^']+)'/u)?.[1];
const key = apiSource.match(/const SUPA_ANON_KEY =\s*'([^']+)'/u)?.[1];
if (!url || !key) throw new Error('Supabase connection settings were not found in src/api.js');

async function read(path, query) {
  const requestUrl = `${url}/rest/v1/${path}?${new URLSearchParams(query)}`;
  let lastError;
  for (let attempt = 1; attempt <= 3; attempt += 1) {
    try {
      const response = await fetch(requestUrl, {
        headers: { apikey: key, authorization: `Bearer ${key}` },
        signal: AbortSignal.timeout(20_000),
      });
      const body = await response.text();
      if (!response.ok) throw new Error(`${path}: ${response.status} ${body}`);
      return JSON.parse(body);
    } catch (error) {
      lastError = error;
      if (attempt < 3) await new Promise((resolve) => setTimeout(resolve, attempt * 500));
    }
  }
  throw lastError;
}

const expectedVolumes = [
  { volume: 1, course: 'Мединский курс (Том 1)', rules: 70, lessons: 23, quran: 0 },
  { volume: 2, course: 'Мединский курс (Том 2)', rules: 148, lessons: 31, quran: 5 },
  { volume: 3, course: 'Мединский курс (Том 3)', rules: 89, lessons: 17, quran: 50 },
];

function countQuranFragments(html) {
  return [...String(html || '').matchAll(/﴿[\s\S]*?﴾/gu)].length;
}

function findUnbalancedTags(html) {
  const issues = [];
  for (const tag of ['div', 'span', 'table', 'thead', 'tbody', 'tr', 'th', 'td', 'p']) {
    const opens = String(html || '').match(new RegExp(`<${tag}\\b`, 'giu'))?.length || 0;
    const closes = String(html || '').match(new RegExp(`</${tag}>`, 'giu'))?.length || 0;
    if (opens !== closes) issues.push({ tag, opens, closes });
  }
  return issues;
}

const result = {
  volumes: {},
  totals: { rules: 0, lessons: 0, quran: 0 },
  staticAssets: {},
  issues: [],
};

for (const expected of expectedVolumes) {
  const rows = await read('rules', {
    select: 'id,lesson_number,title,content,sort_order,rule_ar',
    course_name: `eq.${expected.course}`,
    order: 'lesson_number.asc,sort_order.asc,id.asc',
    limit: '1000',
  });
  const lessons = [...new Set(rows.map((row) => Number(row.lesson_number)))].sort((a, b) => a - b);
  const expectedLessons = Array.from({ length: expected.lessons }, (_, index) => index + 1);
  const quran = rows.reduce((sum, row) => sum + countQuranFragments(row.content), 0);
  const missingRuleAr = rows.filter((row) => !String(row.rule_ar || '').trim()).map((row) => row.id);
  const missingRussianTitle = rows
    .filter((row) => !/\([^()]*[А-Яа-яЁё][^()]*\)/u.test(String(row.title || '')))
    .map((row) => row.id);
  const sortGaps = [];
  for (const lesson of lessons) {
    const actual = rows
      .filter((row) => Number(row.lesson_number) === lesson)
      .map((row) => Number(row.sort_order))
      .sort((a, b) => a - b);
    const wanted = Array.from({ length: actual.length }, (_, index) => index + 1);
    if (actual.join(',') !== wanted.join(',')) sortGaps.push({ lesson, actual, expected: wanted });
  }
  const markupIssues = rows
    .map((row) => ({ id: row.id, tags: findUnbalancedTags(row.content) }))
    .filter((row) => row.tags.length);
  const unclearPlaceholders = rows
    .filter((row) => /موضع غير واضح في المصدر|موضع قرآني غير واضح/u.test(`${row.title}\n${row.content}\n${row.rule_ar || ''}`))
    .map((row) => row.id);

  const volumeIssues = [];
  if (rows.length !== expected.rules) volumeIssues.push(`rules ${rows.length}/${expected.rules}`);
  if (lessons.join(',') !== expectedLessons.join(',')) volumeIssues.push('lesson sequence');
  if (quran !== expected.quran) volumeIssues.push(`Qur'an fragments ${quran}/${expected.quran}`);
  if (missingRuleAr.length) volumeIssues.push(`missing rule_ar: ${missingRuleAr.join(',')}`);
  if (missingRussianTitle.length) volumeIssues.push(`missing Russian title meanings: ${missingRussianTitle.join(',')}`);
  if (sortGaps.length) volumeIssues.push(`sort gaps: ${JSON.stringify(sortGaps)}`);
  if (markupIssues.length) volumeIssues.push(`markup: ${JSON.stringify(markupIssues)}`);
  if (unclearPlaceholders.length) volumeIssues.push(`unclear placeholders: ${unclearPlaceholders.join(',')}`);

  result.volumes[expected.volume] = {
    course: expected.course,
    rules: rows.length,
    lessons: lessons.length,
    quran,
    issues: volumeIssues,
  };
  result.totals.rules += rows.length;
  result.totals.lessons += lessons.length;
  result.totals.quran += quran;
  result.issues.push(...volumeIssues.map((issue) => `Book ${expected.volume}: ${issue}`));
}

const fontCss = fs.readFileSync('assets/fonts/local-fonts.css', 'utf8');
const indexHtml = fs.readFileSync('index.html', 'utf8');
const serviceWorker = fs.readFileSync('sw.js', 'utf8');
const fontPath = 'assets/fonts/UthmanicHafs1Ver18.woff2';
const fontBytes = fs.existsSync(fontPath) ? fs.statSync(fontPath).size : 0;
result.staticAssets = {
  qpcFontBytes: fontBytes,
  fontFaceRegistered: /font-family:\s*['"]Uthmanic Hafs['"]/u.test(fontCss),
  quranStyleUsesFont: /\.rule-quran-ar[\s\S]*?font-family:\s*['"]Uthmanic Hafs['"]/u.test(indexHtml),
  quranStyleForcesBlack: /\.rule-quran-ar[\s\S]*?color:\s*#000\s*!important/u.test(indexHtml),
  serviceWorkerPrecachesFont: serviceWorker.includes('./assets/fonts/UthmanicHafs1Ver18.woff2'),
};
for (const [name, value] of Object.entries(result.staticAssets)) {
  if (name === 'qpcFontBytes' ? value < 80_000 : !value) result.issues.push(`Static asset check failed: ${name}`);
}

console.log(JSON.stringify(result, null, 2));
if (result.issues.length) process.exitCode = 1;
