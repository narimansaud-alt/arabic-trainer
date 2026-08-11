import fs from 'node:fs';

const api = fs.readFileSync('src/api.js', 'utf8');
const SUPA_URL = api.match(/const SUPA_URL = '([^']+)'/)?.[1];
const SUPA_ANON_KEY = api.match(/const SUPA_ANON_KEY =\s*'([^']+)'/m)?.[1];

if (!SUPA_URL || !SUPA_ANON_KEY) {
  throw new Error('Supabase public configuration was not found in src/api.js');
}

const COURSES = [
  'Мединский курс (Том 1)',
  'Мединский курс (Том 2)',
  'Мединский курс (Том 3)',
];

function countBy(rows, key) {
  const out = {};
  for (const row of rows) out[row[key]] = (out[row[key]] || 0) + 1;
  return Object.fromEntries(Object.entries(out).sort((a, b) => Number(a[0]) - Number(b[0])));
}

function collectFallbackTerms(html) {
  const marker = '<span class="rule-term-ru">см. подробное объяснение и примеры ниже</span>';
  const parts = String(html || '').split(marker);
  const terms = [];
  for (let index = 0; index < parts.length - 1; index += 1) {
    const before = parts[index];
    const start = before.lastIndexOf('<span class="rule-term-ar"');
    if (start < 0) {
      terms.push('?');
      continue;
    }
    const segment = before.slice(start);
    const match = segment.match(/<span class="rule-term-ar"[^>]*>([^<]*)<\/span>$/u);
    terms.push(match?.[1] || '?');
  }
  return terms;
}

function uniqSorted(values) {
  return [...new Set(values)].sort((a, b) => a.localeCompare(b));
}

async function fetchRules(course) {
  const qs = new URLSearchParams({
    select: 'lesson_number,title,content,sort_order,rule_kind,summary',
    course_name: `eq.${course}`,
    order: 'lesson_number.asc,sort_order.asc,id.asc',
  });
  const response = await fetch(`${SUPA_URL}/rest/v1/rules?${qs}`, {
    headers: {
      apikey: SUPA_ANON_KEY,
      authorization: `Bearer ${SUPA_ANON_KEY}`,
    },
  });
  const body = await response.text();
  if (!response.ok) {
    throw new Error(`Failed to fetch ${course}: ${response.status} ${body.slice(0, 500)}`);
  }
  return JSON.parse(body);
}

for (const course of COURSES) {
  const rows = await fetchRules(course);
  const text = rows.map((row) => `${row.title}\n${row.content}\n${row.summary || ''}`).join('\n');
  const fallbackTerms = rows.flatMap((row) => collectFallbackTerms(row.content));
  const fallbackCounts = {};
  for (const term of fallbackTerms) fallbackCounts[term] = (fallbackCounts[term] || 0) + 1;
  const lessonCounts = countBy(rows, 'lesson_number');
  const report = {
    course,
    rows: rows.length,
    lessonCounts,
    ruleStudy: rows.filter((row) => String(row.content).includes('rule-study')).length,
    sourceCards: rows.filter((row) => String(row.content).includes('rule-study-source')).length,
    kindGrammar: rows.filter((row) => row.rule_kind === 'grammar').length,
    mojibake: /Рќ|Рђ|вЂ|Щ‡|Ш§/u.test(text),
    importTrash: /Обязательные требования|Внутренняя структура/u.test(text),
    doubleHarakat: /الْخَبَرُُ|الْمُبْتَدَأُُ|إِنََّّ|كَانََ/u.test(text),
    fallbackCount: fallbackTerms.length,
    fallbackTerms: Object.entries(fallbackCounts)
      .sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]))
      .slice(0, 80)
      .map(([term, count]) => ({ term, count })),
    titlesWithoutRussian: rows
      .filter((row) => !/\([^()]*[А-Яа-яЁё][^()]*\)/u.test(row.title))
      .map((row) => `${row.lesson_number}.${row.sort_order} ${row.title}`)
      .slice(0, 50),
    lessonSamples: Object.fromEntries(
      uniqSorted(rows.map((row) => row.lesson_number))
        .filter((lesson) => ['1', '6', '10', '11', '15', '17', '21', '23', '31'].includes(lesson))
        .map((lesson) => [
          lesson,
          rows
            .filter((row) => row.lesson_number === lesson)
            .map((row) => `${row.sort_order}. ${row.title}`),
        ])
    ),
  };
  console.log(JSON.stringify(report, null, 2));
}
