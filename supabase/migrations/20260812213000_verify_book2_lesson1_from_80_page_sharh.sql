-- Verify Medina Book 2 lesson 1 against the complete 80-page Arabic sharh.
-- Sole source: Podrobny_Sharkh_2_tom.pdf, PDF pages 2-7.

begin;

do $migration$
declare
  target_rule_id bigint;
  lesson_rule_count integer;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '1';

  if lesson_rule_count <> 5 then
    raise exception 'Expected 5 existing Book 2 lesson 1 rules, found %', lesson_rule_count;
  end if;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '1'
  );

  -- 1. Preserve the existing card identity and complete the source-backed rule.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '1'
    and sort_order = 1;

  update public.rules
  set
    title = 'إِنَّ وَأَخَوَاتُهَا (إِنَّ и её сёстры)',
    rule_ar = 'إِنَّ وَأَخَوَاتُهَا حُرُوفٌ تَدْخُلُ عَلَى الْجُمْلَةِ الِاسْمِيَّةِ فَقَطْ، فَتَنْصِبُ الْمُبْتَدَأَ وَتَرْفَعُ الْخَبَرَ، وَتَجْعَلُ الْمُبْتَدَأَ اسْمًا لَهَا وَالْخَبَرَ خَبَرًا لَهَا. وَهِيَ: إِنَّ، وَأَنَّ، وَلَكِنَّ، وَكَأَنَّ، وَلَعَلَّ، وَلَيْتَ.',
    summary = 'إِنَّ وَأَخَوَاتُهَا حُرُوفٌ تَدْخُلُ عَلَى الْجُمْلَةِ الِاسْمِيَّةِ فَقَطْ، فَتَنْصِبُ الْمُبْتَدَأَ وَتَرْفَعُ الْخَبَرَ، وَتَجْعَلُ الْمُبْتَدَأَ اسْمًا لَهَا وَالْخَبَرَ خَبَرًا لَهَا. وَهِيَ: إِنَّ، وَأَنَّ، وَلَكِنَّ، وَكَأَنَّ، وَلَعَلَّ، وَلَيْتَ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">إِنَّ وَأَخَوَاتُهَا</span> حُرُوفٌ تَدْخُلُ عَلَى الْجُمْلَةِ الِاسْمِيَّةِ فَقَطْ، فَتَنْصِبُ <span class="ar-tone-nasb">الْمُبْتَدَأَ</span> وَتَرْفَعُ <span class="ar-tone-raf">الْخَبَرَ</span>، وَتَجْعَلُ الْمُبْتَدَأَ اسْمًا لَهَا وَالْخَبَرَ خَبَرًا لَهَا.</span><p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">إِنَّ وَأَخَوَاتُهَا</span> входят только в именное предложение. Бывшее <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">مُبْتَدَأٌ</span> становится их именем и получает <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">نَصْبٌ</span>; бывший <span class="ar-inline ar-tone-predicate" dir="rtl" lang="ar">خَبَرٌ</span> становится их сказуемым и остаётся в <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">رَفْعٌ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Частицы и их смысл</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">إِنَّ</span><span class="rule-term-ru">«поистине, воистину» — усиление утверждения; <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">حَرْفُ تَوْكِيدٍ وَنَصْبٍ</span>.</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">أَنَّ</span><span class="rule-term-ru">«что» — усилительная частица, ставящая имя в винительный падеж.</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">لَكِنَّ</span><span class="rule-term-ru">«но, однако» — <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">حَرْفُ اسْتِدْرَاكٍ</span>, частица противопоставления.</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">كَأَنَّ</span><span class="rule-term-ru">«как будто, словно» — уподобление или предположение: <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">تَشْبِيهٌ وَظَنٌّ</span>.</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">لَعَلَّ</span><span class="rule-term-ru">«возможно; надеюсь» — надежда или опасение: <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">تَرَجٍّ وَإِشْفَاقٌ</span>.</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">لَيْتَ</span><span class="rule-term-ru">«о если бы; хотелось бы» — пожелание: <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">تَمَنٍّ</span>.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Падежи в примере</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">إِنَّ</span> <span class="ar-tone-nasb">الْمَاءَ</span> <span class="ar-tone-raf">بَارِدٌ</span>.</span><span class="rule-example-ru">Поистине, вода холодная. <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">الْمَاءَ</span> — имя <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">إِنَّ</span> в винительном падеже; <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">بَارِدٌ</span> — её сказуемое в именительном падеже.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры сестёр إِنَّ</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">سَمِعْتُ <span class="ar-tone-particle">أَنَّ</span> <span class="ar-tone-nasb">الْمُدَرِّسَ</span> <span class="ar-tone-raf">مَرِيضٌ</span>.</span><span class="rule-example-ru">Я услышал, что преподаватель болен.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">السَّيَّارَةُ قَدِيمَةٌ، <span class="ar-tone-particle">لَكِنَّهَا</span> <span class="ar-tone-raf">قَوِيَّةٌ</span>.</span><span class="rule-example-ru">Машина старая, но она крепкая.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">كَأَنَّ</span> <span class="ar-tone-nasb">الْمَسْجِدَ</span> <span class="ar-tone-raf">مَدْرَسَةٌ</span>.</span><span class="rule-example-ru">Мечеть словно школа.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَعَلَّ</span> <span class="ar-tone-nasb">الِاخْتِبَارَ</span> <span class="ar-tone-raf">سَهْلٌ</span>.</span><span class="rule-example-ru">Надеюсь, экзамен лёгкий.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَيْتَ</span> <span class="ar-tone-nasb">مُحَمَّدًا</span> <span class="ar-tone-raf">طَبِيبٌ</span>.</span><span class="rule-example-ru">Хотелось бы, чтобы Мухаммад был врачом.</span></div></div></div><div class="rule-check-card"><b>Проверьте окончание.</b> После частицы её имя должно быть в <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">نَصْبٍ</span>, а сказуемое — в <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">رَفْعٍ</span>: <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">إِنَّ</span> <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">الطَّالِبَ</span> <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">مُجْتَهِدٌ</span>.</div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$إن
نوعها: حرف توكيد ونصب.
عملها: تنصب المبتدأ وترفع الخبر فتجعل المبتدأ اسما لها والخبر خبرا لها.
نحو: الماء بارد.
إذا دخلت "إن" على هذه الجملة (الماء بارد) أصبحت: إن الماء بارد.
تنبيه: "إن" وأخواتها تدخل على الجملة الاسمية فقط.$$,
      2, 2, 1),
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$أخوات إن
أخوات "إن" كذلك تنصب المبتدأ وترفع الخبر.
أخواتها: أن، لكن، كأن، لعل، وليت.$$,
      3, 3, 2),
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$١. أن: حرف توكيد ونصب.
نحو: سمعت أن المدرس مريض.

٢. لكن: حرف استدراك.
نحو: السيارة قديمة لكنها قوية.
تنبيه: لكن تكتب هكذا (لكن)، ولكن تنطق هكذا (لاكن).$$,
      3, 3, 3),
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$٣. كأن: حرف تشبيه وظن.
نحو: كأنه مدرس جديد.
تنبيه: هنا كأن بمعنى الظن (أظنه مدرسا جديدا).
نحو: كأن المسجد مدرسة.
تنبيه: هنا كأن بمعنى التشبيه.$$,
      4, 4, 4),
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$٤. لعل: حرف ترجي وإشفاق.
نحو: لعل الاختبار سهل.
تنبيه: هنا لعل بمعنى الترجي.
ونحو: لعل الاختبار صعب.
تنبيه: هنا لعل بمعنى الإشفاق.

٥. ليت: حرف تمن ونصب.
نحو: ليت محمدا طبيب.$$,
      4, 5, 5);

  -- 2. Replace the unrelated ordering with the source's missing hamza rule.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '1'
    and sort_order = 2;

  update public.rules
  set
    title = 'مَوَاضِعُ كَسْرِ هَمْزَةِ إِنَّ (случаи касры у хамзы إِنَّ)',
    rule_ar = 'تُكْسَرُ هَمْزَةُ إِنَّ إِذَا وَقَعَتْ فِي أَوَّلِ الْكَلَامِ، أَوْ بَعْدَ الْفِعْلِ قَالَ وَمُضَارِعِهِ وَالْأَمْرِ مِنْهُ.',
    summary = 'تُكْسَرُ هَمْزَةُ إِنَّ إِذَا وَقَعَتْ فِي أَوَّلِ الْكَلَامِ، أَوْ بَعْدَ الْفِعْلِ قَالَ وَمُضَارِعِهِ وَالْأَمْرِ مِنْهُ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">تُكْسَرُ هَمْزَةُ <span class="ar-tone-particle">إِنَّ</span> إِذَا وَقَعَتْ فِي أَوَّلِ الْكَلَامِ، أَوْ بَعْدَ الْفِعْلِ <span class="ar-tone-verb">قَالَ</span> وَمُضَارِعِهِ وَالْأَمْرِ مِنْهُ.</span><p class="rule-study-text">В этих двух местах пишется и произносится именно <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">إِنَّ</span> с касрой под хамзой.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Два положения</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">فِي أَوَّلِ الْكَلَامِ</span><span class="rule-term-ru">в начале высказывания</span></div><div class="rule-meaning-card rule-term-verb"><span class="rule-term-ar" dir="rtl" lang="ar">بَعْدَ قَالَ وَمُضَارِعِهِ وَالْأَمْرِ مِنْهُ</span><span class="rule-term-ru">после <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">قَالَ</span>, его настоящего времени и повелительной формы</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">إِنَّ</span> <span class="ar-tone-nasb">الطَّالِبَ</span> <span class="ar-tone-raf">مَرِيضٌ</span>.</span><span class="rule-example-ru">Поистине, студент болен: частица стоит в начале речи.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">قَالَ</span> الْمُدَرِّسُ: <span class="ar-tone-particle">إِنَّ</span> <span class="ar-tone-nasb">الدَّرْسَيْنِ</span> <span class="ar-tone-raf">سَهْلَانِ</span>.</span><span class="rule-example-ru">Преподаватель сказал: «Поистине, два урока лёгкие».</span></div></div></div><div class="rule-check-card"><b>Не смешивайте две частицы.</b> Здесь правило относится к <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">إِنَّ</span> с касрой; <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَنَّ</span> с фатхой — отдельная сестра <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">إِنَّ</span>.</div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Podrobny_Sharkh_2_tom.pdf',
    $$مواضع كسر همزة "إن"
١. إذا وقعت في أول الكلام.
نحو: إن الطالب مريض.
٢. إذا وقعت بعد الفعل "قال"، ومضارعه، والأمر منه.
نحو: قال المدرس إن الدرسين سهلان.$$,
    3,
    3,
    1
  );

  -- 3. Preserve the ذُو card and add every condition explained in the source.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '1'
    and sort_order = 3;

  update public.rules
  set
    title = 'ذُو وَذَاتُ وَذَوُو وَذَوَاتُ (обладающий: формы и синтаксическая роль)',
    rule_ar = 'ذُو بِمَعْنَى صَاحِبٍ، وَهُوَ مُضَافٌ دَائِمًا. مُفْرَدُهُ الْمُذَكَّرُ ذُو، وَمُفْرَدُهُ الْمُؤَنَّثُ ذَاتُ، وَجَمْعُهُ الْمُذَكَّرُ ذَوُو، وَجَمْعُهُ الْمُؤَنَّثُ ذَوَاتُ. وَلَا تُعْرَبُ ذُو إِعْرَابَ الْأَسْمَاءِ الْخَمْسَةِ إِلَّا إِذَا كَانَتْ مُفْرَدَةً مُذَكَّرَةً. وَيَكُونُ ذُو نَعْتًا بَيْنَ مَعْرِفَتَيْنِ أَوْ نَكِرَتَيْنِ، وَخَبَرًا بَيْنَ مَعْرِفَةٍ وَنَكِرَةٍ.',
    summary = 'ذُو بِمَعْنَى صَاحِبٍ، وَهُوَ مُضَافٌ دَائِمًا. مُفْرَدُهُ الْمُذَكَّرُ ذُو، وَمُفْرَدُهُ الْمُؤَنَّثُ ذَاتُ، وَجَمْعُهُ الْمُذَكَّرُ ذَوُو، وَجَمْعُهُ الْمُؤَنَّثُ ذَوَاتُ. وَلَا تُعْرَبُ ذُو إِعْرَابَ الْأَسْمَاءِ الْخَمْسَةِ إِلَّا إِذَا كَانَتْ مُفْرَدَةً مُذَكَّرَةً. وَيَكُونُ ذُو نَعْتًا بَيْنَ مَعْرِفَتَيْنِ أَوْ نَكِرَتَيْنِ، وَخَبَرًا بَيْنَ مَعْرِفَةٍ وَنَكِرَةٍ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ذُو</span> بِمَعْنَى <span class="ar-tone-default">صَاحِبٍ</span>، وَهُوَ <span class="ar-tone-structure">مُضَافٌ</span> دَائِمًا.</span><p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">ذُو</span> означает «обладающий, владелец чего-либо» и всегда является первым членом идафы. Следующее за ним имя — <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ مَجْرُورٌ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Четыре формы</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْعَدَدُ</span><span class="rule-table-ru">число</span></th><th><span class="rule-table-ar">مُذَكَّرٌ</span><span class="rule-table-ru">мужской род</span></th><th><span class="rule-table-ar">مُؤَنَّثٌ</span><span class="rule-table-ru">женский род</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-structure">مُفْرَدٌ</span><span class="rule-table-ru">единственное</span></td><td><span class="rule-table-ar ar-tone-structure">زَيْدٌ ذُو خُلُقٍ</span><span class="rule-table-ru">Зайд обладает нравом</span></td><td><span class="rule-table-ar ar-tone-structure">آمِنَةُ ذَاتُ خُلُقٍ</span><span class="rule-table-ru">Амина обладает нравом</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure">جَمْعٌ</span><span class="rule-table-ru">множественное</span></td><td><span class="rule-table-ar ar-tone-structure">الطُّلَّابُ ذَوُو خُلُقٍ</span><span class="rule-table-ru">студенты обладают нравом</span></td><td><span class="rule-table-ar ar-tone-structure">الطَّالِبَاتُ ذَوَاتُ خُلُقٍ</span><span class="rule-table-ru">студентки обладают нравом</span></td></tr></tbody></table></div></div><div class="rule-check-card"><b>Условие пяти имён.</b> <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">ذُو</span> склоняется как одно из <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">الْأَسْمَاءِ الْخَمْسَةِ</span> только в форме единственного числа мужского рода.</div><div class="rule-study-card"><span class="rule-card-kicker">نَعْتٌ или خَبَرٌ</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا قَمِيصٌ <span class="ar-tone-subject">ذُو كُمٍّ قَصِيرٍ</span>.</span><span class="rule-example-ru">Это рубашка с коротким рукавом. Два неопределённых сочетания: <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">ذُو</span> — определение (<span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">نَعْتٌ</span>).</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا الْقَمِيصُ <span class="ar-tone-subject">ذُو الْكُمِّ الْقَصِيرِ</span> لِي.</span><span class="rule-example-ru">Эта рубашка с коротким рукавом — моя. Два определённых сочетания: <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">ذُو</span> — определение (<span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">نَعْتٌ</span>).</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا الْقَمِيصُ <span class="ar-tone-predicate">ذُو كُمٍّ قَصِيرٍ</span>.</span><span class="rule-example-ru">У этой рубашки короткий рукав. Между определённым и неопределённым сочетаниями <span class="ar-inline ar-tone-predicate" dir="rtl" lang="ar">ذُو</span> — сказуемое (<span class="ar-inline ar-tone-predicate" dir="rtl" lang="ar">خَبَرٌ</span>).</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$ذو
"ذو" من الأسماء الخمسة بمعنى "صاحب"، وهو دائما مضاف.
نحو: محمد ذو خلق بمعنى صاحب خلق.

مفرد | زيد ذو خلق | آمنة ذات خلق
جمع | الطلاب ذوو خلق | الطالبات ذوات خلق

تنبيه: "ذو" لا تعرب إعراب الأسماء الخمسة إلا إذا كانت مفردة مذكرة.$$,
      5, 5, 1),
    (target_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$"ذو" إذا وقعت بين نكرتين أو معرفتين فهي في الإعراب نعت
نحو: هذا قميص ذو كم قصير (بين نكرتين)
نحو: هذا القميص ذو الكم القصير لي (بين معرفتين)
وإذا وقعت بين المعرفة والنكرة فهي في الإعراب خبر.
نحو: هذا القميص ذو كم قصير (معرفة ونكرة).$$,
      6, 6, 2);

  -- 4. The previous unrelated الْمَنْقُوص card is replaced in place by أَمْ/أَوْ.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '1'
    and sort_order = 4;

  update public.rules
  set
    title = 'أَمْ وَأَوْ (أَمْ при выборе и أَوْ в вопросе и вне вопроса)',
    rule_ar = 'أَمْ مِنْ حُرُوفِ الْعَطْفِ، وَتُسْتَعْمَلُ فِي الِاسْتِفْهَامِ بَعْدَ هَمْزَةِ التَّعْيِينِ لِتَعْيِينِ أَحَدِ الْأَمْرَيْنِ، وَيَأْتِي الْمَسْؤُولُ عَنْهُ بَعْدَ الْهَمْزَةِ مُبَاشَرَةً. وَأَوْ حَرْفُ عَطْفٍ يُسْتَعْمَلُ فِي الِاسْتِفْهَامِ وَغَيْرِهِ.',
    summary = 'أَمْ مِنْ حُرُوفِ الْعَطْفِ، وَتُسْتَعْمَلُ فِي الِاسْتِفْهَامِ بَعْدَ هَمْزَةِ التَّعْيِينِ لِتَعْيِينِ أَحَدِ الْأَمْرَيْنِ، وَيَأْتِي الْمَسْؤُولُ عَنْهُ بَعْدَ الْهَمْزَةِ مُبَاشَرَةً. وَأَوْ حَرْفُ عَطْفٍ يُسْتَعْمَلُ فِي الِاسْتِفْهَامِ وَغَيْرِهِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَمْ</span> لِتَعْيِينِ أَحَدِ الْأَمْرَيْنِ، وَ<span class="ar-tone-particle">أَوْ</span> تُسْتَعْمَلُ فِي الِاسْتِفْهَامِ وَغَيْرِهِ.</span><p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَمْ</span> связывает два варианта в вопросе с выбором. Перед первым вариантом ставится вопросительная хамза выбора; слово, о котором спрашивают, должно идти сразу после неё. <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَوْ</span> — союз «или», употребляемый и в вопросе, и вне вопроса.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Сравнение</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">أَ … أَمْ …؟</span><span class="rule-term-ru">вопрос с обязательным выбором одного из двух вариантов</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">أَوْ</span><span class="rule-term-ru">«или» в вопросительном и невопросительном высказывании</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَ</span>مِنَ الْهِنْدِ أَنْتَ <span class="ar-tone-particle">أَمْ</span> مِنْ بَاكِسْتَانَ؟</span><span class="rule-example-ru">Ты из Индии или из Пакистана?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَلْ يَجُوزُ <span class="ar-tone-particle">أَوْ</span> لَا يَجُوزُ؟</span><span class="rule-example-ru">Разрешается или не разрешается?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">اِجْلِسْ هُنَا <span class="ar-tone-particle">أَوْ</span> هُنَاكَ.</span><span class="rule-example-ru">Сядь здесь или там.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Положение слова после хамзы</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">Форма</span></th><th><span class="rule-table-ru">Пример</span></th><th><span class="rule-table-ru">Почему</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar rule-table-valid">صَحِيحٌ</span><span class="rule-table-ru">правильно</span></td><td><span class="rule-table-ar rule-table-valid">أَطَالِبٌ أَنْتَ أَمْ أُسْتَاذٌ؟</span><span class="rule-table-ru">Ты студент или преподаватель?</span></td><td><span class="rule-table-ru">Спрашиваемое <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">طَالِبٌ</span> стоит сразу после хамзы.</span></td></tr><tr><td><span class="rule-table-ar rule-table-invalid">غَيْرُ صَحِيحٍ</span><span class="rule-table-ru">не по правилу шарха</span></td><td><span class="rule-table-ar rule-table-invalid">أَأَنْتَ طَالِبٌ أَمْ أُسْتَاذٌ؟</span><span class="rule-table-ru">порядок не соответствует приведённому правилу</span></td><td><span class="rule-table-ru">После хамзы поставлено <span class="ar-inline" dir="rtl" lang="ar">أَنْتَ</span>, а не выбираемая характеристика.</span></td></tr></tbody></table></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Podrobny_Sharkh_2_tom.pdf',
    $$أم و أو
"أم" و"أو" من حروف العطف، والفرق في استعمالهما أن:
"أم" حرف يستعمل في الاستفهام بالهمزة التي تفيد التعيين (تعيين أحد الأمرين)،
نحو: أمن الهند أنت أم من باكستان؟
و"أو" حرف يستعمل في الاستفهام هل وفي غير الاستفهام.
نحو: هل يجوز أو لا يجوز؟ (الاستفهام بهل).
نحو: اجلس هنا أو هناك. (غير الاستفهام).
تنبيه: نقول: أطالب أنت أم أستاذ؟
الاستفهام بهمزة التعيين يذكر المسؤول عنه بعد الهمزة مباشرة (طالب أو أستاذ).
ولا تقول أأنت طالب أم أستاذ؟$$,
    6,
    6,
    1
  );

  -- 5. Preserve the number card and include the source's spelling note.
  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '1'
    and sort_order = 5;

  update public.rules
  set
    title = 'مِائَةٌ وَأَلْفٌ (числа сто и тысяча)',
    rule_ar = 'مِائَةٌ وَأَلْفٌ عَدَدَانِ مُضَافَانِ يُسْتَعْمَلَانِ بِلَفْظٍ وَاحِدٍ مَعَ الْمَعْدُودِ الْمُذَكَّرِ وَالْمُؤَنَّثِ، وَمَعْدُودُهُمَا مُفْرَدٌ مَجْرُورٌ دَائِمًا.',
    summary = 'مِائَةٌ وَأَلْفٌ عَدَدَانِ مُضَافَانِ يُسْتَعْمَلَانِ بِلَفْظٍ وَاحِدٍ مَعَ الْمَعْدُودِ الْمُذَكَّرِ وَالْمُؤَنَّثِ، وَمَعْدُودُهُمَا مُفْرَدٌ مَجْرُورٌ دَائِمًا.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">مِائَةٌ وَأَلْفٌ</span> عَدَدَانِ مُضَافَانِ، وَمَعْدُودُهُمَا <span class="ar-tone-jarr">مُفْرَدٌ مَجْرُورٌ</span> دَائِمًا.</span><p class="rule-study-text">Числа «сто» и «тысяча» употребляются в одной форме с существительными мужского и женского рода. Считаемое слово после них всегда стоит в единственном числе и родительном падеже.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Мужской и женский род</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْعَدَدُ</span><span class="rule-table-ru">число</span></th><th><span class="rule-table-ar">مُذَكَّرٌ</span><span class="rule-table-ru">мужской род</span></th><th><span class="rule-table-ar">مُؤَنَّثٌ</span><span class="rule-table-ru">женский род</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-structure">مِائَةٌ</span><span class="rule-table-ru">сто</span></td><td><span class="rule-table-ar ar-tone-jarr">مِائَةُ رَجُلٍ</span><span class="rule-table-ru">сто мужчин</span></td><td><span class="rule-table-ar ar-tone-jarr">مِائَةُ امْرَأَةٍ</span><span class="rule-table-ru">сто женщин</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure">أَلْفٌ</span><span class="rule-table-ru">тысяча</span></td><td><span class="rule-table-ar ar-tone-jarr">أَلْفُ رَجُلٍ</span><span class="rule-table-ru">тысяча мужчин</span></td><td><span class="rule-table-ar ar-tone-jarr">أَلْفُ امْرَأَةٍ</span><span class="rule-table-ru">тысяча женщин</span></td></tr></tbody></table></div></div><div class="rule-check-card"><b>Написание и чтение.</b> В шархе отмечено: пишется <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">مِائَةٌ</span>, но читается без произнесения вставного алифа; автор также указывает, что в написании этого слова существует разногласие.</div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Podrobny_Sharkh_2_tom.pdf',
    $$مائة و ألف
"مائة" و"ألف" عددان مضافان ويستعملان بلفظ واحد (دون تغيير) مع المعدود المذكر والمؤنث ومعدودهما دائما مفرد مجرور.

العدد | مذكر | مؤنث
مائة | مائة رجل | مائة امرأة
ألف | ألف رجل | ألف امرأة

تنبيه: مائة تكتب هكذا (مائة)، ولكن تقرأ هكذا (مئة).
لكن الأمر هذا فيه خلاف.$$,
    7,
    7,
    1
  );
end;
$migration$;

commit;
