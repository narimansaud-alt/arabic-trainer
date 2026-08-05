import fs from 'node:fs';
import path from 'node:path';
import { BOOK2_LESSON_PAGES, BOOK2_RULES, BOOK2_WORDS_14_31 } from '../data/medina-book2-content.mjs';

const COURSE = 'Мединский курс (Том 2)';
const LEGACY_MOJIBAKE_COURSE = 'РњРµРґРёРЅСЃРєРёР№ РєСѓСЂСЃ (РўРѕРј 2)';
const output = process.argv[2] || 'supabase/migrations/20260805235900_correct_book2_rule_course.sql';
const sql = (value) => `'${String(value ?? '').replaceAll("'", "''")}'`;
const esc = (value) => String(value ?? '').replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
const expected = Array.from({ length: 31 }, (_, index) => index + 1);
const lessons = Object.keys(BOOK2_RULES).map(Number).sort((a, b) => a - b);
if (JSON.stringify(lessons) !== JSON.stringify(expected)) throw new Error('Правила должны покрывать уроки 1–31 без пропусков.');
if (Object.keys(BOOK2_LESSON_PAGES).length !== 31) throw new Error('Карта страниц должна покрывать 31 урок.');

function guidanceFor(item) {
  const key = `${item.ar} ${item.ru}`.toLowerCase();
  if (/числ|عَدَد|عُقُود|مِئَ|أَلْف/u.test(key)) return {
    steps: ['Определите разряд и форму числительного.', 'Проверьте род и падеж числительного.', 'Поставьте считаемое слово в требуемое число и падеж.'],
    mistake: 'Не переносите одну схему согласования на все числа: правила 1–2, 3–10, 11–99, сотен и тысяч различаются.',
    extra: ['فِي الْفَصْلِ خَمْسَةَ عَشَرَ طَالِبًا.', 'В классе пятнадцать учеников.']
  };
  if (/вопрос|اِسْتِفْهَام|مَاذَا|مَنْ|أَيْنَ|كَيْفَ/u.test(key)) return {
    steps: ['Поставьте вопросительное слово в начало.', 'Сохраните обычное управление глагола или предлога.', 'Проверьте, отвечает ли фраза именно на заданный вопрос.'],
    mistake: 'Не смешивайте مَنْ для разумных лиц и مَا / مَاذَا для предметов, явлений и прочего неразумного.',
    extra: ['مَاذَا تَقْرَأُ؟ أَقْرَأُ كِتَابًا.', 'Что ты читаешь? Я читаю книгу.']
  };
  if (/отриц|запрет|نَفْي|نَهْي|لَمْ|لَنْ|لَا/u.test(key)) return {
    steps: ['Определите: это сообщение, отрицание прошлого, будущего или запрет.', 'Выберите нужную частицу.', 'Проверьте наклонение и конечную огласовку глагола.'],
    mistake: 'После لَمْ и запретительной لَا глагол ставится в джазм; после لَنْ — в насб.',
    extra: ['لَمْ يَحْضُرْ خَالِدٌ، وَلَنْ يَتَأَخَّرَ غَدًا.', 'Халид не пришёл, а завтра не опоздает.']
  };
  if (/глагол|прошед|настоящ|повел|наклон|جَزْم|نَصْب|فِعْل|مُضَارِع|مَاض|أَمْر/u.test(key)) return {
    steps: ['Найдите словарную форму и корень.', 'Определите время, лицо, число и род.', 'Добавьте показатель лица и окончание, затем проверьте конечную огласовку.'],
    mistake: 'Не определяйте лицо только по переводу: сначала найдите приставку и окончание арабской формы.',
    extra: ['كَتَبْنَا الدَّرْسَ، وَالآنَ نَقْرَؤُهُ.', 'Мы написали урок, а теперь читаем его.']
  };
  if (/местоимен|ضَمِير/u.test(key)) return {
    steps: ['Определите, кого или что заменяет местоимение.', 'Проверьте род и число.', 'Уточните позицию: отдельная форма или слитный суффикс.'],
    mistake: 'Слитное местоимение меняет функцию по контексту: оно может выражать принадлежность или дополнение.',
    extra: ['رَأَيْتُهَا وَسَأَلْتُهَا عَنِ الدَّرْسِ.', 'Я увидел её и спросил её об уроке.']
  };
  if (/идаф|إِضَاف/u.test(key)) return {
    steps: ['Найдите два связанных имени.', 'Уберите артикль и танвин у первого члена.', 'Поставьте второй член в родительный падеж.'],
    mistake: 'Первый член идафы не принимает ال и танвин одновременно с конструкцией принадлежности.',
    extra: ['بَابُ الْمَدْرَسَةِ مَفْتُوحٌ.', 'Дверь школы открыта.']
  };
  if (/прилаг|согласован|نَعْت|صِفَة/u.test(key)) return {
    steps: ['Найдите определяемое существительное.', 'Согласуйте прилагательное в роде, числе и определённости.', 'Проверьте падежные окончания обоих слов.'],
    mistake: 'Прилагательное не получает артикль само по себе, если определяемое существительное остаётся неопределённым.',
    extra: ['هَذِهِ سَيَّارَةٌ جَدِيدَةٌ، وَذَلِكَ بَيْتٌ كَبِيرٌ.', 'Это новая машина, а то большой дом.']
  };
  if (/падеж|именитель|винитель|родитель|إِعْرَاب|مَرْفُوع|مَنْصُوب|مَجْرُور/u.test(key)) return {
    steps: ['Определите синтаксическую роль слова.', 'Выберите требуемый падеж.', 'Проверьте окончание с учётом числа и типа имени.'],
    mistake: 'Окончание зависит не только от смысла, но и от позиции слова в предложении.',
    extra: ['جَاءَ الطَّالِبُ وَرَأَيْتُ الطَّالِبَ وَسَلَّمْتُ عَلَى الطَّالِبِ.', 'Ученик пришёл; я увидел ученика и поприветствовал ученика.']
  };
  return {
    steps: ['Найдите конструкцию из заголовка правила.', 'Определите роль каждого слова в предложении.', 'Сопоставьте форму с переводом и перечитайте пример целиком.'],
    mistake: 'Не разбирайте отдельное окончание вне контекста: сначала установите функцию всего слова и конструкции.',
    extra: null
  };
}

const rows = [];
for (const lesson of expected) {
  const rules = BOOK2_RULES[lesson];
  if (!Array.isArray(rules) || !rules.length) throw new Error(`В уроке ${lesson} нет правил.`);
  rules.forEach((item, index) => {
    if (!item.ar || !item.ru || !item.explanation || !item.examples?.length) throw new Error(`Неполное правило: урок ${lesson}, позиция ${index + 1}.`);
    const guidance = guidanceFor(item);
    const expandedExamples = [...item.examples];
    if (guidance.extra && !expandedExamples.some(([arabic]) => arabic === guidance.extra[0])) expandedExamples.push(guidance.extra);
    const examples = `<ul>${expandedExamples.map(([arabic, russian]) => `<li><b dir="rtl" lang="ar">${esc(arabic)}</b> — ${esc(russian)}</li>`).join('')}</ul>`;
    const steps = `<div class="rule-steps"><b>Как применять.</b><ol>${guidance.steps.map((step) => `<li>${esc(step)}</li>`).join('')}</ol></div>`;
    const [firstArabic, firstRussian] = item.examples[0];
    const analysis = `<div class="rule-example-analysis"><b>Разбор первого примера.</b> В выражении <b dir="rtl" lang="ar">${esc(firstArabic)}</b> найдите конструкцию «${esc(item.ar)}», определите её роль и только затем сопоставьте с переводом: «${esc(firstRussian)}».</div>`;
    const note = item.note ? `<div class="rule-note"><b>Самопроверка.</b> ${esc(item.note)}</div>` : '';
    const warning = `<div class="rule-note"><b>Частая ошибка.</b> ${esc(guidance.mistake)}</div>`;
    const content = `<b>Суть правила.</b> ${esc(item.explanation)}${steps}<br><b>Примеры.</b>${examples}${analysis}${warning}${note}`;
    rows.push([COURSE, String(lesson), `${item.ar} (${item.ru})`, content, index + 1, 'rule', item.explanation.slice(0, 240)]);
  });
}

const seen = new Set();
for (const [lesson, arabic, russian] of BOOK2_WORDS_14_31) {
  if (lesson < 14 || lesson > 31 || !arabic || !russian) throw new Error(`Некорректная строка словаря: ${JSON.stringify([lesson, arabic, russian])}`);
  const key = `${lesson}|${arabic}`;
  if (seen.has(key)) throw new Error(`Дубль слова: ${key}`);
  seen.add(key);
}
const values = [...rows.flat(), ...BOOK2_WORDS_14_31.flat()].join('|');
if (/\uFFFD/u.test(values) || /(?:Р .|РЎ.){4}/u.test(values)) throw new Error('Обнаружен повреждённый Unicode.');

const ruleValues = rows.map((row) => `(${row.map(sql).join(', ')})`).join(',\n');
const migration = `-- Keep Medina Book 2 rules under the same canonical course name as its vocabulary. Volume 1 and vocabulary are intentionally untouched.\nbegin;\ndelete from public.rules where course_name in (${sql(COURSE)}, ${sql(LEGACY_MOJIBAKE_COURSE)});\ninsert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary) values\n${ruleValues};\ncommit;\n`;
fs.mkdirSync(path.dirname(output), { recursive: true });
fs.writeFileSync(output, migration, 'utf8');
console.log(JSON.stringify({ output, lessons: expected.length, rules: rows.length, vocabularyChecked: BOOK2_WORDS_14_31.length }, null, 2));
