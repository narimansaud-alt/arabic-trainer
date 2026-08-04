import fs from 'node:fs';
import path from 'node:path';

const sourcePath = process.argv[2] || 'backups/medina-book1-import/medina_book1_rules_ru.md';
const outlinePath = process.argv[3] || 'backups/medina-book1-import/medina_book1_import_outline.json';
const outputPath = process.argv[4] || 'backups/medina-book1-import/replace_tom1_rules.sql';
const courseName = 'Мединский курс (Том 1)';

const source = fs.readFileSync(sourcePath, 'utf8').replace(/^\uFEFF/, '').replace(/\r\n?/g, '\n');
const outline = JSON.parse(fs.readFileSync(outlinePath, 'utf8'));
const lines = source.split('\n');

function escText(value) {
  return String(value || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function inlineMarkdown(value) {
  const tags = [];
  let text = String(value || '').replace(/<\/?[a-z][^>]*>/gi, (tag) => {
    const key = `@@TAG_${tags.length}@@`;
    tags.push(tag);
    return key;
  });
  text = escText(text)
    .replace(/\*\*(.+?)\*\*/gu, '<b>$1</b>')
    .replace(/__(.+?)__/gu, '<b>$1</b>')
    .replace(/\*(.+?)\*/gu, '<i>$1</i>')
    .replace(/`([^`]+)`/gu, '<code>$1</code>');
  return text.replace(/@@TAG_(\d+)@@/g, (_, index) => tags[Number(index)] || '');
}

function parseTable(block) {
  const rows = block
    .filter((line) => /^\s*\|/.test(line))
    .map((line) => line.trim().replace(/^\|/, '').replace(/\|$/, '').split('|').map((cell) => cell.trim()));
  if (rows.length < 2 || !rows[1].every((cell) => /^:?-{3,}:?$/.test(cell))) return null;
  const head = rows[0].map((cell) => `<th>${inlineMarkdown(cell)}</th>`).join('');
  const body = rows.slice(2).map((row) => `<tr>${row.map((cell) => `<td>${inlineMarkdown(cell)}</td>`).join('')}</tr>`).join('');
  return `<table><thead><tr>${head}</tr></thead><tbody>${body}</tbody></table>`;
}

function markdownToHtml(rawLines) {
  const output = [];
  let paragraph = [];
  let list = [];
  let index = 0;

  const flushParagraph = () => {
    if (!paragraph.length) return;
    output.push(paragraph.map((line) => inlineMarkdown(line.trim())).join('<br>'));
    paragraph = [];
  };
  const flushList = () => {
    if (!list.length) return;
    output.push(`<ul>${list.map((item) => `<li>${inlineMarkdown(item)}</li>`).join('')}</ul>`);
    list = [];
  };

  while (index < rawLines.length) {
    const line = rawLines[index];
    if (!line.trim()) {
      flushParagraph();
      flushList();
      index += 1;
      continue;
    }
    if (/^\s*---+\s*$/.test(line)) {
      flushParagraph();
      flushList();
      index += 1;
      continue;
    }
    if (/^\s*\|/.test(line) && rawLines[index + 1] && /^\s*\|?\s*:?-{3,}/.test(rawLines[index + 1])) {
      flushParagraph();
      flushList();
      const tableLines = [];
      while (index < rawLines.length && /^\s*\|/.test(rawLines[index])) tableLines.push(rawLines[index++]);
      output.push(parseTable(tableLines) || tableLines.map((item) => inlineMarkdown(item)).join('<br>'));
      continue;
    }
    const heading = line.match(/^####\s+(.+)$/u);
    if (heading) {
      flushParagraph();
      flushList();
      output.push(`<h4>${inlineMarkdown(heading[1])}</h4>`);
      index += 1;
      continue;
    }
    const bullet = line.match(/^\s*[-*]\s+(.+)$/u);
    if (bullet) {
      flushParagraph();
      list.push(bullet[1]);
      index += 1;
      continue;
    }
    if (/^\s*<\/?[a-z]/i.test(line)) {
      flushParagraph();
      flushList();
      output.push(line.trim());
      index += 1;
      continue;
    }
    if (/^\s*>/.test(line)) {
      flushParagraph();
      flushList();
      output.push(`<div class="rule-note">${inlineMarkdown(line.replace(/^\s*>\s?/, ''))}</div>`);
      index += 1;
      continue;
    }
    paragraph.push(line);
    index += 1;
  }
  flushParagraph();
  flushList();
  return output.filter(Boolean).join('<br><br>');
}

function plainText(html) {
  return String(html || '')
    .replace(/<[^>]+>/g, ' ')
    .replace(/&nbsp;/g, ' ')
    .replace(/&amp;/g, '&')
    .replace(/\s+/g, ' ')
    .trim();
}

function sql(value) {
  return `'${String(value ?? '').replace(/'/g, "''")}'`;
}

const lessons = [];
let currentLesson = null;
let currentRule = null;
for (const line of lines) {
  const lessonMatch = line.match(/^##\s+.*\(Урок\s+(\d+)(?:;[^)]*)?\)\s*$/u);
  if (lessonMatch) {
    currentLesson = {
      number: Number(lessonMatch[1]),
      heading: line.replace(/^##\s+/, ''),
      internalParts: line.match(/;\s*(части?\s+[^)]+)\)/u)?.[1] || '',
      preamble: [],
      rules: [],
    };
    lessons.push(currentLesson);
    currentRule = null;
    continue;
  }
  if (!currentLesson) continue;
  const ruleMatch = line.match(/^###(?:\s+\d+\.)?\s+(.+?)\s*$/u);
  if (ruleMatch) {
    currentRule = { title: ruleMatch[1], body: [] };
    currentLesson.rules.push(currentRule);
    continue;
  }
  if (currentRule) currentRule.body.push(line);
  else currentLesson.preamble.push(line);
}

const expectedLessons = Array.from({ length: 23 }, (_, index) => index + 1);
const lessonNumbers = lessons.map((lesson) => lesson.number);
if (JSON.stringify(lessonNumbers) !== JSON.stringify(expectedLessons)) {
  throw new Error(`Ожидались уроки 1..23 без пропусков, получено: ${lessonNumbers.join(', ')}`);
}
if (outline.lesson_count !== 23 || outline.lessons?.length !== 23) {
  throw new Error('Карта импорта не подтверждает 23 урока. Импорт остановлен.');
}
if (lessons.some((lesson) => !lesson.rules.length)) throw new Error('Найден урок без правил.');

const rows = [];
for (const lesson of lessons) {
  const rules = lesson.rules;
  rules.forEach((rule, ruleIndex) => {
    const structureNote = lesson.internalParts ? [`<div class="rule-note"><b>Внутренняя структура:</b> ${lesson.internalParts}.</div>`, ''] : [];
    const body = ruleIndex === 0
      ? [...structureNote, ...lesson.preamble, ...(lesson.preamble.some((line) => line.trim()) ? ['', ...rule.body] : rule.body)]
      : rule.body;
    const content = markdownToHtml(body);
    const summary = plainText(content).slice(0, 240);
    const ruleKind = /مراجعة|контрольный урок/iu.test(rule.title) ? 'note' : 'rule';
    rows.push({
      lesson: lesson.number,
      sort: ruleIndex + 1,
      title: rule.title,
      content,
      summary,
      ruleKind,
    });
  });
}

const arabicRange = /[\u0600-\u06FF]/u;
const cyrillicRange = /[\u0400-\u04FF]/u;
for (const row of rows) {
  if (!row.title || !row.content) throw new Error(`Пустое правило в уроке ${row.lesson}`);
  if (arabicRange.test(row.title) && /[\uFFFD]/u.test(row.title)) throw new Error(`Повреждённый Unicode в заголовке урока ${row.lesson}`);
  if (row.content.includes('???')) throw new Error(`Подозрительный текст в уроке ${row.lesson}`);
  if (cyrillicRange.test(row.title) && !/[А-Яа-яЁё]/u.test(row.title)) throw new Error(`Неожиданный текст в заголовке урока ${row.lesson}`);
}
for (const lesson of lessons) {
  if (lesson.number >= 10 && !rows.some((row) => row.lesson === lesson.number && row.content.includes('iarab-example')) && ![11, 17, 21].includes(lesson.number)) {
    console.warn(`Предупреждение: в уроке ${lesson.number} нет i\'раб-примеров`);
  }
}

const values = rows.map((row) => `(${sql(courseName)}, ${sql(String(row.lesson))}, ${sql(row.title)}, ${sql(row.content)}, ${row.sort}, ${sql(row.ruleKind)}, ${sql(row.summary)})`).join(',\n');
const sqlText = `-- Generated from medina_book1_rules_ru.md; parts 4A, 9A-9B and 13A-13C stay inside lessons 4, 9 and 13.\n-- This script replaces only the rules for ${courseName}.\nbegin;\n\ndelete from public.rules where course_name = ${sql(courseName)};\n\ninsert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary)\nvalues\n${values};\n\ncommit;\n`;
fs.mkdirSync(path.dirname(outputPath), { recursive: true });
fs.writeFileSync(outputPath, sqlText, 'utf8');
fs.writeFileSync(outputPath.replace(/\.sql$/u, '.manifest.json'), JSON.stringify({
  source: path.basename(sourcePath),
  lessonCount: lessons.length,
  ruleCount: rows.length,
  rulesPerLesson: Object.fromEntries(lessons.map((lesson) => [lesson.number, lesson.rules.length])),
  internalParts: Object.fromEntries(lessons.filter((lesson) => lesson.internalParts).map((lesson) => [lesson.number, lesson.internalParts])),
  generatedAt: new Date().toISOString(),
}, null, 2), 'utf8');
console.log(JSON.stringify({ lessonCount: lessons.length, ruleCount: rows.length, outputPath }, null, 2));
