-- Verify Medina Book 2 lesson 23 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 53-54.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 43.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '23';

  if lesson_rule_count <> 3 then
    raise exception 'Expected 3 Book 2 lesson 23 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '23' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '23' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '23' and sort_order = 3;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id);

  -- 1. Sound masculine plural: definition, case signs, full i'rab, nun note, and all distinct examples.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'إِعْرَابُ جَمْعِ الْمُذَكَّرِ السَّالِمِ (склонение правильного мужского множественного числа)',
    rule_ar = 'جَمْعُ الْمُذَكَّرِ السَّالِمِ مَا دَلَّ عَلَى ثَلَاثَةٍ فَأَكْثَرَ بِزِيَادَةِ وَاوٍ وَنُونٍ، أَوْ يَاءٍ وَنُونٍ فِي آخِرِهِ؛ وَيُرْفَعُ بِالْوَاوِ، وَيُنْصَبُ وَيُجَرُّ بِالْيَاءِ. وَنُونُهُ مَفْتُوحَةٌ، أَمَّا نُونُ الْمُثَنَّى فَمَكْسُورَةٌ.',
    summary = 'Правильное мужское множественное обозначает троих и более и образуется добавлением вау с нуном либо йа с нуном. Оно поднимается посредством вау, а в насбе и джарре имеет показатель йа; сохранены полные разборы и все различающиеся примеры двух шархов.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Определение и три падежных показателя</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">جَمْعُ الْمُذَكَّرِ السَّالِمِ</span>: مَا دَلَّ عَلَى ثَلَاثَةٍ فَأَكْثَرَ بِزِيَادَةِ وَاوٍ وَنُونٍ، أَوْ يَاءٍ وَنُونٍ فِي آخِرِهِ.</span>
        <p class="rule-study-text">Правильное мужское множественное число обозначает троих и более; к основе добавляются вау и нун либо йа и нун.</p>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-raf" dir="rtl" lang="ar">يُرْفَعُ بِالْوَاوِ: مُدَرِّسُونَ</span><span class="rule-term-ru">в рафъ показатель — вау: преподаватели.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-nasb" dir="rtl" lang="ar">يُنْصَبُ بِالْيَاءِ: مُدَرِّسِينَ</span><span class="rule-term-ru">в насбе показатель — йа: преподавателей.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-jarr" dir="rtl" lang="ar">يُجَرُّ بِالْيَاءِ: مُدَرِّسِينَ</span><span class="rule-term-ru">в джарре показатель — йа: преподавателей.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три полных разбора подробного шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Состояние</th><th>Пример</th><th>Полный арабский разбор</th><th>Русский перевод разбора</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَؤُلَاءِ <span class="ar-tone-raf">مُدَرِّسُونَ</span>.</span><span class="rule-table-ru">Это преподаватели.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">مُدَرِّسُونَ</span>: خَبَرٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الْوَاوُ؛ لِأَنَّهُ جَمْعُ مُذَكَّرٍ سَالِمٌ.</span></td><td>«Преподаватели» — сказуемое в рафъ; показатель — вау, поскольку это правильное мужское множественное.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">الْمُدَرِّسِينَ</span>.</span><span class="rule-table-ru">Я увидел преподавателей.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">الْمُدَرِّسِينَ</span>: مَفْعُولٌ بِهِ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْيَاءُ؛ لِأَنَّهُ جَمْعُ مُذَكَّرٍ سَالِمٌ.</span></td><td>«Преподавателей» — прямое дополнение в насбе; показатель — йа, поскольку это правильное мужское множественное.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">الْمُدَرِّسِينَ</span>.</span><span class="rule-table-ru">Я поприветствовал преподавателей.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-jarr">الْمُدَرِّسِينَ</span>: مَجْرُورٌ بِـ«عَلَى»، وَعَلَامَةُ جَرِّهِ الْيَاءُ؛ لِأَنَّهُ جَمْعُ مُذَكَّرٍ سَالِمٌ.</span></td><td>«Преподавателей» — имя в джарре после предлога «на»; показатель — йа, поскольку это правильное мужское множественное.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все дополнительные примеры второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Состояние</th><th>Пример</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td rowspan="3"><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">جَاءَ <span class="ar-tone-subject">الْمُدَرِّسُونَ</span>.</span></td><td>Преподаватели пришли.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَعْبُدُ <span class="ar-tone-subject">الْمُسْلِمُونَ</span> اللَّهَ.</span></td><td>Мусульмане поклоняются Аллаху.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَيْنَ <span class="ar-tone-raf">الْمُهَنْدِسُونَ</span>؟</span></td><td>Где инженеры?</td></tr>
            <tr><td rowspan="3"><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">الْمُدَرِّسِينَ</span>.</span></td><td>Я увидел преподавателей.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يُحِبُّ الْمُدَرِّسُ الطُّلَّابَ <span class="ar-tone-nasb">الْمُجْتَهِدِينَ</span>.</span></td><td>Преподаватель любит усердных студентов.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يُحِبُّ اللَّهُ <span class="ar-tone-nasb">الْمُؤْمِنِينَ</span>.</span></td><td>Аллах любит верующих.</td></tr>
            <tr><td rowspan="3"><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَبْحَثُ عَنِ <span class="ar-tone-jarr">الْمُدَرِّسِينَ</span>.</span></td><td>Я ищу преподавателей.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذَا إِمَامُ <span class="ar-tone-jarr">الْمُسْلِمِينَ</span>.</span></td><td>Это имам мусульман.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذِهِ الْجَائِزَةُ لِلطُّلَّابِ <span class="ar-tone-jarr">الْمُجْتَهِدِينَ</span>.</span></td><td>Эта награда предназначена усердным студентам.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Огласовка нуна</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">نُونُ الْمُثَنَّى مَكْسُورَةٌ: مُدَرِّسَانِ.</span><span class="rule-term-ru">нун двойственного числа имеет касру: два преподавателя.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">نُونُ جَمْعِ الْمُذَكَّرِ السَّالِمِ مَفْتُوحَةٌ: مُدَرِّسُونَ.</span><span class="rule-term-ru">нун правильного мужского множественного имеет фатху: преподаватели.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الثالث والعشرون
إعراب جمع مذكر السالم وما يلحق به
جمع المذكر السالم: ما دل على ثلاثة فأكثر بزيادة واو ونون، أو ياء ونون في آخره.
علاماته: يرفع بالواو، وينصب ويجر بالياء.
نحو: هؤلاء مدرسون.
مدرسون: خبر مرفوع وعلامة رفعه الواو لأنه جمع مذكر سالم.
رأيت المدرسين.
المدرسين: مفعول به منصوب وعلامة نصبه الياء لأنه جمع مذكر سالم.
سلمت على المدرسين.
المدرسين: مجرور بـ(على) وعلامة جره الياء لأنه جمع مذكر سالم.
تنبيه:
نون المثنى مكسورة (مدرسان) ونون جمع المذكر السالم مفتوحة (مدرسون).$$,
      53, 53, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الدرس الثالث والعشرون
إعراب جمع المذكر السالم، وألفاظ العقود
جمع المذكر السالم: هو ما دل على أكثر من اثنين، بزيادة واو ونون في آخره.
إعرابه: يرفع بالواو، وينصب ويجر بالياء.
الرفع: جاء المدرسون. يعبد المسلمون الله. أين المهندسون؟
النصب: رأيت المدرسين. يحب المدرس الطلاب المجتهدين. يحب الله المؤمنين.
الجر: أبحث عن المدرسين. هذا إمام المسلمين. هذه الجائزة للطلاب المجتهدين.$$,
      43, 43, 2);

  -- 2. Tens: members, declension, full i'rab, and every distinct example.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'إِعْرَابُ أَلْفَاظِ الْعُقُودِ (склонение названий круглых десятков)',
    rule_ar = 'أَلْفَاظُ الْعُقُودِ هِيَ الْأَعْدَادُ مِنْ عِشْرِينَ إِلَى تِسْعِينَ، وَهِيَ مُلْحَقَةٌ بِجَمْعِ الْمُذَكَّرِ السَّالِمِ؛ فَتُرْفَعُ بِالْوَاوِ، وَتُنْصَبُ وَتُجَرُّ بِالْيَاءِ.',
    summary = 'Названия круглых десятков от двадцати до девяноста склоняются как правильное мужское множественное: вау в рафъ и йа в насбе и джарре. Сохранены три полных разбора и все дополнительные примеры второго шарха.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Восемь названий десятков</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Число</th><th>Рафъ</th><th>Насб и джарр</th><th>Русское значение</th></tr></thead>
          <tbody>
            <tr><td>20</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">عِشْرُونَ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">عِشْرِينَ</span></td><td>двадцать</td></tr>
            <tr><td>30</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ثَلَاثُونَ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">ثَلَاثِينَ</span></td><td>тридцать</td></tr>
            <tr><td>40</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">أَرْبَعُونَ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">أَرْبَعِينَ</span></td><td>сорок</td></tr>
            <tr><td>50</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">خَمْسُونَ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">خَمْسِينَ</span></td><td>пятьдесят</td></tr>
            <tr><td>60</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">سِتُّونَ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">سِتِّينَ</span></td><td>шестьдесят</td></tr>
            <tr><td>70</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">سَبْعُونَ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">سَبْعِينَ</span></td><td>семьдесят</td></tr>
            <tr><td>80</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ثَمَانُونَ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">ثَمَانِينَ</span></td><td>восемьдесят</td></tr>
            <tr><td>90</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">تِسْعُونَ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">تِسْعِينَ</span></td><td>девяносто</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три полных разбора подробного шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Состояние</th><th>Пример</th><th>Арабский разбор</th><th>Русский перевод разбора</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَؤُلَاءِ <span class="ar-tone-raf">عِشْرُونَ</span> طَالِبًا.</span><span class="rule-table-ru">Это двадцать студентов.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">عِشْرُونَ</span>: خَبَرٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الْوَاوُ.</span></td><td>«Двадцать» — сказуемое в рафъ; показатель — вау.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عِشْرِينَ</span> طَالِبًا.</span><span class="rule-table-ru">Я увидел двадцать студентов.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">عِشْرِينَ</span>: مَفْعُولٌ بِهِ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْيَاءُ.</span></td><td>«Двадцать» — прямое дополнение в насбе; показатель — йа.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">عِشْرِينَ</span> طَالِبًا.</span><span class="rule-table-ru">Я поприветствовал двадцать студентов.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-jarr">عِشْرِينَ</span>: مَجْرُورٌ بِـ«عَلَى»، وَعَلَامَةُ جَرِّهِ الْيَاءُ.</span></td><td>«Двадцать» — имя в джарре после предлога «на»; показатель — йа.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все дополнительные примеры второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Состояние</th><th>Пример</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td rowspan="3"><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">جَاءَ <span class="ar-tone-raf">عِشْرُونَ</span> طَالِبًا وَطَالِبَةً.</span></td><td>Пришли двадцать студентов и студенток.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">غَابَ الْيَوْمَ <span class="ar-tone-raf">ثَلَاثُونَ</span> طَالِبَةً.</span></td><td>Сегодня отсутствовали тридцать студенток.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">فِي الْكِتَابِ <span class="ar-tone-raf">تِسْعُونَ</span> صَفْحَةً.</span></td><td>В книге девяносто страниц.</td></tr>
            <tr><td rowspan="3"><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عِشْرِينَ</span> طَالِبًا وَطَالِبَةً.</span></td><td>Я увидел двадцать студентов и студенток.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">قَرَأْتُ <span class="ar-tone-nasb">أَرْبَعِينَ</span> صَفْحَةً.</span></td><td>Я прочитал сорок страниц.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">سَأَلْتُ <span class="ar-tone-nasb">خَمْسِينَ</span> طَالِبًا وَطَالِبَةً.</span></td><td>Я спросил пятьдесят студентов и студенток.</td></tr>
            <tr><td rowspan="3"><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَبْحَثُ عَنْ <span class="ar-tone-jarr">عِشْرِينَ</span> طَالِبًا وَطَالِبَةً.</span></td><td>Я ищу двадцать студентов и студенток.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">اِشْتَرَيْتُ كُتُبًا بِـ<span class="ar-tone-jarr">سِتِّينَ</span> رِيَالًا.</span></td><td>Я купил книги за шестьдесят риалов.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُهُ قَبْلَ <span class="ar-tone-jarr">سَبْعِينَ</span> يَوْمًا.</span></td><td>Я видел его семьдесят дней назад.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$ما يلحق بجمع المذكر السالم
ألفاظ العقود: وهي عشرون (٢٠)، ثلاثون (٣٠) إلى تسعين (٩٠).
ألفاظ العقود ملحقة بجمع المذكر السالم، معرب إعرابه رفعا بالواو، ونصبا وجرا بالياء.
نحو: هؤلاء عشرون طالبا.
عشرون: خبر مرفوع وعلامة رفعه الواو.
رأيت عشرين طالبا.
عشرين: مفعول به منصوب وعلامة نصبه الياء.
سلمت على عشرين طالبا.
عشرين: مجرور بـ(على) وعلامة جره الياء.$$,
      53, 53, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$ألفاظ العقود: هي الأعداد ٢٠، ٣٠، ٤٠، ٥٠، ٦٠، ٧٠، ٨٠، ٩٠.
إعرابها: تعرب إعراب جمع المذكر السالم، ترفع بالواو، وتنصب وتجر بالياء.
الرفع: جاء عشرون طالبا وطالبة. غاب اليوم ثلاثون طالبة. في الكتاب تسعون صفحة.
النصب: رأيت عشرين طالبا وطالبة. قرأت أربعين صفحة. سألت خمسين طالبا وطالبة.
الجر: أبحث عن عشرين طالبا وطالبة. اشتريت كتبا بستين ريالا. رأيته قبل سبعين يوما.$$,
      43, 43, 2);

  -- 3. Negating a past verb with repeated la, including default past/present negation and every example.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'نَفْيُ الْفِعْلِ الْمَاضِي بِـ«لَا» النَّافِيَةِ (отрицание прошедшего глагола повторяющейся частицей «не»)',
    rule_ar = 'الْأَصْلُ أَنْ يُنْفَى الْفِعْلُ الْمَاضِي بِـ«مَا» النَّافِيَةِ، وَأَنْ يُنْفَى الْفِعْلُ الْمُضَارِعُ بِـ«لَا» النَّافِيَةِ. وَيَجُوزُ نَفْيُ الْفِعْلِ الْمَاضِي بِـ«لَا» بِشَرْطِ تَكْرَارِهَا، وَذَلِكَ فِي الْإِخْبَارِ فَقَطْ لَا فِي الِاسْتِفْهَامِ.',
    summary = 'Обычно прошедший глагол отрицается частицей مَا, а настоящий — частицей لَا. Прошедший разрешено отрицать через لَا только при её повторении и только в сообщении, не в вопросе; сохранены все примеры обоих шархов.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Основное и допустимое построение</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَا</span> أَكَلْتُ.</span><span class="rule-term-ru">«Я не ел»: обычно прошедший глагол отрицается частицей <span class="ar-inline" dir="rtl" lang="ar">مَا</span>.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَا</span> آكُلُ.</span><span class="rule-term-ru">«Я не ем»: обычно настоящий глагол отрицается частицей <span class="ar-inline" dir="rtl" lang="ar">لَا</span>.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَا</span> أَكَلْتُ وَ<span class="ar-tone-particle">لَا</span> شَرِبْتُ.</span><span class="rule-term-ru">«Я не ел и не пил»: перед прошедшими глаголами <span class="ar-inline" dir="rtl" lang="ar">لَا</span> должна повторяться.</span></div>
        </div>
        <span class="rule-main-ar" dir="rtl" lang="ar">يَكُونُ ذَلِكَ فِي الْإِخْبَارِ فَقَطْ، لَا فِي الِاسْتِفْهَامِ.</span>
        <p class="rule-study-text">Такое отрицание прошедшего употребляется только в сообщении, но не в вопросительном предложении.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры обоих шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَالَ تَعَالَى: ﴿فَلَا صَدَّقَ وَلَا صَلَّى﴾.</span><span class="rule-example-ru">Всевышний сказал: «Он не уверовал и не совершал молитву».</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا أَكَلْتُ وَلَا شَرِبْتُ.</span><span class="rule-example-ru">Я не ел и не пил.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا قَرَأْتُ وَلَا كَتَبْتُ.</span><span class="rule-example-ru">Я не читал и не писал.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ الطَّالِبُ لَا حَفِظَ الدَّرْسَ وَلَا كَتَبَ الْوَاجِبَ.</span><span class="rule-example-ru">Тот студент не выучил урок и не написал домашнее задание.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا ضَرَبَنِي وَلَا ضَرَبْتُهُ.</span><span class="rule-example-ru">Он не ударил меня, и я не ударил его.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا رَآنِي وَلَا رَأَيْتُهُ.</span><span class="rule-example-ru">Он не увидел меня, и я не увидел его.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$نفي الفعل الماضي بـ"لا" النافية
الأصل أن ينفى الفعل الماضي بـ"ما" النافية، ويجوز نفيه بـ"لا" النافية بشرط تكرار لا النافية، وهذا يكون في الإخبار فقط لا في الاستفهام.
نحو:
قال تعالى: (فلا صدق ولا صلى).
لا أكلت ولا شربت.
لا قرأت ولا كتبت.$$,
      54, 54, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$نفي الفعل الماضي بـ(لا) النافية
الأصل أن ينفى الفعل الماضي بـ(ما) النافية: ما أكلت.
والأصل أن ينفى الفعل المضارع بـ(لا) النافية: لا آكل.
قد ينفى الفعل الماضي بـ(لا) النافية، وحينئذ يجب تكرارها، تقول:
لا أكلت ولا شربت.
ذلك الطالب لا حفظ الدرس ولا كتب الواجب.
لا ضربني ولا ضربته.
لا رآني ولا رأيته.
قال تعالى: (فلا صدق ولا صلى).$$,
      43, 43, 2);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '23'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 23 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id)
  ) <> 6 then
    raise exception 'Expected 6 Book 2 lesson 23 source rows';
  end if;
end
$migration$;

commit;
