-- Verify Medina Book 2 lesson 19 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF page 45.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 38.

begin;

do $migration$
declare
  lesson_rule_count integer;
  verb_kinds_id bigint;
  lan_id bigint;
  negation_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '19';

  if lesson_rule_count not in (2, 3) then
    raise exception 'Expected 2 or 3 Book 2 lesson 19 rules, found %', lesson_rule_count;
  end if;

  if lesson_rule_count = 2 then
    select id into strict negation_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '19' and sort_order = 1;
    select id into strict lan_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '19' and sort_order = 2;

    update public.rules
    set sort_order = sort_order + 100
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '19';

    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values
      ('Мединский курс (Том 2)', '19', '', '', 1, 'rule', '', '')
    returning id into verb_kinds_id;
  else
    select id into strict verb_kinds_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '19' and sort_order = 1;
    select id into strict lan_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '19' and sort_order = 2;
    select id into strict negation_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '19' and sort_order = 3;
  end if;

  delete from public.rule_sections
  where rule_id in (verb_kinds_id, lan_id, negation_id);

  delete from public.rule_sources
  where rule_id in (verb_kinds_id, lan_id, negation_id);

  -- 1. The three verb types explicitly introduced by the detailed sharh.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'أَقْسَامُ الْفِعْلِ الثَّلَاثَةُ (три вида глагола)',
    rule_ar = 'الْأَفْعَالُ ثَلَاثَةٌ: فِعْلٌ مَاضٍ، وَفِعْلٌ مُضَارِعٌ، وَفِعْلُ أَمْرٍ.',
    summary = 'Подробный шарх делит глаголы на прошедшее время, настоящее/будущее время и повелительную форму и приводит по одному примеру каждого вида.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три вида</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">الْأَفْعَالُ ثَلَاثَةٌ: <span class="ar-tone-verb">فِعْلٌ مَاضٍ</span>، وَ<span class="ar-tone-verb">فِعْلٌ مُضَارِعٌ</span>، وَ<span class="ar-tone-verb">فِعْلُ أَمْرٍ</span>.</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">ذَهَبْتُ إِلَى السُّوقِ.</span><span class="rule-term-ru"><span class="ar-inline" dir="rtl" lang="ar">فِعْلٌ مَاضٍ</span> — прошедшее время: «Я пошёл на рынок».</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">أَذْهَبُ إِلَى السُّوقِ.</span><span class="rule-term-ru"><span class="ar-inline" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ</span> — настоящее/будущее время: «Я иду на рынок».</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبْ إِلَى السُّوقِ.</span><span class="rule-term-ru"><span class="ar-inline" dir="rtl" lang="ar">فِعْلُ أَمْرٍ</span> — повелительная форма: «Иди на рынок».</span></div>
        </div>
      </div>
    </div>$$
  where id = verb_kinds_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (verb_kinds_id, 'Podrobny_Sharkh_2_tom.pdf', $$الأفعال ثلاثة:
ماض، نحو: ذهبت إلى السوق.
مضارع، نحو: أذهب إلى السوق.
أمر، نحو: اذهب إلى السوق.$$,
      45, 45, 1);

  -- 2. Lan, its government, full i'rab, and all source examples.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'نَصْبُ الْفِعْلِ الْمُضَارِعِ بِـ«لَنْ» (насб настоящего глагола после «не будет»)',
    rule_ar = '«لَنْ» حَرْفُ نَفْيٍ وَنَصْبٍ يَنْصِبُ الْفِعْلَ الْمُضَارِعَ وَيَخُصُّ نَفْيَ الْمُسْتَقْبَلِ؛ وَتَكُونُ عَلَامَةُ النَّصْبِ الْفَتْحَةَ أَوْ حَذْفَ النُّونِ فِي الْأَفْعَالِ الْخَمْسَةِ.',
    summary = 'Частица لَنْ отрицает будущее и ставит настоящий глагол в насб; приведены полный разбор и все примеры двух шархов.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Значение и действие</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> حَرْفُ نَفْيٍ وَنَصْبٍ، يَنْصِبُ <span class="ar-tone-verb">الْفِعْلَ الْمُضَارِعَ</span>، وَيَنْفِي حُصُولَهُ فِي الْمُسْتَقْبَلِ.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">لَنْ</span> переводится как отрицание будущего: «не сделаю; не будет делать». После неё глагол настоящего времени стоит в <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">النَّصْبِ</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный разбор подробного шарха</span>
        <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-nasb">أَذْهَبَ</span>.</span><span class="rule-example-ru">Я не пойду.</span></div>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span>: حَرْفُ نَفْيٍ وَنَصْبٍ.</span><span class="rule-analysis-ru">Частица отрицания и насба.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">أَذْهَبَ</span>: فِعْلٌ مُضَارِعٌ مَنْصُوبٌ بِـ«لَنْ»، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ عَلَى آخِرِهِ، وَالْفَاعِلُ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنَا».</span><span class="rule-analysis-ru">Глагол настоящего времени в насбе после <span class="ar-inline" dir="rtl" lang="ar">لَنْ</span>; показатель — явная фатха в конце. Исполнитель — скрытое местоимение «я».</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все дополнительные примеры второго шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَنْ أَحْلِقَ لِحْيَتِي أَبَدًا.</span><span class="rule-example-ru">Я никогда не сбрею свою бороду.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَنْ أَذْهَبَ إِلَى قَرْيَتِي فِي الصَّيْفِ.</span><span class="rule-example-ru">Летом я не поеду в свою деревню.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَنْ تَلْعَبُوا إِلَّا إِذَا كَتَبْتُمُ الْوَاجِبَ.</span><span class="rule-example-ru">Вы не будете играть, пока не напишете домашнее задание.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْأَطِبَّاءُ لَنْ يَخْرُجُوا مِنَ الْمُسْتَشْفَى الْيَوْمَ.</span><span class="rule-example-ru">Врачи сегодня не выйдут из больницы.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا بُنَيَّةُ، لَنْ تَذْهَبِي غَدًا إِلَى الْمَدْرَسَةِ.</span><span class="rule-example-ru">Доченька, завтра ты не пойдёшь в школу.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَمِعْتُ أَنَّكِ لَنْ تُسَافِرِي إِلَى بَلَدِكِ.</span><span class="rule-example-ru">Я слышал, что ты не поедешь в свою страну.</span></div>
        </div>
      </div>
    </div>$$
  where id = lan_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (lan_id, 'Podrobny_Sharkh_2_tom.pdf', $$سبق أن عرفنا أن المضارع يكون منصوبا بحرف النصب (أن)، والآن نذكر حرف نصب آخر ينصب الفعل المضارع هو: لن.
لن: حرف نفي ونصب، نقول: لن أذهب: فعل مضارع منصوب بـ(لن) وعلامة نصبه الفتحة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "أنا".$$,
      45, 45, 1),
    (lan_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$نَصْبُ الْفِعْلِ الْمُضَارِعِ بِـ(لَنْ)
سَبَقَتْ دِرَاسَتُهُ فِي الدَّرْسِ السَّابِعَ عَشَرَ فَارْجِعْ إِلَيْهِ ـ رَعَاكَ اللهُ ـ وَسَأَذْكُرُ هُنَا أَمْثِلَةً لَهُ:
لَنْ أَحْلِقَ لِحْيَتِي أَبَدًا.
لَنْ أَذْهَبَ إِلَى قَرْيَتِي فِي الصَّيْفِ.
لَنْ تَلْعَبُوا إِلَّا إِذَا كَتَبْتُمُ الْوَاجِبَ.
الْأَطِبَّاءُ لَنْ يَخْرُجُوا مِنَ الْمُسْتَشْفَى الْيَوْمَ.
يَا بُنَيَّةُ لَنْ تَذْهَبِي غَدًا إِلَى الْمَدْرَسَةِ.
سَمِعْتُ أَنَّكِ لَنْ تُسَافِرِي إِلَى بَلَدِكِ.$$,
      38, 38, 2);

  -- 3. Negation of past, present, and future with every source example.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'نَفْيُ الْمَاضِي وَالْحَالِ وَالْمُسْتَقْبَلِ (отрицание прошедшего, настоящего и будущего)',
    rule_ar = 'يُنْفَى الْمَاضِي بِـ«مَا»، وَيُنْفَى الْمُضَارِعُ بِـ«لَا» لِلْحَالِ أَوِ الْمُسْتَقْبَلِ، وَبِـ«لَنْ» لِلْمُسْتَقْبَلِ؛ وَتَدُلُّ «لَا» عَلَى الْحَالِ إِذَا وُجِدَتْ قَرِينَةٌ كَـ«الْآنَ» أَوْ دَلَّتِ الْجُمْلَةُ عَلَيْهِ.',
    summary = 'Прошедшее отрицается посредством مَا, настоящее и будущее — посредством لَا, а будущее — посредством لَنْ; контекст определяет настоящее значение لَا.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Распределение частиц по времени</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">يُنْفَى <span class="ar-tone-structure">الْمَاضِي</span> بِـ<span class="ar-tone-particle">«مَا»</span>، وَيُنْفَى <span class="ar-tone-structure">الْحَالُ وَالْمُسْتَقْبَلُ</span> بِـ<span class="ar-tone-particle">«لَا»</span>، وَيُنْفَى <span class="ar-tone-structure">الْمُسْتَقْبَلُ</span> بِـ<span class="ar-tone-particle">«لَنْ»</span>.</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Время</th><th>Частица</th><th>Пример подробного шарха</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td>Прошедшее</td><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">مَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ذَهَبْتُ إِلَى السُّوقِ.<br><span class="ar-tone-particle">مَا</span> ذَهَبْتُ إِلَى السُّوقِ.</span></td><td>Я пошёл на рынок.<br>Я не ходил на рынок.</td></tr>
            <tr><td>Настоящее или будущее</td><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">لَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَذْهَبُ إِلَى السُّوقِ.<br><span class="ar-tone-particle">لَا</span> أَذْهَبُ إِلَى السُّوقِ.</span></td><td>Я иду на рынок.<br>Я не иду / не пойду на рынок.</td></tr>
            <tr><td>Будущее</td><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">لَنْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَذْهَبُ إِلَى السُّوقِ.<br><span class="ar-tone-particle">لَنْ</span> أَذْهَبَ إِلَى السُّوقِ.</span></td><td>Я пойду на рынок.<br>Я не пойду на рынок.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Отрицание прошедшего посредством مَا</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مَا كَتَبْتُ الدَّرْسَ.</span><span class="rule-example-ru">Я не написал урок.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مَا ذَهَبْتُ إِلَى السُّوقِ أَمْسِ.</span><span class="rule-example-ru">Вчера я не ходил на рынок.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Отрицание настоящего и будущего посредством لَا</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا أَشْرَبُ الْقَهْوَةَ.</span><span class="rule-example-ru">Я не буду пить кофе.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا أَذْهَبُ إِلَى السُّوقِ.</span><span class="rule-example-ru">Я не пойду на рынок.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا أَشْرَبُ الْقَهْوَةَ الْآنَ.</span><span class="rule-example-ru">Сейчас я не пью кофе.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا أَظُنُّ هَذَا صَحِيحًا.</span><span class="rule-example-ru">Я не думаю, что это верно.</span></div>
        </div>
        <div class="rule-check-card"><span class="rule-main-ar" dir="rtl" lang="ar">الْأَصْلُ فِي <span class="ar-tone-particle">لَا النَّافِيَةِ</span> أَنْ تَنْفِيَ الْمُضَارِعَ فِي الْمُسْتَقْبَلِ، وَقَدْ تَنْفِيهِ فِي الْحَالِ إِذَا دَلَّتْ عَلَيْهِ قَرِينَةٌ مِثْلُ <span class="ar-tone-structure">«الْآنَ»</span> أَوْ دَلَّتِ الْجُمْلَةُ عَلَى الْحَالِ.</span><span>Обычное значение отрицательной <span class="ar-inline" dir="rtl" lang="ar">لَا</span> — будущее. Настоящее значение определяется указателем вроде «сейчас» либо общим смыслом предложения.</span></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Отрицание будущего посредством لَنْ</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَنْ أَخْرُجَ مِنَ الْبَيْتِ.</span><span class="rule-example-ru">Я не выйду из дома.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَنْ أَذْهَبَ إِلَى السُّوقِ غَدًا.</span><span class="rule-example-ru">Завтра я не пойду на рынок.</span></div>
        </div>
      </div>
    </div>$$
  where id = negation_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (negation_id, 'Podrobny_Sharkh_2_tom.pdf', $$نفي الماضي والحال والمستقبل
الأزمنة ثلاثة: الماضي، الحال، المستقبل:
ذهبت إلى السوق ـ ما ذهبت إلى السوق. (ينفى الماضي بـ"ما" النافية).
أذهب إلى السوق ـ لا أذهب إلى السوق. (ينفى المضارع بـ"لا" النافية).
أذهب إلى السوق ـ لن أذهب إلى السوق. (ينفى المستقبل بـ"لن").$$,
      45, 45, 1),
    (negation_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$نَفْيُ الْمَاضِي، وَالْحَالِ، وَالْمُسْتَقْبَلِ
يُنْفَى الْمَاضِي بِحَرْفِ النَّفْيِ (مَا): مَا كَتَبْتُ الدَّرْسَ. مَا ذَهَبْتُ إِلَى السُّوقِ أَمْسِ.
يُنْفَى الْمُضَارِعُ بِحَرْفَيِ النَّفْيِ (لَا، وَلَنْ) وَالْفَرْقُ بَيْنَهُمَا، كَمَا يَلِي:
١- لَا: لِنَفْيِ الزَّمَنِ الْمُسْتَقْبَلِ، وَالْحَالِيِّ.
تَقُولُ فِي نَفْيِ الْمُسْتَقْبَلِ: لَا أَشْرَبُ الْقَهْوَةَ. لَا أَذْهَبُ إِلَى السُّوقِ.
وَتَقُولُ فِي نَفْيِ الزَّمَنِ الْحَالِيِّ: لَا أَشْرَبُ الْقَهْوَةَ الْآنَ. لَا أَظُنُّ هَذَا صَحِيحًا.
٢- لَنْ: لِلنَّفْيِ فِي الْمُسْتَقْبَلِ، تَقُولُ: لَنْ أَخْرُجَ مِنَ الْبَيْتِ. لَنْ أَذْهَبَ إِلَى السُّوقِ غَدًا.
لَا النَّافِيَةُ: الْأَصْلُ فِيهَا أَنْ تَنْفِيَ الْمُضَارِعَ فِي الْمُسْتَقْبَلِ، وَقَدْ تَنْفِيهِ فِي الزَّمَنِ الْحَالِيِّ إِذَا دَلَّ عَلَى ذَلِكَ دَلِيلٌ، مِثْلُ كَلِمَةِ: الْآنَ، أَوْ حَالًا... إِلَخْ، أَوْ كَانَتِ الْجُمْلَةُ دَالَّةً عَلَى الْحَالِ.$$,
      38, 38, 2);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '19'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 19 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (verb_kinds_id, lan_id, negation_id)
  ) <> 5 then
    raise exception 'Expected 5 Book 2 lesson 19 source rows';
  end if;
end
$migration$;

commit;
