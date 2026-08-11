import fs from 'node:fs';
import path from 'node:path';
import { BOOK2_RULES } from '../data/medina-book2-content.mjs';

const COURSE = 'Мединский курс (Том 2)';
const LEGACY_MOJIBAKE_COURSE = 'РњРµРґРёРЅСЃРєРёР№ РєСѓСЂСЃ (РўРѕРј 2)';
const output = process.argv[2] || 'supabase/migrations/20260811193000_rebuild_book2_rules_from_sharh.sql';

const ARABIC_RE = /[\u0600-\u06FF]/u;
const DIACRITIC_RE = /[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]/gu;
const WORD_RE = /[\u0621-\u064A\u0671-\u06D3]+(?:[\u064B-\u065F\u0670]*)?/gu;

const sql = (value) => `'${String(value ?? '').replaceAll("'", "''")}'`;
const esc = (value) =>
  String(value ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
const strip = (value) => String(value || '').normalize('NFC').replace(DIACRITIC_RE, '');
const squash = (value) => strip(value).replace(/[^\u0621-\u064A\u0671-\u06D3]+/gu, '');

const MANUAL_VOWELS = new Map(Object.entries({
  'إن وأخواتها': 'إِنَّ وَأَخَوَاتُهَا',
  'أخوات إن': 'أَخَوَاتُ إِنَّ',
  'إن': 'إِنَّ',
  'أن': 'أَنَّ',
  'لكن': 'لَكِنَّ',
  'كأن': 'كَأَنَّ',
  'لعل': 'لَعَلَّ',
  'ليت': 'لَيْتَ',
  'اسم إن': 'اِسْمُ إِنَّ',
  'خبر إن': 'خَبَرُ إِنَّ',
  'اسم أن': 'اِسْمُ أَنَّ',
  'خبر أن': 'خَبَرُ أَنَّ',
  'اسم كأن': 'اِسْمُ كَأَنَّ',
  'خبر كأن': 'خَبَرُ كَأَنَّ',
  'اسم لعل': 'اِسْمُ لَعَلَّ',
  'خبر لعل': 'خَبَرُ لَعَلَّ',
  'اسم ليت': 'اِسْمُ لَيْتَ',
  'خبر ليت': 'خَبَرُ لَيْتَ',
  'اسم لكن': 'اِسْمُ لَكِنَّ',
  'خبر لكن': 'خَبَرُ لَكِنَّ',
  'حرف توكيد ونصب': 'حَرْفُ تَوْكِيدٍ وَنَصْبٍ',
  'حرف تشبيه وظن': 'حَرْفُ تَشْبِيهٍ وَظَنٍّ',
  'حرف ترج ونصب': 'حَرْفُ تَرَجٍّ وَنَصْبٍ',
  'حرف إشفاق ونصب': 'حَرْفُ إِشْفَاقٍ وَنَصْبٍ',
  'حرف تمن ونصب': 'حَرْفُ تَمَنٍّ وَنَصْبٍ',
  'لا محل له من الإعراب': 'لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ',
  'الجملة الاسمية': 'الْجُمْلَةُ الِاسْمِيَّةُ',
  'الجملة الفعلية': 'الْجُمْلَةُ الْفِعْلِيَّةُ',
  'اسم': 'اِسْمٌ',
  'الإعراب': 'الْإِعْرَابُ',
  'إعراب': 'إِعْرَابٌ',
  'مبتدأ': 'مُبْتَدَأٌ',
  'خبر': 'خَبَرٌ',
  'فاعل': 'فَاعِلٌ',
  'مفعول به': 'مَفْعُولٌ بِهِ',
  'نعت': 'نَعْتٌ',
  'منعوت': 'مَنْعُوتٌ',
  'مضاف': 'مُضَافٌ',
  'مضاف إليه': 'مُضَافٌ إِلَيْهِ',
  'ضمير متصل': 'ضَمِيرٌ مُتَّصِلٌ',
  'ضمير مستتر': 'ضَمِيرٌ مُسْتَتِرٌ',
  'مرفوع': 'مَرْفُوعٌ',
  'منصوب': 'مَنْصُوبٌ',
  'مجرور': 'مَجْرُورٌ',
  'رفع': 'رَفْعٌ',
  'نصب': 'نَصْبٌ',
  'جر': 'جَرٌّ',
  'جزم': 'جَزْمٌ',
  'حرف جر': 'حَرْفُ جَرٍّ',
  'لام التعليل': 'لَامُ التَّعْلِيلِ',
  'لا الناهية': 'لَا النَّاهِيَةُ',
  'لا النافية': 'لَا النَّافِيَةُ',
  'ما النافية': 'مَا النَّافِيَةُ',
  'الفعل الماضي': 'الْفِعْلُ الْمَاضِي',
  'الفعل المضارع': 'الْفِعْلُ الْمُضَارِعُ',
  'المضارع': 'الْمُضَارِعُ',
  'فعل الأمر': 'فِعْلُ الْأَمْرِ',
  'الأفعال الخمسة': 'الْأَفْعَالُ الْخَمْسَةُ',
  'الأسماء الخمسة': 'الْأَسْمَاءُ الْخَمْسَةُ',
  'اسم التفضيل': 'اِسْمُ التَّفْضِيلِ',
  'الاسم المنقوص': 'الِاسْمُ الْمَنْقُوصُ',
  'جمع المؤنث السالم': 'جَمْعُ الْمُؤَنَّثِ السَّالِمُ',
  'جمع المذكر السالم': 'جَمْعُ الْمُذَكَّرِ السَّالِمُ',
  'المثنى': 'الْمُثَنَّى',
  'العدد': 'الْعَدَدُ',
  'المعدود': 'الْمَعْدُودُ',
  'تمييز العدد': 'تَمْيِيزُ الْعَدَدِ',
  'العقود': 'الْعُقُودُ',
  'المثال الواوي': 'الْمِثَالُ الْوَاوِيُّ',
  'المثال اليائي': 'الْمِثَالُ الْيَائِيُّ',
  'الأجوف': 'الْأَجْوَفُ',
  'الناقص': 'النَّاقِصُ',
  'المضاعف': 'الْمُضَعَّفُ',
  'الواو': 'الْوَاوُ',
  'الألف': 'الْأَلِفُ',
  'الياء': 'الْيَاءُ',
  'النون': 'النُّونُ',
  'الفتحة': 'الْفَتْحَةُ',
  'الضمة': 'الضَّمَّةُ',
  'الكسرة': 'الْكَسْرَةُ',
  'السكون': 'السُّكُونُ',
  'الشدة': 'الشَّدَّةُ',
  'تاء التأنيث': 'تَاءُ التَّأْنِيثِ',
  'تاء الفاعل': 'تَاءُ الْفَاعِلِ',
  'نون الوقاية': 'نُونُ الْوِقَايَةِ',
  'همزة الاستفهام': 'هَمْزَةُ الِاسْتِفْهَامِ',
  'همزة الوصل': 'هَمْزَةُ الْوَصْلِ',
  'أم': 'أَمْ',
  'ليس': 'لَيْسَ',
  'كان': 'كَانَ',
  'ما زال': 'مَا زَالَ',
  'ذو': 'ذُو',
  'ذات': 'ذَاتُ',
  'مائة': 'مِائَةٌ',
  'ألف': 'أَلْفٌ',
  'ربما': 'رُبَّمَا',
  'أما': 'أَمَّا',
  'بلى': 'بَلَى',
  'نعم': 'نَعَمْ',
  'لم': 'لَمْ',
  'لما': 'لَمَّا',
  'لن': 'لَنْ',
  'أن الناصبة': 'أَنْ النَّاصِبَةُ',
  'إن الشرطية': 'إِنْ الشَّرْطِيَّةُ',
  'كي': 'كَيْ',
  'حتى': 'حَتَّى',
  'إذن': 'إِذَنْ',
  'قط': 'قَطُّ',
  'أبدا': 'أَبَدًا',
  'من': 'مِنْ',
  'الاثنين': 'الِاثْنَيْنِ',
  'المخاطبة': 'الْمُخَاطَبَةِ',
  'أب': 'أَبٌ',
  'أخ': 'أَخٌ',
  'حم': 'حَمٌ',
  'فو': 'فُو',
  'الجذر': 'الْجَذْرُ',
  'أنت': 'أَنْتَ',
  'أنتم': 'أَنْتُمْ',
  'أنتن': 'أَنْتُنَّ',
  'هم': 'هُمْ',
  'هن': 'هُنَّ',
  'ذا': 'ذَا',
  'ذي': 'ذِي',
  'الذي': 'الَّذِي',
  'التي': 'الَّتِي',
  'قال': 'قَالَ',
  'يكتب': 'يَكْتُبُ',
  'يفعل': 'يَفْعَلُ',
  'يفعلان': 'يَفْعَلَانِ',
  'تفعلان': 'تَفْعَلَانِ',
  'يفعلون': 'يَفْعَلُونَ',
  'تفعلون': 'تَفْعَلُونَ',
  'تفعلين': 'تَفْعَلِينَ',
  'لست': 'لَسْتُ',
  'لسنا': 'لَسْنَا',
  'ليست': 'لَيْسَتْ',
  'ليسوا': 'لَيْسُوا',
  'لسن': 'لَسْنَ',
  'ذوو': 'ذَوُو',
  'ذوات': 'ذَوَاتُ',
  'عشر': 'عَشَرَ',
  'عشرة': 'عَشْرَةَ',
  'فعلان': 'فَعْلَانُ',
  'فعلى': 'فَعْلَى',
  'أفعل': 'أَفْعَلُ',
  'ـان': 'ـَانِ',
  'ـون': 'ـُونَ',
  'ـين': 'ـِينَ',
  'ـات': 'ـَاتُ',
  'ـت': 'ـْتُ',
  'ـنا': 'ـْنَا',
  'ـه': 'ـهُ',
  'ـها': 'ـهَا',
  'ـهم': 'ـهُمْ',
  'ـهن': 'ـهُنَّ',
  'لام': 'لَامٌ',
  'نون': 'نُونٌ',
  'واو': 'وَاوٌ',
  'ياء': 'يَاءٌ',
  'حرف': 'حَرْفٌ',
  'فعل': 'فِعْلٌ',
  'مثال': 'مِثَالٌ',
  'أجوف': 'أَجْوَفُ',
  'ناقص': 'نَاقِصٌ',
  'مجزوم': 'مَجْزُومٌ',
  'ممنوع': 'مَمْنُوعٌ',
  'الصرف': 'الصَّرْفِ',
  'الفاعل': 'الْفَاعِلُ',
  'الجماعة': 'الْجَمَاعَةِ',
  'النسوة': 'النِّسْوَةِ',
  'الناهية': 'النَّاهِيَةُ',
  'هيا بنا': 'هَيَّا بِنَا',
  'ها هو ذا': 'هَا هُوَ ذَا',
}));

const TERM_MEANINGS = new Map(Object.entries({
  'إن': 'إِنَّ — «поистине, воистину»; حَرْفُ تَوْكِيدٍ وَنَصْبٍ: усиливает утверждение и ставит своё имя в نَصْب.',
  'أن': 'أَنَّ — «что»; вводит придаточное сообщение и действует как إِنَّ.',
  'لكن': 'لَكِنَّ — «однако, но»; حَرْفُ اسْتِدْرَاكٍ وَنَصْبٍ: вводит противопоставление.',
  'كأن': 'كَأَنَّ — «как будто, словно»; حَرْفُ تَشْبِيهٍ وَظَنٍّ.',
  'لعل': 'لَعَلَّ — «может быть, возможно, надеюсь»; выражает надежду или опасение.',
  'ليت': 'لَيْتَ — «о если бы, хотелось бы»; частица пожелания.',
  'اسم إن': 'اِسْمُ إِنَّ — имя частицы إِنَّ; бывший مبتدأ, стоит в نَصْب.',
  'خبر إن': 'خَبَرُ إِنَّ — сказуемое частицы إِنَّ; бывший خبر, остаётся в رَفْع.',
  'ليس': 'لَيْسَ — «не является, нет»; её имя в رَفْع, خبر в نَصْب.',
  'كان': 'كَانَ — «был/была»; её имя в رَفْع, خبر в نَصْب.',
  'فاعل': 'فَاعِلٌ — действующее лицо, исполнитель действия; обычно مَرْفُوع.',
  'مفعول به': 'مَفْعُولٌ بِهِ — прямое дополнение; обычно مَنْصُوب.',
  'مبتدأ': 'مُبْتَدَأٌ — подлежащее именного предложения; обычно مَرْفُوع.',
  'خبر': 'خَبَرٌ — сказуемое/сообщение об مبتدأ; обычно مَرْفُوع.',
  'نعت': 'نَعْتٌ — определение/прилагательное после определяемого слова.',
  'منعوت': 'مَنْعُوتٌ — определяемое слово, к которому относится نَعْت.',
  'مضاف': 'مُضَافٌ — первый член идафы; не принимает танвин и обычно без ال.',
  'مضاف إليه': 'مُضَافٌ إِلَيْهِ — второй член идафы; всегда مَجْرُور.',
  'مرفوع': 'مَرْفُوعٌ — именительное состояние/рафʿ.',
  'منصوب': 'مَنْصُوبٌ — винительное состояние/насб.',
  'مجرور': 'مَجْرُورٌ — родительное состояние/джарр.',
  'جزم': 'جَزْمٌ — усечение глагола المضارع после частиц джазма.',
  'الفعل الماضي': 'الْفِعْلُ الْمَاضِي — глагол прошедшего времени.',
  'الفعل المضارع': 'الْفِعْلُ الْمُضَارِعُ — глагол настоящего/будущего времени.',
  'فعل الأمر': 'فِعْلُ الْأَمْرِ — повелительное наклонение.',
  'الأفعال الخمسة': 'الْأَفْعَالُ الْخَمْسَةُ — пять форм المضارع с ن: يفعلان، تفعلان، يفعلون، تفعلون، تفعلين.',
  'الأسماء الخمسة': 'الْأَسْمَاءُ الْخَمْسَةُ — пять имён, склоняемых буквами: أب، أخ، حم، فو، ذو.',
  'المثنى': 'الْمُثَنَّى — двойственное число.',
  'العدد': 'الْعَدَدُ — числительное.',
  'المعدود': 'الْمَعْدُودُ — исчисляемое слово после числительного.',
}));

const SISTERS = [
  ['إِنَّ', 'поистине, воистину', 'усиление; اسم إِنَّ в نَصْب, خبر إِنَّ в رَفْع'],
  ['أَنَّ', 'что', 'придаточное сообщение; اسم أَنَّ в نَصْب, خبر أَنَّ в رَفْع'],
  ['لَكِنَّ', 'но, однако', 'противопоставление; имя в نَصْب, خبر в رَفْع'],
  ['كَأَنَّ', 'как будто, словно', 'уподобление/предположение; имя в نَصْب, خبر в رَفْع'],
  ['لَعَلَّ', 'может быть, возможно, надеюсь', 'надежда или опасение; имя в نَصْب, خبر в رَفْع'],
  ['لَيْتَ', 'о если бы, хотелось бы', 'пожелание; имя в نَصْب, خبر в رَفْع'],
];

const manualKey = (value) => strip(value).trim();
const autoVowels = new Map();
const variants = new Map();

function rememberToken(token) {
  if (!ARABIC_RE.test(token) || !DIACRITIC_RE.test(token)) return;
  const key = strip(token);
  if (key.length < 2) return;
  if (!variants.has(key)) variants.set(key, new Set());
  variants.get(key).add(token);
}

for (const rules of Object.values(BOOK2_RULES)) {
  for (const item of rules) {
    [item.ar, item.explanation, item.note, ...(item.examples || []).flat()].filter(Boolean).forEach((text) => {
      for (const token of String(text).match(WORD_RE) || []) rememberToken(token);
    });
  }
}
for (const [key, set] of variants) {
  if (set.size === 1) autoVowels.set(key, [...set][0]);
}

function vocalizeArabicText(value) {
  let text = String(value ?? '');
  for (const [plain, vocalized] of MANUAL_VOWELS) {
    if (!/\s/u.test(plain)) continue;
    text = text.replaceAll(plain, vocalized);
  }
  return text.replace(WORD_RE, (token) => {
    if (DIACRITIC_RE.test(token)) return token;
    const key = strip(token);
    return MANUAL_VOWELS.get(key) || autoVowels.get(key) || token;
  });
}

function termClass(value) {
  const key = squash(value);
  if (/حرف|إن|أن|لكن|كأن|لعل|ليت|ليس|كان|لم|لما|لن|لا|ما|أم|بلى|نعم/u.test(key)) return 'rule-term-particle';
  if (/مبتدأ|اسم/u.test(key)) return 'rule-term-subject';
  if (/خبر/u.test(key)) return 'rule-term-predicate';
  if (/فاعل|مفعول/u.test(key)) return 'rule-term-role';
  if (/فعل|ماض|مضارع|أمر|افعال|يكتب|يفعل|ذهب|قال/u.test(key)) return 'rule-term-verb';
  if (/رفع|مرفوع/u.test(key)) return 'rule-term-raf';
  if (/نصب|منصوب/u.test(key)) return 'rule-term-nasb';
  if (/جر|مجرور/u.test(key)) return 'rule-term-jarr';
  if (/جزم|مجزوم/u.test(key)) return 'rule-term-jazm';
  if (/نعت|منعوت|مضاف/u.test(key)) return 'rule-term-structure';
  return 'rule-term-default';
}

function titleOverride(lesson, item) {
  if (lesson === 1 && strip(item.ar) === 'إن ولعل') {
    return {
      ar: 'إِنَّ وَأَخَوَاتُهَا',
      ru: 'إِنَّ и её сёстры',
      explanation:
        'В шархе этот урок раскрывает إِنَّ وَأَخَوَاتُهَا: эти частицы входят только в الْجُمْلَةُ الِاسْمِيَّةُ, ставят бывший مُبْتَدَأٌ как своё имя в نَصْب, а خَبَرٌ оставляют в رَفْع. Каждая частица имеет свой смысл: усиление, «что», противопоставление, уподобление, надежда/опасение или пожелание.',
      examples: [
        ['إِنَّ الْمَاءَ بَارِدٌ.', 'Поистине, вода холодная.'],
        ['سَمِعْتُ أَنَّ الْمُدَرِّسَ مَرِيضٌ.', 'Я услышал, что учитель болен.'],
        ['السَّيَّارَةُ قَدِيمَةٌ، لَكِنَّهَا قَوِيَّةٌ.', 'Машина старая, но она крепкая.'],
        ['كَأَنَّ الْمَسْجِدَ مَدْرَسَةٌ.', 'Как будто мечеть — школа.'],
        ['لَعَلَّ الِاخْتِبَارَ سَهْلٌ.', 'Возможно, экзамен лёгкий.'],
        ['لَيْتَ مُحَمَّدًا طَبِيبٌ.', 'Хотелось бы, чтобы Мухаммад был врачом.'],
      ],
      note:
        'После إِنَّ нельзя оставлять имя с даммой: правильно إِنَّ الْمَاءَ / إِنَّ الطَّالِبَ. Дамма остаётся у خبر: بَارِدٌ، مُجْتَهِدٌ.',
    };
  }
  return item;
}

function guidanceFor(item) {
  const key = `${item.ar} ${item.ru} ${item.explanation}`.toLowerCase();
  if (/إِنَّ|أَنَّ|لَكِنَّ|كَأَنَّ|لَعَلَّ|لَيْتَ|أخوات|сестр/u.test(key)) {
    return {
      steps: ['Найдите именное предложение: مُبْتَدَأٌ + خَبَرٌ.', 'Поставьте после частицы её имя в نَصْب.', 'Оставьте её خبر в رَفْع и переведите смысл самой частицы.'],
      mistake: 'Главная ошибка: после إِنَّ писать имя с даммой. Правильно: إِنَّ الطَّالِبَ مُجْتَهِدٌ — الطَّالِبَ в نَصْب, مُجْتَهِدٌ в رَفْع.',
    };
  }
  if (/числ|عَدَد|عُقُود|مِئَ|أَلْف/u.test(key)) return {
    steps: ['Определите число и разряд.', 'Проверьте род числительного и род الْمَعْدُودُ.', 'Поставьте الْمَعْدُودُ в нужное число и падеж.'],
    mistake: 'Нельзя применять одно правило ко всем числам: ٣–١٠, ١١–١٩, десятки, сотни и тысячи ведут себя по-разному.',
  };
  if (/مُضَارِع|مَاض|أَمْر|глагол|جَزْم|نَصْب/u.test(key)) return {
    steps: ['Найдите корень и тип глагола.', 'Определите время, лицо, число и род.', 'Проверьте конечное состояние: رَفْع، نَصْب или جَزْم.'],
    mistake: 'Не ориентируйтесь только на русский перевод: арабская приставка, окончание и частица перед глаголом решают форму.',
  };
  if (/لَيْسَ|كَانَ|ما زال/u.test(key)) return {
    steps: ['Найдите имя этой частицы/глагола.', 'Проверьте: имя в رَفْع.', 'Проверьте: خبر в نَصْب, даже если смысл по-русски похож на обычное сказуемое.'],
    mistake: 'Не оставляйте خبر لَيْسَ или خبر كَانَ в рафʿе: это место требует نَصْب.',
  };
  if (/مضاف|إِضَاف|ذُو|ذَات/u.test(key)) return {
    steps: ['Найдите два связанных имени.', 'Первое — مُضَافٌ, второе — مُضَافٌ إِلَيْهِ.', 'У второго члена всегда جَرّ, а первый не принимает танвин.'],
    mistake: 'Первый член идафы не получает одновременно танвин и связь принадлежности.',
  };
  if (/نَعْت|صفة|прилаг|определ/u.test(key)) return {
    steps: ['Найдите مَنْعُوتٌ — определяемое слово.', 'Поставьте после него نَعْتٌ.', 'Согласуйте نَعْتٌ в падеже, определённости, роде и числе.'],
    mistake: 'Нельзя переводить прилагательное отдельно от определяемого слова: его окончание зависит от مَنْعُوت.',
  };
  return {
    steps: ['Прочитайте арабский заголовок и русский смысл.', 'Найдите эту конструкцию в примере.', 'Проверьте роль слов: اسم، خبر، فاعل، مفعول به, затем окончание.'],
    mistake: 'Не разбирайте окончание вне предложения: сначала установите функцию слова, потом падеж или наклонение.',
  };
}

function glossaryFor(item) {
  const found = new Map();
  const add = (ar, ru) => {
    const vocalized = vocalizeArabicText(ar);
    const key = squash(vocalized);
    if (!key || found.has(key)) return;
    found.set(key, [vocalized, ru]);
  };
  add(item.ar, item.ru);
  const source = `${item.ar} ${item.explanation}`;
  for (const [plain, meaning] of TERM_MEANINGS) {
    if (containsArabicTerm(source, plain)) add(plain, meaning);
  }
  if (squash(item.ar).includes(squash('إن وأخواتها'))) {
    for (const [ar, ru, action] of SISTERS) add(ar, `${ar} — ${ru}; ${action}.`);
  }
  return [...found.values()].slice(0, 10);
}

function containsArabicTerm(source, term) {
  const cleanSource = strip(source);
  const cleanTerm = strip(term);
  if (!ARABIC_RE.test(cleanTerm)) return false;
  if (/\s/u.test(cleanTerm)) return cleanSource.includes(cleanTerm);
  const tokens = cleanSource.match(/[\u0621-\u064A\u0671-\u06D3]+/gu) || [];
  return tokens.includes(cleanTerm);
}

function cardsForMeanings(item) {
  const meanings = glossaryFor(item);
  return `<div class="rule-meaning-grid">${meanings.map(([ar, ru]) =>
    `<div class="rule-meaning-card ${termClass(ar)}"><span class="rule-term-ar" dir="rtl" lang="ar">${esc(ar)}</span><span class="rule-term-ru">${esc(vocalizeArabicText(ru))}</span></div>`
  ).join('')}</div>`;
}

function examplesFor(item) {
  return `<div class="rule-example-list">${(item.examples || []).map(([ar, ru]) =>
    `<div class="rule-example-card ${termClass(`${item.ar} ${ar}`)}"><span class="rule-example-ar" dir="rtl" lang="ar">${esc(vocalizeArabicText(ar))}</span><span class="rule-example-ru">${esc(ru)}</span></div>`
  ).join('')}</div>`;
}

function buildContent(item) {
  const guidance = guidanceFor(item);
  const ar = vocalizeArabicText(item.ar);
  const ru = vocalizeArabicText(item.ru);
  const explanation = vocalizeArabicText(item.explanation);
  const titleCard =
    `<div class="rule-study-card"><span class="rule-card-kicker">Название и смысл</span><span class="rule-main-ar" dir="rtl" lang="ar">${esc(ar)}</span><p class="rule-study-text">${esc(ru)}. ${esc(explanation)}</p></div>`;
  const meaningCard =
    `<div class="rule-study-card"><span class="rule-card-kicker">Арабские слова → русский смысл</span>${cardsForMeanings(item)}</div>`;
  const steps =
    `<div class="rule-study-card"><span class="rule-card-kicker">Как применять</span><ol>${guidance.steps.map((step) => `<li>${esc(vocalizeArabicText(step))}</li>`).join('')}</ol></div>`;
  const examples =
    `<div class="rule-study-card"><span class="rule-card-kicker">Примеры</span>${examplesFor(item)}</div>`;
  const check =
    `<div class="rule-check-card"><b>Частая ошибка.</b> ${esc(vocalizeArabicText(guidance.mistake))}${item.note ? `<br><br><b>Самопроверка.</b> ${esc(vocalizeArabicText(item.note))}` : ''}</div>`;
  return `<div class="rule-study">${titleCard}${meaningCard}${steps}${examples}${check}</div>`;
}

const expected = Array.from({ length: 31 }, (_, index) => index + 1);
const lessons = Object.keys(BOOK2_RULES).map(Number).sort((a, b) => a - b);
if (JSON.stringify(lessons) !== JSON.stringify(expected)) {
  throw new Error('Правила должны покрывать уроки 1–31 без пропусков.');
}

const rows = [];
for (const lesson of expected) {
  const rules = BOOK2_RULES[lesson];
  if (!Array.isArray(rules) || !rules.length) throw new Error(`В уроке ${lesson} нет правил.`);
  rules.forEach((rawItem, index) => {
    const item = titleOverride(lesson, rawItem);
    const title = `${vocalizeArabicText(item.ar)} (${vocalizeArabicText(item.ru)})`;
    const summary = `${vocalizeArabicText(item.ru)}. ${vocalizeArabicText(item.explanation).slice(0, 210)}`;
    rows.push([COURSE, String(lesson), title, buildContent(item), index + 1, 'rule', summary]);
  });
}

const values = rows.flat().join('|');
if (/\uFFFD/u.test(values) || /(?:Р.|С.){4}/u.test(values)) throw new Error('Обнаружен повреждённый Unicode.');
if (rows.length < 120) throw new Error(`Слишком мало правил для второго тома: ${rows.length}`);
if (new Set(rows.map((row) => row[1])).size !== 31) throw new Error('Покрыты не все 31 урок.');

const ruleValues = rows.map((row) => `(${row.map(sql).join(', ')})`).join(',\n');
const migration = `-- Rebuild Medina Book 2 rules as readable sharh-based cards with Arabic diacritics and Russian meanings.\n-- Scope: only ${COURSE} rules. Vocabulary and other volumes are untouched.\n-- The previous live rules are saved to backups/book2-rules-before-sharh-cards.json before applying this migration.\nbegin;\n\ndelete from public.rule_sections where rule_id in (select id from public.rules where course_name in (${sql(COURSE)}, ${sql(LEGACY_MOJIBAKE_COURSE)}));\ndelete from public.rules where course_name in (${sql(COURSE)}, ${sql(LEGACY_MOJIBAKE_COURSE)});\n\ninsert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary) values\n${ruleValues};\n\ncommit;\n`;

fs.mkdirSync(path.dirname(output), { recursive: true });
fs.writeFileSync(output, migration, 'utf8');
console.log(JSON.stringify({ output, lessons: 31, rules: rows.length }, null, 2));
