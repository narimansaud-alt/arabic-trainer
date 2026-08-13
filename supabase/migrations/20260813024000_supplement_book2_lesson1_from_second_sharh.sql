-- Supplement Medina Book 2 lesson 1 from the second Arabic sharh.
-- Sources remain separate:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 2-7 (already stored)
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 3-6 (added here)

begin;

do $migration$
declare
  inna_rule_id bigint;
  hamza_rule_id bigint;
  dhu_rule_id bigint;
  am_rule_id bigint;
  number_rule_id bigint;
  manqus_rule_id bigint;
  lesson_rule_count integer;
  updated_content text;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '1';

  if lesson_rule_count <> 5 then
    raise exception 'Expected 5 Book 2 lesson 1 rules before the two-sharh supplement, found %', lesson_rule_count;
  end if;

  select id into strict inna_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '1' and sort_order = 1;

  select id into strict hamza_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '1' and sort_order = 2;

  select id into strict dhu_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '1' and sort_order = 3;

  select id into strict am_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '1' and sort_order = 4;

  select id into strict number_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '1' and sort_order = 5;

  -- The second sharh adds the complete attachment table for إِنَّ and لَعَلَّ.
  select content into strict updated_content from public.rules where id = inna_rule_id;
  if position('book2-second-sharh-pronouns' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 1 rule %', inna_rule_id;
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-pronouns"><span class="rule-card-kicker">إِنَّ и لَعَلَّ с местоимениями</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا دَخَلَتْ <span class="ar-tone-particle">إِنَّ</span> أَوْ <span class="ar-tone-particle">لَعَلَّ</span> عَلَى ضَمِيرٍ، اتَّصَلَ بِهَا ضَمِيرُ النَّصْبِ الْمُنَاسِبُ.</span><p class="rule-study-text">При соединении с личным местоимением употребляется соответствующая слитная форма. В таблице сохранены все десять местоимений из второго шарха.</p><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الضَّمِيرُ</span><span class="rule-table-ru">местоимение</span></th><th><span class="rule-table-ar ar-tone-particle">مَعَ إِنَّ</span><span class="rule-table-ru">форма с إِنَّ</span></th><th><span class="rule-table-ar ar-tone-particle">مَعَ لَعَلَّ</span><span class="rule-table-ru">форма с لَعَلَّ</span></th><th><span class="rule-table-ar">الْمَعْنَى</span><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-subject">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar ar-tone-particle">إِنِّي / إِنَّنِي</span><span class="rule-table-ru">поистине, я</span></td><td><span class="rule-table-ar ar-tone-particle">لَعَلِّي</span><span class="rule-table-ru">возможно, я</span></td><td><span class="rule-table-ru">я</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar ar-tone-particle">إِنَّنَا / إِنَّا</span><span class="rule-table-ru">поистине, мы</span></td><td><span class="rule-table-ar ar-tone-particle">لَعَلَّنَا</span><span class="rule-table-ru">возможно, мы</span></td><td><span class="rule-table-ru">мы</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar ar-tone-particle">إِنَّكَ</span><span class="rule-table-ru">поистине, ты</span></td><td><span class="rule-table-ar ar-tone-particle">لَعَلَّكَ</span><span class="rule-table-ru">возможно, ты</span></td><td><span class="rule-table-ru">мужской род</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-particle">إِنَّكِ</span><span class="rule-table-ru">поистине, ты</span></td><td><span class="rule-table-ar ar-tone-particle">لَعَلَّكِ</span><span class="rule-table-ru">возможно, ты</span></td><td><span class="rule-table-ru">женский род</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-particle">إِنَّكُمْ</span><span class="rule-table-ru">поистине, вы</span></td><td><span class="rule-table-ar ar-tone-particle">لَعَلَّكُمْ</span><span class="rule-table-ru">возможно, вы</span></td><td><span class="rule-table-ru">мужской род, множественное число</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar ar-tone-particle">إِنَّكُنَّ</span><span class="rule-table-ru">поистине, вы</span></td><td><span class="rule-table-ar ar-tone-particle">لَعَلَّكُنَّ</span><span class="rule-table-ru">возможно, вы</span></td><td><span class="rule-table-ru">женский род, множественное число</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar ar-tone-particle">إِنَّهُ</span><span class="rule-table-ru">поистине, он</span></td><td><span class="rule-table-ar ar-tone-particle">لَعَلَّهُ</span><span class="rule-table-ru">возможно, он</span></td><td><span class="rule-table-ru">он</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar ar-tone-particle">إِنَّهَا</span><span class="rule-table-ru">поистине, она</span></td><td><span class="rule-table-ar ar-tone-particle">لَعَلَّهَا</span><span class="rule-table-ru">возможно, она</span></td><td><span class="rule-table-ru">она</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُمْ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar ar-tone-particle">إِنَّهُمْ</span><span class="rule-table-ru">поистине, они</span></td><td><span class="rule-table-ar ar-tone-particle">لَعَلَّهُمْ</span><span class="rule-table-ru">возможно, они</span></td><td><span class="rule-table-ru">мужской род, множественное число</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُنَّ</span><span class="rule-table-ru">они, женщины</span></td><td><span class="rule-table-ar ar-tone-particle">إِنَّهُنَّ</span><span class="rule-table-ru">поистине, они</span></td><td><span class="rule-table-ar ar-tone-particle">لَعَلَّهُنَّ</span><span class="rule-table-ru">возможно, они</span></td><td><span class="rule-table-ru">женский род, множественное число</span></td></tr></tbody></table></div></div>
</div>$html$;
  end if;

  update public.rules
  set
    rule_ar = 'إِنَّ وَأَخَوَاتُهَا حُرُوفٌ تَدْخُلُ عَلَى الْجُمْلَةِ الِاسْمِيَّةِ فَقَطْ، فَتَنْصِبُ الْمُبْتَدَأَ وَتَرْفَعُ الْخَبَرَ، وَتَجْعَلُ الْمُبْتَدَأَ اسْمًا لَهَا وَالْخَبَرَ خَبَرًا لَهَا. وَهِيَ: إِنَّ، وَأَنَّ، وَلَكِنَّ، وَكَأَنَّ، وَلَعَلَّ، وَلَيْتَ. وَإِذَا دَخَلَتْ إِنَّ أَوْ لَعَلَّ عَلَى ضَمِيرٍ، اتَّصَلَ بِهَا ضَمِيرُ النَّصْبِ الْمُنَاسِبُ.',
    summary = 'إِنَّ وَأَخَوَاتُهَا حُرُوفٌ تَدْخُلُ عَلَى الْجُمْلَةِ الِاسْمِيَّةِ فَقَطْ، فَتَنْصِبُ الْمُبْتَدَأَ وَتَرْفَعُ الْخَبَرَ، وَتَجْعَلُ الْمُبْتَدَأَ اسْمًا لَهَا وَالْخَبَرَ خَبَرًا لَهَا. وَهِيَ: إِنَّ، وَأَنَّ، وَلَكِنَّ، وَكَأَنَّ، وَلَعَلَّ، وَلَيْتَ. وَإِذَا دَخَلَتْ إِنَّ أَوْ لَعَلَّ عَلَى ضَمِيرٍ، اتَّصَلَ بِهَا ضَمِيرُ النَّصْبِ الْمُنَاسِبُ.',
    content = updated_content
  where id = inna_rule_id;

  -- Keep the existing number card and make room for the source-only defective-noun rule.
  update public.rules set sort_order = 6 where id = number_rule_id;

  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values
    ('Мединский курс (Том 2)', '1',
     'الِاسْمُ الْمَنْقُوصُ وَغَالٍ (недостаточное имя и слово «дорогой»)',
     $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الِاسْمُ الْمَنْقُوصُ</span> اسْمٌ آخِرُهُ يَاءٌ مَكْسُورٌ مَا قَبْلَهَا، نَحْوُ: <span class="ar-tone-default">الْغَالِي</span> وَ<span class="ar-tone-default">الْقَاضِي</span>.</span><p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">الِاسْمُ الْمَنْقُوصُ</span> — имя с конечной <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">يَاءٌ</span>, перед которой стоит касра. Примеры: «дорогой» и «судья».</p></div><div class="rule-study-card"><span class="rule-card-kicker">Формы без ال</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-default">الْغَالِي</span> ← <span class="ar-tone-structure">غَالٍ</span></span><span class="rule-example-ru">«дорогой» → неопределённая форма, приведённая в шархе</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-default">الْقَاضِي</span> ← <span class="ar-tone-structure">قَاضٍ</span></span><span class="rule-example-ru">«судья» → неопределённая форма, приведённая в шархе</span></div></div><p class="rule-study-text">В этих примерах после удаления <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">ال</span> конечная <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">يَاءٌ</span> опускается. Танвин называется <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">تَنْوِينُ عِوَضٍ</span>: он возмещает удалённую йа.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Значение и формы слова غَالٍ</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">غَالٍ</span><span class="rule-term-ru">дорогой; буквально: «его цена высока»</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">غَالِيَةٌ</span><span class="rule-term-ru">дорогая — форма женского рода</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">رَخِيصٌ</span><span class="rule-term-ru">дешёвый — противоположное значение</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا الْقَلَمُ <span class="ar-tone-default">غَالٍ</span>.</span><span class="rule-example-ru">Эта ручка дорогая.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذِهِ السَّاعَةُ <span class="ar-tone-default">غَالِيَةٌ</span>.</span><span class="rule-example-ru">Эти часы дорогие.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا الْكِتَابُ <span class="ar-tone-default">رَخِيصٌ</span>، وَذَاكَ <span class="ar-tone-default">غَالٍ</span>.</span><span class="rule-example-ru">Эта книга дешёвая, а та — дорогая.</span></div></div></div><div class="rule-check-card"><b>Окончание из шарха:</b> <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">قَاضٍ</span> и <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">غَالٍ</span> пишутся без конечной йа в показанных формах, с танвином касры.</div></div>$html$,
     5,
     'rule',
     'الِاسْمُ الْمَنْقُوصُ اسْمٌ آخِرُهُ يَاءٌ مَكْسُورٌ مَا قَبْلَهَا، نَحْوُ: الْغَالِي وَالْقَاضِي. وَفِي الْمِثَالَيْنِ «غَالٍ» وَ«قَاضٍ» حُذِفَتِ الْيَاءُ بَعْدَ حَذْفِ «ال»، وَالتَّنْوِينُ تَنْوِينُ عِوَضٍ عَنِ الْيَاءِ الْمَحْذُوفَةِ. وَ«غَالٍ» مُؤَنَّثُهُ «غَالِيَةٌ»، وَعَكْسُهُ «رَخِيصٌ».',
     'الِاسْمُ الْمَنْقُوصُ اسْمٌ آخِرُهُ يَاءٌ مَكْسُورٌ مَا قَبْلَهَا، نَحْوُ: الْغَالِي وَالْقَاضِي. وَفِي الْمِثَالَيْنِ «غَالٍ» وَ«قَاضٍ» حُذِفَتِ الْيَاءُ بَعْدَ حَذْفِ «ال»، وَالتَّنْوِينُ تَنْوِينُ عِوَضٍ عَنِ الْيَاءِ الْمَحْذُوفَةِ. وَ«غَالٍ» مُؤَنَّثُهُ «غَالِيَةٌ»، وَعَكْسُهُ «رَخِيصٌ».')
  returning id into manqus_rule_id;

  -- Rebuild only the provenance rows belonging to the second sharh.
  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '1'
  )
    and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf';

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (inna_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$إِنَّ، وَلَعَلَّ

إِنَّ: حَرْفُ نَصْبٍ، يَنْصِبُ الِاسْمَ، وَيَرْفَعُ الْخَبَرَ.
لَعَلَّ: حَرْفُ نَصْبٍ، يَنْصِبُ الِاسْمَ، وَيَرْفَعُ الْخَبَرَ.

دُخُولُ إِنَّ عَلَى الضَّمَائِرِ:
أَوَّلًا: ضَمَائِرُ الْمُتَكَلِّمِ:
إِنَّ + أَنَا = إِنِّي، وَيَجُوزُ: إِنَّنِي.
إِنَّ + نَحْنُ = إِنَّنَا، وَيَجُوزُ: إِنَّا.
ثَانِيًا: ضَمَائِرُ الْمُخَاطَبِ:
إِنَّ + أَنْتَ = إِنَّكَ
إِنَّ + أَنْتِ = إِنَّكِ
إِنَّ + أَنْتُمْ = إِنَّكُمْ
إِنَّ + أَنْتُنَّ = إِنَّكُنَّ
ثَالِثًا: ضَمَائِرُ الْغَائِبِ:
إِنَّ + هُوَ = إِنَّهُ
إِنَّ + هِيَ = إِنَّهَا
إِنَّ + هُمْ = إِنَّهُمْ
إِنَّ + هُنَّ = إِنَّهُنَّ

دُخُولُ لَعَلَّ عَلَى الضَّمَائِرِ:
أَوَّلًا: ضَمَائِرُ الْمُتَكَلِّمِ:
لَعَلَّ + أَنَا = لَعَلِّي
لَعَلَّ + نَحْنُ = لَعَلَّنَا
ثَانِيًا: ضَمَائِرُ الْمُخَاطَبِ:
لَعَلَّ + أَنْتَ = لَعَلَّكَ
لَعَلَّ + أَنْتِ = لَعَلَّكِ
لَعَلَّ + أَنْتُمْ = لَعَلَّكُمْ
لَعَلَّ + أَنْتُنَّ = لَعَلَّكُنَّ
ثَالِثًا: ضَمَائِرُ الْغَائِبِ:
لَعَلَّ + هُوَ = لَعَلَّهُ
لَعَلَّ + هِيَ = لَعَلَّهَا
لَعَلَّ + هُمْ = لَعَلَّهُمْ
لَعَلَّ + هُنَّ = لَعَلَّهُنَّ$source$, 3, 3, 6),

    (inna_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$اسْمُ إِنَّ: مَنْصُوبٌ وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ، وَخَبَرُهَا مَرْفُوعٌ وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ، وَكَذَلِكَ لَعَلَّ، كَمَا فِي الْأَمْثِلَةِ السَّابِقَةِ.
تُفِيدُ إِنَّ: التَّوْكِيدَ، وَتُفِيدُ لَعَلَّ: التَّرَجِّيَ، بِمَعْنَى: أَرْجُو.$source$, 4, 4, 7),

    (am_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$أَمْ: حَرْفُ عَطْفٍ يَأْتِي مَعَ هَمْزَةِ التَّعْيِينِ.
مَا بَعْدَ الْهَمْزَةِ تَذْكُرُ الشَّيْءَ الَّذِي تَسْأَلُ عَنْهُ؛ تَقُولُ: أَمُجْتَهِدٌ أَنْتَ أَمْ كَسْلَانُ؟ وَلَيْسَ: أَأَنْتَ مُجْتَهِدٌ أَمْ كَسْلَانُ؟ لِأَنَّكَ تَسْأَلُ عَنْ اجْتِهَادِهِ وَكَسَلِهِ. قَالَ تَعَالَى: ﴿أَرَاغِبٌ أَنْتَ عَنْ آلِهَتِي يَا إِبْرَاهِيمُ﴾.

الِاسْتِفْهَامُ بِالْهَمْزَةِ
أَمِنَ الْهِنْدِ أَنْتَ أَمْ مِنْ بَاكِسْتَانَ؟
فِي هَذَا الْمِثَالِ هَمْزَةُ الِاسْتِفْهَامِ لِطَلَبِ التَّعْيِينِ (أَيْ: تَعْيِينُ جَوَابٍ مُحَدَّدٍ، وَلَيْسَ جَوَابُهَا نَعَمْ، أَوْ لَا) تَقُولُ فِي الْجَوَابِ: أَنَا مِنَ الْهِنْدِ.$source$, 4, 5, 2),

    (dhu_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$ذُو: اسْمٌ مِنَ الْأَسْمَاءِ الْخَمْسَةِ، مَرْفُوعٌ بِالْوَاوِ، الِاسْمُ الَّذِي بَعْدَهُ يُعْرَبُ مُضَافًا إِلَيْهِ دَائِمًا.
ذُو: اسْمٌ مُذَكَّرٌ، مُؤَنَّثُهُ: ذَاتُ، وَجَمْعُهُ الْمُذَكَّرُ: ذَوُو، وَجَمْعُ الْمُؤَنَّثِ: ذَوَاتُ.

هَذَا الرَّجُلُ ذُو خُلُقٍ. هَذِهِ الْمَرْأَةُ ذَاتُ خُلُقٍ. هَؤُلَاءِ الرِّجَالُ ذَوُو خُلُقٍ. هَؤُلَاءِ النِّسَاءُ ذَوَاتُ خُلُقٍ.

الْأَسْمَاءُ الْخَمْسَةُ، هِيَ: أَبٌ، أَخٌ، حَمٌ، فُو، ذُو. تُرْفَعُ بِالْوَاوِ، وَالِاسْمُ الَّذِي بَعْدَهَا مُضَافٌ إِلَيْهِ.$source$, 5, 5, 3),

    (manqus_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الِاسْمُ الْمَنْقُوصُ: اسْمٌ آخِرُهُ يَاءٌ مَكْسُورٌ مَا قَبْلَهَا، نَحْوُ: الْغَالِي، الْقَاضِي.
تُحْذَفُ يَاؤُهَا إِذَا حُذِفَتْ (ال) تَقُولُ: غَالٍ، قَاضٍ. وَهَذَا التَّنْوِينُ يُسَمَّى تَنْوِينَ عِوَضٍ (أَيْ: بَدَلٌ وَعِوَضٌ عَنِ الْيَاءِ الْمَحْذُوفَةِ).$source$, 5, 5, 1),

    (manqus_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$غَالٍ: اسْمٌ مَنْقُوصٌ حُذِفَتْ يَاؤُهُ (أَصْلُهُ: غَالِي)، مُؤَنَّثُهُ: غَالِيَةٌ.
(مَعْنَاهُ: ثَمَنُهُ كَثِيرٌ، وَعَكْسُهُ رَخِيصٌ).
هَذَا الْقَلَمُ غَالٍ. هَذِهِ السَّاعَةُ غَالِيَةٌ. الْكُتُبُ غَالِيَةٌ فِي بَلَدِنَا.
هَذَا الْكِتَابُ رَخِيصٌ وَذَاكَ غَالٍ.$source$, 6, 6, 2),

    (number_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$١٠٠ وَ١٠٠٠

الْعَدَدَانِ مِائَةٌ، وَأَلْفٌ: الِاسْمُ الَّذِي بَعْدَهُمَا مُفْرَدٌ مَجْرُورٌ بِالْإِضَافَةِ. لَا يَخْتَلِفُ لَفْظُهُ مَعَ الْمُذَكَّرِ وَالْمُؤَنَّثِ.
١٠٠: مِائَةُ رَجُلٍ، وَمِائَةُ امْرَأَةٍ.
١٠٠٠: أَلْفُ رَجُلٍ، وَأَلْفُ امْرَأَةٍ.

هَذَا التِّلْفَازُ بِأَلْفِ رِيَالٍ. قَرَأْتُ أَلْفَ صَفْحَةٍ. وَصَلَ إِلَى مَكَّةَ مِائَةُ حَاجٍّ وَحَاجَّةٍ.$source$, 6, 6, 2);

  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '1';

  if lesson_rule_count <> 6 then
    raise exception 'Expected 6 Book 2 lesson 1 rules after the two-sharh supplement, found %', lesson_rule_count;
  end if;

  if exists (
    select 1
    from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '1'
      and coalesce(rule_ar, '') = ''
  ) then
    raise exception 'Book 2 lesson 1 contains an empty rule_ar after the two-sharh supplement';
  end if;

  if exists (
    select 1
    from public.rules r
    where r.course_name = 'Мединский курс (Том 2)'
      and r.lesson_number = '1'
      and not exists (select 1 from public.rule_sources s where s.rule_id = r.id)
  ) then
    raise exception 'Book 2 lesson 1 contains a rule without provenance after the two-sharh supplement';
  end if;
end;
$migration$;

commit;
