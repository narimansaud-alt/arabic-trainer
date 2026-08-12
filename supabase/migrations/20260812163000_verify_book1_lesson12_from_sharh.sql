-- Verify Medina Book 1 lesson 12 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 17-18.

begin;

do $migration$
declare
  kaaf_rule_id bigint;
  pronoun_rule_id bigint;
  subject_rule_id bigint;
  relative_rule_id bigint;
  sukuns_rule_id bigint;
begin
  select id into strict kaaf_rule_id from public.rules
  where course_name = 'Мединский курс (Том 1)' and lesson_number = '12' and sort_order = 1;
  select id into strict subject_rule_id from public.rules
  where course_name = 'Мединский курс (Том 1)' and lesson_number = '12' and sort_order = 2;
  select id into strict relative_rule_id from public.rules
  where course_name = 'Мединский курс (Том 1)' and lesson_number = '12' and sort_order = 3;
  select id into strict pronoun_rule_id from public.rules
  where course_name = 'Мединский курс (Том 1)' and lesson_number = '12' and sort_order = 4;
  select id into strict sukuns_rule_id from public.rules
  where course_name = 'Мединский курс (Том 1)' and lesson_number = '12' and sort_order = 5;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)' and lesson_number = '12'
  );
  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)' and lesson_number = '12'
  );

  update public.rules set sort_order = sort_order + 100
  where id in (kaaf_rule_id, pronoun_rule_id, subject_rule_id, relative_rule_id, sukuns_rule_id);

  update public.rules
  set
    sort_order = 1,
    title = 'كَافُ الْمُخَاطَبِ: ـكَ وَـكِ (каф собеседника: «твой/твоя»)',
    rule_ar = 'كَافُ الْمُخَاطَبِ ضَمِيرٌ لِلْمُخَاطَبِ؛ تُفْتَحُ لِلْمُذَكَّرِ، وَتُكْسَرُ لِلْمُؤَنَّثِ.',
    summary = 'كَافُ الْمُخَاطَبِ ضَمِيرٌ لِلْمُخَاطَبِ؛ تُفْتَحُ لِلْمُذَكَّرِ، وَتُكْسَرُ لِلْمُؤَنَّثِ.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">كَافُ الْمُخَاطَبِ ضَمِيرٌ لِلْمُخَاطَبِ؛ تُفْتَحُ لِلْمُذَكَّرِ، وَتُكْسَرُ لِلْمُؤَنَّثِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">كَافُ الْمُخَاطَبِ</span> — присоединённое местоимение собеседника. К мужчине обращаются с формой <span dir="rtl" lang="ar">ـكَ</span>, а к женщине — с формой <span dir="rtl" lang="ar">ـكِ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Обращение к мужчине</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَا اسْمُكَ؟ كَيْفَ حَالُكَ يَا أَبِي؟ بَيْتُكَ جَمِيلٌ.</span><span class="rule-example-ru">Как тебя зовут? Как твои дела, отец? Твой дом красивый.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَلَكَ هَذَا الْقَلَمُ يَا خَالِدُ؟</span><span class="rule-example-ru">Тебе принадлежит эта ручка, Халид?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Обращение к женщине</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَا اسْمُكِ؟ كَيْفَ حَالُكِ يَا أُمِّي؟ بَيْتُكِ جَمِيلٌ.</span><span class="rule-example-ru">Как тебя зовут? Как твои дела, мать? Твой дом красивый.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَلَكِ هَذَا الْقَلَمُ يَا فَاطِمَةُ؟</span><span class="rule-example-ru">Тебе принадлежит эта ручка, Фатима?</span></div></div></div></div>$$
  where id = kaaf_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (kaaf_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$كَافُ الْمُخَاطَبِ
كَافُ الْمُخَاطَبِ : ضَمِيرٌ لِلْمُخَاطَبِ .$$, 17, 17, 1),
    (kaaf_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$ضَمِيرُ الْمُخَاطَبِ الْمُذَكَّرِ : مَا اسْمُكَ ؟ كَيْفَ حَالُكَ يَا أَبِي ؟ بَيْتُكَ جَمِيلٌ .
أَلَكَ هَذَا الْقَلَمُ يَا خَالِدُ ؟
ضَمِيرُ الْمُخَاطَبِ الْمُؤَنَّثِ : مَا اسْمُكِ ؟ كَيْفَ حَالُكِ يَا أُمِّي ؟ بَيْتُكِ جَمِيلٌ .
أَلَكِ هَذَا الْقَلَمُ يَا فَاطِمَةُ ؟$$, 17, 17, 2);

  update public.rules
  set
    sort_order = 2,
    title = 'أَنَا وَأَنْتَ وَأَنْتِ (я и ты)',
    rule_ar = 'أَنَا ضَمِيرٌ لِلْمُتَكَلِّمِ الْمُذَكَّرِ وَالْمُؤَنَّثِ، وَأَنْتَ ضَمِيرٌ لِلْمُخَاطَبِ الْمُذَكَّرِ، وَأَنْتِ ضَمِيرٌ لِلْمُخَاطَبِ الْمُؤَنَّثِ.',
    summary = 'أَنَا ضَمِيرٌ لِلْمُتَكَلِّمِ الْمُذَكَّرِ وَالْمُؤَنَّثِ، وَأَنْتَ ضَمِيرٌ لِلْمُخَاطَبِ الْمُذَكَّرِ، وَأَنْتِ ضَمِيرٌ لِلْمُخَاطَبِ الْمُؤَنَّثِ.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Три формы</span><span class="rule-main-ar" dir="rtl" lang="ar">أَنَا ضَمِيرٌ لِلْمُتَكَلِّمِ الْمُذَكَّرِ وَالْمُؤَنَّثِ، وَأَنْتَ ضَمِيرٌ لِلْمُخَاطَبِ الْمُذَكَّرِ، وَأَنْتِ ضَمِيرٌ لِلْمُخَاطَبِ الْمُؤَنَّثِ.</span><table><thead><tr><th>Местоимение</th><th>Кто говорит или к кому обращаются</th><th>Русский смысл</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">أَنَا</span></td><td><span dir="rtl" lang="ar">الْمُتَكَلِّمُ الْمُذَكَّرُ وَالْمُؤَنَّثُ</span></td><td>я — мужчина или женщина</td></tr><tr><td><span dir="rtl" lang="ar">أَنْتَ</span></td><td><span dir="rtl" lang="ar">الْمُخَاطَبُ الْمُذَكَّرُ</span></td><td>ты — обращение к мужчине</td></tr><tr><td><span dir="rtl" lang="ar">أَنْتِ</span></td><td><span dir="rtl" lang="ar">الْمُخَاطَبُ الْمُؤَنَّثُ</span></td><td>ты — обращение к женщине</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">أَنَا — я</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا طَالِبٌ. أَنَا طَالِبَةٌ. أَنَا مُحَمَّدٌ. أَنَا خَدِيجَةُ.</span><span class="rule-example-ru">Я студент. Я студентка. Я Мухаммад. Я Хадиджа.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">أَنْتَ — ты, мужчина</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتَ مُهَنْدِسٌ. أَنْتَ طَبِيبٌ. مَنْ أَنْتَ؟ أَأَنْتَ مُدَرِّسٌ؟</span><span class="rule-example-ru">Ты инженер. Ты врач. Кто ты? Ты преподаватель?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">أَنْتِ — ты, женщина</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتِ مُهَنْدِسَةٌ. أَنْتِ طَبِيبَةٌ. مَنْ أَنْتِ؟ أَأَنْتِ مُدَرِّسَةٌ؟</span><span class="rule-example-ru">Ты инженер. Ты врач. Кто ты? Ты преподавательница?</span></div></div></div></div>$$
  where id = pronoun_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (pronoun_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَنَا، وَأَنْتَ
أَنْتَ : ضَمِيرٌ لِلْمُخَاطَبِ . أَنَا : ضَمِيرٌ لِلْمُتَكَلِّمِ .$$, 17, 17, 1),
    (pronoun_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْمُتَكَلِّمُ الْمُذَكَّرُ وَالْمُؤَنَّثُ : ( أَنَا ) أَنَا طَالِبٌ . أَنَا طَالِبَةٌ . أَنَا مُحَمَّدٌ . أَنَا خَدِيجَةُ .
الْمُخَاطَبُ الْمُذَكَّرُ : ( أَنْتَ ) أَنْتَ مُهَنْدِسٌ . أَنْتَ طَبِيبٌ . مَنْ أَنْتَ ؟ أَأَنْتَ مُدَرِّسٌ ؟
الْمُخَاطَبُ الْمُؤَنَّثُ : ( أَنْتِ ) أَنْتِ مُهَنْدِسَةٌ . أَنْتِ طَبِيبَةٌ . مَنْ أَنْتِ ؟ أَأَنْتِ مُدَرِّسَةٌ ؟$$, 17, 17, 2);

  update public.rules
  set
    sort_order = 3,
    title = 'تَأْنِيثُ الْفَاعِلِ (показатель женского рода при исполнителе действия)',
    rule_ar = 'الْفَاعِلُ هُوَ الَّذِي يَقَعُ بَعْدَ الْفِعْلِ، وَيُلْحَقُ بِالْفِعْلِ تَاءُ التَّأْنِيثِ السَّاكِنَةُ إِذَا كَانَ الْفَاعِلُ مُؤَنَّثًا.',
    summary = 'الْفَاعِلُ هُوَ الَّذِي يَقَعُ بَعْدَ الْفِعْلِ، وَيُلْحَقُ بِالْفِعْلِ تَاءُ التَّأْنِيثِ السَّاكِنَةُ إِذَا كَانَ الْفَاعِلُ مُؤَنَّثًا.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الْفَاعِلُ هُوَ الَّذِي يَقَعُ بَعْدَ الْفِعْلِ، وَيُلْحَقُ بِالْفِعْلِ تَاءُ التَّأْنِيثِ السَّاكِنَةُ إِذَا كَانَ الْفَاعِلُ مُؤَنَّثًا.</span><p class="rule-study-text"><span dir="rtl" lang="ar">الْفَاعِلُ</span> — исполнитель действия, который в приведённой модели стоит после глагола. Перед исполнителем женского рода глагол получает <span dir="rtl" lang="ar">تَاءُ التَّأْنِيثِ السَّاكِنَةُ</span> — неподвижную <span dir="rtl" lang="ar">تْ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Схема</span><table><thead><tr><th>Исполнитель</th><th>Глагол + فَاعِلٌ</th><th>Русский смысл</th></tr></thead><tbody><tr><td>мужской род</td><td><span dir="rtl" lang="ar">خَرَجَ مُحَمَّدٌ</span></td><td>Мухаммад вышел</td></tr><tr><td>женский род</td><td><span dir="rtl" lang="ar">خَرَجَتْ آمِنَةُ</span></td><td>Амина вышла</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبَ سَعِيدٌ. خَرَجَ أَخِي. ذَهَبَ الطَّالِبُ.</span><span class="rule-example-ru">Саид ушёл. Мой брат вышел. Студент ушёл.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">خَرَجَتْ أُمِّي. ذَهَبَتِ الطَّالِبَةُ.</span><span class="rule-example-ru">Моя мать вышла. Студентка ушла.</span></div></div></div></div>$$
  where id = subject_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (subject_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$تَأْنِيثُ الْفَاعِلِ
الْفَاعِلُ : هُوَ الَّذِي يَقَعُ بَعْدَ الْفِعْلِ .
خَرَجَ مُحَمَّدٌ . خَرَجَتْ آمِنَةُ .$$, 17, 17, 1),
    (subject_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$ذَهَبَ سَعِيدٌ . خَرَجَ أَخِي . خَرَجَتْ أُمِّي . ذَهَبَ الطَّالِبُ . ذَهَبَتِ الطَّالِبَةُ .$$, 17, 17, 2);

  update public.rules
  set
    sort_order = 4,
    title = 'الِاسْمَانِ الْمَوْصُولَانِ: الَّذِي وَالَّتِي (относительные имена «который» и «которая»)',
    rule_ar = 'الَّذِي اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ، وَالَّتِي اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُؤَنَّثِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    summary = 'الَّذِي اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ، وَالَّتِي اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُؤَنَّثِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الَّذِي اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ، وَالَّتِي اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُؤَنَّثِ؛ وَكِلَاهُمَا لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span><table><thead><tr><th>Форма</th><th>Род и число</th><th>Русский смысл</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">الَّذِي</span></td><td>единственное, мужской род</td><td>который</td></tr><tr><td><span dir="rtl" lang="ar">الَّتِي</span></td><td>единственное, женский род</td><td>которая</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Мужской род: разумное</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الْفَتَى الَّذِي خَرَجَ الْآنَ ابْنُ عَمِّي.</span><span class="rule-example-ru">Юноша, который сейчас вышел, — сын моего дяди.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنِ الرَّجُلُ الَّذِي جَلَسَ فِي الْحَدِيقَةِ؟</span><span class="rule-example-ru">Кто мужчина, который сидел в саду?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Мужской род: неразумное</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">الْقَلَمُ الَّذِي مَعَكَ مَكْسُورٌ.</span><span class="rule-example-ru">Ручка, которая у тебя, сломана.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنِ الْكِتَابُ الَّذِي عَلَى الْمَكْتَبِ؟</span><span class="rule-example-ru">Кому принадлежит книга, которая лежит на столе?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Женский род: разумное</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الْفَتَاةُ الَّتِي خَرَجَتِ الْآنَ بِنْتُ عَمِّي.</span><span class="rule-example-ru">Девушка, которая сейчас вышла, — дочь моего дяди.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنِ الْمُدَرِّسَةُ الَّتِي جَلَسَتْ فِي الْحَدِيقَةِ؟</span><span class="rule-example-ru">Кто преподавательница, которая сидела в саду?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Женский род: неразумное</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">السَّاعَةُ الَّتِي مَعَكَ مَكْسُورَةٌ.</span><span class="rule-example-ru">Часы, которые у тебя, сломаны.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنِ الْحَقِيبَةُ الَّتِي عَلَى الْمَكْتَبِ؟</span><span class="rule-example-ru">Кому принадлежит сумка, которая лежит на столе?</span></div></div></div></div>$$
  where id = relative_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (relative_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الَّذِي، الَّتِي
الَّذِي : اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ .
الَّتِي : اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُؤَنَّثِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ .$$, 18, 18, 1),
    (relative_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الِاسْمُ الْمَوْصُولُ الْمُذَكَّرُ الْعَاقِلُ : الْفَتَى الَّذِي خَرَجَ الْآنَ ابْنُ عَمِّي .
مَنِ الرَّجُلُ الَّذِي جَلَسَ فِي الْحَدِيقَةِ ؟
الِاسْمُ الْمَوْصُولُ الْمُذَكَّرُ غَيْرُ الْعَاقِلِ : الْقَلَمُ الَّذِي مَعَكَ مَكْسُورٌ .
لِمَنِ الْكِتَابُ الَّذِي عَلَى الْمَكْتَبِ ؟$$, 18, 18, 2),
    (relative_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الِاسْمُ الْمَوْصُولُ الْمُؤَنَّثُ الْعَاقِلُ : الْفَتَاةُ الَّتِي خَرَجَتِ الْآنَ بِنْتُ عَمِّي .
مَنِ الْمُدَرِّسَةُ الَّتِي جَلَسَتْ فِي الْحَدِيقَةِ ؟
الِاسْمُ الْمَوْصُولُ الْمُؤَنَّثُ غَيْرُ الْعَاقِلِ : السَّاعَةُ الَّتِي مَعَكَ مَكْسُورَةٌ .
لِمَنِ الْحَقِيبَةُ الَّتِي عَلَى الْمَكْتَبِ ؟$$, 18, 18, 3);

  update public.rules
  set
    sort_order = 5,
    title = 'كَسْرُ تَاءِ التَّأْنِيثِ عِنْدَ الْتِقَاءِ السَّاكِنَيْنِ (касра при встрече двух сукунов)',
    rule_ar = 'إِذَا الْتَقَتْ تَاءُ التَّأْنِيثِ السَّاكِنَةُ بِـ«أَلْ»، حُرِّكَتِ التَّاءُ بِالْكَسْرَةِ لِلتَّخَلُّصِ مِنَ الْتِقَاءِ السَّاكِنَيْنِ.',
    summary = 'إِذَا الْتَقَتْ تَاءُ التَّأْنِيثِ السَّاكِنَةُ بِـ«أَلْ»، حُرِّكَتِ التَّاءُ بِالْكَسْرَةِ لِلتَّخَلُّصِ مِنَ الْتِقَاءِ السَّاكِنَيْنِ.',
    rule_kind = 'important',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило чтения</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا الْتَقَتْ تَاءُ التَّأْنِيثِ السَّاكِنَةُ بِـ«أَلْ»، حُرِّكَتِ التَّاءُ بِالْكَسْرَةِ لِلتَّخَلُّصِ مِنَ الْتِقَاءِ السَّاكِنَيْنِ.</span><p class="rule-study-text">Если глагол на неподвижную <span dir="rtl" lang="ar">تْ</span> оказывается перед словом с артиклем <span dir="rtl" lang="ar">أَلْ</span>, при слитном чтении <span dir="rtl" lang="ar">تْ</span> получает вспомогательную касру.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Схема автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبَتْ + اَلْـ ← ذَهَبَتِ اَلْـ</span><span class="rule-example-ru">Неподвижная تْ перед артиклем произносится как تِ.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبَتِ الطَّالِبَةُ.</span><span class="rule-example-ru">Студентка ушла.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الْفَتَاةُ الَّتِي خَرَجَتِ الْآنَ بِنْتُ عَمِّي.</span><span class="rule-example-ru">Девушка, которая сейчас вышла, — дочь моего дяди.</span></div></div></div></div>$$
  where id = sukuns_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (sukuns_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$ذَهَبَتِ الطَّالِبَةُ : أَصْلُهُ : ذَهَبَتْ الطَّالِبَةُ ← ذَهَبَتْ + اَلْ ذَهَبَتِ اَلْ .$$, 18, 18, 1),
    (sukuns_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْفَتَاةُ الَّتِي خَرَجَتِ الْآنَ بِنْتُ عَمِّي .$$, 18, 18, 2);
end;
$migration$;

commit;
