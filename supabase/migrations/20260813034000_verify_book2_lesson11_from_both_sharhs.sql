-- Verify Medina Book 2 lesson 11 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF page 31, plus the lesson-boundary
--   material on PDF pages 27 and 29.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 24-25.
-- The second PDF has a damaged logical text layer. Its source_text below is a
-- literal manual transcription from the rendered pages, authorized by the owner.

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
  rule_7_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '11';

  if lesson_rule_count not in (6, 7) then
    raise exception 'Expected 6 or 7 Book 2 lesson 11 rules, found %', lesson_rule_count;
  end if;

  if lesson_rule_count = 6 then
    select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 1;
    select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 2;
    select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 3;
    select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 4;
    select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 5;
    select id into strict rule_7_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 6;

    update public.rules
    set sort_order = sort_order + 100
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '11';

    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values
      ('Мединский курс (Том 2)', '11', '', '', 4, 'rule', '', '')
    returning id into rule_4_id;
  else
    select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 1;
    select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 2;
    select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 3;
    select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 4;
    select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 5;
    select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 6;
    select id into strict rule_7_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '11' and sort_order = 7;
  end if;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '11'
  );

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id, rule_7_id);

  -- 1. Present-tense assignment to pronouns.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'إِسْنَادُ الْفِعْلِ الْمُضَارِعِ إِلَى الضَّمَائِرِ (спряжение глагола настоящего/будущего времени)',
    rule_ar = 'يُسْنَدُ الْفِعْلُ الْمُضَارِعُ إِلَى ضَمَائِرِ الْغَائِبِ وَالْمُخَاطَبِ وَالْمُتَكَلِّمِ بِحُرُوفِ الْمُضَارَعَةِ وَالضَّمَائِرِ الْمُتَّصِلَةِ، وَقَدْ يَكُونُ فَاعِلُهُ اسْمًا ظَاهِرًا أَوْ ضَمِيرًا مُسْتَتِرًا أَوْ ضَمِيرًا مُتَّصِلًا.',
    summary = 'Форма المضارع связывается с местоимениями отсутствующего, собеседника и говорящего; её исполнитель может быть явным именем, скрытым или присоединённым местоимением.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Правило из таблиц двух шархов</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">يُسْنَدُ <span class="ar-tone-verb">الْفِعْلُ الْمُضَارِعُ</span> إِلَى <span class="ar-tone-structure">ضَمَائِرِ الْغَائِبِ وَالْمُخَاطَبِ وَالْمُتَكَلِّمِ</span> بِحُرُوفِ الْمُضَارَعَةِ وَالضَّمَائِرِ الْمُتَّصِلَةِ، وَقَدْ يَكُونُ <span class="ar-tone-subject">فَاعِلُهُ</span> اسْمًا ظَاهِرًا أَوْ ضَمِيرًا مُسْتَتِرًا أَوْ ضَمِيرًا مُتَّصِلًا.</span>
        <p class="rule-study-text">Глагол настоящего/будущего времени спрягается с местоимениями отсутствующего, собеседника и говорящего. Исполнитель действия бывает выражен явным именем, скрытым местоимением либо присоединённым местоимением.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полная таблица форм</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th>Форма</th><th>Исполнитель</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَنَا أَذْهَبُ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنَا»</span><span class="rule-table-ru">скрытое «я»</span></td><td>Я иду.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَحْنُ نَذْهَبُ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «نَحْنُ»</span><span class="rule-table-ru">скрытое «мы»</span></td><td>Мы идём.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَنْتَ تَذْهَبُ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنْتَ»</span><span class="rule-table-ru">скрытое «ты»</span></td><td>Ты, мужчина, идёшь.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَنْتِ تَذْهَبِينَ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span><span class="rule-table-ru">ياء обращения к женщине</span></td><td>Ты, женщина, идёшь.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَنْتُمْ تَذْهَبُونَ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">واو множественного числа</span></td><td>Вы, мужчины, идёте.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَنْتُنَّ تَذْهَبْنَ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span><span class="rule-table-ru">نون женского множественного</span></td><td>Вы, женщины, идёте.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">هُوَ يَذْهَبُ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هُوَ»</span><span class="rule-table-ru">скрытое «он»</span></td><td>Он идёт.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">هِيَ تَذْهَبُ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هِيَ»</span><span class="rule-table-ru">скрытое «она»</span></td><td>Она идёт.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">هُمْ يَذْهَبُونَ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">واو множественного числа</span></td><td>Они, мужчины, идут.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">هُنَّ يَذْهَبْنَ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span><span class="rule-table-ru">نون женского множественного</span></td><td>Они, женщины, идут.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Различия, отмеченные в шархе</span>
        <div class="rule-example-list">
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">أَنْتَ</span> <span class="ar-tone-verb">تَذْهَبُ</span>، وَ<span class="ar-tone-subject">هِيَ</span> <span class="ar-tone-verb">تَذْهَبُ</span>.</span><span class="rule-example-ru">Ты, мужчина, идёшь; она идёт. Внешняя форма глагола одинакова, но исполнитель различен.</span></div>
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">يَذْهَبُ</span> مُحَمَّدٌ، <span class="ar-tone-verb">يَدْرُسُ</span> الطَّالِبُ.</span><span class="rule-example-ru">Мухаммад идёт; студент учится. С мужским исполнителем третьего лица употреблено начальное يَـ.</span></div>
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">تَذْهَبُ</span> مَرْيَمُ، <span class="ar-tone-verb">تَدْرُسُ</span> الطَّالِبَةُ.</span><span class="rule-example-ru">Марьям идёт; студентка учится. С женским исполнителем третьего лица употреблено начальное تَـ.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$إسناد الفعل المضارع (الفعل: يذهب)
أذهب، تذهب، تذهبين، يذهب، تذهب، نذهب، تذهبون، تذهبن، يذهبون، يذهبن.$$, 27, 27, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إِسْنَادُ الفِعْلِ المُضَارِعِ إِلَى الضَّمَائِرِ
الطلابُ يَذْهَبُونَ: واوُ الجماعةِ. حامدٌ يَذْهَبُ: ضميرٌ مستترٌ (هو).
الطالباتُ يَذْهَبْنَ: نونُ النسوةِ. آمنةُ تَذْهَبُ: ضميرٌ مستترٌ (هي).
أنتم تَذْهَبُونَ: واوُ الجماعةِ. أنتَ تَذْهَبُ: ضميرٌ مستترٌ (أنتَ).
أنتنَّ تَذْهَبْنَ: نونُ النسوةِ. أنتِ تَذْهَبِينَ: ياءُ المخاطبةِ.
نحن نَذْهَبُ: ضميرٌ مستترٌ (نحن). أنا أَذْهَبُ: ضميرٌ مستترٌ (أنا).
المخاطبُ المذكرُ، والغائبُ المؤنثُ: لفظُهما في المضارعِ واحدٌ: تَذْهَبُ.
تقولُ: أنتَ تَذْهَبُ، وهي تَذْهَبُ.
الفعلُ المضارعُ مع الفاعلِ المذكرِ يبدأُ بحرفِ الياءِ: يَذْهَبُ محمدٌ، يَدْرُسُ الطالبُ.
الفعلُ المضارعُ مع الفاعلِ المؤنثِ يبدأُ بحرفِ التاءِ: تَذْهَبُ مريمُ، تَدْرُسُ الطالبةُ.$$, 24, 24, 2);

  -- 2. Nominative markers and construction on sukūn.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'عَلَامَاتُ رَفْعِ الْمُضَارِعِ وَبِنَاؤُهُ (признаки رفع и неизменяемость المضارع)',
    rule_ar = 'أَذْهَبُ وَتَذْهَبُ وَيَذْهَبُ وَنَذْهَبُ مَرْفُوعَةٌ بِالضَّمَّةِ، وَيَذْهَبُونَ وَتَذْهَبُونَ وَتَذْهَبِينَ مَرْفُوعَةٌ بِثُبُوتِ النُّونِ، وَيَذْهَبْنَ وَتَذْهَبْنَ مَبْنِيَّةٌ عَلَى السُّكُونِ لِاتِّصَالِهَا بِنُونِ النِّسْوَةِ.',
    summary = 'Обычные формы имеют رفع с даммой, формы с واو الجماعة и ياء المخاطبة - رفع посредством сохранения ن, а формы с نون النسوة построены на сукуне.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три состояния окончаний из шарха</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَذْهَبُ وَتَذْهَبُ وَيَذْهَبُ وَنَذْهَبُ</span> <span class="ar-tone-raf">مَرْفُوعَةٌ بِالضَّمَّةِ</span>، وَ<span class="ar-tone-verb">يَذْهَبُونَ وَتَذْهَبُونَ وَتَذْهَبِينَ</span> <span class="ar-tone-raf">مَرْفُوعَةٌ بِثُبُوتِ النُّونِ</span>، وَ<span class="ar-tone-verb">يَذْهَبْنَ وَتَذْهَبْنَ</span> <span class="ar-tone-structure">مَبْنِيَّةٌ عَلَى السُّكُونِ</span>.</span>
        <p class="rule-study-text">Формы без присоединённых окончаний имеют رفع с явной даммой. Формы с <span class="ar-inline" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span> и <span class="ar-inline" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span> имеют رفع посредством сохранения ن. Формы с <span class="ar-inline" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span> построены на сукуне.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Таблица окончания и исполнителя</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Формы</th><th>Грамматическое состояние</th><th>Исполнитель</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَذْهَبُ، تَذْهَبُ، يَذْهَبُ، نَذْهَبُ</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">مَرْفُوعٌ بِالضَّمَّةِ الظَّاهِرَةِ</span><span class="rule-table-ru">رفع с явной даммой</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ</span><span class="rule-table-ru">скрытое местоимение</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَذْهَبُونَ، تَذْهَبُونَ</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">مَرْفُوعٌ بِثُبُوتِ النُّونِ</span><span class="rule-table-ru">رفع посредством сохранения ن</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">واو множественного числа</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَذْهَبِينَ</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">مَرْفُوعٌ بِثُبُوتِ النُّونِ</span><span class="rule-table-ru">رفع посредством сохранения ن</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span><span class="rule-table-ru">ياء обращения к женщине</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَذْهَبْنَ، تَذْهَبْنَ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">построен на сукуне</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span><span class="rule-table-ru">نون женского множественного</span></td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$أذهبُ: فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "أنا".
تذهبُ: فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "أنت".
تذهبين: فعل مضارع مرفوع وعلامة رفعه ثبوت النون، والفاعل ياء المخاطبة.
يذهبُ: فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "هو".
تذهبُ: فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "هي".
نذهبُ: فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "نحن".
تذهبون: فعل مضارع مرفوع وعلامة رفعه ثبوت النون، والفاعل واو الجماعة.
تذهبن: فعل مضارع مبني على السكون، والفاعل نون النسوة.
يذهبون: فعل مضارع مرفوع وعلامة رفعه ثبوت النون، والفاعل واو الجماعة.
يذهبن: فعل مضارع مبني على السكون، والفاعل نون النسوة.$$, 27, 27, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$أَذْهَبُ، تَذْهَبُ، يَذْهَبُ، نَذْهَبُ: علامةُ الرفعِ الضمةُ.
يَذْهَبُونَ، تَذْهَبِينَ: علامةُ الرفعِ ثبوتُ النونِ.
يَذْهَبْنَ، تَذْهَبْنَ: مَبْنِيٌّ على السكونِ.$$, 24, 24, 2);

  -- 3. Negative mā and lā.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'مَا وَلَا النَّافِيَتَانِ (отрицательные частицы مَا и لَا)',
    rule_ar = 'تُسْتَعْمَلُ «مَا» النَّافِيَةُ مَعَ الْفِعْلِ الْمَاضِي، وَتُسْتَعْمَلُ «لَا» النَّافِيَةُ مَعَ الْفِعْلِ الْمُضَارِعِ؛ وَقَدْ تُسْتَعْمَلُ «مَا» مَعَ الْمُضَارِعِ لِنَفْيِ الْفِعْلِ فِي الْوَقْتِ الْحَاضِرِ.',
    summary = 'مَا обычно отрицает прошедший глагол, لَا - глагол настоящего/будущего времени; 80-страничный шарх отдельно показывает مَا с المضارع для отрицания действия сейчас.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Различие двух частиц</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">تُسْتَعْمَلُ <span class="ar-tone-structure">«مَا» النَّافِيَةُ</span> مَعَ <span class="ar-tone-verb">الْفِعْلِ الْمَاضِي</span>، وَتُسْتَعْمَلُ <span class="ar-tone-structure">«لَا» النَّافِيَةُ</span> مَعَ <span class="ar-tone-verb">الْفِعْلِ الْمُضَارِعِ</span>.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">مَا</span> обычно отрицает действие в прошлом, а <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">لَا</span> - действие настоящего/будущего времени.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры с مَا и прошедшим временем</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">مَا</span> <span class="ar-tone-verb">ذَهَبْتُ</span>.</span><span class="rule-example-ru">Я не ходил.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">مَا</span> <span class="ar-tone-verb">كَتَبَ</span> عَلِيٌّ الدَّرْسَ.</span><span class="rule-example-ru">Али не написал урок.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">مَا</span> <span class="ar-tone-verb">شَرِبْنَا</span> الْعَصِيرَ.</span><span class="rule-example-ru">Мы не пили сок.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">مَا</span> <span class="ar-tone-verb">شَرِبَ</span> أَبِي الْقَهْوَةَ أَمْسِ.</span><span class="rule-example-ru">Мой отец вчера не пил кофе.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры с لَا и настоящим временем</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">لَا</span> <span class="ar-tone-verb">أَذْهَبُ</span>.</span><span class="rule-example-ru">Я не иду.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">لَا</span> <span class="ar-tone-verb">يَكْتُبُ</span> عَلِيٌّ الدَّرْسَ.</span><span class="rule-example-ru">Али не пишет урок.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">لَا</span> <span class="ar-tone-verb">نَشْرَبُ</span> الْعَصِيرَ.</span><span class="rule-example-ru">Мы не пьём сок.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">لَا</span> <span class="ar-tone-verb">يَشْرَبُ</span> أَبِي الشَّايَ.</span><span class="rule-example-ru">Мой отец не пьёт чай.</span></div>
        </div>
      </div>
      <div class="rule-check-card"><span class="ar-inline" dir="rtl" lang="ar">مَا أَشْرَبُ الشَّايَ.</span><br>80-страничный шарх поясняет: «Я не пью чай сейчас, но выпью его позднее, если пожелает Аллах». Это отдельный показанный случай употребления <span class="ar-inline" dir="rtl" lang="ar">مَا</span> с настоящим временем.</div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$الفرق بين "ما" و"لا" النافيتين
"ما" النافية تستعمل مع الفعل الماضي، نحو:
ما شرب أبي القهوة أمس.
"لا" النافية تستعمل مع الفعل المضارع، نحو:
لا يشرب أبي الشاي.
قد تستعمل "ما" النافية مع الفعل المضارع، نحو:
ما أشرب الشاي (هذا يعني لا أشرب الشاي الآن لكن سأشربه فيما بعد إن شاء الله).$$, 29, 29, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$مَا ، وَلَا النَّافِيَتَانِ
يُنْفَى الفعلُ الماضي بـ (مَا) النَّافِيَةِ: مَا ذَهَبْتُ، مَا كَتَبَ عَلِيٌّ الدرسَ، مَا شَرِبْنَا العصيرَ.
يُنْفَى الفعلُ المضارعُ بـ (لَا) النَّافِيَةِ: لَا أَذْهَبُ، لَا يَكْتُبُ عَلِيٌّ الدرسَ، لَا نَشْرَبُ العصيرَ.$$, 24, 24, 2);

  -- 4. Near and distant future.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'سِينُ الِاسْتِقْبَالِ وَسَوْفَ (будущее время с سَـ и سَوْفَ)',
    rule_ar = 'حَرْفَا الِاسْتِقْبَالِ هُمَا السِّينُ وَسَوْفَ؛ تَتَّصِلُ السِّينُ بِالْفِعْلِ الْمُضَارِعِ، وَيَذْكُرُ الشَّرْحُ أَنَّهَا لِلْمُسْتَقْبَلِ الْقَرِيبِ، وَأَنَّ «سَوْفَ» لِلْمُسْتَقْبَلِ الْبَعِيدِ.',
    summary = 'سَـ присоединяется к المضارع и в шархе обозначает близкое будущее; سَوْفَ пишется отдельно и приводится для далёкого будущего.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Два обозначения будущего</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">حَرْفَا الِاسْتِقْبَالِ هُمَا <span class="ar-tone-structure">السِّينُ</span> وَ<span class="ar-tone-structure">سَوْفَ</span>؛ تَتَّصِلُ السِّينُ بِ<span class="ar-tone-verb">الْفِعْلِ الْمُضَارِعِ</span>، وَهِيَ لِلْمُسْتَقْبَلِ الْقَرِيبِ، وَ«سَوْفَ» لِلْمُسْتَقْبَلِ الْبَعِيدِ.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">سَـ</span> пишется слитно с глаголом настоящего/будущего времени и обозначает близкое будущее. <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">سَوْفَ</span> пишется отдельно и в шархе приводится для далёкого будущего.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры будущего</span>
        <div class="rule-example-list">
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">سَأَذْهَبُ</span>، أَوْ <span class="ar-tone-verb">سَوْفَ أَذْهَبُ</span>.</span><span class="rule-example-ru">Я пойду - с سَـ или с سَوْفَ.</span></div>
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">سَيَرْجِعُ</span> الْمُدِيرُ غَدًا إِنْ شَاءَ اللَّهُ.</span><span class="rule-example-ru">Директор вернётся завтра, если пожелает Аллах.</span></div>
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">سَأَذْهَبُ</span> إِلَى مَكَّةَ بَعْدَ أُسْبُوعٍ إِنْ شَاءَ اللَّهُ.</span><span class="rule-example-ru">Я поеду в Мекку через неделю, если пожелает Аллах.</span></div>
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">سَأَغْسِلُ</span> مَلَابِسِي بَعْدَ يَوْمَيْنِ إِنْ شَاءَ اللَّهُ.</span><span class="rule-example-ru">Я постираю свою одежду через два дня, если пожелает Аллах.</span></div>
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">سَوْفَ أُسَافِرُ</span> الشَّهْرَ الْقَادِمَ.</span><span class="rule-example-ru">Я отправлюсь в поездку в следующем месяце.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$حرف الاستقبال
حرف الاستقبال هو السين (س) وسوف، نحو: سأذهب، أو سوف أذهب.$$, 31, 31, 1),
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$حَرْفُ الاسْتِقْبَالِ
حرفُ الاستقبالِ: السِّينُ، وهو للمستقبلِ القريبِ.
تقولُ: سَيَرْجِعُ المديرُ غدًا إن شاءَ اللهُ. سَأَذْهَبُ إلى مكةَ بعدَ أسبوعٍ إن شاءَ اللهُ. سَأَغْسِلُ ملابسي بعدَ يومينِ إن شاءَ اللهُ.
للاستقبالِ حرفٌ آخرُ، هو: سَوْفَ، ويستعملُ للمستقبلِ البعيدِ: سَوْفَ أُسَافِرُ الشهرَ القادمَ.$$, 24, 25, 2);

  -- 5. Verbal noun on fuʿūl.
  update public.rules
  set
    sort_order = 5,
    rule_kind = 'rule',
    title = 'مَصْدَرُ الْفِعْلِ الْمَاضِي عَلَى وَزْنِ فُعُولٍ (масдар прошедшего глагола модели فُعُول)',
    rule_ar = 'لِلْفِعْلِ الْمَاضِي مَصَادِرُ كَثِيرَةٌ، وَمِنْهَا مَصْدَرٌ عَلَى وَزْنِ «فُعُولٍ».',
    summary = 'У прошедшего глагола бывает много масдаров; среди показанных в шархе есть масдары модели فُعُول.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Правило</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">لِلْفِعْلِ الْمَاضِي <span class="ar-tone-structure">مَصَادِرُ كَثِيرَةٌ</span>، وَمِنْهَا مَصْدَرٌ عَلَى وَزْنِ <span class="ar-tone-verb">«فُعُولٍ»</span>.</span>
        <p class="rule-study-text">У прошедшего глагола есть разные масдары. В этом уроке показана модель <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">فُعُولٌ</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все пары глагол - масдар</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Глагол</th><th>Масдар</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">دَخَلَ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">دُخُولٌ</span></td><td>войти - вход</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَجَعَ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">رُجُوعٌ</span></td><td>вернуться - возвращение</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَزَلَ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">نُزُولٌ</span></td><td>спуститься - спуск</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَكِبَ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">رُكُوبٌ</span></td><td>сесть верхом/в транспорт - езда</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">جَلَسَ يَجْلِسُ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">جُلُوسٌ</span></td><td>сидеть - сидение</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">سَجَدَ يَسْجُدُ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">سُجُودٌ</span></td><td>совершать земной поклон - земной поклон</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَكَعَ يَرْكَعُ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">رُكُوعٌ</span></td><td>совершать поясной поклон - поясной поклон</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">صَعِدَ يَصْعَدُ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">صُعُودٌ</span></td><td>подниматься - подъём</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все предложения с масдарами</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْجُلُوسُ هُنَا مَمْنُوعٌ.</span><span class="rule-example-ru">Сидеть здесь запрещено.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَجِبُ السُّجُودُ لِلَّهِ وَحْدَهُ.</span><span class="rule-example-ru">Земной поклон следует совершать одному Аллаху.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">نَقُولُ فِي الرُّكُوعِ: سُبْحَانَ اللَّهِ الْعَظِيمِ.</span><span class="rule-example-ru">В поясном поклоне мы говорим: «Пречист Великий Аллах».</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الصُّعُودُ عَلَى الْجَبَلِ صَعْبٌ.</span><span class="rule-example-ru">Подъём на гору труден.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أُحِبُّ رُكُوبَ الْخَيْلِ.</span><span class="rule-example-ru">Я люблю верховую езду.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَدْخُلُ الطُّلَّابُ قَبْلَ دُخُولِ الْمُدَرِّسِ، وَيَخْرُجُونَ بَعْدَ خُرُوجِهِ.</span><span class="rule-example-ru">Студенты входят до входа преподавателя и выходят после его выхода.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_5_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$المصدر على وزن "فُعُول"
دخل: دُخُولٌ
رجع: رُجُوعٌ
نزل: نُزُولٌ
ركب: رُكُوبٌ$$, 31, 31, 1),
    (rule_5_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$مَصْدَرُ الفِعْلِ المَاضِي
للفعلِ الماضي مصادرُ كثيرةٌ، منها مصدرٌ على وزنِ (فُعُولٍ).
أمثلةٌ: جَلَسَ يَجْلِسُ: جُلُوسٌ. الجُلُوسُ هنا ممنوعٌ.
سَجَدَ يَسْجُدُ: سُجُودٌ. يَجِبُ السُّجُودُ للهِ وحدَهُ.
رَكَعَ يَرْكَعُ: رُكُوعٌ. نَقُولُ في الرُّكُوعِ سبحانَ اللهِ العظيمِ.
صَعِدَ يَصْعَدُ: صُعُودٌ. الصُّعُودُ على الجبلِ صعبٌ.
أُحِبُّ رُكُوبَ الخَيْلِ. يدخلُ الطلابُ قبلَ دُخُولِ المدرسِ ويخرجونَ بعدَ خُرُوجِهِ.$$, 25, 25, 2);

  -- 6. Ammā and the obligatory fāʾ response.
  update public.rules
  set
    sort_order = 6,
    rule_kind = 'rule',
    title = 'أَمَّا ... فَـ (оборот «что касается..., то...»)',
    rule_ar = '«أَمَّا» حَرْفُ تَفْصِيلٍ وَشَرْطٍ يَدُلُّ عَلَى التَّفْصِيلِ بَيْنَ شَيْئَيْنِ أَوْ أَكْثَرَ، وَيَقْتَرِنُ جَوَابُهُ وُجُوبًا بِالْفَاءِ.',
    summary = 'أَمَّا вводит разделение между двумя или несколькими предметами; ответ на неё обязательно начинается с فَـ.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Правило из двух шархов</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">«أَمَّا»</span> حَرْفُ تَفْصِيلٍ وَشَرْطٍ يَدُلُّ عَلَى التَّفْصِيلِ بَيْنَ شَيْئَيْنِ أَوْ أَكْثَرَ، وَيَقْتَرِنُ جَوَابُهُ وُجُوبًا بِ<span class="ar-tone-structure">الْفَاءِ</span>.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">أَمَّا</span> разделяет два или несколько предметов разговора. Ответ на неё обязательно присоединяется с помощью <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">فَـ</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры из обоих шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">فَأَمَّا الْيَتِيمَ فَلَا تَقْهَرْ، وَأَمَّا السَّائِلَ فَلَا تَنْهَرْ، وَأَمَّا بِنِعْمَةِ رَبِّكَ فَحَدِّثْ.</span><span class="rule-example-ru">Что касается сироты, то не притесняй его; что касается просящего, то не прогоняй его; а о милости твоего Господа возвещай.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ تَسْكُنُ؟ أَمَّا أَنَا فَأَسْكُنُ فِي الْمَهْجَعِ الثَّامِنِ، وَأَمَّا عَلِيٌّ فَيَسْكُنُ فِي الْمَهْجَعِ الْأَوَّلِ.</span><span class="rule-example-ru">Где ты живёшь? Что касается меня, я живу в восьмом общежитии, а Али живёт в первом общежитии.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">بِكَمِ الْكِتَابُ وَالْمَجَلَّةُ؟ أَمَّا الْكِتَابُ فَهُوَ بِعَشَرَةِ رِيَالَاتٍ، وَأَمَّا الْمَجَلَّةُ فَهِيَ بِثَلَاثَةِ رِيَالَاتٍ.</span><span class="rule-example-ru">Сколько стоят книга и журнал? Книга стоит десять риялов, а журнал - три рияла.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ يَدْرُسُ حَامِدٌ وَخَالِدٌ وَخَدِيجَةُ؟ أَمَّا حَامِدٌ فَيَدْرُسُ فِي الثَّانَوِيَّةِ، وَأَمَّا خَالِدٌ فَيَدْرُسُ فِي كُلِّيَّةِ الْحَدِيثِ، وَأَمَّا خَدِيجَةُ فَتَدْرُسُ فِي كُلِّيَّةِ الشَّرِيعَةِ.</span><span class="rule-example-ru">Где учатся Хамид, Халид и Хадиджа? Хамид учится в средней школе, Халид - на факультете хадиса, а Хадиджа - на факультете шариата.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_6_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_6_id, 'Podrobny_Sharkh_2_tom.pdf', $$حرف التفصيل: "أما"
أما: حرف تفصيل وشرط، جوابه يقترن وجوبا بالفاء، نحو:
قال تعالى: (فأما اليتيم فلا تقهر. وأما السائل فلا تنهر. وأما بنعمة ربك فحدث).
ونحو: أين تسكن؟
أما أنا فأسكن في المهجع الثامن، وأما علي فيسكن في المهجع الأول.$$, 31, 31, 1),
    (rule_6_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$أَمَّا
أَمَّا: حرفٌ يدلُّ على التفصيلِ بين شيئينِ، أو أكثرَ.
أمثلةٌ: بِكَمِ الكتابُ والمجلةُ؟ أمَّا الكتابُ فهو بعشرةِ ريالاتٍ وأمَّا المجلةُ فهي بثلاثةِ ريالاتٍ.
أينَ يدرسُ حامدٌ وخالدٌ وخديجةُ؟ أمَّا حامدٌ فيدرسُ في الثانويةِ وأمَّا خالدٌ فيدرسُ في كليةِ الحديثِ وأمَّا خديجةُ فتدرسُ في كليةِ الشريعةِ.
قال تعالى: ﴿فَأَمَّا الْيَتِيمَ فَلَا تَقْهَرْ ۝ وَأَمَّا السَّائِلَ فَلَا تَنْهَرْ ۝ وَأَمَّا بِنِعْمَةِ رَبِّكَ فَحَدِّثْ﴾$$, 25, 25, 2);

  -- 7. Definite possessive and indefinite "one of mine".
  update public.rules
  set
    sort_order = 7,
    rule_kind = 'rule',
    title = 'أَخِي وَأَخٌ لِي (определённое «мой брат» и неопределённое «один мой брат»)',
    rule_ar = 'إِذَا أُضِيفَ الِاسْمُ إِلَى يَاءِ الْمُتَكَلِّمِ كَانَ مَعْرِفَةً: أَخِي، وَصَدِيقِي، وَقَرِيبِي؛ وَإِذَا أُرِيدَ تَنْكِيرُهُ فُصِلَ بَيْنَ الِاسْمِ وَيَاءِ الْمُتَكَلِّمِ بِاللَّامِ: أَخٌ لِي، وَصَدِيقٌ لِي، وَقَرِيبٌ لِي.',
    summary = 'Прямое присоединение ياء المتكلم делает имя определённым; для неопределённого значения между именем и значением принадлежности ставится لِـ.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Определённая и неопределённая конструкция</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">إِذَا أُضِيفَ الِاسْمُ إِلَى <span class="ar-tone-structure">يَاءِ الْمُتَكَلِّمِ</span> كَانَ مَعْرِفَةً؛ وَإِذَا أُرِيدَ تَنْكِيرُهُ فُصِلَ بَيْنَ الِاسْمِ وَيَاءِ الْمُتَكَلِّمِ بِ<span class="ar-tone-jarr">اللَّامِ</span>.</span>
        <p class="rule-study-text">При прямом присоединении «моего» имя становится определённым: речь идёт о конкретном брате, друге или родственнике. Для неопределённого значения «один мой...» употребляется отдельная конструкция с <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">لِي</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все формы из двух шархов</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Определённое</th><th>Русский смысл</th><th>Неопределённое</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">أَخِي</span></td><td>мой конкретный брат</td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">أَخٌ لِي</span></td><td>один мой брат</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">صَدِيقِي</span></td><td>мой конкретный друг</td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">صَدِيقٌ لِي</span></td><td>один мой друг</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">قَرِيبِي</span></td><td>мой конкретный родственник</td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">قَرِيبٌ لِي</span></td><td>один мой родственник</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Парный пример</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">جَاءَ صَدِيقِي.</span><span class="rule-example-ru">Пришёл мой определённый друг.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">جَاءَ صَدِيقٌ لِي.</span><span class="rule-example-ru">Пришёл один мой друг.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_7_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_7_id, 'Podrobny_Sharkh_2_tom.pdf', $$التركيب "أخ لي"
إذا قلت: أخي وهو معرفة، وإذا أردت تنكيره قلت: أخ لي بإدخال حرف الجر اللام على ياء المتكلم.
مثال آخر: جاء صديقي، جاء صديق لي.$$, 31, 31, 1),
    (rule_7_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$أَخِي، وَأَخٌ لِي
إذا أردتَ تعريفَ شخصٍ مُعَيَّنٍ، قلتَ: أَخِي، صَدِيقِي، قَرِيبِي (بالإضافةِ إلى ياءِ المتكلمِ).
وإذا أردتَ تنكيرَهُ، قلتَ: أَخٌ لِي، صَدِيقٌ لِي، قَرِيبٌ لِي (تفصلُ باللامِ بين الاسمِ وياءِ المتكلمِ).$$, 25, 25, 2);
end
$migration$;

commit;
