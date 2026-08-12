-- Verify Medina Book 1 lesson 4 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF page 8.

begin;

do $migration$
declare
  target_rule_id bigint;
begin
  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '4'
  );

  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '4'
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '4'
    and sort_order = 1;

  update public.rules
  set
    title = 'حُرُوفُ الْجَرِّ: فِي، عَلَى، مِنْ، إِلَى (предлоги и родительный падеж)',
    rule_ar = 'حُرُوفُ الْجَرِّ تَجُرُّ الِاسْمَ الَّذِي بَعْدَهَا بِالْكَسْرَةِ، وَهِيَ هُنَا: فِي، عَلَى، مِنْ، إِلَى.',
    summary = 'حُرُوفُ الْجَرِّ تَجُرُّ الِاسْمَ الَّذِي بَعْدَهَا بِالْكَسْرَةِ، وَهِيَ هُنَا: فِي، عَلَى، مِنْ، إِلَى.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">حُرُوفُ الْجَرِّ تَجُرُّ الِاسْمَ الَّذِي بَعْدَهَا بِالْكَسْرَةِ، وَهِيَ هُنَا: فِي، عَلَى، مِنْ، إِلَى.</span><p class="rule-study-text">Предлог ставит следующее за ним имя в состояние <span dir="rtl" lang="ar">مَجْرُورٌ</span>; в данных примерах его признак — касра.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Значения</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">فِي</span><span class="rule-term-ru">в</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">عَلَى</span><span class="rule-term-ru">на</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">مِنْ</span><span class="rule-term-ru">из / от</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">إِلَى</span><span class="rule-term-ru">к / в направлении</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><table><thead><tr><th>Предлог</th><th>Арабский пример</th><th>Перевод</th></tr></thead><tbody><tr><td dir="rtl" lang="ar">فِي</td><td dir="rtl" lang="ar">مُحَمَّدٌ فِي الْبَيْتِ.</td><td>Мухаммад в доме.</td></tr><tr><td dir="rtl" lang="ar">فِي</td><td dir="rtl" lang="ar">يَاسِرٌ فِي الْغُرْفَةِ.</td><td>Ясир в комнате.</td></tr><tr><td dir="rtl" lang="ar">فِي</td><td dir="rtl" lang="ar">آمِنَةُ فِي الْمَطْبَخِ.</td><td>Амина на кухне.</td></tr><tr><td dir="rtl" lang="ar">عَلَى</td><td dir="rtl" lang="ar">الْقَلَمُ عَلَى الْمَكْتَبِ.</td><td>Ручка на столе.</td></tr><tr><td dir="rtl" lang="ar">عَلَى</td><td dir="rtl" lang="ar">الطِّفْلُ عَلَى السَّرِيرِ.</td><td>Ребёнок на кровати.</td></tr><tr><td dir="rtl" lang="ar">عَلَى</td><td dir="rtl" lang="ar">الطَّالِبُ عَلَى الْكُرْسِيِّ.</td><td>Студент на стуле.</td></tr><tr><td dir="rtl" lang="ar">مِنْ</td><td dir="rtl" lang="ar">خَرَجَ الْمُدَرِّسُ مِنَ الْفَصْلِ.</td><td>Преподаватель вышел из класса.</td></tr><tr><td dir="rtl" lang="ar">مِنْ</td><td dir="rtl" lang="ar">فَاطِمَةُ مِنَ الْهِنْدِ.</td><td>Фатима из Индии.</td></tr><tr><td dir="rtl" lang="ar">مِنْ</td><td dir="rtl" lang="ar">هٰذَا الْقَلَمُ مِنْ مُحَمَّدٍ.</td><td>Эта ручка от Мухаммада.</td></tr><tr><td dir="rtl" lang="ar">إِلَى</td><td dir="rtl" lang="ar">ذَهَبَ خَالِدٌ إِلَى الْمَعْهَدِ.</td><td>Халид пошёл в институт.</td></tr><tr><td dir="rtl" lang="ar">إِلَى</td><td dir="rtl" lang="ar">ذَهَبَ عَلِيٌّ إِلَى الْمُدِيرِ.</td><td>Али пошёл к директору.</td></tr><tr><td dir="rtl" lang="ar">إِلَى</td><td dir="rtl" lang="ar">ذَهَبَ الطَّالِبُ إِلَى الْمِرْحَاضِ.</td><td>Студент пошёл в уборную.</td></tr></tbody></table></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$حُرُوفُ الْجَرِّ ( فِي، عَلَى، مِنْ، إِلَى )
حُرُوفُ الْجَرِّ : يُجَرُّ الِاسْمُ الَّذِي بَعْدَهَا بِالْكَسْرَةِ .$$,
      8,
      8,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$مُحَمَّدٌ فِي الْبَيْتِ . يَاسِرٌ فِي الْغُرْفَةِ . آمِنَةُ فِي الْمَطْبَخِ .
الْقَلَمُ عَلَى الْمَكْتَبِ . الطِّفْلُ عَلَى السَّرِيرِ . الطَّالِبُ عَلَى الْكُرْسِيِّ .
خَرَجَ الْمُدَرِّسُ مِنَ الْفَصْلِ . فَاطِمَةُ مِنَ الْهِنْدِ . هَذَا الْقَلَمُ مِنْ مُحَمَّدٍ .
ذَهَبَ خَالِدٌ إِلَى الْمَعْهَدِ . ذَهَبَ عَلِيٌّ إِلَى الْمُدِيرِ . ذَهَبَ الطَّالِبُ إِلَى الْمِرْحَاضِ .$$,
      8,
      8,
      2
    );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '4'
    and sort_order = 2;

  update public.rules
  set
    title = 'أَيْنَ؟ (где? — вопрос о месте)',
    rule_ar = 'أَيْنَ اِسْمُ اسْتِفْهَامٍ يُسْأَلُ بِهِ عَنِ الْمَكَانِ.',
    summary = 'أَيْنَ اِسْمُ اسْتِفْهَامٍ يُسْأَلُ بِهِ عَنِ الْمَكَانِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">أَيْنَ اِسْمُ اسْتِفْهَامٍ يُسْأَلُ بِهِ عَنِ الْمَكَانِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">أَيْنَ؟</span> означает «где?» и служит для вопроса о месте.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ مُحَمَّدٌ؟ مُحَمَّدٌ فِي الْغُرْفَةِ.</span><span class="rule-example-ru">Где Мухаммад? Мухаммад в комнате.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ فَاطِمَةُ؟ فَاطِمَةُ فِي الْمَطْبَخِ.</span><span class="rule-example-ru">Где Фатима? Фатима на кухне.</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Sharkh_na_1_tom_Med_kursa.pdf',
    $$أَيْنَ؟ سُؤَالٌ عَنِ الْمَكَانِ .

أَيْنَ مُحَمَّدٌ؟ مُحَمَّدٌ فِي الْغُرْفَةِ .
أَيْنَ فَاطِمَةُ؟ فَاطِمَةُ فِي الْمَطْبَخِ .$$,
    8,
    8,
    1
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '4'
    and sort_order = 3;

  update public.rules
  set
    title = 'مَاذَا؟ (что? — вопрос о неразумном)',
    rule_ar = 'مَاذَا تُسْتَعْمَلُ لِلسُّؤَالِ عَنْ غَيْرِ الْعَاقِلِ، وَهِيَ بِمَعْنَى مَا هٰذَا؟.',
    summary = 'مَاذَا تُسْتَعْمَلُ لِلسُّؤَالِ عَنْ غَيْرِ الْعَاقِلِ، وَهِيَ بِمَعْنَى مَا هٰذَا؟.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">مَاذَا تُسْتَعْمَلُ لِلسُّؤَالِ عَنْ غَيْرِ الْعَاقِلِ، وَهِيَ بِمَعْنَى مَا هٰذَا؟.</span><p class="rule-study-text"><span dir="rtl" lang="ar">مَاذَا؟</span> означает «что?» и в этом уроке равнозначно вопросу <span dir="rtl" lang="ar">مَا هٰذَا؟</span> о неразумном.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَاذَا عَلَى الْمَكْتَبِ؟ الْقَلَمُ عَلَى الْمَكْتَبِ.</span><span class="rule-example-ru">Что на столе? Ручка на столе.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَاذَا عَلَى السَّرِيرِ؟ السَّاعَةُ عَلَى السَّرِيرِ.</span><span class="rule-example-ru">Что на кровати? Часы на кровати.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَاذَا عَلَى الْمَكْتَبِ؟ مُحَمَّدٌ عَلَى الْمَكْتَبِ. ✕</span><span class="rule-example-ru">Неверно: вопрос مَاذَا не задают о Мухаммаде.</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Sharkh_na_1_tom_Med_kursa.pdf',
    $$مَاذَا؟ = مَا هَذَا؟ لِغَيْرِ الْعَاقِلِ .

مَاذَا عَلَى الْمَكْتَبِ؟ الْقَلَمُ عَلَى الْمَكْتَبِ ✓
مَاذَا عَلَى السَّرِيرِ؟ السَّاعَةُ عَلَى السَّرِيرِ ✓
مَاذَا عَلَى الْمَكْتَبِ؟ مُحَمَّدٌ عَلَى الْمَكْتَبِ ✕$$,
    8,
    8,
    1
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '4'
    and sort_order = 4;

  update public.rules
  set
    title = 'الْعَلَمُ الْمُؤَنَّثُ لَا يُنَوَّنُ (женское имя собственное не принимает танвин)',
    rule_ar = 'الْعَلَمُ الْمُؤَنَّثُ لَا يُنَوَّنُ.',
    summary = 'الْعَلَمُ الْمُؤَنَّثُ لَا يُنَوَّنُ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الْعَلَمُ الْمُؤَنَّثُ لَا يُنَوَّنُ.</span><p class="rule-study-text">Женское имя собственное не принимает танвин.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Формы из шарха</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">عَائِشَةُ</span><span class="rule-term-ru">Аиша</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">آمِنَةُ</span><span class="rule-term-ru">Амина</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">فَاطِمَةُ</span><span class="rule-term-ru">Фатима</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">مَرْيَمُ</span><span class="rule-term-ru">Марьям</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Sharkh_na_1_tom_Med_kursa.pdf',
    $$( الْعَلَمُ الْمُؤَنَّثُ لَا يُنَوَّنُ )

عَائِشَةُ، آمِنَةُ، فَاطِمَةُ، مَرْيَمُ$$,
    8,
    8,
    1
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '4'
    and sort_order = 5;

  update public.rules
  set
    title = 'مِنَ الْبَيْتِ وَالْتِقَاءُ السَّاكِنَيْنِ (фатха для устранения встречи двух сукунов)',
    rule_ar = 'فِي مِنَ الْبَيْتِ حُرِّكَتِ النُّونُ بِالْفَتْحَةِ مَنْعًا لِالْتِقَاءِ السَّاكِنَيْنِ.',
    summary = 'فِي مِنَ الْبَيْتِ حُرِّكَتِ النُّونُ بِالْفَتْحَةِ مَنْعًا لِالْتِقَاءِ السَّاكِنَيْنِ.',
    rule_kind = 'important',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">فِي مِنَ الْبَيْتِ حُرِّكَتِ النُّونُ بِالْفَتْحَةِ مَنْعًا لِالْتِقَاءِ السَّاكِنَيْنِ.</span><p class="rule-study-text">В сочетании <span dir="rtl" lang="ar">مِنَ الْبَيْتِ</span> нун слова <span dir="rtl" lang="ar">مِنْ</span> получает фатху, чтобы не встретились два сукуна.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Схема</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مِنْ + أَلْـ ← مِنَ الْـ</span><span class="rule-example-ru">مِنْ перед словом с артиклем читается مِنَ</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مِنَ الْبَيْتِ</span><span class="rule-example-ru">из дома</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Sharkh_na_1_tom_Med_kursa.pdf',
    $$مِنَ الْبَيْتِ : أَصْلُهُ : مِنْ + ال ← مِنَ الـ . حُرِّكَتِ النُّونُ بِالْفَتْحَةِ مَنْعًا لِالْتِقَاءِ السَّاكِنَيْنِ .$$,
    8,
    8,
    1
  );

  delete from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '4'
    and sort_order > 5;
end;
$migration$;

commit;
