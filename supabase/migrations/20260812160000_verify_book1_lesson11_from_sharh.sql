-- Verify Medina Book 1 lesson 11 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF page 16.

begin;

do $migration$
declare
  fi_rule_id bigint;
  speaker_yaa_rule_id bigint;
begin
  select id into strict fi_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '11'
    and sort_order = 1;

  select id into strict speaker_yaa_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '11'
    and sort_order = 2;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '11'
  );

  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '11'
  );

  delete from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '11'
    and id not in (fi_rule_id, speaker_yaa_rule_id);

  update public.rules
  set
    sort_order = 1,
    title = 'فِي مَعَ ضَمِيرِ الْغَائِبِ: فِيهِ وَفِيهَا (предлог فِي с местоимением отсутствующего)',
    rule_ar = 'فِي حَرْفُ جَرٍّ، وَتَتَّصِلُ بِضَمِيرِ الْغَائِبِ الْمُذَكَّرِ فَتَصِيرُ فِيهِ، وَبِضَمِيرِ الْغَائِبِ الْمُؤَنَّثِ فَتَصِيرُ فِيهَا.',
    summary = 'فِي حَرْفُ جَرٍّ، وَتَتَّصِلُ بِضَمِيرِ الْغَائِبِ الْمُذَكَّرِ فَتَصِيرُ فِيهِ، وَبِضَمِيرِ الْغَائِبِ الْمُؤَنَّثِ فَتَصِيرُ فِيهَا.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">فِي حَرْفُ جَرٍّ، وَتَتَّصِلُ بِضَمِيرِ الْغَائِبِ الْمُذَكَّرِ فَتَصِيرُ فِيهِ، وَبِضَمِيرِ الْغَائِبِ الْمُؤَنَّثِ فَتَصِيرُ فِيهَا.</span><p class="rule-study-text"><span dir="rtl" lang="ar">فِي</span> — предлог «в». С присоединённым местоимением отсутствующего мужского рода получается <span dir="rtl" lang="ar">فِيهِ</span> — «в нём», а женского рода — <span dir="rtl" lang="ar">فِيهَا</span> — «в ней».</p></div><div class="rule-study-card"><span class="rule-card-kicker">Две формы</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">فِيهِ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ الْمُذَكَّرِ</span> — местоимение отсутствующего мужского рода</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">فِيهَا</span><span class="rule-term-ru"><span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ الْمُؤَنَّثِ</span> — местоимение отсутствующего женского рода</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Мужской род</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">بَيْتِي فِيهِ حَدِيقَةٌ. فَصْلِي فِيهِ طُلَّابٌ.</span><span class="rule-example-ru">В моём доме есть сад. В моём классе есть учащиеся.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَاذَا فِي هَذَا الْبَيْتِ؟ فِيهِ أَثَاثٌ.</span><span class="rule-example-ru">Что в этом доме? В нём есть мебель.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ فِي الْمَكْتَبِ؟ مَا فِيهِ أَحَدٌ.</span><span class="rule-example-ru">Кто в кабинете? В нём никого нет.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Женский род</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">حَدِيقَتِي فِيهَا أَزْهَارٌ. غُرْفَتِي فِيهَا نَافِذَةٌ.</span><span class="rule-example-ru">В моём саду есть цветы. В моей комнате есть окно.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَاذَا فِي الْحَقِيبَةِ؟ فِيهَا كُتُبٌ.</span><span class="rule-example-ru">Что в сумке? В ней есть книги.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ فِي الْمَكْتَبَةِ؟ مَا فِيهَا أَحَدٌ.</span><span class="rule-example-ru">Кто в библиотеке? В ней никого нет.</span></div></div></div></div>$$
  where id = fi_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      fi_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$فِي + ضَمِيرُ الْغَائِبِ
فِي : حَرْفُ جَرٍّ .
ضَمِيرُ الْغَائِبِ الْمُذَكَّرِ : فِيهِ .
ضَمِيرُ الْغَائِبِ الْمُؤَنَّثِ : فِيهَا .$$,
      16,
      16,
      1
    ),
    (
      fi_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$بَيْتِي فِيهِ حَدِيقَةٌ . فَصْلِي فِيهِ طُلَّابٌ . مَاذَا فِي هَذَا الْبَيْتِ ؟ فِيهِ أَثَاثٌ .
مَنْ فِي الْمَكْتَبِ ؟ مَا فِيهِ أَحَدٌ .
حَدِيقَتِي فِيهَا أَزْهَارٌ . غُرْفَتِي فِيهَا نَافِذَةٌ . مَاذَا فِي الْحَقِيبَةِ ؟ فِيهَا كُتُبٌ .
مَنْ فِي الْمَكْتَبَةِ ؟ مَا فِيهَا أَحَدٌ .$$,
      16,
      16,
      2
    );

  update public.rules
  set
    sort_order = 2,
    title = 'يَاءُ الْمُتَكَلِّمِ (ياء говорящего: «мой/моя»)',
    rule_ar = 'يَاءُ الْمُتَكَلِّمِ ضَمِيرٌ لِلْمُتَكَلِّمِ.',
    summary = 'يَاءُ الْمُتَكَلِّمِ ضَمِيرٌ لِلْمُتَكَلِّمِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">يَاءُ الْمُتَكَلِّمِ ضَمِيرٌ لِلْمُتَكَلِّمِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">يَاءُ الْمُتَكَلِّمِ</span> — присоединённое местоимение говорящего. В приведённых автором именах оно передаёт значение «мой/моя».</p></div><div class="rule-study-card"><span class="rule-card-kicker">Формы из шарха</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">بَيْتِي · غُرْفَتِي · حَقِيبَتِي</span><span class="rule-term-ru">мой дом · моя комната · моя сумка</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">بَلَدِي · جَامِعَتِي</span><span class="rule-term-ru">моя страна · мой университет</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">أَبِي · أُمِّي</span><span class="rule-term-ru">мой отец · моя мать</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">أَخِي · أُخْتِي</span><span class="rule-term-ru">мой брат · моя сестра</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">بَيْتِي جَمِيلٌ. غُرْفَتِي كَبِيرَةٌ.</span><span class="rule-example-ru">Мой дом красивый. Моя комната большая.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أُحِبُّ بَلَدِي. جَامِعَتِي كَبِيرَةٌ.</span><span class="rule-example-ru">Я люблю свою страну. Мой университет большой.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أُحِبُّ أَبِي وَأُمِّي. أُحِبُّ أَخِي وَأُخْتِي.</span><span class="rule-example-ru">Я люблю своего отца и свою мать. Я люблю своего брата и свою сестру.</span></div></div></div></div>$$
  where id = speaker_yaa_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      speaker_yaa_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$يَاءُ الْمُتَكَلِّمِ
يَاءُ الْمُتَكَلِّمِ : ضَمِيرٌ لِلْمُتَكَلِّمِ .
بَيْتِي . غُرْفَتِي . حَقِيبَتِي . بَلَدِي . جَامِعَتِي . أَبِي . أُمِّي . أَخِي . أُخْتِي .$$,
      16,
      16,
      1
    ),
    (
      speaker_yaa_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$بَيْتِي جَمِيلٌ . غُرْفَتِي كَبِيرَةٌ . أُحِبُّ بَلَدِي . جَامِعَتِي كَبِيرَةٌ . أُحِبُّ أَبِي وَأُمِّي .
أُحِبُّ أَخِي وَأُخْتِي .$$,
      16,
      16,
      2
    );
end;
$migration$;

commit;
