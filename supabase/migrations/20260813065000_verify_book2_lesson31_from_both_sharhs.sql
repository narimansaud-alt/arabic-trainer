-- Verify Medina Book 2 lesson 31 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF page 75.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 62.

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
    and lesson_number = '31';

  if lesson_rule_count <> 3 then
    raise exception 'Expected 3 Book 2 lesson 31 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '31' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '31' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '31' and sort_order = 3;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id);

  -- 1. Definition and terminology.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'النَّعْتُ وَالْمَنْعُوتُ (определение и определяемое слово)',
    rule_ar = 'النَّعْتُ هُوَ التَّابِعُ الَّذِي يُبَيِّنُ صِفَةً مِنْ صِفَاتِ الْمَنْعُوتِ. وَيُسَمَّى النَّعْتُ صِفَةً، وَيُسَمَّى الْمَنْعُوتُ مَوْصُوفًا.',
    summary = 'النَّعْتُ — зависимое определение, которое называет признак определяемого слова. النَّعْتُ также называется صِفَةٌ, а الْمَنْعُوتُ — مَوْصُوفٌ.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Два элемента сочетания</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-subject" dir="rtl" lang="ar">الْمَنْعُوتُ</span><span class="rule-term-ru">определяемое слово: имя, признак которого раскрывает последующее определение.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-predicate" dir="rtl" lang="ar">النَّعْتُ</span><span class="rule-term-ru">определение или прилагательное, которое следует за определяемым словом.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">الصِّفَةُ</span><span class="rule-term-ru">другое название определения.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">الْمَوْصُوفُ</span><span class="rule-term-ru">другое название определяемого слова.</span></div>
        </div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا <span class="ar-tone-subject">كِتَابٌ</span> <span class="ar-tone-predicate">جَدِيدٌ</span>.</span><span class="rule-example-ru">Это новая книга: <span class="ar-inline" dir="rtl" lang="ar">كِتَابٌ</span> — определяемое слово, <span class="ar-inline" dir="rtl" lang="ar">جَدِيدٌ</span> — его определение.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الحادي والثلاثون:
متابعة النعت للمنعوت.$$,
      75, 75, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$النعت: هو الذي يبين صفة من صفات المنعوت.
النعت يسمى صفة، والمنعوت يسمى موصوفا.$$,
      62, 62, 2);

  -- 2. The four kinds of agreement and the complete source table.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'مُتَابَعَةُ النَّعْتِ لِلْمَنْعُوتِ فِي أَرْبَعَةِ أُمُورٍ (согласование определения с определяемым словом в четырёх признаках)',
    rule_ar = 'يَتْبَعُ النَّعْتُ الْمَنْعُوتَ فِي أَرْبَعَةِ أُمُورٍ: الْإِعْرَابِ، وَالتَّذْكِيرِ وَالتَّأْنِيثِ، وَالْإِفْرَادِ وَالتَّثْنِيَةِ وَالْجَمْعِ، وَالتَّعْرِيفِ وَالتَّنْكِيرِ. وَجَمْعُ غَيْرِ الْعَاقِلِ يُنْعَتُ بِالْمُفْرَدِ الْمُؤَنَّثِ، نَحْوُ: هَذِهِ كُتُبٌ جَدِيدَةٌ.',
    summary = 'Определение повторяет падеж, род, число и определённость определяемого слова. Строка جَمْعُ غَيْرِ الْعَاقِلِ показывает женское единственное определение при неодушевлённом множественном.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре направления согласования</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-case" dir="rtl" lang="ar">الْإِعْرَابُ</span><span class="rule-term-ru">раф‘, насб или джарр.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">التَّذْكِيرُ وَالتَّأْنِيثُ</span><span class="rule-term-ru">мужской или женский род.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">الْإِفْرَادُ وَالتَّثْنِيَةُ وَالْجَمْعُ</span><span class="rule-term-ru">единственное, двойственное или множественное число.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">التَّعْرِيفُ وَالتَّنْكِيرُ</span><span class="rule-term-ru">определённость или неопределённость.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полная таблица второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Признак</th><th><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">раф‘</span></th><th><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></th><th><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْإِعْرَابُ</span><span class="rule-table-ru">падеж</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذَا كِتَابٌ جَدِيدٌ.</span><span class="rule-table-ru">Это новая книга.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَرَأْتُ كِتَابًا جَدِيدًا.</span><span class="rule-table-ru">Я прочитал новую книгу.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِطَّلَعْتُ عَلَى كِتَابٍ جَدِيدٍ.</span><span class="rule-table-ru">Я ознакомился с новой книгой.</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">التَّذْكِيرُ</span><span class="rule-table-ru">мужской род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَامِدٌ رَجُلٌ صَالِحٌ.</span><span class="rule-table-ru">Хамид — праведный мужчина.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَأَلْتُ رَجُلًا صَالِحًا.</span><span class="rule-table-ru">Я спросил праведного мужчину.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَافَرْتُ مَعَ رَجُلٍ صَالِحٍ.</span><span class="rule-table-ru">Я путешествовал с праведным мужчиной.</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">التَّأْنِيثُ</span><span class="rule-table-ru">женский род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فَاطِمَةُ بِنْتٌ صَالِحَةٌ.</span><span class="rule-table-ru">Фатима — праведная девушка.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَزَوَّجْتُ امْرَأَةً صَالِحَةً.</span><span class="rule-table-ru">Я женился на праведной женщине.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمَسَّكْتُ بِالزَّوْجَةِ الصَّالِحَةِ.</span><span class="rule-table-ru">Я держался праведной жены.</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْإِفْرَادُ</span><span class="rule-table-ru">единственное число</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذَا كِتَابٌ جَدِيدٌ.</span><span class="rule-table-ru">Это новая книга.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَرَأْتُ كِتَابًا جَدِيدًا.</span><span class="rule-table-ru">Я прочитал новую книгу.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِطَّلَعْتُ عَلَى كِتَابٍ جَدِيدٍ.</span><span class="rule-table-ru">Я ознакомился с новой книгой.</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">التَّثْنِيَةُ</span><span class="rule-table-ru">двойственное число</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذَانِ كِتَابَانِ جَدِيدَانِ.</span><span class="rule-table-ru">Это две новые книги.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَرَأْتُ كِتَابَيْنِ جَدِيدَيْنِ.</span><span class="rule-table-ru">Я прочитал две новые книги.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِطَّلَعْتُ عَلَى كِتَابَيْنِ جَدِيدَيْنِ.</span><span class="rule-table-ru">Я ознакомился с двумя новыми книгами.</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْجَمْعُ</span><span class="rule-table-ru">множественное число</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذِهِ كُتُبٌ جَدِيدَةٌ.</span><span class="rule-table-ru">Это новые книги.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَرَأْتُ كُتُبًا جَدِيدَةً.</span><span class="rule-table-ru">Я прочитал новые книги.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِطَّلَعْتُ عَلَى كُتُبٍ جَدِيدَةٍ.</span><span class="rule-table-ru">Я ознакомился с новыми книгами.</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">التَّعْرِيفُ</span><span class="rule-table-ru">определённость</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْكِتَابُ الْجَدِيدُ غَالٍ.</span><span class="rule-table-ru">Новая книга дорогая.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَرَأْتُ الْكِتَابَ الْجَدِيدَ.</span><span class="rule-table-ru">Я прочитал новую книгу.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِطَّلَعْتُ عَلَى الْكِتَابِ الْجَدِيدِ.</span><span class="rule-table-ru">Я ознакомился с новой книгой.</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">التَّنْكِيرُ</span><span class="rule-table-ru">неопределённость</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذَا كِتَابٌ جَدِيدٌ.</span><span class="rule-table-ru">Это новая книга.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَرَأْتُ كِتَابًا جَدِيدًا.</span><span class="rule-table-ru">Я прочитал новую книгу.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِطَّلَعْتُ عَلَى كِتَابٍ جَدِيدٍ.</span><span class="rule-table-ru">Я ознакомился с новой книгой.</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Неодушевлённое множественное</span>В строке <span class="ar-inline" dir="rtl" lang="ar">هَذِهِ كُتُبٌ جَدِيدَةٌ</span> слово <span class="ar-inline" dir="rtl" lang="ar">كُتُبٌ</span> является неодушевлённым множественным, поэтому определение имеет форму женского единственного <span class="ar-inline" dir="rtl" lang="ar">جَدِيدَةٌ</span>.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Дополнительные сочетания подробного шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">وَلَدٌ صَغِيرٌ.</span><span class="rule-example-ru">Маленький мальчик: мужской род, неопределённость, единственное число, раф‘.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">بِنْتٌ صَغِيرَةٌ.</span><span class="rule-example-ru">Маленькая девочка: женский род, неопределённость, единственное число, раф‘.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْوَلَدَانِ الصَّغِيرَانِ.</span><span class="rule-example-ru">Два маленьких мальчика: мужской род, определённость, двойственное число, раф‘.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْبَنَاتُ الصَّغِيرَاتُ.</span><span class="rule-example-ru">Маленькие девочки: женский род, определённость, множественное число, раф‘.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$متابعة النعت للمنعوت:
يتبع النعت المنعوت في الإعراب، والإفراد والتثنية والجمع، والتعريف والتنكير، والتذكير والتأنيث.
ولد صغير، بنت صغيرة، الولدان الصغيران، البنات الصغيرات.
هنا النعت تبع المنعوت في التذكير والتنكير والإفراد والإعراب.
هنا النعت تبع المنعوت في التأنيث والتنكير والإفراد والإعراب.
هنا النعت تبع المنعوت في التذكير والتعريف والتثنية والإعراب.
هنا النعت تبع المنعوت في التأنيث والتعريف والجمع والإعراب.$$,
      75, 75, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$النعت يتبع المنعوت في الأمور الآتية:
الإعراب: هذا كتاب جديد، قرأت كتابا جديدا، اطلعت على كتاب جديد.
التذكير: حامد رجل صالح، سألت رجلا صالحا، سافرت مع رجل صالح.
التأنيث: فاطمة بنت صالحة، تزوجت امرأة صالحة، تمسكت بالزوجة الصالحة.
الإفراد: هذا كتاب جديد، قرأت كتابا جديدا، اطلعت على كتاب جديد.
التثنية: هذان كتابان جديدان، قرأت كتابين جديدين، اطلعت على كتابين جديدين.
الجمع: هذه كتب جديدة، قرأت كتبا جديدة، اطلعت على كتب جديدة.
التعريف: الكتاب الجديد غال، قرأت الكتاب الجديد، اطلعت على الكتاب الجديد.
التنكير: هذا كتاب جديد، قرأت كتابا جديدا، اطلعت على كتاب جديد.$$,
      62, 62, 2);

  -- 3. Full analysis procedure and the two source examples.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'note',
    title = 'تَحْلِيلُ النَّعْتِ وَالْمَنْعُوتِ (анализ определения и определяемого слова)',
    rule_ar = 'عِنْدَ تَحْلِيلِ النَّعْتِ وَالْمَنْعُوتِ يُحَدَّدُ إِعْرَابُ الْمَنْعُوتِ وَجِنْسُهُ وَعَدَدُهُ وَتَعْرِيفُهُ أَوْ تَنْكِيرُهُ، ثُمَّ يُحْكَمُ لِلنَّعْتِ بِمِثْلِ ذَلِكَ تَمَامًا؛ لِأَنَّهُ تَابِعٌ لَهُ.',
    summary = 'Для анализа сначала определяют у الْمَنْعُوتُ падеж, род, число и определённость; затем проверяют те же четыре характеристики у النَّعْتُ, потому что оно следует за определяемым словом.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Два полных разбора из второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Предложение</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَنْعُوتُ</span><span class="rule-table-ru">определяемое слово</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">النَّعْتُ</span><span class="rule-table-ru">определение</span></th><th>Почему совпадают</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذَا كِتَابٌ جَدِيدٌ.</span><span class="rule-table-ru">Это новая книга.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">كِتَابٌ: مَرْفُوعٌ، مُذَكَّرٌ، مُفْرَدٌ، نَكِرَةٌ</span><span class="rule-table-ru">раф‘, мужской род, единственное число, неопределённое</span></td><td><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">جَدِيدٌ: مَرْفُوعٌ، مُذَكَّرٌ، مُفْرَدٌ، نَكِرَةٌ</span><span class="rule-table-ru">полностью повторяет признаки</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لِأَنَّهُ تَابِعٌ لَهُ</span><span class="rule-table-ru">потому что определение зависит от определяемого слова</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">تَزَوَّجْتُ الْمَرْأَتَيْنِ الصَّالِحَتَيْنِ.</span><span class="rule-table-ru">Я женился на двух праведных женщинах.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">الْمَرْأَتَيْنِ: مَنْصُوبٌ، مُؤَنَّثٌ، مُثَنًّى، مَعْرِفَةٌ</span><span class="rule-table-ru">насб, женский род, двойственное число, определённое</span></td><td><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">الصَّالِحَتَيْنِ: مَنْصُوبٌ، مُؤَنَّثٌ، مُثَنًّى، مَعْرِفَةٌ</span><span class="rule-table-ru">полностью повторяет признаки</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لِأَنَّهُ تَابِعٌ لَهُ</span><span class="rule-table-ru">потому что определение зависит от определяемого слова</span></td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$ولد صغير: هنا النعت تبع المنعوت في التذكير والتنكير والإفراد والإعراب.
بنت صغيرة: هنا النعت تبع المنعوت في التأنيث والتنكير والإفراد والإعراب.
الولدان الصغيران: هنا النعت تبع المنعوت في التذكير والتعريف والتثنية والإعراب.
البنات الصغيرات: هنا النعت تبع المنعوت في التأنيث والتعريف والجمع والإعراب.$$,
      75, 75, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$هذا كتاب جديد:
المنعوت في هذا المثال: مرفوع، مذكر، مفرد، نكرة. وكذلك النعت مثله تماما؛ لأنه تابع له.
تزوجت المرأتين الصالحتين:
المنعوت في هذا المثال: منصوب، مؤنث، مثنى، معرفة. وكذلك النعت مثله تماما؛ لأنه تابع له.$$,
      62, 62, 2);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '31'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 31 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id)
  ) <> 6 then
    raise exception 'Expected 6 Book 2 lesson 31 source rows';
  end if;

  if exists (
    select 1 from public.rules
    where id in (rule_1_id, rule_2_id, rule_3_id)
      and (content::text like '%←%' or content::text like '%→%')
  ) then
    raise exception 'Book 2 lesson 31 contains an RTL-hostile arrow';
  end if;
end
$migration$;

commit;
