-- Verify Medina Book 1 lesson 1 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 3-4.

begin;

do $migration$
declare
  target_rule_id bigint;
begin
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '1'
    and sort_order = 1;

  update public.rules
  set
    title = 'هٰذَا (это/этот: указательное имя для близкого единственного мужского рода)',
    rule_ar = 'هٰذَا اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْقَرِيبِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    summary = 'هٰذَا اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْقَرِيبِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">هٰذَا اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْقَرِيبِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">هٰذَا</span> — указательное имя «это / этот». Оно указывает на один близкий предмет или на одно близкое лицо мужского рода.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Термины</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">هٰذَا</span><span class="rule-term-ru">это / этот</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">اِسْمُ إِشَارَةٍ</span><span class="rule-term-ru">указательное имя</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">الْعَاقِلُ</span><span class="rule-term-ru">разумный</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">غَيْرُ الْعَاقِلِ</span><span class="rule-term-ru">неразумный</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا رَجُلٌ. هٰذَا وَلَدٌ. هٰذَا شَيْخٌ.</span><span class="rule-example-ru">Это мужчина. Это мальчик. Это шейх.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا كِتَابٌ. هٰذَا بَابٌ. هٰذَا قَلَمٌ.</span><span class="rule-example-ru">Это книга. Это дверь. Это ручка.</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$هَذَا : اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْقَرِيبِ، الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ .$$,
      3,
      3,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْعَاقِلُ
هَذَا رَجُلٌ
هَذَا وَلَدٌ
هَذَا شَيْخٌ

غَيْرُ الْعَاقِلِ
هَذَا كِتَابٌ
هَذَا بَابٌ
هَذَا قَلَمٌ$$,
      3,
      3,
      2
    );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '1'
    and sort_order = 2;

  update public.rules
  set
    title = 'مَا هٰذَا؟ (что это? — вопрос о неразумном)',
    rule_ar = 'مَا اِسْمُ اسْتِفْهَامٍ يُسْأَلُ بِهِ عَنْ غَيْرِ الْعَاقِلِ.',
    summary = 'مَا اِسْمُ اسْتِفْهَامٍ يُسْأَلُ بِهِ عَنْ غَيْرِ الْعَاقِلِ.',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">مَا اِسْمُ اسْتِفْهَامٍ يُسْأَلُ بِهِ عَنْ غَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">مَا</span> — вопросительное имя «что?». В этом уроке оно используется для вопроса о неразумном.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Вопрос и ответ</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَا هٰذَا؟ هٰذَا كِتَابٌ.</span><span class="rule-example-ru">Что это? Это книга.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَا هٰذَا؟ هٰذَا بَابٌ.</span><span class="rule-example-ru">Что это? Это дверь.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَا هٰذَا؟ هٰذَا قَلَمٌ.</span><span class="rule-example-ru">Что это? Это ручка.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Различие</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">مَا</span><span class="rule-term-ru">что? — о неразумном</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">مَنْ</span><span class="rule-term-ru">кто? — о разумном</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$مَا : اِسْمُ اِسْتِفْهَامٍ لِغَيْرِ الْعَاقِلِ .$$,
      3,
      3,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$مَا هَذَا؟ هَذَا كِتَابٌ ✓
مَا هَذَا؟ هَذَا بَابٌ ✓
مَا هَذَا؟ هَذَا قَلَمٌ ✓
مَا هَذَا؟ هَذَا رَجُلٌ ✕
مَا هَذَا؟ هَذَا وَلَدٌ ✕$$,
      3,
      3,
      2
    );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '1'
    and sort_order = 3;

  update public.rules
  set
    title = 'هَمْزَةُ الِاسْتِفْهَامِ: أَ، نَعَمْ، لَا (общий вопрос и ответы «да/нет»)',
    rule_ar = 'هَمْزَةُ الِاسْتِفْهَامِ حَرْفٌ جَوَابُهُ نَعَمْ أَوْ لَا.',
    summary = 'هَمْزَةُ الِاسْتِفْهَامِ حَرْفٌ جَوَابُهُ نَعَمْ أَوْ لَا.',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">هَمْزَةُ الِاسْتِفْهَامِ حَرْفٌ جَوَابُهُ نَعَمْ أَوْ لَا.</span><p class="rule-study-text"><span dir="rtl" lang="ar">أَ</span> ставится в начале высказывания и образует общий вопрос. Ответ: <span dir="rtl" lang="ar">نَعَمْ</span> «да» или <span dir="rtl" lang="ar">لَا</span> «нет».</p></div><div class="rule-study-card"><span class="rule-card-kicker">Схема</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">أَ</span><span class="rule-term-ru">вопросительная хамза</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">نَعَمْ</span><span class="rule-term-ru">да</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">لَا</span><span class="rule-term-ru">нет</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهٰذَا سَرِيرٌ؟ نَعَمْ. هٰذَا سَرِيرٌ.</span><span class="rule-example-ru">Это кровать? Да. Это кровать.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهٰذَا كُرْسِيٌّ؟ لَا. هٰذَا سَرِيرٌ.</span><span class="rule-example-ru">Это стул? Нет. Это кровать.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهٰذَا طَبِيبٌ؟ نَعَمْ. هٰذَا طَبِيبٌ.</span><span class="rule-example-ru">Это врач? Да. Это врач.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَهٰذَا طَالِبٌ؟ لَا. هٰذَا طَبِيبٌ.</span><span class="rule-example-ru">Это студент? Нет. Это врач.</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$أَ : هَمْزَةُ الِاسْتِفْهَامِ، حَرْفٌ جَوَابُهُ ( نَعَمْ ) أَوْ ( لَا ) .

أَهَذَا سَرِيرٌ؟ نَعَمْ. هَذَا سَرِيرٌ.
أَهَذَا رَجُلٌ؟ نَعَمْ. هَذَا رَجُلٌ.
أَهَذَا كُرْسِيٌّ؟ لَا. هَذَا سَرِيرٌ.
أَهَذَا وَلَدٌ؟ لَا. هَذَا رَجُلٌ.$$,
      3,
      3,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$أَهَذَا طَبِيبٌ؟ نَعَمْ. هَذَا طَبِيبٌ.
أَهَذَا طَالِبٌ؟ لَا. هَذَا طَبِيبٌ.
أَهَذَا كَلْبٌ؟ نَعَمْ. هَذَا كَلْبٌ.
أَهَذَا قِطٌّ؟ لَا. هَذَا كَلْبٌ.$$,
      4,
      4,
      2
    );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '1'
    and sort_order = 4;

  update public.rules
  set
    title = 'مَنْ هٰذَا؟ (кто это? — вопрос о разумном)',
    rule_ar = 'مَنْ اِسْمُ اسْتِفْهَامٍ يُسْأَلُ بِهِ عَنِ الْعَاقِلِ.',
    summary = 'مَنْ اِسْمُ اسْتِفْهَامٍ يُسْأَلُ بِهِ عَنِ الْعَاقِلِ.',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">مَنْ اِسْمُ اسْتِفْهَامٍ يُسْأَلُ بِهِ عَنِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">مَنْ</span> — вопросительное имя «кто?». Оно используется для вопроса о разумном.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Вопрос и ответ</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هٰذَا؟ هٰذَا طَبِيبٌ.</span><span class="rule-example-ru">Кто это? Это врач.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هٰذَا؟ هٰذَا وَلَدٌ.</span><span class="rule-example-ru">Кто это? Это мальчик.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هٰذَا؟ هٰذَا طَالِبٌ.</span><span class="rule-example-ru">Кто это? Это студент.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Различие</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">مَنْ</span><span class="rule-term-ru">кто? — о разумном</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">مَا</span><span class="rule-term-ru">что? — о неразумном</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$مَنْ : اِسْمُ اِسْتِفْهَامٍ لِلْعَاقِلِ .

مَنْ هَذَا؟ هَذَا طَبِيبٌ ✓
مَنْ هَذَا؟ هَذَا وَلَدٌ ✓
مَنْ هَذَا؟ هَذَا طَالِبٌ ✓
مَنْ هَذَا؟ هَذَا كِتَابٌ ✕
مَنْ هَذَا؟ هَذَا قَلَمٌ ✕$$,
      4,
      4,
      1
    );
end;
$migration$;

commit;
