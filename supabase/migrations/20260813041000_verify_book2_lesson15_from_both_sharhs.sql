-- Verify Medina Book 2 lesson 15 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF page 35.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 29-30.
-- The second PDF has a damaged logical text layer. Its source_text below is a
-- literal manual transcription from the rendered pages, authorized by the owner.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
  rule_4_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '15';

  if lesson_rule_count <> 4 then
    raise exception 'Expected 4 Book 2 lesson 15 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '15' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '15' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '15' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '15' and sort_order = 4;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id);

  -- 1. Prohibitive la: meaning, forms, jussive signs, examples, and i'rab.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'لَا النَّاهِيَةُ (запретительная частица لَا)',
    rule_ar = 'لَا النَّاهِيَةُ حَرْفُ جَزْمٍ يَدْخُلُ عَلَى الْفِعْلِ الْمُضَارِعِ فَيَجْزِمُهُ، وَيَجْعَلُ زَمَنَهُ لِلْمُسْتَقْبَلِ فَقَطْ.',
    summary = 'Запретительная لَا входит только перед глаголом настоящего-будущего времени, переводит его в джазм и относит запрет к будущему.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Название, смысл и действие</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَا النَّاهِيَةُ</span> حَرْفُ <span class="ar-tone-jazm">جَزْمٍ</span>، يَجْزِمُ <span class="ar-tone-verb">الْفِعْلَ الْمُضَارِعَ</span>، وَيَجْعَلُ زَمَنَهُ لِلْمُسْتَقْبَلِ فَقَطْ.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">لَا النَّاهِيَةُ</span> — запретительная частица «не делай». Она входит только перед глаголом настоящего-будущего времени и переводит его в состояние <span class="ar-inline ar-tone-jazm" dir="rtl" lang="ar">الْجَزْمُ</span> — джазм.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Формы обращения и признаки джазма</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Собеседник</th><th>Форма запрета</th><th>Русский перевод</th><th>Признак</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">لَا تَذْهَبْ.</span></td><td>Не уходи.</td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">لَا تَذْهَبُوا.</span></td><td>Не уходите.</td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нун</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">لَا تَذْهَبِي.</span></td><td>Не уходи.</td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нун</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">لَا تَذْهَبْنَ.</span></td><td>Не уходите.</td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">построен на сукуне</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все дополнительные примеры из двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">لَا تَدْخُلْ.</span><span class="rule-example-ru">Не входи.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">لَا تَأْكُلْ هَذَا يَا أَخِي.</span><span class="rule-example-ru">Не ешь это, брат мой.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">اِجْتَهِدْ</span> وَلَا <span class="ar-tone-verb">تُهْمِلْ</span> دُرُوسَكَ.</span><span class="rule-example-ru">Старайся и не пренебрегай своими уроками.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">لَا تَخْرُجْ مِنَ الْفَصْلِ إِلَّا بَعْدَ إِذْنِ الْمُدَرِّسِ.</span><span class="rule-example-ru">Не выходи из класса иначе как после разрешения преподавателя.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">إِعْرَابٌ (грамматический разбор)</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">تَدْخُلْ</span>: فِعْلٌ مُضَارِعٌ <span class="ar-tone-jazm">مَجْزُومٌ</span> بِـ<span class="ar-tone-particle">«لَا» النَّاهِيَةِ</span>، وَعَلَامَةُ جَزْمِهِ السُّكُونُ.</span>
        <p class="rule-study-text"><span class="ar-inline" dir="rtl" lang="ar">تَدْخُلْ</span> — глагол настоящего-будущего времени в джазме из-за запретительной <span class="ar-inline" dir="rtl" lang="ar">لَا</span>; признак джазма — сукун.</p>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$«لا» الناهية
«لا» الناهية تدخل على الفعل المضارع فقط وتجزمه، نحو: لا تدخلْ.
الإعراب:
تدخلْ: فعل مضارع مجزوم بـ «لا» الناهية وعلامة جزمه السكون.$$, 35, 35, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$لَا النَّاهِيَةُ
لَا النَّاهِيَةُ: حَرْفُ جَزْمٍ، يَجْزِمُ الْفِعْلَ الْمُضَارِعَ، وَيَجْعَلُ زَمَنَهُ لِلْمُسْتَقْبَلِ فَقَطْ.
إِسْنَادُ الْفِعْلِ الْمُضَارِعِ الْمَجْزُومِ بِلَا النَّاهِيَةِ إِلَى الضَّمَائِرِ
لَا تَذْهَبْ | ضَمِيرٌ مُسْتَتِرٌ (أَنْتَ) | لَا تَذْهَبُوا | وَاوُ الْجَمَاعَةِ | الْمُذَكَّرُ | الْمُخَاطَبُ
لَا تَذْهَبِي | يَاءُ الْمُخَاطَبَةِ | لَا تَذْهَبْنَ | نُونُ النِّسْوَةِ | الْمُؤَنَّثُ | الْمُخَاطَبُ
لَا تَذْهَبْ: عَلَامَةُ جَزْمِهِ السُّكُونُ.
لَا تَذْهَبُوا، لَا تَذْهَبِي: عَلَامَةُ جَزْمِهِمَا حَذْفُ النُّونِ.
لَا تَذْهَبْنَ: مَبْنِيٌّ عَلَى السُّكُونِ.
أَمْثِلَةٌ: لَا تَأْكُلْ هَذَا يَا أَخِي. اِجْتَهِدْ وَلَا تُهْمِلْ دُرُوسَكَ. لَا تَخْرُجْ مِنَ الْفَصْلِ إِلَّا بَعْدَ إِذْنِ الْمُدَرِّسِ.$$, 29, 29, 2);

  -- 2. Negative la and ma, including normal and contextual time reference.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'لَا وَمَا النَّافِيَتَانِ (отрицательные لَا и مَا)',
    rule_ar = 'لَا النَّافِيَةُ تَنْفِي الْفِعْلَ الْمُضَارِعَ وَتَجْعَلُ زَمَنَهُ لِلْمُسْتَقْبَلِ، وَمَا النَّافِيَةُ تَنْفِي الْفِعْلَ الْمَاضِيَ، وَلَا تَعْمَلُ وَاحِدَةٌ مِنْهُمَا شَيْئًا؛ وَقَدْ تَدْخُلُ مَا عَلَى الْمُضَارِعِ فَتَجْعَلُ زَمَنَهُ لِلْحَالِ، وَقَدْ تَنْفِي لَا الْمُضَارِعَ فِي الْحَالِ إِذَا دَلَّ عَلَيْهِ دَلِيلٌ.',
    summary = 'Отрицательная لَا обычно отрицает настоящее-будущее с будущим значением, а مَا — прошедшее; обе не изменяют окончание глагола. Контекст может указывать на отрицание действия прямо сейчас.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Основное различие</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Частица и перевод</th><th>Что отрицает</th><th>Обычное время</th><th>Грамматическое действие</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">لَا النَّافِيَةُ</span><span class="rule-table-ru">отрицательная «не»</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمُضَارِعُ</span><span class="rule-table-ru">настоящее-будущее</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُسْتَقْبَلُ</span><span class="rule-table-ru">будущее</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَا تَعْمَلُ شَيْئًا</span><span class="rule-table-ru">ничего не изменяет</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">مَا النَّافِيَةُ</span><span class="rule-table-ru">отрицательная «не»</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمَاضِي</span><span class="rule-table-ru">прошедшее</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمَاضِي</span><span class="rule-table-ru">прошлое</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَا تَعْمَلُ شَيْئًا</span><span class="rule-table-ru">ничего не изменяет</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры с отрицательной لَا</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا أَشْرَبُ الْقَهْوَةَ.</span><span class="rule-example-ru">Я не пью кофе.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا أَشْرَبُ الْخَمْرَ أَبَدًا.</span><span class="rule-example-ru">Я никогда не пью вино.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّالِبُ الْمُجْتَهِدُ لَا يَنَامُ فِي الْفَصْلِ.</span><span class="rule-example-ru">Старательный студент не спит в классе.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры с отрицательной مَا</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مَا أَكَلْتُ شَيْئًا.</span><span class="rule-example-ru">Я ничего не ел.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مَا جَاءَ الْمُرَاقِبُ الْيَوْمَ.</span><span class="rule-example-ru">Инспектор сегодня не пришёл.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا مَا كَتَبْتُ الْوَاجِبَ يَا أُسْتَاذُ.</span><span class="rule-example-ru">Учитель, я не написал домашнее задание.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Когда контекст указывает на настоящий момент</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا مَا أَشْرَبُ الْقَهْوَةَ.</span><span class="rule-example-ru">Я сейчас не пью кофе. В пояснении шарха: вообще я пью кофе, но сейчас его не пью.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا أَذْهَبُ الْآنَ.</span><span class="rule-example-ru">Я сейчас не иду.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَ لَا تَأْكُلُ؟ فَالطَّعَامُ لَذِيذٌ.</span><span class="rule-example-ru">Почему ты не ешь? Ведь еда вкусная.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$لَا، وَمَا النَّافِيَتَانِ
لَا النَّافِيَةُ: تَنْفِي الْفِعْلَ الْمُضَارِعَ، وَتَجْعَلُ زَمَنَهُ لِلْمُسْتَقْبَلِ، وَلَا تَعْمَلُ شَيْئًا.
أَمْثِلَةٌ: لَا أَشْرَبُ الْقَهْوَةَ. لَا أَشْرَبُ الْخَمْرَ أَبَدًا. الطَّالِبُ الْمُجْتَهِدُ لَا يَنَامُ فِي الْفَصْلِ.
مَا النَّافِيَةُ: تَنْفِي الْفِعْلَ الْمَاضِيَ، وَلَا تَعْمَلُ شَيْئًا.
أَمْثِلَةٌ: مَا أَكَلْتُ شَيْئًا. مَا جَاءَ الْمُرَاقِبُ الْيَوْمَ. أَنَا مَا كَتَبْتُ الْوَاجِبَ يَا أُسْتَاذُ.
قَدْ تَدْخُلُ (مَا) عَلَى الْفِعْلِ الْمُضَارِعِ فَتَقْلِبُ زَمَنَهُ مِنَ الْمُسْتَقْبَلِ إِلَى الْحَالِ.
أَنَا مَا أَشْرَبُ الْقَهْوَةَ (أَيْ: الْآنَ) بِمَعْنَى: أَنَا أَشْرَبُ الْقَهْوَةَ وَلَكِنِ الْآنَ لَا أَشْرَبُهَا.
لَا النَّافِيَةُ قَدْ تَنْفِي الْمُضَارِعَ فِي الزَّمَنِ الْحَالِيِّ إِذَا دَلَّ عَلَيْهِ دَلِيلٌ، نَحْوُ: لَا أَذْهَبُ الْآنَ، وَنَحْوُ: لِمَ لَا تَأْكُلُ فَالطَّعَامُ لَذِيذٌ؟$$, 29, 29, 1);

  -- 3. Kada: proximity, government, all examples, and both source analyses.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'كَادَ وَأَفْعَالُ الْمُقَارَبَةِ (كَادَ и глаголы близости действия)',
    rule_ar = 'كَادَ فِعْلٌ مَاضٍ نَاقِصٌ مِنْ أَفْعَالِ الْمُقَارَبَةِ، يَرْفَعُ الْمُبْتَدَأَ وَيَنْصِبُ الْخَبَرَ، وَخَبَرُهُ جُمْلَةٌ فِعْلِيَّةٌ فِعْلُهَا مُضَارِعٌ؛ وَمَعْنَاهُ قَرُبَ أَنْ يَقَعَ الْخَبَرُ.',
    summary = 'كَادَ — неполный глагол близости действия: его имя стоит в именительном, сказуемое — в позиции винительного и выражается глагольным предложением с المضارع.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Название, значение и управление</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَادَ</span> فِعْلٌ مَاضٍ <span class="ar-tone-structure">نَاقِصٌ</span> مِنْ <span class="ar-tone-structure">أَفْعَالِ الْمُقَارَبَةِ</span>؛ يَرْفَعُ الْمُبْتَدَأَ وَيَنْصِبُ الْخَبَرَ، وَمَعْنَاهُ: قَرُبَ أَنْ يَقَعَ الْخَبَرُ.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">كَادَ</span> — «чуть не; почти; был близок к тому, чтобы». Это неполный глагол из глаголов близости действия: его имя именительное, а сказуемое занимает позицию винительного.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Форма сказуемого</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">خَبَرُ <span class="ar-tone-verb">كَادَ</span> جُمْلَةٌ فِعْلِيَّةٌ فِعْلُهَا <span class="ar-tone-verb">مُضَارِعٌ</span>.</span>
        <p class="rule-study-text">Сказуемое <span class="ar-inline" dir="rtl" lang="ar">كَادَ</span> является глагольным предложением, глагол которого стоит в настоящем-будущем времени.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры из двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">كَادَ مُحَمَّدٌ يَخْرُجُ.</span><span class="rule-example-ru">Мухаммад чуть было не вышел.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">كَادَ الطِّفْلُ يَسْقُطُ.</span><span class="rule-example-ru">Ребёнок чуть было не упал.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَكَادُ الْإِمَامُ يَرْكَعُ.</span><span class="rule-example-ru">Имам уже почти совершает поясной поклон.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">ضَرَبَتِ الْمُدِيرَةُ الطَّالِبَةَ فَكَادَتْ تَبْكِي.</span><span class="rule-example-ru">Директриса ударила ученицу, и та чуть не заплакала.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَكَادُ الْجَرَسُ يَرِنُّ.</span><span class="rule-example-ru">Звонок вот-вот зазвонит.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِنْقَلَبَتْ سَيَّارَةُ حَامِدٍ وَكَادَ يَمُوتُ.</span><span class="rule-example-ru">Машина Хамида перевернулась, и он чуть не умер.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный إِعْرَاب (разбор) из 80-страничного шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Часть</th><th>Арабский разбор</th><th>Русское объяснение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">كَادَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مَاضٍ نَاقِصٌ مَبْنِيٌّ عَلَى الْفَتْحِ.</span></td><td>Неполный глагол прошедшего времени, построен на фатхе.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُحَمَّدٌ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِسْمُ كَادَ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span></td><td>Имя كَادَ в именительном; признак — явно выраженная дамма.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَخْرُجُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ عَلَى آخِرِهِ، وَالْفَاعِلُ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هُوَ».</span></td><td>Глагол المضارع в именительном; исполнитель — скрытое местоимение «он».</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْجُمْلَةُ الْفِعْلِيَّةُ «يَخْرُجُ»</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">فِي مَحَلِّ نَصْبٍ خَبَرُ كَادَ.</span></td><td>Всё глагольное предложение занимает позицию винительного как сказуемое كَادَ.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Два разбора из второго шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَادَ</span> <span class="ar-tone-subject">الطِّفْلُ</span> <span class="ar-tone-verb">يَسْقُطُ</span>.</span><span class="rule-example-ru">كَادَ — прошедший глагол; الطِّفْلُ — имя كَادَ; يَسْقُطُ — сказуемое كَادَ в позиции винительного.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِنْقَلَبَتْ سَيَّارَةُ حَامِدٍ وَ<span class="ar-tone-verb">كَادَ يَمُوتُ</span>.</span><span class="rule-example-ru">كَادَ — прошедший глагол; يَمُوتُ — сказуемое; имя كَادَ — скрытое местоимение «он».</span></div>
        </div>
        <div class="rule-check-card"><span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">فِي مَحَلِّ نَصْبٍ</span> — «в позиции винительного»: выражение заняло место имени в винительном.</div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$كاد
كاد من أفعال المقاربة، نحو: كاد محمد يخرج.
كاد فعل ناقص يرفع المبتدأ وينصب الخبر ويسمى المبتدأ اسم كاد، والخبر يسمى خبر كاد، وخبره جملة فعلية فعلها مضارع.
الإعراب:
«كاد محمد يخرج»
كاد: فعل ماض ناقص مبني على الفتح.
محمد: اسم كاد مرفوع وعلامة رفعه الضمة الظاهرة على آخره.
يخرج: فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره «هو».
والجملة الفعلية (يخرج) في محل نصب خبر كاد.$$, 35, 35, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$كَادَ
كَادَ: فِعْلٌ مَاضٍ يَعْمَلُ عَمَلَ كَانَ يَرْفَعُ الِاسْمَ وَيَنْصِبُ الْخَبَرَ، وَخَبَرُهُ يَجِبُ أَنْ يَكُونَ فِعْلًا مُضَارِعًا.
كَادَ: مِنْ أَفْعَالِ الْمُقَارَبَةِ، أَيْ: قَرُبَ أَنْ يَقَعَ الْخَبَرُ.
أَمْثِلَةٌ: كَادَ الطِّفْلُ يَسْقُطُ. يَكَادُ الْإِمَامُ يَرْكَعُ. ضَرَبَتِ الْمُدِيرَةُ الطَّالِبَةَ فَكَادَتْ تَبْكِي. يَكَادُ الْجَرَسُ يَرِنُّ.
كَادَ الطِّفْلُ يَسْقُطُ: كَادَ فِعْلٌ مَاضٍ، الطِّفْلُ اسْمُ كَادَ، يَسْقُطُ خَبَرُ كَادَ.
اِنْقَلَبَتْ سَيَّارَةُ حَامِدٍ وَكَادَ يَمُوتُ: كَادَ فِعْلٌ مَاضٍ، يَمُوتُ خَبَرُ كَادَ، وَاسْمُ كَادَ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ (هُوَ).
كَادَ الطِّفْلُ يَسْقُطُ: يَسْقُطُ، خَبَرُ كَادَ فِي مَحَلِّ نَصْبٍ.
فِي مَحَلِّ نَصْبٍ: مَعْنَاهُ أَنَّهُ حَلَّ مَحَلَّ اسْمٍ مَنْصُوبٍ.$$, 30, 30, 2);

  -- 4. The source's explicit review of the exclamation form.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'مُرَاجَعَةُ فِعْلِ التَّعَجُّبِ (повторение восклицательной формы)',
    rule_ar = 'سَبَقَ تَعْرِيفُ فِعْلِ التَّعَجُّبِ فِي الصَّفْحَةِ الْحَادِيَةِ وَالْعِشْرِينَ، وَأَعَادَ الشَّرْحُ هُنَا أَرْبَعَةَ أَمْثِلَةٍ لَهُ.',
    summary = 'Шарх отсылает к прежнему определению восклицательного глагола и повторяет здесь четыре примера без нового объяснения правила.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Что именно повторяет источник</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">سَبَقَ تَعْرِيفُ <span class="ar-tone-verb">فِعْلِ التَّعَجُّبِ</span> فِي الصَّفْحَةِ الْحَادِيَةِ وَالْعِشْرِينَ، فَارْجِعْ إِلَيْهِ.</span>
        <p class="rule-study-text">Источник сообщает, что определение уже было дано на странице 21, и в этом уроке приводит повторение на четырёх примерах.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все четыре примера</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">مَا أَطْوَلَ حَامِدًا!</span><span class="rule-example-ru">Как высок Хамид!</span></div>
          <div class="rule-example-card"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">مَا أَوْسَخَ الْغُرْفَةَ!</span><span class="rule-example-ru">Как грязна комната!</span></div>
          <div class="rule-example-card"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">مَا أَجْمَلَ الْوَرْدَةَ!</span><span class="rule-example-ru">Как прекрасна роза!</span></div>
          <div class="rule-example-card"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">مَا أَصْغَرَ السَّيَّارَةَ!</span><span class="rule-example-ru">Как мала машина!</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$فِعْلُ التَّعَجُّبِ
سَبَقَ تَعْرِيفُهُ فِي ص ٢١ فَارْجِعْ إِلَيْهِ حَفِظَكَ اللَّهُ.
أَمْثِلَةٌ: مَا أَطْوَلَ حَامِدًا! مَا أَوْسَخَ الْغُرْفَةَ! مَا أَجْمَلَ الْوَرْدَةَ! مَا أَصْغَرَ السَّيَّارَةَ!$$, 30, 30, 1);
end
$migration$;

commit;
