-- Verify Medina Book 1 lesson 6 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF page 10.

begin;

do $migration$
declare
  target_rule_id bigint;
begin
  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '6'
  );

  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '6'
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '6'
    and sort_order = 1;

  update public.rules
  set
    title = 'هٰذِهِ (эта: указательное имя для близкого единственного женского рода)',
    rule_ar = 'هٰذِهِ اِسْمُ إِشَارَةٍ لِلْمُفْرَدَةِ الْمُؤَنَّثَةِ الْقَرِيبَةِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    summary = 'هٰذِهِ اِسْمُ إِشَارَةٍ لِلْمُفْرَدَةِ الْمُؤَنَّثَةِ الْقَرِيبَةِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">هٰذِهِ اِسْمُ إِشَارَةٍ لِلْمُفْرَدَةِ الْمُؤَنَّثَةِ الْقَرِيبَةِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">هٰذِهِ</span> — указательное имя «эта». Оно указывает на одно близкое лицо или один близкий предмет женского рода.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Разумное</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذِهِ خَدِيجَةُ.</span><span class="rule-example-ru">Это Хадиджа.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذِهِ بِنْتٌ.</span><span class="rule-example-ru">Это девочка.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذِهِ أُخْتُ الْمُهَنْدِسِ.</span><span class="rule-example-ru">Это сестра инженера.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Неразумное</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذِهِ سَيَّارَةٌ.</span><span class="rule-example-ru">Это автомобиль.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذِهِ مِكْوَاةٌ.</span><span class="rule-example-ru">Это утюг.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذِهِ دَرَّاجَةُ أَنَسٍ.</span><span class="rule-example-ru">Это велосипед Анаса.</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$هَذِهِ : اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُؤَنَّثِ الْقَرِيبِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ .$$,
      10,
      10,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْعَاقِلُ
هَذِهِ خَدِيجَةُ
هَذِهِ بِنْتٌ
هَذِهِ أُخْتُ الْمُهَنْدِسِ

غَيْرُ الْعَاقِلِ
هَذِهِ سَيَّارَةٌ
هَذِهِ مِكْوَاةٌ
هَذِهِ دَرَّاجَةُ أَنَسٍ$$,
      10,
      10,
      2
    );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '6'
    and sort_order = 2;

  update public.rules
  set
    title = 'أَسْمَاءٌ مُؤَنَّثَةٌ وَأَسْمَاءٌ مُذَكَّرَةٌ (примеры рода имён)',
    rule_ar = 'مِنَ الْأَسْمَاءِ الْمُؤَنَّثَةِ: أُذُنٌ، وَعَيْنٌ، وَيَدٌ، وَرِجْلٌ، وَمِلْعَقَةٌ، وَقِدْرٌ؛ وَأَنْفٌ وَفَمٌ مُذَكَّرَانِ.',
    summary = 'مِنَ الْأَسْمَاءِ الْمُؤَنَّثَةِ: أُذُنٌ، وَعَيْنٌ، وَيَدٌ، وَرِجْلٌ، وَمِلْعَقَةٌ، وَقِدْرٌ؛ وَأَنْفٌ وَفَمٌ مُذَكَّرَانِ.',
    rule_kind = 'important',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Формы из урока</span><span class="rule-main-ar" dir="rtl" lang="ar">مِنَ الْأَسْمَاءِ الْمُؤَنَّثَةِ: أُذُنٌ، وَعَيْنٌ، وَيَدٌ، وَرِجْلٌ، وَمِلْعَقَةٌ، وَقِدْرٌ؛ وَأَنْفٌ وَفَمٌ مُذَكَّرَانِ.</span><p class="rule-study-text">Род этих слов определяется по их употреблению с <span dir="rtl" lang="ar">هٰذِهِ</span> или <span dir="rtl" lang="ar">هٰذَا</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Женский род</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">هٰذِهِ أُذُنٌ</span><span class="rule-term-ru">это ухо</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">هٰذِهِ عَيْنٌ</span><span class="rule-term-ru">это глаз</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">هٰذِهِ يَدٌ</span><span class="rule-term-ru">это рука</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">هٰذِهِ رِجْلٌ</span><span class="rule-term-ru">это нога</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">هٰذِهِ مِلْعَقَةٌ</span><span class="rule-term-ru">это ложка</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">هٰذِهِ قِدْرٌ</span><span class="rule-term-ru">это кастрюля</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Мужской род</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا أَنْفٌ، وَهٰذَا فَمٌ. ✓</span><span class="rule-example-ru">Это нос, а это рот.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذِهِ أَنْفٌ، وَهٰذِهِ فَمٌ. ✕</span><span class="rule-example-ru">Неверно: أَنْفٌ и فَمٌ мужского рода.</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Sharkh_na_1_tom_Med_kursa.pdf',
    $$أَمْثِلَةٌ أُخْرَى : هَذِهِ أُذُنٌ وَهَذِهِ عَيْنٌ . هَذِهِ يَدٌ وَهَذِهِ رِجْلٌ . هَذِهِ مِلْعَقَةٌ وَهَذِهِ قِدْرٌ .

هَذِهِ أَنْفٌ، وَهَذِهِ فَمٌ ✕
هَذَا أَنْفٌ، وَهَذَا فَمٌ ✓$$,
    10,
    10,
    1
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '6'
    and sort_order = 3;

  update public.rules
  set
    title = 'الْجُمْلَةُ الِاسْمِيَّةُ: الْمُبْتَدَأُ وَالْخَبَرُ (именное предложение: мубтада и хабар)',
    rule_ar = 'الْجُمْلَةُ الِاسْمِيَّةُ تَتَكَوَّنُ مِنْ كَلِمَتَيْنِ تُفِيدَانِ مَعْنًى تَامًّا مُفِيدًا، وَهُمَا الْمُبْتَدَأُ وَالْخَبَرُ، وَيُطَابِقُ الْخَبَرُ الْمُبْتَدَأَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ.',
    summary = 'الْجُمْلَةُ الِاسْمِيَّةُ تَتَكَوَّنُ مِنْ كَلِمَتَيْنِ تُفِيدَانِ مَعْنًى تَامًّا مُفِيدًا، وَهُمَا الْمُبْتَدَأُ وَالْخَبَرُ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الْجُمْلَةُ الِاسْمِيَّةُ تَتَكَوَّنُ مِنْ كَلِمَتَيْنِ تُفِيدَانِ مَعْنًى تَامًّا مُفِيدًا، وَهُمَا الْمُبْتَدَأُ وَالْخَبَرُ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">الْجُمْلَةُ الِاسْمِيَّةُ</span> состоит из двух слов, которые дают полный полезный смысл. Первый член — <span dir="rtl" lang="ar">الْمُبْتَدَأُ</span>, второй — <span dir="rtl" lang="ar">الْخَبَرُ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><table><thead><tr><th>Предложение</th><th>الْمُبْتَدَأُ</th><th>الْخَبَرُ</th><th>Перевод</th></tr></thead><tbody><tr><td dir="rtl" lang="ar">مُحَمَّدٌ طَالِبٌ.</td><td dir="rtl" lang="ar">مُحَمَّدٌ</td><td dir="rtl" lang="ar">طَالِبٌ</td><td>Мухаммад — студент.</td></tr><tr><td dir="rtl" lang="ar">تِلْكَ شَمْسٌ.</td><td dir="rtl" lang="ar">تِلْكَ</td><td dir="rtl" lang="ar">شَمْسٌ</td><td>То — солнце.</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Полезный законченный смысл</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">مُحَمَّدٌ طَالِبٌ. الْبَابُ مُغْلَقٌ. الْمِنْدِيلُ وَسِخٌ.</span><span class="rule-example-ru">Мухаммад — студент. Дверь закрыта. Платок грязный.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">فَاطِمَةُ طَالِبَةٌ. النَّافِذَةُ مَفْتُوحَةٌ. الْقَهْوَةُ لَذِيذَةٌ.</span><span class="rule-example-ru">Фатима — студентка. Окно открыто. Кофе вкусный.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Согласование рода</span><div class="rule-example-list"><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">الْغُرْفَةُ مَفْتُوحَةٌ. ✓</span><span class="rule-example-ru">Комната открыта: хабар женского рода.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">الْغُرْفَةُ مَفْتُوحٌ. ✕</span><span class="rule-example-ru">Неверно: хабар не согласован с женским мубтада.</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْجُمْلَةُ الِاسْمِيَّةُ

الْجُمْلَةُ الِاسْمِيَّةُ : تَتَكَوَّنُ مِنْ كَلِمَتَيْنِ تُفِيدَانِ مَعْنًى تَامًّا مُفِيدًا . ( وَتُسَمَّى جُمْلَةً مُفِيدَةً ) .$$,
      10,
      10,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$مُحَمَّدٌ طَالِبٌ . الْبَابُ مُغْلَقٌ . الْمِنْدِيلُ وَسِخٌ . هُوَ مُسْلِمٌ . ذَلِكَ قَمَرٌ .
فَاطِمَةُ طَالِبَةٌ . النَّافِذَةُ مَفْتُوحَةٌ . الْقَهْوَةُ لَذِيذَةٌ . هِيَ مُسْلِمَةٌ . تِلْكَ شَمْسٌ .$$,
      10,
      10,
      2
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْغُرْفَةُ مَفْتُوحٌ ✕
الْغُرْفَةُ مَفْتُوحَةٌ ✓

مُحَمَّدٌ طَالِبٌ ( مُحَمَّدٌ : مُبْتَدَأٌ، طَالِبٌ : خَبَرٌ ) . تِلْكَ شَمْسٌ ( تِلْكَ : مُبْتَدَأٌ، شَمْسٌ : خَبَرٌ ) .$$,
      10,
      10,
      3
    );

  delete from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '6'
    and sort_order > 3;
end;
$migration$;

commit;
