-- Verify Medina Book 2 lesson 30 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 73-74.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 61.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
  rule_4_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '30';

  if lesson_rule_count not in (2, 4) then
    raise exception 'Expected 2 or 4 Book 2 lesson 30 rules, found %', lesson_rule_count;
  end if;

  if lesson_rule_count = 2 then
    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values
      ('Мединский курс (Том 2)', '30', '', '', 3, 'rule', '', '')
    returning id into rule_3_id;

    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values
      ('Мединский курс (Том 2)', '30', '', '', 4, 'rule', '', '')
    returning id into rule_4_id;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '30' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '30' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '30' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '30' and sort_order = 4;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id);

  -- 1. Dual pronouns and their independent/attached forms.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'ضَمِيرَا الْمُثَنَّى «هُمَا» وَ«أَنْتُمَا» (местоимения двойственного числа «они двое» и «вы двое»)',
    rule_ar = 'ضَمِيرُ الْمُثَنَّى لِلْغَائِبِ هُوَ «هُمَا»، وَلِلْمُخَاطَبِ هُوَ «أَنْتُمَا»، وَيُسْتَعْمَلُ كُلٌّ مِنْهُمَا لِلْمُذَكَّرِ وَالْمُؤَنَّثِ. وَيَأْتِيَانِ ضَمِيرَيْنِ مُنْفَصِلَيْنِ، كَمَا يَتَّصِلُ «ـهُمَا» فِي مَحَلِّ نَصْبٍ أَوْ جَرٍّ، وَ«ـكُمَا» فِي مَحَلِّ نَصْبٍ أَوْ جَرٍّ.',
    summary = 'هُمَا обозначает двух отсутствующих, а أَنْتُمَا — двух собеседников; обе формы используются для мужчин и женщин. В насбе и джарре применяются присоединённые ـهُمَا и ـكُمَا.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Два самостоятельных местоимения</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-subject" dir="rtl" lang="ar">هُمَا</span><span class="rule-term-ru">они двое; используется для двух мужчин или двух женщин.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-subject" dir="rtl" lang="ar">أَنْتُمَا</span><span class="rule-term-ru">вы двое; используется при обращении к двум мужчинам или двум женщинам.</span></div>
        </div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هُمَا طَالِبَانِ. هُمَا طَالِبَتَانِ.</span><span class="rule-example-ru">Они двое — студенты. Они обе — студентки.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتُمَا طَالِبَانِ. أَنْتُمَا طَالِبَتَانِ.</span><span class="rule-example-ru">Вы двое — студенты. Вы обе — студентки.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Самостоятельная и присоединённая формы</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Синтаксическое положение</th><th>Третье лицо</th><th>Второе лицо</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">раф‘</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمَا طَالِبَانِ.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمَا طَالِبَانِ.</span></td><td>Они двое / вы двое — студенты.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُهُمَا.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُكُمَا.</span></td><td>Я увидел их обоих / вас обоих.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">كِتَابُهُمَا.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">كِتَابُكُمَا.</span></td><td>Книга их двоих / ваша общая книга.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$المثنى:
ضمير المثنى: هما للغائب، وأنتما للمخاطب، ويستعمل للمذكر والمؤنث.
نحو: هما طالبان، هما طالبتان. أنتما طالبان، أنتما طالبتان.
الرفع: هما طالبان، أنتما طالبان.
النصب: رأيتهما، رأيتكما.
الجر: كتابهما، كتابكما.$$,
      73, 73, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$ضمير المثنى يسمى ألف الاثنين، وهو الفاعل.$$,
      61, 61, 2);

  -- 2. Past and present assignment to dual pronouns.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'إِسْنَادُ الْمَاضِي وَالْمُضَارِعِ إِلَى ضَمِيرِ الْمُثَنَّى (присоединение прошедшего и настоящего глагола к двойственному числу)',
    rule_ar = 'يُسْنَدُ الْمَاضِي إِلَى الْمُثَنَّى الْغَائِبِ بِأَلِفِ الِاثْنَيْنِ، وَهِيَ ضَمِيرٌ مُتَّصِلٌ مَبْنِيٌّ عَلَى السُّكُونِ فِي مَحَلِّ رَفْعٍ، وَهِيَ فَاعِلٌ، نَحْوُ: ذَهَبَا وَذَهَبَتَا. أَمَّا فِي «ذَهَبْتُمَا» فَالتَّاءُ الْمُتَحَرِّكَةُ ضَمِيرٌ مُتَّصِلٌ فِي مَحَلِّ رَفْعٍ فَاعِلٌ. وَيُسْنَدُ الْمُضَارِعُ إِلَى «هُمَا» بِـ«يَفْعَلَانِ» لِلْمُذَكَّرِ وَ«تَفْعَلَانِ» لِلْمُؤَنَّثِ، وَإِلَى «أَنْتُمَا» بِـ«تَفْعَلَانِ» لِلْمُذَكَّرِ وَالْمُؤَنَّثِ.',
    summary = 'В третьем лице прошедшего исполнителем служит أَلِفُ الِاثْنَيْنِ; в ذَهَبْتُمَا исполнителем является подвижная ت. Настоящее различает يَفْعَلَانِ для двух мужчин третьего лица и تَفْعَلَانِ для двух женщин либо двух собеседников.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Прошедшее время</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Кто совершил действие</th><th>Форма</th><th>Исполнитель и построение</th><th>Перевод</th></tr></thead>
          <tbody>
            <tr><td>Двое мужчин</td><td><span class="rule-table-ar" dir="rtl" lang="ar">مُحَمَّدٌ وَخَالِدٌ ذَهَبَا.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span><span class="rule-table-ru">связанное местоимение-исполнитель; прошедший глагол на фатхе</span></td><td>Мухаммад и Халид ушли.</td></tr>
            <tr><td>Две женщины</td><td><span class="rule-table-ar" dir="rtl" lang="ar">آمِنَةُ وَمَرْيَمُ ذَهَبَتَا.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَاءُ التَّأْنِيثِ وَأَلِفُ الِاثْنَيْنِ</span><span class="rule-table-ru">показатель женского рода и исполнитель двойственного числа</span></td><td>Амина и Марьям ушли.</td></tr>
            <tr><td>Два собеседника</td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمَا ذَهَبْتُمَا.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">التَّاءُ الْمُتَحَرِّكَةُ</span><span class="rule-table-ru">связанное местоимение в позиции раф‘ как исполнитель</span></td><td>Вы двое ушли.</td></tr>
            <tr><td>Дополнительные имена второго шарха</td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَانِ ذَهَبَا. الطَّالِبَتَانِ ذَهَبَتَا.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span></td><td>Два студента ушли. Две студентки ушли.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Настоящее время</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение и род</th><th>Форма</th><th>Русский перевод</th><th>Исполнитель</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمَا</span><span class="rule-table-ru">два мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمَا يَذْهَبَانِ.</span></td><td>Они двое идут.</td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمَا</span><span class="rule-table-ru">две женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمَا تَذْهَبَانِ.</span></td><td>Они обе идут.</td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمَا</span><span class="rule-table-ru">мужчины или женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمَا تَذْهَبَانِ.</span></td><td>Вы двое или вы обе идёте.</td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span></td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$إسناد الفعل إلى ضمير المثنى:
الماضي: محمد وخالد ذهبا. آمنة ومريم ذهبتا.
الألف يسمى ألف الاثنين، وهو ضمير متصل مبني على السكون في محل رفع فاعل.
التاء المتحركة في (ذهبتما) ضمير متصل في محل رفع فاعل.
المضارع: هما يذهبان للمذكر. هما تذهبان للمؤنث. أنتما تذهبان للمذكر والمؤنث.
الفاعل: ألف الاثنين في محل رفع.$$,
      73, 73, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إسناد الفعل الماضي والمضارع والأمر إلى ضمير المثنى:
الطالبان ذهبا. الطالبتان ذهبتا. أنتما ذهبتما.
الطالبان يذهبان. الطالبتان تذهبان. أنتما تذهبان.
ضمير المثنى يسمى ألف الاثنين، وهو الفاعل.
المضارع المسند إلى ألف الاثنين فعل من الأفعال الخمسة.$$,
      61, 61, 2);

  -- 3. Derivation of the dual imperative.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'صِيَاغَةُ الْأَمْرِ لِلْمُثَنَّى (образование повелительного для двоих)',
    rule_ar = 'يُصَاغُ أَمْرُ الْمُثَنَّى مِنَ الْمُضَارِعِ «تَذْهَبَانِ» بِحَذْفِ حَرْفِ الْمُضَارَعَةِ، ثُمَّ حَذْفِ النُّونِ، ثُمَّ الْإِتْيَانِ بِهَمْزَةِ الْوَصْلِ مَعَ الْحَرَكَةِ الْمُنَاسِبَةِ، فَيُقَالُ: «اِذْهَبَا». وَفِعْلُ الْأَمْرِ الْمُسْنَدُ إِلَى أَلِفِ الِاثْنَيْنِ مَبْنِيٌّ عَلَى حَذْفِ النُّونِ.',
    summary = 'Форма приказа для двоих образуется от تَذْهَبَانِ: удаляются ت настоящего времени и ن, затем добавляется хамзатуль-васл с подходящей огласовкой.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре шага</span>
        <ol class="rule-step-list">
          <li><span class="rule-step-ar" dir="rtl" lang="ar">تَذْهَبَانِ</span><span class="rule-step-ru">Берём настоящее время «вы двое идёте».</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">ذْهَبَانِ</span><span class="rule-step-ru">Удаляем ت настоящего времени.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">ذْهَبَا</span><span class="rule-step-ru">Удаляем ن.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">اِذْهَبَا</span><span class="rule-step-ru">Добавляем хамзатуль-васл с касрой, чтобы начать произношение со слова с сукуном.</span></li>
        </ol>
        <div class="rule-note"><span class="rule-note-label">Признак построения</span><span class="ar-inline" dir="rtl" lang="ar">اِذْهَبَا</span> — повелительный глагол, построенный на <span class="ar-inline ar-tone-jazm" dir="rtl" lang="ar">حَذْفِ النُّونِ</span>; <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span> — исполнитель.</div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$كيف يصاغ الأمر للمثنى؟
1. نأتي بالفعل المضارع: تذهبان.
2. نحذف حرف المضارعة: ذهبان.
3. نحذف النون: ذهبا.
4. نأتي بهمزة الوصل مع الحركة المناسبة: اذهبا.$$,
      74, 74, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الأمر: اذهبا. علامة البناء حذف النون، وألف الاثنين فاعل.$$,
      61, 61, 2);

  -- 4. The five present forms and their three states.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'الْأَفْعَالُ الْخَمْسَةُ وَإِعْرَابُهَا (пять форм настоящего глагола и их изменение)',
    rule_ar = 'الْأَفْعَالُ الْخَمْسَةُ هِيَ كُلُّ فِعْلٍ مُضَارِعٍ اتَّصَلَتْ بِهِ وَاوُ الْجَمَاعَةِ أَوْ يَاءُ الْمُخَاطَبَةِ أَوْ أَلِفُ الِاثْنَيْنِ، وَصِيَغُهَا: يَفْعَلُونَ، وَتَفْعَلُونَ، وَتَفْعَلِينَ، وَيَفْعَلَانِ، وَتَفْعَلَانِ. وَعَلَامَةُ رَفْعِهَا ثُبُوتُ النُّونِ، وَعَلَامَةُ نَصْبِهَا وَجَزْمِهَا حَذْفُ النُّونِ.',
    summary = 'Пять форм — это настоящее время с وَاوُ الْجَمَاعَةِ, يَاءُ الْمُخَاطَبَةِ или أَلِفُ الِاثْنَيْنِ. В раф‘ ن сохраняется, в насбе и джазме удаляется.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Какие формы входят в пятёрку</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Лицо</th><th>Модель</th><th>Пример</th><th>Русское значение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْغَائِبُ الْجَمْعُ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">يَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْرُسُونَ</span></td><td>они учатся</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُخَاطَبُ الْجَمْعُ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">تَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْرُسُونَ</span></td><td>вы учитесь</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُخَاطَبَةُ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">تَفْعَلِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْرُسِينَ</span></td><td>ты учишься</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْغَائِبُ الْمُثَنَّى</span><span class="rule-table-ru">они двое</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">يَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْرُسَانِ</span></td><td>они двое учатся</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُخَاطَبُ الْمُثَنَّى</span><span class="rule-table-ru">вы двое</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">تَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْرُسَانِ</span></td><td>вы двое учитесь</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Раф‘, насб и джазм всех пяти форм</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Модель</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">сохранение ن</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">удаление ن</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْجَزْمُ</span><span class="rule-table-ru">удаление ن</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَذْهَبَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَذْهَبَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَذْهَبَا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">تَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَذْهَبَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَذْهَبَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَذْهَبَا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَذْهَبُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَذْهَبُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَذْهَبُوا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">تَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَذْهَبُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَذْهَبُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَذْهَبُوا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">تَفْعَلِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَذْهَبِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَذْهَبِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَذْهَبِي</span></td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$إعراب الأفعال الخمسة:
سبق شرحها بالتفصيل في الدرس الثامن عشر.
المضارع المرفوع والمضارع المنصوب والمضارع المجزوم، نحو: يذهبان، لن يذهبا، لم يذهبا؛ تذهبون، لن تذهبوا، لم تذهبوا؛ يذهبون، لن يذهبوا، لم يذهبوا.
علامة الرفع في الأفعال الخمسة: ثبوت النون. وعلامة النصب والجزم: حذف النون.$$,
      74, 74, 1),
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الأفعال الخمسة هي: كل فعل مضارع اتصلت به واو الجماعة، أو ياء المخاطبة، أو ألف الاثنين.
وتكون خمسة كالتالي:
1. الغائب: يدرسون.
2. المخاطب: تدرسون.
3. المخاطبة: تدرسين.
4. الغائب: يدرسان.
5. المخاطب: تدرسان.
علامة الرفع في الأفعال الخمسة: ثبوت النون، وعلامة النصب والجزم: حذف النون.$$,
      61, 61, 2);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '30'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 30 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id)
  ) <> 8 then
    raise exception 'Expected 8 Book 2 lesson 30 source rows';
  end if;

  if exists (
    select 1 from public.rules
    where id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id)
      and (content::text like '%←%' or content::text like '%→%')
  ) then
    raise exception 'Book 2 lesson 30 contains an RTL-hostile arrow';
  end if;
end
$migration$;

commit;
