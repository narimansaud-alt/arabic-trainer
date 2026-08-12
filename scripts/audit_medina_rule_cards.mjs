import fs from 'node:fs';

const api = fs.readFileSync('src/api.js', 'utf8');
const SUPA_URL = api.match(/const SUPA_URL = '([^']+)'/)?.[1];
const SUPA_ANON_KEY = api.match(/const SUPA_ANON_KEY =\s*'([^']+)'/m)?.[1];

if (!SUPA_URL || !SUPA_ANON_KEY) {
  throw new Error('Supabase public configuration was not found in src/api.js');
}

const ALL_COURSES = [
  'Мединский курс (Том 1)',
  'Мединский курс (Том 2)',
  'Мединский курс (Том 3)',
  'Мединский курс (Том 4)',
];
const requestedVolume = String(process.argv[2] || '').trim();
const COURSES = requestedVolume
  ? ALL_COURSES.filter((course) => course.endsWith(`(Том ${requestedVolume})`))
  : ALL_COURSES;

if (!COURSES.length) {
  throw new Error(`Unknown Medina course volume: ${requestedVolume}`);
}

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

function findUnvocalizedArabicWords(value) {
  const words = String(value || '').match(/[\p{Script_Extensions=Arabic}ـ]+/gu) || [];
  return uniqSorted(
    words.filter((word) => {
      const letters = word.match(/\p{Letter}/gu) || [];
      return letters.length > 1 && !/\p{Mark}/u.test(word);
    })
  );
}

function findDuplicateArabicMarks(value) {
  return uniqSorted(
    [...String(value || '').matchAll(/([\u064b-\u0652\u0670])\1/gu)].map((match) => match[0])
  );
}

function findUnbalancedTags(value) {
  const html = String(value || '');
  const tags = ['div', 'span', 'table', 'thead', 'tbody', 'tr', 'th', 'td', 'p'];
  return tags.filter((tag) => {
    const opens = html.match(new RegExp(`<${tag}\\b`, 'giu'))?.length || 0;
    const closes = html.match(new RegExp(`</${tag}>`, 'giu'))?.length || 0;
    return opens !== closes;
  });
}

function stripHtml(value) {
  return String(value || '')
    .replace(/<br\s*\/?>/giu, ' ')
    .replace(/<[^>]+>/gu, ' ')
    .replace(/&nbsp;/giu, ' ')
    .replace(/&lt;/giu, '<')
    .replace(/&gt;/giu, '>')
    .replace(/&amp;/giu, '&')
    .replace(/\s+/gu, ' ')
    .trim();
}

function hasArabic(value) {
  return /\p{Script_Extensions=Arabic}/u.test(String(value || ''));
}

function hasCyrillic(value) {
  return /\p{Script=Cyrillic}/u.test(String(value || ''));
}

function findTableTranslationGaps(rows) {
  const headers = [];
  const bodyRows = [];
  const structuralCells = [];
  const structuralHeader = /кто|значен|термин|роль|форма|местоим|падеж|состояни|показатель|исполнитель|вид|категор|род и число|лицо/u;
  for (const row of rows) {
    let tableIndex = 0;
    for (const table of String(row.content || '').matchAll(/<table\b[^>]*>([\s\S]*?)<\/table>/giu)) {
      tableIndex += 1;
      const trMatches = [...table[0].matchAll(/<tr\b[^>]*>([\s\S]*?)<\/tr>/giu)];
      const headerTexts = trMatches.length
        ? [...trMatches[0][1].matchAll(/<th\b[^>]*>([\s\S]*?)<\/th>/giu)].map((cell) => stripHtml(cell[1]).toLowerCase())
        : [];
      trMatches.forEach((tr, rowIndex) => {
        const cells = [...tr[1].matchAll(/<(th|td)\b[^>]*>([\s\S]*?)<\/\1>/giu)];
        const plainCells = cells.map((cell) => stripHtml(cell[2]));
        if (cells.some((cell) => cell[1].toLowerCase() === 'th')) {
          plainCells.forEach((cell, cellIndex) => {
            if (hasArabic(cell) && !hasCyrillic(cell)) {
              headers.push({
                rule: `${row.lesson_number}.${row.sort_order} ${row.title}`,
                table: tableIndex,
                column: cellIndex + 1,
                text: cell,
              });
            }
          });
          return;
        }
        const plainRow = plainCells.join(' ');
        if (hasArabic(plainRow) && !hasCyrillic(plainRow)) {
          bodyRows.push({
            rule: `${row.lesson_number}.${row.sort_order} ${row.title}`,
            table: tableIndex,
            row: rowIndex + 1,
            text: plainRow,
          });
        }
        plainCells.forEach((cell, cellIndex) => {
          if (
            hasArabic(cell) &&
            !hasCyrillic(cell) &&
            structuralHeader.test(headerTexts[cellIndex] || '')
          ) {
            structuralCells.push({
              rule: `${row.lesson_number}.${row.sort_order} ${row.title}`,
              table: tableIndex,
              row: rowIndex + 1,
              column: cellIndex + 1,
              text: cell,
            });
          }
        });
      });
    }
  }
  return { headers, bodyRows, structuralCells };
}

function findArabicExampleCardsWithoutRussian(rows) {
  const findings = [];
  for (const row of rows) {
    for (const card of String(row.content || '').matchAll(/<div\b[^>]*class="[^"]*rule-example-card[^"]*"[^>]*>([\s\S]*?)<\/div>/giu)) {
      if (/rule-example-ar/u.test(card[0]) && !/rule-example-ru/u.test(card[0])) {
        findings.push({
          rule: `${row.lesson_number}.${row.sort_order} ${row.title}`,
          text: stripHtml(card[1]),
        });
      }
    }
  }
  return findings;
}

async function fetchRules(course) {
  const qs = new URLSearchParams({
    select: 'id,lesson_number,title,content,sort_order,rule_kind,summary,rule_ar',
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
  const malformedPunctuation = rows
    .filter((row) => /؟\s*\.|\.\s*؟|[،؛]\s*\./u.test(`${row.rule_ar || ''}\n${row.content || ''}`))
    .map((row) => `${row.lesson_number}.${row.sort_order} ${row.title}`);
  const unbalancedMarkup = rows
    .map((row) => ({
      rule: `${row.lesson_number}.${row.sort_order} ${row.title}`,
      tags: findUnbalancedTags(row.content),
    }))
    .filter((entry) => entry.tags.length > 0);
  const duplicateArabicMarks = rows
    .map((row) => ({
      rule: `${row.lesson_number}.${row.sort_order} ${row.title}`,
      marks: findDuplicateArabicMarks(`${row.title}\n${row.rule_ar || ''}\n${row.content || ''}`),
    }))
    .filter((entry) => entry.marks.length > 0);
  const missingRuleAr = rows
    .filter((row) => !String(row.rule_ar || '').trim())
    .map((row) => `${row.lesson_number}.${row.sort_order} ${row.title}`);
  const unvocalizedRuleAr = rows
    .map((row) => ({
      rule: `${row.lesson_number}.${row.sort_order} ${row.title}`,
      words: findUnvocalizedArabicWords(row.rule_ar),
    }))
    .filter((entry) => entry.words.length > 0);
  const sortOrderGaps = Object.entries(lessonCounts)
    .map(([lesson, count]) => {
      const actual = rows
        .filter((row) => row.lesson_number === lesson)
        .map((row) => Number(row.sort_order))
        .sort((a, b) => a - b);
      const expected = Array.from({ length: count }, (_, index) => index + 1);
      return { lesson, actual, expected };
    })
    .filter((entry) => entry.actual.join(',') !== entry.expected.join(','));
  const tableTranslationGaps = findTableTranslationGaps(rows);
  const arabicExamplesWithoutRussian = findArabicExampleCardsWithoutRussian(rows);
  const invalidConnectedWasl = rows
    .filter((row) => /←[^<\n]{0,80}اَلْـ/u.test(String(row.content || '')))
    .map((row) => `${row.lesson_number}.${row.sort_order} ${row.title}`);
  const validConnectedWasl = rows
    .filter((row) =>
      row.lesson_number === '12' &&
      Number(row.sort_order) === 5 &&
      /ذَهَبَتْ \+ اَلْـ ← ذَهَبَتِ الْـ/u.test(String(row.content || ''))
    )
    .map((row) => `${row.lesson_number}.${row.sort_order} ${row.title}`);
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
    duplicateArabicMarks,
    malformedPunctuation,
    missingRuleAr,
    unvocalizedRuleAr,
    unbalancedMarkup,
    sortOrderGaps,
    tableTranslationGaps,
    arabicExamplesWithoutRussian,
    invalidConnectedWasl,
    validConnectedWasl,
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

  const isBookOne = course === ALL_COURSES[0];
  if (
    isBookOne &&
    (
      tableTranslationGaps.headers.length > 0 ||
      tableTranslationGaps.bodyRows.length > 0 ||
      tableTranslationGaps.structuralCells.length > 0 ||
      arabicExamplesWithoutRussian.length > 0 ||
      invalidConnectedWasl.length > 0 ||
      validConnectedWasl.length !== 1
    )
  ) {
    process.exitCode = 1;
  }
}
