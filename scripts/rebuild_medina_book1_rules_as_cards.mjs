import fs from 'node:fs';
import path from 'node:path';

const COURSE = 'Мединский курс (Том 1)';
const LEGACY_COURSE = 'РњРµРґРёРЅСЃРєРёР№ РєСѓСЂСЃ (РўРѕРј 1)';
const SOURCE_SQL = 'supabase/migrations/20260804160000_replace_tom1_rules_archive.sql';
const OUTPUT_SQL = 'supabase/migrations/20260811214000_fix_book1_rule_card_meanings.sql';
const MANIFEST = 'tmp/book1-rules-card-manifest.json';

function htmlEscape(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function sql(value) {
  return `'${String(value ?? '').replace(/'/g, "''")}'`;
}

function stripHtml(value) {
  return String(value || '')
    .replace(/<br\s*\/?>/gi, ' ')
    .replace(/<[^>]+>/g, ' ')
    .replace(/&nbsp;/g, ' ')
    .replace(/&amp;/g, '&')
    .replace(/\s+/g, ' ')
    .trim();
}

function parseSqlRows(sqlText) {
  const valuesIndex = sqlText.indexOf('values');
  if (valuesIndex < 0) throw new Error('values block not found');
  const start = valuesIndex + 'values'.length;
  const end = sqlText.lastIndexOf(';');
  const data = sqlText.slice(start, end);
  const rows = [];
  let i = 0;
  const n = data.length;
  const skip = () => {
    while (i < n && /[\s,]/.test(data[i])) i += 1;
  };
  while (i < n) {
    skip();
    if (i >= n) break;
    if (data[i] !== '(') {
      i += 1;
      continue;
    }
    i += 1;
    const row = [];
    while (i < n) {
      skip();
      if (data[i] === "'") {
        i += 1;
        let value = '';
        while (i < n) {
          if (data[i] === "'") {
            if (data[i + 1] === "'") {
              value += "'";
              i += 2;
              continue;
            }
            i += 1;
            break;
          }
          value += data[i];
          i += 1;
        }
        row.push(value);
      } else {
        let value = '';
        while (i < n && data[i] !== ',' && data[i] !== ')') {
          value += data[i];
          i += 1;
        }
        row.push(value.trim());
      }
      skip();
      if (data[i] === ',') {
        i += 1;
        continue;
      }
      if (data[i] === ')') {
        i += 1;
        break;
      }
    }
    if (row.length) rows.push(row);
  }
  return rows.map((row) => ({
    courseName: row[0],
    lesson: Number(row[1]),
    title: row[2],
    content: row[3],
    sort: Number(row[4]),
    kind: row[5],
    summary: row[6] || '',
  }));
}

const ARABIC_FIXES = new Map([
  ['هذا', 'هَذَا'],
  ['هذه', 'هَذِهِ'],
  ['ذلك', 'ذَلِكَ'],
  ['تلك', 'تِلْكَ'],
  ['هؤلاء', 'هَؤُلَاءِ'],
  ['أولئك', 'أُولَئِكَ'],
  ['ما', 'مَا'],
  ['من', 'مَنْ'],
  ['أين', 'أَيْنَ'],
  ['كم', 'كَمْ'],
  ['نعم', 'نَعَمْ'],
  ['لا', 'لَا'],
  ['في', 'فِي'],
  ['على', 'عَلَى'],
  ['من ', 'مِنْ '],
  ['إلى', 'إِلَى'],
  ['لمن', 'لِمَنْ'],
  ['لي', 'لِي'],
  ['له', 'لَهُ'],
  ['لها', 'لَهَا'],
  ['عندي', 'عِنْدِي'],
  ['عنده', 'عِنْدَهُ'],
  ['عندها', 'عِنْدَهَا'],
  ['مبتدأ', 'مُبْتَدَأٌ'],
  ['خبر', 'خَبَرٌ'],
  ['فاعل', 'فَاعِلٌ'],
  ['مفعول به', 'مَفْعُولٌ بِهِ'],
  ['مضاف إليه', 'مُضَافٌ إِلَيْهِ'],
  ['مضاف', 'مُضَافٌ'],
  ['نعت', 'نَعْتٌ'],
  ['منعوت', 'مَنْعُوتٌ'],
  ['مجرور', 'مَجْرُورٌ'],
  ['مرفوع', 'مَرْفُوعٌ'],
  ['منصوب', 'مَنْصُوبٌ'],
  ['مجزوم', 'مَجْزُومٌ'],
  ['تمييز', 'تَمْيِيزٌ'],
  ['اسم إشارة', 'اِسْمُ إِشَارَةٍ'],
  ['اسم استفهام', 'اِسْمُ اسْتِفْهَامٍ'],
  ['حرف جر', 'حَرْفُ جَرٍّ'],
  ['حروف الجر', 'حُرُوفُ الْجَرِّ'],
  ['الجملة الاسمية', 'الْجُمْلَةُ الِاسْمِيَّةُ'],
  ['النعت والمنعوت', 'النَّعْتُ وَالْمَنْعُوتُ'],
  ['الممنوع من الصرف', 'الْمَمْنُوعُ مِنَ الصَّرْفِ'],
  ['المثنى', 'الْمُثَنَّى'],
]);

function vocalizeLooseArabic(value) {
  let output = String(value || '');
  [...ARABIC_FIXES.entries()]
    .sort((a, b) => b[0].length - a[0].length)
    .forEach(([plain, vocalized]) => {
      output = output.replace(new RegExp(plain.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'gu'), vocalized);
    });
  return output;
}

function normalizeArabic(value) {
  return String(value || '')
    .replace(/[\u064B-\u065F\u0670]/g, '')
    .replace(/[إأآا]/g, 'ا')
    .replace(/[ىي]/g, 'ي')
    .replace(/ة/g, 'ه')
    .replace(/\s+/g, ' ')
    .trim();
}

function termClass(value) {
  const key = normalizeArabic(value);
  if (/رفع|مرفوع/u.test(key)) return 'rule-term-raf';
  if (/نصب|منصوب|تمييز/u.test(key)) return 'rule-term-nasb';
  if (/جر|مجرور|مضاف اليه/u.test(key)) return 'rule-term-jarr';
  if (/جزم|مجزوم/u.test(key)) return 'rule-term-jazm';
  if (/نعت|منعوت|مضاف|مثني|ممنوع|صرف|عدد|معدود|معرفه|نكره|بدل|معطوف|جمله اسميه/u.test(key)) return 'rule-term-structure';
  if (/مبتدا|اسم اشاره|اسم استفهام|ضمير|انا|انت|هو|هي|هم|هن|نحن/u.test(key)) return 'rule-term-subject';
  if (/خبر/u.test(key)) return 'rule-term-predicate';
  if (/فاعل|مفعول/u.test(key)) return 'rule-term-role';
  if (/فعل|ذهب|رجع|احب|قال/u.test(key)) return 'rule-term-verb';
  if (/حرف|حروف|(?:^| )(?:ما|من|اين|كم|نعم|لا|في|علي|الي|لمن|و)(?: |$)|لـ/u.test(key)) return 'rule-term-particle';
  return 'rule-term-default';
}

function splitTitle(title) {
  const raw = vocalizeLooseArabic(String(title || '').trim());
  const match = raw.match(/^(.+?)\s*\((.+)\)$/u);
  if (!match) return { ar: raw, ru: '' };
  return { ar: match[1].trim(), ru: match[2].trim() };
}

function sentenceSplit(text) {
  const plain = stripHtml(text)
    .replace(/([.!?؟])\s+/g, '$1|')
    .split('|')
    .map((item) => item.trim())
    .filter(Boolean);
  return plain;
}

function collectExamples(content) {
  const examples = [];
  const listItems = [...String(content || '').matchAll(/<li>([\s\S]*?)<\/li>/gi)].map((m) => stripHtml(m[1]));
  for (const item of listItems) {
    const parts = item.split(/\s+—\s+/u);
    if (parts.length >= 2 && /[\u0600-\u06FF]/u.test(parts[0])) {
      examples.push([vocalizeLooseArabic(parts[0].trim()), parts.slice(1).join(' — ').trim()]);
    }
  }
  if (!examples.length) {
    const plain = sentenceSplit(content);
    for (const line of plain) {
      const parts = line.split(/\s+—\s+/u);
      if (parts.length >= 2 && /[\u0600-\u06FF]/u.test(parts[0])) {
        examples.push([vocalizeLooseArabic(parts[0].trim()), parts.slice(1).join(' — ').trim()]);
      }
    }
  }
  return examples.slice(0, 10);
}

function extractTerms(title, content) {
  const found = new Map();
  const defaultMeanings = {
    'هَذَا': 'это / этот: указательное имя для близкого мужского рода',
    'هَذِهِ': 'эта: указательное имя для близкого женского рода',
    'ذَلِكَ': 'то / тот: указательное имя для далёкого мужского рода',
    'تِلْكَ': 'та: указательное имя для далёкого женского рода',
    'هَؤُلَاءِ': 'эти: указательное имя для множественного разумных',
    'أُولَئِكَ': 'те: указательное имя для множественного далёких разумных',
    'مَا': 'что?: вопросительное имя для неразумного',
    'مَنْ': 'кто?: вопросительное имя для разумного',
    'أَيْنَ': 'где?: вопросительное имя места',
    'كَمْ': 'сколько?: вопросительное имя числа',
    'نَعَمْ': 'да: утвердительный ответ',
    'لَا': 'нет: отрицательный ответ',
    'أَ': 'вопросительная хамза: частица общего вопроса',
    'أَلْـ': 'определённый артикль',
    'وَ': 'и / а: союз عَطْف',
    'حَرْفُ جَرٍّ': 'предлог, после которого имя становится مَجْرُورٌ',
    'حُرُوفُ الْجَرِّ': 'предлоги родительного падежа',
    'حَرْفُ عَطْفٍ': 'союзная частица, соединяющая слова или предложения',
    'حَرْفٌ': 'частица / служебное слово',
    'اِسْمٌ': 'имя: существительное, прилагательное, местоимение или другое именное слово',
    'مُضَافٌ': 'первый член идафы',
    'مُضَافٌ إِلَيْهِ': 'второй член идафы, всегда مَجْرُورٌ',
    'نَعْتٌ': 'прилагательное / определение',
    'مَنْعُوتٌ': 'определяемое слово',
    'الْمَعْرِفَةُ': 'определённое / известное имя',
    'النَّكِرَةُ': 'неопределённое имя',
    'الْبَدَلُ': 'замена / поясняющее слово после другого имени',
    'الْمَعْطُوفُ': 'слово, присоединённое через союз',
    'الْجُمْلَةُ الِاسْمِيَّةُ': 'именное предложение',
    'جُمْلَةٌ اِسْمِيَّةٌ': 'именное предложение',
    'الْأَسْمَاءُ الْخَمْسَةُ': 'пять особых имён: أَبٌ، أَخٌ، حَمٌ، فُو، ذُو',
    'مُبْتَدَأٌ': 'подлежащее именного предложения',
    'الْمُبْتَدَأُ': 'подлежащее именного предложения; первый главный член الجُمْلَةُ الِاسْمِيَّةُ',
    'خَبَرٌ': 'сказуемое / сообщение о مُبْتَدَأٌ',
    'الْخَبَرُ': 'сказуемое / сообщение о الْمُبْتَدَأُ',
    'فَاعِلٌ': 'действующее лицо, подлежащее при глаголе',
    'مَفْعُولٌ بِهِ': 'прямое дополнение',
    'مَرْفُوعٌ': 'в именительном падеже / в состоянии رفع',
    'مَنْصُوبٌ': 'в винительном падеже / в состоянии نصب',
    'مَجْرُورٌ': 'в родительном падеже / в состоянии جرّ',
    'الْمُثَنَّى': 'двойственное число',
    'تَمْيِيزٌ': 'поясняющее слово после كَمْ и чисел',
    'الْعَدَدُ': 'числительное',
    'الْمَعْدُودُ': 'считаемое слово',
    'الْمَمْنُوعُ مِنَ الصَّرْفِ': 'диптот: слово без танвина, с особым جَرّ',
    'مَمْنُوعٌ مِنَ الصَّرْفِ': 'диптот: слово без танвина, с особым جَرّ',
    'مَمْنُوعًا مِنَ الصَّرْفِ': 'диптот в винительном выражении: слово, запрещённое от танвина',
    'مَفَاعِلُ': 'модель ломаного множественного числа, относящаяся к диптотам',
    'إِبْرَاهِيمُ، إِسْمَاعِيلُ، إِسْحَاقُ، بَغْدَادُ': 'примеры диптотов: имена и название города без танвина',
    'إِبْرَاهِيمُ، إِسْمَاعِيلُ، إِسْحَاقُ، لَنْدَنُ': 'примеры иноязычных имён/названий, которые не принимают танвин',
    'ضَمِيرٌ': 'местоимение',
    'ضَمَائِرُ مُنْفَصِلَةٌ': 'самостоятельные местоимения',
    'ضَمَائِرُ مُتَّصِلَةٌ': 'присоединённые местоимения',
  };
  const put = (ar, ru = '', options = {}) => {
    const cleanAr = vocalizeLooseArabic(String(ar || '').replace(/[.:؛،]+$/u, '').trim());
    if (!cleanAr || cleanAr.length > 60 || !/[\u0600-\u06FF]/u.test(cleanAr)) return;
    const words = cleanAr.trim().split(/\s+/u).length;
    const looksLikeSentence = /[.؟?!]/u.test(cleanAr) || words > 4;
    if (!options.title && looksLikeSentence) return;
    const fallback = Object.entries(defaultMeanings).find(([term]) => normalizeArabic(term) === normalizeArabic(cleanAr))?.[1] || '';
    if (!found.has(cleanAr)) found.set(cleanAr, ru || fallback);
  };
  const { ar, ru } = splitTitle(title);
  put(ar, ru, { title: true });
  for (const bold of String(content || '').matchAll(/<b>([\s\S]*?)<\/b>/gi)) {
    const text = stripHtml(bold[1]);
    const key = normalizeArabic(text);
    if (/[\u0600-\u06FF]/u.test(text) && (/مبتدا|خبر|فاعل|مفعول|مضاف|نعت|منعوت|جر|رفع|نصب|جزم|تمييز|ضمير|مثني|عدد|معدود|ممنوع|صرف|حرف|اسم/u.test(key))) {
      put(text);
    }
  }
  const plain = stripHtml(content);
  for (const m of plain.matchAll(/([\u0600-\u06FF][\u0600-\u06FF\sًٌٍَُِّْٰـ]+?)(?:\s+—\s+|:)\s*([^.;،]{2,90})/gu)) {
    put(m[1], m[2].trim());
  }
  Object.entries(defaultMeanings).forEach(([arTerm, meaning]) => {
    if (normalizeArabic(`${title} ${content}`).includes(normalizeArabic(arTerm))) put(arTerm, meaning);
  });
  return [...found.entries()].slice(0, 12);
}

function guidanceFor(row) {
  const titleKey = normalizeArabic(row.title);
  const key = normalizeArabic(`${row.title} ${row.content}`);
  if (/نعت|منعوت|صفه/u.test(titleKey)) return {
    steps: ['Найдите مَنْعُوتٌ - определяемое слово.', 'После него поставьте نَعْتٌ.', 'Согласуйте نَعْتٌ с مَنْعُوتٌ в роде, числе, падеже и определённости.'],
    mistake: 'Если существительное определённое, прилагательное тоже должно быть определённым; если оно после предлога, прилагательное тоже в جَرّ.',
  };
  if (/مضاف|اضافه/u.test(titleKey)) return {
    steps: ['Найдите два имени, связанные смыслом принадлежности.', 'Первое имя - مُضَافٌ: без танвина и без أَلْـ.', 'Второе имя - مُضَافٌ إِلَيْهِ: всегда в جَرّ.'],
    mistake: 'Главная ошибка: дать первому члену идафы танвин или артикль одновременно с идафой.',
  };
  if (/مثني|هذان|هاتان/u.test(titleKey)) return {
    steps: ['Проверьте, что речь ровно о двух предметах или лицах.', 'В رَفْع обычно используется окончание ـَانِ.', 'В نَصْب и جَرّ используется ـَيْنِ.'],
    mistake: 'Нельзя переводить двойственное как обычное множественное: оно означает именно «два / две».',
  };
  if (/عدد|معدود|كم|تمييز/u.test(titleKey)) return {
    steps: ['Определите число.', 'Проверьте род единственного числа الْمَعْدُودُ.', 'После كَمْ ставьте تَمْيِيزٌ в نَصْب, а после 3-10 - множественное в جَرّ.'],
    mistake: 'Для чисел 3-10 род числительного противоположен роду единственного числа считаемого слова.',
  };
  if (/ممنوع من الصرف|صرف/u.test(titleKey)) return {
    steps: ['Проверьте, относится ли слово к группе الْمَمْنُوعُ مِنَ الصَّرْفِ.', 'Не ставьте танвин.', 'В جَرّ без أَلْـ и без идафы ставьте фатху вместо касры.'],
    mistake: 'Диптот не «полностью неизменяемый»: он меняет падеж, но без танвина и с особым родительным падежом.',
  };
  if (/مبتدا|خبر|الجمله الاسميه/u.test(titleKey)) return {
    steps: ['Найдите مُبْتَدَأٌ: о ком или о чём говорится.', 'Найдите خَبَرٌ: что сообщается.', 'Оба главных члена обычно مَرْفُوعٌ.'],
    mistake: 'Не называйте любое первое слово مُبْتَدَأٌ автоматически: сначала проверьте, даёт ли второе слово законченное сообщение.',
  };
  if (/اسم اشاره|هذا|هذه|ذلك|تلك|هؤلاء|اولئك/u.test(key)) return {
    steps: ['Определите близость: близко или далеко.', 'Определите род и число того, на что указывают.', 'Проверьте: после указательного слова часто идёт имя, раскрывающее, на что указывают.'],
    mistake: 'Не смешивайте формы: هَذَا для близкого мужского, هَذِهِ для близкого женского, ذَلِكَ/تِلْكَ для далёкого.',
  };
  if (/حروف الجر|حرف جر|مجرور|في|علي|الي|من/u.test(key)) return {
    steps: ['Найдите предлог حَرْفُ جَرٍّ.', 'Слово после него поставьте как مَجْرُورٌ.', 'Переведите связь места, направления, источника или принадлежности по контексту.'],
    mistake: 'После предлога нельзя оставлять имя как مَرْفُوعٌ: нужен جَرّ, обычно касра или танвин касры.',
  };
  if (/مضاف|اضافه/u.test(key)) return {
    steps: ['Найдите два имени, связанные смыслом принадлежности.', 'Первое имя - مُضَافٌ: без танвина и без أَلْـ.', 'Второе имя - مُضَافٌ إِلَيْهِ: всегда в جَرّ.'],
    mistake: 'Главная ошибка: дать первому члену идафы танвин или артикль одновременно с идафой.',
  };
  if (/نعت|منعوت|صفه/u.test(key)) return {
    steps: ['Найдите مَنْعُوتٌ - определяемое слово.', 'После него поставьте نَعْتٌ.', 'Согласуйте نَعْتٌ с مَنْعُوتٌ в роде, числе, падеже и определённости.'],
    mistake: 'Если существительное определённое, прилагательное тоже должно быть определённым; если оно после предлога, прилагательное тоже в جَرّ.',
  };
  if (/ضمير|انا|انت|هو|هي|هم|هن|نحن|ياء المتكلم|كاف/u.test(key)) return {
    steps: ['Определите лицо: говорящий, собеседник или отсутствующий.', 'Определите число и род.', 'Проверьте: местоимение самостоятельное или присоединённое к слову.'],
    mistake: 'Не смешивайте самостоятельные ضَمَائِرُ مُنْفَصِلَةٌ с присоединёнными ضَمَائِرُ مُتَّصِلَةٌ.',
  };
  if (/مبتدا|خبر|الجمله الاسميه/u.test(key)) return {
    steps: ['Найдите مُبْتَدَأٌ: о ком или о чём говорится.', 'Найдите خَبَرٌ: что сообщается.', 'Оба главных члена обычно مَرْفُوعٌ.'],
    mistake: 'Не называйте любое первое слово مُبْتَدَأٌ автоматически: сначала проверьте, даёт ли второе слово законченное сообщение.',
  };
  if (/مثني|هذان|هاتان|ـان|ـين/u.test(key)) return {
    steps: ['Проверьте, что речь ровно о двух предметах или лицах.', 'В رَفْع обычно используется окончание ـَانِ.', 'В نَصْب и جَرّ используется ـَيْنِ.'],
    mistake: 'Нельзя переводить двойственное как обычное множественное: оно означает именно «два / две».',
  };
  if (/عدد|معدود|كم|تمييز/u.test(key)) return {
    steps: ['Определите число.', 'Проверьте род единственного числа الْمَعْدُودُ.', 'После كَمْ ставьте تَمْيِيزٌ в نَصْب, а после 3-10 - множественное в جَرّ.'],
    mistake: 'Для чисел 3-10 род числительного противоположен роду единственного числа считаемого слова.',
  };
  if (/ممنوع من الصرف|ينون|الفتحه/u.test(key)) return {
    steps: ['Проверьте, относится ли слово к группе الْمَمْنُوعُ مِنَ الصَّرْفِ.', 'Не ставьте танвин.', 'В جَرّ без أَلْـ и без идафы ставьте фатху вместо касры.'],
    mistake: 'Диптот не «полностью неизменяемый»: он меняет падеж, но без танвина и с особым родительным падежом.',
  };
  return {
    steps: ['Прочитайте арабский заголовок отдельно.', 'Сравните русский смысл с примером.', 'Проверьте роль слов и их окончание.'],
    mistake: 'Не переводите правило отдельно от арабского примера: форма слова видна именно в предложении.',
  };
}

function cardsForMeanings(terms) {
  if (!terms.length) return '';
  return `<div class="rule-meaning-grid">${terms.map(([ar, ru]) =>
    `<div class="rule-meaning-card ${termClass(ar)}"><span class="rule-term-ar" dir="rtl" lang="ar">${htmlEscape(ar)}</span><span class="rule-term-ru">${htmlEscape(vocalizeLooseArabic(ru || 'см. подробное объяснение и примеры ниже'))}</span></div>`
  ).join('')}</div>`;
}

function cardsForExamples(row, examples) {
  if (!examples.length) return '';
  return `<div class="rule-example-list">${examples.map(([ar, ru]) =>
    `<div class="rule-example-card ${termClass(`${row.title} ${ar}`)}"><span class="rule-example-ar" dir="rtl" lang="ar">${htmlEscape(ar)}</span><span class="rule-example-ru">${htmlEscape(ru)}</span></div>`
  ).join('')}</div>`;
}

function cleanContent(content) {
  return String(content || '')
    .replace(/## Обязательные требования к импорту этой базы[\s\S]*$/u, '')
    .replace(/<div class="rule-note"><b>Внутренняя структура:<\/b>[^<]*<\/div><br><br>/gu, '')
    .trim();
}

function addSharhAdditions(baseRows) {
  const rows = baseRows.map((row) => (
    row.lesson === 6 && row.sort >= 4
      ? { ...row, sort: row.sort + 1 }
      : row
  ));
  rows.push({
    courseName: COURSE,
    lesson: 6,
    title: 'الْجُمْلَةُ الِاسْمِيَّةُ: الْمُبْتَدَأُ وَالْخَبَرُ (именное предложение: мубтада и хабар)',
    content: [
      '<p><b>الْجُمْلَةُ الِاسْمِيَّةُ</b> — именное предложение. В шархе первого тома это правило появляется в шестом уроке: предложение начинается с имени и состоит из двух главных частей.</p>',
      '<ul>',
      '<li><b>الْمُبْتَدَأُ</b> — первый член именного предложения; то, о чём говорится. В основе он مَرْفُوعٌ.</li>',
      '<li><b>الْخَبَرُ</b> — второй член именного предложения; сообщение о مُبْتَدَأٌ. В основе он тоже مَرْفُوعٌ.</li>',
      '<li>هَذَا طَالِبٌ — Это студент.</li>',
      '<li>هَذِهِ طَالِبَةٌ — Это студентка.</li>',
      '<li>أَحْمَدُ مُدَرِّسٌ — Ахмад — преподаватель.</li>',
      '<li>آمِنَةُ طَبِيبَةٌ — Амина — врач.</li>',
      '</ul>',
      '<p><b>إِعْرَابٌ مُبَسَّطٌ:</b> в примере <b>هَذَا طَالِبٌ</b> слово <b>هَذَا</b> стоит в позиции مُبْتَدَأٌ, а <b>طَالِبٌ</b> является خَبَرٌ; признак رفع у <b>طَالِبٌ</b> — дамма/танвин даммы в конце.</p>',
    ].join(''),
    sort: 4,
    kind: 'rule',
  });
  rows.push({
    courseName: COURSE,
    lesson: 1,
    title: 'الْمَعْرِفَةُ وَالنَّكِرَةُ (определённое и неопределённое имя)',
    content: [
      '<p><b>الْمَعْرِفَةُ</b> — определённое, известное имя. <b>النَّكِرَةُ</b> — неопределённое имя. Это правило помогает понять, почему в начале курса одно слово получает танвин, а другое — артикль <b>أَلْـ</b>.</p>',
      '<ul>',
      '<li>كِتَابٌ — книга / какая-то книга.</li>',
      '<li>الْكِتَابُ — эта известная книга / книга с артиклем.</li>',
      '<li>هَذَا كِتَابٌ — Это книга.</li>',
      '<li>هَذَا الْكِتَابُ — Эта книга.</li>',
      '</ul>',
      '<p>К определённым словам относятся, например: имена собственные, местоимения, указательные слова, слова с <b>أَلْـ</b> и слово в идафе, если оно определяется вторым членом.</p>',
    ].join(''),
    sort: 5,
    kind: 'rule',
  });
  rows.push({
    courseName: COURSE,
    lesson: 4,
    title: 'أَقْسَامُ الْكَلِمَةِ: اِسْمٌ، فِعْلٌ، حَرْفٌ (три вида слова)',
    content: [
      '<p>В объяснениях учителя отдельно выделено деление арабских слов на три основы: <b>اِسْمٌ</b>, <b>فِعْلٌ</b>, <b>حَرْفٌ</b>.</p>',
      '<ul>',
      '<li><b>اِسْمٌ</b> — имя: существительное, прилагательное, местоимение, указательное или вопросительное имя.</li>',
      '<li><b>فِعْلٌ</b> — глагол: слово действия, связанное со временем.</li>',
      '<li><b>حَرْفٌ</b> — частица/служебное слово: его смысл раскрывается вместе с другим словом.</li>',
      '<li>ذَهَبَ مُحَمَّدٌ إِلَى الْمَدْرَسَةِ — Мухаммад пошёл в школу.</li>',
      '</ul>',
    ].join(''),
    sort: 7,
    kind: 'rule',
  });
  rows.push({
    courseName: COURSE,
    lesson: 8,
    title: 'الْبَدَلُ بَعْدَ اسْمِ الْإِشَارَةِ (بدل после указательного слова)',
    content: [
      '<p><b>الْبَدَلُ</b> — слово, которое поясняет предыдущее слово и следует за ним в падеже. После указательного слова имя с <b>أَلْـ</b> часто разбирается как بدل.</p>',
      '<ul>',
      '<li>هَذَا الرَّجُلُ تَاجِرٌ — Этот мужчина — торговец.</li>',
      '<li>ذَلِكَ الْبَيْتُ قَدِيمٌ — Тот дом старый.</li>',
      '<li>هَذَا: اِسْمُ إِشَارَةٍ — указательное имя.</li>',
      '<li>الرَّجُلُ: بَدَلٌ — بدل, поясняющий هَذَا.</li>',
      '</ul>',
    ].join(''),
    sort: 4,
    kind: 'rule',
  });
  rows.push({
    courseName: COURSE,
    lesson: 11,
    title: 'الْمَعْطُوفُ بِالْوَاوِ (слово, присоединённое союзом وَ)',
    content: [
      '<p><b>الْمَعْطُوفُ</b> — слово, присоединённое к предыдущему слову через союз <b>وَ</b>. Оно следует за тем словом в падеже.</p>',
      '<ul>',
      '<li>الْمُدَرِّسُ وَالْمُدِيرُ فِي الْفَصْلِ — Учитель и директор в классе.</li>',
      '<li>ذَهَبَ مُحَمَّدٌ إِلَى عَبَّاسٍ وَخَالِدٍ — Мухаммад пошёл к Аббасу и Халиду.</li>',
      '<li>خَالِدٍ: مَعْطُوفٌ عَلَى عَبَّاسٍ — Халид присоединён к Аббасу и поэтому тоже в جَرّ.</li>',
      '</ul>',
    ].join(''),
    sort: 4,
    kind: 'rule',
  });
  rows.push({
    courseName: COURSE,
    lesson: 12,
    title: 'الْتِقَاءُ السَّاكِنَيْنِ (встреча двух сукунов)',
    content: [
      '<p>Если при чтении встречаются две буквы с сукуном подряд, арабская речь обычно устраняет трудность произношения: первая из двух неподвижных букв получает вспомогательную гласную.</p>',
      '<ul>',
      '<li>ذَهَبَتْ + الْمُدَرِّسَةُ → ذَهَبَتِ الْمُدَرِّسَةُ — Учительница ушла.</li>',
      '<li>مِنْ + الْبَيْتِ → مِنَ الْبَيْتِ — из дома.</li>',
      '</ul>',
      '<p>Важное исключение из объяснения учителя: предлог <b>مِنْ</b> перед <b>أَلْـ</b> получает фатху: <b>مِنَ الْـ</b>.</p>',
    ].join(''),
    sort: 5,
    kind: 'rule',
  });
  rows.push({
    courseName: COURSE,
    lesson: 17,
    title: 'مُطَابَقَةُ الْخَبَرِ لِلْمُبْتَدَأِ (согласование хабар с мубтада)',
    content: [
      '<p><b>الْخَبَرُ</b> согласуется с <b>الْمُبْتَدَأُ</b> по смыслу, роду и числу, если хабар выражен описательным именем.</p>',
      '<ul>',
      '<li>الطَّالِبُ طَوِيلٌ — Студент высокий.</li>',
      '<li>الطَّالِبَةُ مُجْتَهِدَةٌ — Студентка усердная.</li>',
      '<li>الطُّلَّابُ طِوَالٌ — Студенты высокие.</li>',
      '<li>الأَقْلَامُ جَمِيلَةٌ — Ручки красивые.</li>',
      '</ul>',
      '<p>Для множественного числа неразумных предметов хабар часто приходит как женский род единственного числа: <b>الأَقْلَامُ جَمِيلَةٌ</b>.</p>',
    ].join(''),
    sort: 3,
    kind: 'rule',
  });
  return rows.sort((a, b) => a.lesson - b.lesson || a.sort - b.sort || a.title.localeCompare(b.title));
}

function buildCardContent(row) {
  const sourceContent = vocalizeLooseArabic(cleanContent(row.content));
  const title = splitTitle(row.title);
  const plainSentences = sentenceSplit(sourceContent)
    .filter((line) => !/^\s*[-*]?\s*$/.test(line))
    .slice(0, 4);
  const explanation = plainSentences.join(' ');
  const terms = extractTerms(row.title, sourceContent);
  const examples = collectExamples(sourceContent);
  const guidance = guidanceFor(row);
  const titleCard =
    `<div class="rule-study-card"><span class="rule-card-kicker">Название и смысл</span><span class="rule-main-ar" dir="rtl" lang="ar">${htmlEscape(title.ar)}</span><p class="rule-study-text">${htmlEscape(title.ru ? `${title.ru}. ` : '')}${htmlEscape(explanation)}</p></div>`;
  const meaningCard =
    `<div class="rule-study-card"><span class="rule-card-kicker">Арабские слова → русский смысл</span>${cardsForMeanings(terms)}</div>`;
  const stepsCard =
    `<div class="rule-study-card"><span class="rule-card-kicker">Как применять</span><ol>${guidance.steps.map((step) => `<li>${htmlEscape(vocalizeLooseArabic(step))}</li>`).join('')}</ol></div>`;
  const examplesCard = examples.length
    ? `<div class="rule-study-card"><span class="rule-card-kicker">Примеры</span>${cardsForExamples(row, examples)}</div>`
    : '';
  const fullCard =
    `<div class="rule-study-card rule-study-source"><span class="rule-card-kicker">Подробное объяснение</span><div class="rule-study-text">${sourceContent}</div></div>`;
  const checkCard = `<div class="rule-check-card"><b>Частая ошибка.</b> ${htmlEscape(vocalizeLooseArabic(guidance.mistake))}</div>`;
  return `<div class="rule-study">${titleCard}${meaningCard}${stepsCard}${examplesCard}${fullCard}${checkCard}</div>`;
}

const source = fs.readFileSync(SOURCE_SQL, 'utf8');
const rows = parseSqlRows(source).filter((row) => row.courseName === COURSE);
if (rows.length !== 76) throw new Error(`Expected 76 book 1 rules, got ${rows.length}`);
const lessons = [...new Set(rows.map((row) => row.lesson))].sort((a, b) => a - b);
const expectedLessons = Array.from({ length: 23 }, (_, index) => index + 1);
if (JSON.stringify(lessons) !== JSON.stringify(expectedLessons)) {
  throw new Error(`Expected lessons 1-23, got ${lessons.join(', ')}`);
}

const enrichedRows = addSharhAdditions(rows);

const rebuilt = enrichedRows.map((row) => ({
  ...row,
  title: `${splitTitle(row.title).ar}${splitTitle(row.title).ru ? ` (${splitTitle(row.title).ru})` : ''}`,
  content: buildCardContent(row),
  summary: stripHtml(buildCardContent(row)).slice(0, 240),
}));

const values = rebuilt.map((row) =>
  `(${sql(COURSE)}, ${sql(String(row.lesson))}, ${sql(row.title)}, ${sql(row.content)}, ${row.sort}, ${sql(row.kind)}, ${sql(row.summary)})`
).join(',\n');

const migration = `-- Rebuild Medina Book 1 rules as readable cards aligned with the Book 1 sharh.
-- Scope: only ${COURSE} rules. Vocabulary, books, and other volumes are untouched.
begin;

delete from public.rule_sections where rule_id in (select id from public.rules where course_name in (${sql(COURSE)}, ${sql(LEGACY_COURSE)}));
delete from public.rules where course_name in (${sql(COURSE)}, ${sql(LEGACY_COURSE)});

insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary) values
${values};

commit;
`;

fs.mkdirSync(path.dirname(OUTPUT_SQL), { recursive: true });
fs.writeFileSync(OUTPUT_SQL, migration, 'utf8');
fs.mkdirSync(path.dirname(MANIFEST), { recursive: true });
fs.writeFileSync(MANIFEST, JSON.stringify({
  source: SOURCE_SQL,
  output: OUTPUT_SQL,
  lessons: lessons.length,
  rules: rebuilt.length,
  rulesPerLesson: Object.fromEntries(expectedLessons.map((lesson) => [lesson, rebuilt.filter((row) => row.lesson === lesson).length])),
}, null, 2), 'utf8');
console.log(JSON.stringify({ output: OUTPUT_SQL, lessons: lessons.length, rules: rebuilt.length }, null, 2));
