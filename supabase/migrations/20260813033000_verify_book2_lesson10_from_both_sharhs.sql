-- Verify Medina Book 2 lesson 10 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 27-30.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 23.
-- The second PDF has a damaged logical text layer. Its source_text below is a
-- literal manual transcription from the rendered page, authorized by the owner.
-- Public rule_ar is independently formulated and fully vocalized.

begin;

do $migration$
declare
  lesson_rule_count integer;
  verified_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
  rule_4_id bigint;
begin
  select count(*), count(*) filter (where coalesce(rule_ar, '') <> '')
  into lesson_rule_count, verified_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '10';

  if lesson_rule_count <> 4 or verified_rule_count not in (0, 4) then
    raise exception 'Expected 4 uniformly verified/unverified Book 2 lesson 10 rules, found % rules and % verified', lesson_rule_count, verified_rule_count;
  end if;

  select id into strict rule_1_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '10' and sort_order = 1;

  select id into strict rule_2_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '10' and sort_order = 2;

  select id into strict rule_3_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '10' and sort_order = 3;

  select id into strict rule_4_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '10' and sort_order = 4;

  delete from public.rule_sections
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id);

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id);

  -- 1. Past and present verb forms shown in the second sharh.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'الْفِعْلُ الْمَاضِي وَالْفِعْلُ الْمُضَارِعُ (глагол прошедшего и настоящего/будущего времени)',
    rule_ar = 'الْفِعْلُ الْمَاضِي مَبْنِيٌّ عَلَى الْفَتْحَةِ، وَالْفِعْلُ الْمُضَارِعُ فِي هَذِهِ الْأَمْثِلَةِ مَرْفُوعٌ بِالضَّمَّةِ.',
    summary = 'Глагол прошедшего времени строится на фатхе; глагол настоящего/будущего времени в приведённых примерах стоит в состоянии رفع с даммой.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Правило из шарха</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">الْفِعْلُ الْمَاضِي</span> مَبْنِيٌّ عَلَى <span class="ar-tone-structure">الْفَتْحَةِ</span>، وَ<span class="ar-tone-verb">الْفِعْلُ الْمُضَارِعُ</span> فِي هَذِهِ الْأَمْثِلَةِ <span class="ar-tone-raf">مَرْفُوعٌ بِالضَّمَّةِ</span>.</span>
        <p class="rule-study-text">Глагол прошедшего времени строится на фатхе. Глагол настоящего/будущего времени в приведённых примерах стоит в состоянии <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">رَفْعٌ</span> с даммой.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Формы из шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Прошедшее</th><th>Настоящее/будущее</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">ذَهَبَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَذْهَبُ</span></td><td>ушёл - уходит</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">رَكَعَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَرْكَعُ</span></td><td>совершил поясной поклон - совершает поясной поклон</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">فَهِمَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَفْهَمُ</span></td><td>понял - понимает</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">حَفِظَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَحْفَظُ</span></td><td>выучил - заучивает</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">كَتَبَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَكْتُبُ</span></td><td>написал - пишет</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَزَلَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَنْزِلُ</span></td><td>спустился - спускается</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Парные предложения из шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">سَجَدَ</span> الْمُسْلِمُ لِلَّهِ. <span class="ar-tone-verb">يَسْجُدُ</span> الْمُسْلِمُ لِلَّهِ.</span><span class="rule-example-ru">Мусульманин совершил земной поклон Аллаху. Мусульманин совершает земной поклон Аллаху.</span></div>
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">غَسَلَ</span> الرَّجُلُ ثَوْبَهُ. <span class="ar-tone-verb">يَغْسِلُ</span> الرَّجُلُ ثَوْبَهُ.</span><span class="rule-example-ru">Мужчина выстирал свою одежду. Мужчина стирает свою одежду.</span></div>
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">فَهِمَ</span> الطَّالِبُ الدَّرْسَ. <span class="ar-tone-verb">يَفْهَمُ</span> الطَّالِبُ الدَّرْسَ.</span><span class="rule-example-ru">Студент понял урок. Студент понимает урок.</span></div>
          <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">قَرَأَ</span> حَمَدٌ الْقُرْآنَ. <span class="ar-tone-verb">يَقْرَأُ</span> حَمَدٌ الْقُرْآنَ.</span><span class="rule-example-ru">Хамад прочитал Коран. Хамад читает Коран.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الفِعْلُ المَاضِي ، والفِعْلُ المُضَارِعُ
الفعلُ الماضي : مَبْنِيٌّ على الفَتْحَةِ ، نحو : ذَهَبَ ، رَكَعَ ، فَهِمَ ، حَفِظَ ، كَتَبَ ، نَزَلَ .
الفعلُ المضارعُ : مرفوعٌ بالضَّمَّةِ ، نحو : يَذْهَبُ ، يَرْكَعُ ، يَفْهَمُ ، يَحْفَظُ ، يَكْتُبُ ، يَنْزِلُ .
أمثلة : سَجَدَ المسلمُ للهِ ، يَسْجُدُ المسلمُ للهِ . غَسَلَ الرجلُ ثوبَهُ ، يَغْسِلُ الرجلُ ثوبَهُ .
فَهِمَ الطالبُ الدرسَ ، يَفْهَمُ الطالبُ الدرسَ . قَرَأَ حَمَدٌ القرآنَ ، يَقْرَأُ حَمَدٌ القرآنَ .$$, 23, 23, 1);

  -- 2. Four source vowel-pattern pairs.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'أَبْوَابُ الْمَاضِي وَالْمُضَارِعِ (огласовочные модели прошедшего и настоящего времени)',
    rule_ar = 'مِنْ أَبْوَابِ الْفِعْلِ الثُّلَاثِيِّ الْمُجَرَّدِ فِي هَذَا الدَّرْسِ: فَعَلَ يَفْعَلُ، وَفَعَلَ يَفْعِلُ، وَفَعَلَ يَفْعُلُ، وَفَعِلَ يَفْعَلُ.',
    summary = 'В уроке показаны четыре модели соотношения огласовок прошедшего и настоящего времени трёхбуквенного непроизводного глагола.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре модели из обоих шархов</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">مِنْ أَبْوَابِ <span class="ar-tone-structure">الْفِعْلِ الثُّلَاثِيِّ الْمُجَرَّدِ</span> فِي هَذَا الدَّرْسِ: <span class="ar-tone-verb">فَعَلَ يَفْعَلُ، وَفَعَلَ يَفْعِلُ، وَفَعَلَ يَفْعُلُ، وَفَعِلَ يَفْعَلُ</span>.</span>
        <p class="rule-study-text">Это четыре показанные в шархах модели соотношения огласовок прошедшего и настоящего времени трёхбуквенного непроизводного глагола.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Модели и все приведённые пары</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Модель</th><th>Примеры из шархов</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">فَعَلَ يَفْعَلُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">ذَهَبَ - يَذْهَبُ؛ رَكَعَ - يَرْكَعُ.</span></td><td>уйти - уходить; совершить поясной поклон - совершать поясной поклон</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">فَعَلَ يَفْعِلُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">جَلَسَ - يَجْلِسُ؛ رَجَعَ - يَرْجِعُ.</span></td><td>сесть - сидеть; вернуться - возвращаться</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">فَعَلَ يَفْعُلُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">كَتَبَ - يَكْتُبُ؛ سَجَدَ - يَسْجُدُ.</span></td><td>написать - писать; совершить земной поклон - совершать земной поклон</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">فَعِلَ يَفْعَلُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">سَمِعَ - يَسْمَعُ؛ حَفِظَ - يَحْفَظُ.</span></td><td>услышать - слышать; выучить - заучивать</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-check-card"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">سَنَدْرُسُ بَقِيَّةَ الْأَبْوَابِ فِي الْمُسْتَوَيَاتِ الْأُخْرَى إِنْ شَاءَ اللَّهُ.</span><br>Остальные модели будут изучаться на других уровнях, если пожелает Аллах.</div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$هذه بعض أبواب من الفعل الثلاثي المجرد:
فَعَلَ - يَفْعَلُ، نحو: ذَهَبَ - يَذْهَبُ.
فَعَلَ - يَفْعِلُ، نحو: جَلَسَ - يَجْلِسُ.
فَعَلَ - يَفْعُلُ، نحو: كَتَبَ - يَكْتُبُ.
فَعِلَ - يَفْعَلُ، نحو: سَمِعَ - يَسْمَعُ.
سندرس بقية الأبواب في المستويات الأخرى إن شاء الله.$$, 27, 27, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$من أبواب الماضي والمضارع :
١- فَعَلَ : يَفْعَلُ ← ذَهَبَ يَذْهَبُ ، رَكَعَ يَرْكَعُ .
٢- فَعَلَ : يَفْعُلُ ← كَتَبَ يَكْتُبُ ، سَجَدَ يَسْجُدُ .
٣- فَعَلَ : يَفْعِلُ ← جَلَسَ يَجْلِسُ ، رَجَعَ يَرْجِعُ .
٤- فَعِلَ : يَفْعَلُ ← سَمِعَ يَسْمَعُ ، حَفِظَ يَحْفَظُ .$$, 23, 23, 2);

  -- 3. Conjoined numbers 21-99 with every distinct source example.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'الْعَدَدُ الْمَعْطُوفُ مِنْ ٢١ إِلَى ٩٩ (составные числительные от 21 до 99)',
    rule_ar = 'الْعَدَدُ الْمَعْطُوفُ مِنْ ٢١ إِلَى ٩٩ مُكَوَّنٌ مِنْ جُزْأَيْنِ بَيْنَهُمَا وَاوُ الْعَطْفِ؛ يُوَافِقُ الْجُزْءُ الْأَوَّلُ الْمَعْدُودَ فِي ١ وَ٢، وَيُخَالِفُهُ فِي ٣-٩، وَلَا تَتَغَيَّرُ أَلْفَاظُ الْعُقُودِ مَعَ الْمُذَكَّرِ وَالْمُؤَنَّثِ، وَيَكُونُ الْمَعْدُودُ مُفْرَدًا مَنْصُوبًا.',
    summary = 'В числах 21-99 единицы соединяются с десятками союзом وَ; 1 и 2 согласуются с считаемым, 3-9 противопоставляются ему по роду, десятки не меняются по роду, а считаемое стоит в единственном числе и винительном падеже.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полное правило из двух шархов</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الْعَدَدُ الْمَعْطُوفُ</span> مِنْ ٢١ إِلَى ٩٩ مُكَوَّنٌ مِنْ جُزْأَيْنِ بَيْنَهُمَا <span class="ar-tone-structure">وَاوُ الْعَطْفِ</span>؛ يُوَافِقُ الْجُزْءُ الْأَوَّلُ <span class="ar-tone-subject">الْمَعْدُودَ</span> فِي ١ وَ٢، وَيُخَالِفُهُ فِي ٣-٩، وَلَا تَتَغَيَّرُ <span class="ar-tone-structure">أَلْفَاظُ الْعُقُودِ</span> مَعَ الْمُذَكَّرِ وَالْمُؤَنَّثِ، وَيَكُونُ الْمَعْدُودُ <span class="ar-tone-nasb">مُفْرَدًا مَنْصُوبًا</span>.</span>
        <p class="rule-study-text">В числах от 21 до 99 единицы соединяются с десятками союзом <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">وَ</span>. Числа 1 и 2 согласуются с считаемым по роду, числа 3-9 имеют противоположный род. Формы десятков 20-90 не меняются по роду. Считаемое слово стоит в единственном числе и винительном падеже.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Термины</span>
        <div class="rule-meaning-grid">
          <div><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">الْعَدَدُ الْمَعْطُوفُ</span><span>составное числительное с союзом</span></div>
          <div><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">وَاوُ الْعَطْفِ</span><span>соединительный союз وَ</span></div>
          <div><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">أَلْفَاظُ الْعُقُودِ</span><span>названия десятков 20-90</span></div>
          <div><span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">الْمَعْدُودُ</span><span>считаемое слово</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все отдельные примеры обоих шархов</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Число</th><th>С мужским считаемым</th><th>С женским считаемым</th></tr></thead>
          <tbody>
            <tr><td>21</td><td><span class="rule-table-ar" dir="rtl" lang="ar">وَاحِدٌ وَعِشْرُونَ طَالِبًا.</span><span class="rule-table-ru">Двадцать один студент.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">إِحْدَى وَعِشْرُونَ طَالِبَةً.</span><span class="rule-table-ru">Двадцать одна студентка.</span></td></tr>
            <tr><td>22</td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِثْنَانِ وَعِشْرُونَ طَالِبًا.</span><span class="rule-table-ru">Двадцать два студента.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِثْنَتَانِ وَعِشْرُونَ طَالِبَةً.</span><span class="rule-table-ru">Двадцать две студентки.</span></td></tr>
            <tr><td>23</td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِي الْمَدِينَةِ ثَلَاثَةٌ وَعِشْرُونَ فُنْدُقًا.</span><span class="rule-table-ru">В городе двадцать три гостиницы.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِي الْمَدِينَةِ ثَلَاثٌ وَعِشْرُونَ حَدِيقَةً.</span><span class="rule-table-ru">В городе двадцать три сада.</span></td></tr>
            <tr><td>24</td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجَ أَرْبَعَةٌ وَعِشْرُونَ طَالِبًا.</span><span class="rule-table-ru">Вышли двадцать четыре студента.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجَ أَرْبَعٌ وَعِشْرُونَ طَالِبَةً.</span><span class="rule-table-ru">Вышли двадцать четыре студентки.</span></td></tr>
            <tr><td>25</td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِي الْمَعْهَدِ خَمْسَةٌ وَعِشْرُونَ فَصْلًا.</span><span class="rule-table-ru">В институте двадцать пять аудиторий.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِي الْمَعْهَدِ خَمْسٌ وَعِشْرُونَ سَبُّورَةً.</span><span class="rule-table-ru">В институте двадцать пять досок.</span></td></tr>
            <tr><td>26</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ثَمَنُ الْقَلَمِ سِتَّةٌ وَعِشْرُونَ رِيَالًا.</span><span class="rule-table-ru">Цена ручки - двадцать шесть риялов.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ثَمَنُ الْقَلَمِ سِتٌّ وَعِشْرُونَ رُوبِيَّةً.</span><span class="rule-table-ru">Цена ручки - двадцать шесть рупий.</span></td></tr>
            <tr><td>27</td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَافَرَ سَبْعَةٌ وَعِشْرُونَ طَالِبًا.</span><span class="rule-table-ru">Уехали двадцать семь студентов.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَافَرَ سَبْعٌ وَعِشْرُونَ طَالِبَةً.</span><span class="rule-table-ru">Уехали двадцать семь студенток.</span></td></tr>
            <tr><td>28</td><td><span class="rule-table-ar" dir="rtl" lang="ar">جَاءَ ثَمَانِيَةٌ وَعِشْرُونَ طَالِبًا.</span><span class="rule-table-ru">Пришли двадцать восемь студентов.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَافَرَ ثَمَانٍ وَعِشْرُونَ طَالِبَةً.</span><span class="rule-table-ru">Уехали двадцать восемь студенток.</span></td></tr>
            <tr><td>29</td><td><span class="rule-table-ar" dir="rtl" lang="ar">جَاءَ تِسْعَةٌ وَعِشْرُونَ طَالِبًا.</span><span class="rule-table-ru">Пришли двадцать девять студентов.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تِسْعٌ وَعِشْرُونَ طَالِبَةً.</span><span class="rule-table-ru">Двадцать девять студенток.</span></td></tr>
            <tr><td>30</td><td colspan="2"><span class="rule-table-ar" dir="rtl" lang="ar">جَاءَ ثَلَاثُونَ طَالِبًا وَثَلَاثُونَ طَالِبَةً.</span><span class="rule-table-ru">Пришли тридцать студентов и тридцать студенток.</span></td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$العدد المعطوف
العدد المعطوف مكون من جزئين أحدهما مفرد والآخر عقد وبينهما واو العطف. والأعداد المعطوفة تبدأ من واحد وعشرين (٢١) إلى تسعة وتسعين (٩٩)، نحو: واحد وعشرون، وخمسة وثلاثون.
يكون معدوده دائما مفردا منصوبا، نحو: خمسة وعشرون طالبا.
في واحد وعشرين (٢١) واثنان وعشرين (٢٢) الجزء الأول (١، ٢) يوافق المعدود، ومن ثلاثة وعشرين (٢٣) إلى تسعة وعشرين (٢٩) الجزء الأول (من ٣-٩) يخالف المعدود في التذكير والتأنيث.
واحد وعشرون طالبا، إحدى وعشرون طالبة.
اثنان وعشرون طالبا، اثنتان وعشرون طالبة.
ثلاثة وعشرون طالبا، ثلاث وعشرون طالبة.
أربعة وعشرون طالبا، أربع وعشرون طالبة.
خمسة وعشرون طالبا، خمس وعشرون طالبة.
ستة وعشرون طالبا، ست وعشرون طالبة.
سبعة وعشرون طالبا، سبع وعشرون طالبة.
ثمانية وعشرون طالبا، ثمان وعشرون طالبة.
تسعة وعشرون طالبا، تسع وعشرون طالبة.$$, 28, 28, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الأَعْدَادُ المَعْطُوفَةُ ، وَأَلْفَاظُ العُقُودِ
الأعدادُ المعطوفةُ: من ٢١ إلى ٩٩ (الجزءُ الأولُ من ١ إلى ٩ ، والجزءُ الثاني ألفاظُ العقودِ).
العددانِ ١ و٢ يوافقانِ المعدودَ ، والأعدادُ من ٣ إلى ٩ تُخَالِفُ المعدودَ .
ألفاظُ العقودِ : هي الأعدادُ من ٢٠ إلى ٩٠ ، وهي لا تَتَغَيَّرُ مع المعدودِ .
تقول : وَاحِدٌ وَعِشْرُونَ طَالِبًا ، إِحْدَى وَعِشْرُونَ طَالِبَةً .
اِثْنَانِ وَعِشْرُونَ طَالِبًا ، اِثْنَتَانِ وَعِشْرُونَ طَالِبَةً .
فِي المَدِينَةِ ثَلَاثَةٌ وَعِشْرُونَ فُنْدُقًا . فِي المَدِينَةِ ثَلَاثٌ وَعِشْرُونَ حَدِيقَةً .
خَرَجَ أَرْبَعَةٌ وَعِشْرُونَ طَالِبًا . خَرَجَ أَرْبَعٌ وَعِشْرُونَ طَالِبَةً .
فِي المَعْهَدِ خَمْسَةٌ وَعِشْرُونَ فَصْلًا . فِي المَعْهَدِ خَمْسٌ وَعِشْرُونَ سَبُّورَةً .
ثَمَنُ القَلَمِ سِتَّةٌ وَعِشْرُونَ رِيَالًا . ثَمَنُ القَلَمِ سِتٌّ وَعِشْرُونَ رُوبِيَّةً .
سَافَرَ سَبْعَةٌ وَعِشْرُونَ طَالِبًا . سَافَرَ سَبْعٌ وَعِشْرُونَ طَالِبَةً .
جَاءَ ثَمَانِيَةٌ وَعِشْرُونَ طَالِبًا . سَافَرَ ثَمَانٍ وَعِشْرُونَ طَالِبَةً .
جَاءَ تِسْعَةٌ وَعِشْرُونَ طَالِبًا . جَاءَ ثَلَاثُونَ طَالِبًا وَثَلَاثُونَ طَالِبَةً .
(الواوُ حرفُ عطفٍ في كُلِّ الأمثلةِ)$$, 23, 23, 2);

  -- 4. Complete clock table found only in the 80-page sharh.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'السَّاعَةُ (обозначение времени по часам)',
    rule_ar = 'تُقَالُ السَّاعَةُ وَالدَّقَائِقُ كَمَا فِي الْأَمْثِلَةِ، وَيُسْتَعْمَلُ الرُّبْعُ وَالثُّلُثُ وَالنِّصْفُ، وَيُسْتَعْمَلُ «إِلَّا» مَعَ السَّاعَةِ التَّالِيَةِ.',
    summary = 'Время называется по часу и минутам; используются также выражения с четвертью, третью и половиной, а после половины - конструкция с إِلَّا и следующим часом.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Схема из шарха</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">تُقَالُ <span class="ar-tone-structure">السَّاعَةُ وَالدَّقَائِقُ</span> كَمَا فِي الْأَمْثِلَةِ، وَيُسْتَعْمَلُ <span class="ar-tone-subject">الرُّبْعُ وَالثُّلُثُ وَالنِّصْفُ</span>، وَيُسْتَعْمَلُ <span class="ar-tone-structure">«إِلَّا»</span> مَعَ السَّاعَةِ التَّالِيَةِ.</span>
        <p class="rule-study-text">Время называется по часу и минутам. В шархе даны также формы «четверть», «треть», «половина» и выражения со словом <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">إِلَّا</span> - «без» - перед следующим часом.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полная таблица времени из шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Время</th><th>Арабское выражение</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td>1:00</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ.</span></td><td>Один час.</td></tr>
            <tr><td>1:05</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَخَمْسُ دَقَائِقَ.</span></td><td>Один час пять минут.</td></tr>
            <tr><td>1:10</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَعَشْرُ دَقَائِقَ.</span></td><td>Один час десять минут.</td></tr>
            <tr><td>1:15</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَخَمْسَ عَشْرَةَ دَقِيقَةً.<br>السَّاعَةُ الْوَاحِدَةُ وَالرُّبُعُ / وَالرُّبْعُ.</span></td><td>Один час пятнадцать минут; четверть второго.</td></tr>
            <tr><td>1:20</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَعِشْرُونَ دَقِيقَةً.<br>السَّاعَةُ الْوَاحِدَةُ وَالثُّلُثُ / وَالثُّلْثُ.</span></td><td>Один час двадцать минут; час и треть.</td></tr>
            <tr><td>1:25</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَخَمْسٌ وَعِشْرُونَ دَقِيقَةً.</span></td><td>Один час двадцать пять минут.</td></tr>
            <tr><td>1:30</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَثَلَاثُونَ دَقِيقَةً.<br>السَّاعَةُ الْوَاحِدَةُ وَالنِّصْفُ.</span></td><td>Один час тридцать минут; половина второго.</td></tr>
            <tr><td>1:35</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَالنِّصْفُ وَخَمْسُ دَقَائِقَ.<br>السَّاعَةُ الْوَاحِدَةُ وَخَمْسٌ وَثَلَاثُونَ دَقِيقَةً.</span></td><td>Один час тридцать пять минут; час с половиной и пять минут.</td></tr>
            <tr><td>1:40</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَأَرْبَعُونَ دَقِيقَةً.<br>السَّاعَةُ الثَّانِيَةُ إِلَّا ثُلْثًا.</span></td><td>Один час сорок минут; без двадцати два.</td></tr>
            <tr><td>1:45</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَخَمْسٌ وَأَرْبَعُونَ دَقِيقَةً.<br>السَّاعَةُ الثَّانِيَةُ إِلَّا رُبْعًا.</span></td><td>Один час сорок пять минут; без четверти два.</td></tr>
            <tr><td>1:50</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَخَمْسُونَ دَقِيقَةً.<br>السَّاعَةُ الثَّانِيَةُ إِلَّا عَشْرَ دَقَائِقَ.</span></td><td>Один час пятьдесят минут; без десяти два.</td></tr>
            <tr><td>1:55</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الْوَاحِدَةُ وَخَمْسٌ وَخَمْسُونَ دَقِيقَةً.<br>السَّاعَةُ الثَّانِيَةُ إِلَّا خَمْسَ دَقَائِقَ.</span></td><td>Один час пятьдесят пять минут; без пяти два.</td></tr>
            <tr><td>2:00</td><td><span class="rule-table-ar" dir="rtl" lang="ar">السَّاعَةُ الثَّانِيَةُ.</span></td><td>Два часа.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$الساعة
١:٠٠ الساعة الواحدة
١:٠٥ الساعة الواحدة وخمس دقائق
١:١٠ الساعة الواحدة وعشر دقائق
١:١٥ الساعة الواحدة وخمس عشرة دقيقة
الساعة الواحدة والربع (بضم الباء وسكونها)
١:٢٠ الساعة الواحدة وعشرون دقيقة
الساعة الواحدة والثلث (بضم اللام وسكونها)
١:٢٥ الساعة الواحدة وخمس وعشرون دقيقة
١:٣٠ الساعة الواحدة وثلاثون دقيقة
الساعة الواحدة والنصف
١:٣٥ الساعة الواحدة والنصف وخمس دقائق
الساعة الواحدة وخمس وثلاثون دقيقة
١:٤٠ الساعة الواحدة وأربعون دقيقة
الساعة الثانية إلا ثلثا
١:٤٥ الساعة الواحدة وخمس وأربعون دقيقة
الساعة الثانية إلا ربعا
١:٥٠ الساعة الواحدة وخمسون دقيقة
الساعة الثانية إلا عشر دقائق
١:٥٥ الساعة الواحدة وخمس وخمسون دقيقة
الساعة الثانية إلا خمس دقائق
٢:٠٠ الساعة الثانية$$, 30, 30, 1);
end
$migration$;

commit;
