import fs from 'node:fs';
import path from 'node:path';
import { BOOK2_LESSON_PAGES, BOOK2_RULES, BOOK2_WORDS_14_31 } from '../data/medina-book2-content.mjs';

const COURSE = 'Мединский курс (Том 2)';
const output = process.argv[2] || 'supabase/migrations/20260805093000_complete_medina_book2.sql';
const sql = (value) => `'${String(value ?? '').replaceAll("'", "''")}'`;
const esc = (value) => String(value ?? '').replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;');
const expected = Array.from({ length: 31 }, (_, index) => index + 1);
const lessons = Object.keys(BOOK2_RULES).map(Number).sort((a,b) => a-b);
if (JSON.stringify(lessons) !== JSON.stringify(expected)) throw new Error('Правила должны покрывать уроки 1–31 без пропусков.');
if (Object.keys(BOOK2_LESSON_PAGES).length !== 31) throw new Error('Карта страниц должна покрывать 31 урок.');

const rows = [];
for (const lesson of expected) {
  const rules = BOOK2_RULES[lesson];
  if (!Array.isArray(rules) || !rules.length) throw new Error(`В уроке ${lesson} нет правил.`);
  rules.forEach((item,index) => {
    if (!item.ar || !item.ru || !item.explanation || !item.examples?.length) throw new Error(`Неполное правило: урок ${lesson}, позиция ${index+1}.`);
    const examples = `<ul>${item.examples.map(([ar,ru]) => `<li><b dir="rtl" lang="ar">${esc(ar)}</b> — ${esc(ru)}</li>`).join('')}</ul>`;
    const note = item.note ? `<br><br><div class="rule-note"><b>Как проверить себя.</b> ${esc(item.note)}</div>` : '';
    const [fromPage,toPage] = BOOK2_LESSON_PAGES[lesson];
    const content = `<b>Суть правила.</b> ${esc(item.explanation)}<br><br><b>Примеры.</b>${examples}${note}<br><br><span class="rule-source-note">Книга, том 2: страницы ${fromPage}–${toPage}.</span>`;
    rows.push([COURSE,String(lesson),`${item.ar} (${item.ru})`,content,index+1,'rule',item.explanation.slice(0,240)]);
  });
}

const seen = new Set();
for (const [lesson,ar,ru] of BOOK2_WORDS_14_31) {
  if (lesson < 14 || lesson > 31 || !ar || !ru) throw new Error(`Некорректная строка словаря: ${JSON.stringify([lesson,ar,ru])}`);
  const key = `${lesson}|${ar}`;
  if (seen.has(key)) throw new Error(`Дубль слова: ${key}`);
  seen.add(key);
}
const values = [...rows.flat(),...BOOK2_WORDS_14_31.flat()].join('|');
if (/\uFFFD/u.test(values) || /(?:Р.|С.){4}/u.test(values)) throw new Error('Обнаружен поврежденный Unicode.');

const ruleValues = rows.map((row) => `(${row.map(sql).join(', ')})`).join(',\n');
const wordValues = BOOK2_WORDS_14_31.map(([lesson,ar,ru]) => `(${sql(ar)}, ${sql(ru)}, ${sql(String(lesson))}, ${sql(COURSE)})`).join(',\n');
const migration = `-- Complete Medina Book 2 curriculum. Volume 1 is intentionally untouched.\n+begin;\n+delete from public.rules where course_name = ${sql(COURSE)};\n+insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary) values\n+${ruleValues};\n+-- Lessons 1-13 contain the owner's reviewed vocabulary and stay unchanged.\n+delete from public.words where course_name = ${sql(COURSE)} and lesson_number ~ '^[0-9]+$' and lesson_number::integer between 14 and 31;\n+insert into public.words (word_ar, word_ru, lesson_number, course_name) values\n+${wordValues};\n+commit;\n+`.replace(/^\+/gmu, '');
fs.mkdirSync(path.dirname(output),{recursive:true});
fs.writeFileSync(output,migration,'utf8');
console.log(JSON.stringify({output,lessons:expected.length,rules:rows.length,newWords:BOOK2_WORDS_14_31.length},null,2));
