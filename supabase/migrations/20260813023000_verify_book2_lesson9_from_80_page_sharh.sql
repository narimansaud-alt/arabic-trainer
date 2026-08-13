-- Verify Medina Book 2 lesson 9 against the complete 80-page Arabic sharh.
-- Sole source: Podrobny_Sharkh_2_tom.pdf, PDF pages 25-26.

begin;

do $migration$
declare
  lesson_rule_count integer;
  verified_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
  rule_4_id bigint;
  rule_5_id bigint;
  rule_6_id bigint;
  rule_7_id bigint;
begin
  select count(*), count(*) filter (where coalesce(rule_ar, '') <> '')
  into lesson_rule_count, verified_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '9';

  if lesson_rule_count <> 7 or verified_rule_count not in (0, 7) then
    raise exception 'Expected 7 uniformly verified/unverified Book 2 lesson 9 rules, found % rules and % verified', lesson_rule_count, verified_rule_count;
  end if;

  if verified_rule_count = 0 then
    select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 1;
    select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 2;
    select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 3;
    select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 4;
    select id into strict rule_7_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 5;
    select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 6;
    select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 7;
    update public.rules
    set sort_order = sort_order + 100
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '9';
  else
    select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 1;
    select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 2;
    select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 3;
    select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 4;
    select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 5;
    select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 6;
    select id into strict rule_7_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 7;
  end if;

  delete from public.rule_sections
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id, rule_7_id);

  -- 1. Accusative marker of the sound feminine plural.
  update public.rules
  set
    sort_order = 1,
    title = 'عَلَامَةُ النَّصْبِ فِي جَمْعِ الْمُؤَنَّثِ السَّالِمِ (винительное состояние правильного женского множественного)',
    rule_ar = 'عَلَامَةُ نَصْبِ جَمْعِ الْمُؤَنَّثِ السَّالِمِ الْكَسْرَةُ الظَّاهِرَةُ نِيَابَةً عَنِ الْفَتْحَةِ.',
    summary = 'عَلَامَةُ نَصْبِ جَمْعِ الْمُؤَنَّثِ السَّالِمِ الْكَسْرَةُ الظَّاهِرَةُ نِيَابَةً عَنِ الْفَتْحَةِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">عَلَامَةُ نَصْبِ <span class="ar-tone-structure">جَمْعِ الْمُؤَنَّثِ السَّالِمِ</span> هِيَ <span class="ar-tone-nasb">الْكَسْرَةُ الظَّاهِرَةُ نِيَابَةً عَنِ الْفَتْحَةِ</span>.</span><p class="rule-study-text">У правильного женского множественного показателем винительного состояния служит явная касра вместо фатхи.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Сравнение и полный разбор</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример</span></th><th><span class="rule-table-ar">إِعْرَابُ الْمَفْعُولِ بِهِ</span><span class="rule-table-ru">разбор прямого дополнения</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar"><span class="ar-tone-verb">قَرَأْتُ</span> <span class="ar-tone-nasb">الْمَجَلَّةَ</span>.</span><span class="rule-table-ru">Я прочитал журнал.</span></td><td><span class="rule-table-ar ar-tone-nasb">«الْمَجَلَّةَ» مَفْعُولٌ بِهِ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-table-ru">«Журнал» — дополнение; показатель винительного состояния — явная фатха.</span></td></tr><tr><td><span class="rule-table-ar"><span class="ar-tone-verb">قَرَأْتُ</span> <span class="ar-tone-nasb">الْمَجَلَّاتِ</span>.</span><span class="rule-table-ru">Я прочитал журналы.</span></td><td><span class="rule-table-ar ar-tone-nasb">«الْمَجَلَّاتِ» مَفْعُولٌ بِهِ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْكَسْرَةُ الظَّاهِرَةُ نِيَابَةً عَنِ الْفَتْحَةِ؛ لِأَنَّهُ جَمْعُ مُؤَنَّثٍ سَالِمٌ.</span><span class="rule-table-ru">«Журналы» — дополнение; показатель — явная касра вместо фатхи, потому что это правильное женское множественное.</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_1_id;

  -- 2. The source exclamation pattern and example.
  update public.rules
  set
    sort_order = 2,
    title = 'فِعْلُ التَّعَجُّبِ «مَا أَفْعَلَهُ!» (восклицательная модель «как прекрасен…!»)',
    rule_ar = 'صِيغَةُ التَّعَجُّبِ هِيَ «مَا أَفْعَلَهُ!». فِي جُمْلَةِ «خَطُّكَ جَمِيلٌ» نَقُولُ: «مَا أَجْمَلَ خَطَّكَ!».',
    summary = 'صِيغَةُ التَّعَجُّبِ هِيَ «مَا أَفْعَلَهُ!». فِي جُمْلَةِ «خَطُّكَ جَمِيلٌ» نَقُولُ: «مَا أَجْمَلَ خَطَّكَ!».',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Модель</span><span class="rule-main-ar" dir="rtl" lang="ar">فِعْلُ التَّعَجُّبِ: <span class="ar-tone-verb">«مَا أَفْعَلَهُ!»</span></span><p class="rule-study-text">Эта модель выражает восклицание и сильное впечатление.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Преобразование из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">خَطُّكَ</span> <span class="ar-tone-predicate">جَمِيلٌ</span>.</span><span class="rule-example-ru">Твой почерк красив.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">مَا أَجْمَلَ</span> <span class="ar-tone-nasb">خَطَّكَ</span>!</span><span class="rule-example-ru">Как красив твой почерк!</span></div></div></div><div class="rule-check-card"><b>عَلَامَةُ التَّعَجُّبِ — восклицательный знак:</b> !</div></div>$$
  where id = rule_2_id;

  -- 3. Two source kinds of vocative and their endings.
  update public.rules
  set
    sort_order = 3,
    title = 'نِدَاءُ الْعَلَمِ الْمُفْرَدِ وَالْمُضَافِ (обращение к одиночному имени и идафе)',
    rule_ar = 'الْمُنَادَى الْعَلَمُ الْمُفْرَدُ مَبْنِيٌّ عَلَى الضَّمِّ، نَحْوُ: يَا مُحَمَّدُ. وَالْمُنَادَى الْمُضَافُ مَنْصُوبٌ، نَحْوُ: يَا عَبْدَ اللهِ.',
    summary = 'الْمُنَادَى الْعَلَمُ الْمُفْرَدُ مَبْنِيٌّ عَلَى الضَّمِّ، نَحْوُ: يَا مُحَمَّدُ. وَالْمُنَادَى الْمُضَافُ مَنْصُوبٌ، نَحْوُ: يَا عَبْدَ اللهِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Два вида обращения</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">نَوْعُ الْمُنَادَى</span><span class="rule-table-ru">вид обращения</span></th><th><span class="rule-table-ar">حُكْمُهُ</span><span class="rule-table-ru">его окончание</span></th><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример и перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-subject">الْعَلَمُ الْمُفْرَدُ</span><span class="rule-table-ru">одиночное имя собственное</span></td><td><span class="rule-table-ar ar-tone-raf">مَبْنِيٌّ عَلَى الضَّمِّ</span><span class="rule-table-ru">построено на дамме</span></td><td><span class="rule-table-ar">يَا <span class="ar-tone-subject">مُحَمَّدُ</span>!</span><span class="rule-table-ru">О Мухаммад!</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure">الْمُضَافُ</span><span class="rule-table-ru">обращение в идафе</span></td><td><span class="rule-table-ar ar-tone-nasb">مَنْصُوبٌ</span><span class="rule-table-ru">стоит в винительном состоянии</span></td><td><span class="rule-table-ar">يَا <span class="ar-tone-nasb">عَبْدَ</span> <span class="ar-tone-jarr">اللهِ</span>!</span><span class="rule-table-ru">О раб Аллаха!</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_3_id;

  -- 4. Interrogative hamza before a noun made definite by ال.
  update public.rules
  set
    sort_order = 4,
    title = 'دُخُولُ هَمْزَةِ الاِسْتِفْهَامِ عَلَى الْمُحَلَّى بِـ«الْـ» (вопросительная хамза перед артиклем)',
    rule_ar = 'إِذَا دَخَلَتْ هَمْزَةُ الاِسْتِفْهَامِ عَلَى الْمُحَلَّى بِـ«الْـ»، نَقُولُ بِالْمَدِّ: «أَ + الْآنَ ← آلْآنَ فَهِمْتَ؟».',
    summary = 'إِذَا دَخَلَتْ هَمْزَةُ الاِسْتِفْهَامِ عَلَى الْمُحَلَّى بِـ«الْـ»، نَقُولُ بِالْمَدِّ: «أَ + الْآنَ ← آلْآنَ فَهِمْتَ؟».',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило и исходное сложение</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">أَ</span> + <span class="ar-tone-structure">الْآنَ</span> ← <span class="ar-tone-verb">آلْآنَ فَهِمْتَ؟</span></span><p class="rule-study-text">Когда вопросительная хамза входит перед словом с определённым артиклем, в данном примере получается чтение с маддом: «Теперь ты понял?»</p></div><div class="rule-check-card"><b>بِالْمَدِّ — с удлинением.</b> В результате пишется начальная <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">آ</span>, а не две раздельные хамзы.</div></div>$$
  where id = rule_4_id;

  -- 5. Deletion of the alif of interrogative ما after a preposition.
  update public.rules
  set
    sort_order = 5,
    title = 'حَذْفُ أَلِفِ «مَا» الاِسْتِفْهَامِيَّةِ (удаление алифа вопросительного مَا)',
    rule_ar = 'إِذَا دَخَلَ حَرْفُ الْجَرِّ عَلَى «مَا» الاِسْتِفْهَامِيَّةِ حُذِفَتْ أَلِفُهَا: بِمَ، وَلِمَ، وَعَمَّ، وَمِمَّ.',
    summary = 'إِذَا دَخَلَ حَرْفُ الْجَرِّ عَلَى «مَا» الاِسْتِفْهَامِيَّةِ حُذِفَتْ أَلِفُهَا: بِمَ، وَلِمَ، وَعَمَّ، وَمِمَّ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا دَخَلَ <span class="ar-tone-jarr">حَرْفُ الْجَرِّ</span> عَلَى <span class="ar-tone-structure">«مَا» الاِسْتِفْهَامِيَّةِ</span> حُذِفَتْ أَلِفُهَا.</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">لِمَ</span> خَرَجْتَ مِنَ الْفَصْلِ؟</span><span class="rule-example-ru">Почему ты вышел из класса?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полный ряд из шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">التَّرْكِيبُ</span><span class="rule-table-ru">состав</span></th><th><span class="rule-table-ar">بَعْدَ حَذْفِ الْأَلِفِ</span><span class="rule-table-ru">после удаления алифа</span></th><th><span class="rule-table-ar">الْمَعْنَى</span><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">لِ + مَا</span><span class="rule-table-ru">лям + «что?»</span></td><td><span class="rule-table-ar ar-tone-structure">لِمَ</span><span class="rule-table-ru">алиф удалён</span></td><td><span class="rule-table-ru">почему? для чего?</span></td></tr><tr><td><span class="rule-table-ar">بِ + مَا</span><span class="rule-table-ru">ба + «что?»</span></td><td><span class="rule-table-ar ar-tone-structure">بِمَ</span><span class="rule-table-ru">алиф удалён</span></td><td><span class="rule-table-ru">чем? посредством чего?</span></td></tr><tr><td><span class="rule-table-ar">عَنْ + مَا</span><span class="rule-table-ru">«о/от» + «что?»</span></td><td><span class="rule-table-ar ar-tone-structure">عَمَّ</span><span class="rule-table-ru">алиф удалён, нуны уподоблены</span></td><td><span class="rule-table-ru">о чём?</span></td></tr><tr><td><span class="rule-table-ar">مِنْ + مَا</span><span class="rule-table-ru">«из/от» + «что?»</span></td><td><span class="rule-table-ar ar-tone-structure">مِمَّ</span><span class="rule-table-ru">алиф удалён, нуны уподоблены</span></td><td><span class="rule-table-ru">из чего? от чего?</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_5_id;

  -- 6. Four relative nouns actually listed in the source.
  update public.rules
  set
    sort_order = 6,
    title = 'الْأَسْمَاءُ الْمَوْصُولَةُ الْأَرْبَعَةُ (четыре приведённых относительных местоимения)',
    rule_ar = 'الاِسْمُ الْمَوْصُولُ لِلْمُفْرَدِ الْمُذَكَّرِ «الَّذِي»، وَلِلْمُفْرَدَةِ الْمُؤَنَّثَةِ «الَّتِي»، وَلِجَمْعِ الْمُذَكَّرِ «الَّذِينَ»، وَلِجَمْعِ الْمُؤَنَّثِ «اللَّائِي».',
    summary = 'الاِسْمُ الْمَوْصُولُ لِلْمُفْرَدِ الْمُذَكَّرِ «الَّذِي»، وَلِلْمُفْرَدَةِ الْمُؤَنَّثَةِ «الَّتِي»، وَلِجَمْعِ الْمُذَكَّرِ «الَّذِينَ»، وَلِجَمْعِ الْمُؤَنَّثِ «اللَّائِي».',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Форма по роду и числу</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْعَدَدُ وَالْجِنْسُ</span><span class="rule-table-ru">число и род</span></th><th><span class="rule-table-ar">الاِسْمُ الْمَوْصُولُ</span><span class="rule-table-ru">относительное местоимение</span></th><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример и перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">مُفْرَدٌ مُذَكَّرٌ</span><span class="rule-table-ru">единственное, мужской род</span></td><td><span class="rule-table-ar ar-tone-structure">الَّذِي</span><span class="rule-table-ru">который</span></td><td><span class="rule-table-ar">مَنِ الْفَتَى <span class="ar-tone-structure">الَّذِي</span> دَخَلَ الْفَصْلَ الْآنَ؟</span><span class="rule-table-ru">Кто тот юноша, который сейчас вошёл в класс?</span></td></tr><tr><td><span class="rule-table-ar">مُفْرَدَةٌ مُؤَنَّثَةٌ</span><span class="rule-table-ru">единственное, женский род</span></td><td><span class="rule-table-ar ar-tone-structure">الَّتِي</span><span class="rule-table-ru">которая</span></td><td><span class="rule-table-ar">مَنِ الْفَتَاةُ <span class="ar-tone-structure">الَّتِي</span> دَخَلَتِ الْفَصْلَ الْآنَ؟</span><span class="rule-table-ru">Кто та девушка, которая сейчас вошла в класс?</span></td></tr><tr><td><span class="rule-table-ar">جَمْعٌ مُذَكَّرٌ</span><span class="rule-table-ru">множественное, мужской род</span></td><td><span class="rule-table-ar ar-tone-structure">الَّذِينَ</span><span class="rule-table-ru">которые, мужчины</span></td><td><span class="rule-table-ar">مَنِ الْفِتْيَةُ <span class="ar-tone-structure">الَّذِينَ</span> دَخَلُوا الْفَصْلَ الْآنَ؟</span><span class="rule-table-ru">Кто те юноши, которые сейчас вошли в класс?</span></td></tr><tr><td><span class="rule-table-ar">جَمْعٌ مُؤَنَّثٌ</span><span class="rule-table-ru">множественное, женский род</span></td><td><span class="rule-table-ar ar-tone-structure">اللَّائِي</span><span class="rule-table-ru">которые, женщины</span></td><td><span class="rule-table-ar">مَنِ الْفَتَيَاتُ <span class="ar-tone-structure">اللَّائِي</span> دَخَلْنَ الْفَصْلَ الْآنَ؟</span><span class="rule-table-ru">Кто те девушки, которые сейчас вошли в класс?</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_6_id;

  -- 7. Definition, status, function, and two examples of نون الوقاية.
  update public.rules
  set
    sort_order = 7,
    title = 'نُونُ الْوِقَايَةِ (защитная нун)',
    rule_ar = 'نُونُ الْوِقَايَةِ حَرْفٌ مَبْنِيٌّ عَلَى الْكَسْرِ لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ. فَائِدَتُهَا وِقَايَةُ الْفِعْلِ وَحِفْظُهُ مِنَ الْكَسْرَةِ إِذَا اتَّصَلَتْ بِهِ يَاءُ الْمُتَكَلِّمِ.',
    summary = 'نُونُ الْوِقَايَةِ حَرْفٌ مَبْنِيٌّ عَلَى الْكَسْرِ لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ. فَائِدَتُهَا وِقَايَةُ الْفِعْلِ وَحِفْظُهُ مِنَ الْكَسْرَةِ إِذَا اتَّصَلَتْ بِهِ يَاءُ الْمُتَكَلِّمِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Определение и إِعْرَابٌ</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">نُونُ الْوِقَايَةِ</span> حَرْفٌ مَبْنِيٌّ عَلَى الْكَسْرِ، لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ.</span><p class="rule-study-text">Защитная нун — неизменяемая частица, построенная на касре и не занимающая синтаксического места.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Зачем она нужна</span><span class="rule-main-ar" dir="rtl" lang="ar">تَقِي <span class="ar-tone-verb">الْفِعْلَ</span> وَتَحْفَظُهُ مِنَ الْكَسْرَةِ إِذَا اتَّصَلَتْ بِهِ <span class="ar-tone-subject">يَاءُ الْمُتَكَلِّمِ</span>.</span><p class="rule-study-text">Она защищает глагол от касры при присоединении йа говорящего.</p><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">عَلَّمَ</span><span class="ar-tone-structure">نِ</span><span class="ar-tone-nasb">ي</span> <span class="ar-tone-subject">الْمُدَرِّسُ</span>.</span><span class="rule-example-ru">Преподаватель научил меня.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">خَلَقَ</span><span class="ar-tone-structure">نِ</span><span class="ar-tone-nasb">ي</span> <span class="ar-tone-subject">رَبِّي</span>.</span><span class="rule-example-ru">Мой Господь создал меня.</span></div></div></div></div>$$
  where id = rule_7_id;

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id, rule_7_id);

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس التاسع
علامة النصب في جمع مؤنث سالم
نقول: قرأت المجلة، هنا (مجلة) مفعول به منصوب وعلامة نصبه الفتحة الظاهرة على آخره.
ونقول: قرأت المجلات، هنا (المجلات) مفعول به منصوب، لكن علامة نصبه الكسرة الظاهرة نيابة عن الفتحة لأنه جمع مؤنث سالم. (مجلات جمع مجلة).$$,
      25, 25, 1),
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$فعل التعجب: "ما أفعله!"
عند التعجب نقول في الجملة (خطك جميل): ما أجمل خطك!
! : علامة التعجب.$$,
      25, 25, 1),
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$النداء
١. نداء العلم المفرد، نحو: يا محمد.
٢. نداء المضاف، نحو: يا عبد الله.
تنبيه:
• المنادى العلم المفرد مبني على الضم.
• المنادى المضاف منصوب.$$,
      25, 25, 1),
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$دخول همزة الاستفهام على المحلى بـ "ال"
إذا دخلت همزة الاستفهام على "ال" التعريف، نقول:
أ + الآن فهمت؟
آلآن فهمت؟ (بالمد).$$,
      26, 26, 1),
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$حذف ألف "ما" الاستفهامية
لم خرجت من الفصل؟
(لم) هنا مكون من (حرف الجر اللام + ما الاستفهامية).
وقاعدته: إذا دخل حرف الجر على ما الاستفهامية حذفت ألفها.
ومثله:
بم: ب + ما
عم: عن + ما
مم: من + ما$$,
      26, 26, 1),
    (rule_6_id, 'Podrobny_Sharkh_2_tom.pdf', $$الأسماء الموصولة
الذي (للمفرد المذكر)، نحو: من الفتى الذي دخل الفصل الآن؟
التي (للمفرد المؤنث)، نحو: من الفتاة التي دخلت الفصل الآن؟
الذين (جمع المذكر)، نحو: من الفتية الذين دخلوا الفصل الآن؟
اللائي (جمع المؤنث)، نحو: من الفتيات اللائي دخلن الفصل الآن؟$$,
      26, 26, 1),
    (rule_7_id, 'Podrobny_Sharkh_2_tom.pdf', $$نون الوقاية
نون الوقاية: حرف مبني على الكسر لا محل له من الإعراب.
فائدته: وقاية وحفظ الفعل من الكسرة إذا اتصل به ياء المتكلم، نحو: علمني المدرس، خلقني ربي.$$,
      26, 26, 1);
end;
$migration$;

commit;
