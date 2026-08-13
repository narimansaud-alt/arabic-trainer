-- Verify Medina Book 2 lesson 4 against the complete 80-page Arabic sharh.
-- Sole source: Podrobny_Sharkh_2_tom.pdf, PDF pages 15-16.

begin;

do $migration$
declare
  target_rule_id bigint;
  lesson_rule_count integer;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '4';

  if lesson_rule_count <> 3 then
    raise exception 'Expected 3 Book 2 lesson 4 rules, found %', lesson_rule_count;
  end if;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '4'
  );

  -- 1. Complete source table of the ten past-tense pronoun forms.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '4'
    and sort_order = 1;

  update public.rules
  set
    title = 'إِسْنَادُ الْفِعْلِ الْمَاضِي إِلَى الضَّمَائِرِ الْعَشَرَةِ (спряжение прошедшего времени с десятью местоимениями)',
    rule_ar = 'يُسْنَدُ الْفِعْلُ الْمَاضِي إِلَى الضَّمَائِرِ الْعَشَرَةِ، فَتَدُلُّ صِيغَتُهُ عَلَى الْمُتَكَلِّمِ أَوِ الْمُخَاطَبِ أَوِ الْغَائِبِ، وَعَلَى الْإِفْرَادِ أَوِ الْجَمْعِ، وَعَلَى التَّذْكِيرِ أَوِ التَّأْنِيثِ. وَصِيَغُ ذَهَبَ هِيَ: ذَهَبْتُ، ذَهَبْتَ، ذَهَبْتِ، ذَهَبَ، ذَهَبَتْ، ذَهَبْنَا، ذَهَبْتُمْ، ذَهَبْتُنَّ، ذَهَبُوا، ذَهَبْنَ.',
    summary = 'يُسْنَدُ الْفِعْلُ الْمَاضِي إِلَى الضَّمَائِرِ الْعَشَرَةِ، فَتَدُلُّ صِيغَتُهُ عَلَى الْمُتَكَلِّمِ أَوِ الْمُخَاطَبِ أَوِ الْغَائِبِ، وَعَلَى الْإِفْرَادِ أَوِ الْجَمْعِ، وَعَلَى التَّذْكِيرِ أَوِ التَّأْنِيثِ. وَصِيَغُ ذَهَبَ هِيَ: ذَهَبْتُ، ذَهَبْتَ، ذَهَبْتِ، ذَهَبَ، ذَهَبَتْ، ذَهَبْنَا، ذَهَبْتُمْ، ذَهَبْتُنَّ، ذَهَبُوا، ذَهَبْنَ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">يُسْنَدُ <span class="ar-tone-verb">الْفِعْلُ الْمَاضِي</span> إِلَى <span class="ar-tone-subject">الضَّمَائِرِ الْعَشَرَةِ</span>، فَتَدُلُّ صِيغَتُهُ عَلَى الْمُتَكَلِّمِ أَوِ الْمُخَاطَبِ أَوِ الْغَائِبِ، وَعَلَى الْإِفْرَادِ أَوِ الْجَمْعِ، وَعَلَى التَّذْكِيرِ أَوِ التَّأْنِيثِ.</span><p class="rule-study-text">Форма прошедшего глагола показывает, кто совершил действие: говорящий, собеседник или отсутствующий; единственное это число или множественное; мужской это род или женский.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Полная таблица из шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الضَّمِيرُ</span><span class="rule-table-ru">местоимение</span></th><th><span class="rule-table-ar">صِيغَةُ ذَهَبَ</span><span class="rule-table-ru">форма «ушёл»</span></th><th><span class="rule-table-ar">الدَّلَالَةُ</span><span class="rule-table-ru">лицо, число и род</span></th><th><span class="rule-table-ar">نَوْعُ الضَّمِيرِ</span><span class="rule-table-ru">разряд местоимения</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-subject">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتُ</span><span class="rule-table-ru">я ушёл / ушла</span></td><td><span class="rule-table-ar">مُفْرَدُ الْمُتَكَلِّمِ</span><span class="rule-table-ru">говорящий, единственное число</span></td><td><span class="rule-table-ar">ضَمِيرُ الْمُتَكَلِّمِ</span><span class="rule-table-ru">местоимение говорящего</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتَ</span><span class="rule-table-ru">ты ушёл</span></td><td><span class="rule-table-ar">مُفْرَدٌ مُذَكَّرٌ مُخَاطَبٌ</span><span class="rule-table-ru">собеседник, мужской род, ед. число</span></td><td><span class="rule-table-ar">ضَمِيرُ الْمُخَاطَبِ</span><span class="rule-table-ru">местоимение собеседника</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتِ</span><span class="rule-table-ru">ты ушла</span></td><td><span class="rule-table-ar">مُفْرَدٌ مُؤَنَّثٌ مُخَاطَبٌ</span><span class="rule-table-ru">собеседница, женский род, ед. число</span></td><td><span class="rule-table-ar">ضَمِيرُ الْمُخَاطَبَةِ</span><span class="rule-table-ru">местоимение собеседницы</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar ar-tone-verb">ذَهَبَ</span><span class="rule-table-ru">он ушёл</span></td><td><span class="rule-table-ar">لِلْمُفْرَدِ الْمُذَكَّرِ الْغَائِبِ</span><span class="rule-table-ru">отсутствующий мужчина, ед. число</span></td><td><span class="rule-table-ar">ضَمِيرُ الْغَائِبِ</span><span class="rule-table-ru">местоимение отсутствующего</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar ar-tone-verb">ذَهَبَتْ</span><span class="rule-table-ru">она ушла</span></td><td><span class="rule-table-ar">لِلْمُفْرَدِ الْمُؤَنَّثِ الْغَائِبَةِ</span><span class="rule-table-ru">отсутствующая женщина, ед. число</span></td><td><span class="rule-table-ar">ضَمِيرُ الْغَائِبَةِ</span><span class="rule-table-ru">местоимение отсутствующей</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar ar-tone-verb">ذَهَبْنَا</span><span class="rule-table-ru">мы ушли</span></td><td><span class="rule-table-ar">جَمْعُ الْمُتَكَلِّمِ مَعَ غَيْرِهِ</span><span class="rule-table-ru">говорящий вместе с другими</span></td><td><span class="rule-table-ar">ضَمِيرُ الْمُتَكَلِّمِينَ</span><span class="rule-table-ru">местоимение говорящих</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتُمْ</span><span class="rule-table-ru">вы ушли</span></td><td><span class="rule-table-ar">جَمْعُ مُذَكَّرٍ مُخَاطَبٍ</span><span class="rule-table-ru">собеседники, мужской род, мн. число</span></td><td><span class="rule-table-ar">ضَمِيرُ الْمُخَاطَبِينَ</span><span class="rule-table-ru">местоимение собеседников</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتُنَّ</span><span class="rule-table-ru">вы ушли</span></td><td><span class="rule-table-ar">جَمْعُ مُؤَنَّثٍ مُخَاطَبٍ</span><span class="rule-table-ru">собеседницы, женский род, мн. число</span></td><td><span class="rule-table-ar">ضَمِيرُ الْمُخَاطَبَاتِ</span><span class="rule-table-ru">местоимение собеседниц</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُمْ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb">ذَهَبُوا</span><span class="rule-table-ru">они ушли</span></td><td><span class="rule-table-ar">لِجَمْعِ الْمُذَكَّرِ الْغَائِبِينَ</span><span class="rule-table-ru">отсутствующие мужчины, мн. число</span></td><td><span class="rule-table-ar">ضَمِيرُ الْغَائِبِينَ</span><span class="rule-table-ru">местоимение отсутствующих мужчин</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">هُنَّ</span><span class="rule-table-ru">они, женщины</span></td><td><span class="rule-table-ar ar-tone-verb">ذَهَبْنَ</span><span class="rule-table-ru">они ушли</span></td><td><span class="rule-table-ar">لِجَمْعِ الْمُؤَنَّثِ الْغَائِبَاتِ</span><span class="rule-table-ru">отсутствующие женщины, мн. число</span></td><td><span class="rule-table-ar">ضَمِيرُ الْغَائِبَاتِ</span><span class="rule-table-ru">местоимение отсутствующих женщин</span></td></tr></tbody></table></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Podrobny_Sharkh_2_tom.pdf',
    $$الدرس الرابع
الفعل الماضي
إسناد الفعل الماضي إلى الضمائر العشرة (الفعل: ذهب)
أنا ذهبتُ | مفرد المتكلم | أنا: ضمير المتكلم
أنتَ ذهبتَ | مفرد مذكر المخاطب | أنت: ضمير المخاطب
أنتِ ذهبتِ | مفرد مؤنث المخاطبة | أنت: ضمير المخاطبة
هو ذهبَ | للمفرد المذكر الغائب | هو: ضمير الغائب
هي ذهبتْ | للمفرد المؤنث الغائبة | هي: ضمير الغائبة
نحن ذهبنا | جمع المتكلم مع غيره | نحن: ضمير المتكلمين
أنتم ذهبتم | جمع مذكر المخاطبين | أنتم: ضمير المخاطبين
أنتن ذهبتن | جمع مؤنث المخاطبات | أنتن: ضمير المخاطبات
هم ذهبوا | لجمع المذكر الغائبين | هم: ضمير الغائبين
هن ذهبن | لجمع المؤنث الغائبات | هن: ضمير الغائبات$$,
    15,
    15,
    1
  );

  -- 2. The source-specific answer to a negative question containing ما.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '4'
    and sort_order = 2;

  update public.rules
  set
    title = 'جَوَابُ السُّؤَالِ الْمَنْفِيِّ بِـمَا (ответ на отрицательный вопрос с مَا)',
    rule_ar = 'إِذَا وَقَعَتْ «مَا» النَّافِيَةُ بَعْدَ هَمْزَةِ الِاسْتِفْهَامِ، أُجِيبَ بِـ«بَلَى» فِي الْإِثْبَاتِ، وَبِـ«نَعَمْ» فِي النَّفْيِ.',
    summary = 'إِذَا وَقَعَتْ «مَا» النَّافِيَةُ بَعْدَ هَمْزَةِ الِاسْتِفْهَامِ، أُجِيبَ بِـ«بَلَى» فِي الْإِثْبَاتِ، وَبِـ«نَعَمْ» فِي النَّفْيِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا وَقَعَتْ <span class="ar-tone-particle">«مَا» النَّافِيَةُ</span> بَعْدَ هَمْزَةِ الِاسْتِفْهَامِ، أُجِيبَ بِـ<span class="ar-tone-particle">«بَلَى»</span> فِي الْإِثْبَاتِ، وَبِـ<span class="ar-tone-particle">«نَعَمْ»</span> فِي النَّفْيِ.</span><p class="rule-study-text">В отрицательном вопросе вида <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَ + مَا</span> ответ <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">بَلَى</span> утверждает действие, а <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">نَعَمْ</span> подтверждает, что действия не было.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Вопрос и два ответа</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَمَا</span> <span class="ar-tone-verb">ذَهَبْتَ</span> إِلَى السُّوقِ الْيَوْمَ؟</span><span class="rule-example-ru">Разве ты не ходил сегодня на рынок?</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">بَلَى</span>، <span class="ar-tone-verb">ذَهَبْتُ</span>.</span><span class="rule-example-ru">Напротив, ходил. Это утверждение действия.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">نَعَمْ</span>، <span class="ar-tone-particle">مَا</span> <span class="ar-tone-verb">ذَهَبْتُ</span>.</span><span class="rule-example-ru">Да, верно: не ходил. Это подтверждение отрицания.</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Podrobny_Sharkh_2_tom.pdf',
    $$فائدة:
إذا وقعت "ما" النافية بعد الاستفهام،
نحو: أما ذهبت إلى السوق اليوم؟
نقول في الجواب:
بلى. ذهبت (بمعنى نعم) وذلك في الإثبات.
نعم. ما ذهبت (بمعنى لا) وذلك في النفي.$$,
    15,
    15,
    1
  );

  -- 3. لأن, its composition, causal meaning, and the complete source i'rab.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '4'
    and sort_order = 3;

  update public.rules
  set
    title = 'لِأَنَّ وَلَامُ التَّعْلِيلِ (لِأَنَّ и лям причины)',
    rule_ar = 'لِأَنَّ مُرَكَّبَةٌ مِنْ لَامِ التَّعْلِيلِ وَ«أَنَّ». وَاللَّامُ حَرْفُ جَرٍّ، وَ«أَنَّ» حَرْفُ نَصْبٍ؛ يَكُونُ اسْمُهَا مَنْصُوبًا وَخَبَرُهَا مَرْفُوعًا، وَتَكُونُ «أَنَّ وَاسْمُهَا وَخَبَرُهَا» فِي مَحَلِّ جَرٍّ.',
    summary = 'لِأَنَّ مُرَكَّبَةٌ مِنْ لَامِ التَّعْلِيلِ وَ«أَنَّ». وَاللَّامُ حَرْفُ جَرٍّ، وَ«أَنَّ» حَرْفُ نَصْبٍ؛ يَكُونُ اسْمُهَا مَنْصُوبًا وَخَبَرُهَا مَرْفُوعًا، وَتَكُونُ «أَنَّ وَاسْمُهَا وَخَبَرُهَا» فِي مَحَلِّ جَرٍّ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Состав и смысл</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لِأَنَّ</span> = <span class="ar-tone-jarr">لِـ</span> + <span class="ar-tone-particle">أَنَّ</span>.</span><p class="rule-study-text"><span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">لَامُ التَّعْلِيلِ</span> указывает причину и является предлогом. <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَنَّ</span> ставит своё имя в винительный падеж и поднимает сказуемое.</p><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَا</span> <span class="ar-tone-verb">جَاءَ</span> الْمُدَرِّسُ <span class="ar-tone-particle">لِأَنَّهُ</span> <span class="ar-tone-raf">مَرِيضٌ</span>.</span><span class="rule-example-ru">Преподаватель не пришёл, потому что он болен. Причина отсутствия преподавателя — болезнь.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полный إِعْرَابٌ из шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">اللَّفْظُ</span><span class="rule-table-ru">элемент</span></th><th><span class="rule-table-ar">إِعْرَابُهُ</span><span class="rule-table-ru">грамматический разбор</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-jarr">لِـ</span><span class="rule-table-ru">лям причины</span></td><td><span class="rule-table-ar ar-tone-jarr">حَرْفُ جَرٍّ مَبْنِيٌّ عَلَى الْكَسْرِ لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ.</span><span class="rule-table-ru">Предлог, построенный на касре; синтаксического места не имеет.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-particle">أَنَّ</span><span class="rule-table-ru">частица «что»</span></td><td><span class="rule-table-ar ar-tone-particle">حَرْفُ نَصْبٍ مَبْنِيٌّ عَلَى الْفَتْحِ لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ.</span><span class="rule-table-ru">Частица винительного управления, построенная на фатхе; синтаксического места не имеет.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">ـهُ</span><span class="rule-table-ru">слитное «он»</span></td><td><span class="rule-table-ar ar-tone-nasb">ضَمِيرٌ مُتَّصِلٌ فِي مَحَلِّ نَصْبٍ اسْمُ أَنَّ.</span><span class="rule-table-ru">Слитное местоимение в позиции винительного падежа — имя <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَنَّ</span>.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-raf">مَرِيضٌ</span><span class="rule-table-ru">болен</span></td><td><span class="rule-table-ar ar-tone-raf">خَبَرُ أَنَّ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-table-ru">Сказуемое <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَنَّ</span> в именительном падеже; показатель — явно выраженная дамма в конце.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure">أَنَّ وَاسْمُهَا وَخَبَرُهَا</span><span class="rule-table-ru">вся конструкция</span></td><td><span class="rule-table-ar ar-tone-jarr">فِي مَحَلِّ جَرٍّ.</span><span class="rule-table-ru">Вся конструкция находится в позиции родительного падежа после лям.</span></td></tr></tbody></table></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$لأنّ = ل + أن.
(لأنّ) اللام تفيد التعليل (أي: السبب)، وهي حرف الجر.
نحو: ما جاء المدرّس لأنه مريض.
فهنا سبب غياب المدرس المرض.$$,
      15, 15, 1),
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$الإعراب:
لِ: حرف جر مبني على الكسر لا محل له من الإعراب.
أنّ: حرف نصب مبني على الفتح لا محل له من الإعراب.
ه: ضمير متصل في محل نصب اسم أن.
مريضٌ: خبر أن مرفوع وعلامة رفعه الضمة الظاهرة على آخره.
و"أن واسمها وخبرها" في محل جر.$$,
      16, 16, 2);
end;
$migration$;

commit;
