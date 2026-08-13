-- Verify Medina Book 2 lesson 24 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 55-57.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 44-46.

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
    and lesson_number = '24';

  if lesson_rule_count <> 5 then
    raise exception 'Expected 5 Book 2 lesson 24 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '24' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '24' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '24' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '24' and sort_order = 4;
  select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '24' and sort_order = 5;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);

  -- 1. One and two: agreement, order, syntactic role, no tamyiz, and case examples.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'الْعَدَدَانِ «وَاحِدٌ» وَ«اِثْنَانِ» (числительные «один» и «два»)',
    rule_ar = 'يُوَافِقُ الْعَدَدَانِ «وَاحِدٌ» وَ«اِثْنَانِ» الْمَعْدُودَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَيَتَقَدَّمُ الْمَعْدُودُ عَلَيْهِمَا، وَيَكُونُ الْعَدَدُ نَعْتًا لِلْمَعْدُودِ. وَالْعَدَدَانِ وَاحِدٌ وَاثْنَانِ لَا تَمْيِيزَ لَهُمَا. وَ«وَاحِدٌ» مُعْرَبٌ؛ فَيُرْفَعُ بِالضَّمَّةِ، وَيُنْصَبُ بِالْفَتْحَةِ، وَيُجَرُّ بِالْكَسْرَةِ.',
    summary = 'Числительные «один» и «два» согласуются с исчисляемым словом в роде и следуют после него. Числительное выступает согласованным определением; отдельного тамйиза у этих двух числительных нет. Подробный шарх также показывает три падежа слова «один».',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Согласование и порядок слов</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">وَاحِدٌ وَاثْنَانِ</span> يُوَافِقَانِ الْمَعْدُودَ، وَيَتَقَدَّمُ الْمَعْدُودُ عَلَيْهِمَا.</span>
        <p class="rule-study-text">«Один» и «два» согласуются с исчисляемым словом в мужском или женском роде. Сначала ставится исчисляемое слово, затем числительное.</p>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">طَالِبٌ <span class="ar-tone-structure">وَاحِدٌ</span></span><span class="rule-term-ru">один студент.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">طَالِبَةٌ <span class="ar-tone-structure">وَاحِدَةٌ</span></span><span class="rule-term-ru">одна студентка.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">طَالِبَانِ <span class="ar-tone-structure">اِثْنَانِ</span></span><span class="rule-term-ru">два студента.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">طَالِبَتَانِ <span class="ar-tone-structure">اِثْنَتَانِ</span></span><span class="rule-term-ru">две студентки.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Синтаксическая роль</span><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">نَعْتٌ</span> — согласованное определение к исчисляемому слову. <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">التَّمْيِيزُ</span> — поясняющее исчисляемое слово в особой конструкции; у числительных один и два отдельного тамйиза нет.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три падежа числительного «один»</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th>Арабский пример</th><th>Русский перевод</th><th>Форма числительного</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ, именительный</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذَا طَالِبٌ <span class="ar-tone-raf">وَاحِدٌ</span>.</span></td><td>Это один студент.</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">وَاحِدٌ</span><span class="rule-table-ru">окончание с даммой.</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб, винительный</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ طَالِبًا <span class="ar-tone-nasb">وَاحِدًا</span>.</span></td><td>Я увидел одного студента.</td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">وَاحِدًا</span><span class="rule-table-ru">окончание с фатхой.</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр, родительный</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى طَالِبٍ <span class="ar-tone-jarr">وَاحِدٍ</span>.</span></td><td>Я поприветствовал одного студента.</td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">وَاحِدٍ</span><span class="rule-table-ru">окончание с касрой.</span></td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الرابع والعشرون
مراجعة العدد
درسنا في هذا الباب:
١. العدد المفرد (من واحد إلى عشرة).
العددان (واحد) و(اثنان) يوافقان المعدود،
نحو: طالب واحد، وطالبان اثنان، طالبة واحدة، وطالبتان اثنتان.
العدد يكون نعتا للمعدود.
تنبيه: في العددين (واحد واثنان) يتقدم المعدود على العدد وفي البقية يؤخر.
العدد المفرد معرب، نقول:
في حالة الرفع: هذا طالب واحد.
وفي حالة النصب: رأيت طالبا واحدا.
وفي حالة الجر: سلمت على طالب واحد.$$,
      55, 55, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$١- العددان (١، ٢) يوافقان المعدود:
طالب واحد. طالبة واحدة. طالبان اثنان. طالبتان اثنتان.$$,
      44, 44, 2),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$العددان (١، ٢) لا تمييز لهما.$$,
      46, 46, 3);

  -- 2. Three through ten: gender opposition and plural genitive counted noun.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'table',
    title = 'الْأَعْدَادُ مِنْ ثَلَاثَةٍ إِلَى عَشَرَةٍ (числительные от трёх до десяти)',
    rule_ar = 'تُخَالِفُ الْأَعْدَادُ مِنْ ثَلَاثَةٍ إِلَى عَشَرَةٍ الْمَعْدُودَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَيَتَأَخَّرُ الْمَعْدُودُ عَنِ الْعَدَدِ، وَيَكُونُ جَمْعًا مَجْرُورًا بِالْإِضَافَةِ، فَيُعْرَبُ مُضَافًا إِلَيْهِ مَجْرُورًا. وَيُرَاعَى فِي تَذْكِيرِ الْعَدَدِ وَتَأْنِيثِهِ مُفْرَدُ الْمَعْدُودِ لَا جَمْعُهُ.',
    summary = 'Числительные 3–10 противоположны исчисляемому слову по роду. Исчисляемое слово ставится после числа во множественном числе и джарре как мудаф иляйхи. Род определяется по единственному числу исчисляемого слова.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Противоположность по роду</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">الْأَعْدَادُ مِنْ <span class="ar-tone-structure">ثَلَاثَةٍ إِلَى عَشَرَةٍ</span> تُخَالِفُ الْمَعْدُودَ.</span>
        <p class="rule-study-text">С существительным мужского рода употребляется форма числительного с окончанием <span class="ar-inline" dir="rtl" lang="ar">ـَةٌ</span>, а с существительным женского рода — форма без него.</p>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Число</th><th>С мужским исчисляемым словом</th><th>Русский смысл</th><th>С женским исчисляемым словом</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td>3</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ثَلَاثَةُ</span> طُلَّابٍ</span></td><td>трое студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ثَلَاثُ</span> طَالِبَاتٍ</span></td><td>три студентки</td></tr>
            <tr><td>4</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">أَرْبَعَةُ</span> طُلَّابٍ</span></td><td>четверо студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">أَرْبَعُ</span> طَالِبَاتٍ</span></td><td>четыре студентки</td></tr>
            <tr><td>5</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">خَمْسَةُ</span> طُلَّابٍ</span></td><td>пятеро студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">خَمْسُ</span> طَالِبَاتٍ</span></td><td>пять студенток</td></tr>
            <tr><td>6</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">سِتَّةُ</span> طُلَّابٍ</span></td><td>шестеро студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">سِتُّ</span> طَالِبَاتٍ</span></td><td>шесть студенток</td></tr>
            <tr><td>7</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">سَبْعَةُ</span> طُلَّابٍ</span></td><td>семеро студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">سَبْعُ</span> طَالِبَاتٍ</span></td><td>семь студенток</td></tr>
            <tr><td>8</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ثَمَانِيَةُ</span> طُلَّابٍ</span></td><td>восемь студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ثَمَانِي</span> طَالِبَاتٍ</span></td><td>восемь студенток</td></tr>
            <tr><td>9</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">تِسْعَةُ</span> طُلَّابٍ</span></td><td>девять студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">تِسْعُ</span> طَالِبَاتٍ</span></td><td>девять студенток</td></tr>
            <tr><td>10</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">عَشَرَةُ</span> طُلَّابٍ</span></td><td>десять студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">عَشْرُ</span> طَالِبَاتٍ</span></td><td>десять студенток</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Форма исчисляемого слова</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-jarr" dir="rtl" lang="ar">جَمْعٌ مَجْرُورٌ بِالْإِضَافَةِ</span><span class="rule-term-ru">множественное число в джарре посредством конструкции идафы.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-jarr" dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ مَجْرُورٌ</span><span class="rule-term-ru">второй член идафы в родительном падеже.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Как определить род</span><span class="ar-inline" dir="rtl" lang="ar">سَبْعَةُ أَيَّامٍ</span> — «семь дней». Смотрят на единственное число <span class="ar-inline" dir="rtl" lang="ar">يَوْمٌ</span> «день», а не на форму множественного числа.</div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$والأعداد من (ثلاثة إلى عشرة) تخالف المعدود،
نحو: ثلاثة طلاب، وخمس طالبات.
المعدود من ٣ إلى ٩ يكون جمعا مجرورا ويعرب مضافا إليه.
تنبيه: في العددين (واحد واثنان) يتقدم المعدود على العدد وفي البقية يؤخر.$$,
      55, 55, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$٢- الأعداد من (٣ إلى ١٠) تخالف المعدود:
ثلاثة طلاب. ثلاث طالبات.
أربعة طلاب. أربع طالبات.
خمسة طلاب. خمس طالبات.
ستة طلاب. ست طالبات.
سبعة طلاب. سبع طالبات.
ثمانية طلاب. ثماني طالبات.
تسعة طلاب. تسع طالبات.
عشرة طلاب. عشر طالبات.$$,
      44, 44, 2),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$١- الأعداد من (٣ إلى ١٠) المعدود يكون جمعا مجرورا بالإضافة:
ثلاثة طلاب. ثلاث طالبات.
مضاف إليه مجرور. مضاف إليه مجرور.
سبعة أيام: ينظر في تذكير العدد وتأنيثه إلى المفرد (يوم) ولا ينظر إلى الجمع.$$,
      46, 46, 3);

  -- 3. Compound numbers 11-19 and the singular accusative tamyiz used through 99.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'table',
    title = 'الْأَعْدَادُ الْمُرَكَّبَةُ مِنْ أَحَدَ عَشَرَ إِلَى تِسْعَةَ عَشَرَ (составные числительные от одиннадцати до девятнадцати)',
    rule_ar = 'يَكُونُ الْمَعْدُودُ مَعَ الْأَعْدَادِ مِنْ أَحَدَ عَشَرَ إِلَى تِسْعَةٍ وَتِسْعِينَ مُفْرَدًا مَنْصُوبًا عَلَى التَّمْيِيزِ. وَفِي أَحَدَ عَشَرَ وَاثْنَيْ عَشَرَ يُوَافِقُ الْجُزْآنِ الْمَعْدُودَ، أَمَّا مِنْ ثَلَاثَةَ عَشَرَ إِلَى تِسْعَةَ عَشَرَ فَالْجُزْءُ الْأَوَّلُ يُخَالِفُهُ وَالْجُزْءُ الثَّانِي يُوَافِقُهُ. وَالْعَدَدُ الْمُرَكَّبُ مَبْنِيٌّ عَلَى فَتْحِ الْجُزْأَيْنِ، إِلَّا الْجُزْءَ الْأَوَّلَ مِنِ اثْنَيْ عَشَرَ وَاثْنَتَيْ عَشْرَةَ فَهُوَ مُعْرَبٌ إِعْرَابَ الْمُثَنَّى.',
    summary = 'После чисел 11–99 исчисляемое слово имеет единственное число и насб как тамйиз. В 11–12 обе части числа согласуются с ним, а в 13–19 первая часть противоположна по роду и вторая согласуется. Составные числа неизменяемы на фатхе обеих частей, кроме первой части двенадцати.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный ряд 11–19</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Число</th><th>Мужской род</th><th>Русский смысл</th><th>Женский род</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td>11</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">أَحَدَ عَشَرَ</span> طَالِبًا</span></td><td>одиннадцать студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">إِحْدَى عَشْرَةَ</span> طَالِبَةً</span></td><td>одиннадцать студенток</td></tr>
            <tr><td>12</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">اِثْنَا عَشَرَ</span> طَالِبًا</span></td><td>двенадцать студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">اِثْنَتَا عَشْرَةَ</span> طَالِبَةً</span></td><td>двенадцать студенток</td></tr>
            <tr><td>13</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ثَلَاثَةَ عَشَرَ</span> طَالِبًا</span></td><td>тринадцать студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ثَلَاثَ عَشْرَةَ</span> طَالِبَةً</span></td><td>тринадцать студенток</td></tr>
            <tr><td>14</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">أَرْبَعَةَ عَشَرَ</span> طَالِبًا</span></td><td>четырнадцать студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">أَرْبَعَ عَشْرَةَ</span> طَالِبَةً</span></td><td>четырнадцать студенток</td></tr>
            <tr><td>15</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">خَمْسَةَ عَشَرَ</span> طَالِبًا</span></td><td>пятнадцать студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">خَمْسَ عَشْرَةَ</span> طَالِبَةً</span></td><td>пятнадцать студенток</td></tr>
            <tr><td>16</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">سِتَّةَ عَشَرَ</span> طَالِبًا</span></td><td>шестнадцать студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">سِتَّ عَشْرَةَ</span> طَالِبَةً</span></td><td>шестнадцать студенток</td></tr>
            <tr><td>17</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">سَبْعَةَ عَشَرَ</span> طَالِبًا</span></td><td>семнадцать студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">سَبْعَ عَشْرَةَ</span> طَالِبَةً</span></td><td>семнадцать студенток</td></tr>
            <tr><td>18</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ثَمَانِيَةَ عَشَرَ</span> طَالِبًا</span></td><td>восемнадцать студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ثَمَانِيَ عَشْرَةَ</span> طَالِبَةً</span></td><td>восемнадцать студенток</td></tr>
            <tr><td>19</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">تِسْعَةَ عَشَرَ</span> طَالِبًا</span></td><td>девятнадцать студентов</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">تِسْعَ عَشْرَةَ</span> طَالِبَةً</span></td><td>девятнадцать студенток</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Неизменяемая форма и исключение двенадцати</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th>Число 13</th><th>Число 12</th><th>Русский перевод</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَؤُلَاءِ <span class="ar-tone-structure">ثَلَاثَةَ عَشَرَ</span> طَالِبًا.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَؤُلَاءِ <span class="ar-tone-raf">اِثْنَا عَشَرَ</span> طَالِبًا.</span></td><td>Это тринадцать студентов. Это двенадцать студентов.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-structure">ثَلَاثَةَ عَشَرَ</span> طَالِبًا.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">اِثْنَيْ عَشَرَ</span> طَالِبًا.</span></td><td>Я увидел тринадцать студентов. Я увидел двенадцать студентов.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-structure">ثَلَاثَةَ عَشَرَ</span> طَالِبًا.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">اِثْنَيْ عَشَرَ</span> طَالِبًا.</span></td><td>Я поприветствовал тринадцать студентов. Я поприветствовал двенадцать студентов.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Исчисляемое слово и огласовка ش</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-nasb" dir="rtl" lang="ar">مُفْرَدٌ مَنْصُوبٌ تَمْيِيزًا</span><span class="rule-term-ru">единственное число в насбе в роли тамйиза после чисел 11–99.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">عَشْرٌ؛ أَحَدَ عَشَرَ</span><span class="rule-term-ru">в отдельном слове «десять» буква ش с сукуном, в составном мужском числе — с фатхой.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">عَشَرَةٌ؛ إِحْدَى عَشْرَةَ</span><span class="rule-term-ru">в отдельной женской форме ش с фатхой, в составном числе — с сукуном; шарх допускает и фатху.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$٢. العدد المركب (من أحد عشر إلى تسعة عشر).
المعدود من ١١ إلى ٩٩ يكون مفردا منصوبا ويعرب تمييزا.
العددان (أحد عشر) و(اثنا عشر) الجزآن يوافقان المعدود،
نحو: أحد عشر طالبا، واثنتا عشرة طالبة.
والأعداد من (ثلاثة عشر إلى تسعة عشر) الجزء الأول يخالف المعدود والجزء الثاني يوافقه،
نحو: ثلاثة عشر طالبا، وخمس عشرة طالبة.
العدد المركب مبني على فتح الجزأين ما عدا الجزء الأول في (اثني عشر واثنتي عشرة) فهو معرب إعراب المثنى، نقول:
في حالة الرفع: هؤلاء ثلاثة عشر طالبا. هؤلاء اثنا عشر طالبا.
وفي حالة النصب: رأيت ثلاثة عشر طالبا. رأيت اثني عشر طالبا.
وفي حالة الجر: سلمت على ثلاثة عشر طالبا. سلمت على اثني عشر طالبا.$$,
      55, 56, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$٣- العددان (١١، ١٢) الجزآن يوافقان المعدود:
أحد عشر طالبا. إحدى عشرة طالبة. اثنا عشر طالبا. اثنتا عشرة طالبة.
٤- الأعداد من (١٣ إلى ١٩) الجزء الأول يخالف المعدود، والجزء الثاني (١٠) يوافقه:
ثلاثة عشر طالبا. ثلاث عشرة طالبة.
أربعة عشر طالبا. أربع عشرة طالبة.
خمسة عشر طالبا. خمس عشرة طالبة.
ستة عشر طالبا. ست عشرة طالبة.
سبعة عشر طالبا. سبع عشرة طالبة.
ثمانية عشر طالبا. ثماني عشرة طالبة.
تسعة عشر طالبا. تسع عشرة طالبة.$$,
      44, 44, 2),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$٢- الأعداد من (١١ إلى ٩٩) المعدود يكون مفردا منصوبا، ويعرب تمييزا.
عشر: حرف الشين يكون ساكنا في المفرد، ومفتوحا في المركب: أحد عشر.
عشرة: حرف الشين يكون مفتوحا في المفرد، وساكنا في المركب: إحدى عشرة، ويجوز أن يكون مفتوحا في المركب.$$,
      46, 46, 3);

  -- 4. Coordinated numbers and decade words.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'table',
    title = 'الْعَدَدُ الْمَعْطُوفُ وَأَلْفَاظُ الْعُقُودِ (присоединённые числительные и названия десятков)',
    rule_ar = 'فِي الْعَدَدِ الْمَعْطُوفِ مِنْ وَاحِدٍ وَعِشْرِينَ إِلَى تِسْعَةٍ وَتِسْعِينَ يَجْرِي الْجُزْءُ الْأَوَّلُ قَبْلَ وَاوِ الْعَطْفِ عَلَى حُكْمِ الْأَعْدَادِ مِنْ وَاحِدٍ إِلَى تِسْعَةٍ، وَيَكُونُ مُنَوَّنًا، وَتَبْقَى أَلْفَاظُ الْعُقُودِ بَعْدَ الْوَاوِ عَلَى صُورَةٍ وَاحِدَةٍ مَعَ الْمُذَكَّرِ وَالْمُؤَنَّثِ. وَتُعْرَبُ أَلْفَاظُ الْعُقُودِ إِعْرَابَ جَمْعِ الْمُذَكَّرِ السَّالِمِ؛ فَتُرْفَعُ بِالْوَاوِ، وَتُنْصَبُ وَتُجَرُّ بِالْيَاءِ.',
    summary = 'В присоединённых числительных 21–99 единицы подчиняются уже изученным правилам 1–9 и получают танвин, а десятки сохраняют одну форму для мужского и женского рода. Десятки склоняются как правильное мужское множественное число: вау в рафъ, йа в насбе и джарре.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Одна форма десятков для обоих родов</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Десяток</th><th>Арабский пример</th><th>Русский перевод</th></tr></thead>
          <tbody>
            <tr><td>20</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">عِشْرُونَ</span> طَالِبًا وَطَالِبَةً.</span></td><td>Двадцать студентов и студенток.</td></tr>
            <tr><td>40</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">أَرْبَعُونَ</span> طَالِبًا وَطَالِبَةً.</span></td><td>Сорок студентов и студенток.</td></tr>
            <tr><td>80</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ثَمَانُونَ</span> طَالِبًا وَطَالِبَةً.</span></td><td>Восемьдесят студентов и студенток.</td></tr>
          </tbody>
        </table></div>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">سِتَّةٌ وَعِشْرُونَ</span> طَالِبًا</span><span class="rule-term-ru">двадцать шесть студентов: единица противоположна мужскому исчисляемому слову.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">سِتٌّ وَعِشْرُونَ</span> طَالِبَةً</span><span class="rule-term-ru">двадцать шесть студенток: единица противоположна женскому исчисляемому слову.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Танвин</span>Первый компонент перед <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">وَاوُ الْعَطْفِ</span> — соединительным «и» — имеет танвин: <span class="ar-inline" dir="rtl" lang="ar">سِتَّةٌ</span> или <span class="ar-inline" dir="rtl" lang="ar">سِتٌّ</span>.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Склонение присоединённого числа</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th>Арабский пример</th><th>Русский перевод</th><th>Показатель десятка</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذِهِ ثَلَاثَةٌ وَ<span class="ar-tone-raf">عِشْرُونَ</span> قَلَمًا.</span></td><td>Это двадцать три ручки.</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الْوَاوُ</span><span class="rule-table-ru">вау.</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِشْتَرَيْتُ ثَلَاثَةً وَ<span class="ar-tone-nasb">عِشْرِينَ</span> قَلَمًا.</span></td><td>Я купил двадцать три ручки.</td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">الْيَاءُ</span><span class="rule-table-ru">йа.</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَصَلْتُ عَلَى ثَلَاثَةٍ وَ<span class="ar-tone-jarr">عِشْرِينَ</span> قَلَمًا.</span></td><td>Я получил двадцать три ручки.</td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْيَاءُ</span><span class="rule-table-ru">йа.</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Исчисляемое слово после 11–99</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">عِشْرُونَ <span class="ar-tone-nasb">طَالِبًا</span>.</span><span class="rule-example-ru">Двадцать студентов; «студент» — единственное число, насб, тамйиз.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">خَمْسٌ وَسِتُّونَ <span class="ar-tone-nasb">طَالِبَةً</span>.</span><span class="rule-example-ru">Шестьдесят пять студенток; «студентка» — единственное число, насб, тамйиз.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِثْنَانِ وَتِسْعُونَ <span class="ar-tone-nasb">طَالِبًا</span>.</span><span class="rule-example-ru">Девяносто два студента; «студент» — единственное число, насб, тамйиз.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$٣. العدد المعطوف: (من ٢١ إلى ٩٩) ما عدا العقود (٢٠، ٣٠، ٤٠ إلى ٩٠).
الأعداد من (١-٢) ومن (٣-٩) وهي الجزء الأول (قبل واو العطف) حكمها كما ذكرنا سابقا، أما ألفاظ العقود وهي الجزء الثاني (بعد واو العطف) فحكمها لا تتغير مع المعدود، تبقى في صيغة واحدة مع المذكر والمؤنث، نحو:
ستة وعشرون طالبا، وست وعشرون طالبة.
تنبيه: يكون العدد الأول في العدد المعطوف منونا.
العدد المعطوف معرب، نقول:
في حالة الرفع: هذه ثلاثة وعشرون قلما.
وفي حالة النصب: اشتريت ثلاثة وعشرين قلما.
وفي حالة الجر: حصلت على ثلاثة وعشرين قلما.
٤. العقود (٢٠، ٣٠، ٤٠ إلى ٩٠).
إعراب العقود مثل إعراب جمع المذكر السالم (انظر الدرس ٢٣).$$,
      56, 56, 1),
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$٥- ألفاظ العقود (٢٠، ٣٠، ٤٠ إلى ٩٠) تأتي بصورة واحدة مع المذكر والمؤنث:
عشرون طالبا وطالبة. أربعون طالبا وطالبة. ثمانون طالبا وطالبة.$$,
      45, 45, 2),
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$٢- الأعداد من (١١ إلى ٩٩) المعدود يكون مفردا منصوبا، ويعرب تمييزا:
أحد عشر طالبا. عشرون طالبا. خمس وستون طالبة. اثنان وتسعون طالبا.
كل ما تحته خط يعرب تمييزا منصوبا.$$,
      46, 46, 3);

  -- 5. Hundreds, thousands, large compounds, and their counted nouns.
  update public.rules
  set
    sort_order = 5,
    rule_kind = 'table',
    title = 'مِائَةٌ وَأَلْفٌ وَالْأَعْدَادُ الْكَبِيرَةُ (сто, тысяча и большие числа)',
    rule_ar = 'يَكُونُ الْمَعْدُودُ بَعْدَ مِائَةٍ وَأَلْفٍ وَمُضَاعَفَاتِهِمَا مُفْرَدًا مَجْرُورًا بِالْإِضَافَةِ، وَيَلْزَمُ لَفْظَا مِائَةٍ وَأَلْفٍ صُورَةً وَاحِدَةً مَعَ الْمُذَكَّرِ وَالْمُؤَنَّثِ. وَتُحْذَفُ نُونُ الْمُثَنَّى مِنْ مِئَتَيْنِ وَأَلْفَيْنِ عِنْدَ الْإِضَافَةِ. وَعِنْدَ دُخُولِ الْأَعْدَادِ مِنْ ثَلَاثَةٍ إِلَى تِسْعَةٍ عَلَى مِائَةٍ يُقَالُ نَحْوُ «ثَلَاثُمِائَةٍ»، وَعِنْدَ دُخُولِهَا عَلَى أَلْفٍ يُقَالُ نَحْوُ «ثَلَاثَةُ آلَافٍ».',
    summary = 'После ста, тысячи и их кратных исчисляемое слово имеет единственное число и джарр по идафе. «Сто» и «тысяча» не меняют форму из-за рода. При идафе из двойственных «две сотни» и «две тысячи» удаляется нун. Оба шарха также разбирают сотни, тысячи и большие составные числа.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Одна форма для мужского и женского рода</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Количество</th><th>С мужским словом</th><th>Русский смысл</th><th>С женским словом</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td>100</td><td><span class="rule-table-ar" dir="rtl" lang="ar">مِائَةُ رَجُلٍ</span></td><td>сто мужчин</td><td><span class="rule-table-ar" dir="rtl" lang="ar">مِائَةُ امْرَأَةٍ</span></td><td>сто женщин</td></tr>
            <tr><td>1000</td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَلْفُ رَجُلٍ</span></td><td>тысяча мужчин</td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَلْفُ امْرَأَةٍ</span></td><td>тысяча женщин</td></tr>
            <tr><td>200</td><td><span class="rule-table-ar" dir="rtl" lang="ar">مِئَتَا رَجُلٍ</span></td><td>двести мужчин</td><td><span class="rule-table-ar" dir="rtl" lang="ar">مِئَتَا امْرَأَةٍ</span></td><td>двести женщин</td></tr>
            <tr><td>2000</td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَلْفَا رَجُلٍ</span></td><td>две тысячи мужчин</td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَلْفَا امْرَأَةٍ</span></td><td>две тысячи женщин</td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Удаление нуна</span><span class="ar-inline" dir="rtl" lang="ar">أَلْفَا طَالِبٍ</span> происходит от <span class="ar-inline" dir="rtl" lang="ar">أَلْفَانِ</span>: нун удаляется из-за идафы. Для «двухсот» шарх допускает оба написания: <span class="ar-inline" dir="rtl" lang="ar">مِئَتَا</span> и <span class="ar-inline" dir="rtl" lang="ar">مَائَتَا</span>.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Сотни и тысячи</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Разряд</th><th>Арабский пример</th><th>Русский перевод</th><th>Что показывает форма</th></tr></thead>
          <tbody>
            <tr><td>100</td><td><span class="rule-table-ar" dir="rtl" lang="ar">مِائَةُ طَالِبٍ وَطَالِبَةٍ.</span></td><td>Сто студентов и студенток.</td><td>Одна форма с обоими родами.</td></tr>
            <tr><td>1000</td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَلْفُ طَالِبٍ وَطَالِبَةٍ.</span></td><td>Тысяча студентов и студенток.</td><td>Одна форма с обоими родами.</td></tr>
            <tr><td>2000</td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَلْفَا طَالِبٍ وَطَالِبَةٍ.</span></td><td>Две тысячи студентов и студенток.</td><td>Нун двойственного числа удалён в идафе.</td></tr>
            <tr><td>300</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ثَلَاثُمِائَةِ طَالِبٍ وَطَالِبَةٍ.</span></td><td>Триста студентов и студенток.</td><td><span class="rule-table-ar" dir="rtl" lang="ar">مِائَةٌ</span><span class="rule-table-ru">«сто» — слово женского рода.</span></td></tr>
            <tr><td>500</td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَمْسُمِائَةِ طَالِبٍ وَطَالِبَةٍ.</span></td><td>Пятьсот студентов и студенток.</td><td>Та же модель сотен.</td></tr>
            <tr><td>800</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ثَمَانِمِائَةِ طَالِبٍ وَطَالِبَةٍ.</span></td><td>Восемьсот студентов и студенток.</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ثَمَانِ</span><span class="rule-table-ru">имеет скрытое падежное окончание.</span></td></tr>
            <tr><td>3000</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ثَلَاثَةُ آلَافِ طَالِبٍ وَطَالِبَةٍ.</span></td><td>Три тысячи студентов и студенток.</td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَلْفٌ</span><span class="rule-table-ru">«тысяча» — слово мужского рода.</span></td></tr>
            <tr><td>5000</td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَمْسَةُ آلَافِ طَالِبٍ وَطَالِبَةٍ.</span></td><td>Пять тысяч студентов и студенток.</td><td>Та же модель тысяч.</td></tr>
            <tr><td>900</td><td><span class="rule-table-ar" dir="rtl" lang="ar">تِسْعُمِائَةِ طَالِبٍ.</span></td><td>Девятьсот студентов.</td><td>Пример подробного шарха.</td></tr>
            <tr><td>5000</td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَمْسَةُ آلَافِ طَالِبٍ.</span></td><td>Пять тысяч студентов.</td><td>Пример подробного шарха.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Форма исчисляемого слова</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-jarr">مُفْرَدٌ مَجْرُورٌ بِالْإِضَافَةِ</span></span>
        <p class="rule-study-text">После ста, тысячи и их кратных исчисляемое слово стоит в единственном числе и джарре как второй член идафы.</p>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مِائَةُ <span class="ar-tone-jarr">طَالِبٍ</span>.</span><span class="rule-example-ru">Сто студентов.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">خَمْسُمِائَةِ <span class="ar-tone-jarr">طَالِبَةٍ</span>.</span><span class="rule-example-ru">Пятьсот студенток.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">ثَلَاثَةُ آلَافِ <span class="ar-tone-jarr">طَالِبٍ</span>.</span><span class="rule-example-ru">Три тысячи студентов.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">خَمْسُونَ أَلْفَ <span class="ar-tone-jarr">طَالِبَةٍ</span>.</span><span class="rule-example-ru">Пятьдесят тысяч студенток.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَرْبَعُمِائَةِ أَلْفِ <span class="ar-tone-jarr">طَالِبٍ</span>.</span><span class="rule-example-ru">Четыреста тысяч студентов.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Примечание о 800</span>В сочетании <span class="ar-inline" dir="rtl" lang="ar">ثَمَانِمِائَةِ طَالِبٍ</span> компонент <span class="ar-inline" dir="rtl" lang="ar">ثَمَانِ</span> имеет <span class="ar-inline" dir="rtl" lang="ar">إِعْرَابٌ تَقْدِيرِيٌّ</span> — скрытое, предполагаемое падежное окончание; шарх сообщает, что это будет изучаться на третьем уровне.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Большие составные числа из второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Число</th><th>Запись словами</th><th>Русский перевод и строение</th></tr></thead>
          <tbody>
            <tr><td>6142</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">اِثْنَانِ</span> وَأَرْبَعُونَ وَمِائَةٌ وَ<span class="ar-tone-structure">سِتَّةُ آلَافِ</span> رِيَالٍ.</span></td><td>Шесть тысяч сто сорок два риала: «два» согласуется с риалом; десятки и сто имеют одну форму для обоих родов; «шесть» противоположно слову «тысяча» мужского рода.</td></tr>
            <tr><td>9573</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ثَلَاثٌ وَسَبْعُونَ وَخَمْسُمِائَةٍ وَ<span class="ar-tone-structure">تِسْعَةُ آلَافِ</span> رُوبِيَّةٍ.</span></td><td>Девять тысяч пятьсот семьдесят три рупии.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Число 3456 в трёх падежах</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th>Арабский пример</th><th>Русский перевод</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَؤُلَاءِ <span class="ar-tone-raf">سِتَّةٌ وَخَمْسُونَ وَأَرْبَعُمِائَةٍ وَثَلَاثَةُ آلَافِ</span> طَالِبٍ.</span></td><td>Это 3456 студентов.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">سِتَّةً وَخَمْسِينَ وَأَرْبَعَمِائَةٍ وَثَلَاثَةَ آلَافِ</span> طَالِبٍ.</span></td><td>Я увидел 3456 студентов.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">سِتَّةٍ وَخَمْسِينَ وَأَرْبَعِمِائَةٍ وَثَلَاثَةِ آلَافِ</span> طَالِبٍ.</span></td><td>Я поприветствовал 3456 студентов.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_5_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$٥. مائة وألف.
يكون المعدود بعدهما مفردا مجرورا بالإضافة، ويبقى في صيغة واحدة مع المذكر والمؤنث لا يتغير،
نحو: مائة رجل، مائة امرأة. ألف رجل، ألف امرأة.
تنبيه: تحذف النون في (مائتان وألفان) عند الإضافة،
نحو: مئتا رجل، مئتا امرأة. ألفا رجل، ألفا امرأة.
تنبيه: مئتا ومائتا كلاهما صحيح.
إذا دخلت الأعداد من (ثلاثة إلى تسعة) على (مائة وألف)، فإن (مائة وألف) تجر بالإضافة،
نحو: تسعمائة طالب، وخمسة آلاف طالب.
تنبيه: ثمانمائة طالب:
(ثمان) في (ثمانمائة) يعرب إعرابا تقديريا (الإعراب التقديري سندرسه في المستوى الثالث بإذن الله تعالى).
٣٤٥٦ (طالب/طالبة).
يقرأ في حالة الرفع: هؤلاء ستة وخمسون وأربعمائة وثلاثة آلاف طالب.
ويقرأ في حالة النصب: رأيت ستة وخمسين وأربعمائة وثلاثة آلاف طالب.
ويقرأ في حالة الجر: سلمت على ستة وخمسين وأربعمائة وثلاثة آلاف طالب.$$,
      56, 57, 1),
    (rule_5_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$٦- الأعداد (١٠٠، ١٠٠٠، ٢٠٠٠) تأتي بصورة واحدة مع المذكر والمؤنث:
مائة طالب وطالبة. ألف طالب وطالبة. ألفا طالب وطالبة.
٧- الأعداد (٣٠٠، ٤٠٠، ٥٠٠ إلى ٩٠٠) العدد من (٣ إلى ٩) يكون مذكرا؛ لأن لفظ (مائة) مؤنث، تقول: ثلاثمائة طالب وطالبة. خمسمائة طالب وطالبة. ثمانمائة طالب وطالبة، وهكذا.
٨- الأعداد (٣٠٠٠، ٤٠٠٠، ٥٠٠٠ إلى ٩٠٠٠) العدد من (٣ إلى ٩) يكون مؤنثا؛ لأن لفظ (ألف) مذكر، تقول: ثلاثة آلاف طالب وطالبة. خمسة آلاف طالب وطالبة، وهكذا.
٦١٤٢ ريال: اثنان وأربعون ومائة وستة آلاف ريال.
٩٥٧٣ روبية: ثلاث وسبعون وخمسمائة وتسعة آلاف روبية.$$,
      45, 45, 2),
    (rule_5_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$٣- الأعداد (١٠٠، ١٠٠٠، ٢٠٠٠، ٥٠٠٠، ... إلخ) المعدود يكون مفردا مجرورا بالإضافة:
مائة طالب. خمسمائة طالبة. ثلاثة آلاف طالب. خمسون ألف طالبة. أربعمائة ألف طالب.
كل ما تحته خط يعرب مضافا إليه مجرورا.
ألفا طالب: أصله (ألفان) حذفت النون بسبب الإضافة.$$,
      46, 46, 3);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '24'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 24 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id)
  ) <> 15 then
    raise exception 'Expected 15 Book 2 lesson 24 source rows';
  end if;

  if exists (
    select 1 from public.rules
    where id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id)
      and (content::text like '%←%' or content::text like '%→%')
  ) then
    raise exception 'Book 2 lesson 24 contains an RTL-hostile arrow';
  end if;
end
$migration$;

commit;
