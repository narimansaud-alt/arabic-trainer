-- Verify Medina Book 1 lesson 2 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF page 5.

begin;

do $migration$
declare
  target_rule_id bigint;
begin
  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '2'
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '2'
    and sort_order = 1;

  update public.rules
  set
    title = 'ذٰلِكَ (то/тот: указательное имя для далёкого единственного мужского рода)',
    rule_ar = 'ذٰلِكَ اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْبَعِيدِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    summary = 'ذٰلِكَ اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْبَعِيدِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">ذٰلِكَ اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْبَعِيدِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">ذٰلِكَ</span> — указательное имя «то / тот». Оно указывает на один далёкий предмет или на одно далёкое лицо мужского рода.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Близко и далеко</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">هٰذَا</span><span class="rule-term-ru">это / этот — близко</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">ذٰلِكَ</span><span class="rule-term-ru">то / тот — далеко</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">ذٰلِكَ رَجُلٌ. ذٰلِكَ مُدَرِّسٌ. ذٰلِكَ طَالِبٌ.</span><span class="rule-example-ru">То — мужчина. То — преподаватель. То — студент.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">ذٰلِكَ نَجْمٌ. ذٰلِكَ بَيْتٌ. ذٰلِكَ حِصَانٌ.</span><span class="rule-example-ru">То — звезда. То — дом. То — лошадь.</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$ذَلِكَ : اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُذَكَّرِ الْبَعِيدِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ .$$,
      5,
      5,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْعَاقِلُ
ذَلِكَ رَجُلٌ
ذَلِكَ مُدَرِّسٌ
ذَلِكَ طَالِبٌ

غَيْرُ الْعَاقِلِ
ذَلِكَ نَجْمٌ
ذَلِكَ بَيْتٌ
ذَلِكَ حِصَانٌ$$,
      5,
      5,
      2
    );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '2'
    and sort_order = 2;

  update public.rules
  set
    title = 'مَنْ هٰذَا؟ وَمَنْ ذٰلِكَ؟ (вопрос «кто?» о близком и далёком)',
    rule_ar = 'مَنْ هٰذَا؟ سُؤَالٌ عَنِ الْقَرِيبِ الْعَاقِلِ، وَمَنْ ذٰلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ الْعَاقِلِ.',
    summary = 'مَنْ هٰذَا؟ سُؤَالٌ عَنِ الْقَرِيبِ الْعَاقِلِ، وَمَنْ ذٰلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ الْعَاقِلِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">مَنْ هٰذَا؟ سُؤَالٌ عَنِ الْقَرِيبِ الْعَاقِلِ، وَمَنْ ذٰلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">مَنْ هٰذَا؟</span> — «Кто это?» о близком разумном. <span dir="rtl" lang="ar">مَنْ ذٰلِكَ؟</span> — «Кто это там?» о далёком разумном.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Сравнение</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هٰذَا؟ هٰذَا مُدِيرٌ.</span><span class="rule-example-ru">Кто это? Это директор.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هٰذَا؟ هٰذَا إِمَامٌ.</span><span class="rule-example-ru">Кто это? Это имам.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ ذٰلِكَ؟ ذٰلِكَ مُدَرِّسٌ.</span><span class="rule-example-ru">Кто это там? То — преподаватель.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ ذٰلِكَ؟ ذٰلِكَ طَالِبٌ.</span><span class="rule-example-ru">Кто это там? То — студент.</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Sharkh_na_1_tom_Med_kursa.pdf',
    $$مَنْ هَذَا؟ سُؤَالٌ عَنِ الْقَرِيبِ الْعَاقِلِ .
مَنْ ذَلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ الْعَاقِلِ .

مَنْ هَذَا؟ هَذَا مُدِيرٌ .
مَنْ هَذَا؟ هَذَا إِمَامٌ .
مَنْ ذَلِكَ؟ ذَلِكَ مُدَرِّسٌ .
مَنْ ذَلِكَ؟ ذَلِكَ طَالِبٌ .$$,
    5,
    5,
    1
  );

  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values
    (
      'Мединский курс (Том 1)',
      '2',
      'مَا هٰذَا؟ وَمَا ذٰلِكَ؟ (вопрос «что?» о близком и далёком)',
      $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">مَا هٰذَا؟ سُؤَالٌ عَنِ الْقَرِيبِ غَيْرِ الْعَاقِلِ، وَمَا ذٰلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ غَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">مَا هٰذَا؟</span> — «Что это?» о близком неразумном. <span dir="rtl" lang="ar">مَا ذٰلِكَ؟</span> — «Что это там?» о далёком неразумном.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Сравнение</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">مَا هٰذَا؟ هٰذَا حَجَرٌ.</span><span class="rule-example-ru">Что это? Это камень.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">مَا هٰذَا؟ هٰذَا حِمَارٌ.</span><span class="rule-example-ru">Что это? Это осёл.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">مَا ذٰلِكَ؟ ذٰلِكَ لَبَنٌ.</span><span class="rule-example-ru">Что это там? То — молоко.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">مَا ذٰلِكَ؟ ذٰلِكَ قِطٌّ.</span><span class="rule-example-ru">Что это там? То — кот.</span></div></div></div></div>$$,
      3,
      'rule',
      'مَا هٰذَا؟ سُؤَالٌ عَنِ الْقَرِيبِ غَيْرِ الْعَاقِلِ، وَمَا ذٰلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ غَيْرِ الْعَاقِلِ.',
      'مَا هٰذَا؟ سُؤَالٌ عَنِ الْقَرِيبِ غَيْرِ الْعَاقِلِ، وَمَا ذٰلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ غَيْرِ الْعَاقِلِ.'
    )
  returning id into target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Sharkh_na_1_tom_Med_kursa.pdf',
    $$مَا هَذَا؟ سُؤَالٌ عَنِ الْقَرِيبِ غَيْرِ الْعَاقِلِ .
مَا ذَلِكَ؟ سُؤَالٌ عَنِ الْبَعِيدِ غَيْرِ الْعَاقِلِ .

مَا هَذَا؟ هَذَا حَجَرٌ .
مَا هَذَا؟ هَذَا حِمَارٌ .
مَا ذَلِكَ؟ ذَلِكَ لَبَنٌ .
مَا ذَلِكَ؟ ذَلِكَ قِطٌّ .$$,
    5,
    5,
    1
  );
end;
$migration$;

commit;
