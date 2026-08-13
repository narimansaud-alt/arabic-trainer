-- Verify Medina Book 2 lesson 29 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 70-72.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 58-60.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
  rule_4_id bigint;
  rule_5_id bigint;
  rule_6_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '29';

  if lesson_rule_count not in (5, 6) then
    raise exception 'Expected 5 or 6 Book 2 lesson 29 rules, found %', lesson_rule_count;
  end if;

  if lesson_rule_count = 5 then
    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values
      ('Мединский курс (Том 2)', '29', '', '', 6, 'rule', '', '')
    returning id into rule_6_id;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '29' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '29' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '29' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '29' and sort_order = 4;
  select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '29' and sort_order = 5;
  select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '29' and sort_order = 6;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id);

  -- 1. Definition and the two operations: idgham and fakk.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'الْفِعْلُ الْمُضَعَّفُ وَالْإِدْغَامُ وَالْفَكُّ (удвоенный глагол, слияние и раскрытие)',
    rule_ar = 'الْفِعْلُ الْمُضَعَّفُ هُوَ مَا كَانَتْ عَيْنُهُ وَلَامُهُ مِنْ جِنْسٍ وَاحِدٍ، أَيْ إِنَّ الْحَرْفَ الثَّانِيَ وَالثَّالِثَ حَرْفٌ وَاحِدٌ مُكَرَّرٌ. وَالْإِدْغَامُ جَعْلُ الْحَرْفَيْنِ الْمِثْلَيْنِ حَرْفًا وَاحِدًا مُشَدَّدًا، وَالْفَكُّ إِظْهَارُ الْحَرْفَيْنِ كِلَيْهِمَا.',
    summary = 'У удвоенного глагола вторая и третья коренные одинаковы. При слиянии они записываются одной буквой с шаддой; при раскрытии обе коренные показываются раздельно.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Что означает удвоение</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمُضَعَّفُ</span><span class="rule-term-ru">глагол, у которого вторая и третья коренные буквы одинаковы.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">الْإِدْغَامُ</span><span class="rule-term-ru">слияние двух одинаковых букв в одну букву с шаддой.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">فَكُّ الْإِدْغَامِ</span><span class="rule-term-ru">раскрытие шадды: обе одинаковые коренные записываются отдельно.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Исходная и слитая формы</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Слитая форма</th><th>Исходная раскрытая форма</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">حَجَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجَجَ</span></td><td>совершил хадж</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">عَدَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدَدَ</span></td><td>посчитал</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">شَمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمِمَ</span></td><td>понюхал</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الفعل المضعف: هو الفعل الذي عينه ولامه من جنس واحد، أي نفس الحرف، نحو: حج.$$,
      70, 70, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الفعل المضعف: هو ما كانت عينه ولامه من جنس واحد، أي الحرف الثاني والثالث حرف واحد مكرر، نحو: الماضي عد، أصله عدد.$$,
      58, 58, 2);

  -- 2. Past tense with ten pronouns and obligatory fakk/idgham.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'إِسْنَادُ الْمُضَعَّفِ فِي الْمَاضِي (присоединение местоимений к удвоенному глаголу в прошедшем времени)',
    rule_ar = 'يَجِبُ الْإِدْغَامُ فِي الْمَاضِي الْمُضَعَّفِ مَعَ الضَّمِيرِ الْمُسْتَتِرِ وَفِي نَحْوِ حَجَّتْ وَحَجُّوا، وَيَجِبُ فَكُّ الْإِدْغَامِ عِنْدَ إِسْنَادِهِ إِلَى التَّاءِ الْمُتَحَرِّكَةِ وَنَا الْفَاعِلِينَ وَنُونِ النِّسْوَةِ، نَحْوُ: حَجَجْتُ، وَحَجَجْنَا، وَحَجَجْنَ.',
    summary = 'В прошедшем времени шадда сохраняется с невидимым исполнителем, ت женского рода и وَاوُ الْجَمَاعَةِ. С подвижной ت, نَا и نُونُ النِّسْوَةِ удвоение обязательно раскрывается.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Когда слияние сохраняется, а когда раскрывается</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">يَجِبُ الْإِدْغَامُ</span><span class="rule-term-ru">слияние обязательно: <span class="ar-inline" dir="rtl" lang="ar">حَجَّ، حَجَّتْ، حَجُّوا</span>.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">يَجِبُ فَكُّ الْإِدْغَامِ</span><span class="rule-term-ru">раскрытие обязательно: <span class="ar-inline" dir="rtl" lang="ar">حَجَجْتُ، حَجَجْنَا، حَجَجْنَ</span>.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений и три глагола</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th>Совершить хадж</th><th>Посчитать</th><th>Понюхать</th><th>Состояние удвоения</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمَّ</span></td><td>слияние</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمُّوا</span></td><td>слияние</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجَّتْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدَّتْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمَّتْ</span></td><td>слияние</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجَجْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدَدْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمِمْنَ</span></td><td>обязательное раскрытие</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجَجْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدَدْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمِمْتَ</span></td><td>обязательное раскрытие</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجَجْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدَدْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمِمْتُمْ</span></td><td>обязательное раскрытие</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجَجْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدَدْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمِمْتِ</span></td><td>обязательное раскрытие</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجَجْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدَدْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمِمْتُنَّ</span></td><td>обязательное раскрытие</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجَجْتُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدَدْتُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمِمْتُ</span></td><td>обязательное раскрытие</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَجَجْنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَدَدْنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شَمِمْنَا</span></td><td>обязательное раскрытие</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$إسناد الفعل الماضي إلى الضمائر العشرة:
هو حج، هي حجت، نحن حججنا، أنتم حججتم، هم حجوا، هن حججن.
قاعدة في الفعل الماضي:
1. يجب إدغام عين الفعل في لامه عند إسناد الفعل المضعف إلى الضمير المستتر والضمير البارز الساكن.
2. يجب فك الإدغام عند إسناد الفعل المضعف إلى ضمير متحرك.$$,
      70, 70, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إسناد الفعل الماضي المضعف إلى الضمائر:
عد، عدوا، عدت، عددن، عددت، عددتم، عددت، عددتن، عددت، عددنا.
شم، شموا، شمت، شممن، شممت، شممتم، شممت، شممتن، شممت، شممنا.
عددت، عددن، عددنا: يجب فك الإدغام عند الإسناد إلى التاء ونا ونون النسوة.
عد، عدت، عدوا: يجب فيها الإدغام.$$,
      58, 58, 2);

  -- 3. Present tense with ten pronouns, all three states, and optional fakk in jazm.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'إِسْنَادُ الْمُضَعَّفِ فِي الْمُضَارِعِ وَإِعْرَابُهُ (удвоенный глагол в настоящем времени и его изменение)',
    rule_ar = 'يَبْقَى الْإِدْغَامُ فِي الْمُضَارِعِ الْمَرْفُوعِ وَالْمَنْصُوبِ، وَيَجِبُ فَكُّهُ مَعَ نُونِ النِّسْوَةِ. وَإِذَا جُزِمَ الْمُضَارِعُ الْمُضَعَّفُ الْمُسْنَدُ إِلَى ضَمِيرٍ مُسْتَتِرٍ جَازَ فِيهِ الْإِدْغَامُ وَالْفَكُّ، نَحْوُ: لَمْ يَحُجَّ وَلَمْ يَحْجُجْ. فَالْمُدْغَمُ مَجْزُومٌ بِسُكُونٍ مُقَدَّرٍ وَحُرِّكَ بِالْفَتْحِ لِلتَّخَلُّصِ مِنِ الْتِقَاءِ السَّاكِنَيْنِ، وَالْمَفْكُوكُ مَجْزُومٌ بِسُكُونٍ ظَاهِرٍ.',
    summary = 'В раф‘ и насбе удвоение сохраняется; с نُونُ النِّسْوَةِ раскрывается. В джазме одиночной формы разрешены слитая и раскрытая формы, каждая со своим способом выражения сукуна.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Две допустимые формы джазма</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَمْ يَحُجَّ.</span><span class="rule-example-ru">Он не совершил хадж: слитая форма, сукун предполагается, а последняя буква получила фатху для устранения встречи двух сукунов.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَمْ يَحْجُجْ.</span><span class="rule-example-ru">Он не совершил хадж: раскрытая форма с явным сукуном.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений в трёх состояниях</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَرْفُوعُ</span><span class="rule-table-ru">раф‘</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَنْصُوبُ</span><span class="rule-table-ru">насб</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَجْزُومُ</span><span class="rule-table-ru">джазм</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَحُجُّ؛ يَعُدُّ؛ يَشُمُّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَحُجَّ؛ لَنْ يَعُدَّ؛ لَنْ يَشُمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَحُجَّ أَوْ يَحْجُجْ؛ لَمْ يَعُدَّ أَوْ يَعْدُدْ؛ لَمْ يَشُمَّ أَوْ يَشْمُمْ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَحُجُّونَ؛ يَعُدُّونَ؛ يَشُمُّونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَحُجُّوا؛ لَنْ يَعُدُّوا؛ لَنْ يَشُمُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَحُجُّوا؛ لَمْ يَعُدُّوا؛ لَمْ يَشُمُّوا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجُّ؛ تَعُدُّ؛ تَشُمُّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجَّ؛ لَنْ تَعُدَّ؛ لَنْ تَشُمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجَّ أَوْ تَحْجُجْ؛ لَمْ تَعُدَّ أَوْ تَعْدُدْ؛ لَمْ تَشُمَّ أَوْ تَشْمُمْ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَحْجُجْنَ؛ يَعْدُدْنَ؛ يَشْمُمْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَحْجُجْنَ؛ لَنْ يَعْدُدْنَ؛ لَنْ يَشْمُمْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَحْجُجْنَ؛ لَمْ يَعْدُدْنَ؛ لَمْ يَشْمُمْنَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجُّ؛ تَعُدُّ؛ تَشُمُّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجَّ؛ لَنْ تَعُدَّ؛ لَنْ تَشُمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجَّ أَوْ تَحْجُجْ؛ لَمْ تَعُدَّ أَوْ تَعْدُدْ؛ لَمْ تَشُمَّ أَوْ تَشْمُمْ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجُّونَ؛ تَعُدُّونَ؛ تَشُمُّونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجُّوا؛ لَنْ تَعُدُّوا؛ لَنْ تَشُمُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجُّوا؛ لَمْ تَعُدُّوا؛ لَمْ تَشُمُّوا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجِّينَ؛ تَعُدِّينَ؛ تَشُمِّينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجِّي؛ لَنْ تَعُدِّي؛ لَنْ تَشُمِّي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجِّي؛ لَمْ تَعُدِّي؛ لَمْ تَشُمِّي</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحْجُجْنَ؛ تَعْدُدْنَ؛ تَشْمُمْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحْجُجْنَ؛ لَنْ تَعْدُدْنَ؛ لَنْ تَشْمُمْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحْجُجْنَ؛ لَمْ تَعْدُدْنَ؛ لَمْ تَشْمُمْنَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَحُجُّ؛ أَعُدُّ؛ أَشُمُّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ أَحُجَّ؛ لَنْ أَعُدَّ؛ لَنْ أَشُمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ أَحُجَّ أَوْ أَحْجُجْ؛ لَمْ أَعُدَّ أَوْ أَعْدُدْ؛ لَمْ أَشُمَّ أَوْ أَشْمُمْ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحُجُّ؛ نَعُدُّ؛ نَشُمُّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ نَحُجَّ؛ لَنْ نَعُدَّ؛ لَنْ نَشُمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ نَحُجَّ أَوْ نَحْجُجْ؛ لَمْ نَعُدَّ أَوْ نَعْدُدْ؛ لَمْ نَشُمَّ أَوْ نَشْمُمْ</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">نُونُ النِّسْوَةِ</span>В формах <span class="ar-inline" dir="rtl" lang="ar">يَحْجُجْنَ، يَعْدُدْنَ، يَشْمُمْنَ</span> раскрытие обязательно; глагол неизменяем на сукуне в раф‘ и находится в позиции насба или джазма после соответствующей частицы.</div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$إسناد الفعل المضارع إلى الضمائر:
المضارع المرفوع والمنصوب والمجزوم من حج مع الضمائر العشرة.
يجوز الإدغام والفك في الفعل المضارع المضعف المجزوم المسند إلى ضمير مستتر، نحو: لم يحج، ولم يحجج.$$,
      71, 71, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إسناد الفعل المضارع المضعف إلى الضمائر: يعد ويشم في الرفع والنصب والجزم مع الضمائر.
يعدن ويشممن: يجب فك الإدغام عند الإسناد إلى نون النسوة في الرفع والنصب والجزم.
لم يعد: مجزوم بالسكون المقدر، وحرك بالفتح للتخلص من التقاء الساكنين، إذ أصله لم يعدد.
المضارع المضعف المجزوم بالسكون يجوز فيه الإدغام والفك، تقول: لم يعد، ولم يعدد.$$,
      59, 59, 2);

  -- 4. Imperative: four forms, building signs, and optional fakk.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'صِيَاغَةُ أَمْرِ الْمُضَعَّفِ وَإِسْنَادُهُ (образование и присоединение форм повелительного удвоенного глагола)',
    rule_ar = 'يُصَاغُ أَمْرُ الْمُضَعَّفِ مِنَ الْمُضَارِعِ بِحَذْفِ حَرْفِ الْمُضَارَعَةِ. فَيُبْنَى الْمُفْرَدُ الْمُذَكَّرُ عَلَى سُكُونٍ مُقَدَّرٍ فِي صُورَةِ الْإِدْغَامِ، وَيُحَرَّكُ بِالْفَتْحِ لِلتَّخَلُّصِ مِنِ الْتِقَاءِ السَّاكِنَيْنِ، وَيَجُوزُ فِيهِ الْفَكُّ مَعَ سُكُونٍ ظَاهِرٍ. وَيُبْنَى مَعَ وَاوِ الْجَمَاعَةِ وَيَاءِ الْمُخَاطَبَةِ عَلَى حَذْفِ النُّونِ، وَيَجِبُ فَكُّ الْإِدْغَامِ مَعَ نُونِ النِّسْوَةِ.',
    summary = 'Повелительное образуется удалением префикса настоящего времени. В мужском единственном разрешены слитая и раскрытая формы; с وَاوُ الْجَمَاعَةِ и يَاءُ الْمُخَاطَبَةِ удаляется ن, а с نُونُ النِّسْوَةِ раскрытие обязательно.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Образование формы</span>
        <ol class="rule-step-list">
          <li><span class="rule-step-ar" dir="rtl" lang="ar">تَحُجُّ</span><span class="rule-step-ru">Берём настоящее время «ты совершаешь хадж».</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">حُجَّ</span><span class="rule-step-ru">Удаляем ت настоящего времени; слитая форма получает фатху для устранения двух сукунов.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">اُحْجُجْ</span><span class="rule-step-ru">Допустимая раскрытая форма с хамзатуль-васл и явным сукуном.</span></li>
        </ol>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре формы трёх глаголов</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Обращение</th><th>Совершить хадж</th><th>Посчитать</th><th>Понюхать</th><th>Построение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حُجَّ أَوِ اُحْجُجْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عُدَّ أَوِ اُعْدُدْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شُمَّ أَوِ اُشْمُمْ</span></td><td>сукун скрытый или явный</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حُجُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عُدُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شُمُّوا</span></td><td>удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حُجِّي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عُدِّي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شُمِّي</span></td><td>удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُحْجُجْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُعْدُدْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُشْمُمْنَ</span></td><td>обязательное раскрытие; сукун</td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Точный признак</span><span class="ar-inline" dir="rtl" lang="ar">حُجُّوا</span> и <span class="ar-inline" dir="rtl" lang="ar">حُجِّي</span> являются формами пяти глаголов и строятся на <span class="ar-inline ar-tone-jazm" dir="rtl" lang="ar">حَذْفِ النُّونِ</span> — удалении нуна.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Обращения</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَحْمَدُ، حُجَّ.</span><span class="rule-example-ru">Ахмад, соверши хадж.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا فَاطِمَةُ، حُجِّي.</span><span class="rule-example-ru">Фатима, соверши хадж.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَوْلَادُ، حُجُّوا.</span><span class="rule-example-ru">Мальчики, совершите хадж.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا بَنَاتُ، اُحْجُجْنَ.</span><span class="rule-example-ru">Девочки, совершите хадж.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$كيف يصاغ فعل الأمر من الفعل المضعف؟
1. نأتي بالفعل المضارع: تحج.
2. نحذف حرف المضارعة: حج.
3. نفتح أو نضم أو نكسر آخر الفعل بحسب الضمير الذي أسند إليه.
حج: أسند إلى أنت، مبني على السكون المقدر، وحرك بالفتح للتخلص من التقاء الساكنين.
حجوا: أسند إلى أنتم، مبني على الضم لاتصال واو الجماعة.
حجي: أسند إلى أنت، مبني على الكسر لاتصال ياء المخاطبة.
نقول: يا أحمد حج، يا فاطمة حجي، يا أولاد حجوا، يا بنات احججن.$$,
      72, 72, 1),
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إسناد فعل الأمر المضعف إلى الضمائر:
عد، عدوا، عدي، اعددن.
شم، شموا، شمي، اشممن.
اعددن: يجب فك الإدغام عند الإسناد إلى نون النسوة.
عد: مبني على سكون مقدر، وحرك بالفتح للتخلص من التقاء الساكنين، إذ أصله اعدد.
الأمر من المضعف المبني على السكون يجوز فيه الإدغام والفك، تقول: عد، واعدد.$$,
      60, 60, 2);

  -- 5. Qatt and abadan.
  update public.rules
  set
    sort_order = 5,
    rule_kind = 'rule',
    title = 'قَطُّ وَأَبَدًا (наречия «никогда» для прошлого и будущего)',
    rule_ar = '«قَطُّ» ظَرْفُ زَمَانٍ مُخْتَصٌّ بِالزَّمَنِ الْمَاضِي وَيُسْبَقُ بِالنَّفْيِ، وَ«أَبَدًا» ظَرْفُ زَمَانٍ مُخْتَصٌّ بِالزَّمَنِ الْمُسْتَقْبَلِ.',
    summary = 'قَطُّ употребляется с отрицанием прошлого, а أَبَدًا относится к будущему. Сохранены все самостоятельные примеры двух шархов.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Различие по времени</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">قَطُّ</span><span class="rule-term-ru">«никогда»: относится к прошлому и употребляется после отрицания.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">أَبَدًا</span><span class="rule-term-ru">«никогда, вечно»: относится к будущему.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры источников</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مَا شَرِبْتُ الْخَمْرَ قَطُّ، وَلَنْ أَشْرَبَهَا أَبَدًا.</span><span class="rule-example-ru">Я никогда не пил вино и никогда не буду его пить.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا مَا ذَهَبْتُ إِلَى الْهِنْدِ قَطُّ.</span><span class="rule-example-ru">Я никогда не ездил в Индию.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَمْ أَسْمَعْ كَلَامًا مِثْلَ هَذَا قَطُّ.</span><span class="rule-example-ru">Я никогда не слышал подобных слов.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْكُفَّارُ خَالِدُونَ فِي النَّارِ أَبَدًا.</span><span class="rule-example-ru">Неверующие будут пребывать в Огне вечно.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_5_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$قط وأبدا:
«قط» تستعمل للماضي، و«أبدا» تستعمل للمستقبل، نحو: ما شربت الخمر قط ولن أشربها أبدا.$$,
      72, 72, 1),
    (rule_5_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$قط: ظرف زمان مختص بالزمن الماضي، ويسبق بالنفي، تقول: ما شربت الخمر قط.
أبدا: ظرف زمان مختص بالزمن المستقبل، تقول: لن أترك الصلاة أبدا.
أمثلة: أنا ما ذهبت إلى الهند قط. لم أشرب الخمر قط، ولن أشربها أبدا. لم أسمع كلاما مثل هذا قط. الكفار خالدون في النار أبدا.$$,
      60, 60, 2);

  -- 6. Ism at-tafdil of taba and lana.
  update public.rules
  set
    sort_order = 6,
    rule_kind = 'rule',
    title = 'اسْمُ التَّفْضِيلِ مِنْ «طَابَ» وَ«لَانَ» (сравнительная степень от «быть хорошим» и «быть мягким»)',
    rule_ar = 'اسْمُ التَّفْضِيلِ مِنَ الْفِعْلِ الْأَجْوَفِ «طَابَ» هُوَ «أَطْيَبُ»، وَمِنَ الْفِعْلِ الْأَجْوَفِ «لَانَ» هُوَ «أَلْيَنُ».',
    summary = 'Для двух полых глаголов шархи отдельно фиксируют формы имени предпочтения: طَابَ — أَطْيَبُ, لَانَ — أَلْيَنُ.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Две формы</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Глагол</th><th>Связанное качество</th><th><span class="rule-table-ar" dir="rtl" lang="ar">اسْمُ التَّفْضِيلِ</span><span class="rule-table-ru">форма сравнения</span></th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">طَابَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">طَيِّبٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">أَطْيَبُ</span></td><td>быть хорошим, приятным — лучше, приятнее</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">لَانَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَيِّنٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">أَلْيَنُ</span></td><td>быть мягким — мягче</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Примеры второго шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الطَّعَامُ طَيِّبٌ، وَذَلِكَ أَطْيَبُ.</span><span class="rule-example-ru">Эта еда хорошая, а та — лучше.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">خَالِدٌ رَجُلٌ طَيِّبٌ، وَأَخُوهُ أَطْيَبُ مِنْهُ.</span><span class="rule-example-ru">Халид — хороший человек, а его брат лучше него.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الْقَمِيصُ لَيِّنٌ، وَذَلِكَ أَلْيَنُ.</span><span class="rule-example-ru">Эта рубашка мягкая, а та — мягче.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ الْمِخَدَّةُ لَيِّنَةٌ، وَتِلْكَ أَلْيَنُ مِنْهَا.</span><span class="rule-example-ru">Эта подушка мягкая, а та мягче неё.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_6_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_6_id, 'Podrobny_Sharkh_2_tom.pdf', $$اسم التفضيل من الفعلين «لان» و«طاب»:
لان: لين، ألين.
طاب: طيب، أطيب.$$,
      72, 72, 1),
    (rule_6_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$طاب ولان:
طاب: فعل ماض أجوف، بمعنى طيب. لان: فعل ماض أجوف، بمعنى لين.
اسم التفضيل منهما: أطيب، وألين.
أمثلة: هذا الطعام طيب، وذلك أطيب. خالد رجل طيب، وأخوه أطيب منه. هذا القميص لين، وذلك ألين. هذه المخدة لينة، وتلك ألين منها.$$,
      60, 60, 2);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '29'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 29 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id)
  ) <> 12 then
    raise exception 'Expected 12 Book 2 lesson 29 source rows';
  end if;

  if exists (
    select 1 from public.rules
    where id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id)
      and (content::text like '%←%' or content::text like '%→%')
  ) then
    raise exception 'Book 2 lesson 29 contains an RTL-hostile arrow';
  end if;
end
$migration$;

commit;
