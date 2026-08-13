-- Verify Medina Book 2 lesson 18 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 43-44.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 37.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
  rule_4_id bigint;
  rule_5_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '18';

  if lesson_rule_count <> 5 then
    raise exception 'Expected 5 Book 2 lesson 18 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '18' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '18' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '18' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '18' and sort_order = 4;
  select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '18' and sort_order = 5;

  delete from public.rule_sections
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);

  -- 1. Definition, all five forms, full raf and nasb tables, and signs.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'الْأَفْعَالُ الْخَمْسَةُ وَإِعْرَابُهَا (пять форм настоящего времени и их изменение)',
    rule_ar = 'الْأَفْعَالُ الْخَمْسَةُ هِيَ كُلُّ فِعْلٍ مُضَارِعٍ اتَّصَلَتْ بِهِ وَاوُ الْجَمَاعَةِ، أَوْ أَلِفُ الِاثْنَيْنِ، أَوْ يَاءُ الْمُخَاطَبَةِ؛ وَعَلَامَةُ رَفْعِهَا ثُبُوتُ النُّونِ، وَعَلَامَةُ نَصْبِهَا وَجَزْمِهَا حَذْفُ النُّونِ.',
    summary = 'Определение пяти форм настоящего времени, их пять моделей, полные таблицы раф‘ и насба и признаки трёх состояний.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Определение из двух шархов</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الْأَفْعَالُ الْخَمْسَةُ</span> هِيَ كُلُّ <span class="ar-tone-verb">فِعْلٍ مُضَارِعٍ</span> اتَّصَلَتْ بِهِ <span class="ar-tone-subject">وَاوُ الْجَمَاعَةِ</span>، أَوْ <span class="ar-tone-subject">أَلِفُ الِاثْنَيْنِ</span>، أَوْ <span class="ar-tone-subject">يَاءُ الْمُخَاطَبَةِ</span>.</span>
        <p class="rule-study-text">К пяти формам относится каждый глагол настоящего времени, к которому присоединена вау мужского множественного числа, алиф двойственного числа или йа обращения к женщине.</p>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">يَدْرُسُونَ</span><span class="rule-term-ru">они, мужчины, учатся</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">تَدْرُسُونَ</span><span class="rule-term-ru">вы, мужчины, учитесь</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">يَدْرُسَانِ</span><span class="rule-term-ru">они двое, мужчины, учатся</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">تَدْرُسَانِ</span><span class="rule-term-ru">вы двое учитесь / они две женщины учатся</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">تَدْرُسِينَ</span><span class="rule-term-ru">ты, женщина, учишься</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Признаки إِعْرَاب</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ: ثُبُوتُ النُّونِ</span><span class="rule-term-ru">раф‘: нун сохраняется</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ: حَذْفُ النُّونِ</span><span class="rule-term-ru">насб: нун удаляется</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">الْجَزْمُ: حَذْفُ النُّونِ</span><span class="rule-term-ru">джазм: нун удаляется</span></div>
        </div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مَاذَا <span class="ar-tone-raf">تُرِيدُونَ</span> أَنْ <span class="ar-tone-nasb">تَشْتَرُوا</span>؟</span><span class="rule-example-ru">Что вы хотите купить? В первой форме нун сохранён, после частицы насба — удалён.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا هِنْدُ، لَنْ <span class="ar-tone-nasb">تَخْرُجِي</span>.</span><span class="rule-example-ru">О Хинд, ты не выйдешь. У формы обращения к женщине нун удалён.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полная таблица форм в раф‘</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Форма</th><th>Полный арабский разбор</th><th>Исполнитель и русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">تَفْعَلِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ ثُبُوتُ النُّونِ.</span><span class="rule-table-ru">Глагол настоящего времени в раф‘; признак — сохранение нуна.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span><span class="rule-table-ru">ты, женщина, делаешь</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">تَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ ثُبُوتُ النُّونِ.</span><span class="rule-table-ru">Глагол настоящего времени в раф‘; признак — сохранение нуна.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span><span class="rule-table-ru">вы двое делаете / они две женщины делают</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">يَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ ثُبُوتُ النُّونِ.</span><span class="rule-table-ru">Глагол настоящего времени в раф‘; признак — сохранение нуна.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span><span class="rule-table-ru">они двое, мужчины, делают</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">تَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ ثُبُوتُ النُّونِ.</span><span class="rule-table-ru">Глагол настоящего времени в раф‘; признак — сохранение нуна.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">вы, мужчины, делаете</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">يَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ ثُبُوتُ النُّونِ.</span><span class="rule-table-ru">Глагол настоящего времени в раф‘; признак — сохранение нуна.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">они, мужчины, делают</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полная таблица форм в насбе</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Форма</th><th>Полный арабский разбор</th><th>Исполнитель и русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">يَجِبُ أَنْ تَفْعَلِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ حَذْفُ النُّونِ.</span><span class="rule-table-ru">Глагол настоящего времени в насбе; признак — удаление нуна.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span><span class="rule-table-ru">тебе, женщине, нужно сделать</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">يَجِبُ أَنْ تَفْعَلَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ حَذْفُ النُّونِ.</span><span class="rule-table-ru">Глагол настоящего времени в насбе; признак — удаление нуна.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span><span class="rule-table-ru">вам двоим / им двум женщинам нужно сделать</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">يَجِبُ أَنْ يَفْعَلَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ حَذْفُ النُّونِ.</span><span class="rule-table-ru">Глагол настоящего времени в насбе; признак — удаление нуна.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span><span class="rule-table-ru">им двоим, мужчинам, нужно сделать</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">يَجِبُ أَنْ تَفْعَلُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ حَذْفُ النُّونِ.</span><span class="rule-table-ru">Глагол настоящего времени в насбе; признак — удаление нуна.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">вам, мужчинам, нужно сделать</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">يَجِبُ أَنْ يَفْعَلُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ حَذْفُ النُّونِ.</span><span class="rule-table-ru">Глагол настоящего времени в насбе; признак — удаление нуна.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">им, мужчинам, нужно сделать</span></td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الثامن عشر
الأفعال الخمسة
قاعدة
الأفعال الخمسة، هي: كل فعل مضارع اتصلت به واو الجماعة، أو ألف الاثنين، أو ياء المخاطبة.
علاماتها:
علامة الرفع في الأفعال الخمسة، ثبوت النون، نحو: تفعلين، تفعلان، يفعلان، تفعلون، يفعلون.
علامة النصب في الأفعال الخمسة، حذف النون، نحو: يجب أن تكتبي الواجب.
المضارع المرفوع
تفعلين | فعل مضارع مرفوع وعلامة رفعه ثبوت النون | ياء المخاطبة
تفعلان | فعل مضارع مرفوع وعلامة رفعه ثبوت النون | ألف الاثنين
يفعلان | فعل مضارع مرفوع وعلامة رفعه ثبوت النون | ألف الاثنين
تفعلون | فعل مضارع مرفوع وعلامة رفعه ثبوت النون | واو الجماعة
يفعلون | فعل مضارع مرفوع وعلامة رفعه ثبوت النون | واو الجماعة
المضارع المنصوب
يجب أن تفعلي | فعل مضارع منصوب وعلامة نصبه حذف النون | ياء المخاطبة
يجب أن تفعلا | فعل مضارع منصوب وعلامة نصبه حذف النون | ألف الاثنين
يجب أن يفعلا | فعل مضارع منصوب وعلامة نصبه حذف النون | ألف الاثنين
يجب أن تفعلوا | فعل مضارع منصوب وعلامة نصبه حذف النون | واو الجماعة
يجب أن يفعلوا | فعل مضارع منصوب وعلامة نصبه حذف النون | واو الجماعة$$,
      43, 43, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$حَذْفُ النُّونِ مِنَ الْأَفْعَالِ الْخَمْسَةِ لِلنَّصْبِ
سَبَقَتْ دِرَاسَتُهُمَا فِي الدَّرْسِ السَّابِعَ عَشَرَ، وَسَأَذْكُرُ هُنَا أَمْثِلَةً لَهُمَا.
حَذْفُ النُّونِ مِنَ الْأَفْعَالِ الْخَمْسَةِ لِلنَّصْبِ: مَاذَا تُرِيدُونَ أَنْ تَشْتَرُوا؟ يَا هِنْدُ لَنْ تَخْرُجِي.
الْأَفْعَالُ الْخَمْسَةُ، هِيَ: كُلُّ فِعْلٍ مُضَارِعٍ اتَّصَلَتْ بِهِ وَاوُ الْجَمَاعَةِ، أَوْ أَلِفُ الِاثْنَيْنِ، أَوْ يَاءُ الْمُخَاطَبَةِ.
وَتَكُونُ خَمْسَةً، كَالتَّالِي:
١- الْغَائِبُ: يَدْرُسُونَ.
٢- الْمُخَاطَبُ: تَدْرُسُونَ.
٣- الْغَائِبُ: يَدْرُسَانِ.
٤- الْمُخَاطَبُ: تَدْرُسَانِ.
٥- الْمُخَاطَبَةُ: تَدْرُسِينَ.
الْأَفْعَالُ الْخَمْسَةُ: عَلَامَةُ الرَّفْعِ ثُبُوتُ النُّونِ، وَعَلَامَةُ النَّصْبِ وَالْجَزْمِ حَذْفُ النُّونِ.$$,
      37, 37, 2);

  -- 2. The separating alif after waw al-jama'ah.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'note',
    title = 'الْأَلِفُ الْفَارِقَةُ بَعْدَ وَاوِ الْجَمَاعَةِ (разделительный алиф после вау множественного числа)',
    rule_ar = 'فِي «تَفْعَلُونَ» وَ«يَفْعَلُونَ»، إِذَا حُذِفَتِ النُّونُ بَعْدَ دُخُولِ «أَنْ» أُتِيَ بِالْأَلِفِ الْفَارِقَةِ بَعْدَ وَاوِ الْجَمَاعَةِ، وَكَذَلِكَ يُؤْتَى بِهَا فِي الْفِعْلِ الْمَاضِي وَفِعْلِ الْأَمْرِ.',
    summary = 'Замечание подробного шарха о написании разделительного алифа после вау множественного числа в насбе, прошедшем времени и повелительной форме.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">تَنْبِيهٌ — примечание</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">فِي <span class="ar-tone-raf">«تَفْعَلُونَ» وَ«يَفْعَلُونَ»</span>، إِذَا حُذِفَتِ النُّونُ بَعْدَ دُخُولِ <span class="ar-tone-particle">«أَنْ»</span> أُتِيَ بِـ<span class="ar-tone-structure">الْأَلِفِ الْفَارِقَةِ</span> بَعْدَ <span class="ar-tone-subject">وَاوِ الْجَمَاعَةِ</span>.</span>
        <p class="rule-study-text">Когда у форм с вау множественного числа после частицы <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَنْ</span> удаляется нун, после вау пишется разделительный алиф.</p>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">تَفْعَلُونَ</span> ← <span class="ar-tone-nasb">أَنْ تَفْعَلُوا</span></span><span class="rule-term-ru">вы делаете → чтобы вы сделали</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">يَفْعَلُونَ</span> ← <span class="ar-tone-nasb">أَنْ يَفْعَلُوا</span></span><span class="rule-term-ru">они делают → чтобы они сделали</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">فَعَلُوا</span><span class="rule-term-ru">они сделали — прошедшее время</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">اِفْعَلُوا</span><span class="rule-term-ru">сделайте — повелительная форма</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$تنبيه: في (تفعلون) و(يفعلون)، إذا حذفت النون بعد دخول (أن)، أتينا بالألف الفارقة بعد الواو، كما ترى في الجدول السابق. وكذلك يؤتى بالألف في الفعل الماضي، نحو: فعلوا، والأمر، نحو: افعلوا.$$,
      44, 44, 1);

  -- 3. Nun an-niswah and the difference between mu'rab and mabni.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'نُونُ النِّسْوَةِ مَعَ الْفِعْلِ الْمُضَارِعِ (нун женского множественного числа с настоящим временем)',
    rule_ar = 'الْفِعْلُ الْمُضَارِعُ مُعْرَبٌ، فَإِذَا اتَّصَلَتْ بِهِ نُونُ النِّسْوَةِ صَارَ مَبْنِيًّا عَلَى السُّكُونِ فِي الرَّفْعِ وَالنَّصْبِ وَالْجَزْمِ، فَيَبْقَى آخِرُهُ عَلَى السُّكُونِ وَلَا يَتَغَيَّرُ.',
    summary = 'Форма настоящего времени с нуном женского множественного числа остаётся построенной на сукуне в раф‘, насбе и джазме; приведены все четыре примера шарха.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Почему окончание не меняется</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">الْفِعْلُ الْمُضَارِعُ</span> مُعْرَبٌ، فَإِذَا اتَّصَلَتْ بِهِ <span class="ar-tone-subject">نُونُ النِّسْوَةِ</span> صَارَ <span class="ar-tone-structure">مَبْنِيًّا عَلَى السُّكُونِ</span> فِي الرَّفْعِ وَالنَّصْبِ وَالْجَزْمِ.</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">مُعْرَبٌ</span><span class="rule-term-ru">изменяемый: окончание меняется — дамма в раф‘, фатха в насбе, сукун в джазме</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-term-ru">построенный на сукуне: окончание сохраняет сукун во всех трёх состояниях</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все состояния из второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Состояние</th><th>Арабский пример</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">раф‘</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الطَّالِبَاتُ يَدْرُسْنَ.</span></td><td>Студентки учатся.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْجَزْمُ</span><span class="rule-table-ru">джазм</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَاتُ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">يَدْرُسْنَ</span>.</span></td><td>Студентки не учились.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَاتُ <span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb">يَدْرُسْنَ</span>.</span></td><td>Студентки не будут учиться.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَجِبُ <span class="ar-tone-particle">أَنْ</span> <span class="ar-tone-verb">تَدْرُسْنَ</span>.</span></td><td>Вам, женщинам, нужно учиться.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$وَبِنَاءُ الْفِعْلِ الْمُضَارِعِ الْمُسْنَدِ إِلَى نُونِ النِّسْوَةِ
الْفِعْلُ الْمُضَارِعُ مُعْرَبٌ، وَإِذَا دَخَلَتْ عَلَيْهِ نُونُ النِّسْوَةِ صَارَ مَبْنِيًّا عَلَى السُّكُونِ فِي الرَّفْعِ، وَالْجَزْمِ، وَالنَّصْبِ: الطَّالِبَاتُ يَدْرُسْنَ. الطَّالِبَاتُ لَمْ يَدْرُسْنَ. الطَّالِبَاتُ لَنْ يَدْرُسْنَ. يَجِبُ أَنْ تَدْرُسْنَ.
مُعْرَبٌ، أَيْ: تَتَغَيَّرُ حَرَكَةُ آخِرِهِ، الضَّمَّةُ فِي الرَّفْعِ، وَالْفَتْحَةُ فِي النَّصْبِ، وَالسُّكُونُ فِي الْجَزْمِ.
مَبْنِيٌّ عَلَى السُّكُونِ: أَيْ يَبْقَى عَلَى السُّكُونِ فِي الرَّفْعِ وَالنَّصْبِ وَالْجَزْمِ (لَا يَتَغَيَّرُ).$$,
      37, 37, 1);

  -- 4. Contraction of an plus negative la.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'أَلَّا = أَنْ + لَا النَّافِيَةُ (чтобы не)',
    rule_ar = 'إِذَا دَخَلَتْ «لَا» النَّافِيَةُ عَلَى الْفِعْلِ الْمُضَارِعِ الْمَنْصُوبِ فَإِنَّ الْفِعْلَ يَبْقَى مَنْصُوبًا وَلَا يَتَغَيَّرُ، وَ«أَلَّا» أَصْلُهَا «أَنْ + لَا النَّافِيَةُ».',
    summary = 'Сочетание частицы насба «чтобы» с отрицательной «не» образует أَلَّا; отрицание не отменяет состояние насба последующего глагола.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Образование формы</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَلَّا</span> أَصْلُهَا <span class="ar-tone-particle">أَنْ + لَا النَّافِيَةُ</span>، وَيَبْقَى <span class="ar-tone-verb">الْفِعْلُ الْمُضَارِعُ</span> بَعْدَهَا مَنْصُوبًا.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَلَّا</span> означает «чтобы не». Отрицательная частица вставляется после <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَنْ</span>, поэтому последующий глагол остаётся в насбе.</p>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَرْجُو <span class="ar-tone-particle">أَنْ</span> <span class="ar-tone-nasb">تَدْخُلَ</span>.</span><span class="rule-example-ru">Прошу тебя войти.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَرْجُو <span class="ar-tone-particle">أَلَّا</span> <span class="ar-tone-nasb">تَدْخُلَ</span>.</span><span class="rule-example-ru">Прошу тебя не входить.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إِذَا دَخَلَتْ لَا النَّافِيَةُ عَلَى الْفِعْلِ الْمُضَارِعِ الْمَنْصُوبِ فَإِنَّ الْفِعْلَ يَبْقَى مَنْصُوبًا لَا يَتَغَيَّرُ، تَقُولُ: أَرْجُو أَنْ تَدْخُلَ: أَرْجُو أَلَّا تَدْخُلَ. أَلَّا: أَصْلُهَا أَنْ + لَا النَّافِيَةُ.$$,
      37, 37, 1);

  -- 5. Kaf at-tashbih with every distinct example from both sources.
  update public.rules
  set
    sort_order = 5,
    rule_kind = 'rule',
    title = 'كَافُ التَّشْبِيهِ (каф сравнения: как, подобно)',
    rule_ar = 'كَافُ التَّشْبِيهِ حَرْفُ جَرٍّ يُفِيدُ التَّشْبِيهَ وَمَعْنَاهُ «مِثْلُ»، وَيَكُونُ الِاسْمُ بَعْدَهُ مَجْرُورًا.',
    summary = 'Каф сравнения имеет значение «как, подобно» и является предлогом; собраны все неповторяющиеся примеры двух шархов.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Значение и управление</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">كَافُ التَّشْبِيهِ</span> حَرْفُ جَرٍّ يُفِيدُ التَّشْبِيهَ، وَمَعْنَاهُ <span class="ar-tone-structure">«مِثْلُ»</span>.</span>
        <p class="rule-study-text">Каф сравнения переводится «как; подобно». Как предлог, он ставит следующее имя в состояние <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">الْجَرِّ</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все неповторяющиеся примеры двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْمَسْجِدُ <span class="ar-tone-particle">كَـ</span><span class="ar-tone-jarr">الْمَدْرَسَةِ</span>.</span><span class="rule-example-ru">Мечеть подобна школе.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ الْمَدْرَسَةُ <span class="ar-tone-particle">كَـ</span><span class="ar-tone-jarr">الْمَسْجِدِ</span>.</span><span class="rule-example-ru">Эта школа подобна мечети.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتَ <span class="ar-tone-particle">كَـ</span><span class="ar-tone-jarr">الْأَسَدِ</span>.</span><span class="rule-example-ru">Ты как лев.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَاعَتِي <span class="ar-tone-particle">كَـ</span><span class="ar-tone-jarr">سَاعَتِكَ</span>.</span><span class="rule-example-ru">Мои часы похожи на твои часы.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">حَامِدٌ كَسْلَانُ <span class="ar-tone-particle">كَـ</span><span class="ar-tone-jarr">زَمِيلِهِ</span>.</span><span class="rule-example-ru">Хамид ленив, как его товарищ.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_5_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$كاف التشبيه
هي حرف جر بمعنى مثل:
نحو: المسجد كالمدرسة (مثل المدرسة).
نحو: ساعتي كساعتك.
نحو: حامد كسلان كزميله.$$,
      44, 44, 1),
    (rule_5_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$كَافُ التَّشْبِيهِ
كَافُ التَّشْبِيهِ: حَرْفُ جَرٍّ يُفِيدُ التَّشْبِيهَ.
هَذِهِ الْمَدْرَسَةُ كَالْمَسْجِدِ.
أَنْتَ كَالْأَسَدِ.
سَاعَتِي كَسَاعَتِكَ.
حَامِدٌ كَسْلَانُ كَزَمِيلِهِ.$$,
      37, 37, 2);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '18'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 18 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id)
  ) <> 7 then
    raise exception 'Expected 7 Book 2 lesson 18 source rows';
  end if;
end
$migration$;

commit;
