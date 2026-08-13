-- Verify Medina Book 2 lesson 3 against the complete 80-page Arabic sharh.
-- Sole source: Podrobny_Sharkh_2_tom.pdf, PDF pages 11-14.

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
    and lesson_number = '3';

  if lesson_rule_count not in (5, 7) then
    raise exception 'Expected 5 or 7 Book 2 lesson 3 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 1;
  select id into strict rule_2_id from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 2;
  select id into strict rule_3_id from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 3;

  if lesson_rule_count = 5 then
    select id into strict rule_5_id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 4;
    select id into strict rule_6_id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 5;
  else
    select id into strict rule_4_id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 4;
    select id into strict rule_5_id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 5;
    select id into strict rule_6_id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 6;
    select id into strict rule_7_id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 7;
  end if;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '3'
  );

  -- Free sort positions before preserving the existing ordinal and negative-question cards.
  update public.rules set sort_order = 6 where id = rule_6_id;
  update public.rules set sort_order = 5 where id = rule_5_id;

  -- 1. اسم التفضيل: formation, doubled and maqsur forms, and both source-listed uses.
  update public.rules
  set
    sort_order = 1,
    title = 'اِسْمُ التَّفْضِيلِ (имя сравнительной и превосходной степени)',
    rule_ar = 'اِسْمُ التَّفْضِيلِ وَصْفٌ عَلَى وَزْنِ «أَفْعَلَ»، وَهُوَ مَمْنُوعٌ مِنَ الصَّرْفِ. وَإِذَا كَانَ مُضَعَّفًا أُدْغِمَ الْحَرْفَانِ الْمِثْلَانِ، وَإِذَا كَانَ مَقْصُورًا لَا تَظْهَرُ عَلَيْهِ عَلَامَةُ الْإِعْرَابِ. وَيَأْتِي بَعْدَهُ «مِنْ»، أَوْ يَكُونُ مُضَافًا.',
    summary = 'اِسْمُ التَّفْضِيلِ وَصْفٌ عَلَى وَزْنِ «أَفْعَلَ»، وَهُوَ مَمْنُوعٌ مِنَ الصَّرْفِ. وَإِذَا كَانَ مُضَعَّفًا أُدْغِمَ الْحَرْفَانِ الْمِثْلَانِ، وَإِذَا كَانَ مَقْصُورًا لَا تَظْهَرُ عَلَيْهِ عَلَامَةُ الْإِعْرَابِ. وَيَأْتِي بَعْدَهُ «مِنْ»، أَوْ يَكُونُ مُضَافًا.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">اِسْمُ التَّفْضِيلِ</span> وَصْفٌ عَلَى وَزْنِ <span class="ar-tone-structure">«أَفْعَلَ»</span>، وَهُوَ مَمْنُوعٌ مِنَ الصَّرْفِ.</span><p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">اِسْمُ التَّفْضِيلِ</span> выражает превосходство одного предмета над другим по общему признаку. Он строится по модели <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">أَفْعَلُ</span> и относится к словам, запрещённым от полного склонения.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Образование формы</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الصِّفَةُ</span><span class="rule-table-ru">исходное качество</span></th><th><span class="rule-table-ar">اِسْمُ التَّفْضِيلِ</span><span class="rule-table-ru">форма сравнения</span></th><th><span class="rule-table-ar">الْأَصْلُ</span><span class="rule-table-ru">форма до слияния</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">جَمِيلٌ</span><span class="rule-table-ru">красивый</span></td><td><span class="rule-table-ar ar-tone-structure">أَجْمَلُ</span><span class="rule-table-ru">красивее; самый красивый</span></td><td><span class="rule-table-ar">—</span><span class="rule-table-ru">обычная модель</span></td></tr><tr><td><span class="rule-table-ar">جَيِّدٌ</span><span class="rule-table-ru">хороший</span></td><td><span class="rule-table-ar ar-tone-structure">أَجْوَدُ</span><span class="rule-table-ru">лучше; наилучший</span></td><td><span class="rule-table-ar">—</span><span class="rule-table-ru">обычная модель</span></td></tr><tr><td><span class="rule-table-ar">لَذِيذٌ</span><span class="rule-table-ru">вкусный</span></td><td><span class="rule-table-ar ar-tone-structure">أَلَذُّ</span><span class="rule-table-ru">вкуснее; самый вкусный</span></td><td><span class="rule-table-ar">أَلْذَذُ</span><span class="rule-table-ru">две одинаковые буквы слились</span></td></tr><tr><td><span class="rule-table-ar">جَدِيدٌ</span><span class="rule-table-ru">новый</span></td><td><span class="rule-table-ar ar-tone-structure">أَجَدُّ</span><span class="rule-table-ru">новее; самый новый</span></td><td><span class="rule-table-ar">أَجْدَدُ</span><span class="rule-table-ru">две одинаковые буквы слились</span></td></tr><tr><td><span class="rule-table-ar">قَلِيلٌ</span><span class="rule-table-ru">малочисленный; малый</span></td><td><span class="rule-table-ar ar-tone-structure">أَقَلُّ</span><span class="rule-table-ru">меньше; наименьший</span></td><td><span class="rule-table-ar">أَقْلَلُ</span><span class="rule-table-ru">две одинаковые буквы слились</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Форма на конечный алиф</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا كَانَ <span class="ar-tone-structure">اِسْمُ التَّفْضِيلِ مَقْصُورًا</span> لَا تَظْهَرُ عَلَيْهِ عَلَامَةُ الْإِعْرَابِ.</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">غَنِيٌّ ← <span class="ar-tone-structure">أَغْنَى</span></span><span class="rule-example-ru">богатый → богаче; самый богатый</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">ذَكِيٌّ ← <span class="ar-tone-structure">أَذْكَى</span></span><span class="rule-example-ru">умный → умнее; самый умный. Падежное окончание на конечном алифе внешне не проявляется.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Два употребления из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-jarr"><span class="rule-example-ar" dir="rtl" lang="ar">أَحْمَدُ <span class="ar-tone-structure">أَطْوَلُ</span> <span class="ar-tone-jarr">مِنْ مُحَمَّدٍ</span>.</span><span class="rule-example-ru">Ахмад выше Мухаммада. После имени сравнения стоит <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">مِنْ</span> — «чем».</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَحْمَدُ <span class="ar-tone-structure">أَطْوَلُ طَالِبٍ</span> فِي الْفَصْلِ.</span><span class="rule-example-ru">Ахмад — самый высокий ученик в классе. Имя сравнения является первым членом идафы.</span></div></div></div></div>$$
  where id = rule_1_id;

  -- 2. The decades, replacing the unrelated لَكِنَّ / كَأَنَّ card.
  update public.rules
  set
    sort_order = 2,
    title = 'الْعُقُودُ مِنْ عِشْرِينَ إِلَى تِسْعِينَ (десятки от двадцати до девяноста)',
    rule_ar = 'الْأَعْدَادُ مِنْ عِشْرِينَ إِلَى تِسْعِينَ تُسَمَّى عُقُودًا، وَتُعْرَبُ إِعْرَابَ جَمْعِ الْمُذَكَّرِ السَّالِمِ لِأَنَّهَا مُلْحَقَةٌ بِهِ: تُرْفَعُ بِالْوَاوِ، وَتُنْصَبُ وَتُجَرُّ بِالْيَاءِ. وَمَعْدُودُهَا مُفْرَدٌ مَنْصُوبٌ.',
    summary = 'الْأَعْدَادُ مِنْ عِشْرِينَ إِلَى تِسْعِينَ تُسَمَّى عُقُودًا، وَتُعْرَبُ إِعْرَابَ جَمْعِ الْمُذَكَّرِ السَّالِمِ لِأَنَّهَا مُلْحَقَةٌ بِهِ: تُرْفَعُ بِالْوَاوِ، وَتُنْصَبُ وَتُجَرُّ بِالْيَاءِ. وَمَعْدُودُهَا مُفْرَدٌ مَنْصُوبٌ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الْعُقُودُ</span> مِنْ عِشْرِينَ إِلَى تِسْعِينَ تُعْرَبُ إِعْرَابَ <span class="ar-tone-raf">جَمْعِ الْمُذَكَّرِ السَّالِمِ</span>، وَمَعْدُودُهَا <span class="ar-tone-nasb">مُفْرَدٌ مَنْصُوبٌ</span>.</span><p class="rule-study-text">Числа от двадцати до девяноста называются десятками. Они присоединены к категории правильного множественного числа мужского рода: поднимаются с <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">الْوَاوُ</span>, а в винительном и родительном падежах получают <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">الْيَاءُ</span>. Считаемое слово всегда стоит в единственном числе и винительном падеже.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Три падежных состояния</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْحَالَةُ</span><span class="rule-table-ru">состояние</span></th><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример</span></th><th><span class="rule-table-ar">الْعَلَامَةُ</span><span class="rule-table-ru">показатель</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-raf">الرَّفْعُ</span><span class="rule-table-ru">именительный падеж</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">هَؤُلَاءِ</span> <span class="ar-tone-raf">عِشْرُونَ</span> <span class="ar-tone-nasb">طَالِبًا</span>.</span><span class="rule-table-ru">Это двадцать студентов.</span></td><td><span class="rule-table-ar ar-tone-raf">مَرْفُوعٌ بِالْوَاوِ</span><span class="rule-table-ru">именительный с вау</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">النَّصْبُ</span><span class="rule-table-ru">винительный падеж</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">رَأَيْتُ</span> <span class="ar-tone-nasb">عِشْرِينَ طَالِبًا</span>.</span><span class="rule-table-ru">Я увидел двадцать студентов.</span></td><td><span class="rule-table-ar ar-tone-nasb">مَنْصُوبٌ بِالْيَاءِ</span><span class="rule-table-ru">винительный с йа</span></td></tr><tr><td><span class="rule-table-ar ar-tone-jarr">الْجَرُّ</span><span class="rule-table-ru">родительный падеж</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">سَلَّمْتُ</span> عَلَى <span class="ar-tone-jarr">عِشْرِينَ</span> <span class="ar-tone-nasb">طَالِبًا</span>.</span><span class="rule-table-ru">Я поприветствовал двадцать студентов.</span></td><td><span class="rule-table-ar ar-tone-jarr">مَجْرُورٌ بِالْيَاءِ</span><span class="rule-table-ru">родительный с йа</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_2_id;

  -- 3. Construction and i'rab of compound numerals, including the exception of twelve.
  update public.rules
  set
    sort_order = 3,
    title = 'بِنَاءُ الْعَدَدِ الْمُرَكَّبِ وَإِعْرَابُ اثْنَيْ عَشَرَ (построение составных числительных и склонение двенадцати)',
    rule_ar = 'الْعَدَدُ الْمُرَكَّبُ مِنْ أَحَدَ عَشَرَ إِلَى تِسْعَةَ عَشَرَ مُكَوَّنٌ مِنْ جُزْأَيْنِ، وَهُوَ مَبْنِيٌّ عَلَى فَتْحِ الْجُزْأَيْنِ فِي الرَّفْعِ وَالنَّصْبِ وَالْجَرِّ. وَيُسْتَثْنَى الْجُزْءُ الْأَوَّلُ مِنِ اثْنَيْ عَشَرَ وَاثْنَتَيْ عَشْرَةَ، فَيُعْرَبُ إِعْرَابَ الْمُثَنَّى. وَمَعْدُودُ الْعَدَدِ الْمُرَكَّبِ مُفْرَدٌ مَنْصُوبٌ دَائِمًا.',
    summary = 'الْعَدَدُ الْمُرَكَّبُ مِنْ أَحَدَ عَشَرَ إِلَى تِسْعَةَ عَشَرَ مُكَوَّنٌ مِنْ جُزْأَيْنِ، وَهُوَ مَبْنِيٌّ عَلَى فَتْحِ الْجُزْأَيْنِ فِي الرَّفْعِ وَالنَّصْبِ وَالْجَرِّ. وَيُسْتَثْنَى الْجُزْءُ الْأَوَّلُ مِنِ اثْنَيْ عَشَرَ وَاثْنَتَيْ عَشْرَةَ، فَيُعْرَبُ إِعْرَابَ الْمُثَنَّى. وَمَعْدُودُ الْعَدَدِ الْمُرَكَّبِ مُفْرَدٌ مَنْصُوبٌ دَائِمًا.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الْعَدَدُ الْمُرَكَّبُ</span> مِنْ أَحَدَ عَشَرَ إِلَى تِسْعَةَ عَشَرَ مُكَوَّنٌ مِنْ جُزْأَيْنِ، وَهُوَ <span class="ar-tone-structure">مَبْنِيٌّ عَلَى فَتْحِ الْجُزْأَيْنِ</span> فِي الْحَالَاتِ الثَّلَاثِ.</span><p class="rule-study-text">Числа 11–19 состоят из двух частей. Обе части имеют постоянную фатху в именительном, винительном и родительном падежах. Исключение — первая часть числа двенадцать: она изменяется как двойственное число. После составного числительного считаемое слово всегда единственное и винительное.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Постоянная фатха обеих частей</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هَؤُلَاءِ <span class="ar-tone-structure">ثَلَاثَةَ عَشَرَ</span> <span class="ar-tone-nasb">طَالِبًا</span>.</span><span class="rule-example-ru">Это тринадцать студентов — форма одинакова в именительном падеже.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">رَأَيْتُ</span> <span class="ar-tone-structure">ثَلَاثَةَ عَشَرَ</span> <span class="ar-tone-nasb">طَالِبًا</span>.</span><span class="rule-example-ru">Я увидел тринадцать студентов — форма одинакова в винительном падеже.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">سَلَّمْتُ</span> عَلَى <span class="ar-tone-structure">ثَلَاثَةَ عَشَرَ</span> <span class="ar-tone-nasb">طَالِبًا</span>.</span><span class="rule-example-ru">Я поприветствовал тринадцать студентов — форма одинакова в родительном падеже.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Исключение: двенадцать</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْحَالَةُ</span><span class="rule-table-ru">состояние</span></th><th><span class="rule-table-ar">الْمُذَكَّرُ</span><span class="rule-table-ru">мужской род</span></th><th><span class="rule-table-ar">الْمُؤَنَّثُ</span><span class="rule-table-ru">женский род</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-raf">الرَّفْعُ</span><span class="rule-table-ru">именительный</span></td><td><span class="rule-table-ar ar-tone-raf">اثْنَا عَشَرَ طَالِبًا</span><span class="rule-table-ru">двенадцать студентов</span></td><td><span class="rule-table-ar ar-tone-raf">اثْنَتَا عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">двенадцать студенток</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">النَّصْبُ</span><span class="rule-table-ru">винительный</span></td><td><span class="rule-table-ar ar-tone-nasb">اثْنَيْ عَشَرَ طَالِبًا</span><span class="rule-table-ru">двенадцать студентов</span></td><td><span class="rule-table-ar ar-tone-nasb">اثْنَتَيْ عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">двенадцать студенток</span></td></tr><tr><td><span class="rule-table-ar ar-tone-jarr">الْجَرُّ</span><span class="rule-table-ru">родительный</span></td><td><span class="rule-table-ar ar-tone-jarr">اثْنَيْ عَشَرَ طَالِبًا</span><span class="rule-table-ru">двенадцать студентов</span></td><td><span class="rule-table-ar ar-tone-jarr">اثْنَتَيْ عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">двенадцать студенток</span></td></tr></tbody></table></div></div><div class="rule-check-card"><b>Соединительная хамза.</b> После предыдущего слова не добавляйте гласную на хамзу соединения: <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">مِنِ اثْنَيْ عَشَرَ</span>.</div></div>$$
  where id = rule_3_id;

  -- 4. Gender agreement and opposition in 11-19.
  if rule_4_id is null then
    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values ('Мединский курс (Том 2)', '3', '', '', 4, 'rule', '', '')
    returning id into rule_4_id;
  end if;

  update public.rules
  set
    sort_order = 4,
    title = 'تَذْكِيرُ الْعَدَدِ الْمُرَكَّبِ وَتَأْنِيثُهُ (род частей составного числительного)',
    rule_ar = 'فِي أَحَدَ عَشَرَ وَاثْنَيْ عَشَرَ الْجُزْآنِ يُوَافِقَانِ الْمَعْدُودَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَمِنْ ثَلَاثَةَ عَشَرَ إِلَى تِسْعَةَ عَشَرَ الْجُزْءُ الْأَوَّلُ يُخَالِفُ الْمَعْدُودَ، وَالْجُزْءُ الثَّانِي يُوَافِقُهُ.',
    summary = 'فِي أَحَدَ عَشَرَ وَاثْنَيْ عَشَرَ الْجُزْآنِ يُوَافِقَانِ الْمَعْدُودَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَمِنْ ثَلَاثَةَ عَشَرَ إِلَى تِسْعَةَ عَشَرَ الْجُزْءُ الْأَوَّلُ يُخَالِفُ الْمَعْدُودَ، وَالْجُزْءُ الثَّانِي يُوَافِقُهُ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило рода</span><span class="rule-main-ar" dir="rtl" lang="ar">فِي <span class="ar-tone-structure">أَحَدَ عَشَرَ وَاثْنَيْ عَشَرَ</span> الْجُزْآنِ يُوَافِقَانِ الْمَعْدُودَ، وَمِنْ <span class="ar-tone-structure">ثَلَاثَةَ عَشَرَ إِلَى تِسْعَةَ عَشَرَ</span> الْجُزْءُ الْأَوَّلُ يُخَالِفُهُ وَالثَّانِي يُوَافِقُهُ.</span><p class="rule-study-text">В 11 и 12 обе части совпадают с родом считаемого слова. В 13–19 первая часть противоположна его роду, а вторая часть совпадает с ним.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Полная таблица 11–19</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْعَدَدُ</span><span class="rule-table-ru">число</span></th><th><span class="rule-table-ar">مَعَ الْمُذَكَّرِ</span><span class="rule-table-ru">с мужским считаемым</span></th><th><span class="rule-table-ar">مَعَ الْمُؤَنَّثِ</span><span class="rule-table-ru">с женским считаемым</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">١١</span><span class="rule-table-ru">одиннадцать</span></td><td><span class="rule-table-ar ar-tone-structure">أَحَدَ عَشَرَ طَالِبًا</span><span class="rule-table-ru">одиннадцать студентов</span></td><td><span class="rule-table-ar ar-tone-structure">إِحْدَى عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">одиннадцать студенток</span></td></tr><tr><td><span class="rule-table-ar">١٢</span><span class="rule-table-ru">двенадцать</span></td><td><span class="rule-table-ar ar-tone-structure">اثْنَا عَشَرَ طَالِبًا</span><span class="rule-table-ru">двенадцать студентов</span></td><td><span class="rule-table-ar ar-tone-structure">اثْنَتَا عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">двенадцать студенток</span></td></tr><tr><td><span class="rule-table-ar">١٣</span><span class="rule-table-ru">тринадцать</span></td><td><span class="rule-table-ar ar-tone-structure">ثَلَاثَةَ عَشَرَ طَالِبًا</span><span class="rule-table-ru">тринадцать студентов</span></td><td><span class="rule-table-ar ar-tone-structure">ثَلَاثَ عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">тринадцать студенток</span></td></tr><tr><td><span class="rule-table-ar">١٤</span><span class="rule-table-ru">четырнадцать</span></td><td><span class="rule-table-ar ar-tone-structure">أَرْبَعَةَ عَشَرَ طَالِبًا</span><span class="rule-table-ru">четырнадцать студентов</span></td><td><span class="rule-table-ar ar-tone-structure">أَرْبَعَ عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">четырнадцать студенток</span></td></tr><tr><td><span class="rule-table-ar">١٥</span><span class="rule-table-ru">пятнадцать</span></td><td><span class="rule-table-ar ar-tone-structure">خَمْسَةَ عَشَرَ طَالِبًا</span><span class="rule-table-ru">пятнадцать студентов</span></td><td><span class="rule-table-ar ar-tone-structure">خَمْسَ عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">пятнадцать студенток</span></td></tr><tr><td><span class="rule-table-ar">١٦</span><span class="rule-table-ru">шестнадцать</span></td><td><span class="rule-table-ar ar-tone-structure">سِتَّةَ عَشَرَ طَالِبًا</span><span class="rule-table-ru">шестнадцать студентов</span></td><td><span class="rule-table-ar ar-tone-structure">سِتَّ عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">шестнадцать студенток</span></td></tr><tr><td><span class="rule-table-ar">١٧</span><span class="rule-table-ru">семнадцать</span></td><td><span class="rule-table-ar ar-tone-structure">سَبْعَةَ عَشَرَ طَالِبًا</span><span class="rule-table-ru">семнадцать студентов</span></td><td><span class="rule-table-ar ar-tone-structure">سَبْعَ عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">семнадцать студенток</span></td></tr><tr><td><span class="rule-table-ar">١٨</span><span class="rule-table-ru">восемнадцать</span></td><td><span class="rule-table-ar ar-tone-structure">ثَمَانِيَةَ عَشَرَ طَالِبًا</span><span class="rule-table-ru">восемнадцать студентов</span></td><td><span class="rule-table-ar ar-tone-structure">ثَمَانِيَ عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">восемнадцать студенток</span></td></tr><tr><td><span class="rule-table-ar">١٩</span><span class="rule-table-ru">девятнадцать</span></td><td><span class="rule-table-ar ar-tone-structure">تِسْعَةَ عَشَرَ طَالِبًا</span><span class="rule-table-ru">девятнадцать студентов</span></td><td><span class="rule-table-ar ar-tone-structure">تِسْعَ عَشْرَةَ طَالِبَةً</span><span class="rule-table-ru">девятнадцать студенток</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_4_id;

  -- 5. Ordinal numerals and the complete source table from first through tenth.
  update public.rules
  set
    sort_order = 5,
    title = 'الْعَدَدُ التَّرْتِيبِيُّ (порядковое числительное)',
    rule_ar = 'الْعَدَدُ التَّرْتِيبِيُّ نَعْتٌ لِمَعْدُودِهِ، وَيُوَافِقُهُ فِي التَّذْكِيرِ وَالتَّأْنِيثِ.',
    summary = 'الْعَدَدُ التَّرْتِيبِيُّ نَعْتٌ لِمَعْدُودِهِ، وَيُوَافِقُهُ فِي التَّذْكِيرِ وَالتَّأْنِيثِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الْعَدَدُ التَّرْتِيبِيُّ</span> <span class="ar-tone-predicate">نَعْتٌ</span> لِمَعْدُودِهِ، وَيُوَافِقُهُ فِي التَّذْكِيرِ وَالتَّأْنِيثِ.</span><p class="rule-study-text">Порядковое числительное является определением своего считаемого слова и согласуется с ним в мужском или женском роде.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Формы от первого до десятого</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْعَدَدُ</span><span class="rule-table-ru">номер</span></th><th><span class="rule-table-ar">الْمُذَكَّرُ</span><span class="rule-table-ru">мужской род</span></th><th><span class="rule-table-ar">الْمُؤَنَّثُ</span><span class="rule-table-ru">женский род</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">١</span><span class="rule-table-ru">первый</span></td><td><span class="rule-table-ar ar-tone-structure">الدَّرْسُ الْأَوَّلُ</span><span class="rule-table-ru">первый урок</span></td><td><span class="rule-table-ar ar-tone-structure">الْحِصَّةُ الْأُولَى</span><span class="rule-table-ru">первое занятие</span></td></tr><tr><td><span class="rule-table-ar">٢</span><span class="rule-table-ru">второй</span></td><td><span class="rule-table-ar ar-tone-structure">الدَّرْسُ الثَّانِي</span><span class="rule-table-ru">второй урок</span></td><td><span class="rule-table-ar ar-tone-structure">الْحِصَّةُ الثَّانِيَةُ</span><span class="rule-table-ru">второе занятие</span></td></tr><tr><td><span class="rule-table-ar">٣</span><span class="rule-table-ru">третий</span></td><td><span class="rule-table-ar ar-tone-structure">الدَّرْسُ الثَّالِثُ</span><span class="rule-table-ru">третий урок</span></td><td><span class="rule-table-ar ar-tone-structure">الْحِصَّةُ الثَّالِثَةُ</span><span class="rule-table-ru">третье занятие</span></td></tr><tr><td><span class="rule-table-ar">٤</span><span class="rule-table-ru">четвёртый</span></td><td><span class="rule-table-ar ar-tone-structure">الدَّرْسُ الرَّابِعُ</span><span class="rule-table-ru">четвёртый урок</span></td><td><span class="rule-table-ar ar-tone-structure">الْحِصَّةُ الرَّابِعَةُ</span><span class="rule-table-ru">четвёртое занятие</span></td></tr><tr><td><span class="rule-table-ar">٥</span><span class="rule-table-ru">пятый</span></td><td><span class="rule-table-ar ar-tone-structure">الدَّرْسُ الْخَامِسُ</span><span class="rule-table-ru">пятый урок</span></td><td><span class="rule-table-ar ar-tone-structure">الْحِصَّةُ الْخَامِسَةُ</span><span class="rule-table-ru">пятое занятие</span></td></tr><tr><td><span class="rule-table-ar">٦</span><span class="rule-table-ru">шестой</span></td><td><span class="rule-table-ar ar-tone-structure">الدَّرْسُ السَّادِسُ</span><span class="rule-table-ru">шестой урок</span></td><td><span class="rule-table-ar ar-tone-structure">الْحِصَّةُ السَّادِسَةُ</span><span class="rule-table-ru">шестое занятие</span></td></tr><tr><td><span class="rule-table-ar">٧</span><span class="rule-table-ru">седьмой</span></td><td><span class="rule-table-ar ar-tone-structure">الدَّرْسُ السَّابِعُ</span><span class="rule-table-ru">седьмой урок</span></td><td><span class="rule-table-ar ar-tone-structure">الْحِصَّةُ السَّابِعَةُ</span><span class="rule-table-ru">седьмое занятие</span></td></tr><tr><td><span class="rule-table-ar">٨</span><span class="rule-table-ru">восьмой</span></td><td><span class="rule-table-ar ar-tone-structure">الدَّرْسُ الثَّامِنُ</span><span class="rule-table-ru">восьмой урок</span></td><td><span class="rule-table-ar ar-tone-structure">الْحِصَّةُ الثَّامِنَةُ</span><span class="rule-table-ru">восьмое занятие</span></td></tr><tr><td><span class="rule-table-ar">٩</span><span class="rule-table-ru">девятый</span></td><td><span class="rule-table-ar ar-tone-structure">الدَّرْسُ التَّاسِعُ</span><span class="rule-table-ru">девятый урок</span></td><td><span class="rule-table-ar ar-tone-structure">الْحِصَّةُ التَّاسِعَةُ</span><span class="rule-table-ru">девятое занятие</span></td></tr><tr><td><span class="rule-table-ar">١٠</span><span class="rule-table-ru">десятый</span></td><td><span class="rule-table-ar ar-tone-structure">الدَّرْسُ الْعَاشِرُ</span><span class="rule-table-ru">десятый урок</span></td><td><span class="rule-table-ar ar-tone-structure">الْحِصَّةُ الْعَاشِرَةُ</span><span class="rule-table-ru">десятое занятие</span></td></tr></tbody></table></div></div></div>$$
  where id = rule_5_id;

  -- 6. Correct answers to a negative question.
  update public.rules
  set
    sort_order = 6,
    title = 'جَوَابُ الِاسْتِفْهَامِ الْمَنْفِيِّ بِبَلَى وَنَعَمْ (ответ на отрицательный вопрос)',
    rule_ar = 'إِذَا كَانَ الِاسْتِفْهَامُ مَنْفِيًّا، كَانَ جَوَابُهُ فِي الْإِثْبَاتِ «بَلَى»، وَفِي النَّفْيِ «نَعَمْ».',
    summary = 'إِذَا كَانَ الِاسْتِفْهَامُ مَنْفِيًّا، كَانَ جَوَابُهُ فِي الْإِثْبَاتِ «بَلَى»، وَفِي النَّفْيِ «نَعَمْ».',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا كَانَ <span class="ar-tone-particle">الِاسْتِفْهَامُ مَنْفِيًّا</span>، كَانَ جَوَابُهُ فِي الْإِثْبَاتِ <span class="ar-tone-particle">«بَلَى»</span>، وَفِي النَّفْيِ <span class="ar-tone-particle">«نَعَمْ»</span>.</span><p class="rule-study-text">Если вопрос содержит отрицание, <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">بَلَى</span> отменяет его и утверждает положительный ответ. <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">نَعَمْ</span> подтверждает отрицание.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Сравните ответы</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَلَسْتَ</span> طَبِيبًا؟ <span class="ar-tone-particle">بَلَى</span>، أَنَا طَبِيبٌ.</span><span class="rule-example-ru">Разве ты не врач? — Напротив, я врач.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَلَسْتَ</span> طَبِيبًا؟ <span class="ar-tone-particle">نَعَمْ</span>، لَسْتُ طَبِيبًا.</span><span class="rule-example-ru">Разве ты не врач? — Да, верно: я не врач.</span></div></div></div><div class="rule-check-card"><b>Смысл ответа определяется отрицанием в вопросе.</b> Здесь русское «да» нельзя механически передавать одной и той же арабской частицей.</div></div>$$
  where id = rule_6_id;

  -- 7. أيهما as an inflected interrogative in obligatory idafa with the dual pronoun.
  if rule_7_id is null then
    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values ('Мединский курс (Том 2)', '3', '', '', 7, 'rule', '', '')
    returning id into rule_7_id;
  end if;

  update public.rules
  set
    sort_order = 7,
    title = 'أَيُّهُمَا لِلتَّعْيِينِ (который из двоих?)',
    rule_ar = 'أَيٌّ اسْمُ اسْتِفْهَامٍ مُعْرَبٌ، وَهُوَ مُلَازِمٌ لِلْإِضَافَةِ، وَهُمَا ضَمِيرُ الْمُثَنَّى. وَالِاسْتِفْهَامُ بِأَيُّهُمَا يُرَادُ بِهِ التَّعْيِينُ.',
    summary = 'أَيٌّ اسْمُ اسْتِفْهَامٍ مُعْرَبٌ، وَهُوَ مُلَازِمٌ لِلْإِضَافَةِ، وَهُمَا ضَمِيرُ الْمُثَنَّى. وَالِاسْتِفْهَامُ بِأَيُّهُمَا يُرَادُ بِهِ التَّعْيِينُ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Состав и значение</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَيٌّ</span> اسْمُ اسْتِفْهَامٍ مُعْرَبٌ، وَهُوَ مُلَازِمٌ لِلْإِضَافَةِ؛ وَ<span class="ar-tone-structure">هُمَا</span> ضَمِيرُ الْمُثَنَّى.</span><p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَيٌّ</span> — изменяемое вопросительное имя, которое обязательно входит в идафу. <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">هُمَا</span> — местоимение двойственного числа. Вместе <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَيُّهُمَا</span> означает «который из них двоих?» и служит для выбора одного из двух.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Пример из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مُحَمَّدٌ: عِنْدِي قَلَمَانِ.<br>حَامِدٌ: <span class="ar-tone-particle">أَيُّهُمَا</span> أَرْخَصُ؟</span><span class="rule-example-ru">Мухаммад: «У меня две ручки». Хамид: «Которая из них двоих дешевле?»</span></div></div></div></div>$$
  where id = rule_7_id;

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id, rule_7_id);

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الثالث
اسم التفضيل
اسم التفضيل وصف على وزن "أفعل" وهو ممنوع من الصرف
نحو:
١. جميل – أجمل.
٢. جيد – أجود.
٣. اسم التفضيل المضعف:
نحو:
• لذيذ – ألذّ، أصله: ألذذ.
• جديد – أجدّ، أصله: أجدد.
• قليل – أقلّ، أصله: أقلل.
اسم التفضيل المقصور الذي آخره ألف لازمة مفتوح ما قبلها، نحو:
١. غنيّ – أغنى.
٢. ذكيّ – أذكى.
فمثل هذه الكلمات لا تظهر علامة الإعراب فلا نقول: هو أذكىٌ مني.
اسم التفضيل:
١. إما أن يأتي بعده "من"،
نحو: أحمد أطول من محمد.
٢. وإما أن يكون مضافاً،
نحو: أحمد أطول طالب في الفصل.$$,
      11, 11, 1),
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$الأعداد من عشرين إلى تسعين فتسمى عقوداً وتعرب إعراب جمع مذكر السالم لأنها ملحقة بجمع المذكر السالم، ومعدودها مفرد منصوب.
نحو:
• هؤلاء عشرون طالباً (مرفوع بالواو).
• رأيت عشرين طالباً (منصوب بالياء).
• سلمت على عشرين طالباً (مجرور بالياء).$$,
      12, 12, 1),
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$الأعداد المركبة هي الأعداد من أحد عشر (١١) إلى تسعة عشر (١٩).
العدد المركب:
١. مكون من كلمتين (جزءين)،
نحو: أحد عشر.
٢. مبني على فتح الجزئين،
نحو:
• هؤلاء ثلاثة عشر طالباً.
• رأيت ثلاثة عشر طالباً.
• سلمت على ثلاثة عشر طالباً.
فالعدد المركب مبني على فتح الجزئين في كل الحالات (حالة الرفع والنصب والجر).
إلا الجزء الأول في اثني عشر واثنتي عشرة فهما معربان كما ترى، ويعربان إعراب المثنى،
نحو:
• هؤلاء اثنا عشر طالباً، اثنتا عشرة طالبة (مرفوع بالألف).
• رأيت اثني عشر طالباً، اثنتي عشرة طالبة (منصوب بالياء).
• سلمت على اثني عشر طالباً، اثنتي عشرة طالبة (مجرور بالياء).
٣. معدوده مفرد منصوب دائماً.
نحو: أحد عشر طالباً.$$,
      12, 12, 1),
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$في أحد عشر طالباً (١١) واثنتي عشرة طالبة (١٢) الجزءان يوافقان المعدود في التذكير والتأنيث، ومن ثلاثة عشر (١٣) إلى تسعة عشر (١٩) الجزء الأول يخالف المعدود والجزء الثاني يوافقه في التذكير والتأنيث.$$,
      13, 13, 1),
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$العدد الترتيبي
العدد الترتيبي نعت لمعدوده، ويوافقه في التذكير والتأنيث.$$,
      14, 14, 1),
    (rule_6_id, 'Podrobny_Sharkh_2_tom.pdf', $$أليس كذلك؟
إذا كان الاستفهام منفياً، نحو: "أليس كذلك؟"، فجوابه في الإثبات "بلى" وفي النفي "نعم".
نحو: ألست طبيباً؟
بلى. أنا طبيب.
أو نعم. لست طبيباً.$$,
      14, 14, 1),
    (rule_7_id, 'Podrobny_Sharkh_2_tom.pdf', $$أيهما
أيّ: اسم استفهام معرب، وهو ملازم للإضافة.
هما: ضمير المثنى.
"أيهما" استفهام يراد به التعيين، نحو:
محمد: عندي قلمان.
حامد: أيهما أرخص؟$$,
      14, 14, 1);
end;
$migration$;

commit;
