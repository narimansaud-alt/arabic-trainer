-- Verify Medina Book 2 lesson 6 against the complete 80-page Arabic sharh.
-- Sole source: Podrobny_Sharkh_2_tom.pdf, PDF pages 20-22.

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
    and lesson_number = '6';

  if lesson_rule_count <> 6 then
    raise exception 'Expected 6 Book 2 lesson 6 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 4;
  select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 5;
  select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 6;

  delete from public.rule_sections
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id);

  -- 1. The three source classifications and the complete ten-row pronoun table.
  update public.rules
  set
    sort_order = 1,
    title = 'أَقْسَامُ الضَّمَائِرِ وَجَدْوَلُهَا (разряды местоимений и полная таблица)',
    rule_ar = 'تَنْقَسِمُ الضَّمَائِرُ بِاعْتِبَارِ الِاتِّصَالِ وَالِانْفِصَالِ إِلَى مُتَّصِلَةٍ وَمُنْفَصِلَةٍ، وَبِاعْتِبَارِ الْإِعْرَابِ إِلَى ضَمَائِرِ رَفْعٍ وَنَصْبٍ وَجَرٍّ، وَبِاعْتِبَارِ الظُّهُورِ وَالِاسْتِتَارِ إِلَى بَارِزَةٍ وَمُسْتَتِرَةٍ.',
    summary = 'تَنْقَسِمُ الضَّمَائِرُ بِاعْتِبَارِ الِاتِّصَالِ وَالِانْفِصَالِ إِلَى مُتَّصِلَةٍ وَمُنْفَصِلَةٍ، وَبِاعْتِبَارِ الْإِعْرَابِ إِلَى ضَمَائِرِ رَفْعٍ وَنَصْبٍ وَجَرٍّ، وَبِاعْتِبَارِ الظُّهُورِ وَالِاسْتِتَارِ إِلَى بَارِزَةٍ وَمُسْتَتِرَةٍ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Три способа классификации</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">الِاتِّصَالُ وَالِانْفِصَالُ</span><span class="rule-term-ru">По слитности: <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">ضَمِيرٌ مُتَّصِلٌ</span> — слитное местоимение; <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">ضَمِيرٌ مُنْفَصِلٌ</span> — отдельное местоимение.</span></div><div class="rule-meaning-card rule-term-object"><span class="rule-term-ar" dir="rtl" lang="ar">الْإِعْرَابُ</span><span class="rule-term-ru">По синтаксическому месту: <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">ضَمِيرُ رَفْعٍ</span> — в позиции именительного состояния; <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">ضَمِيرُ نَصْبٍ</span> — винительного; <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">ضَمِيرُ جَرٍّ</span> — родительного.</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">الظُّهُورُ وَالِاسْتِتَارُ</span><span class="rule-term-ru">По выраженности: <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ بَارِزٌ</span> — явно выраженное; <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ</span> — скрытое местоимение.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полная таблица из шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">ضَمَائِرُ الرَّفْعِ الْمُنْفَصِلَةُ</span><span class="rule-table-ru">отдельные местоимения именительного состояния</span></th><th><span class="rule-table-ar">ضَمَائِرُ الرَّفْعِ الْمُتَّصِلَةُ</span><span class="rule-table-ru">слитные местоимения именительного состояния</span></th><th><span class="rule-table-ar">ضَمَائِرُ النَّصْبِ الْمُتَّصِلَةُ</span><span class="rule-table-ru">слитные местоимения винительного состояния</span></th><th><span class="rule-table-ar">ضَمَائِرُ الْجَرِّ الْمُتَّصِلَةُ</span><span class="rule-table-ru">слитные местоимения родительного состояния</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-subject">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar ar-tone-subject">ذَهَبْتُ: تُ</span><span class="rule-table-ru">я ушёл / ушла; та — исполнитель</span></td><td><span class="rule-table-ar ar-tone-nasb">عَلَّمَنِي: ي</span><span class="rule-table-ru">он научил меня; йа — дополнение</span></td><td><span class="rule-table-ar ar-tone-jarr">كِتَابِي: ي</span><span class="rule-table-ru">моя книга; йа — добавленное к имени местоимение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar ar-tone-subject">ذَهَبْنَا: نَا</span><span class="rule-table-ru">мы ушли; на — исполнитель</span></td><td><span class="rule-table-ar ar-tone-nasb">عَلَّمَنَا: نَا</span><span class="rule-table-ru">он научил нас; на — дополнение</span></td><td><span class="rule-table-ar ar-tone-jarr">كِتَابُنَا: نَا</span><span class="rule-table-ru">наша книга; на — добавленное к имени местоимение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar ar-tone-subject">ذَهَبْتَ: تَ</span><span class="rule-table-ru">ты ушёл; та — исполнитель</span></td><td><span class="rule-table-ar ar-tone-nasb">عَلَّمَكَ: كَ</span><span class="rule-table-ru">он научил тебя, мужчину; каф — дополнение</span></td><td><span class="rule-table-ar ar-tone-jarr">كِتَابُكَ: كَ</span><span class="rule-table-ru">твоя книга, у мужчины; каф — добавленное местоимение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-subject">ذَهَبْتِ: تِ</span><span class="rule-table-ru">ты ушла; та — исполнитель</span></td><td><span class="rule-table-ar ar-tone-nasb">عَلَّمَكِ: كِ</span><span class="rule-table-ru">он научил тебя, женщину; каф — дополнение</span></td><td><span class="rule-table-ar ar-tone-jarr">كِتَابُكِ: كِ</span><span class="rule-table-ru">твоя книга, у женщины; каф — добавленное местоимение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-subject">ذَهَبْتُمْ: ت</span><span class="rule-table-ru">вы ушли; та — исполнитель, мим указывает множественное число</span></td><td><span class="rule-table-ar ar-tone-nasb">عَلَّمَكُمْ: كُمْ</span><span class="rule-table-ru">он научил вас, мужчин; кум — дополнение</span></td><td><span class="rule-table-ar ar-tone-jarr">كِتَابُكُمْ: كُمْ</span><span class="rule-table-ru">ваша книга, у мужчин; кум — добавленное местоимение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar ar-tone-subject">ذَهَبْتُنَّ: ت</span><span class="rule-table-ru">вы ушли; та — исполнитель, нун указывает женское множественное</span></td><td><span class="rule-table-ar ar-tone-nasb">عَلَّمَكُنَّ: كُنَّ</span><span class="rule-table-ru">он научил вас, женщин; кунна — дополнение</span></td><td><span class="rule-table-ar ar-tone-jarr">كِتَابُكُنَّ: كُنَّ</span><span class="rule-table-ru">ваша книга, у женщин; кунна — добавленное местоимение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar ar-tone-subject">ذَهَبَ: ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هُوَ»</span><span class="rule-table-ru">он ушёл; исполнитель — скрытое «он»</span></td><td><span class="rule-table-ar ar-tone-nasb">عَلَّمَهُ: هُ</span><span class="rule-table-ru">он научил его; ха — дополнение</span></td><td><span class="rule-table-ar ar-tone-jarr">كِتَابُهُ: هُ</span><span class="rule-table-ru">его книга; ха — добавленное местоимение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar ar-tone-subject">ذَهَبَتْ: ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هِيَ»</span><span class="rule-table-ru">она ушла; исполнитель — скрытое «она»</span></td><td><span class="rule-table-ar ar-tone-nasb">عَلَّمَهَا: هَا</span><span class="rule-table-ru">он научил её; ха — дополнение</span></td><td><span class="rule-table-ar ar-tone-jarr">كِتَابُهَا: هَا</span><span class="rule-table-ru">её книга; ха — добавленное местоимение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُمْ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar ar-tone-subject">ذَهَبُوا: و</span><span class="rule-table-ru">они ушли; вау группы — исполнитель</span></td><td><span class="rule-table-ar ar-tone-nasb">عَلَّمَهُمْ: هُمْ</span><span class="rule-table-ru">он научил их, мужчин; хум — дополнение</span></td><td><span class="rule-table-ar ar-tone-jarr">كِتَابُهُمْ: هُمْ</span><span class="rule-table-ru">их книга, у мужчин; хум — добавленное местоимение</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُنَّ</span><span class="rule-table-ru">они, женщины</span></td><td><span class="rule-table-ar ar-tone-subject">ذَهَبْنَ: ن</span><span class="rule-table-ru">они ушли; нун женщин — исполнитель</span></td><td><span class="rule-table-ar ar-tone-nasb">عَلَّمَهُنَّ: هُنَّ</span><span class="rule-table-ru">он научил их, женщин; хунна — дополнение</span></td><td><span class="rule-table-ar ar-tone-jarr">كِتَابُهُنَّ: هُنَّ</span><span class="rule-table-ru">их книга, у женщин; хунна — добавленное местоимение</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_1_id;

  -- 2. The three syntactic positions of the attached first-person plural pronoun.
  update public.rules
  set
    sort_order = 2,
    title = 'ضَمِيرُ الْمُتَكَلِّمِينَ «نَا» وَمَحَلُّهُ (местоимение «мы/нас/наш» и его синтаксическая позиция)',
    rule_ar = 'ضَمِيرُ الْمُتَكَلِّمِينَ الْمُتَّصِلُ هُوَ «نَا»، وَالْمُنْفَصِلُ هُوَ «نَحْنُ». وَيَكُونُ «نَا» فِي مَحَلِّ جَرٍّ إِذَا كَانَ مُضَافًا إِلَيْهِ، وَفِي مَحَلِّ نَصْبٍ إِذَا كَانَ اسْمَ «إِنَّ»، وَفِي مَحَلِّ رَفْعٍ إِذَا كَانَ فَاعِلًا.',
    summary = 'ضَمِيرُ الْمُتَكَلِّمِينَ الْمُتَّصِلُ هُوَ «نَا»، وَالْمُنْفَصِلُ هُوَ «نَحْنُ». وَيَكُونُ «نَا» فِي مَحَلِّ جَرٍّ إِذَا كَانَ مُضَافًا إِلَيْهِ، وَفِي مَحَلِّ نَصْبٍ إِذَا كَانَ اسْمَ «إِنَّ»، وَفِي مَحَلِّ رَفْعٍ إِذَا كَانَ فَاعِلًا.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Слитная и отдельная формы</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الضَّمِيرُ الْمُتَّصِلُ:</span> نَا؛ <span class="ar-tone-structure">الضَّمِيرُ الْمُنْفَصِلُ:</span> نَحْنُ.</span><p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">نَا</span> — слитное местоимение говорящих; <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">نَحْنُ</span> — соответствующее отдельное местоимение «мы».</p></div><div class="rule-study-card"><span class="rule-card-kicker">Один пример — три позиции</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-jarr">رَبَّنَا</span> <span class="ar-tone-nasb">إِنَّنَا</span> <span class="ar-tone-verb">سَمِعْنَا</span>.</span><p class="rule-study-text">Господь наш! Поистине, мы услышали.</p><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример</span></th><th><span class="rule-table-ar">مَحَلُّ «نَا»</span><span class="rule-table-ru">синтаксическая позиция «на»</span></th><th><span class="rule-table-ar">الْمَعْنَى</span><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-jarr">رَبَّنَا</span><span class="rule-table-ru">Господь наш</span></td><td><span class="rule-table-ar ar-tone-jarr">مُضَافٌ إِلَيْهِ فِي مَحَلِّ جَرٍّ</span><span class="rule-table-ru">добавленное местоимение в позиции родительного состояния</span></td><td><span class="rule-table-ar">نَا</span><span class="rule-table-ru">наш</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">إِنَّنَا</span><span class="rule-table-ru">поистине, мы</span></td><td><span class="rule-table-ar ar-tone-nasb">اسْمُ «إِنَّ» فِي مَحَلِّ نَصْبٍ</span><span class="rule-table-ru">имя частицы «инна» в позиции винительного состояния</span></td><td><span class="rule-table-ar">نَا</span><span class="rule-table-ru">мы</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">سَمِعْنَا</span><span class="rule-table-ru">мы услышали</span></td><td><span class="rule-table-ar ar-tone-subject">فَاعِلٌ فِي مَحَلِّ رَفْعٍ</span><span class="rule-table-ru">исполнитель в позиции именительного состояния</span></td><td><span class="rule-table-ar">نَا</span><span class="rule-table-ru">мы</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_2_id;

  -- 3. أظن takes two objects and may precede أن with its noun and predicate.
  update public.rules
  set
    sort_order = 3,
    title = 'أَظُنُّ وَمَفْعُولَاهُ (глагол «я думаю» и два его дополнения)',
    rule_ar = '«أَظُنُّ» فِعْلٌ يَنْصِبُ مَفْعُولَيْنِ، نَحْوُ: أَظُنُّ الطَّالِبَ غَائِبًا. وَقَدْ يَدْخُلُ عَلَى «أَنَّ» وَاسْمِهَا وَخَبَرِهَا، نَحْوُ: أَظُنُّ أَنَّ الْمُدَرِّسَ جَدِيدٌ.',
    summary = '«أَظُنُّ» فِعْلٌ يَنْصِبُ مَفْعُولَيْنِ، نَحْوُ: أَظُنُّ الطَّالِبَ غَائِبًا. وَقَدْ يَدْخُلُ عَلَى «أَنَّ» وَاسْمِهَا وَخَبَرِهَا، نَحْوُ: أَظُنُّ أَنَّ الْمُدَرِّسَ جَدِيدٌ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Два прямых дополнения</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَظُنُّ</span> <span class="ar-tone-nasb">الطَّالِبَ</span> <span class="ar-tone-nasb">غَائِبًا</span>.</span><p class="rule-study-text">Я думаю, что студент отсутствует. <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">الطَّالِبَ</span> — первое прямое дополнение; <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">غَائِبًا</span> — второе.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Перед أَنَّ с её именем и сказуемым</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَظُنُّ</span> <span class="ar-tone-structure">أَنَّ</span> <span class="ar-tone-nasb">الْمُدَرِّسَ</span> <span class="ar-tone-predicate">جَدِيدٌ</span>.</span><p class="rule-study-text">Я думаю, что преподаватель новый.</p><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْكَلِمَةُ</span><span class="rule-table-ru">слово</span></th><th><span class="rule-table-ar">إِعْرَابُهَا</span><span class="rule-table-ru">грамматический разбор</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-nasb">الْمُدَرِّسَ</span><span class="rule-table-ru">преподаватель</span></td><td><span class="rule-table-ar ar-tone-nasb">اسْمُ «أَنَّ» مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-table-ru">Имя «анна» в винительном состоянии; показатель — явная фатха в конце.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-predicate">جَدِيدٌ</span><span class="rule-table-ru">новый</span></td><td><span class="rule-table-ar ar-tone-raf">خَبَرُ «أَنَّ» مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-table-ru">Сказуемое «анна» в именительном состоянии; показатель — явная дамма в конце.</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_3_id;

  -- 4. Complete source table for فعلان / فعلى / فعال and its stated exception.
  update public.rules
  set
    sort_order = 4,
    title = 'جَمْعُ فَعْلَانَ وَفَعْلَى عَلَى فِعَالٍ (множественное модели «фа‘лян/фа‘ля»)',
    rule_ar = 'تُجْمَعُ الصِّفَةُ الَّتِي عَلَى وَزْنِ «فَعْلَانَ» لِلْمُذَكَّرِ وَ«فَعْلَى» لِلْمُؤَنَّثِ عَلَى وَزْنِ «فِعَالٍ» لِلْمُذَكَّرِ وَالْمُؤَنَّثِ، وَ«كُسَالَى» خِلَافُ الْقَاعِدَةِ.',
    summary = 'تُجْمَعُ الصِّفَةُ الَّتِي عَلَى وَزْنِ «فَعْلَانَ» لِلْمُذَكَّرِ وَ«فَعْلَى» لِلْمُؤَنَّثِ عَلَى وَزْنِ «فِعَالٍ» لِلْمُذَكَّرِ وَالْمُؤَنَّثِ، وَ«كُسَالَى» خِلَافُ الْقَاعِدَةِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Модель образования</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">فَعْلَانُ</span> لِلْمُذَكَّرِ + <span class="ar-tone-structure">فَعْلَى</span> لِلْمُؤَنَّثِ ← <span class="ar-tone-structure">فِعَالٌ</span> لِلْجَمْعِ الْمُذَكَّرِ وَالْمُؤَنَّثِ.</span><p class="rule-study-text">Прилагательное мужского рода модели <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">فَعْلَانُ</span> имеет женскую форму <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">فَعْلَى</span>; общее множественное обоих родов строится по модели <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">فِعَالٌ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Полная таблица из шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">فَعْلَانُ</span><span class="rule-table-ru">мужской род, единственное число</span></th><th><span class="rule-table-ar">فَعْلَى</span><span class="rule-table-ru">женский род, единственное число</span></th><th><span class="rule-table-ar">فِعَالٌ</span><span class="rule-table-ru">множественное обоих родов</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-structure">جَوْعَانُ</span><span class="rule-table-ru">голодный</span></td><td><span class="rule-table-ar ar-tone-structure">جَوْعَى</span><span class="rule-table-ru">голодная</span></td><td><span class="rule-table-ar ar-tone-structure">جِيَاعٌ</span><span class="rule-table-ru">голодные</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure">شَبْعَانُ</span><span class="rule-table-ru">сытый</span></td><td><span class="rule-table-ar ar-tone-structure">شَبْعَى</span><span class="rule-table-ru">сытая</span></td><td><span class="rule-table-ar ar-tone-structure">شِبَاعٌ</span><span class="rule-table-ru">сытые</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure">غَضْبَانُ</span><span class="rule-table-ru">сердитый</span></td><td><span class="rule-table-ar ar-tone-structure">غَضْبَى</span><span class="rule-table-ru">сердитая</span></td><td><span class="rule-table-ar ar-tone-structure">غِضَابٌ</span><span class="rule-table-ru">сердитые</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure">كَسْلَانُ</span><span class="rule-table-ru">ленивый</span></td><td><span class="rule-table-ar ar-tone-structure">كَسْلَى</span><span class="rule-table-ru">ленивая</span></td><td><span class="rule-table-ar ar-tone-structure">كُسَالَى</span><span class="rule-table-ru">ленивые; исключение из модели <span class="ar-inline" dir="rtl" lang="ar">فِعَالٌ</span></span></td></tr></tbody></table></div></div></div>$$
  where id = rule_4_id;

  -- 5. The pause hā in لمه.
  update public.rules
  set
    sort_order = 5,
    title = 'هَاءُ السَّكْتِ فِي «لِمَهْ؟» (ха паузы в слове «почему?»)',
    rule_ar = 'الْهَاءُ فِي «لِمَهْ؟» تُسَمَّى هَاءَ السَّكْتِ، وَيُؤْتَى بِهَا سَاكِنَةً فِي الْوَقْفِ، وَ«لِمَهْ؟» بِمَعْنَى «لِمَاذَا؟».',
    summary = 'الْهَاءُ فِي «لِمَهْ؟» تُسَمَّى هَاءَ السَّكْتِ، وَيُؤْتَى بِهَا سَاكِنَةً فِي الْوَقْفِ، وَ«لِمَهْ؟» بِمَعْنَى «لِمَاذَا؟».',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الْهَاءُ فِي <span class="ar-tone-structure">«لِمَهْ؟»</span> تُسَمَّى <span class="ar-tone-structure">هَاءَ السَّكْتِ</span>، وَيُؤْتَى بِهَا سَاكِنَةً فِي الْوَقْفِ.</span><p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">لِمَهْ؟</span> означает «почему?». Конечная <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">هْ</span> — неподвижная ха паузы.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Диалог из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أَخَرَجْتَ مِنَ الْفَصْلِ يَا مُحَمَّدُ؟</span><span class="rule-example-ru">Ты вышел из класса, Мухаммад?</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">نَعَمْ، خَرَجْتُ.</span><span class="rule-example-ru">Да, я вышел.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَهْ؟</span><span class="rule-example-ru">Почему?</span></div></div></div></div>$$
  where id = rule_5_id;

  -- 6. The imperative هات and all four forms supplied by the source.
  update public.rules
  set
    sort_order = 6,
    title = 'هَاتِ وَصِيَغُهُ (повелительный глагол «дай/принеси» и его формы)',
    rule_ar = '«هَاتِ» فِعْلُ أَمْرٍ عَلَى الْقَوْلِ الرَّاجِحِ، وَتَكُونُ تَاؤُهُ مَكْسُورَةً إِلَّا مَعَ وَاوِ الْجَمَاعَةِ فَتَكُونُ مَضْمُومَةً. وَمَعْنَى «هَاتِ الْكِتَابَ»: «أَعْطِنِي الْكِتَابَ».',
    summary = '«هَاتِ» فِعْلُ أَمْرٍ عَلَى الْقَوْلِ الرَّاجِحِ، وَتَكُونُ تَاؤُهُ مَكْسُورَةً إِلَّا مَعَ وَاوِ الْجَمَاعَةِ فَتَكُونُ مَضْمُومَةً. وَمَعْنَى «هَاتِ الْكِتَابَ»: «أَعْطِنِي الْكِتَابَ».',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">هَاتِ</span> فِعْلُ أَمْرٍ عَلَى الْقَوْلِ الرَّاجِحِ. تَاؤُهُ مَكْسُورَةٌ، إِلَّا مَعَ <span class="ar-tone-subject">وَاوِ الْجَمَاعَةِ</span> فَهِيَ مَضْمُومَةٌ.</span><p class="rule-study-text"><span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">هَاتِ الْكِتَابَ</span> означает «дай мне книгу» или «принеси книгу».</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все формы из шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْمُخَاطَبُ</span><span class="rule-table-ru">к кому обращаются</span></th><th><span class="rule-table-ar">الصِّيغَةُ</span><span class="rule-table-ru">форма и пример</span></th><th><span class="rule-table-ar">الْمَعْنَى</span><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">مُفْرَدٌ مُذَكَّرٌ</span><span class="rule-table-ru">один мужчина</span></td><td><span class="rule-table-ar ar-tone-verb">هَاتِ الْكِتَابَ يَا مُحَمَّدُ.</span><span class="rule-table-ru">форма <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">هَاتِ</span></span></td><td><span class="rule-table-ar">أَعْطِنِي الْكِتَابَ.</span><span class="rule-table-ru">Дай мне книгу, Мухаммад.</span></td></tr><tr><td><span class="rule-table-ar">مُفْرَدَةٌ مُؤَنَّثَةٌ</span><span class="rule-table-ru">одна женщина</span></td><td><span class="rule-table-ar ar-tone-verb">هَاتِي الْكِتَابَ يَا آمِنَةُ.</span><span class="rule-table-ru">форма <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">هَاتِي</span></span></td><td><span class="rule-table-ar">أَعْطِينِي الْكِتَابَ.</span><span class="rule-table-ru">Дай мне книгу, Амина.</span></td></tr><tr><td><span class="rule-table-ar">جَمْعٌ مُذَكَّرٌ</span><span class="rule-table-ru">группа мужчин</span></td><td><span class="rule-table-ar ar-tone-verb">هَاتُوا الْكِتَابَ يَا أَوْلَادُ.</span><span class="rule-table-ru">форма <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">هَاتُوا</span></span></td><td><span class="rule-table-ar">أَعْطُونِي الْكِتَابَ.</span><span class="rule-table-ru">Дайте мне книгу, мальчики.</span></td></tr><tr><td><span class="rule-table-ar">جَمْعٌ مُؤَنَّثٌ</span><span class="rule-table-ru">группа женщин</span></td><td><span class="rule-table-ar ar-tone-verb">هَاتِينَ الْكِتَابَ يَا بَنَاتُ.</span><span class="rule-table-ru">форма <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">هَاتِينَ</span></span></td><td><span class="rule-table-ar">أَعْطِينَنِي الْكِتَابَ.</span><span class="rule-table-ru">Дайте мне книгу, девочки.</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_6_id;

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id);

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس السادس
الضمائر

تنقسم الضمائر باعتبار الاتصال والانفصال إلى:
• ضمائر منفصلة، نحو: أنا أذهب.
• ضمائر متصلة، نحو: ذهبت.
وتنقسم الضمائر باعتبار الإعراب إلى:
• ضمائر الرفع، نحو: ذهبت (ت: فاعل).
• ضمائر النصب، نحو: رأيتك (ك: مفعول به).
• ضمائر الجر، نحو: كتابك (ك: مضاف إليه).
وتنقسم الضمائر باعتبار الظهور والاستتار إلى:
• ضمائر بارزة، نحو: ذهبت، الفاعل ضمير بارز هو (التاء).
• ضمائر مستترة، نحو: ذهب، الفاعل ضمير مستتر تقديره "هو".

الضمائر
ضمائر الرفع المنفصلة | ضمائر الرفع المتصلة | ضمائر النصب المتصلة | ضمائر الجر المتصلة
أنا | ذَهَبْتُ: ت | عَلَّمَنِي: ي | كتابي: ي
نحن | ذَهَبْنَا: نا | عَلَّمَنَا: نا | كتابنا: نا
أَنْتَ | ذَهَبْتَ: ت | عَلَّمَكَ: ك | كتابك: ك
أَنْتِ | ذَهَبْتِ: ت | عَلَّمَكِ: ك | كتابك: ك
أَنْتُمْ | ذَهَبْتُمْ: ت | عَلَّمَكُمْ: كم | كتابكم: كم
أَنْتُنَّ | ذَهَبْتُنَّ: ت | عَلَّمَكُنَّ: كن | كتابكن: كن
هو | ذَهَبَ: ضمير مستتر تقديره "هو" | عَلَّمَهُ: ه | كتابه: ه
هي | ذَهَبَتْ: ضمير مستتر تقديره "هي" | عَلَّمَهَا: ها | كتابها: ها
هم | ذَهَبُوا: و | عَلَّمَهُمْ: هم | كتابهم: هم
هُنَّ | ذَهَبْنَ: ن | عَلَّمَهُنَّ: هن | كتابهن: هن$$, 20, 20, 1),
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$الضمير المتصل للمتكلمين هو (نا)، وفي المنفصل (نحن).
نحو: ربنا إننا سمعنا.
(نا) في (ربنا): مضاف إليه في محل جر.
(نا) في (إننا): اسم إن في محل نصب.
(نا) في (سمعنا): فاعل في محل رفع.$$,
      21, 21, 1),
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$أظن
"أظن" فعل تنصب مفعولين، نحو: أظن الطالب غائباً (الطالب) هو المفعول الأول، و(غائباً) هو المفعول الثاني.
وقد تدخل "أظن" على "أن واسمها وخبرها"، نحو: أظن أن المدرس جديد.
المدرس: اسم أن منصوب وعلامة نصبه الفتحة الظاهرة على آخره.
جديد: خبر أن مرفوع وعلامة رفعه الضمة الظاهرة على آخره.$$,
      21, 21, 1),
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$تجمع الصفة التي على وزن "فعلان" و"فعلى" على وزن "فعال" للمذكر والمؤنث، نحو:
فعلان (مفرد مذكر) | فعلى (مفرد مؤنث) | فعال (جمع مذكر ومؤنث)
جوعان | جوعى | جياع
شبعان | شبعى | شباع
غضبان | غضبى | غضاب
كسلان | كسلى | كسالى (خلاف القاعدة)$$,
      21, 21, 1),
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$لمة
المدرس: أخرجت من الفصل يا محمد؟
محمد: نعم، خرجت.
المدرس: لمه؟
الهاء تسمى هاء السكت، ويؤتى بها ساكنة في الوقف، وهي بمعنى "لماذا".$$,
      21, 21, 1),
    (rule_6_id, 'Podrobny_Sharkh_2_tom.pdf', $$هات
هات: فعل أمر (على القول الراجح) وتكون مكسورة التاء إلا مع واو الجماعة فتكون التاء مضمومة، نحو:
هات الكتاب يا محمد
هاتي الكتاب يا آمنة
هاتوا الكتاب يا أولاد
هاتين الكتاب يا بنات
والمعنى: أعطني الكتاب.$$,
      22, 22, 1);
end;
$migration$;

commit;
