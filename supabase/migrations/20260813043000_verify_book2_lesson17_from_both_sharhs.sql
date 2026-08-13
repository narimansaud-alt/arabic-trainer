-- Verify Medina Book 2 lesson 17 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 40-42.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 34-36.
-- The source fragments below are kept separately from the formulated rule_ar.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
  rule_4_id bigint;
  rule_5_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '17';

  if lesson_rule_count <> 5 then
    raise exception 'Expected 5 Book 2 lesson 17 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '17' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '17' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '17' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '17' and sort_order = 4;
  select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '17' and sort_order = 5;

  delete from public.rule_sections
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);

  -- 1. Nasb particles, the complete ten-form table, and nasb signs.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'نَوَاصِبُ الْفِعْلِ الْمُضَارِعِ (средства постановки глагола настоящего времени в состояние насба)',
    rule_ar = 'تَنْصِبُ «أَنْ» وَ«لَنْ» الْفِعْلَ الْمُضَارِعَ، وَيُنْصَبُ الْمُضَارِعُ بَعْدَ لَامِ التَّعْلِيلِ بِـ«أَنْ» مُضْمَرَةٍ؛ وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ، أَوْ حَذْفُ النُّونِ فِي الْأَفْعَالِ الْخَمْسَةِ، وَالْمُضَارِعُ الْمُسْنَدُ إِلَى نُونِ النِّسْوَةِ مَبْنِيٌّ عَلَى السُّكُونِ.',
    summary = 'Три объяснённых в двух шархах средства насба, их значения, полная таблица десяти форм и признаки изменения окончания.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три средства насба</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَنْ</span> وَ<span class="ar-tone-particle">لَنْ</span> تَنْصِبَانِ <span class="ar-tone-verb">الْفِعْلَ الْمُضَارِعَ</span>، وَيُنْصَبُ الْمُضَارِعُ بَعْدَ <span class="ar-tone-particle">لَامِ التَّعْلِيلِ</span> بِـ<span class="ar-tone-particle">«أَنْ» مُضْمَرَةٍ</span>.</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">أَنْ</span><span class="rule-term-ru">«чтобы; что сделать» — частица насба, относящая последующее действие к будущему</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">لَنْ</span><span class="rule-term-ru">«не сделает / не будет делать» — частица отрицания будущего и насба</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">لَامُ التَّعْلِيلِ</span><span class="rule-term-ru">лям причины или цели — «чтобы; для того чтобы»; после неё подразумевается скрытая частица <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَنْ</span></span></div>
        </div>
        <div class="rule-check-card"><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَنْ</span> وَ<span class="ar-tone-particle">لَامُ التَّعْلِيلِ</span> لَا تَأْتِيَانِ فِي أَوَّلِ الْكَلَامِ، وَأَمَّا <span class="ar-tone-particle">لَنْ</span> فَتَأْتِي فِي أَوَّلِهِ وَوَسَطِهِ.</span><span>Частица «чтобы» и лям цели не начинают высказывание; частица будущего отрицания встречается и в начале, и в середине.</span></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полная таблица десяти форм из второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Лицо, число и род</th><th><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">أَنْ</span><span class="rule-table-ru">«чтобы»</span></th><th><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">لَنْ</span><span class="rule-table-ru">отрицание будущего</span></th><th><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">لَامُ التَّعْلِيلِ</span><span class="rule-table-ru">«для того чтобы»</span></th></tr></thead>
          <tbody>
            <tr><td>Он, ед. ч.</td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَامِدٌ يَجِبُ أَنْ <span class="ar-tone-verb">يَذْهَبَ</span>.</span><span class="rule-table-ru">Хамид должен пойти.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَامِدٌ لَنْ <span class="ar-tone-verb">يَذْهَبَ</span>.</span><span class="rule-table-ru">Хамид не пойдёт.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجَ حَامِدٌ <span class="ar-tone-verb">لِيَذْهَبَ</span> إِلَى الْمَطْعَمِ.</span><span class="rule-table-ru">Хамид вышел, чтобы пойти в столовую.</span></td></tr>
            <tr><td>Они, мужчины</td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطُّلَّابُ يَجِبُ أَنْ <span class="ar-tone-verb">يَذْهَبُوا</span>.</span><span class="rule-table-ru">Студенты должны пойти.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطُّلَّابُ لَنْ <span class="ar-tone-verb">يَذْهَبُوا</span>.</span><span class="rule-table-ru">Студенты не пойдут.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجَ الطُّلَّابُ <span class="ar-tone-verb">لِيَذْهَبُوا</span> إِلَى الْمَطْعَمِ.</span><span class="rule-table-ru">Студенты вышли, чтобы пойти в столовую.</span></td></tr>
            <tr><td>Она, ед. ч.</td><td><span class="rule-table-ar" dir="rtl" lang="ar">فَاطِمَةُ يَجِبُ أَنْ <span class="ar-tone-verb">تَذْهَبَ</span>.</span><span class="rule-table-ru">Фатима должна пойти.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فَاطِمَةُ لَنْ <span class="ar-tone-verb">تَذْهَبَ</span>.</span><span class="rule-table-ru">Фатима не пойдёт.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجَتْ فَاطِمَةُ <span class="ar-tone-verb">لِتَذْهَبَ</span> إِلَى الْمَطْعَمِ.</span><span class="rule-table-ru">Фатима вышла, чтобы пойти в столовую.</span></td></tr>
            <tr><td>Они, женщины</td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَاتُ يَجِبُ أَنْ <span class="ar-tone-verb">يَذْهَبْنَ</span>.</span><span class="rule-table-ru">Студентки должны пойти.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَاتُ لَنْ <span class="ar-tone-verb">يَذْهَبْنَ</span>.</span><span class="rule-table-ru">Студентки не пойдут.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجَتِ الطَّالِبَاتُ <span class="ar-tone-verb">لِيَذْهَبْنَ</span> إِلَى الْمَطْعَمِ.</span><span class="rule-table-ru">Студентки вышли, чтобы пойти в столовую.</span></td></tr>
            <tr><td>Ты, мужчина</td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَجِبُ أَنْ <span class="ar-tone-verb">تَذْهَبَ</span> يَا حَامِدُ.</span><span class="rule-table-ru">Тебе нужно пойти, Хамид.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ <span class="ar-tone-verb">تَذْهَبَ</span> يَا حَامِدُ.</span><span class="rule-table-ru">Ты не пойдёшь, Хамид.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَخَرَجْتَ <span class="ar-tone-verb">لِتَذْهَبَ</span> إِلَى الْمَطْعَمِ يَا حَامِدُ؟</span><span class="rule-table-ru">Ты вышел, чтобы пойти в столовую, Хамид?</span></td></tr>
            <tr><td>Вы, мужчины</td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَجِبُ أَنْ <span class="ar-tone-verb">تَذْهَبُوا</span>.</span><span class="rule-table-ru">Вам нужно пойти.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ <span class="ar-tone-verb">تَذْهَبُوا</span>.</span><span class="rule-table-ru">Вы не пойдёте.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَخَرَجْتُمْ <span class="ar-tone-verb">لِتَذْهَبُوا</span> إِلَى الْمَطْعَمِ؟</span><span class="rule-table-ru">Вы вышли, чтобы пойти в столовую?</span></td></tr>
            <tr><td>Ты, женщина</td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَجِبُ أَنْ <span class="ar-tone-verb">تَذْهَبِي</span> يَا فَاطِمَةُ.</span><span class="rule-table-ru">Тебе нужно пойти, Фатима.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ <span class="ar-tone-verb">تَذْهَبِي</span> يَا فَاطِمَةُ.</span><span class="rule-table-ru">Ты не пойдёшь, Фатима.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَخَرَجْتِ <span class="ar-tone-verb">لِتَذْهَبِي</span> إِلَى الْمَطْعَمِ يَا فَاطِمَةُ؟</span><span class="rule-table-ru">Ты вышла, чтобы пойти в столовую, Фатима?</span></td></tr>
            <tr><td>Вы, женщины</td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَجِبُ أَنْ <span class="ar-tone-verb">تَذْهَبْنَ</span>.</span><span class="rule-table-ru">Вам нужно пойти.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ <span class="ar-tone-verb">تَذْهَبْنَ</span>.</span><span class="rule-table-ru">Вы не пойдёте.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَخَرَجْتُنَّ <span class="ar-tone-verb">لِتَذْهَبْنَ</span> إِلَى الْمَطْعَمِ؟</span><span class="rule-table-ru">Вы вышли, чтобы пойти в столовую?</span></td></tr>
            <tr><td>Я</td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَجِبُ أَنْ <span class="ar-tone-verb">أَذْهَبَ</span>.</span><span class="rule-table-ru">Мне нужно пойти.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ <span class="ar-tone-verb">أَذْهَبَ</span>.</span><span class="rule-table-ru">Я не пойду.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجْتُ <span class="ar-tone-verb">لِأَذْهَبَ</span> إِلَى الْمَطْعَمِ.</span><span class="rule-table-ru">Я вышел, чтобы пойти в столовую.</span></td></tr>
            <tr><td>Мы</td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَجِبُ أَنْ <span class="ar-tone-verb">نَذْهَبَ</span>.</span><span class="rule-table-ru">Нам нужно пойти.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ <span class="ar-tone-verb">نَذْهَبَ</span>.</span><span class="rule-table-ru">Мы не пойдём.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجْنَا <span class="ar-tone-verb">لِنَذْهَبَ</span> إِلَى الْمَطْعَمِ.</span><span class="rule-table-ru">Мы вышли, чтобы пойти в столовую.</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Признаки формы</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-nasb" dir="rtl" lang="ar">لَنْ أَذْهَبَ، لَنْ تَذْهَبَ، لَنْ يَذْهَبَ، لَنْ نَذْهَبَ</span><span class="rule-term-ru">признак насба — фатха</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-nasb" dir="rtl" lang="ar">لَنْ يَذْهَبُوا، لَنْ تَذْهَبِي</span><span class="rule-term-ru">признак насба — удаление нуна</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">لَنْ يَذْهَبْنَ، لَنْ تَذْهَبْنَ</span><span class="rule-term-ru">формы с нуном женского множественного числа построены на сукуне</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس السابع عشر
نصب الفعل المضارع بـ "أن" ظاهرة ومضمرة
"أن": حرف نصب، ويدخل على الفعل المضارع وينصبه.
نحو: أريد أن أخرج (بمعنى أريد الخروج).
"أن أخرج" يسمى مصدرا مؤولا.
"لام التعليل": حرف جر.
يدخل على الفعل المضارع وينصبه بـ "أن" مضمرة بعدها.
نحو: خرجت لأشرب الماء، والأصل: خرجت لأن أشرب الماء.$$,
      40, 40, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$نَوَاصِبُ الْفِعْلِ الْمُضَارِعِ
مِنَ الْحُرُوفِ الَّتِي تَنْصِبُ الْفِعْلَ الْمُضَارِعَ: أَنْ، وَلَنْ، وَلَامُ التَّعْلِيلِ.
إِسْنَادُ الْفِعْلِ الْمُضَارِعِ الْمَنْصُوبِ إِلَى الضَّمَائِرِ
حَامِدٌ يَجِبُ أَنْ يَذْهَبَ | حَامِدٌ لَنْ يَذْهَبَ | خَرَجَ حَامِدٌ لِيَذْهَبَ إِلَى الْمَطْعَمِ
الطُّلَّابُ يَجِبُ أَنْ يَذْهَبُوا | الطُّلَّابُ لَنْ يَذْهَبُوا | خَرَجَ الطُّلَّابُ لِيَذْهَبُوا إِلَى الْمَطْعَمِ
فَاطِمَةُ يَجِبُ أَنْ تَذْهَبَ | فَاطِمَةُ لَنْ تَذْهَبَ | خَرَجَتْ فَاطِمَةُ لِتَذْهَبَ إِلَى الْمَطْعَمِ
الطَّالِبَاتُ يَجِبُ أَنْ يَذْهَبْنَ | الطَّالِبَاتُ لَنْ يَذْهَبْنَ | خَرَجَتِ الطَّالِبَاتُ لِيَذْهَبْنَ إِلَى الْمَطْعَمِ
يَجِبُ أَنْ تَذْهَبَ يَا حَامِدُ | لَنْ تَذْهَبَ يَا حَامِدُ | أَخَرَجْتَ لِتَذْهَبَ إِلَى الْمَطْعَمِ يَا حَامِدُ؟
يَجِبُ أَنْ تَذْهَبُوا | لَنْ تَذْهَبُوا | أَخَرَجْتُمْ لِتَذْهَبُوا إِلَى الْمَطْعَمِ؟
يَجِبُ أَنْ تَذْهَبِي يَا فَاطِمَةُ | لَنْ تَذْهَبِي يَا فَاطِمَةُ | أَخَرَجْتِ لِتَذْهَبِي إِلَى الْمَطْعَمِ يَا فَاطِمَةُ؟
يَجِبُ أَنْ تَذْهَبْنَ | لَنْ تَذْهَبْنَ | أَخَرَجْتُنَّ لِتَذْهَبْنَ إِلَى الْمَطْعَمِ؟
يَجِبُ أَنْ أَذْهَبَ | لَنْ أَذْهَبَ | خَرَجْتُ لِأَذْهَبَ إِلَى الْمَطْعَمِ
يَجِبُ أَنْ نَذْهَبَ | لَنْ نَذْهَبَ | خَرَجْنَا لِنَذْهَبَ إِلَى الْمَطْعَمِ
لَنْ أَذْهَبَ، لَنْ تَذْهَبَ، لَنْ يَذْهَبَ، لَنْ نَذْهَبَ: عَلَامَةُ النَّصْبِ الْفَتْحَةُ.
لَنْ يَذْهَبُوا، لَنْ تَذْهَبِي: عَلَامَةُ النَّصْبِ حَذْفُ النُّونِ.
لَنْ يَذْهَبْنَ، لَنْ تَذْهَبْنَ: مَبْنِيٌّ عَلَى السُّكُونِ.
أَنْ، وَلَامُ التَّعْلِيلِ لَا يَأْتِيَانِ فِي أَوَّلِ الْكَلَامِ، وَأَمَّا لَنْ فَتَأْتِي فِي أَوَّلِ الْكَلَامِ وَوَسَطِهِ.
أَنْ: حَرْفٌ يَنْصِبُ الْفِعْلَ الْمُضَارِعَ، وَيَجْعَلُهُ لِلْمُسْتَقْبَلِ: أُرِيدُ أَنْ أَسْأَلَكَ. أَيُمْكِنُكَ أَنْ تَخْرُجَ مَعِي غَدًا؟
لَنْ: حَرْفُ نَفْيٍ يَنْصِبُ الْفِعْلَ الْمُضَارِعَ، وَيَجْعَلُهُ لِلْمُسْتَقْبَلِ: لَنْ أَتْرُكَ الصَّلَاةَ أَبَدًا. أَنَا مُتْعَبٌ فَلَنْ أَلْعَبَ الْيَوْمَ.
لَامُ التَّعْلِيلِ: حَرْفُ جَرٍّ، وَالْفِعْلُ الْمُضَارِعُ بَعْدَهُ مَنْصُوبٌ بِأَنْ الْمُضْمَرَةِ (غَيْرِ ظَاهِرَةٍ): جِئْتُ لِأَتَعَلَّمَ (بِمَعْنَى: لِكَيْ أَتَعَلَّمَ). خَرَجَ مُحَمَّدٌ لِيَتَوَضَّأَ. نَدْرُسُ اللُّغَةَ الْعَرَبِيَّةَ لِنَفْهَمَ الْقُرْآنَ وَالْحَدِيثَ.$$, 34, 35, 2);

  -- 2. The interpreted masdar and all source i'rab blocks.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'الْمَصْدَرُ الْمُؤَوَّلُ وَإِعْرَابُهُ (толкуемый масдар и его грамматический разбор)',
    rule_ar = 'يُسَمَّى تَرْكِيبُ «أَنْ» مَعَ الْفِعْلِ الْمُضَارِعِ مَصْدَرًا مُؤَوَّلًا، وَيَأْخُذُ مَحَلَّهُ الْإِعْرَابِيَّ بِحَسَبِ مَوْقِعِهِ فِي الْجُمْلَةِ؛ فَيَكُونُ مَفْعُولًا بِهِ أَوْ فَاعِلًا.',
    summary = 'Конструкция из частицы «чтобы» и глагола заменяется масдаром и занимает синтаксическое место дополнения или подлежащего; приведены все разборы двух шархов.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Что называется толкуемым масдаром</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">يُسَمَّى <span class="ar-tone-particle">تَرْكِيبُ «أَنْ» مَعَ الْفِعْلِ</span> <span class="ar-tone-structure">مَصْدَرًا مُؤَوَّلًا</span>، وَيَأْخُذُ مَحَلَّهُ الْإِعْرَابِيَّ بِحَسَبِ مَوْقِعِهِ فِي الْجُمْلَةِ.</span>
        <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أُرِيدُ <span class="ar-tone-nasb">أَنْ أَخْرُجَ</span> = أُرِيدُ <span class="ar-tone-structure">الْخُرُوجَ</span>.</span><span class="rule-example-ru">Я хочу выйти: сочетание «чтобы я вышел» заменяется масдаром «выход».</span></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный разбор: «Я хочу выйти»</span>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أُرِيدُ</span>: فِعْلٌ مُضَارِعٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ عَلَى آخِرِهِ، وَالْفَاعِلُ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنَا».</span><span class="rule-analysis-ru">Глагол настоящего времени в состоянии раф‘; показатель — явная дамма в конце. Исполнитель — скрытое местоимение «я».</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَنْ</span>: حَرْفُ نَصْبٍ مَبْنِيٌّ عَلَى السُّكُونِ.</span><span class="rule-analysis-ru">Частица насба, построенная на сукуне.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَخْرُجَ</span>: فِعْلٌ مُضَارِعٌ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ عَلَى آخِرِهِ، وَالْفَاعِلُ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنَا».</span><span class="rule-analysis-ru">Глагол настоящего времени в насбе; показатель — явная фатха в конце. Исполнитель — скрытое местоимение «я».</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">أَنْ أَخْرُجَ</span>: مَصْدَرٌ مُؤَوَّلٌ فِي مَحَلِّ نَصْبٍ مَفْعُولٌ بِهِ.</span><span class="rule-analysis-ru">Толкуемый масдар занимает место прямого дополнения в состоянии насба.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный разбор: лям цели</span>
        <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">خَرَجْتُ <span class="ar-tone-nasb">لِأَشْرَبَ</span> الْمَاءَ.</span><span class="rule-example-ru">Я вышел, чтобы попить воды.</span></div>
        <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْأَصْلُ: خَرَجْتُ <span class="ar-tone-particle">لِأَنْ</span> أَشْرَبَ الْمَاءَ.</span><span class="rule-example-ru">Исходная развёрнутая форма: «Я вышел для того, чтобы попить воды».</span></div>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">خَرَجْتُ</span>: فِعْلٌ مَاضٍ مَبْنِيٌّ عَلَى السُّكُونِ، وَالْفَاعِلُ التَّاءُ الْمُتَحَرِّكَةُ فِي مَحَلِّ رَفْعٍ.</span><span class="rule-analysis-ru">Глагол прошедшего времени, построенный на сукуне; подвижная та — исполнитель в позиции раф‘.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لِـ</span>: حَرْفُ جَرٍّ مَبْنِيٌّ عَلَى الْكَسْرِ.</span><span class="rule-analysis-ru">Предлог, построенный на касре.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَشْرَبَ</span>: فِعْلٌ مُضَارِعٌ مَنْصُوبٌ بِـ«أَنْ» الْمُضْمَرَةِ بَعْدَ لَامِ التَّعْلِيلِ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ عَلَى آخِرِهِ، وَالْفَاعِلُ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنَا».</span><span class="rule-analysis-ru">Глагол настоящего времени в насбе посредством скрытой частицы после ляма цели; показатель — явная фатха. Исполнитель — скрытое «я».</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">لِأَشْرَبَ</span>: مَصْدَرٌ مُؤَوَّلٌ فِي مَحَلِّ نَصْبٍ مَفْعُولٌ بِهِ لِـ«خَرَجْتُ».</span><span class="rule-analysis-ru">В подробном шархе сочетание определено как толкуемый масдар в позиции насба — дополнение к «я вышел».</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">الْمَاءَ</span>: مَفْعُولٌ بِهِ لِـ«أَشْرَبَ» مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-analysis-ru">Прямое дополнение к «пью» в состоянии насба; показатель — явная фатха.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Разбор из второго шарха</span>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">أَنْ أَجْلِسَ</span>: <span class="ar-tone-particle">أَنْ</span> حَرْفُ نَصْبٍ، وَ<span class="ar-tone-verb">أَجْلِسَ</span> فِعْلٌ مُضَارِعٌ مَنْصُوبٌ وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ، وَالْمَصْدَرُ الْمُؤَوَّلُ فَاعِلٌ فِي مَحَلِّ رَفْعٍ.</span><span class="rule-analysis-ru">«Чтобы я сел»: частица насба и глагол в насбе с фатхой; весь толкуемый масдар является исполнителем в позиции раф‘.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$الإعراب:
أريد: فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "أنا".
أن: حرف النصب مبني على السكون.
أخرج: فعل مضارع منصوب وعلامة نصبه الفتحة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "أنا".
أن أخرج: مصدر مؤول في محل نصب مفعول به.
الإعراب:
خرجت: فعل ماض مبني على السكون، والفاعل التاء المتحركة (ت) في محل رفع.
ل: حرف جر مبني على الكسر.
أشرب: فعل مضارع منصوب بـ "أن" المضمرة بعد لام التعليل وعلامة نصبه الفتحة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "أنا".
لأشرب: مصدر مؤول في محل نصب مفعول به ل (خرجت).
الماء: مفعول به ل (أشرب) منصوب وعلامة نصبه الفتحة الظاهرة على آخره.$$,
      40, 40, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$أَنْ أَجْلِسَ: أَنْ حَرْفُ نَصْبٍ، أَجْلِسَ: فِعْلٌ مُضَارِعٌ مَنْصُوبٌ وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ، وَالْمَصْدَرُ الْمُؤَوَّلُ فَاعِلٌ فِي مَحَلِّ رَفْعٍ.
(أَنْ + الْفِعْلُ) يُسَمَّى مَصْدَرًا مُؤَوَّلًا.$$,
      36, 36, 2);

  -- 3. Yumkinu, la yumkinu, attached pronouns, and syntactic roles.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'يُمْكِنُ وَلَا يُمْكِنُ (можно и невозможно)',
    rule_ar = '«يُمْكِنُ» فِعْلٌ مُضَارِعٌ مَرْفُوعٌ يَحْتَاجُ إِلَى فَاعِلٍ وَمَفْعُولٍ بِهِ؛ وَيَكُونُ الْفَاعِلُ اسْمًا ظَاهِرًا أَوْ مَصْدَرًا مُؤَوَّلًا، وَتَكُونُ يَاءُ الْمُتَكَلِّمِ وَكَافُ الْمُخَاطَبِ مَفْعُولًا بِهِ، وَ«لَا» فِي «لَا يُمْكِنُ» حَرْفُ نَفْيٍ لَا يَعْمَلُ.',
    summary = 'Глагол «можно» требует исполнителя и дополнения; приведены десять местоименных форм, отрицание, исходные примеры и полный разбор ролей.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Форма и управление</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">يُمْكِنُ</span> فِعْلٌ مُضَارِعٌ مَرْفُوعٌ، يَحْتَاجُ إِلَى <span class="ar-tone-subject">فَاعِلٍ</span> وَ<span class="ar-tone-nasb">مَفْعُولٍ بِهِ</span>. وَ<span class="ar-tone-particle">لَا</span> فِي «لَا يُمْكِنُ» حَرْفُ نَفْيٍ لَا يَعْمَلُ.</span>
        <p class="rule-study-text">Глагол <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">يُمْكِنُ</span> — «можно; возможно» — стоит в раф‘ и требует исполнителя и прямого дополнения. Отрицательная частица в сочетании <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">لَا يُمْكِنُ</span> не изменяет форму глагола.</p>
        <div class="rule-check-card"><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَمْكَنَ ـ يُمْكِنُ</span> فِعْلٌ ثُلَاثِيٌّ مَزِيدٌ بِحَرْفٍ وَاحِدٍ، وَهُوَ الْهَمْزَةُ.</span><span>Это трёхбуквенный глагол, расширенный одной буквой — хамзой.</span></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять форм с присоединёнными местоимениями</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Кому разрешается</th><th>Арабская форма</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td>мне</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَلْ <span class="ar-tone-verb">يُمْكِنُنِي</span> الْجُلُوسُ؟</span></td><td>Можно ли мне сесть?</td></tr>
            <tr><td>тебе, мужчине</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَلْ <span class="ar-tone-verb">يُمْكِنُكَ</span> الْجُلُوسُ؟</span></td><td>Можно ли тебе сесть?</td></tr>
            <tr><td>тебе, женщине</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَلْ <span class="ar-tone-verb">يُمْكِنُكِ</span> الْجُلُوسُ؟</span></td><td>Можно ли тебе сесть?</td></tr>
            <tr><td>ему</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَلْ <span class="ar-tone-verb">يُمْكِنُهُ</span> الْجُلُوسُ؟</span></td><td>Можно ли ему сесть?</td></tr>
            <tr><td>ей</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَلْ <span class="ar-tone-verb">يُمْكِنُهَا</span> الْجُلُوسُ؟</span></td><td>Можно ли ей сесть?</td></tr>
            <tr><td>нам</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَلْ <span class="ar-tone-verb">يُمْكِنُنَا</span> الْجُلُوسُ؟</span></td><td>Можно ли нам сесть?</td></tr>
            <tr><td>вам, мужчинам</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَلْ <span class="ar-tone-verb">يُمْكِنُكُمْ</span> الْجُلُوسُ؟</span></td><td>Можно ли вам сесть?</td></tr>
            <tr><td>вам, женщинам</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَلْ <span class="ar-tone-verb">يُمْكِنُكُنَّ</span> الْجُلُوسُ؟</span></td><td>Можно ли вам сесть?</td></tr>
            <tr><td>им, мужчинам</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَلْ <span class="ar-tone-verb">يُمْكِنُهُمْ</span> الْجُلُوسُ؟</span></td><td>Можно ли им сесть?</td></tr>
            <tr><td>им, женщинам</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَلْ <span class="ar-tone-verb">يُمْكِنُهُنَّ</span> الْجُلُوسُ؟</span></td><td>Можно ли им сесть?</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Примеры и синтаксические роли из второго шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيُمْكِنُنِي الْجُلُوسُ هُنَا؟</span><span class="rule-example-ru">Можно ли мне сесть здесь?</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيُمْكِنُ أَنْ أَجْلِسَ هُنَا؟</span><span class="rule-example-ru">Можно ли мне сесть здесь?</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا يُمْكِنُكَ الْجُلُوسُ هُنَا.</span><span class="rule-example-ru">Тебе нельзя сидеть здесь.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا يُمْكِنُ أَنْ تَجْلِسَ هُنَا.</span><span class="rule-example-ru">Тебе нельзя сидеть здесь.</span></div>
        </div>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">أَيُمْكِنُنِي، لَا يُمْكِنُكَ</span>: يَاءُ الْمُتَكَلِّمِ وَكَافُ الْمُخَاطَبِ كِلَاهُمَا مَفْعُولٌ بِهِ.</span><span class="rule-analysis-ru">Йа говорящего и каф собеседника — прямые дополнения.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">الْجُلُوسُ</span>: فَاعِلٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ.</span><span class="rule-analysis-ru">«Сидение» — исполнитель в раф‘; показатель — дамма.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">أَنْ أَجْلِسَ</span>: فَاعِلٌ.</span><span class="rule-analysis-ru">Толкуемый масдар «чтобы я сел» является исполнителем.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">هُنَا</span>: ظَرْفُ مَكَانٍ.</span><span class="rule-analysis-ru">«Здесь» — обстоятельство места.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$أمكن يمكن
هذا الفعل ثلاثي مزيد بحرف وهو الهمزة (سندرس هذا الباب في المستوى الثالث وفي المستوى الرابع تفصيلا إن شاء الله).
هل يمكنني الجلوس؟
هل يمكنك الجلوس؟
هل يمكنك الجلوس؟
هل يمكنه الجلوس؟
هل يمكنها الجلوس؟
هل يمكننا الجلوس؟
هل يمكنكم الجلوس؟
هل يمكنكن الجلوس؟
هل يمكنهم الجلوس؟
هل يمكنهن الجلوس؟$$,
      41, 41, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$يُمْكِنُ، وَلَا يُمْكِنُ
يُمْكِنُ: فِعْلٌ مُضَارِعٌ مَرْفُوعٌ وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ، يَحْتَاجُ إِلَى فَاعِلٍ وَمَفْعُولٍ بِهِ.
لَا يُمْكِنُ: لَا حَرْفُ نَفْيٍ لَا يَعْمَلُ شَيْئًا.
أَمْثِلَةٌ:
أَيُمْكِنُنِي الْجُلُوسُ هُنَا؟
أَيُمْكِنُ أَنْ أَجْلِسَ هُنَا؟
لَا يُمْكِنُكَ الْجُلُوسُ هُنَا.
لَا يُمْكِنُ أَنْ تَجْلِسَ هُنَا.
أَيُمْكِنُنِي، لَا يُمْكِنُكَ: يَاءُ الْمُتَكَلِّمِ، وَكَافُ الْمُخَاطَبِ: كِلَاهُمَا مَفْعُولٌ بِهِ.
الْجُلُوسُ: فَاعِلٌ مَرْفُوعٌ وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ.
أَنْ أَجْلِسَ: فَاعِلٌ.
هُنَا: ظَرْفُ مَكَانٍ.$$,
      35, 35, 2);

  -- 4. Mundhu and mudhu, their government, examples, and i'rab.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'مُنْذُ وَمُذْ (с; тому назад)',
    rule_ar = '«مُنْذُ» حَرْفُ جَرٍّ مُخْتَصٌّ بِالزَّمَانِ وَهُوَ مَبْنِيٌّ عَلَى الضَّمِّ؛ وَتَكُونُ «مُنْذُ» وَ«مُذْ» حَرْفَيْ جَرٍّ إِذَا جَاءَ بَعْدَهُمَا اسْمٌ مَجْرُورٌ، وَظَرْفَيْنِ إِذَا جَاءَ بَعْدَهُمَا اسْمٌ مَرْفُوعٌ أَوْ جُمْلَةٌ اسْمِيَّةٌ أَوْ فِعْلِيَّةٌ.',
    summary = 'Предлоги времени «с; тому назад», их построение, все примеры двух шархов, полный разбор и условие употребления как предлога или обстоятельства.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Употребление</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مُنْذُ</span> حَرْفُ جَرٍّ مُخْتَصٌّ بِالزَّمَانِ، وَهُوَ مَبْنِيٌّ عَلَى الضَّمِّ.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">مُنْذُ</span> относится ко времени и передаёт значения «с какого-то времени» или «какое-то время тому назад».</p>
        <div class="rule-check-card"><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مُنْذُ وَمُذْ</span> حَرْفَا جَرٍّ إِذَا جَاءَ بَعْدَهُمَا اسْمٌ مَجْرُورٌ، وَظَرْفَانِ إِذَا جَاءَ بَعْدَهُمَا اسْمٌ مَرْفُوعٌ أَوْ جُمْلَةٌ اسْمِيَّةٌ أَوْ فِعْلِيَّةٌ.</span><span>Они являются предлогами перед именем в родительном состоянии и обстоятельствами перед именем в именительном состоянии либо перед именным или глагольным предложением.</span></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَجَعْتُ <span class="ar-tone-jarr">مُنْذُ أُسْبُوعٍ</span>.</span><span class="rule-example-ru">Я вернулся неделю назад.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مَا رَأَيْتُكَ <span class="ar-tone-jarr">مُنْذُ يَوْمَيْنِ</span>.</span><span class="rule-example-ru">Я не видел тебя два дня.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَسْكُنُ فِي هَذَا الْبَيْتِ <span class="ar-tone-jarr">مُنْذُ سَنَةٍ</span>.</span><span class="rule-example-ru">Я живу в этом доме год.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هُوَ مَرِيضٌ <span class="ar-tone-jarr">مُنْذُ يَوْمِ الْجُمُعَةِ</span>.</span><span class="rule-example-ru">Он болен с пятницы.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَافَرَ <span class="ar-tone-jarr">مُنْذُ ثَلَاثَةِ أَيَّامٍ</span>.</span><span class="rule-example-ru">Он уехал три дня назад.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный разбор: «Я вернулся неделю назад»</span>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">رَجَعْتُ</span>: فِعْلٌ مَاضٍ مَبْنِيٌّ عَلَى السُّكُونِ، وَالْفَاعِلُ التَّاءُ الْمُتَحَرِّكَةُ فِي مَحَلِّ رَفْعٍ.</span><span class="rule-analysis-ru">Глагол прошедшего времени, построенный на сукуне; подвижная та — исполнитель в позиции раф‘.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مُنْذُ</span>: حَرْفُ جَرٍّ مَبْنِيٌّ عَلَى الضَّمِّ.</span><span class="rule-analysis-ru">Предлог, построенный на дамме.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-jarr">أُسْبُوعٍ</span>: اسْمٌ مَجْرُورٌ، وَعَلَامَةُ جَرِّهِ الْكَسْرَةُ الظَّاهِرَةُ.</span><span class="rule-analysis-ru">Имя в родительном состоянии; показатель — явная касра.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$منذ: حرف جر مبني على الضمة.
نحو: رجعت منذ أسبوع.
الإعراب:
رجعت: فعل ماض مبني على السكون، والفاعل التاء المتحركة (ت) في محل رفع.
منذ: حرف الجر مبني على الضم.
أسبوع: اسم مجرور وعلامة جره الكسرة الظاهرة.
فائدة:
منذ ومذ: حرفا جر إذا جاء بعدهما اسم مجرور ويكونان ظرفين إذا جاء بعدهما اسم مرفوع أو جملة اسمية أو فعلية.$$,
      41, 41, 1),
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$مُنْذُ
مُنْذُ: حَرْفُ جَرٍّ يَخْتَصُّ بِالزَّمَانِ.
أَمْثِلَةٌ:
مَا رَأَيْتُكَ مُنْذُ يَوْمَيْنِ.
أَسْكُنُ فِي هَذَا الْبَيْتِ مُنْذُ سَنَةٍ.
هُوَ مَرِيضٌ مُنْذُ يَوْمِ الْجُمُعَةِ.
سَافَرَ مُنْذُ ثَلَاثَةِ أَيَّامٍ.$$,
      35, 35, 2);

  -- 5. Complete conjugation and source examples for ra'a/yara.
  update public.rules
  set
    sort_order = 5,
    rule_kind = 'rule',
    title = 'رَأَى ـ يَرَى (видеть)',
    rule_ar = '«رَأَى» فِعْلٌ مَاضٍ، وَمُضَارِعُهُ «يَرَى»، وَيُسْنَدُ فِي الْمَاضِي وَالْمُضَارِعِ إِلَى الضَّمَائِرِ عَلَى الْوُجُوهِ الْمُبَيَّنَةِ فِي الْجَدْوَلِ.',
    summary = 'Полная таблица десяти форм глагола «видеть» в прошедшем и настоящем времени, все примеры и грамматический разбор второго шарха.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Прошедшее и настоящее время</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">رَأَى</span> فِعْلٌ مَاضٍ، وَمُضَارِعُهُ <span class="ar-tone-verb">يَرَى</span>.</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th>Прошедшее время</th><th>Настоящее время</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَأَى</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَرَى</span></td><td>он увидел / видит</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَأَتْ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَرَى</span></td><td>она увидела / видит</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَأَوْا</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَرَوْنَ</span></td><td>они увидели / видят</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span><span class="rule-table-ru">они, женщины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَأَيْنَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَرَيْنَ</span></td><td>они увидели / видят</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَأَيْتَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَرَى</span></td><td>ты увидел / видишь</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَأَيْتِ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَرَيْنَ</span></td><td>ты увидела / видишь</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَأَيْتُمْ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَرَوْنَ</span></td><td>вы увидели / видите</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَأَيْتُنَّ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَرَيْنَ</span></td><td>вы увидели / видите</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَأَيْتُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَى</span></td><td>я увидел / вижу</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَأَيْنَا</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَرَى</span></td><td>мы увидели / видим</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры второго шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مَاذَا تَرَى؟ أَرَى قَلَمًا.</span><span class="rule-example-ru">Что ты видишь? Я вижу ручку.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">عَلِيٌّ يَرَى رَجُلًا قَادِمًا.</span><span class="rule-example-ru">Али видит приближающегося мужчину.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">نَحْنُ نَرَى أَشْيَاءَ كَثِيرَةً.</span><span class="rule-example-ru">Мы видим много вещей.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Грамматический разбор: «Я вижу ручку»</span>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَرَى</span>: فِعْلٌ مُضَارِعٌ، وَالْفَاعِلُ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنَا».</span><span class="rule-analysis-ru">Глагол настоящего времени; исполнитель — скрытое местоимение «я».</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">قَلَمًا</span>: مَفْعُولٌ بِهِ مَنْصُوبٌ.</span><span class="rule-analysis-ru">«Ручку» — прямое дополнение в состоянии насба.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_5_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$الفعل: رأى يرى
الماضي | المضارع
رأى | يرى
رأت | ترى
رأوا | يرون
رأين | يرين
رأيت | ترى
رأيت | ترين
رأيتم | ترون
رأيتن | ترين
رأيت | أرى
رأينا | نرى$$,
      42, 42, 1),
    (rule_5_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$رَأَى
رَأَى: فِعْلٌ مَاضٍ، مُضَارِعُهُ: أَرَى، تَرَى، يَرَى، نَرَى.
مَاذَا تَرَى؟ أَرَى قَلَمًا.
عَلِيٌّ يَرَى رَجُلًا قَادِمًا.
نَحْنُ نَرَى أَشْيَاءَ كَثِيرَةً.
أَرَى قَلَمًا:
أَرَى فِعْلٌ مُضَارِعٌ، الْفَاعِلُ: ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ (أَنَا).
قَلَمًا: مَفْعُولٌ بِهِ مَنْصُوبٌ.$$,
      36, 36, 2);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '17'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 17 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id)
  ) <> 10 then
    raise exception 'Expected 10 Book 2 lesson 17 source rows';
  end if;
end
$migration$;

commit;
