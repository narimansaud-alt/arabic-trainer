-- Restore the complete, source-ordered Russian rendering of Medina Book 1
-- lessons 1-3. The public cards reproduce every explanation and example from
-- Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 3-7, without changing rule IDs.

begin;

create temporary table book1_full_sharh_updates (
  rule_id bigint primary key,
  expected_lesson text not null,
  content text not null
) on commit drop;

insert into book1_full_sharh_updates (rule_id, expected_lesson, content)
values
(
  1876,
  '1',
  $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный текст шарха · страница 3</span><span class="rule-main-ar" dir="rtl" lang="ar">هَذَا: اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْقَرِيبِ، الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">هَذَا</span> — указательное имя для близкого единственного мужского рода, как разумного, так и неразумного.</p></div><div class="rule-study-card"><span class="rule-card-kicker">الْعَاقِلُ (разумный)</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا رَجُلٌ.</span><span class="rule-example-ru">Это мужчина.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا وَلَدٌ.</span><span class="rule-example-ru">Это мальчик.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا شَيْخٌ.</span><span class="rule-example-ru">Это шейх.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">غَيْرُ الْعَاقِلِ (неразумный)</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا كِتَابٌ.</span><span class="rule-example-ru">Это книга.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَابٌ.</span><span class="rule-example-ru">Это дверь.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا قَلَمٌ.</span><span class="rule-example-ru">Это ручка.</span></div></div></div></div>$html$
),
(
  1877,
  '1',
  $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный текст шарха · страница 3</span><span class="rule-main-ar" dir="rtl" lang="ar">مَا: اِسْمُ اِسْتِفْهَامٍ لِغَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">مَا</span> — вопросительное имя для неразумного.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">مَا هَذَا؟ هَذَا كِتَابٌ. ✓</span><span class="rule-example-ru">Что это? Это книга. Верно.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">مَا هَذَا؟ هَذَا بَابٌ. ✓</span><span class="rule-example-ru">Что это? Это дверь. Верно.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">مَا هَذَا؟ هَذَا قَلَمٌ. ✓</span><span class="rule-example-ru">Что это? Это ручка. Верно.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">مَا هَذَا؟ هَذَا رَجُلٌ. ✕</span><span class="rule-example-ru">Что это? Это мужчина. Неверно.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">مَا هَذَا؟ هَذَا وَلَدٌ. ✕</span><span class="rule-example-ru">Что это? Это мальчик. Неверно.</span></div></div></div></div>$html$
),
(
  1878,
  '1',
  $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный текст шарха · страницы 3–4</span><span class="rule-main-ar" dir="rtl" lang="ar">أَ: هَمْزَةُ الِاسْتِفْهَامِ، حَرْفٌ جَوَابُهُ (نَعَمْ) أَوْ (لَا).</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">أَ</span> — вопросительная хамза; это частица, ответом на которую служит <span dir="rtl" lang="ar">نَعَمْ</span> («да») или <span dir="rtl" lang="ar">لَا</span> («нет»).</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора · страница 3</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهَذَا سَرِيرٌ؟ نَعَمْ. هَذَا سَرِيرٌ.</span><span class="rule-example-ru">Это кровать? Да. Это кровать.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهَذَا رَجُلٌ؟ نَعَمْ. هَذَا رَجُلٌ.</span><span class="rule-example-ru">Это мужчина? Да. Это мужчина.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهَذَا كُرْسِيٌّ؟ لَا. هَذَا سَرِيرٌ.</span><span class="rule-example-ru">Это стул? Нет. Это кровать.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهَذَا وَلَدٌ؟ لَا. هَذَا رَجُلٌ.</span><span class="rule-example-ru">Это мальчик? Нет. Это мужчина.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора · страница 4</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهَذَا طَبِيبٌ؟ نَعَمْ. هَذَا طَبِيبٌ.</span><span class="rule-example-ru">Это врач? Да. Это врач.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهَذَا طَالِبٌ؟ لَا. هَذَا طَبِيبٌ.</span><span class="rule-example-ru">Это студент? Нет. Это врач.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهَذَا كَلْبٌ؟ نَعَمْ. هَذَا كَلْبٌ.</span><span class="rule-example-ru">Это собака? Да. Это собака.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهَذَا قِطٌّ؟ لَا. هَذَا كَلْبٌ.</span><span class="rule-example-ru">Это кот? Нет. Это собака.</span></div></div></div></div>$html$
),
(
  1879,
  '1',
  $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный текст шарха · страница 4</span><span class="rule-main-ar" dir="rtl" lang="ar">مَنْ: اِسْمُ اِسْتِفْهَامٍ لِلْعَاقِلِ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">مَنْ</span> — вопросительное имя для разумного.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">مَنْ هَذَا؟ هَذَا طَبِيبٌ. ✓</span><span class="rule-example-ru">Кто это? Это врач. Верно.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">مَنْ هَذَا؟ هَذَا وَلَدٌ. ✓</span><span class="rule-example-ru">Кто это? Это мальчик. Верно.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">مَنْ هَذَا؟ هَذَا طَالِبٌ. ✓</span><span class="rule-example-ru">Кто это? Это студент. Верно.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">مَنْ هَذَا؟ هَذَا كِتَابٌ. ✕</span><span class="rule-example-ru">Кто это? Это книга. Неверно.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">مَنْ هَذَا؟ هَذَا قَلَمٌ. ✕</span><span class="rule-example-ru">Кто это? Это ручка. Неверно.</span></div></div></div></div>$html$
),
(
  1471,
  '2',
  $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный текст шарха · страница 5</span><span class="rule-main-ar" dir="rtl" lang="ar">ذَلِكَ: اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْبَعِيدِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">ذَلِكَ</span> — указательное имя для далёкого единственного мужского рода, разумного и неразумного.</p></div><div class="rule-study-card"><span class="rule-card-kicker">الْعَاقِلُ (разумный)</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ رَجُلٌ.</span><span class="rule-example-ru">То — мужчина.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ مُدَرِّسٌ.</span><span class="rule-example-ru">То — преподаватель.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ طَالِبٌ.</span><span class="rule-example-ru">То — студент.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">غَيْرُ الْعَاقِلِ (неразумный)</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ نَجْمٌ.</span><span class="rule-example-ru">То — звезда.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ بَيْتٌ.</span><span class="rule-example-ru">То — дом.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ حِصَانٌ.</span><span class="rule-example-ru">То — лошадь.</span></div></div></div></div>$html$
),
(
  1472,
  '2',
  $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный текст шарха · страница 5</span><span class="rule-main-ar" dir="rtl" lang="ar">مَنْ هَذَا؟ سُؤَالٌ عَنِ الْقَرِيبِ الْعَاقِلِ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">مَنْ هَذَا؟</span> — вопрос о близком разумном: «Кто это?»</p><span class="rule-main-ar" dir="rtl" lang="ar">مَنْ ذَلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ الْعَاقِلِ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">مَنْ ذَلِكَ؟</span> — вопрос о далёком разумном: «Кто это там?»</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هَذَا؟ هَذَا مُدِيرٌ.</span><span class="rule-example-ru">Кто это? Это директор.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هَذَا؟ هَذَا إِمَامٌ.</span><span class="rule-example-ru">Кто это? Это имам.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ ذَلِكَ؟ ذَلِكَ مُدَرِّسٌ.</span><span class="rule-example-ru">Кто это там? То — преподаватель.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ ذَلِكَ؟ ذَلِكَ طَالِبٌ.</span><span class="rule-example-ru">Кто это там? То — студент.</span></div></div></div></div>$html$
),
(
  1880,
  '2',
  $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный текст шарха · страница 5</span><span class="rule-main-ar" dir="rtl" lang="ar">مَا هَذَا؟ سُؤَالٌ عَنِ الْقَرِيبِ غَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">مَا هَذَا؟</span> — вопрос о близком неразумном: «Что это?»</p><span class="rule-main-ar" dir="rtl" lang="ar">مَا ذَلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ غَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">مَا ذَلِكَ؟</span> — вопрос о далёком неразумном: «Что это там?»</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">مَا هَذَا؟ هَذَا حَجَرٌ.</span><span class="rule-example-ru">Что это? Это камень.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">مَا هَذَا؟ هَذَا حِمَارٌ.</span><span class="rule-example-ru">Что это? Это осёл.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">مَا ذَلِكَ؟ ذَلِكَ لَبَنٌ.</span><span class="rule-example-ru">Что это там? То — молоко.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">مَا ذَلِكَ؟ ذَلِكَ قِطٌّ.</span><span class="rule-example-ru">Что это там? То — кот.</span></div></div></div></div>$html$
),
(
  1473,
  '3',
  $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный текст шарха · страница 6</span><span class="rule-main-ar" dir="rtl" lang="ar">أَلْ: حَرْفُ تَعْرِيفٍ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">أَلْ</span> — частица определённости (определённый артикль).</p></div><div class="rule-study-card"><span class="rule-card-kicker">Формы из шарха</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">بَيْتٌ: الْبَيْتُ</span><span class="rule-term-ru">неопределённое «дом»: определённое «дом»</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">مَسْجِدٌ: الْمَسْجِدُ</span><span class="rule-term-ru">неопределённое «мечеть»: определённое «мечеть»</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">قَلَمٌ: الْقَلَمُ</span><span class="rule-term-ru">неопределённое «ручка»: определённое «ручка»</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Замечание автора</span><span class="rule-main-ar" dir="rtl" lang="ar">يُحْذَفُ التَّنْوِينُ عِنْدَ دُخُولِ أَلْ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> Танвин удаляется при присоединении <span dir="rtl" lang="ar">أَلْ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все правильные и неправильные формы автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">الْقَلَمُ مَكْسُورٌ. ✓</span><span class="rule-example-ru">Ручка сломана. Верно.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">الْبَابُ مَفْتُوحٌ. ✓</span><span class="rule-example-ru">Дверь открыта. Верно.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">الْوَلَدُ جَالِسٌ. ✓</span><span class="rule-example-ru">Мальчик сидит. Верно.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">الْقَلَمٌ. ✕</span><span class="rule-example-ru">Форма «ручка» неверна.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">قَلَمُ. ✕</span><span class="rule-example-ru">Форма «ручка» неверна.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">الْوَلَدٌ جَالِسٌ. ✕</span><span class="rule-example-ru">Форма «мальчик сидит» неверна.</span></div></div></div></div>$html$
),
(
  1474,
  '3',
  $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный текст шарха · страница 6</span><span class="rule-main-ar" dir="rtl" lang="ar">النَّكِرَةُ: شَيْءٌ غَيْرُ مُعَيَّنٍ، نَحْوُ: بَيْتٌ، قَلَمٌ، رَجُلٌ، بِنْتٌ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">النَّكِرَةُ</span> (неопределённое имя) — нечто неопределённое, например: дом, ручка, мужчина, девочка.</p><span class="rule-main-ar" dir="rtl" lang="ar">الْمَعْرِفَةُ: شَيْءٌ مُعَيَّنٌ، نَحْوُ: الْبَيْتُ، الْقَلَمُ، الرَّجُلُ، الْبِنْتُ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">الْمَعْرِفَةُ</span> (определённое имя) — нечто определённое, например: определённый дом, определённая ручка, определённый мужчина, определённая девочка.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Полное пояснение автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">بَيْتٌ: يَشْمَلُ كُلَّ الْبُيُوتِ، وَلَيْسَ بَيْتًا مُعَيَّنًا.</span><span class="rule-example-ru">Слово «дом» охватывает все дома и не означает какой-либо определённый дом.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">الْبَيْتُ: يَدُلُّ عَلَى بَيْتٍ مُعَيَّنٍ بِذَاتِهِ.</span><span class="rule-example-ru">Слово «определённый дом» указывает на конкретный дом как таковой.</span></div></div></div></div>$html$
),
(
  1475,
  '3',
  $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный текст шарха · страницы 6–7</span><span class="rule-main-ar" dir="rtl" lang="ar">الْحُرُوفُ الْقَمَرِيَّةُ: يُنْطَقُ السُّكُونُ عَلَى اللَّامِ (الْقَمَرُ).</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">الْحُرُوفُ الْقَمَرِيَّةُ</span> (лунные буквы): сукун над буквой <span dir="rtl" lang="ar">ل</span> произносится: <span dir="rtl" lang="ar">الْقَمَرُ</span> (луна).</p><span class="rule-main-ar" dir="rtl" lang="ar">الْحُرُوفُ الشَّمْسِيَّةُ: لَا يُنْطَقُ السُّكُونُ عَلَى اللَّامِ، وَتُوضَعُ شَدَّةٌ عَلَى الْحَرْفِ الَّذِي بَعْدَهُ (الشَّمْسُ).</span><p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">الْحُرُوفُ الشَّمْسِيَّةُ</span> (солнечные буквы): сукун над буквой <span dir="rtl" lang="ar">ل</span> не произносится, а над следующей после неё буквой ставится шадда: <span dir="rtl" lang="ar">الشَّمْسُ</span> (солнце).</p></div><div class="rule-study-card"><span class="rule-card-kicker">الْحُرُوفُ الْقَمَرِيَّةُ (лунные буквы)</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Буква</th><th>Пример автора</th><th>Русский перевод</th></tr></thead><tbody><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْأَبُ</span></td><td>отец</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ب</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْبَابُ</span></td><td>дверь</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ج</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْجَنَّةُ</span></td><td>рай</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ح</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْحِمَارُ</span></td><td>осёл</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">خ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْخُبْزُ</span></td><td>хлеб</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ع</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْعَيْنُ</span></td><td>глаз</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">غ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْغَدَاءُ</span></td><td>обед</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ف</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْفَمُ</span></td><td>рот</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ق</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْقَمَرُ</span></td><td>луна</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ك</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْكَلْبُ</span></td><td>собака</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">م</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمَاءُ</span></td><td>вода</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">و</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْوَلَدُ</span></td><td>мальчик</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هـ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْهَوَاءُ</span></td><td>воздух</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْيَدُ</span></td><td>рука</td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">الْحُرُوفُ الشَّمْسِيَّةُ (солнечные буквы)</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Буква</th><th>Пример автора</th><th>Русский перевод</th></tr></thead><tbody><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ت</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">التَّاجِرُ</span></td><td>торговец</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ث</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الثَّوْبُ</span></td><td>одежда</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">د</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الدِّيكُ</span></td><td>петух</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ذ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الذَّهَبُ</span></td><td>золото</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ر</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الرَّجُلُ</span></td><td>мужчина</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ز</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الزَّهْرَةُ</span></td><td>цветок</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">س</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّمَكُ</span></td><td>рыба</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ش</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الشَّمْسُ</span></td><td>солнце</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ص</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الصَّدْرُ</span></td><td>грудь</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ض</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الضَّيْفُ</span></td><td>гость</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ط</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبُ</span></td><td>студент</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ظ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الظَّهْرُ</span></td><td>спина</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ل</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اللَّحْمُ</span></td><td>мясо</td></tr><tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ن</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">النَّجْمُ</span></td><td>звезда</td></tr></tbody></table></div></div></div>$html$
);

do $migration$
declare
  expected_count integer;
  changed_count integer;
begin
  select count(*) into expected_count
  from public.rules r
  join book1_full_sharh_updates u on u.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 1)'
    and r.lesson_number = u.expected_lesson;

  if expected_count <> 10 then
    raise exception 'Book 1 lessons 1-3 identity check failed: expected 10 matching rules, found %', expected_count;
  end if;

  update public.rules r
  set content = u.content
  from book1_full_sharh_updates u
  where r.id = u.rule_id
    and r.course_name = 'Мединский курс (Том 1)'
    and r.lesson_number = u.expected_lesson;

  get diagnostics changed_count = row_count;
  if changed_count <> 10 then
    raise exception 'Book 1 lessons 1-3 content update failed: updated % rows', changed_count;
  end if;

  update public.rule_sources
  set source_text = $source$الْقَلَمُ مَكْسُورٌ ✓
الْبَابُ مَفْتُوحٌ ✓
الْوَلَدُ جَالِسٌ ✓
الْقَلَمٌ ✕
قَلَمُ ✕
الْوَلَدٌ جَالِسٌ ✕$source$
  where rule_id = 1473
    and source_document = 'Sharkh_na_1_tom_Med_kursa.pdf'
    and source_page_from = 6
    and sort_order = 2;

  get diagnostics changed_count = row_count;
  if changed_count <> 1 then
    raise exception 'Book 1 lesson 3 invalid-form source restoration matched % rows', changed_count;
  end if;

  update public.rule_sources
  set source_text = replace(source_text, 'غ : الْغِذَاءُ', 'غ : الْغَدَاءُ')
  where rule_id = 1475
    and source_document = 'Sharkh_na_1_tom_Med_kursa.pdf'
    and source_page_from = 7
    and sort_order = 2
    and strpos(source_text, 'غ : الْغِذَاءُ') > 0;

  get diagnostics changed_count = row_count;
  if changed_count <> 1 then
    raise exception 'Book 1 lesson 3 al-ghadaa source correction matched % rows', changed_count;
  end if;

  if exists (
    select 1
    from public.rules r
    join book1_full_sharh_updates u on u.rule_id = r.id
    where strpos(r.content, 'Полный перевод:') = 0
  ) then
    raise exception 'A Book 1 lesson 1-3 card is missing its full Russian translation';
  end if;

  if not exists (
    select 1 from public.rules
    where id = 1878
      and content like '%أَهَذَا رَجُلٌ؟%'
      and content like '%أَهَذَا وَلَدٌ؟%'
      and content like '%أَهَذَا كَلْبٌ؟%'
      and content like '%أَهَذَا قِطٌّ؟%'
  ) then
    raise exception 'Book 1 lesson 1 is still missing yes/no examples from PDF pages 3-4';
  end if;

  if not exists (
    select 1 from public.rules
    where id = 1473
      and content like '%الْقَلَمٌ%'
      and content like '%قَلَمُ.%'
      and content like '%الْوَلَدٌ جَالِسٌ%'
  ) then
    raise exception 'Book 1 lesson 3 is still missing the three invalid source forms';
  end if;
end;
$migration$;

commit;
