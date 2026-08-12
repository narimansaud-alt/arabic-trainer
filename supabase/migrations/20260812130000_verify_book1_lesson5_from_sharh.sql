-- Verify Medina Book 1 lesson 5 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF page 9.

begin;

do $migration$
declare
  target_rule_id bigint;
begin
  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '5'
  );

  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '5'
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '5'
    and sort_order = 1;

  update public.rules
  set
    title = 'الْمُضَافُ وَالْمُضَافُ إِلَيْهِ (первый и второй члены идафы)',
    rule_ar = 'فِي الْإِضَافَةِ يُحْذَفُ التَّنْوِينُ وَأَلْ مِنَ الْمُضَافِ، وَيَكُونُ الْمُضَافُ إِلَيْهِ مَجْرُورًا بِالْكَسْرَةِ.',
    summary = 'فِي الْإِضَافَةِ يُحْذَفُ التَّنْوِينُ وَأَلْ مِنَ الْمُضَافِ، وَيَكُونُ الْمُضَافُ إِلَيْهِ مَجْرُورًا بِالْكَسْرَةِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">فِي الْإِضَافَةِ يُحْذَفُ التَّنْوِينُ وَأَلْ مِنَ الْمُضَافِ، وَيَكُونُ الْمُضَافُ إِلَيْهِ مَجْرُورًا بِالْكَسْرَةِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">الْمُضَافُ</span> — первый член идафы: у него не бывает танвина и артикля <span dir="rtl" lang="ar">أَلْ</span>. <span dir="rtl" lang="ar">الْمُضَافُ إِلَيْهِ</span> — второй член идафы; он стоит в состоянии <span dir="rtl" lang="ar">مَجْرُورٌ</span> с касрой.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Схема</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">كِتَابُ مُحَمَّدٍ</span><span class="rule-term-ru">книга Мухаммада</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">بِنْتُ حَامِدٍ</span><span class="rule-term-ru">дочь Хамида</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">كِتَابُ اللَّهِ</span><span class="rule-term-ru">Книга Аллаха</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Три проверки</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">كِتَابُ مُحَمَّدٍ ✓ — كِتَابٌ مُحَمَّدٍ ✕</span><span class="rule-example-ru">У первого члена удаляется танвин.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">كِتَابُ مُحَمَّدٍ ✓ — الْكِتَابُ مُحَمَّدٍ ✕</span><span class="rule-example-ru">У первого члена удаляется артикль.</span></div><div class="rule-example-card rule-term-jarr"><span class="rule-example-ar" dir="rtl" lang="ar">كِتَابُ مُحَمَّدٍ ✓ — كِتَابُ مُحَمَّدٌ ✕</span><span class="rule-example-ru">Второй член получает касру.</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْمُضَافُ، وَالْمُضَافُ إِلَيْهِ

كِتَابٌ : مُحَمَّدٌ ← كِتَابُ مُحَمَّدٍ
بِنْتٌ : حَامِدٌ ← بِنْتُ حَامِدٍ
كِتَابٌ : اللَّهُ ← كِتَابُ اللَّهِ$$,
      9,
      9,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$كِتَابٌ مُحَمَّدٍ ✕
كِتَابُ مُحَمَّدٍ ✓ ( يُحْذَفُ التَّنْوِينُ عِنْدَ الْإِضَافَةِ ) .

الْكِتَابُ مُحَمَّدٍ ✕
كِتَابُ مُحَمَّدٍ ✓ ( تُحْذَفُ أَلْ عِنْدَ الْإِضَافَةِ ) .

كِتَابُ مُحَمَّدٌ ✕
كِتَابُ مُحَمَّدٍ ✓ ( الْمُضَافُ إِلَيْهِ مَجْرُورٌ بِالْكَسْرَةِ : مُحَمَّدٍ ) .$$,
      9,
      9,
      2
    );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '5'
    and sort_order = 2;

  update public.rules
  set
    title = 'الْمُنَادَى وَيَا (обращение с частицей يَا)',
    rule_ar = 'الْمُنَادَى هُوَ مَنْ تَدْعُوهُ بِـيَا، وَيُحْذَفُ التَّنْوِينُ مِنَ الِاسْمِ عِنْدَ النِّدَاءِ.',
    summary = 'الْمُنَادَى هُوَ مَنْ تَدْعُوهُ بِـيَا، وَيُحْذَفُ التَّنْوِينُ مِنَ الِاسْمِ عِنْدَ النِّدَاءِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الْمُنَادَى هُوَ مَنْ تَدْعُوهُ بِـيَا، وَيُحْذَفُ التَّنْوِينُ مِنَ الِاسْمِ عِنْدَ النِّدَاءِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">الْمُنَادَى</span> — тот, к кому обращаются с <span dir="rtl" lang="ar">يَا</span>. При обращении танвин имени удаляется.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">يَا مُحَمَّدُ</span><span class="rule-term-ru">о Мухаммад!</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">يَا أُسْتَاذُ</span><span class="rule-term-ru">о учитель!</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">يَا وَلَدُ</span><span class="rule-term-ru">о мальчик!</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">يَا بِنْتُ</span><span class="rule-term-ru">о девочка!</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Окончание</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">يَا شَيْخُ ✓</span><span class="rule-example-ru">Правильно: одна дамма без танвина.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">يَا شَيْخٌ ✕</span><span class="rule-example-ru">Неверно: танвин при таком обращении удаляется.</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Sharkh_na_1_tom_Med_kursa.pdf',
    $$الْمُنَادَى

الْمُنَادَى : هُوَ بِمَعْنَى أَنْ تَقُولَ لِصَدِيقِكَ تَعَالَ .

يَا مُحَمَّدُ . يَا أُسْتَاذُ . يَا وَلَدُ . يَا بِنْتُ .

يَا شَيْخٌ ✕
يَا شَيْخُ ✓ ( يُحْذَفُ التَّنْوِينُ عِنْدَ النِّدَاءِ ) .$$,
    9,
    9,
    1
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '5'
    and sort_order = 3;

  update public.rules
  set
    title = 'كِتَابُ مَنْ هٰذَا؟ (вопрос о владельце)',
    rule_ar = 'يُسْأَلُ عَنْ مَالِكِ الشَّيْءِ الْعَاقِلِ بِـمَنْ، نَحْوُ: كِتَابُ مَنْ هٰذَا؟.',
    summary = 'يُسْأَلُ عَنْ مَالِكِ الشَّيْءِ الْعَاقِلِ بِـمَنْ، نَحْوُ: كِتَابُ مَنْ هٰذَا؟.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">يُسْأَلُ عَنْ مَالِكِ الشَّيْءِ الْعَاقِلِ بِـمَنْ، نَحْوُ: كِتَابُ مَنْ هٰذَا؟</span><p class="rule-study-text">Чтобы спросить, кому принадлежит предмет, перед <span dir="rtl" lang="ar">مَنْ</span> ставят название предмета: <span dir="rtl" lang="ar">كِتَابُ مَنْ هٰذَا؟</span> — «Чья это книга?»</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">كِتَابُ مَنْ هٰذَا؟ هٰذَا كِتَابُ مُحَمَّدٍ.</span><span class="rule-example-ru">Чья это книга? Это книга Мухаммада.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">قَلَمُ مَنْ هٰذَا؟ هٰذَا قَلَمُ خَالِدٍ.</span><span class="rule-example-ru">Чья это ручка? Это ручка Халида.</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$كِتَابُ مَنْ هَذَا؟ سُؤَالٌ عَنِ الْعَاقِلِ ← هَذَا كِتَابُ مُحَمَّدٍ .
قَلَمُ مَنْ هَذَا؟ هَذَا قَلَمُ خَالِدٍ .$$,
      9,
      9,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$أَمْثِلَةٌ أُخْرَى لِلْمُضَافِ، وَالْمُضَافِ إِلَيْهِ : خَالُ حَامِدٍ فَقِيرٌ .
مَا اسْمُ الرَّجُلِ؟ اِبْنُ مَنْ أَنْتَ؟ أَنَا اِبْنُ خَالِدٍ . مَا اسْمُ الْبِنْتِ؟ اسْمُ الْبِنْتِ زَيْنَبُ .$$,
      9,
      9,
      2
    );
end;
$migration$;

commit;
