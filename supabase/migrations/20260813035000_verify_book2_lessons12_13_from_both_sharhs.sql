-- Verify Medina Book 2 lessons 12 and 13 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF page 32.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 26.
-- The second PDF has a damaged logical text layer. Its source_text below is a
-- literal manual transcription from the rendered page, authorized by the owner.

begin;

do $migration$
declare
  lesson_12_count integer;
  lesson_13_count integer;
  lesson_12_keep_id bigint;
  lesson_12_remove_1_id bigint;
  lesson_12_remove_2_id bigint;
  lesson_13_rule_1_id bigint;
  lesson_13_rule_2_id bigint;
begin
  select count(*) into lesson_12_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '12';

  select count(*) into lesson_13_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '13';

  if lesson_12_count not in (1, 3) then
    raise exception 'Expected 1 or 3 Book 2 lesson 12 rules, found %', lesson_12_count;
  end if;
  if lesson_13_count <> 2 then
    raise exception 'Expected 2 Book 2 lesson 13 rules, found %', lesson_13_count;
  end if;

  if lesson_12_count = 3 then
    select id into strict lesson_12_remove_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '12' and sort_order = 1;
    select id into strict lesson_12_keep_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '12' and sort_order = 2;
    select id into strict lesson_12_remove_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '12' and sort_order = 3;
  else
    select id into strict lesson_12_keep_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '12' and sort_order = 1;
  end if;

  select id into strict lesson_13_rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '13' and sort_order = 1;
  select id into strict lesson_13_rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '13' and sort_order = 2;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number in ('12', '13')
  );

  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number in ('12', '13')
  );

  if lesson_12_count = 3 then
    delete from public.rules
    where id in (lesson_12_remove_1_id, lesson_12_remove_2_id);
  end if;

  -- Lesson 12: all seven weekday names and no unsupported adverb rule.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'أَسْمَاءُ أَيَّامِ الْأُسْبُوعِ (названия дней недели)',
    rule_ar = 'أَسْمَاءُ أَيَّامِ الْأُسْبُوعِ هِيَ: يَوْمُ السَّبْتِ، وَيَوْمُ الْأَحَدِ، وَيَوْمُ الِاثْنَيْنِ، وَيَوْمُ الثُّلَاثَاءِ، وَيَوْمُ الْأَرْبِعَاءِ، وَيَوْمُ الْخَمِيسِ، وَيَوْمُ الْجُمُعَةِ.',
    summary = 'В шархе урок 12 содержит полный список семи дней недели от субботы до пятницы.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный список из шарха</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">أَسْمَاءُ أَيَّامِ الْأُسْبُوعِ هِيَ: <span class="ar-tone-structure">يَوْمُ السَّبْتِ، وَيَوْمُ الْأَحَدِ، وَيَوْمُ الِاثْنَيْنِ، وَيَوْمُ الثُّلَاثَاءِ، وَيَوْمُ الْأَرْبِعَاءِ، وَيَوْمُ الْخَمِيسِ، وَيَوْمُ الْجُمُعَةِ</span>.</span>
        <p class="rule-study-text">В арабском шархе дни недели перечислены от субботы до пятницы.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Арабское название и русский смысл</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Арабское название</th><th>Русский перевод</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَوْمُ السَّبْتِ</span></td><td>суббота</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَوْمُ الْأَحَدِ</span></td><td>воскресенье</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَوْمُ الِاثْنَيْنِ</span></td><td>понедельник</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَوْمُ الثُّلَاثَاءِ</span></td><td>вторник</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَوْمُ الْأَرْبِعَاءِ</span></td><td>среда</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَوْمُ الْخَمِيسِ</span></td><td>четверг</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَوْمُ الْجُمُعَةِ</span></td><td>пятница</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = lesson_12_keep_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (lesson_12_keep_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الثاني عشر
أسماء أيام الأسبوع
يَوْمُ السَّبْتِ
يَوْمُ الأَحَدِ
يَوْمُ الإثْنَيْنِ
يَوْمُ الثُّلَاثَاءِ
يَوْمُ الأَرْبِعَاءِ
يَوْمُ الخَمِيسِ
يَوْمُ الجُمُعَةِ$$, 32, 32, 1);

  -- Lesson 13, rule 1: kasrah of inna and fatḥah of anna.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'كَسْرُ هَمْزَةِ إِنَّ وَفَتْحُ هَمْزَةِ أَنَّ (касра у хамзы إِنَّ и фатха у хамзы أَنَّ)',
    rule_ar = 'تُكْسَرُ هَمْزَةُ «إِنَّ» فِي ابْتِدَاءِ الْكَلَامِ وَبَعْدَ فِعْلِ الْقَوْلِ «قَالَ يَقُولُ»، وَتُفْتَحُ هَمْزَةُ «أَنَّ» بَعْدَ جَمِيعِ الْأَفْعَالِ مَا عَدَا أَفْعَالَ الْقَوْلِ فِي الْأَمْثِلَةِ الْمَذْكُورَةِ؛ وَلَا تَأْتِي «أَنَّ» فِي ابْتِدَاءِ الْكَلَامِ.',
    summary = 'إِنَّ употребляется в начале речи и после قَالَ يَقُولُ; أَنَّ употребляется после остальных показанных глаголов и не начинает речь.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полное различие из шарха</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">تُكْسَرُ هَمْزَةُ <span class="ar-tone-structure">«إِنَّ»</span> فِي ابْتِدَاءِ الْكَلَامِ وَبَعْدَ فِعْلِ الْقَوْلِ <span class="ar-tone-verb">«قَالَ يَقُولُ»</span>، وَتُفْتَحُ هَمْزَةُ <span class="ar-tone-structure">«أَنَّ»</span> بَعْدَ جَمِيعِ الْأَفْعَالِ مَا عَدَا أَفْعَالَ الْقَوْلِ فِي الْأَمْثِلَةِ الْمَذْكُورَةِ.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">إِنَّ</span> с касрой у хамзы употребляется в начале речи и после глаголов «сказал/говорит». <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">أَنَّ</span> с фатхой у хамзы приводится после остальных глаголов. Шарх отмечает, что исключения у глаголов речи будут подробно изучены позднее.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Позиции</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Позиция</th><th>Форма</th><th>Русское пояснение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">فِي ابْتِدَاءِ الْكَلَامِ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">إِنَّ</span></td><td>в начале высказывания</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">بَعْدَ الْفِعْلِ قَالَ يَقُولُ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">إِنَّ</span></td><td>после глаголов «сказал/говорит»</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">بَعْدَ جَمِيعِ الْأَفْعَالِ مَا عَدَا أَفْعَالَ الْقَوْلِ</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">أَنَّ</span></td><td>после остальных глаголов в показанных примерах</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">إِنَّ в начале речи</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">إِنَّ اللَّهَ غَفُورٌ رَحِيمٌ.</span><span class="rule-example-ru">Поистине, Аллах - Прощающий, Милующий.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">إِنَّ الطَّالِبَ مُجْتَهِدٌ.</span><span class="rule-example-ru">Поистине, студент усерден.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">إِنَّ الدَّرْسَ سَهْلٌ.</span><span class="rule-example-ru">Поистине, урок лёгкий.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">إِنَّ после глагола речи</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَالَ الْمُرَاقِبُ: إِنَّ الْمُدَرِّسَ غَائِبٌ.</span><span class="rule-example-ru">Надзиратель сказал: «Преподаватель отсутствует».</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَقُولُ الْمُدَرِّسُ: إِنَّ الِاخْتِبَارَ سَهْلٌ.</span><span class="rule-example-ru">Преподаватель говорит: «Экзамен лёгкий».</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَالَ: إِنِّي مُؤْمِنٌ.</span><span class="rule-example-ru">Он сказал: «Поистине, я верующий».</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَقُولُونَ: إِنَّكَ مُسَافِرٌ.</span><span class="rule-example-ru">Они говорят: «Поистине, ты путник».</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">أَنَّ после других глаголов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ.</span><span class="rule-example-ru">Я свидетельствую, что Мухаммад - посланник Аллаха.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَمِعْتُ أَنَّ الْمُدَرِّسَ غَائِبٌ.</span><span class="rule-example-ru">Я услышал, что преподаватель отсутствует.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَظُنُّ أَنَّكَ طَبِيبٌ.</span><span class="rule-example-ru">Я думаю, что ты врач.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَعْرِفُ أَنَّنِي أَتَكَلَّمُ خَمْسَ لُغَاتٍ.</span><span class="rule-example-ru">Я знаю, что говорю на пяти языках.</span></div>
        </div>
      </div>
      <div class="rule-check-card"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">أَنَّ</span> с фатхой у хамзы не употребляется в начале речи.</div>
    </div>$$
  where id = lesson_13_rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (lesson_13_rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$كَسْرُ هَمْزَةِ إِنَّ، وَفَتْحُهَا
أَوَّلًا: تُكْسَرُ هَمْزَةُ إِنَّ في مواضعَ كثيرةٍ، نَدْرُسُ منها موضعينِ فقط:
١- في ابتداءِ الكلامِ: إِنَّ اللهَ غفورٌ رحيمٌ. إِنَّ الطالبَ مجتهدٌ. إِنَّ الدرسَ سهلٌ.
٢- بعدَ الفعلِ قالَ يقولُ: قالَ المراقبُ: إِنَّ المدرسَ غائبٌ. يقولُ المدرسُ: إِنَّ الاختبارَ سهلٌ. قالَ إِنِّي مؤمنٌ. يقولونَ إِنَّكَ مسافرٌ.
ثانيًا: تُفْتَحُ همزةُ إِنَّ (أَنَّ) في مواضعَ كثيرةٍ، ندرسُ منها موضعًا واحدًا فقط:
بعدَ جميعِ الأفعالِ ماعدا أفعالَ القولِ (فيه تفصيلٌ سندرسُهُ فيما بعدَ إن شاءَ اللهُ).
أَشْهَدُ أَنَّ محمدًا رسولُ اللهِ. سَمِعْتُ أَنَّ المدرسَ غائبٌ. أَظُنُّ أَنَّكَ طبيبٌ. أَعْرِفُ أَنَّنِي أتكلمُ خمسَ لغاتٍ.
أَنَّ (بفتح الهمزة) لا تأتي في ابتداءِ الكلامِ.$$, 26, 26, 1);

  -- Lesson 13, rule 2: explicit review of the present endings.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'مُرَاجَعَةُ إِسْنَادِ الْمُضَارِعِ إِلَى الضَّمَائِرِ (повторение спряжения المضارع)',
    rule_ar = 'تُرْفَعُ صِيَغُ الْمُضَارِعِ الْمُتَّصِلَةُ بِوَاوِ الْجَمَاعَةِ أَوْ يَاءِ الْمُخَاطَبَةِ بِثُبُوتِ النُّونِ، وَتُبْنَى الصِّيَغُ الْمُتَّصِلَةُ بِنُونِ النِّسْوَةِ عَلَى السُّكُونِ.',
    summary = 'Автор повторяет: формы с واو الجماعة и ياء المخاطبة имеют رفع посредством сохранения ن, а формы с نون النسوة построены на сукуне.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Повторение автора</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">تُرْفَعُ صِيَغُ <span class="ar-tone-verb">الْمُضَارِعِ</span> الْمُتَّصِلَةُ بِ<span class="ar-tone-subject">وَاوِ الْجَمَاعَةِ</span> أَوْ <span class="ar-tone-subject">يَاءِ الْمُخَاطَبَةِ</span> بِ<span class="ar-tone-raf">ثُبُوتِ النُّونِ</span>، وَتُبْنَى الصِّيَغُ الْمُتَّصِلَةُ بِ<span class="ar-tone-subject">نُونِ النِّسْوَةِ</span> عَلَى <span class="ar-tone-structure">السُّكُونِ</span>.</span>
        <p class="rule-study-text">Второй шарх сообщает, что подробное объяснение уже было дано в уроке 11, и повторяет эти формы кратко для пользы.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Краткая таблица повторения</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Признак</th><th>Исполнитель</th><th>Примеры</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ثُبُوتُ النُّونِ</span><span class="rule-table-ru">сохранение ن</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَدْرُسُونَ، تَدْرُسُونَ</span></td><td>они учатся; вы, мужчины, учитесь</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ثُبُوتُ النُّونِ</span><span class="rule-table-ru">сохранение ن</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَدْرُسِينَ</span></td><td>ты, женщина, учишься</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">построен на сукуне</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَدْرُسْنَ، تَدْرُسْنَ</span></td><td>они, женщины, учатся; вы, женщины, учитесь</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = lesson_13_rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (lesson_13_rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الثالث عشر
الفعل المضارع
تقدم معنا في الدرس العاشر.$$, 32, 32, 1),
    (lesson_13_rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إِسْنَادُ الفِعْلِ المُضَارِعِ إِلَى الضَّمَائِرِ
سبقتْ دراستُهُ في الدرسِ الحادي عشرَ في جدولٍ مُخَصَّصٍ لهُ، فارجعْ إليهِ زادكَ اللهُ علمًا وحرصًا. وسأعيدُ ذكرَهُ هنا إجمالًا؛ وذلك إتمامًا للفائدةِ.
ثبوتُ النونِ: واوُ الجماعةِ، يَدْرُسُونَ، تَدْرُسُونَ.
ثبوتُ النونِ: ياءُ المخاطبةِ، تَدْرُسِينَ.
مَبْنِيٌّ على السكونِ: نونُ النسوةِ، يَدْرُسْنَ، تَدْرُسْنَ.$$, 26, 26, 2);
end
$migration$;

commit;
