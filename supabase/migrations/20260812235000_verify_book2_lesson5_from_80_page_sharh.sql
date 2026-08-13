-- Verify Medina Book 2 lesson 5 against the complete 80-page Arabic sharh.
-- Sole source: Podrobny_Sharkh_2_tom.pdf, PDF pages 17-19.

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
  rule_8_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '5';

  if lesson_rule_count not in (4, 8) then
    raise exception 'Expected 4 or 8 Book 2 lesson 5 rules, found %', lesson_rule_count;
  end if;

  if lesson_rule_count = 4 then
    select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 1;
    select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 2;
    select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 3;
    select id into strict rule_7_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 4;
    update public.rules
    set sort_order = sort_order + 100
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '5';
  else
    select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 1;
    select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 2;
    select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 3;
    select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 4;
    select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 5;
    select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 6;
    select id into strict rule_7_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 7;
    select id into strict rule_8_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '5' and sort_order = 8;
  end if;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '5'
  );

  if rule_1_id is null then
    insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values ('Мединский курс (Том 2)', '5', '', '', 1, 'rule', '', '') returning id into rule_1_id;
  end if;
  if rule_2_id is null then
    insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values ('Мединский курс (Том 2)', '5', '', '', 2, 'rule', '', '') returning id into rule_2_id;
  end if;
  if rule_3_id is null then
    insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values ('Мединский курс (Том 2)', '5', '', '', 3, 'rule', '', '') returning id into rule_3_id;
  end if;
  if rule_8_id is null then
    insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values ('Мединский курс (Том 2)', '5', '', '', 8, 'rule', '', '') returning id into rule_8_id;
  end if;

  -- 1. The two sentence types.
  update public.rules
  set
    sort_order = 1,
    title = 'قِسْمَا الْجُمْلَةِ: الِاسْمِيَّةُ وَالْفِعْلِيَّةُ (два вида предложения: именное и глагольное)',
    rule_ar = 'تَنْقَسِمُ الْجُمْلَةُ إِلَى قِسْمَيْنِ: الْجُمْلَةُ الِاسْمِيَّةُ أَوَّلُهَا اسْمٌ وَتَتَكَوَّنُ مِنَ الْمُبْتَدَأِ وَالْخَبَرِ، وَالْجُمْلَةُ الْفِعْلِيَّةُ أَوَّلُهَا فِعْلٌ وَتَتَكَوَّنُ مِنَ الْفِعْلِ وَالْفَاعِلِ أَوْ نَائِبِ الْفَاعِلِ.',
    summary = 'تَنْقَسِمُ الْجُمْلَةُ إِلَى قِسْمَيْنِ: الْجُمْلَةُ الِاسْمِيَّةُ أَوَّلُهَا اسْمٌ وَتَتَكَوَّنُ مِنَ الْمُبْتَدَأِ وَالْخَبَرِ، وَالْجُمْلَةُ الْفِعْلِيَّةُ أَوَّلُهَا فِعْلٌ وَتَتَكَوَّنُ مِنَ الْفِعْلِ وَالْفَاعِلِ أَوْ نَائِبِ الْفَاعِلِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Два вида предложения</span><span class="rule-main-ar" dir="rtl" lang="ar">تَنْقَسِمُ <span class="ar-tone-structure">الْجُمْلَةُ</span> إِلَى قِسْمَيْنِ: <span class="ar-tone-subject">جُمْلَةٌ اسْمِيَّةٌ</span> وَ<span class="ar-tone-verb">جُمْلَةٌ فِعْلِيَّةٌ</span>.</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">الْجُمْلَةُ الِاسْمِيَّةُ</span><span class="rule-term-ru">Именное предложение начинается с имени и состоит из <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">مُبْتَدَأٌ</span> — подлежащего и <span class="ar-inline ar-tone-predicate" dir="rtl" lang="ar">خَبَرٌ</span> — сказуемого.</span></div><div class="rule-meaning-card rule-term-verb"><span class="rule-term-ar" dir="rtl" lang="ar">الْجُمْلَةُ الْفِعْلِيَّةُ</span><span class="rule-term-ru">Глагольное предложение начинается с глагола и состоит из глагола с исполнителем либо глагола с заместителем исполнителя.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">مُحَمَّدٌ</span> <span class="ar-tone-predicate">مُجْتَهِدٌ</span>.</span><span class="rule-example-ru">Мухаммад усерден. Первое слово — имя; это законченное именное предложение.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">قَرَأَ</span> <span class="ar-tone-subject">الطَّالِبُ</span> <span class="ar-tone-nasb">الْقُرْآنَ</span>.</span><span class="rule-example-ru">Студент прочитал Коран. Первое слово — глагол; это глагольное предложение.</span></div></div></div></div>$$
  where id = rule_1_id;

  -- 2. The three kinds of predicate.
  update public.rules
  set
    sort_order = 2,
    title = 'أَنْوَاعُ الْخَبَرِ الثَّلَاثَةُ (три вида сказуемого)',
    rule_ar = 'الْخَبَرُ ثَلَاثَةُ أَنْوَاعٍ: اسْمٌ مُفْرَدٌ، وَجُمْلَةٌ فِعْلِيَّةٌ أَوِ اسْمِيَّةٌ، وَشِبْهُ جُمْلَةٍ يَكُونُ جَارًّا وَمَجْرُورًا أَوْ ظَرْفَ مَكَانٍ أَوْ ظَرْفَ زَمَانٍ.',
    summary = 'الْخَبَرُ ثَلَاثَةُ أَنْوَاعٍ: اسْمٌ مُفْرَدٌ، وَجُمْلَةٌ فِعْلِيَّةٌ أَوِ اسْمِيَّةٌ، وَشِبْهُ جُمْلَةٍ يَكُونُ جَارًّا وَمَجْرُورًا أَوْ ظَرْفَ مَكَانٍ أَوْ ظَرْفَ زَمَانٍ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-predicate">الْخَبَرُ</span> ثَلَاثَةُ أَنْوَاعٍ: <span class="ar-tone-structure">اسْمٌ مُفْرَدٌ</span>، وَ<span class="ar-tone-structure">جُمْلَةٌ</span>، وَ<span class="ar-tone-structure">شِبْهُ جُمْلَةٍ</span>.</span></div><div class="rule-study-card"><span class="rule-card-kicker">Виды и примеры</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">نَوْعُ الْخَبَرِ</span><span class="rule-table-ru">вид сказуемого</span></th><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример</span></th><th><span class="rule-table-ar">الْمَعْنَى</span><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-predicate">اسْمٌ مُفْرَدٌ</span><span class="rule-table-ru">одиночное имя</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">بِلَالٌ</span> <span class="ar-tone-predicate">طَالِبٌ</span>.</span><span class="rule-table-ru">Биляль — студент.</span></td><td><span class="rule-table-ar">خَبَرٌ مُفْرَدٌ</span><span class="rule-table-ru">сказуемое выражено одним именем</span></td></tr><tr><td><span class="rule-table-ar ar-tone-predicate">جُمْلَةٌ فِعْلِيَّةٌ</span><span class="rule-table-ru">глагольное предложение</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">بِلَالٌ</span> <span class="ar-tone-verb">خَرَجَ</span>.</span><span class="rule-table-ru">Биляль вышел.</span></td><td><span class="rule-table-ar">الْخَبَرُ جُمْلَةٌ فِعْلِيَّةٌ</span><span class="rule-table-ru">сказуемое — глагольное предложение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-predicate">جُمْلَةٌ اسْمِيَّةٌ</span><span class="rule-table-ru">именное предложение</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">بِلَالٌ</span> <span class="ar-tone-subject">خَطُّهُ</span> <span class="ar-tone-predicate">جَمِيلٌ</span>.</span><span class="rule-table-ru">У Биляля красивый почерк.</span></td><td><span class="rule-table-ar">الْخَبَرُ جُمْلَةٌ اسْمِيَّةٌ</span><span class="rule-table-ru">сказуемое — именное предложение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-predicate">جَارٌّ وَمَجْرُورٌ</span><span class="rule-table-ru">предлог с именем</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">بِلَالٌ</span> <span class="ar-tone-jarr">فِي الْفَصْلِ</span>.</span><span class="rule-table-ru">Биляль находится в классе.</span></td><td><span class="rule-table-ar">شِبْهُ جُمْلَةٍ</span><span class="rule-table-ru">квазипредложение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-predicate">ظَرْفُ مَكَانٍ</span><span class="rule-table-ru">обстоятельство места</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">بِلَالٌ</span> <span class="ar-tone-structure">خَلْفَ مُحَمَّدٍ</span>.</span><span class="rule-table-ru">Биляль находится позади Мухаммада.</span></td><td><span class="rule-table-ar">شِبْهُ جُمْلَةٍ</span><span class="rule-table-ru">квазипредложение; также бывает обстоятельством времени</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_2_id;

  -- 3. Verbal sentence and complete source i'rab.
  update public.rules
  set
    sort_order = 3,
    title = 'الْجُمْلَةُ الْفِعْلِيَّةُ وَإِعْرَابُهَا (глагольное предложение и его разбор)',
    rule_ar = 'الْجُمْلَةُ الْفِعْلِيَّةُ هِيَ الَّتِي أَوَّلُهَا فِعْلٌ، وَتَتَكَوَّنُ مِنَ الْفِعْلِ وَالْفَاعِلِ، أَوْ مِنَ الْفِعْلِ وَنَائِبِ الْفَاعِلِ.',
    summary = 'الْجُمْلَةُ الْفِعْلِيَّةُ هِيَ الَّتِي أَوَّلُهَا فِعْلٌ، وَتَتَكَوَّنُ مِنَ الْفِعْلِ وَالْفَاعِلِ، أَوْ مِنَ الْفِعْلِ وَنَائِبِ الْفَاعِلِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">الْجُمْلَةُ الْفِعْلِيَّةُ</span> هِيَ الَّتِي أَوَّلُهَا فِعْلٌ، وَتَتَكَوَّنُ مِنَ الْفِعْلِ وَالْفَاعِلِ، أَوْ مِنَ الْفِعْلِ وَنَائِبِ الْفَاعِلِ.</span></div><div class="rule-study-card"><span class="rule-card-kicker">Пример</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">قَرَأَ</span> <span class="ar-tone-subject">الطَّالِبُ</span> <span class="ar-tone-nasb">الْقُرْآنَ</span>.</span><p class="rule-study-text">Студент прочитал Коран.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Полный إِعْرَابٌ</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْكَلِمَةُ</span><span class="rule-table-ru">слово</span></th><th><span class="rule-table-ar">إِعْرَابُهَا</span><span class="rule-table-ru">грамматический разбор</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb">قَرَأَ</span><span class="rule-table-ru">прочитал</span></td><td><span class="rule-table-ar ar-tone-verb">فِعْلٌ مَاضٍ مَبْنِيٌّ عَلَى الْفَتْحِ.</span><span class="rule-table-ru">Глагол прошедшего времени, построенный на фатхе.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">الطَّالِبُ</span><span class="rule-table-ru">студент</span></td><td><span class="rule-table-ar ar-tone-raf">فَاعِلٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-table-ru">Исполнитель в именительном падеже; показатель — явная дамма в конце.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">الْقُرْآنَ</span><span class="rule-table-ru">Коран</span></td><td><span class="rule-table-ar ar-tone-nasb">مَفْعُولٌ بِهِ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-table-ru">Прямое дополнение в винительном падеже; показатель — явная фатха в конце.</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_3_id;

  -- 4. Definitions and fixed cases of فاعل and مفعول به.
  update public.rules
  set
    sort_order = 4,
    title = 'الْفَاعِلُ وَالْمَفْعُولُ بِهِ (исполнитель и прямое дополнение)',
    rule_ar = 'الْفَاعِلُ مَرْفُوعٌ دَائِمًا، وَهُوَ الَّذِي فَعَلَ الْفِعْلَ. وَالْمَفْعُولُ بِهِ مَنْصُوبٌ دَائِمًا، وَهُوَ الَّذِي وَقَعَ عَلَيْهِ فِعْلُ الْفَاعِلِ.',
    summary = 'الْفَاعِلُ مَرْفُوعٌ دَائِمًا، وَهُوَ الَّذِي فَعَلَ الْفِعْلَ. وَالْمَفْعُولُ بِهِ مَنْصُوبٌ دَائِمًا، وَهُوَ الَّذِي وَقَعَ عَلَيْهِ فِعْلُ الْفَاعِلِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">تَنْبِيهٌ — важное замечание</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">الْفَاعِلُ مَرْفُوعٌ دَائِمًا</span>، وَ<span class="ar-tone-nasb">الْمَفْعُولُ بِهِ مَنْصُوبٌ دَائِمًا</span>.</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">الْفَاعِلُ</span><span class="rule-term-ru">Исполнитель — тот, кто совершил действие; он всегда в именительном падеже.</span></div><div class="rule-meaning-card rule-term-object"><span class="rule-term-ar" dir="rtl" lang="ar">الْمَفْعُولُ بِهِ</span><span class="rule-term-ru">Прямое дополнение — тот или то, на кого или на что направлено действие исполнителя; оно всегда в винительном падеже.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Пример и роли</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">ضَرَبَ</span> <span class="ar-tone-subject">زَيْدٌ</span> <span class="ar-tone-nasb">عَمْرًا</span>.</span><p class="rule-study-text">Зайд ударил Амра. <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">زَيْدٌ</span> — исполнитель, потому что он совершил действие; <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">عَمْرًا</span> — прямое дополнение, потому что действие направлено на него.</p></div></div>$$
  where id = rule_4_id;

  -- 5. Overt nouns and attached or detached pronouns in both roles.
  update public.rules
  set
    sort_order = 5,
    title = 'صُوَرُ الْفَاعِلِ وَالْمَفْعُولِ بِهِ (формы исполнителя и прямого дополнения)',
    rule_ar = 'يَكُونُ الْفَاعِلُ اسْمًا ظَاهِرًا أَوْ ضَمِيرَ رَفْعٍ مُتَّصِلًا، وَقَدْ يَكُونُ ضَمِيرًا مُنْفَصِلًا. وَيَكُونُ الْمَفْعُولُ بِهِ اسْمًا ظَاهِرًا أَوْ ضَمِيرَ نَصْبٍ مُتَّصِلًا.',
    summary = 'يَكُونُ الْفَاعِلُ اسْمًا ظَاهِرًا أَوْ ضَمِيرَ رَفْعٍ مُتَّصِلًا، وَقَدْ يَكُونُ ضَمِيرًا مُنْفَصِلًا. وَيَكُونُ الْمَفْعُولُ بِهِ اسْمًا ظَاهِرًا أَوْ ضَمِيرَ نَصْبٍ مُتَّصِلًا.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Исполнитель</span><span class="rule-main-ar" dir="rtl" lang="ar">الْفَاعِلُ إِمَّا <span class="ar-tone-subject">اسْمٌ ظَاهِرٌ</span>، وَإِمَّا <span class="ar-tone-subject">ضَمِيرُ رَفْعٍ مُتَّصِلٌ</span>، وَقَدْ يَكُونُ <span class="ar-tone-subject">ضَمِيرًا مُنْفَصِلًا</span>.</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">خَرَجَ</span> <span class="ar-tone-subject">بِلَالٌ</span>.</span><span class="rule-example-ru">Биляль вышел: исполнитель выражен явным именем.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">خَرَجْتُ</span>؛ <span class="ar-tone-verb">خَرَجُوا</span>.</span><span class="rule-example-ru">Я вышел; они вышли: исполнитель — слитное местоимение <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">تُ</span> или <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">و</span>.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَا <span class="ar-tone-verb">فَهِمَ</span> الدَّرْسَ إِلَّا <span class="ar-tone-subject">أَنْتَ</span>.</span><span class="rule-example-ru">Урок понял только ты: исполнитель выражен отдельным местоимением.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Прямое дополнение</span><span class="rule-main-ar" dir="rtl" lang="ar">الْمَفْعُولُ بِهِ إِمَّا <span class="ar-tone-nasb">اسْمٌ ظَاهِرٌ</span، وَإِمَّا <span class="ar-tone-nasb">ضَمِيرُ نَصْبٍ مُتَّصِلٌ</span>.</span><div class="rule-example-list"><div class="rule-example-card rule-term-object"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">قَرَأْتُ</span> <span class="ar-tone-nasb">الدَّرْسَ</span>.</span><span class="rule-example-ru">Я прочитал урок: дополнение — явное имя.</span></div><div class="rule-example-card rule-term-object"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">فَهِمَ</span><span class="ar-tone-nasb">هُ</span>.</span><span class="rule-example-ru">Он понял его: <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">ـهُ</span> — слитное местоимение в роли прямого дополнения.</span></div></div></div></div>$$
  where id = rule_5_id;

  -- 6. A preceding verb must remain singular.
  update public.rules
  set
    sort_order = 6,
    title = 'إِفْرَادُ الْفِعْلِ الْمُتَقَدِّمِ (единственное число глагола перед исполнителем)',
    rule_ar = 'إِذَا تَقَدَّمَ الْفِعْلُ وَجَبَ أَنْ يَكُونَ مُفْرَدًا، وَإِنْ كَانَ الْفَاعِلُ مُثَنًّى أَوْ جَمْعًا.',
    summary = 'إِذَا تَقَدَّمَ الْفِعْلُ وَجَبَ أَنْ يَكُونَ مُفْرَدًا، وَإِنْ كَانَ الْفَاعِلُ مُثَنًّى أَوْ جَمْعًا.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило порядка слов</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا تَقَدَّمَ <span class="ar-tone-verb">الْفِعْلُ</span> وَجَبَ أَنْ يَكُونَ <span class="ar-tone-structure">مُفْرَدًا</span>، وَإِنْ كَانَ <span class="ar-tone-subject">الْفَاعِلُ</span> مُثَنًّى أَوْ جَمْعًا.</span><p class="rule-study-text">Когда глагол стоит перед явным исполнителем, глагол остаётся в единственном числе. Род глагола при этом соответствует роду исполнителя.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Шесть примеров из шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">عَدَدُ الْفَاعِلِ</span><span class="rule-table-ru">число исполнителя</span></th><th><span class="rule-table-ar">الْمُذَكَّرُ</span><span class="rule-table-ru">мужской род</span></th><th><span class="rule-table-ar">الْمُؤَنَّثُ</span><span class="rule-table-ru">женский род</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">مُفْرَدٌ</span><span class="rule-table-ru">единственное</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">خَرَجَ</span> <span class="ar-tone-subject">الطَّالِبُ</span>.</span><span class="rule-table-ru">Студент вышел.</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">خَرَجَتِ</span> <span class="ar-tone-subject">الطَّالِبَةُ</span>.</span><span class="rule-table-ru">Студентка вышла.</span></td></tr><tr><td><span class="rule-table-ar">مُثَنًّى</span><span class="rule-table-ru">двойственное</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">خَرَجَ</span> <span class="ar-tone-subject">الطَّالِبَانِ</span>.</span><span class="rule-table-ru">Два студента вышли.</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">خَرَجَتِ</span> <span class="ar-tone-subject">الطَّالِبَتَانِ</span>.</span><span class="rule-table-ru">Две студентки вышли.</span></td></tr><tr><td><span class="rule-table-ar">جَمْعٌ</span><span class="rule-table-ru">множественное</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">خَرَجَ</span> <span class="ar-tone-subject">الطُّلَّابُ</span>.</span><span class="rule-table-ru">Студенты вышли.</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">خَرَجَتِ</span> <span class="ar-tone-subject">الطَّالِبَاتُ</span>.</span><span class="rule-table-ru">Студентки вышли.</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_6_id;

  -- 7. Complete source table identifying the subject in each past form.
  update public.rules
  set
    sort_order = 7,
    title = 'تَعْيِينُ الْفَاعِلِ فِي الْفِعْلِ الْمَاضِي (определение исполнителя в прошедшем глаголе)',
    rule_ar = 'فَاعِلُ الْفِعْلِ الْمَاضِي إِمَّا ضَمِيرٌ مُسْتَتِرٌ، وَإِمَّا ضَمِيرُ رَفْعٍ مُتَّصِلٌ: تَاءُ الْفَاعِلِ، أَوْ وَاوُ الْجَمَاعَةِ، أَوْ نُونُ النِّسْوَةِ، أَوْ نَا الْمُتَكَلِّمِينَ. وَتَاءُ التَّأْنِيثِ السَّاكِنَةُ عَلَامَةُ تَأْنِيثٍ وَلَيْسَتْ فَاعِلًا، وَالْأَلِفُ بَعْدَ وَاوِ الْجَمَاعَةِ أَلِفٌ فَارِقَةٌ.',
    summary = 'فَاعِلُ الْفِعْلِ الْمَاضِي إِمَّا ضَمِيرٌ مُسْتَتِرٌ، وَإِمَّا ضَمِيرُ رَفْعٍ مُتَّصِلٌ: تَاءُ الْفَاعِلِ، أَوْ وَاوُ الْجَمَاعَةِ، أَوْ نُونُ النِّسْوَةِ، أَوْ نَا الْمُتَكَلِّمِينَ. وَتَاءُ التَّأْنِيثِ السَّاكِنَةُ عَلَامَةُ تَأْنِيثٍ وَلَيْسَتْ فَاعِلًا، وَالْأَلِفُ بَعْدَ وَاوِ الْجَمَاعَةِ أَلِفٌ فَارِقَةٌ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Как найти исполнителя</span><span class="rule-main-ar" dir="rtl" lang="ar">فَاعِلُ الْفِعْلِ الْمَاضِي إِمَّا <span class="ar-tone-subject">ضَمِيرٌ مُسْتَتِرٌ</span>، وَإِمَّا <span class="ar-tone-subject">ضَمِيرُ رَفْعٍ مُتَّصِلٌ</span>.</span><p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">تَاءُ التَّأْنِيثِ السَّاكِنَةُ</span> только обозначает женский род и не является исполнителем. Алиф после <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span> — разделительный алиф и также не является исполнителем.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Полная таблица из шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْفِعْلُ</span><span class="rule-table-ru">форма</span></th><th><span class="rule-table-ar">الْفَاعِلُ</span><span class="rule-table-ru">исполнитель</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبَ</span><span class="rule-table-ru">он ушёл</span></td><td><span class="rule-table-ar ar-tone-subject">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هُوَ».</span><span class="rule-table-ru">Скрытое местоимение «он».</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبَتْ</span><span class="rule-table-ru">она ушла</span></td><td><span class="rule-table-ar ar-tone-subject">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هِيَ»؛ وَالتَّاءُ السَّاكِنَةُ عَلَامَةُ التَّأْنِيثِ.</span><span class="rule-table-ru">Скрытое «она»; неподвижная та — только показатель женского рода.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبُوا</span><span class="rule-table-ru">они, мужчины, ушли</span></td><td><span class="rule-table-ar ar-tone-subject">وَاوُ الْجَمَاعَةِ «و»؛ وَالْأَلِفُ أَلِفٌ فَارِقَةٌ.</span><span class="rule-table-ru">Вау группы — исполнитель; алиф является разделительным.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبْنَ</span><span class="rule-table-ru">они, женщины, ушли</span></td><td><span class="rule-table-ar ar-tone-subject">نُونُ النِّسْوَةِ «ن».</span><span class="rule-table-ru">Нун женщин — исполнитель.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتُ</span><span class="rule-table-ru">я ушёл / ушла</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ «ت».</span><span class="rule-table-ru">Подвижная та — исполнитель.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتَ</span><span class="rule-table-ru">ты, мужчина, ушёл</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ «ت».</span><span class="rule-table-ru">Подвижная та — исполнитель.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتُمْ</span><span class="rule-table-ru">вы, мужчины, ушли</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ «ت»؛ وَالْمِيمُ عَلَامَةُ الْجَمْعِ لِلْمُذَكَّرِ.</span><span class="rule-table-ru">Подвижная та — исполнитель; мим обозначает мужское множественное.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتُنَّ</span><span class="rule-table-ru">вы, женщины, ушли</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ «ت»؛ وَالنُّونُ عَلَامَةُ الْجَمْعِ لِلْمُؤَنَّثِ.</span><span class="rule-table-ru">Подвижная та — исполнитель; нун обозначает женское множественное.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتِ</span><span class="rule-table-ru">ты, женщина, ушла</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ «ت».</span><span class="rule-table-ru">Подвижная та — исполнитель.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبْنَا</span><span class="rule-table-ru">мы ушли</span></td><td><span class="rule-table-ar ar-tone-subject">نُونُ الْمُتَكَلِّمِينَ «نَا».</span><span class="rule-table-ru">Нун говорящих — исполнитель.</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_7_id;

  -- 8. Breaking the meeting of two sukuns in connected reading only.
  update public.rules
  set
    sort_order = 8,
    title = 'كَسْرُ السَّاكِنِ الْأَوَّلِ عِنْدَ الْتِقَاءِ السَّاكِنَيْنِ (касра первого сукуна при встрече двух сукунов)',
    rule_ar = 'عِنْدَ الْتِقَاءِ السَّاكِنَيْنِ يُكْسَرُ السَّاكِنُ الْأَوَّلُ. فِي وَصْلِ «بِلَالٌ الْأَذَانَ» تُكْسَرُ نُونُ التَّنْوِينِ فِي الْقِرَاءَةِ فَقَطْ، وَتَبْقَى الْكِتَابَةُ كَمَا هِيَ.',
    summary = 'عِنْدَ الْتِقَاءِ السَّاكِنَيْنِ يُكْسَرُ السَّاكِنُ الْأَوَّلُ. فِي وَصْلِ «بِلَالٌ الْأَذَانَ» تُكْسَرُ نُونُ التَّنْوِينِ فِي الْقِرَاءَةِ فَقَطْ، وَتَبْقَى الْكِتَابَةُ كَمَا هِيَ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">فَائِدَةٌ — полезное замечание</span><span class="rule-main-ar" dir="rtl" lang="ar">عِنْدَ <span class="ar-tone-structure">الْتِقَاءِ السَّاكِنَيْنِ</span> يُكْسَرُ السَّاكِنُ الْأَوَّلُ.</span><p class="rule-study-text">В сочетании танвина с последующим определённым артиклем встречаются два сукуна: скрытый нун танвина и лям артикля. При слитном чтении первый из них получает касру.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Написание и произношение</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الْكِتَابَةُ:</span> سَمِعَ <span class="ar-tone-subject">بِلَالٌ</span> <span class="ar-tone-nasb">الْأَذَانَ</span>.</span><span class="rule-example-ru">На письме: «Биляль услышал азан». Написание остаётся без изменений.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">تَمْثِيلُ النُّطْقِ:</span> سَمِعَ <span class="ar-tone-subject">بِلَالُنِ</span> <span class="ar-tone-nasb">الْأَذَانَ</span>.</span><span class="rule-example-ru">Передача слитного произношения: нун танвина читается с касрой. Это только чтение, а не новое написание слова.</span></div></div></div><div class="rule-check-card"><b>При васлировании.</b> Начальный алиф артикля не получает отдельной фатхи: <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">بِلَالُنِ الْأَذَانَ</span>.</div></div>$$
  where id = rule_8_id;

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id, rule_7_id, rule_8_id);

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الخامس
الفاعل والمفعول به
الجملة تنقسم إلى قسمين:
• الجملة الاسمية: هي التي أولها اسم وتتكون من المبتدأ والخبر، نحو: محمد مجتهد، هذه جملة اسمية؛ لأن أولها اسم وهي جملة مفيدة.
• والجملة الفعلية: هي التي أولها فعل، وتتكون من الفعل والفاعل (أو الفعل ونائب الفاعل).$$, 17, 17, 1),
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$والخبر ثلاثة أنواع:
١. اسم مفرد، نحو: بلال طالب.
٢. جملة، والجملة إما فعلية، وإما اسمية، نحو:
بلال خرج (جملة فعلية).
بلال خطه جميل (جملة اسمية).
٣. شبه جملة؛ وشبه الجملة إما يكون جاراً ومجروراً، وإما ظرفاً (ظرف مكان أو ظرف زمان)، نحو:
بلال في الفصل (جار ومجرور).
بلال خلف محمد (ظرف مكان).$$, 17, 17, 1),
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$والجملة الفعلية: هي التي أولها فعل، وتتكون من الفعل والفاعل (أو الفعل ونائب الفاعل)،
نحو: قرأ الطالب القرآن.
قرأ: فعل ماض مبني على الفتح.
الطالب: فاعل مرفوع وعلامة رفعه الضمة الظاهرة على آخره.
القرآن: مفعول به منصوب وعلامة نصبه الفتحة الظاهرة على آخره.$$,
      17, 17, 1),
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$تنبيه:
الفاعل مرفوع دائماً، والمفعول به منصوب دائماً. والفاعل هو الذي فعل الفعل، والمفعول به هو الذي وقع عليه فعل الفاعل، نحو: ضرب زيدٌ عمراً.
فزيد: فاعل؛ لأنه فعل الفعل (ضرب)، وعمراً: مفعول به؛ لأنه وقع عليه فعل الفاعل (الضرب).$$,
      18, 18, 1),
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$الفاعل:
• إما يكون اسماً ظاهراً، نحو: خرج بلال أو خرج الطالب.
• وإما أن يكون ضمير رفع متصلاً (وقد يكون منفصلاً؛ نحو: ما فهم الدرس إلا أنت).
نحو: خرجت (ت) أو خرجوا (و).
كذلك المفعول به يكون اسماً ظاهراً وضميراً، نحو: قرأت الدرس (اسم ظاهر)، وفهمه (ه) (ضمير نصب متصل).$$,
      18, 18, 1),
    (rule_6_id, 'Podrobny_Sharkh_2_tom.pdf', $$إذا تقدم الفعل وجب أن يكون مفرداً وإن كان الفاعل مثنى أو جمعاً.
نحو:
خرج الطالب (الفاعل مفرد). خرجت الطالبة (الفاعل مفرد).
خرج الطالبان (الفاعل مثنى). خرجت الطالبتان (الفاعل مثنى).
خرج الطلاب (الفاعل جمع). خرجت الطالبات (الفاعل جمع).$$,
      18, 18, 1),
    (rule_7_id, 'Podrobny_Sharkh_2_tom.pdf', $$تعيين الفاعل في الفعل الماضي (الفعل: ذهب)
ذهب | ضمير مستتر تقديره "هو"
ذهبت | ضمير مستتر تقديره "هي"، والتاء الساكنة: علامة التأنيث
ذهبوا | واو الجماعة (و)، والألف: ألف الفارقة
ذهبن | نون النسوة (ن)
ذهبت | التاء المتحركة (ت)
ذهبت | التاء المتحركة (ت)
ذهبتم | التاء المتحركة (ت)، والميم علامة الجمع للمذكر
ذهبتن | التاء المتحركة (ت)، والنون علامة الجمع للمؤنث
ذهبت | التاء المتحركة (ت)
ذهبنا | نون المتكلمين (نا)$$,
      19, 19, 1),
    (rule_8_id, 'Podrobny_Sharkh_2_tom.pdf', $$فائدة:
سمع بلالٌ الأذان.
يقرأ "سمع بلالن الأذان" بكسر نون التنوين أي: سمع بلال ن الأذان بسبب التقاء الساكنين (نون التنوين ولام التعريف في الأذان). وعند التقاء الساكنين يكسر الساكن الأول.
تنبيه: هذا في القراءة فقط، أما في الكتابة تبقى كما هي: سمع بلال الأذان.$$,
      19, 19, 1);
end;
$migration$;

commit;
