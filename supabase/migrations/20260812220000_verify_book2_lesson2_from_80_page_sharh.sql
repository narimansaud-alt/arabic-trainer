-- Verify Medina Book 2 lesson 2 against the complete 80-page Arabic sharh.
-- Sole source: Podrobny_Sharkh_2_tom.pdf, PDF pages 8-10.

begin;

do $migration$
declare
  target_rule_id bigint;
  lesson_rule_count integer;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '2';

  if lesson_rule_count not in (3, 4) then
    raise exception 'Expected 3 or 4 Book 2 lesson 2 rules, found %', lesson_rule_count;
  end if;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '2'
  );

  -- 1. Definition, government, and complete ten-form table of لَيْسَ.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '2'
    and sort_order = 1;

  update public.rules
  set
    title = 'لَيْسَ وَإِسْنَادُهَا إِلَى الضَّمَائِرِ الْعَشَرَةِ (لَيْسَ и десять форм с местоимениями)',
    rule_ar = 'لَيْسَ فِعْلٌ مَاضٍ نَاقِصٌ جَامِدٌ؛ يَلْزَمُ صُورَةَ الْمَاضِي وَلَيْسَ لَهُ مُضَارِعٌ وَلَا مُشْتَقٌّ آخَرُ. يَرْفَعُ الْمُبْتَدَأَ وَيَنْصِبُ الْخَبَرَ، فَيَجْعَلُ الْمُبْتَدَأَ اسْمًا لَهُ وَالْخَبَرَ خَبَرًا لَهُ، وَعَمَلُهُ عَكْسُ عَمَلِ إِنَّ وَأَخَوَاتِهَا.',
    summary = 'لَيْسَ فِعْلٌ مَاضٍ نَاقِصٌ جَامِدٌ؛ يَلْزَمُ صُورَةَ الْمَاضِي وَلَيْسَ لَهُ مُضَارِعٌ وَلَا مُشْتَقٌّ آخَرُ. يَرْفَعُ الْمُبْتَدَأَ وَيَنْصِبُ الْخَبَرَ، فَيَجْعَلُ الْمُبْتَدَأَ اسْمًا لَهُ وَالْخَبَرَ خَبَرًا لَهُ، وَعَمَلُهُ عَكْسُ عَمَلِ إِنَّ وَأَخَوَاتِهَا.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">لَيْسَ</span> فِعْلٌ مَاضٍ نَاقِصٌ جَامِدٌ؛ يَرْفَعُ <span class="ar-tone-raf">الْمُبْتَدَأَ</span> وَيَنْصِبُ <span class="ar-tone-nasb">الْخَبَرَ</span>.</span><p class="rule-study-text"><span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">لَيْسَ</span> — неполный неизменяемый глагол прошедшей формы: у него нет настоящего времени и других производных форм. Он действует противоположно <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">إِنَّ وَأَخَوَاتُهَا</span>: бывшее подлежащее становится именем <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">لَيْسَ</span> в именительном падеже, а бывшее сказуемое — её сказуемым в винительном падеже.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Изменение предложения</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">الْمَاءُ</span> <span class="ar-tone-predicate">بَارِدٌ</span> ← <span class="ar-tone-verb">لَيْسَ</span> <span class="ar-tone-raf">الْمَاءُ</span> <span class="ar-tone-nasb">بَارِدًا</span>.</span><span class="rule-example-ru">Вода холодная → Вода не холодная. <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">الْمَاءُ</span> — имя <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">لَيْسَ</span>; <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">بَارِدًا</span> — её сказуемое.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Десять форм</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الضَّمِيرُ</span><span class="rule-table-ru">местоимение</span></th><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример</span></th><th><span class="rule-table-ar">اسْمُ لَيْسَ</span><span class="rule-table-ru">имя لَيْسَ</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar ar-tone-verb">أَنَا لَسْتُ مُدَرِّسًا.</span><span class="rule-table-ru">Я не преподаватель.</span></td><td><span class="rule-table-ar">التَّاءُ الْمُتَحَرِّكَةُ</span><span class="rule-table-ru">подвижная ت</span></td></tr><tr><td><span class="rule-table-ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar ar-tone-verb">أَنْتَ لَسْتَ كَبِيرًا.</span><span class="rule-table-ru">Ты не большой.</span></td><td><span class="rule-table-ar">التَّاءُ الْمُتَحَرِّكَةُ</span><span class="rule-table-ru">подвижная ت</span></td></tr><tr><td><span class="rule-table-ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-verb">أَنْتِ لَسْتِ كَبِيرَةً.</span><span class="rule-table-ru">Ты не большая.</span></td><td><span class="rule-table-ar">التَّاءُ الْمُتَحَرِّكَةُ</span><span class="rule-table-ru">подвижная ت</span></td></tr><tr><td><span class="rule-table-ar">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar ar-tone-verb">حَامِدٌ لَيْسَ طَالِبًا.</span><span class="rule-table-ru">Хамид не студент.</span></td><td><span class="rule-table-ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ هُوَ</span><span class="rule-table-ru">скрытое «он»</span></td></tr><tr><td><span class="rule-table-ar">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar ar-tone-verb">آمِنَةُ لَيْسَتْ طَالِبَةً.</span><span class="rule-table-ru">Амина не студентка.</span></td><td><span class="rule-table-ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ هِيَ</span><span class="rule-table-ru">скрытое «она»; ت — показатель женского рода</span></td></tr><tr><td><span class="rule-table-ar">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar ar-tone-verb">نَحْنُ لَسْنَا طُلَّابًا.</span><span class="rule-table-ru">Мы не студенты.</span></td><td><span class="rule-table-ar">نَا الْمُتَكَلِّمِينَ</span><span class="rule-table-ru">نَا говорящих</span></td></tr><tr><td><span class="rule-table-ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb">أَنْتُمْ لَسْتُمْ جُدُدًا.</span><span class="rule-table-ru">Вы не новые.</span></td><td><span class="rule-table-ar">التَّاءُ وَالْمِيمُ لِلْجَمْعِ</span><span class="rule-table-ru">ت и показатель мужского множества م</span></td></tr><tr><td><span class="rule-table-ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar ar-tone-verb">أَنْتُنَّ لَسْتُنَّ مُجْتَهِدَاتٍ.</span><span class="rule-table-ru">Вы не усердные.</span></td><td><span class="rule-table-ar">التَّاءُ وَالنُّونُ لِلْجَمْعِ الْمُؤَنَّثِ</span><span class="rule-table-ru">ت и показатель женского множества ن</span></td></tr><tr><td><span class="rule-table-ar">هُمْ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb">الطُّلَّابُ لَيْسُوا صِغَارًا.</span><span class="rule-table-ru">Студенты не маленькие.</span></td><td><span class="rule-table-ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">واو группы; ا — отделяющий алиф</span></td></tr><tr><td><span class="rule-table-ar">هُنَّ</span><span class="rule-table-ru">они, женщины</span></td><td><span class="rule-table-ar ar-tone-verb">الطَّالِبَاتُ لَسْنَ مُتَزَوِّجَاتٍ.</span><span class="rule-table-ru">Студентки не замужем.</span></td><td><span class="rule-table-ar">نُونُ النِّسْوَةِ</span><span class="rule-table-ru">نون женщин</span></td></tr></tbody></table></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الثاني
ليس
نوعها: فعل ماض ناقص جامد، وجامد بمعنى أنه يبقى في صورة الماضي فقط وليس له مضارع أو مشتق آخر.
عمله: يرفع المبتدأ وينصب الخبر فيجعل المبتدأ اسما له والخبر خبرا له (عكس إن وأخواتها).
نحو: الماء بارد.
إذا دخل الفعل "ليس" على هذه الجملة (الماء بارد) أصبحت: ليس الماء باردا.$$,
      8, 8, 1),
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$إسناد الفعل ليس إلى الضمائر العشرة
أنا لست مدرسا/بمدرس
أنت لست كبيرا/بكبير
أنت لست كبيرة/بكبيرة
حامد (هو) ليس طالبا/بطالب
آمنة (هي) ليست طالبة/بطالبة
نحن لسنا طلابا/بطلاب
أنتم لستم جددا/بجدد
أنتن لستن مجتهدات/بمجتهدات
الطلاب (هم) ليسوا صغارا/بصغار
الطالبات (هن) لسن متزوجات/بمتزوجات$$,
      9, 9, 2);

  -- 2. Added باء with its restriction and the two kinds of شبه جملة.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '2'
    and sort_order = 2;

  update public.rules
  set
    title = 'الْبَاءُ الزَّائِدَةُ فِي خَبَرِ لَيْسَ الْمُفْرَدِ (добавочная بِـ при одиночном сказуемом لَيْسَ)',
    rule_ar = 'قَدْ تَدْخُلُ الْبَاءُ الزَّائِدَةُ عَلَى خَبَرِ لَيْسَ الْمُفْرَدِ، فَيُجَرُّ لَفْظًا وَيَبْقَى مَنْصُوبًا مَحَلًّا. وَلَا تَدْخُلُ عَلَى خَبَرِ لَيْسَ إِذَا كَانَ جُمْلَةً أَوْ شِبْهَ جُمْلَةٍ. وَشِبْهُ الْجُمْلَةِ إِمَّا جَارٌّ وَمَجْرُورٌ، وَإِمَّا ظَرْفُ زَمَانٍ أَوْ مَكَانٍ.',
    summary = 'قَدْ تَدْخُلُ الْبَاءُ الزَّائِدَةُ عَلَى خَبَرِ لَيْسَ الْمُفْرَدِ، فَيُجَرُّ لَفْظًا وَيَبْقَى مَنْصُوبًا مَحَلًّا. وَلَا تَدْخُلُ عَلَى خَبَرِ لَيْسَ إِذَا كَانَ جُمْلَةً أَوْ شِبْهَ جُمْلَةٍ. وَشِبْهُ الْجُمْلَةِ إِمَّا جَارٌّ وَمَجْرُورٌ، وَإِمَّا ظَرْفُ زَمَانٍ أَوْ مَكَانٍ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">قَدْ تَدْخُلُ <span class="ar-tone-particle">الْبَاءُ الزَّائِدَةُ</span> عَلَى خَبَرِ <span class="ar-tone-verb">لَيْسَ</span> الْمُفْرَدِ، فَيُجَرُّ <span class="ar-tone-jarr">لَفْظًا</span> وَيَبْقَى <span class="ar-tone-nasb">مَنْصُوبًا مَحَلًّا</span>.</span><p class="rule-study-text">Добавочная <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">بِـ</span> может войти к одиночному сказуемому <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">لَيْسَ</span>. Тогда слово получает касру по внешней форме, но по синтаксическому месту остаётся сказуемым <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">لَيْسَ</span> в винительном падеже.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Два разбора одной формы</span><div class="rule-example-list"><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">لَيْسَ</span> <span class="ar-tone-raf">الْمَاءُ</span> <span class="ar-tone-jarr">بِبَارِدٍ</span>.</span><span class="rule-example-ru">Вода не холодная. <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">بَارِدٍ</span> — родительный по форме из-за <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">بِـ</span>, но винительный по синтаксическому месту как сказуемое <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">لَيْسَ</span>.</span></div></div></div><div class="rule-check-card"><b>Ограничение.</b> Добавочная <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">بِـ</span> не входит к сказуемому <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">لَيْسَ</span>, если оно является предложением или <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">شِبْهَ جُمْلَةٍ</span>.</div><div class="rule-study-card"><span class="rule-card-kicker">Два вида شِبْهُ جُمْلَةٍ</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-jarr"><span class="rule-term-ar" dir="rtl" lang="ar">جَارٌّ وَمَجْرُورٌ</span><span class="rule-term-ru">предлог и имя в родительном падеже: <span class="ar-inline" dir="rtl" lang="ar">هَاشِمٌ مِنَ الْهِنْدِ</span> — Хашим из Индии</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">ظَرْفُ زَمَانٍ أَوْ مَكَانٍ</span><span class="rule-term-ru">обстоятельство времени или места: <span class="ar-inline" dir="rtl" lang="ar">الْقَلَمُ تَحْتَ الْمَكْتَبِ</span> — ручка под столом</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$قد تدخل الباء الزائدة (ب) على خبر ليس المفرد.
نحو: ليس الماء ببارد.
الإعراب:
ب: حرف جر زائد مبني على الكسر لا محل له من الإعراب.
بارد: مجرور بالباء (ب) وعلامة جره الكسرة الظاهرة.
بارد: خبر ليس مجرور لفظا منصوب محلا أو نقول خبر ليس منصوب وعلامة نصبه الفتحة المقدرة.
تنبيه: لا تدخل الباء الزائدة على خبر ليس إذا كان جملة أو شبه جملة.$$,
      8, 8, 1),
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$شبه جملة نوعان:
١. جار ومجرور؛ نحو: هاشم من الهند.
٢. ظرف (زمان أو مكان)، نحو: ليس القلم تحت المكتب.$$,
      9, 9, 2);

  -- 3. The source requires, rather than merely permits, fronting in this case.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '2'
    and sort_order = 3;

  update public.rules
  set
    title = 'وُجُوبُ تَقْدِيمِ خَبَرَيْ إِنَّ وَلَيْسَ (обязательное вынесение сказуемого إِنَّ и لَيْسَ)',
    rule_ar = 'يَجِبُ تَقْدِيمُ خَبَرَيْ إِنَّ وَلَيْسَ عَلَى اسْمَيْهِمَا إِذَا كَانَ اسْمَاهُمَا نَكِرَتَيْنِ، وَخَبَرَاهُمَا شِبْهَ جُمْلَةٍ.',
    summary = 'يَجِبُ تَقْدِيمُ خَبَرَيْ إِنَّ وَلَيْسَ عَلَى اسْمَيْهِمَا إِذَا كَانَ اسْمَاهُمَا نَكِرَتَيْنِ، وَخَبَرَاهُمَا شِبْهَ جُمْلَةٍ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">يَجِبُ تَقْدِيمُ خَبَرَيْ <span class="ar-tone-particle">إِنَّ</span> وَ<span class="ar-tone-verb">لَيْسَ</span> عَلَى اسْمَيْهِمَا إِذَا كَانَ اسْمَاهُمَا <span class="ar-tone-structure">نَكِرَتَيْنِ</span>، وَخَبَرَاهُمَا <span class="ar-tone-predicate">شِبْهَ جُمْلَةٍ</span>.</span><p class="rule-study-text">Сказуемое необходимо поставить перед именем у обеих конструкций, если одновременно соблюдены два условия: имя неопределённое, а сказуемое является полупредложением.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Два условия</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">الِاسْمُ نَكِرَةٌ</span><span class="rule-term-ru">имя неопределённое</span></div><div class="rule-meaning-card rule-term-predicate"><span class="rule-term-ar" dir="rtl" lang="ar">الْخَبَرُ شِبْهُ جُمْلَةٍ</span><span class="rule-term-ru">сказуемое — сочетание с предлогом либо обстоятельство времени/места</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры и исходный порядок</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">Конструкция</span></th><th><span class="rule-table-ru">Правильный порядок</span></th><th><span class="rule-table-ru">Порядок исходного именного предложения</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-particle">إِنَّ</span><span class="rule-table-ru">частица إِنَّ</span></td><td><span class="rule-table-ar"><span class="ar-tone-particle">إِنَّ</span> <span class="ar-tone-predicate">لِي</span> <span class="ar-tone-nasb">أَخًا</span>.</span><span class="rule-table-ru">Поистине, у меня есть брат.</span></td><td><span class="rule-table-ar">إِنَّ <span class="ar-tone-nasb">أَخًا</span> <span class="ar-tone-predicate">لِي</span>.</span><span class="rule-table-ru">базовый порядок для показа перестановки</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">لَيْسَ</span><span class="rule-table-ru">глагол لَيْسَ</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">لَيْسَ</span> <span class="ar-tone-predicate">لِي</span> <span class="ar-tone-raf">أَخٌ</span>.</span><span class="rule-table-ru">У меня нет брата.</span></td><td><span class="rule-table-ar">لَيْسَ <span class="ar-tone-raf">أَخٌ</span> <span class="ar-tone-predicate">لِي</span>.</span><span class="rule-table-ru">базовый порядок для показа перестановки</span></td></tr><tr><td><span class="rule-table-ar ar-tone-particle">إِنَّ</span><span class="rule-table-ru">обстоятельство места</span></td><td><span class="rule-table-ar"><span class="ar-tone-particle">إِنَّ</span> <span class="ar-tone-predicate">تَحْتَ السَّيَّارَةِ</span> <span class="ar-tone-nasb">قِطًّا</span>.</span><span class="rule-table-ru">Поистине, под машиной есть кот.</span></td><td><span class="rule-table-ar">إِنَّ <span class="ar-tone-nasb">قِطًّا</span> <span class="ar-tone-predicate">تَحْتَ السَّيَّارَةِ</span>.</span><span class="rule-table-ru">базовый порядок для показа перестановки</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">لَيْسَ</span><span class="rule-table-ru">обстоятельство места</span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">لَيْسَ</span> <span class="ar-tone-predicate">تَحْتَ السَّيَّارَةِ</span> <span class="ar-tone-raf">قِطٌّ</span>.</span><span class="rule-table-ru">Под машиной нет кота.</span></td><td><span class="rule-table-ar">لَيْسَ <span class="ar-tone-raf">قِطٌّ</span> <span class="ar-tone-predicate">تَحْتَ السَّيَّارَةِ</span>.</span><span class="rule-table-ru">базовый порядок для показа перестановки</span></td></tr></tbody></table></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Podrobny_Sharkh_2_tom.pdf',
    $$متى يجب تقديم خبري "إن" و"ليس" على اسميهما؟
إذا كان اسماهما نكرتين وخبراهما شبه جملة.
نحو:
١. إن لي أخا.
أصل الجملة: إن أخا لي.
٢. ليس لي أخ.
أصل الجملة: ليس أخ لي.
٣. إن تحت السيارة قطا.
أصل الجملة: إن قطا تحت السيارة.
٤. ليس تحت السيارة قط.
أصل الجملة: ليس قط تحت السيارة.$$,
    9,
    10,
    1
  );

  -- 4. Source-backed note about ابن between two proper names.
  select id into target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '2'
    and sort_order = 4;

  if target_rule_id is null then
    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values
      (
        'Мединский курс (Том 2)',
        '2',
        'حَذْفُ هَمْزَةِ ابْنٍ بَيْنَ عَلَمَيْنِ (удаление хамзы в ابْنٌ между двумя именами)',
        '',
        4,
        'rule',
        '',
        ''
      )
    returning id into target_rule_id;
  end if;

  update public.rules
  set
    title = 'حَذْفُ هَمْزَةِ ابْنٍ بَيْنَ عَلَمَيْنِ (удаление хамзы в ابْنٌ между двумя именами)',
    rule_ar = 'إِذَا وَقَعَتْ كَلِمَةُ ابْنٍ بَيْنَ عَلَمَيْنِ، وَكَانَ الثَّانِي أَبًا لِلْأَوَّلِ، حُذِفَتْ هَمْزَةُ الْوَصْلِ مِنْهَا كِتَابَةً وَقِرَاءَةً، وَحُذِفَ تَنْوِينُ الْعَلَمِ الْأَوَّلِ فِي الْقِرَاءَةِ تَخْفِيفًا، وَكَانَتْ بْنُ نَعْتًا لِلْعَلَمِ الْأَوَّلِ.',
    summary = 'إِذَا وَقَعَتْ كَلِمَةُ ابْنٍ بَيْنَ عَلَمَيْنِ، وَكَانَ الثَّانِي أَبًا لِلْأَوَّلِ، حُذِفَتْ هَمْزَةُ الْوَصْلِ مِنْهَا كِتَابَةً وَقِرَاءَةً، وَحُذِفَ تَنْوِينُ الْعَلَمِ الْأَوَّلِ فِي الْقِرَاءَةِ تَخْفِيفًا، وَكَانَتْ بْنُ نَعْتًا لِلْعَلَمِ الْأَوَّلِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا وَقَعَتْ كَلِمَةُ <span class="ar-tone-structure">ابْنٍ</span> بَيْنَ عَلَمَيْنِ، وَكَانَ الثَّانِي أَبًا لِلْأَوَّلِ، حُذِفَتْ هَمْزَةُ الْوَصْلِ مِنْهَا: <span class="ar-tone-structure">ابْنٌ ← بْنُ</span>.</span><p class="rule-study-text">Условие шарха: слово «сын» стоит между двумя именами собственными, и второе имя принадлежит отцу первого человека. Тогда соединительная хамза опускается на письме и при чтении; танвин первого имени при чтении также снимается для облегчения.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Пример</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">اسْمِي <span class="ar-tone-subject">بِلَالُ</span> <span class="ar-tone-structure">بْنُ</span> <span class="ar-tone-jarr">حَامِدٍ</span>.</span><span class="rule-example-ru">Меня зовут Биляль, сын Хамида. <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">بْنُ</span> — определение (<span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">نَعْتٌ</span>) к первому имени.</span></div></div></div><div class="rule-check-card"><b>Сравните.</b> В обычной отдельной форме: <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">ابْنٌ</span>. Между двумя именами при указанных условиях: <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">بْنُ</span>.</div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Podrobny_Sharkh_2_tom.pdf',
    $$فائدة:
اسمي بلال ابن حامد.
في القراءة، نقول: اسمي بلال بن حامد، يحذف التنوين تخفيفا من (بلال) وتحذف همزة الوصل من (ابن ← بن)، فنقرأها كما كتبت لأن (ابن) وقع بين علمين، ووقع نعتا لأولهما (بلال).$$,
    10,
    10,
    1
  );
end;
$migration$;

commit;
