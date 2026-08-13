-- Verify Medina Book 2 lesson 7 against the complete 80-page Arabic sharh.
-- Sole source: Podrobny_Sharkh_2_tom.pdf, PDF pages 23-24.

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
    and lesson_number = '7';

  if lesson_rule_count not in (4, 6) then
    raise exception 'Expected 4 or 6 Book 2 lesson 7 rules, found %', lesson_rule_count;
  end if;

  if lesson_rule_count = 4 then
    select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 1;
    select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 2;
    select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 3;
    select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 4;
    update public.rules
    set sort_order = sort_order + 100
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '7';
  else
    select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 1;
    select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 2;
    select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 3;
    select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 4;
    select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 5;
    select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 6;
  end if;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '7'
  );

  if rule_3_id is null then
    insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values ('Мединский курс (Том 2)', '7', '', '', 3, 'rule', '', '') returning id into rule_3_id;
  end if;
  if rule_5_id is null then
    insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values ('Мединский курс (Том 2)', '7', '', '', 5, 'rule', '', '') returning id into rule_5_id;
  end if;

  -- 1. كان requires a nominative noun and an accusative predicate.
  update public.rules
  set
    sort_order = 1,
    title = 'كَانَ وَعَمَلُهَا وَإِعْرَابُهَا (действие كَانَ и полный разбор)',
    rule_ar = '«كَانَ» فِعْلٌ مَاضٍ نَاقِصٌ يَحْتَاجُ إِلَى اسْمٍ مَرْفُوعٍ وَخَبَرٍ مَنْصُوبٍ.',
    summary = '«كَانَ» فِعْلٌ مَاضٍ نَاقِصٌ يَحْتَاجُ إِلَى اسْمٍ مَرْفُوعٍ وَخَبَرٍ مَنْصُوبٍ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَانَ</span> فِعْلٌ مَاضٍ نَاقِصٌ؛ يَحْتَاجُ إِلَى <span class="ar-tone-subject">اسْمٍ مَرْفُوعٍ</span> وَ<span class="ar-tone-nasb">خَبَرٍ مَنْصُوبٍ</span>.</span><p class="rule-study-text"><span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">كَانَ</span> — неполный глагол прошедшего времени. Его имя стоит в именительном состоянии, а сказуемое — в винительном.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Пример и полный إِعْرَابٌ</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَانَ</span> <span class="ar-tone-subject">الطَّالِبُ</span> <span class="ar-tone-nasb">غَائِبًا</span>.</span><p class="rule-study-text">Студент отсутствовал.</p><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْكَلِمَةُ</span><span class="rule-table-ru">слово</span></th><th><span class="rule-table-ar">إِعْرَابُهَا</span><span class="rule-table-ru">грамматический разбор</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb">كَانَ</span><span class="rule-table-ru">был</span></td><td><span class="rule-table-ar ar-tone-verb">فِعْلٌ مَاضٍ نَاقِصٌ مَبْنِيٌّ عَلَى الْفَتْحِ.</span><span class="rule-table-ru">Неполный глагол прошедшего времени, построенный на фатхе.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">الطَّالِبُ</span><span class="rule-table-ru">студент</span></td><td><span class="rule-table-ar ar-tone-raf">اسْمُ «كَانَ» مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-table-ru">Имя «кана» в именительном состоянии; показатель — явная дамма в конце.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">غَائِبًا</span><span class="rule-table-ru">отсутствующий</span></td><td><span class="rule-table-ar ar-tone-nasb">خَبَرُ «كَانَ» مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-table-ru">Сказуемое «кана» в винительном состоянии; показатель — явная фатха в конце.</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_1_id;

  -- 2. Complete ten-pronoun source table and identification of اسم كان.
  update public.rules
  set
    sort_order = 2,
    title = 'إِسْنَادُ كَانَ إِلَى الضَّمَائِرِ الْعَشَرَةِ (спряжение كَانَ по десяти местоимениям)',
    rule_ar = 'يُسْنَدُ الْفِعْلُ «كَانَ» إِلَى الضَّمَائِرِ الْعَشَرَةِ، وَيَكُونُ اسْمُهُ ضَمِيرًا مُتَّصِلًا أَوْ مُسْتَتِرًا. وَفِي «كَانَتْ» اسْمُ «كَانَ» ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هِيَ»، وَتَاءُ التَّأْنِيثِ عَلَامَةٌ وَلَيْسَتِ اسْمًا.',
    summary = 'يُسْنَدُ الْفِعْلُ «كَانَ» إِلَى الضَّمَائِرِ الْعَشَرَةِ، وَيَكُونُ اسْمُهُ ضَمِيرًا مُتَّصِلًا أَوْ مُسْتَتِرًا. وَفِي «كَانَتْ» اسْمُ «كَانَ» ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هِيَ»، وَتَاءُ التَّأْنِيثِ عَلَامَةٌ وَلَيْسَتِ اسْمًا.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Как определяется имя كَانَ</span><span class="rule-main-ar" dir="rtl" lang="ar">اسْمُ <span class="ar-tone-verb">«كَانَ»</span> فِي هَذِهِ الصِّيَغِ إِمَّا <span class="ar-tone-subject">ضَمِيرٌ مُتَّصِلٌ</span>، وَإِمَّا <span class="ar-tone-subject">ضَمِيرٌ مُسْتَتِرٌ</span>.</span><p class="rule-study-text">В форме <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">كَانَتْ</span> неподвижная та лишь обозначает женский род; имя <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">كَانَ</span> — скрытое <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">هِيَ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Полная таблица из шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الضَّمِيرُ</span><span class="rule-table-ru">местоимение</span></th><th><span class="rule-table-ar">فِعْلُ «كَانَ»</span><span class="rule-table-ru">форма глагола</span></th><th><span class="rule-table-ar">اسْمُ «كَانَ»</span><span class="rule-table-ru">имя «кана»</span></th><th><span class="rule-table-ar">الْمَعْنَى</span><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-subject">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar ar-tone-verb">كُنْتُ</span><span class="rule-table-ru">форма для «я»</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ «تُ»</span><span class="rule-table-ru">подвижная та</span></td><td><span class="rule-table-ru">я был / была</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar ar-tone-verb">كُنْتَ</span><span class="rule-table-ru">форма мужского рода</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ «تَ»</span><span class="rule-table-ru">подвижная та</span></td><td><span class="rule-table-ru">ты был</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-verb">كُنْتِ</span><span class="rule-table-ru">форма женского рода</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ «تِ»</span><span class="rule-table-ru">подвижная та</span></td><td><span class="rule-table-ru">ты была</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar ar-tone-verb">كَانَ</span><span class="rule-table-ru">форма «он»</span></td><td><span class="rule-table-ar ar-tone-subject">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هُوَ»</span><span class="rule-table-ru">скрытое «он»</span></td><td><span class="rule-table-ru">он был</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar ar-tone-verb">كَانَتْ</span><span class="rule-table-ru">форма «она»</span></td><td><span class="rule-table-ar ar-tone-subject">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هِيَ»؛ وَالتَّاءُ السَّاكِنَةُ عَلَامَةُ التَّأْنِيثِ.</span><span class="rule-table-ru">скрытое «она»; неподвижная та — показатель женского рода</span></td><td><span class="rule-table-ru">она была</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar ar-tone-verb">كُنَّا</span><span class="rule-table-ru">форма «мы»</span></td><td><span class="rule-table-ar ar-tone-subject">نُونُ الْمُتَكَلِّمِينَ «نَا»</span><span class="rule-table-ru">нун говорящих</span></td><td><span class="rule-table-ru">мы были</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb">كُنْتُمْ</span><span class="rule-table-ru">форма мужского множественного</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ «تُ»؛ وَالْمِيمُ عَلَامَةُ الْجَمْعِ لِلْمُذَكَّرِ.</span><span class="rule-table-ru">подвижная та; мим — показатель мужского множественного</span></td><td><span class="rule-table-ru">вы были</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar ar-tone-verb">كُنْتُنَّ</span><span class="rule-table-ru">форма женского множественного</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ «تُ»؛ وَالنُّونُ عَلَامَةُ الْجَمْعِ لِلْمُؤَنَّثِ.</span><span class="rule-table-ru">подвижная та; нун — показатель женского множественного</span></td><td><span class="rule-table-ru">вы были</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُمْ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb">كَانُوا</span><span class="rule-table-ru">форма мужского множественного</span></td><td><span class="rule-table-ar ar-tone-subject">وَاوُ الْجَمَاعَةِ «و»</span><span class="rule-table-ru">вау группы</span></td><td><span class="rule-table-ru">они были</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُنَّ</span><span class="rule-table-ru">они, женщины</span></td><td><span class="rule-table-ar ar-tone-verb">كُنَّ</span><span class="rule-table-ru">форма женского множественного</span></td><td><span class="rule-table-ar ar-tone-subject">نُونُ النِّسْوَةِ «ن»</span><span class="rule-table-ru">нун женщин</span></td><td><span class="rule-table-ru">они были</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_2_id;

  -- 3. Complete versus defective verbs and the two roles of the moving tā.
  update public.rules
  set
    sort_order = 3,
    title = 'الْفِعْلُ التَّامُّ وَالنَّاقِصُ وَتَاءُ «ضَرَبْتُ» وَ«كُنْتُ» (полный и неполный глагол; роль та)',
    rule_ar = 'الْفِعْلُ التَّامُّ يَكْتَمِلُ مَعْنَاهُ بِذِكْرِ فَاعِلِهِ، أَمَّا الْفِعْلُ النَّاقِصُ فَلَا يَكْتَمِلُ مَعْنَاهُ بِذِكْرِ مَرْفُوعِهِ، بَلْ يَحْتَاجُ إِلَى خَبَرٍ مَنْصُوبٍ. وَالتَّاءُ فِي «ضَرَبْتُ» فَاعِلٌ فِي مَحَلِّ رَفْعٍ، وَفِي «كُنْتُ» اسْمُ «كَانَ» فِي مَحَلِّ رَفْعٍ.',
    summary = 'الْفِعْلُ التَّامُّ يَكْتَمِلُ مَعْنَاهُ بِذِكْرِ فَاعِلِهِ، أَمَّا الْفِعْلُ النَّاقِصُ فَلَا يَكْتَمِلُ مَعْنَاهُ بِذِكْرِ مَرْفُوعِهِ، بَلْ يَحْتَاجُ إِلَى خَبَرٍ مَنْصُوبٍ. وَالتَّاءُ فِي «ضَرَبْتُ» فَاعِلٌ فِي مَحَلِّ رَفْعٍ، وَفِي «كُنْتُ» اسْمُ «كَانَ» فِي مَحَلِّ رَفْعٍ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Полный и неполный глагол</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-verb"><span class="rule-term-ar" dir="rtl" lang="ar">الْفِعْلُ التَّامُّ</span><span class="rule-term-ru">Полный глагол завершает смысл после упоминания исполнителя: <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">ذَهَبَ</span> <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">مُحَمَّدٌ</span> — «Мухаммад ушёл».</span></div><div class="rule-meaning-card rule-term-object"><span class="rule-term-ar" dir="rtl" lang="ar">الْفِعْلُ النَّاقِصُ</span><span class="rule-term-ru">Неполный глагол не завершает смысл одним своим именем: <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">كَانَ</span> <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">الطَّالِبُ</span>… требует сказуемого, например <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">غَائِبًا</span>.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Одинаковая буква — разные функции</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример</span></th><th><span class="rule-table-ar">وَظِيفَةُ التَّاءِ</span><span class="rule-table-ru">функция та</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb">ضَرَبْتُ</span><span class="rule-table-ru">я ударил / ударила</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ فَاعِلٌ فِي مَحَلِّ رَفْعٍ.</span><span class="rule-table-ru">Та — исполнитель в позиции именительного состояния.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">كُنْتُ</span><span class="rule-table-ru">я был / была</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ اسْمُ «كَانَ» فِي مَحَلِّ رَفْعٍ.</span><span class="rule-table-ru">Та — имя «кана» в позиции именительного состояния.</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_3_id;

  -- 4. The four source types of the predicate of كان.
  update public.rules
  set
    sort_order = 4,
    title = 'أَنْوَاعُ خَبَرِ كَانَ (виды сказуемого كَانَ)',
    rule_ar = 'خَبَرُ «كَانَ» مِثْلُ خَبَرِ الْمُبْتَدَأِ؛ يَكُونُ مُفْرَدًا، أَوْ جُمْلَةً فِعْلِيَّةً، أَوْ جُمْلَةً اسْمِيَّةً، أَوْ شِبْهَ جُمْلَةٍ.',
    summary = 'خَبَرُ «كَانَ» مِثْلُ خَبَرِ الْمُبْتَدَأِ؛ يَكُونُ مُفْرَدًا، أَوْ جُمْلَةً فِعْلِيَّةً، أَوْ جُمْلَةً اسْمِيَّةً، أَوْ شِبْهَ جُمْلَةٍ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">خَبَرُ <span class="ar-tone-verb">«كَانَ»</span> مِثْلُ خَبَرِ <span class="ar-tone-subject">الْمُبْتَدَأِ</span>؛ لَهُ أَرْبَعُ صُوَرٍ فِي هَذَا الدَّرْسِ.</span></div><div class="rule-study-card"><span class="rule-card-kicker">Виды и примеры</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">نَوْعُ الْخَبَرِ</span><span class="rule-table-ru">вид сказуемого</span></th><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример</span></th><th><span class="rule-table-ar">الْمَعْنَى</span><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-predicate">مُفْرَدٌ</span><span class="rule-table-ru">одиночное имя</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">كَانَ</span> <span class="ar-tone-subject">الطَّالِبُ</span> <span class="ar-tone-nasb">غَائِبًا</span>.</span><span class="rule-table-ru">сказуемое — одно слово</span></td><td><span class="rule-table-ru">Студент отсутствовал.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-predicate">جُمْلَةٌ فِعْلِيَّةٌ</span><span class="rule-table-ru">глагольное предложение</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">كَانَ</span> <span class="ar-tone-subject">الْمُدَرِّسُ</span> <span class="ar-tone-verb">يَشْرَحُ الدَّرْسَ</span>.</span><span class="rule-table-ru">сказуемое — глагольное предложение</span></td><td><span class="rule-table-ru">Преподаватель объяснял урок.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-predicate">جُمْلَةٌ اسْمِيَّةٌ</span><span class="rule-table-ru">именное предложение</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">كَانَ</span> <span class="ar-tone-subject">الطَّالِبُ</span> <span class="ar-tone-subject">خُلُقُهُ</span> <span class="ar-tone-predicate">كَرِيمٌ</span>.</span><span class="rule-table-ru">сказуемое — именное предложение</span></td><td><span class="rule-table-ru">У студента был благородный нрав.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-predicate">شِبْهُ جُمْلَةٍ</span><span class="rule-table-ru">квазипредложение</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">كَانَ</span> <span class="ar-tone-subject">الطَّالِبُ</span> <span class="ar-tone-jarr">فِي الْفَصْلِ</span>.</span><span class="rule-table-ru">сказуемое — предлог с именем</span></td><td><span class="rule-table-ru">Студент был в классе.</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_4_id;

  -- 5. Obligatory fronting when the noun is indefinite and the predicate is شبه جملة.
  update public.rules
  set
    sort_order = 5,
    title = 'تَقْدِيمُ خَبَرِ كَانَ عَلَى اسْمِهَا (вынесение сказуемого كَانَ перед её именем)',
    rule_ar = 'إِذَا كَانَ اسْمُ «كَانَ» نَكِرَةً وَخَبَرُهَا شِبْهَ جُمْلَةٍ، وَجَبَ تَقْدِيمُ الْخَبَرِ عَلَى الاِسْمِ، نَحْوُ: كَانَ فِي الْفَصْلِ طَالِبٌ.',
    summary = 'إِذَا كَانَ اسْمُ «كَانَ» نَكِرَةً وَخَبَرُهَا شِبْهَ جُمْلَةٍ، وَجَبَ تَقْدِيمُ الْخَبَرِ عَلَى الاِسْمِ، نَحْوُ: كَانَ فِي الْفَصْلِ طَالِبٌ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">تَنْبِيهٌ — важное замечание</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا كَانَ <span class="ar-tone-subject">اسْمُ «كَانَ» نَكِرَةً</span> وَ<span class="ar-tone-predicate">خَبَرُهَا شِبْهَ جُمْلَةٍ</span>، وَجَبَ تَقْدِيمُ الْخَبَرِ عَلَى الاِسْمِ.</span><p class="rule-study-text">Если имя «кана» неопределённое, а сказуемое является квазипредложением, сказуемое обязательно ставится раньше имени.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Правильный порядок</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَانَ</span> <span class="ar-tone-jarr">فِي الْفَصْلِ</span> <span class="ar-tone-subject">طَالِبٌ</span>.</span><p class="rule-study-text">В классе был студент. <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">فِي الْفَصْلِ</span> — вынесенное вперёд сказуемое; <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">طَالِبٌ</span> — неопределённое имя «кана», поставленное после него.</p></div></div>$$
  where id = rule_5_id;

  -- 6. Plural mīm before the definite article and wāw of vowel lengthening.
  update public.rules
  set
    sort_order = 6,
    title = 'ضَمُّ مِيمِ الْجَمْعِ وَوَاوُ الْإِشْبَاعِ (дамма мима группы и вау удлинения)',
    rule_ar = 'تُضَمُّ مِيمُ الْجَمْعِ فِي «فَعَلْتُمْ» قَبْلَ لَامِ التَّعْرِيفِ تَخَلُّصًا مِنَ الْتِقَاءِ السَّاكِنَيْنِ، نَحْوُ: «أَرَأَيْتُمُ الْمُدَرِّسَ؟». وَإِذَا كَانَ الْمَفْعُولُ بِهِ ضَمِيرًا، زِيدَتْ وَاوٌ لِلْإِشْبَاعِ، نَحْوُ: «أَرَأَيْتُمُوهُ؟».',
    summary = 'تُضَمُّ مِيمُ الْجَمْعِ فِي «فَعَلْتُمْ» قَبْلَ لَامِ التَّعْرِيفِ تَخَلُّصًا مِنَ الْتِقَاءِ السَّاكِنَيْنِ، نَحْوُ: «أَرَأَيْتُمُ الْمُدَرِّسَ؟». وَإِذَا كَانَ الْمَفْعُولُ بِهِ ضَمِيرًا، زِيدَتْ وَاوٌ لِلْإِشْبَاعِ، نَحْوُ: «أَرَأَيْتُمُوهُ؟».',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Перед определённым артиклем</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَرَأَيْتُمُ</span> <span class="ar-tone-nasb">الْمُدَرِّسَ</span>؟</span><p class="rule-study-text">«Вы видели преподавателя?» Мим группы получает дамму, чтобы устранить встречу двух сукунов: мима и ляма определённого артикля.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Перед слитным объектным местоимением</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَرَأَيْتُمُو</span><span class="ar-tone-nasb">هُ</span>؟</span><p class="rule-study-text">«Вы видели его?» После даммы мима появляется дополнительная <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">وَاوُ الْإِشْبَاعِ</span> — вау удлинения.</p></div><div class="rule-check-card"><b>الْإِشْبَاعُ — удлинение.</b> <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">إِشْبَاعُ ضَمَّةِ الْمِيمِ</span> означает протянуть дамму мима в произношении; из этого удлинения возникает звук вау.</div></div>$$
  where id = rule_6_id;

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id);

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس السابع
كان
كان: فعل ماض ناقص، يحتاج إلى اسم مرفوع وخبر منصوب، نحو: كان الطالب غائباً.
الإعراب:
كان: فعل ماض ناقص مبني على الفتح.
الطالب: اسم كان مرفوع وعلامة رفعه الضمة الظاهرة على آخره.
غائباً: خبر كان منصوب وعلامة نصبه الفتحة الظاهرة على آخره.$$,
      23, 23, 1),
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$إسناد فعل كان إلى الضمائر العشرة
فعل: كان | اسم كان
كُنْتُ | التاء المتحركة (ت)
كُنْتَ | التاء المتحركة (ت)
كُنْتِ | التاء المتحركة (ت)
كَانَ | ضمير مستتر تقديره "هو"
كَانَتْ | ضمير مستتر تقديره "هي"، والتاء الساكنة: علامة التأنيث
كُنَّا | نون المتكلمين (نا)
كُنْتُمْ | التاء المتحركة (ت)، والميم علامة الجمع للمذكر
كُنْتُنَّ | التاء المتحركة (ت)، والنون علامة الجمع للمؤنث
كَانُوا | واو الجماعة (و)
كُنَّ | نون النسوة (ن)$$,
      23, 23, 1),
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$الفرق في التاء المتحركة (ت) في ضربت وكنت
أن التاء في ضربت: في محل رفع فاعل، وفي كنت: في محل رفع اسم كان.
لأن الفعل ضرب فعل تام يحتاج إلى الفاعل، أما كان فهو فعل ناقص، والفعل الناقص يحتاج إلى اسم وخبر.
تنبيه: الفعل التام هو الذي يكتمل معناه بذكر فاعله، نحو: ذهب محمد.
أما الناقص فلا يكتمل معناه بذكر مرفوعه بل يحتاج إلى اسم منصوب ليتمم معناه، نحو: كان الطالب غائباً. فإذا قلنا: كان الطالب، لا يتم المعنى.$$,
      24, 24, 1),
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$خبر كان
خبر كان مثل خبر المبتدأ يكون مفرداً، وجملة، وشبه جملة، نحو:
كان الطالب غائباً (مفرد).
كان المدرس يشرح الدرس (جملة فعلية).
كان الطالب خلقه كريم (جملة اسمية).
كان الطالب في الفصل.$$,
      24, 24, 1),
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$تنبيه: إذا كان "اسم كان" نكرة وخبره شبه جملة، وجب تقديم الخبر على الاسم، نحو: كان في الفصل طالب.$$,
      24, 24, 1),
    (rule_6_id, 'Podrobny_Sharkh_2_tom.pdf', $$لحوق ضمائر النصب المتصلة بـ "فعلتم" قبل لام التعريف
أرأيتموه؟
تضم ميم الجمع (م) للتخلص من التقاء الساكنين (م + ال)، نقول: أرأيتم المدرس؟
وإذا كان المفعول به ضميراً، نقول: أرأيتموه؟ بزيادة الواو وهو حرف زائد وفائدته الإشباع.
فائدة:
المراد بالإشباع: إشباع حركة ميم الضمة؛ أي: مدها في النطق فينتج من هذا المد حرف الواو.$$,
      24, 24, 1);
end;
$migration$;

commit;
