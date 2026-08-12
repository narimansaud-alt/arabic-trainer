-- Verify Medina Book 1 lesson 14 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 23-25.

begin;

do $migration$
declare
  idafa_rule_id bigint;
  pronouns_rule_id bigint;
  verbs_rule_id bigint;
  foreign_rule_id bigint;
  any_rule_id bigint;
begin
  select id into strict idafa_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '14' and sort_order = 1;
  select id into strict pronouns_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '14' and sort_order = 2;
  select id into strict verbs_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '14' and sort_order = 3;
  select id into strict foreign_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '14' and sort_order = 4;
  select id into strict any_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '14' and sort_order = 6;

  delete from public.rule_sections where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '14'
  );
  delete from public.rule_sources where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '14'
  );
  delete from public.rules
  where course_name = 'Мединский курс (Том 1)' and lesson_number = '14' and sort_order = 5;
  update public.rules set sort_order = sort_order + 100
  where id in (idafa_rule_id, pronouns_rule_id, verbs_rule_id, foreign_rule_id, any_rule_id);

  update public.rules
  set sort_order = 1,
      title = 'إِضَافَةُ الْأَسْمَاءِ إِلَى ضَمِيرَيِ الْمُخَاطَبِينَ وَالْمُتَكَلِّمِينَ (идафа к местоимениям «ваш» и «наш»)',
      rule_ar = 'تُضَافُ الْأَسْمَاءُ إِلَى ضَمِيرِ جَمْعِ الْمُخَاطَبِ «ـكُمْ»، وَإِلَى ضَمِيرِ جَمْعِ الْمُتَكَلِّمِ «ـنَا».',
      summary = 'تُضَافُ الْأَسْمَاءُ إِلَى ضَمِيرِ جَمْعِ الْمُخَاطَبِ «ـكُمْ»، وَإِلَى ضَمِيرِ جَمْعِ الْمُتَكَلِّمِ «ـنَا».',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">تُضَافُ الْأَسْمَاءُ إِلَى ضَمِيرِ جَمْعِ الْمُخَاطَبِ «ـكُمْ»، وَإِلَى ضَمِيرِ جَمْعِ الْمُتَكَلِّمِ «ـنَا».</span><p class="rule-study-text">Суффикс <span dir="rtl" lang="ar">ـكُمْ</span> означает «ваш» при обращении к группе, а <span dir="rtl" lang="ar">ـنَا</span> — «наш». Имя перед суффиксом является <span dir="rtl" lang="ar">مُضَافٌ</span>, суффикс — <span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">ـكُمْ — ваш</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">اللَّهُ رَبُّكُمْ. النَّبِيُّ مُحَمَّدٌ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيُّكُمْ.</span><span class="rule-example-ru">Аллах — ваш Господь. Пророк Мухаммад, мир ему и благословение Аллаха, — ваш пророк.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">الْإِسْلَامُ دِينُكُمْ. مَا لُغَتُكُمْ؟ أَيْنَ مَدْرَسَتُكُمْ؟ بَيْتُكُمْ جَمِيلٌ.</span><span class="rule-example-ru">Ислам — ваша религия. Какой у вас язык? Где ваша школа? Ваш дом красивый.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">ـنَا — наш</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">اللَّهُ رَبُّنَا. النَّبِيُّ مُحَمَّدٌ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيُّنَا.</span><span class="rule-example-ru">Аллах — наш Господь. Пророк Мухаммад, мир ему и благословение Аллаха, — наш пророк.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">الْإِسْلَامُ دِينُنَا. اللُّغَةُ الْعَرَبِيَّةُ لُغَتُنَا. أَيْنَ مَدْرَسَتُنَا؟ بَيْتُنَا جَمِيلٌ.</span><span class="rule-example-ru">Ислам — наша религия. Арабский язык — наш язык. Где наша школа? Наш дом красивый.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">رَبُّ / رَبُّ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُضَافٌ</span> — первый член идафы</span></div><div class="rule-meaning-card rule-term-jarr"><span class="rule-term-ar" dir="rtl" lang="ar">ـكُمْ / ـنَا</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span> — второй член идафы</span></div></div></div></div>$$
  where id = idafa_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (idafa_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$إِضَافَةُ الْأَسْمَاءِ إِلَى ضَمِيرَيِ الْمُخَاطَبِينَ، وَالْمُتَكَلِّمِينَ
الْإِضَافَةُ إِلَى ضَمِيرِ الْمُخَاطَبِينَ : اللَّهُ رَبُّكُمْ . النَّبِيُّ مُحَمَّدٌ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيُّكُمْ .
الْإِسْلَامُ دِينُكُمْ . مَا لُغَتُكُمْ ؟ أَيْنَ مَدْرَسَتُكُمْ ؟ بَيْتُكُمْ جَمِيلٌ .$$, 23, 23, 1),
    (idafa_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْإِضَافَةُ إِلَى ضَمِيرِ الْمُتَكَلِّمِينَ : اللَّهُ رَبُّنَا . النَّبِيُّ مُحَمَّدٌ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيُّنَا . الْإِسْلَامُ دِينُنَا . اللُّغَةُ الْعَرَبِيَّةُ لُغَتُنَا . أَيْنَ مَدْرَسَتُنَا ؟ بَيْتُنَا جَمِيلٌ .$$, 23, 23, 2),
    (idafa_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$رَبُّكُمْ : رَبُّ مُضَافٌ، ـكُمْ مُضَافٌ إِلَيْهِ .
رَبُّنَا : رَبُّ مُضَافٌ، ـنَا مُضَافٌ إِلَيْهِ .$$, 23, 23, 3);

  update public.rules
  set sort_order = 2,
      title = 'نَحْنُ وَأَنْتُمْ وَأَنْتُنَّ (мы и вы)',
      rule_ar = 'نَحْنُ ضَمِيرُ جَمْعٍ لِلْمُتَكَلِّمِينَ وَالْمُتَكَلِّمَاتِ، وَأَنْتُمْ ضَمِيرُ جَمْعٍ لِلْمُخَاطَبِينَ، وَأَنْتُنَّ ضَمِيرُ جَمْعٍ لِلْمُخَاطَبَاتِ.',
      summary = 'نَحْنُ ضَمِيرُ جَمْعٍ لِلْمُتَكَلِّمِينَ وَالْمُتَكَلِّمَاتِ، وَأَنْتُمْ ضَمِيرُ جَمْعٍ لِلْمُخَاطَبِينَ، وَأَنْتُنَّ ضَمِيرُ جَمْعٍ لِلْمُخَاطَبَاتِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Местоимения группы</span><span class="rule-main-ar" dir="rtl" lang="ar">نَحْنُ ضَمِيرُ جَمْعٍ لِلْمُتَكَلِّمِينَ وَالْمُتَكَلِّمَاتِ، وَأَنْتُمْ ضَمِيرُ جَمْعٍ لِلْمُخَاطَبِينَ، وَأَنْتُنَّ ضَمِيرُ جَمْعٍ لِلْمُخَاطَبَاتِ.</span><table><thead><tr><th>Форма</th><th>Русский смысл</th><th>Кто</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">نَحْنُ</span></td><td>мы</td><td>говорящие мужчины или женщины</td></tr><tr><td><span dir="rtl" lang="ar">أَنْتُمْ</span></td><td>вы</td><td>группа мужчин</td></tr><tr><td><span dir="rtl" lang="ar">أَنْتُنَّ</span></td><td>вы</td><td>группа женщин</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">نَحْنُ — мы</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">نَحْنُ مُسْلِمُونَ. نَحْنُ مُهَنْدِسُونَ. نَحْنُ حَفَدَةُ الْمُدِيرِ.</span><span class="rule-example-ru">Мы мусульмане. Мы инженеры. Мы внуки директора.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">أَنْتُمْ — вы, мужчины</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتُمْ مُسْلِمُونَ. أَنْتُمْ مُهَنْدِسُونَ. أَأَنْتُمْ حَفَدَةُ الْمُدِيرِ؟</span><span class="rule-example-ru">Вы мусульмане. Вы инженеры. Вы внуки директора?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Сопоставление форм</span><table><thead><tr><th>Единственное</th><th>Множественное</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">أَنَا مُدَرِّسٌ</span></td><td><span dir="rtl" lang="ar">نَحْنُ مُدَرِّسُونَ</span></td></tr><tr><td><span dir="rtl" lang="ar">أَنَا مُدَرِّسَةٌ</span></td><td><span dir="rtl" lang="ar">نَحْنُ مُدَرِّسَاتٌ</span></td></tr><tr><td><span dir="rtl" lang="ar">أَنْتَ طَبِيبٌ</span></td><td><span dir="rtl" lang="ar">أَنْتُمْ أَطِبَّاءُ</span></td></tr><tr><td><span dir="rtl" lang="ar">أَنْتِ طَبِيبَةٌ</span></td><td><span dir="rtl" lang="ar">أَنْتُنَّ طَبِيبَاتٌ</span></td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">فِي أَيِّ شَارِعٍ بَيْتُكُمْ؟ بَيْتُنَا فِي الشَّارِعِ الَّذِي أَمَامَ الْمَحْكَمَةِ.</span><span class="rule-example-ru">На какой улице ваш дом? Наш дом на улице перед судом.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَأَنْتُمْ مُدَرِّسُونَ؟ لَا. نَحْنُ أَطِبَّاءُ.</span><span class="rule-example-ru">Вы преподаватели? Нет. Мы врачи.</span></div></div></div></div>$$
  where id = pronouns_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (pronouns_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$ضَمِيرُ الْجَمْعِ لِلْمُتَكَلِّمِ : ( نَحْنُ ) نَحْنُ مُسْلِمُونَ . نَحْنُ مُهَنْدِسُونَ . نَحْنُ حَفَدَةُ الْمُدِيرِ .
ضَمِيرُ الْجَمْعِ لِلْمُخَاطَبِ : ( أَنْتُمْ ) أَنْتُمْ مُسْلِمُونَ . أَنْتُمْ مُهَنْدِسُونَ . أَأَنْتُمْ حَفَدَةُ الْمُدِيرِ ؟$$, 23, 23, 1),
    (pronouns_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَمْثِلَةٌ : فِي أَيِّ شَارِعٍ بَيْتُكُمْ ؟ بَيْتُنَا فِي الشَّارِعِ الَّذِي أَمَامَ الْمَحْكَمَةِ .
أَأَنْتُمْ مُدَرِّسُونَ ؟ لَا . نَحْنُ أَطِبَّاءُ .
أَنَا مُدَرِّسٌ : نَحْنُ مُدَرِّسُونَ . أَنَا مُدَرِّسَةٌ : نَحْنُ مُدَرِّسَاتٌ .
أَنْتَ طَبِيبٌ : أَنْتُمْ أَطِبَّاءُ . أَنْتِ طَبِيبَةٌ : أَنْتُنَّ طَبِيبَاتٌ .$$, 23, 23, 2);

  update public.rules
  set sort_order = 3,
      title = 'أَيٌّ (какой? который?)',
      rule_ar = 'أَيٌّ اِسْمُ اسْتِفْهَامٍ لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ، وَالِاسْمُ الَّذِي بَعْدَهُ مُضَافٌ إِلَيْهِ.',
      summary = 'أَيٌّ اِسْمُ اسْتِفْهَامٍ لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ، وَالِاسْمُ الَّذِي بَعْدَهُ مُضَافٌ إِلَيْهِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">أَيٌّ اِسْمُ اسْتِفْهَامٍ لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ، وَالِاسْمُ الَّذِي بَعْدَهُ مُضَافٌ إِلَيْهِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">أَيٌّ</span> — вопросительное имя «какой? который?» для разумного и неразумного. Следующее имя является <span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span>. Форма самого вопросительного имени меняется по управлению: <span dir="rtl" lang="ar">أَيُّ</span> или <span dir="rtl" lang="ar">أَيِّ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">О разумном</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَيُّ الطُّلَّابِ خَرَجَ؟</span><span class="rule-example-ru">Который из студентов вышел?</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَيُّكُمْ ذَهَبَ إِلَى الْمُسْتَشْفَى؟</span><span class="rule-example-ru">Кто из вас пошёл в больницу?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">О неразумном</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">أَيُّ كُلِّيَّةٍ هٰذِهِ؟ أَيُّ شَهْرٍ هٰذَا؟</span><span class="rule-example-ru">Какой это факультет? Какой это месяц?</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">فِي أَيِّ مَدْرَسَةٍ أَنْتَ؟ مِنْ أَيِّ بَلَدٍ أَنْتَ؟</span><span class="rule-example-ru">В какой школе ты учишься? Из какой ты страны?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полные ответы автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَيُّ يَوْمٍ هٰذَا؟ هٰذَا يَوْمُ السَّبْتِ.</span><span class="rule-example-ru">Какой сегодня день? Сегодня суббота.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَيُّ كُلِّيَّةٍ هٰذِهِ؟ هٰذِهِ كُلِّيَّةُ الشَّرِيعَةِ.</span><span class="rule-example-ru">Какой это факультет? Это факультет шариата.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">فِي أَيِّ مَعْهَدٍ أَنْتَ؟ أَنَا فِي مَعْهَدِ اللُّغَةِ الْعَرَبِيَّةِ.</span><span class="rule-example-ru">В каком институте ты учишься? Я в Институте арабского языка.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">مِنْ أَيِّ بَلَدٍ أَنْتَ؟ أَنَا مِنَ الْجَزَائِرِ.</span><span class="rule-example-ru">Из какой ты страны? Я из Алжира.</span></div></div></div></div>$$
  where id = any_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (any_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَيٌّ
أَيٌّ : اِسْمُ اسْتِفْهَامٍ لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ . وَالِاسْمُ الَّذِي بَعْدَهُ مُضَافٌ إِلَيْهِ .$$, 24, 24, 1),
    (any_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْعَاقِلُ : أَيُّ الطُّلَّابِ خَرَجَ ؟ أَيُّكُمْ ذَهَبَ إِلَى الْمُسْتَشْفَى ؟
غَيْرُ الْعَاقِلِ : أَيُّ كُلِّيَّةٍ هَذِهِ ؟ أَيُّ شَهْرٍ هَذَا ؟ فِي أَيِّ مَدْرَسَةٍ أَنْتَ ؟ مِنْ أَيِّ بَلَدٍ أَنْتَ ؟$$, 24, 24, 2),
    (any_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَيُّ يَوْمٍ هَذَا ؟ هَذَا يَوْمُ السَّبْتِ . أَيُّ كُلِّيَّةٍ هَذِهِ ؟ هَذِهِ كُلِّيَّةُ الشَّرِيعَةِ .
فِي أَيِّ مَعْهَدٍ أَنْتَ ؟ أَنَا فِي مَعْهَدِ اللُّغَةِ الْعَرَبِيَّةِ . مِنْ أَيِّ بَلَدٍ أَنْتَ ؟ أَنَا مِنَ الْجَزَائِرِ .$$, 24, 24, 3);

  update public.rules
  set sort_order = 4,
      title = 'ضَمَائِرُ الْفَاعِلِ الْمُتَّصِلَةُ بِالْفِعْلِ الْمَاضِي (местоименные окончания прошедшего глагола)',
      rule_ar = 'تَتَّصِلُ بِالْفِعْلِ الْمَاضِي ضَمَائِرُ الْفَاعِلِ: «ـتُ» لِلْمُتَكَلِّمِ، وَ«ـتَ» لِلْمُخَاطَبِ، وَ«ـتِ» لِلْمُخَاطَبَةِ، وَ«ـتُمْ» لِجَمْعِ الْمُخَاطَبِينَ، وَ«ـتُنَّ» لِجَمْعِ الْمُخَاطَبَاتِ.',
      summary = 'تَتَّصِلُ بِالْفِعْلِ الْمَاضِي ضَمَائِرُ الْفَاعِلِ: «ـتُ» لِلْمُتَكَلِّمِ، وَ«ـتَ» لِلْمُخَاطَبِ، وَ«ـتِ» لِلْمُخَاطَبَةِ، وَ«ـتُمْ» لِجَمْعِ الْمُخَاطَبِينَ، وَ«ـتُنَّ» لِجَمْعِ الْمُخَاطَبَاتِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">تَتَّصِلُ بِالْفِعْلِ الْمَاضِي ضَمَائِرُ الْفَاعِلِ: «ـتُ»، وَ«ـتَ»، وَ«ـتِ»، وَ«ـتُمْ»، وَ«ـتُنَّ».</span><table><thead><tr><th>Кто</th><th>ذَهَبَ</th><th>خَرَجَ</th><th>Русский смысл</th></tr></thead><tbody><tr><td>я</td><td><span dir="rtl" lang="ar">ذَهَبْتُ</span></td><td><span dir="rtl" lang="ar">خَرَجْتُ</span></td><td>я пошёл/пошла · я вышел/вышла</td></tr><tr><td>ты, мужчина</td><td><span dir="rtl" lang="ar">ذَهَبْتَ</span></td><td><span dir="rtl" lang="ar">خَرَجْتَ</span></td><td>ты пошёл · ты вышел</td></tr><tr><td>ты, женщина</td><td><span dir="rtl" lang="ar">ذَهَبْتِ</span></td><td><span dir="rtl" lang="ar">خَرَجْتِ</span></td><td>ты пошла · ты вышла</td></tr><tr><td>вы, мужчины</td><td><span dir="rtl" lang="ar">ذَهَبْتُمْ</span></td><td><span dir="rtl" lang="ar">خَرَجْتُمْ</span></td><td>вы пошли · вы вышли</td></tr><tr><td>вы, женщины</td><td><span dir="rtl" lang="ar">ذَهَبْتُنَّ</span></td><td><span dir="rtl" lang="ar">خَرَجْتُنَّ</span></td><td>вы пошли · вы вышли</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Вопросы четырём собеседникам</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتَ ذَهَبْتَ إِلَى الْمَعْهَدِ. أَيْنَ ذَهَبْتَ؟ لِمَاذَا خَرَجْتَ؟</span><span class="rule-example-ru">Ты, мужчина, пошёл в институт. Куда ты пошёл? Почему ты вышел?</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتِ ذَهَبْتِ إِلَى الْمَعْهَدِ. أَيْنَ ذَهَبْتِ؟ لِمَاذَا خَرَجْتِ؟</span><span class="rule-example-ru">Ты, женщина, пошла в институт. Куда ты пошла? Почему ты вышла?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتُمْ ذَهَبْتُمْ إِلَى الْمَعْهَدِ. أَيْنَ ذَهَبْتُمْ؟ لِمَاذَا خَرَجْتُمْ؟</span><span class="rule-example-ru">Вы, мужчины, пошли в институт. Куда вы пошли? Почему вы вышли?</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتُنَّ ذَهَبْتُنَّ إِلَى الْمَعْهَدِ. أَيْنَ ذَهَبْتُنَّ؟ لِمَاذَا خَرَجْتُنَّ؟</span><span class="rule-example-ru">Вы, женщины, пошли в институт. Куда вы пошли? Почему вы вышли?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор и сверка</span><table><thead><tr><th>Правильно</th><th>Неправильно</th><th>Структура правильной формы</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">أَنَا ذَهَبْتُ ✓</span></td><td><span dir="rtl" lang="ar">أَنَا ذَهَبَ ✕</span></td><td><span dir="rtl" lang="ar">ذَهَبْـ</span> — <span dir="rtl" lang="ar">فِعْلٌ</span>; <span dir="rtl" lang="ar">ـتُ</span> — <span dir="rtl" lang="ar">فَاعِلٌ</span></td></tr><tr><td><span dir="rtl" lang="ar">أَنْتُمْ ذَهَبْتُمْ ✓</span></td><td><span dir="rtl" lang="ar">أَنْتُمْ ذَهَبُوا ✕</span></td><td><span dir="rtl" lang="ar">ـتُـ</span> — <span dir="rtl" lang="ar">فَاعِلٌ</span>; <span dir="rtl" lang="ar">ـمْ</span> — <span dir="rtl" lang="ar">عَلَامَةُ الْجَمْعِ الْمُذَكَّرِ</span></td></tr><tr><td><span dir="rtl" lang="ar">أَنْتُنَّ ذَهَبْتُنَّ ✓</span></td><td><span dir="rtl" lang="ar">أَنْتُنَّ ذَهَبْنَ ✕</span></td><td><span dir="rtl" lang="ar">ـتُـ</span> — <span dir="rtl" lang="ar">فَاعِلٌ</span>; <span dir="rtl" lang="ar">ـنَّ</span> — <span dir="rtl" lang="ar">عَلَامَةُ الْجَمْعِ الْمُؤَنَّثِ</span></td></tr></tbody></table></div></div>$$
  where id = verbs_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (verbs_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$ضَمِيرُ الْمُخَاطَبِ الْمُتَّصِلُ بِالْفِعْلِ
الْمُفْرَدُ الْمُذَكَّرُ : ذَهَبْتَ . خَرَجْتَ .
الْمُفْرَدُ الْمُؤَنَّثُ : ذَهَبْتِ . خَرَجْتِ .
الْجَمْعُ الْمُذَكَّرُ : ذَهَبْتُمْ . خَرَجْتُمْ .
الْجَمْعُ الْمُؤَنَّثُ : ذَهَبْتُنَّ . خَرَجْتُنَّ .$$, 24, 24, 1),
    (verbs_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَنْتَ ذَهَبْتَ إِلَى الْمَعْهَدِ . أَيْنَ ذَهَبْتَ ؟ لِمَاذَا خَرَجْتَ ؟
أَنْتِ ذَهَبْتِ إِلَى الْمَعْهَدِ . أَيْنَ ذَهَبْتِ ؟ لِمَاذَا خَرَجْتِ ؟
أَنْتُمْ ذَهَبْتُمْ إِلَى الْمَعْهَدِ . أَيْنَ ذَهَبْتُمْ ؟ لِمَاذَا خَرَجْتُمْ ؟
أَنْتُنَّ ذَهَبْتُنَّ إِلَى الْمَعْهَدِ . أَيْنَ ذَهَبْتُنَّ ؟ لِمَاذَا خَرَجْتُنَّ ؟$$, 24, 24, 2),
    (verbs_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$ذَهَبْتُ : ذَهَبْـ فِعْلٌ، ـتُ فَاعِلٌ . أَنَا ذَهَبَ ✕ أَنَا ذَهَبْتُ ✓
ذَهَبْتُمْ : ذَهَبْـ فِعْلٌ، ـتُـ فَاعِلٌ، ـمْ عَلَامَةُ الْجَمْعِ الْمُذَكَّرِ . أَنْتُمْ ذَهَبُوا ✕ أَنْتُمْ ذَهَبْتُمْ ✓
ذَهَبْتُنَّ : ذَهَبْـ فِعْلٌ، ـتُـ فَاعِلٌ، ـنَّ عَلَامَةُ الْجَمْعِ الْمُؤَنَّثِ . أَنْتُنَّ ذَهَبْنَ ✕ أَنْتُنَّ ذَهَبْتُنَّ ✓$$, 25, 25, 3);

  update public.rules
  set sort_order = 5,
      title = 'الْعَلَمُ الْأَعْجَمِيُّ (иноязычное собственное имя)',
      rule_ar = 'الْعَلَمُ الْأَعْجَمِيُّ لَا يُنَوَّنُ، وَهُوَ مَمْنُوعٌ مِنَ الصَّرْفِ.',
      summary = 'الْعَلَمُ الْأَعْجَمِيُّ لَا يُنَوَّنُ، وَهُوَ مَمْنُوعٌ مِنَ الصَّرْفِ.',
      rule_kind = 'important',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило шарха</span><span class="rule-main-ar" dir="rtl" lang="ar">الْعَلَمُ الْأَعْجَمِيُّ لَا يُنَوَّنُ، وَهُوَ مَمْنُوعٌ مِنَ الصَّرْفِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">الْعَلَمُ الْأَعْجَمِيُّ</span> — иноязычное собственное имя. По правилу этой страницы оно не принимает танвин и относится к <span dir="rtl" lang="ar">الْمَمْنُوعُ مِنَ الصَّرْفِ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">إِبْرَاهِيمُ · يَعْقُوبُ · جِبْرِيلُ · مِيكَائِيلُ</span><span class="rule-example-ru">Ибрахим · Якуб · Джибриль · Микаиль</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">وَلِيَمُ · لَنْدَنُ · بَاكِسْتَانُ</span><span class="rule-example-ru">Уильям · Лондон · Пакистан</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Без танвина</span><div class="rule-example-list"><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">إِبْرَاهِيمٌ ✕</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">وَلِيَمٌ ✕</span></div></div></div></div>$$
  where id = foreign_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (foreign_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْعَلَمُ الْأَعْجَمِيُّ
الْعَلَمُ الْأَعْجَمِيُّ : لَا يُنَوَّنُ ( مَمْنُوعٌ مِنَ الصَّرْفِ ) .$$, 25, 25, 1),
    (foreign_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$إِبْرَاهِيمُ . يَعْقُوبُ . جِبْرِيلُ . مِيكَائِيلُ . وَلِيَمُ . لَنْدَنُ . بَاكِسْتَانُ .
إِبْرَاهِيمٌ ✕ وَلِيَمٌ ✕$$, 25, 25, 2);
end;
$migration$;

commit;
