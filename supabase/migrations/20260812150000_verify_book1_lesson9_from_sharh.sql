-- Verify Medina Book 1 lesson 9 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF page 13.

begin;

do $migration$
declare
  adjective_rule_id bigint;
  relative_rule_id bigint;
begin
  select id into strict adjective_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '9'
    and sort_order = 1;

  select id into strict relative_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '9'
    and sort_order = 3;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '9'
  );

  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '9'
  );

  delete from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '9'
    and id not in (adjective_rule_id, relative_rule_id);

  update public.rules
  set
    sort_order = 1,
    title = 'النَّعْتُ وَالْمَنْعُوتُ (определение и определяемое имя)',
    rule_ar = 'يَتْبَعُ النَّعْتُ الْمَنْعُوتَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَالتَّعْرِيفِ وَالتَّنْكِيرِ، وَالْإِعْرَابِ، وَالْإِفْرَادِ.',
    summary = 'يَتْبَعُ النَّعْتُ الْمَنْعُوتَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَالتَّعْرِيفِ وَالتَّنْكِيرِ، وَالْإِعْرَابِ، وَالْإِفْرَادِ.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">يَتْبَعُ النَّعْتُ الْمَنْعُوتَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَالتَّعْرِيفِ وَالتَّنْكِيرِ، وَالْإِعْرَابِ، وَالْإِفْرَادِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">الْمَنْعُوتُ</span> — определяемое имя; <span dir="rtl" lang="ar">النَّعْتُ</span> — его определение. В этом уроке определение следует за определяемым именем и согласуется с ним по четырём признакам.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Четыре признака согласования</span><table><thead><tr><th>Арабский термин</th><th>Русский смысл</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">التَّذْكِيرُ وَالتَّأْنِيثُ</span></td><td>мужской или женский род</td></tr><tr><td><span dir="rtl" lang="ar">التَّعْرِيفُ وَالتَّنْكِيرُ</span></td><td>определённость или неопределённость</td></tr><tr><td><span dir="rtl" lang="ar">الْإِعْرَابُ</span></td><td>одинаковое падежное состояние и окончание</td></tr><tr><td><span dir="rtl" lang="ar">الْإِفْرَادُ</span></td><td>форма единственного числа</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Правильные образцы из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الرَّجُلُ الْكَرِيمُ طَبِيبٌ.</span><span class="rule-example-ru">Этот благородный мужчина — врач.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">عَبَّاسٌ تَاجِرٌ غَنِيٌّ.</span><span class="rule-example-ru">Аббас — богатый торговец.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الْعَرَبِيَّةُ لُغَةٌ جَمِيلَةٌ.</span><span class="rule-example-ru">Арабский язык — красивый язык.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">الْمِرْوَحَةُ فِي الْغُرْفَةِ الْكَبِيرَةِ.</span><span class="rule-example-ru">Вентилятор находится в большой комнате.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">الْكُوبُ لِلْمُدَرِّسِ الْجَدِيدِ.</span><span class="rule-example-ru">Стакан принадлежит новому преподавателю.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Сверка форм</span><table><thead><tr><th>Форма, отмеченная в шархе знаком ✕</th><th>Исправленная форма</th><th>Нарушенный признак</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">هَذَا الرَّجُلُ كَرِيمٌ طَبِيبٌ</span></td><td><span dir="rtl" lang="ar">هَذَا الرَّجُلُ الْكَرِيمُ طَبِيبٌ</span></td><td>определённость</td></tr><tr><td><span dir="rtl" lang="ar">عَبَّاسٌ تَاجِرٌ الْغَنِيُّ</span></td><td><span dir="rtl" lang="ar">عَبَّاسٌ تَاجِرٌ غَنِيٌّ</span></td><td>неопределённость</td></tr><tr><td><span dir="rtl" lang="ar">الْعَرَبِيَّةُ لُغَةٌ جَمِيلٌ</span></td><td><span dir="rtl" lang="ar">الْعَرَبِيَّةُ لُغَةٌ جَمِيلَةٌ</span></td><td>женский род</td></tr><tr><td><span dir="rtl" lang="ar">لِمَنْ: تِلْكَ السَّيَّارَةُ الْجَدِيدَةِ</span></td><td><span dir="rtl" lang="ar">لِمَنْ تِلْكَ السَّيَّارَةُ الْجَدِيدَةُ؟</span></td><td>падеж</td></tr><tr><td><span dir="rtl" lang="ar">الْمِرْوَحَةُ فِي الْغُرْفَةِ الْكَبِيرُ</span></td><td><span dir="rtl" lang="ar">الْمِرْوَحَةُ فِي الْغُرْفَةِ الْكَبِيرَةِ.</span></td><td>род и падеж</td></tr><tr><td><span dir="rtl" lang="ar">الْكُوبُ لِلْمُدَرِّسِ الْجَدِيدَةِ</span></td><td><span dir="rtl" lang="ar">الْكُوبُ لِلْمُدَرِّسِ الْجَدِيدِ.</span></td><td>род</td></tr></tbody></table></div></div>$$
  where id = adjective_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      adjective_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$النَّعْتُ، وَالْمَنْعُوتُ

هَذَا الرَّجُلُ الْكَرِيمُ طَبِيبٌ .
عَبَّاسٌ تَاجِرٌ غَنِيٌّ .
الْعَرَبِيَّةُ لُغَةٌ جَمِيلَةٌ .
الْمِرْوَحَةُ فِي الْغُرْفَةِ الْكَبِيرَةِ .
الْكُوبُ لِلْمُدَرِّسِ الْجَدِيدِ .$$,
      13,
      13,
      1
    ),
    (
      adjective_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$هَذَا الرَّجُلُ كَرِيمٌ طَبِيبٌ ✕
عَبَّاسٌ تَاجِرٌ الْغَنِيُّ ✕
الْعَرَبِيَّةُ لُغَةٌ جَمِيلٌ ✕
لِمَنْ : تِلْكَ السَّيَّارَةُ الْجَدِيدَةِ ✕
الْمِرْوَحَةُ فِي الْغُرْفَةِ الْكَبِيرُ ✕
الْكُوبُ لِلْمُدَرِّسِ الْجَدِيدَةِ ✕$$,
      13,
      13,
      2
    ),
    (
      adjective_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$( النَّعْتُ يَتْبَعُ الْمَنْعُوتَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَالتَّعْرِيفِ وَالتَّنْكِيرِ، وَالإِعْرَابِ، وَالإِفْرَادِ . )$$,
      13,
      13,
      3
    );

  update public.rules
  set
    sort_order = 2,
    title = 'الِاسْمُ الْمَوْصُولُ: الَّذِي (относительное имя «который»)',
    rule_ar = 'الَّذِي اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    summary = 'الَّذِي اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الَّذِي اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">الَّذِي</span> — относительное имя «который». Оно употребляется с одним словом мужского рода — как обозначающим разумное лицо, так и неразумный предмет.</p></div><div class="rule-study-card"><span class="rule-card-kicker">С разумным</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّالِبُ الَّذِي خَرَجَ مِنَ الْهِنْدِ</span><span class="rule-example-ru">Студент, который вышел из Индии.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنِ الْوَلَدُ الصَّغِيرُ الَّذِي خَرَجَ؟</span><span class="rule-example-ru">Кто тот маленький мальчик, который вышел?</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الْمُدَرِّسُ الَّذِي جَلَسَ عَلَى الْكُرْسِيِّ جَدِيدٌ.</span><span class="rule-example-ru">Преподаватель, который сел на стул, — новый.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">С неразумным</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">الْكِتَابُ الَّذِي عَلَى الْمَكْتَبِ لِلْمُدَرِّسِ.</span><span class="rule-example-ru">Книга, которая лежит на столе, принадлежит преподавателю.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنِ الْقَلَمُ الَّذِي عَلَى الْمَكْتَبِ؟</span><span class="rule-example-ru">Кому принадлежит ручка, которая лежит на столе?</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">الْبَيْتُ الْكَبِيرُ الَّذِي فِي الشَّارِعِ لِلْوَزِيرِ.</span><span class="rule-example-ru">Большой дом, который находится на улице, принадлежит министру.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Варианты без الَّذِي</span><p class="rule-study-text">Для требуемого здесь значения «который» относительное имя <span dir="rtl" lang="ar">الَّذِي</span> должно присутствовать. Шарх отмечает следующие варианты без него знаком ✕.</p><div class="rule-example-list"><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">مَنِ الْوَلَدُ الصَّغِيرُ خَرَجَ؟ ✕</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">الْكِتَابُ عَلَى الْمَكْتَبِ لِلْمُدَرِّسِ. ✕</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنِ الْقَلَمُ عَلَى الْمَكْتَبِ. ✕</span></div></div></div></div>$$
  where id = relative_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      relative_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الَّذِي : اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ .$$,
      13,
      13,
      1
    ),
    (
      relative_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْعَاقِلُ
الطَّالِبُ الَّذِي خَرَجَ مِنَ الْهِنْدِ
مَنِ الْوَلَدُ الصَّغِيرُ الَّذِي خَرَجَ ؟
الْمُدَرِّسُ الَّذِي جَلَسَ عَلَى الْكُرْسِيِّ جَدِيدٌ .

غَيْرُ الْعَاقِلِ
الْكِتَابُ الَّذِي عَلَى الْمَكْتَبِ لِلْمُدَرِّسِ
لِمَنِ الْقَلَمُ الَّذِي عَلَى الْمَكْتَبِ ؟
الْبَيْتُ الْكَبِيرُ الَّذِي فِي الشَّارِعِ لِلْوَزِيرِ .$$,
      13,
      13,
      2
    ),
    (
      relative_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$مَنِ الْوَلَدُ الصَّغِيرُ خَرَجَ ؟ ✕
الْكِتَابُ عَلَى الْمَكْتَبِ لِلْمُدَرِّسِ . ✕
لِمَنِ الْقَلَمُ عَلَى الْمَكْتَبِ . ✕$$,
      13,
      13,
      3
    );
end;
$migration$;

commit;
