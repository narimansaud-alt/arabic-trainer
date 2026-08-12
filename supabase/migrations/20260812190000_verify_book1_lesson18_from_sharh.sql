-- Verify Medina Book 1 lesson 18 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 30-31.

begin;

do $migration$
declare
  dual_rule_id bigint;
  demonstrative_rule_id bigint;
  kam_rule_id bigint;
begin
  select id into strict dual_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '18' and sort_order = 1;
  select id into strict kam_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '18' and sort_order = 2;

  delete from public.rule_sections where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '18'
  );
  delete from public.rule_sources where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '18'
  );
  update public.rules set sort_order = sort_order + 100
  where id in (dual_rule_id, kam_rule_id);

  update public.rules
  set sort_order = 1,
      title = 'الْمُثَنَّى (двойственное число)',
      rule_ar = 'الْمُثَنَّى مَا دَلَّ عَلَى اثْنَيْنِ أَوِ اثْنَتَيْنِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
      summary = 'الْمُثَنَّى مَا دَلَّ عَلَى اثْنَيْنِ أَوِ اثْنَتَيْنِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Определение автора</span><span class="rule-main-ar" dir="rtl" lang="ar">الْمُثَنَّى: مَا دَلَّ عَلَى اثْنَيْنِ أَوِ اثْنَتَيْنِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">الْمُثَنَّى</span> — форма, обозначающая двух лиц или два предмета; она употребляется с разумными и неразумными.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Разумные</span><table><thead><tr><th>Единственное число</th><th>Двойственное число</th><th>Русский смысл</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">رَجُلٌ</span></td><td><span dir="rtl" lang="ar">رَجُلَانِ</span></td><td>мужчина → двое мужчин</td></tr><tr><td><span dir="rtl" lang="ar">اِمْرَأَةٌ</span></td><td><span dir="rtl" lang="ar">اِمْرَأَتَانِ</span></td><td>женщина → две женщины</td></tr><tr><td><span dir="rtl" lang="ar">وَلَدٌ</span></td><td><span dir="rtl" lang="ar">وَلَدَانِ</span></td><td>мальчик / сын → два мальчика / сына</td></tr><tr><td><span dir="rtl" lang="ar">بِنْتٌ</span></td><td><span dir="rtl" lang="ar">بِنْتَانِ</span></td><td>девочка / дочь → две девочки / дочери</td></tr><tr><td><span dir="rtl" lang="ar">أَخٌ</span></td><td><span dir="rtl" lang="ar">أَخَوَانِ</span></td><td>брат → два брата</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Неразумные</span><table><thead><tr><th>Единственное число</th><th>Двойственное число</th><th>Русский смысл</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">قَلَمٌ</span></td><td><span dir="rtl" lang="ar">قَلَمَانِ</span></td><td>ручка → две ручки</td></tr><tr><td><span dir="rtl" lang="ar">سَاعَةٌ</span></td><td><span dir="rtl" lang="ar">سَاعَتَانِ</span></td><td>часы → двое часов</td></tr><tr><td><span dir="rtl" lang="ar">رِيَالٌ</span></td><td><span dir="rtl" lang="ar">رِيَالَانِ</span></td><td>риал → два риала</td></tr><tr><td><span dir="rtl" lang="ar">غُرْفَةٌ</span></td><td><span dir="rtl" lang="ar">غُرْفَتَانِ</span></td><td>комната → две комнаты</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">خَالِدٌ لَهُ ابْنَانِ وَبِنْتَانِ.</span><span class="rule-example-ru">У Халида два сына и две дочери.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">فَاطِمَةُ لَهَا طِفْلَانِ صَغِيرَانِ.</span><span class="rule-example-ru">У Фатимы двое маленьких детей.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">لِي عَيْنَانِ وَأُذُنَانِ وَيَدَانِ وَرِجْلَانِ.</span><span class="rule-example-ru">У меня два глаза, два уха, две руки и две ноги.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">صَلَاةُ الْفَجْرِ رَكْعَتَانِ.</span><span class="rule-example-ru">Утренний намаз состоит из двух рак‘атов.</span></div></div></div></div>$$
  where id = dual_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (dual_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْمُثَنَّى
الْمُثَنَّى : مَا دَلَّ عَلَى اثْنَيْنِ، أَوِ اثْنَتَيْنِ لِلْعَاقِلِ، وَغَيْرِ الْعَاقِلِ .$$, 30, 30, 1),
    (dual_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْعَاقِلُ : رَجُلٌ : رَجُلَانِ . اِمْرَأَةٌ : اِمْرَأَتَانِ . وَلَدٌ : وَلَدَانِ . بِنْتٌ : بِنْتَانِ . أَخٌ : أَخَوَانِ .
غَيْرُ الْعَاقِلِ : قَلَمٌ : قَلَمَانِ . سَاعَةٌ : سَاعَتَانِ . رِيَالٌ : رِيَالَانِ . غُرْفَةٌ : غُرْفَتَانِ .$$, 30, 30, 2),
    (dual_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَمْثِلَةٌ لِلْمُثَنَّى : خَالِدٌ لَهُ ابْنَانِ وَبِنْتَانِ . فَاطِمَةُ لَهَا طِفْلَانِ صَغِيرَانِ .
لِي عَيْنَانِ وَأُذُنَانِ وَيَدَانِ وَرِجْلَانِ . صَلَاةُ الْفَجْرِ رَكْعَتَانِ .$$, 30, 30, 3);

  insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values (
    'Мединский курс (Том 1)', '18',
    'هَذَانِ وَهَاتَانِ (эти двое / эти две)',
    $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَانِ</span><span class="rule-example-ru">Указательное имя для близкого двойственного числа мужского рода — разумного и неразумного.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَاتَانِ</span><span class="rule-example-ru">Указательное имя для близкого двойственного числа женского рода — разумного и неразумного.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">هَذَانِ — мужской род</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَانِ طَالِبَانِ. هَذَانِ تَاجِرَانِ. هَذَانِ صَدِيقَانِ.</span><span class="rule-example-ru">Это два студента. Это два торговца. Это два друга.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَانِ قَلَمَانِ. هَذَانِ مِفْتَاحَانِ. هَذَانِ كَلْبَانِ.</span><span class="rule-example-ru">Это две ручки. Это два ключа. Это две собаки.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">هَاتَانِ — женский род</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَاتَانِ طَالِبَتَانِ. هَاتَانِ تَاجِرَتَانِ. هَاتَانِ صَدِيقَتَانِ.</span><span class="rule-example-ru">Это две студентки. Это две торговки. Это две подруги.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَاتَانِ مِسْطَرَتَانِ. هَاتَانِ لُغَتَانِ. هَاتَانِ كَلْبَتَانِ.</span><span class="rule-example-ru">Это две линейки. Это два языка. Это две собаки женского пола.</span></div></div></div></div>$$,
    2, 'table',
    'هَذَانِ اِسْمُ إِشَارَةٍ لِلْمُثَنَّى الْقَرِيبِ الْمُذَكَّرِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ، وَهَاتَانِ اِسْمُ إِشَارَةٍ لِلْمُثَنَّى الْقَرِيبِ الْمُؤَنَّثِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    'هَذَانِ اِسْمُ إِشَارَةٍ لِلْمُثَنَّى الْقَرِيبِ الْمُذَكَّرِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ، وَهَاتَانِ اِسْمُ إِشَارَةٍ لِلْمُثَنَّى الْقَرِيبِ الْمُؤَنَّثِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ.'
  ) returning id into demonstrative_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (demonstrative_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هَذَانِ، وَهَاتَانِ
هَذَانِ : اِسْمُ إِشَارَةٍ لِلْمُثَنَّى الْقَرِيبِ الْمُذَكَّرِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ .
هَاتَانِ : اِسْمُ إِشَارَةٍ لِلْمُثَنَّى الْقَرِيبِ الْمُؤَنَّثِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ .$$, 30, 30, 1),
    (demonstrative_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هَذَانِ طَالِبَانِ . هَذَانِ قَلَمَانِ . هَذَانِ تَاجِرَانِ . هَذَانِ مِفْتَاحَانِ . هَذَانِ صَدِيقَانِ . هَذَانِ كَلْبَانِ .
هَاتَانِ طَالِبَتَانِ . هَاتَانِ مِسْطَرَتَانِ . هَاتَانِ تَاجِرَتَانِ . هَاتَانِ لُغَتَانِ . هَاتَانِ صَدِيقَتَانِ . هَاتَانِ كَلْبَتَانِ .$$, 30, 30, 2);

  update public.rules
  set sort_order = 3,
      title = 'كَمْ وَتَمْيِيزُهَا (вопрос «сколько?» и его тамйиз)',
      rule_ar = 'كَمْ اِسْمُ اسْتِفْهَامٍ يَدُلُّ عَلَى الْعَدَدِ، وَالِاسْمُ الَّذِي بَعْدَهُ مَنْصُوبٌ يُسَمَّى تَمْيِيزًا.',
      summary = 'كَمْ اِسْمُ اسْتِفْهَامٍ يَدُلُّ عَلَى الْعَدَدِ، وَالِاسْمُ الَّذِي بَعْدَهُ مَنْصُوبٌ يُسَمَّى تَمْيِيزًا.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Определение автора</span><span class="rule-main-ar" dir="rtl" lang="ar">كَمْ اِسْمُ اسْتِفْهَامٍ يَدُلُّ عَلَى الْعَدَدِ، وَالِاسْمُ الَّذِي بَعْدَهُ مَنْصُوبٌ يُسَمَّى تَمْيِيزًا.</span><p class="rule-study-text"><span dir="rtl" lang="ar">كَمْ</span> — вопросительное имя «сколько?». Следующее за ним имя стоит в <span dir="rtl" lang="ar">مَنْصُوبٌ</span> — винительном падеже — и называется <span dir="rtl" lang="ar">تَمْيِيزٌ</span> — поясняющим словом.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Вопросы и ответы автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">كَمْ كِتَابًا عِنْدَكَ؟ عِنْدِي كِتَابَانِ.</span><span class="rule-example-ru">Сколько у тебя книг? У меня две книги.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">كَمْ أَخًا لَكَ؟ لِي أَخَوَانِ.</span><span class="rule-example-ru">Сколько у тебя братьев? У меня два брата.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">كَمْ مَسْجِدًا فِي هَذَا الشَّارِعِ؟ فِيهِ مَسْجِدٌ وَاحِدٌ.</span><span class="rule-example-ru">Сколько мечетей на этой улице? На ней одна мечеть.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">كَمْ أُخْتًا لَكَ؟ لِي ثَلَاثُ أَخَوَاتٍ.</span><span class="rule-example-ru">Сколько у тебя сестёр? У меня три сестры.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">كَمْ حَقِيبَةً عِنْدَكِ؟ عِنْدِي حَقِيبَتَانِ.</span><span class="rule-example-ru">Сколько у тебя сумок? У меня две сумки.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">كَمْ سَيَّارَةً فِي بَيْتِكَ؟ فِيهِ سَيَّارَتَانِ.</span><span class="rule-example-ru">Сколько машин у тебя дома? В нём две машины.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор автора</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">كَمْ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">اِسْمُ اسْتِفْهَامٍ</span> — вопросительное имя</span></div><div class="rule-meaning-card rule-term-role"><span class="rule-term-ar" dir="rtl" lang="ar">أَخًا</span><span class="rule-term-ru"><span dir="rtl" lang="ar">تَمْيِيزٌ</span> — поясняющее слово</span></div></div><table><thead><tr><th>Пример</th><th><span dir="rtl" lang="ar">الْمُبْتَدَأُ</span></th><th><span dir="rtl" lang="ar">الْخَبَرُ</span></th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">هَذَانِ رَجُلَانِ</span></td><td><span dir="rtl" lang="ar">هَذَانِ</span></td><td><span dir="rtl" lang="ar">رَجُلَانِ</span></td></tr><tr><td><span dir="rtl" lang="ar">هَاتَانِ فَتَاتَانِ</span></td><td><span dir="rtl" lang="ar">هَاتَانِ</span></td><td><span dir="rtl" lang="ar">فَتَاتَانِ</span></td></tr></tbody></table></div></div>$$
  where id = kam_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (kam_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$كَمْ
كَمْ : اِسْمُ اسْتِفْهَامٍ يَدُلُّ عَلَى الْعَدَدِ، وَالِاسْمُ الَّذِي بَعْدَهُ مَنْصُوبٌ يُسَمَّى تَمْيِيزًا .$$, 31, 31, 1),
    (kam_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$كَمْ كِتَابًا عِنْدَكَ ؟ عِنْدِي كِتَابَانِ . كَمْ أَخًا لَكَ ؟ لِي أَخَوَانِ .
كَمْ مَسْجِدًا فِي هَذَا الشَّارِعِ ؟ فِيهِ مَسْجِدٌ وَاحِدٌ .
كَمْ أُخْتًا لَكَ ؟ لِي ثَلَاثُ أَخَوَاتٍ . كَمْ حَقِيبَةً عِنْدَكِ ؟ عِنْدِي حَقِيبَتَانِ .
كَمْ سَيَّارَةً فِي بَيْتِكَ ؟ فِيهِ سَيَّارَتَانِ .$$, 31, 31, 2),
    (kam_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هَذَانِ رَجُلَانِ : هَذَانِ مُبْتَدَأٌ، رَجُلَانِ خَبَرٌ .
هَاتَانِ فَتَاتَانِ : هَاتَانِ مُبْتَدَأٌ، فَتَاتَانِ خَبَرٌ .
كَمْ أَخًا لَكَ ؟ : كَمْ اِسْمُ اسْتِفْهَامٍ، أَخًا تَمْيِيزٌ .$$, 31, 31, 3);
end;
$migration$;

commit;
