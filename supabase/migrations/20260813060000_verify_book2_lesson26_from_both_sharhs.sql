-- Verify Medina Book 2 lesson 26 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 60-62.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 48.

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
    and lesson_number = '26';

  if lesson_rule_count <> 5 then
    raise exception 'Expected 5 Book 2 lesson 26 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '26' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '26' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '26' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '26' and sort_order = 4;
  select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '26' and sort_order = 5;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);

  -- 1. The weak verb, its types, and the morphological scale.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'الْفِعْلُ الْمُعْتَلُّ وَالْمِيزَانُ الصَّرْفِيُّ (слабый глагол и морфологическая модель)',
    rule_ar = 'الْفِعْلُ الْمُعْتَلُّ هُوَ مَا كَانَ أَحَدُ أَحْرُفِهِ الْأَصْلِيَّةِ حَرْفَ عِلَّةٍ، وَحُرُوفُ الْعِلَّةِ هِيَ الْوَاوُ وَالْأَلِفُ وَالْيَاءُ. وَتُسَمَّى أَحْرُفُ الْجِذْرِ فَاءَ الْفِعْلِ وَعَيْنَ الْفِعْلِ وَلَامَ الْفِعْلِ بِحَسَبِ الْمِيزَانِ الصَّرْفِيِّ «فَعَلَ». فَإِنْ كَانَتْ فَاءُ الْفِعْلِ حَرْفَ عِلَّةٍ فَهُوَ الْمِثَالُ، وَإِنْ كَانَتْ عَيْنُهُ حَرْفَ عِلَّةٍ فَهُوَ الْأَجْوَفُ، وَإِنْ كَانَتْ لَامُهُ حَرْفَ عِلَّةٍ فَهُوَ النَّاقِصُ، وَإِنِ اجْتَمَعَ فِيهِ حَرْفَا عِلَّةٍ فَهُوَ اللَّفِيفُ الْمَفْرُوقُ أَوِ الْمَقْرُونُ.',
    summary = 'Слабым называется глагол, одна из коренных букв которого — و, ا или ي. Место слабой буквы определяет тип: الْمِثَالُ, الْأَجْوَفُ, النَّاقِصُ или اللَّفِيفُ. Коренные буквы сопоставляются с ف، ع، ل морфологической модели.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Слабые и правильные глаголы</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلٌ مُعْتَلٌّ</span><span class="rule-term-ru">слабый глагол: среди его коренных букв есть буква слабости.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">حُرُوفُ الْعِلَّةِ: الْوَاوُ، وَالْأَلِفُ، وَالْيَاءُ</span><span class="rule-term-ru">буквы слабости: و, ا и ي.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلٌ صَحِيحٌ</span><span class="rule-term-ru">правильный глагол: среди его коренных букв нет буквы слабости.</span></div>
        </div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">وَجَدَ، قَالَ، رَضِيَ.</span><span class="rule-example-ru">Нашёл; сказал; был доволен — примеры слабых глаголов из подробного шарха.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Тип определяется местом слабой буквы</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Положение</th><th>Арабское название и русский смысл</th><th>Пример из шарха</th></tr></thead>
          <tbody>
            <tr><td>Первая коренная буква</td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْمِثَالُ الْوَاوِيُّ</span><span class="rule-table-ru">начальный слабый و</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">وَقَفَ</span><span class="rule-table-ru">остановился, встал</span></td></tr>
            <tr><td>Первая коренная буква</td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْمِثَالُ الْيَائِيُّ</span><span class="rule-table-ru">начальный слабый ي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَبِسَ</span><span class="rule-table-ru">высох</span></td></tr>
            <tr><td>Вторая коренная буква</td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْأَجْوَفُ الْوَاوِيُّ</span><span class="rule-table-ru">полый глагол с исходным و</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">زَارَ، يَزُورُ</span><span class="rule-table-ru">посетил, посещает</span></td></tr>
            <tr><td>Вторая коренная буква</td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْأَجْوَفُ الْيَائِيُّ</span><span class="rule-table-ru">полый глагол с исходным ي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بَاعَ، يَبِيعُ</span><span class="rule-table-ru">продал, продаёт</span></td></tr>
            <tr><td>Третья коренная буква</td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">النَّاقِصُ الْوَاوِيُّ</span><span class="rule-table-ru">конечный слабый و</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَا، يَدْعُو</span><span class="rule-table-ru">позвал, зовёт</span></td></tr>
            <tr><td>Третья коренная буква</td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">النَّاقِصُ الْيَائِيُّ</span><span class="rule-table-ru">конечный слабый ي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بَكَى، يَبْكِي</span><span class="rule-table-ru">плакал, плачет</span></td></tr>
            <tr><td>Первая и третья</td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اللَّفِيفُ الْمَفْرُوقُ</span><span class="rule-table-ru">два разделённых слабых корня</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">وَقَى</span><span class="rule-table-ru">защитил</span></td></tr>
            <tr><td>Вторая и третья</td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اللَّفِيفُ الْمَقْرُونُ</span><span class="rule-table-ru">два соседних слабых корня</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">كَوَى</span><span class="rule-table-ru">прижёг</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Как установить происхождение ا</span>Сравните настоящее время или масдар: <span class="ar-inline" dir="rtl" lang="ar">قَالَ، يَقُولُ</span> и <span class="ar-inline" dir="rtl" lang="ar">خَافَ، خَوْفٌ</span> обнаруживают исходный <span class="ar-inline" dir="rtl" lang="ar">و</span>; <span class="ar-inline" dir="rtl" lang="ar">بَاعَ، يَبِيعُ</span> обнаруживает исходный <span class="ar-inline" dir="rtl" lang="ar">ي</span>.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Морфологическая модель</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Буква слова</th><th>Место в модели</th><th>Русское объяснение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ذ</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">فَاءُ الْفِعْلِ</span></td><td>первая коренная буква слова <span class="ar-inline" dir="rtl" lang="ar">ذَهَبَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ه</span></td><td><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">عَيْنُ الْفِعْلِ</span></td><td>вторая коренная буква</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">ب</span></td><td><span class="rule-table-ar ar-tone-object" dir="rtl" lang="ar">لَامُ الْفِعْلِ</span></td><td>третья коренная буква</td></tr>
          </tbody>
        </table></div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبَ: فَعَلَ.</span><span class="rule-example-ru">Глагол «пошёл» соответствует модели <span class="ar-inline" dir="rtl" lang="ar">فَعَلَ</span>.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">حَفِظَ: فَعِلَ.</span><span class="rule-example-ru">Глагол «выучил, сохранил» соответствует модели <span class="ar-inline" dir="rtl" lang="ar">فَعِلَ</span>.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الفعل المعتل:
هو ما كان أحد حروفه الأصلية حرف علة، وحروف العلة هي الألف والواو والياء، نحو: وجد، قال، رضي.
الفعل الصحيح: هو ما خلت حروفه الأصلية من حرف العلة.
فعل: الفاء والعين واللام تسمى الميزان الصرفي للفعل.
إذا كانت فاء الفعل حرف علة يسمى معتل الفاء أو المثال، وينقسم إلى مثال واوي نحو وقف، ومثال يائي نحو يبس.
إذا كانت عين الفعل حرف علة يسمى معتل العين أو الأجوف، وينقسم إلى أجوف واوي نحو زار يزور، وأجوف يائي نحو باع يبيع.
إذا كانت لام الفعل حرف علة يسمى معتل اللام أو الناقص، وينقسم إلى ناقص واوي نحو دعا يدعو، وناقص يائي نحو بكى يبكي.
إذا كانت فاء الفعل ولامه حرفي علة يسمى اللفيف المفروق، نحو وقى. وإذا كانت عينه ولامه حرفي علة يسمى اللفيف المقرون، نحو كوى.$$,
      60, 60, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الفعل المعتل الفاء: هو الذي في أوله حرف علة؛ نحو: وجد، وعد، وقف.
أحرف العلة ثلاثة، هي: الواو، والألف، والياء.
حرف العلة إذا كان في أول الفعل سمي الفعل مثالا، وإذا كان حرف العلة الذي في أول الفعل واوا سمي المثال الواوي.
الوزن (فعل) هو الميزان الصرفي للأفعال والأسماء. فالفعل ذهب وزنه فعل، والفعل حفظ وزنه فعل.
تقول في الفعل ذهب: حرف الذال فاء الفعل، وحرف الهاء عين الفعل، وحرف الباء لام الفعل؛ وذلك بناء على ترتيب الأحرف في الميزان فعل.$$,
      48, 48, 2);

  -- 2. Initial weak waw: deletion, retained waw, complete paradigms, and commands.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'الْمِثَالُ الْوَاوِيُّ وَحَذْفُ فَاءِ الْفِعْلِ (начальный слабый و и его выпадение)',
    rule_ar = 'يُحْذَفُ وَاوُ الْمِثَالِ الْوَاوِيِّ فِي الْمُضَارِعِ وَالْأَمْرِ إِذَا كَانَتْ عَيْنُ الْمُضَارِعِ مَكْسُورَةً، نَحْوُ: وَقَفَ، يَقِفُ، قِفْ. وَلَا تُحْذَفُ إِذَا كَانَتْ عَيْنُ الْمُضَارِعِ مَفْتُوحَةً أَوْ مَضْمُومَةً، نَحْوُ: وَجِلَ، يَوْجَلُ؛ وَوَجُهَ، يَوْجُهُ. وَقَدْ تُحْذَفُ فِي بَعْضِ الْأَفْعَالِ مَعَ أَنَّ عَيْنَ الْمُضَارِعِ غَيْرُ مَكْسُورَةٍ، نَحْوُ: وَضَعَ، يَضَعُ، ضَعْ؛ وَوَهَبَ، يَهَبُ، هَبْ.',
    summary = 'У الْمِثَالُ الْوَاوِيُّ начальный و выпадает в настоящем времени и повелительном наклонении, когда в настоящем времени вторая коренная имеет касру. Шархи приводят полный ряд форм, исключительные формы с фатхой и спряжение повелительного наклонения.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Когда начальный و выпадает</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">وَقَفَ</span>، <span class="ar-tone-verb">يَقِفُ</span>، <span class="ar-tone-verb">قِفْ</span>.</span><span class="rule-example-ru">Остановился; останавливается; остановись. В настоящем времени <span class="ar-inline" dir="rtl" lang="ar">عَيْنُ الْفِعْلِ</span> имеет касру, поэтому начальный <span class="ar-inline" dir="rtl" lang="ar">و</span> удаляется.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">وَجِلَ</span>، <span class="ar-tone-verb">يَوْجَلُ</span>.</span><span class="rule-example-ru">Испугался; боится. При фатхе второй коренной начальный <span class="ar-inline" dir="rtl" lang="ar">و</span> сохраняется.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">وَجُهَ</span>، <span class="ar-tone-verb">يَوْجُهُ</span>.</span><span class="rule-example-ru">Был знатным; бывает знатным. При дамме второй коренной начальный <span class="ar-inline" dir="rtl" lang="ar">و</span> сохраняется.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">وَضَعَ</span>، <span class="ar-tone-verb">يَضَعُ</span>، <span class="ar-tone-verb">ضَعْ</span>؛ <span class="ar-tone-verb">وَهَبَ</span>، <span class="ar-tone-verb">يَهَبُ</span>، <span class="ar-tone-verb">هَبْ</span>.</span><span class="rule-example-ru">Положил; кладёт; положи. Подарил; дарит; подари. Это приведённые шархом формы, где <span class="ar-inline" dir="rtl" lang="ar">و</span> выпадает при фатхе второй коренной.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Почему в форме приказа нет начального ا</span>После удаления <span class="ar-inline" dir="rtl" lang="ar">و</span> первая оставшаяся буква уже имеет огласовку, поэтому соединительная хамза не требуется: <span class="ar-inline" dir="rtl" lang="ar">قِفْ</span>, а не форма с добавленным алифом.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный ряд примеров из второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَاضِي</span><span class="rule-table-ru">прошедшее</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمُضَارِعُ</span><span class="rule-table-ru">настоящее</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْأَمْرُ</span><span class="rule-table-ru">повелительное</span></th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَجَدَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَجِدُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">جِدْ</span></td><td>нашёл; находит; найди</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَزَنَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَزِنُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">زِنْ</span></td><td>взвесил; взвешивает; взвесь</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَصَلَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَصِلُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">صِلْ</span></td><td>прибыл; прибывает; прибудь</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَقَفَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَقِفُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">قِفْ</span></td><td>остановился; останавливается; остановись</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَعَدَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَعِدُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">عِدْ</span></td><td>обещал; обещает; обещай</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَصَفَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَصِفُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">صِفْ</span></td><td>описал; описывает; опиши</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَعَظَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَعِظُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">عِظْ</span></td><td>наставил; наставляет; наставь</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَضَعَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَضَعُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">ضَعْ</span></td><td>положил; кладёт; положи</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَهَبَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَهَبُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">هَبْ</span></td><td>подарил; дарит; подари</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَقَعَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَقَعُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">قَعْ</span></td><td>упал; падает; упади</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَدَعَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَدَعُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">دَعْ</span></td><td>оставил; оставляет; оставь</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Повелительное наклонение по числу и роду</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَحْمَدُ، قِفْ.</span><span class="rule-example-ru">Ахмад, встань.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا فَاطِمَةُ، قِفِي.</span><span class="rule-example-ru">Фатима, встань.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَوْلَادُ، قِفُوا.</span><span class="rule-example-ru">Мальчики, встаньте.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا بَنَاتُ، قِفْنَ.</span><span class="rule-example-ru">Девочки, встаньте.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Сопоставление с الْمِثَالُ الْيَائِيُّ</span><span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">يَبِسَ، يَيْبَسُ، اِيبَسْ</span> — «высох; высыхает; высохни». Это отдельный пример с начальным <span class="ar-inline" dir="rtl" lang="ar">ي</span>.</div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$المثال الواوي:
1. يجب حذف الواو في المضارع والأمر إذا كانت عين الفعل المضارع مكسورة، نحو: وقف يقف قف.
2. لا تحذف الواو إذا كانت عين الفعل المضارع غير مكسورة، نحو: وجل يوجل، ووجه يوجه.
3. هناك أفعال تحذف فيها فاء الفعل مع أن عين الفعل [موضع غير واضح في المصدر]، نحو: وضع يضع ضع، وهب يهب هب، [موضع غير واضح في المصدر].
الأصل يوجد، حذفت منه الواو لأن عين الفعل المضارع مكسورة.
يا أحمد قف، يا فاطمة قفي، يا أولاد قفوا، يا بنات قفن.
يبس ييبس ايبس.$$,
      61, 61, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$وجد: يجد (أصله: يوجد مكسور العين، حذفت منه الواو).
وجد يجد جد
وزن يزن زن
وصل يصل صل
وقف يقف قف
وعد يعد عد
وصف يصف صف
وعظ يعظ عظ
وضع يضع ضع
وهب يهب هب
وقع يقع قع
ودع يدع دع.$$,
      48, 48, 2);

  -- 3. Diminutive of triliteral nouns.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'التَّصْغِيرُ عَلَى وَزْنِ فُعَيْلٍ (уменьшительная форма по модели فُعَيْلٌ)',
    rule_ar = 'التَّصْغِيرُ جَعْلُ الشَّيْءِ صَغِيرًا، وَهُوَ خَاصٌّ بِالْأَسْمَاءِ. وَيَكُونُ تَصْغِيرُ كُلِّ اسْمٍ ثُلَاثِيٍّ عَلَى وَزْنِ «فُعَيْلٍ».',
    summary = 'Уменьшительная форма образуется у имён. Для трёхбуквенного имени шархи дают модель فُعَيْلٌ и сохраняют несколько самостоятельных примеров.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Модель трёхбуквенного имени</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">التَّصْغِيرُ</span><span class="rule-term-ru">уменьшение предмета или уменьшительная форма имени.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-pattern" dir="rtl" lang="ar">فُعَيْلٌ</span><span class="rule-term-ru">морфологическая модель уменьшительной формы трёхбуквенного имени.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-subject" dir="rtl" lang="ar">خَاصٌّ بِالْأَسْمَاءِ</span><span class="rule-term-ru">эта форма относится к именам.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все различные примеры двух шархов</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Исходное выражение</th><th>Уменьшительная форма</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">وَلَدٌ صَغِيرٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">وُلَيْدٌ</span></td><td>маленький мальчик, мальчуган</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">جَبَلٌ صَغِيرٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">جُبَيْلٌ</span></td><td>маленькая гора, горка</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَهْرٌ صَغِيرٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">نُهَيْرٌ</span></td><td>маленькая река, речка</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">كَلْبٌ صَغِيرٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">كُلَيْبٌ</span></td><td>маленькая собака, собачка</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">اِبْنٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">بُنَيٌّ</span></td><td>сын — сынок</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">قَبْلُ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">قُبَيْلُ</span></td><td>до, прежде — незадолго до</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$التصغير:
تصغير الاسم الثلاثي يكون على وزن فعيل.
جبل: جبيل.
ابن: بني.
قبل: قبيل.$$,
      62, 62, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$التصغير: جعل الشيء صغيرا، والتصغير خاص بالأسماء.
تصغير الاسم الثلاثي يكون على وزن (فعيل).
ولد صغير: وليد.
جبل صغير: جبيل.
نهر صغير: نهير.
كلب صغير: كليب.$$,
      48, 48, 2);

  -- 4. The masdar pattern fa'al.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'الْمَصْدَرُ عَلَى وَزْنِ فَعَالٍ (масдар по модели فَعَالٌ)',
    rule_ar = 'مَصْدَرُ الْفِعْلِ «ذَهَبَ» هُوَ «ذَهَابٌ»، وَهُوَ عَلَى وَزْنِ «فَعَالٍ»، وَمِثْلُهُ «نَجَاحٌ».',
    summary = 'Подробный шарх отдельно фиксирует масдар ذَهَابٌ от ذَهَبَ и его морфологическую модель فَعَالٌ; к той же модели отнесено слово نَجَاحٌ.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Масдар и модель</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Слово</th><th>Морфологическая модель</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">ذَهَابٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">فَعَالٌ</span></td><td>уход, отправление; масдар глагола <span class="ar-inline" dir="rtl" lang="ar">ذَهَبَ</span> «пошёл»</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَجَاحٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">فَعَالٌ</span></td><td>успех; слово той же модели</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$المصدر (ذهاب) على وزن فعال، ومثله نجاح.$$,
      62, 62, 1);

  -- 5. The ha huwa dha construction and all forms supplied by the detailed sharh.
  update public.rules
  set
    sort_order = 5,
    rule_kind = 'rule',
    title = 'تَرْكِيبُ «هَا هُوَ ذَا» (конструкция «вот он»)',
    rule_ar = 'يَتَكَوَّنُ تَرْكِيبُ «هَا هُوَ ذَا» مِنْ «هَا» التَّنْبِيهِ، وَضَمِيرِ رَفْعٍ مُنْفَصِلٍ، وَاسْمِ إِشَارَةٍ لِلْقَرِيبِ. وَيَجُوزُ الْفَصْلُ بَيْنَ «هَا» التَّنْبِيهِ وَاسْمِ الْإِشَارَةِ بِالضَّمِيرِ، وَيُسْتَعْمَلُ اسْمُ الْإِشَارَةِ الْمُنَاسِبُ لِلْجِنْسِ وَالْعَدَدِ.',
    summary = 'В конструкции «вот он» частица привлечения внимания هَا отделяется от указательного местоимения личным местоимением. Подробный шарх даёт формы для лица, рода и числа.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Состав конструкции</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">هَا: حَرْفُ تَنْبِيهٍ</span><span class="rule-term-ru">частица привлечения внимания: «вот».</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-subject" dir="rtl" lang="ar">هُوَ: ضَمِيرُ رَفْعٍ مُنْفَصِلٌ</span><span class="rule-term-ru">отдельное личное местоимение в форме раф‘: «он».</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">ذَا: اسْمُ إِشَارَةٍ لِلْقَرِيبِ</span><span class="rule-term-ru">указательное местоимение для близкого предмета мужского рода: «этот».</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Допустимое разделение</span>Между <span class="ar-inline" dir="rtl" lang="ar">هَا</span> привлечения внимания и указательным местоимением можно поставить личное местоимение.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все формы из подробного шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Арабская форма</th><th>Русский перевод</th><th>Лицо, род и число</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَا هُوَ ذَا.</span></td><td>Вот он.</td><td>3-е лицо, мужской род, единственное число</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَا أَنْتَ ذَا.</span></td><td>Вот ты.</td><td>2-е лицо, мужской род, единственное число</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَا أَنَا ذَا.</span></td><td>Вот я.</td><td>1-е лицо, форма с указательным <span class="ar-inline" dir="rtl" lang="ar">ذَا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَا هِيَ ذِي.</span></td><td>Вот она.</td><td>3-е лицо, женский род, единственное число</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَا أَنْتِ ذِي.</span></td><td>Вот ты.</td><td>2-е лицо, женский род, единственное число</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَا نَحْنُ أُولَاءِ.</span></td><td>Вот мы.</td><td>1-е лицо, множественное число</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَا هُمْ أُولَاءِ.</span></td><td>Вот они.</td><td>3-е лицо, мужской род, множественное число</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَا أَنْتُمْ أُولَاءِ.</span></td><td>Вот вы.</td><td>2-е лицо, мужской род, множественное число</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَا هُنَّ أُولَاءِ.</span></td><td>Вот они.</td><td>3-е лицо, женский род, множественное число</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَا أَنْتُنَّ أُولَاءِ.</span></td><td>Вот вы.</td><td>2-е лицо, женский род, множественное число</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_5_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$ها هو ذا:
ها: حرف تنبيه.
هو: ضمير رفع منفصل.
ذا: اسم الإشارة للقريب (مفرد مذكر).
ها هو ذا، ها أنت ذا، ها أنا ذا، ها هي ذي، ها أنت ذي، ها نحن أولاء، ها هم أولاء، ها أنتم أولاء، ها هن أولاء، ها أنتن أولاء.
يجوز الفصل بين (ها) التنبيه واسم الإشارة بالضمير.$$,
      62, 62, 1);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '26'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 26 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id)
  ) <> 8 then
    raise exception 'Expected 8 Book 2 lesson 26 source rows';
  end if;

  if exists (
    select 1 from public.rules
    where id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id)
      and (content::text like '%←%' or content::text like '%→%')
  ) then
    raise exception 'Book 2 lesson 26 contains an RTL-hostile arrow';
  end if;
end
$migration$;

commit;
