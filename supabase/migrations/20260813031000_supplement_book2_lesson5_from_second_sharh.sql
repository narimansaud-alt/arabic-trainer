-- Supplement Medina Book 2 lesson 5 from the manually verified scan of the
-- second Arabic sharh, PDF page 13. Page 14 starts lesson 6.

begin;

do $migration$
declare
  roles_rule_id bigint;
  forms_rule_id bigint;
  agreement_rule_id bigint;
  subject_rule_id bigint;
  lesson_rule_count integer;
  updated_content text;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '5';

  if lesson_rule_count <> 8 then
    raise exception 'Expected 8 Book 2 lesson 5 rules, found %', lesson_rule_count;
  end if;

  select id into strict roles_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '5'
    and sort_order = 4;

  select id into strict forms_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '5'
    and sort_order = 5;

  select id into strict agreement_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '5'
    and sort_order = 6;

  select id into strict subject_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '5'
    and sort_order = 7;

  -- 4. Keep the shared definition once and add every distinct page-13 example.
  select content into strict updated_content from public.rules where id = roles_rule_id;
  if position('book2-second-sharh-l5-role-examples' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 5 role rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l5-role-examples"><span class="rule-card-kicker">Дополнительные примеры второго шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَكَلَ</span> <span class="ar-tone-subject">أُسَامَةُ</span> <span class="ar-tone-nasb">الْعِنَبَ</span>.</span><span class="rule-example-ru">Усама съел виноград: <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">أُسَامَةُ</span> — исполнитель, <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">الْعِنَبَ</span> — прямое дополнение.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَسَرَ</span> <span class="ar-tone-subject">الطِّفْلُ</span> <span class="ar-tone-nasb">الْقَلَمَ</span>.</span><span class="rule-example-ru">Ребёнок сломал ручку.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">شَرِبَتْ</span> <span class="ar-tone-subject">فَاطِمَةُ</span> <span class="ar-tone-nasb">الْعَصِيرَ</span>.</span><span class="rule-example-ru">Фатима выпила сок.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">غَسَلَتْ</span> <span class="ar-tone-subject">آمِنَةُ</span> <span class="ar-tone-nasb">الثَّوْبَ</span>.</span><span class="rule-example-ru">Амина постирала одежду.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор примера второго шарха</span><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">ضَرَبَ</span> <span class="ar-tone-subject">الْمُدَرِّسُ</span> <span class="ar-tone-nasb">الطَّالِبَ</span>.</span><span class="rule-example-ru">Преподаватель ударил студента.</span></div><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْكَلِمَةُ</span><span class="rule-table-ru">слово</span></th><th><span class="rule-table-ar">وَظِيفَتُهَا</span><span class="rule-table-ru">роль и причина</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-subject">الْمُدَرِّسُ</span><span class="rule-table-ru">преподаватель</span></td><td><span class="rule-table-ar ar-tone-subject">فَاعِلٌ؛ لِأَنَّهُ هُوَ الَّذِي فَعَلَ الضَّرْبَ.</span><span class="rule-table-ru">Исполнитель, потому что именно он совершил действие.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">الطَّالِبَ</span><span class="rule-table-ru">студента</span></td><td><span class="rule-table-ar ar-tone-nasb">مَفْعُولٌ بِهِ؛ لِأَنَّهُ وَقَعَ عَلَيْهِ الضَّرْبُ.</span><span class="rule-table-ru">Прямое дополнение, потому что удар пришёлся на него.</span></td></tr></tbody></table></div></div>
</div>$html$;
  end if;
  update public.rules set content = updated_content where id = roles_rule_id;

  -- 5. Correct the detailed-sharh form and add the masculine/feminine object suffixes.
  select content into strict updated_content from public.rules where id = forms_rule_id;
  updated_content := replace(
    updated_content,
    '<span class="ar-tone-verb">فَهِمَ</span><span class="ar-tone-nasb">هُ</span>',
    '<span class="ar-tone-verb">فَهِمْتُ</span><span class="ar-tone-nasb">هُ</span>'
  );
  updated_content := replace(updated_content, 'Он понял его:', 'Я понял его:');
  if position('book2-second-sharh-l5-object-gender' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 5 forms rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l5-object-gender"><span class="rule-card-kicker">Род слитного дополнения</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-role"><span class="rule-term-ar" dir="rtl" lang="ar">ـهُ</span><span class="rule-term-ru">«его» — местоимение указывает на слово мужского рода.</span></div><div class="rule-meaning-card rule-term-role"><span class="rule-term-ar" dir="rtl" lang="ar">ـهَا</span><span class="rule-term-ru">«её» — местоимение указывает на слово женского рода.</span></div></div><div class="rule-example-list"><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ <span class="ar-tone-verb">فَتَحَ</span> <span class="ar-tone-nasb">الْبَابَ</span>؟ أَنَا <span class="ar-tone-verb">فَتَحْتُ</span><span class="ar-tone-nasb">هُ</span>.</span><span class="rule-example-ru">Кто открыл дверь? — Я открыл её. Слово <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">الْبَابَ</span> мужского рода, поэтому употреблено <span class="ar-inline ar-tone-role" dir="rtl" lang="ar">ـهُ</span>.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ <span class="ar-tone-verb">فَتَحَ</span> <span class="ar-tone-nasb">النَّافِذَةَ</span>؟ أَنَا <span class="ar-tone-verb">فَتَحْتُ</span><span class="ar-tone-nasb">هَا</span>.</span><span class="rule-example-ru">Кто открыл окно? — Я открыл его. Слово <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">النَّافِذَةَ</span> женского рода, поэтому употреблено <span class="ar-inline ar-tone-role" dir="rtl" lang="ar">ـهَا</span>.</span></div></div></div>
</div>$html$;
  end if;
  update public.rules
  set
    rule_ar = 'يَكُونُ الْفَاعِلُ اسْمًا ظَاهِرًا أَوْ ضَمِيرَ رَفْعٍ مُتَّصِلًا، وَقَدْ يَكُونُ ضَمِيرًا مُنْفَصِلًا. وَيَكُونُ الْمَفْعُولُ بِهِ اسْمًا ظَاهِرًا أَوْ ضَمِيرَ نَصْبٍ مُتَّصِلًا. وَالضَّمِيرُ «ـهُ» يَدُلُّ عَلَى الْمُذَكَّرِ، وَالضَّمِيرُ «ـهَا» يَدُلُّ عَلَى الْمُؤَنَّثِ.',
    summary = 'يَكُونُ الْفَاعِلُ اسْمًا ظَاهِرًا أَوْ ضَمِيرَ رَفْعٍ مُتَّصِلًا، وَقَدْ يَكُونُ ضَمِيرًا مُنْفَصِلًا. وَيَكُونُ الْمَفْعُولُ بِهِ اسْمًا ظَاهِرًا أَوْ ضَمِيرَ نَصْبٍ مُتَّصِلًا. وَالضَّمِيرُ «ـهُ» يَدُلُّ عَلَى الْمُذَكَّرِ، وَالضَّمِيرُ «ـهَا» يَدُلُّ عَلَى الْمُؤَنَّثِ.',
    content = updated_content
  where id = forms_rule_id;

  -- 6. Add the contrast between verb-first and subject-first agreement.
  select content into strict updated_content from public.rules where id = agreement_rule_id;
  if position('book2-second-sharh-l5-word-order' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 5 agreement rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l5-word-order"><span class="rule-card-kicker">Положение исполнителя меняет согласование</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْفِعْلُ أَوَّلًا</span><span class="rule-table-ru">сначала глагол</span></th><th><span class="rule-table-ar">الْفَاعِلُ أَوَّلًا</span><span class="rule-table-ru">сначала исполнитель</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar"><span class="ar-tone-verb">شَرِبَ</span> <span class="ar-tone-subject">الْأَوْلَادُ</span> الْقَهْوَةَ.</span><span class="rule-table-ru">Мальчики выпили кофе: глагол перед исполнителем стоит в единственном числе.</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">الْأَوْلَادُ</span> <span class="ar-tone-verb">شَرِبُوا</span> الْقَهْوَةَ.</span><span class="rule-table-ru">Мальчики выпили кофе: после исполнителя глагол имеет множественное число.</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Дополнительные предложения второго шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">دَخَلَ</span> <span class="ar-tone-subject">الطُّلَّابُ</span> الْفَصْلَ وَ<span class="ar-tone-verb">جَلَسُوا</span>.</span><span class="rule-example-ru">Студенты вошли в класс и сели.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">دَخَلَتِ</span> <span class="ar-tone-subject">الطَّالِبَاتُ</span> الْفَصْلَ وَ<span class="ar-tone-verb">جَلَسْنَ</span>.</span><span class="rule-example-ru">Студентки вошли в класс и сели.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">قَرَأَ</span> <span class="ar-tone-subject">الطُّلَّابُ</span> الدَّرْسَ وَ<span class="ar-tone-verb">فَهِمُوهُ</span>.</span><span class="rule-example-ru">Студенты прочитали урок и поняли его.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">ضَرَبَ</span> <span class="ar-tone-subject">الْأَوْلَادُ</span> الْحَيَّةَ وَ<span class="ar-tone-verb">قَتَلُوهَا</span>.</span><span class="rule-example-ru">Мальчики ударили змею и убили её.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Правильно и неправильно</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الصَّحِيحُ</span><span class="rule-table-ru">правильно</span></th><th><span class="rule-table-ar">الْخَطَأُ</span><span class="rule-table-ru">неправильно</span></th><th><span class="rule-table-ru">причина</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar rule-table-valid"><span class="ar-tone-verb">سَمِعَ</span> <span class="ar-tone-subject">النَّاسُ</span> الْأَذَانَ.</span><span class="rule-table-ru">Люди услышали азан.</span></td><td><span class="rule-table-ar rule-table-invalid"><span class="ar-tone-verb">سَمِعُوا</span> <span class="ar-tone-subject">النَّاسُ</span> الْأَذَانَ.</span></td><td><span class="rule-table-ru">Перед явным исполнителем глагол должен быть в единственном числе.</span></td></tr><tr><td><span class="rule-table-ar rule-table-valid"><span class="ar-tone-subject">النَّاسُ</span> <span class="ar-tone-verb">سَمِعُوا</span> الْأَذَانَ.</span><span class="rule-table-ru">Люди услышали азан.</span></td><td><span class="rule-table-ar rule-table-invalid"><span class="ar-tone-subject">النَّاسُ</span> <span class="ar-tone-verb">سَمِعَ</span> الْأَذَانَ.</span></td><td><span class="rule-table-ru">После исполнителя во множественном числе глагол тоже должен быть во множественном.</span></td></tr><tr><td><span class="rule-table-ar rule-table-valid"><span class="ar-tone-verb">قَتَلَتِ</span> <span class="ar-tone-subject">الطَّالِبَاتُ</span> الْحَيَّةَ.</span><span class="rule-table-ru">Студентки убили змею.</span></td><td><span class="rule-table-ar rule-table-invalid"><span class="ar-tone-verb">قَتَلْنَ</span> <span class="ar-tone-subject">الطَّالِبَاتُ</span> الْحَيَّةَ.</span></td><td><span class="rule-table-ru">Перед явным исполнителем женского множественного глагол остаётся в женском единственном.</span></td></tr><tr><td><span class="rule-table-ar rule-table-valid"><span class="ar-tone-subject">الطَّالِبَاتُ</span> <span class="ar-tone-verb">قَتَلْنَ</span> الْحَيَّةَ.</span><span class="rule-table-ru">Студентки убили змею.</span></td><td><span class="rule-table-ar rule-table-invalid"><span class="ar-tone-subject">الطَّالِبَاتُ</span> <span class="ar-tone-verb">قَتَلَتِ</span> الْحَيَّةَ.</span></td><td><span class="rule-table-ru">После женского множественного исполнителя нужна форма с <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span>.</span></td></tr></tbody></table></div></div>
</div>$html$;
  end if;
  update public.rules
  set
    rule_ar = 'إِذَا تَقَدَّمَ الْفِعْلُ وَجَبَ أَنْ يَكُونَ مُفْرَدًا، وَإِنْ كَانَ الْفَاعِلُ مُثَنًّى أَوْ جَمْعًا. وَإِذَا تَقَدَّمَ الْفَاعِلُ وَجَبَ أَنْ يُطَابِقَهُ الْفِعْلُ فِي الْإِفْرَادِ وَالتَّثْنِيَةِ وَالْجَمْعِ.',
    summary = 'إِذَا تَقَدَّمَ الْفِعْلُ وَجَبَ أَنْ يَكُونَ مُفْرَدًا، وَإِنْ كَانَ الْفَاعِلُ مُثَنًّى أَوْ جَمْعًا. وَإِذَا تَقَدَّمَ الْفَاعِلُ وَجَبَ أَنْ يُطَابِقَهُ الْفِعْلُ فِي الْإِفْرَادِ وَالتَّثْنِيَةِ وَالْجَمْعِ.',
    content = updated_content
  where id = agreement_rule_id;

  -- 7. Keep the existing full table and add only the two distinct marker examples.
  select content into strict updated_content from public.rules where id = subject_rule_id;
  if position('book2-second-sharh-l5-subject-markers' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 5 subject rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l5-subject-markers"><span class="rule-card-kicker">Два дополнительных примера показателя исполнителя</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَتَبْتُ</span> الْوَاجِبَ.</span><span class="rule-example-ru">Я написал домашнее задание: <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">تَاءُ الْفَاعِلِ</span> является исполнителем.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَتَبُوا</span>.</span><span class="rule-example-ru">Они написали: <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span> является исполнителем.</span></div></div></div>
</div>$html$;
  end if;
  update public.rules set content = updated_content where id = subject_rule_id;

  delete from public.rule_sources
  where rule_id in (roles_rule_id, forms_rule_id, agreement_rule_id, subject_rule_id)
    and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf';

  -- source_text is a manual transcription of the printed scan. It intentionally
  -- keeps the source wording and its partial vocalization; it is not rule_ar.
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (roles_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الدَّرْسُ الْخَامِسُ
الْفَاعِلُ، وَالْمَفْعُولُ بِهِ
الفاعلُ: اسمٌ مرفوعٌ قَبْلَهُ فِعْلٌ، وهو الذي فَعَلَ الْفِعْلَ.
الْمَفْعُولُ به: اسمٌ مَنْصُوبٌ وَقَعَ عليه فِعْلُ الفاعلِ.
أمثلةٌ: قَرَأَ الطالبُ القرآنَ. أَكَلَ أسامةُ العِنَبَ. كَسَرَ الطفلُ القلمَ.
شَرِبَتْ فاطمةُ العَصِيرَ. ضَرَبَ المدرسُ الطالبَ. غَسَلَتْ آمنةُ الثَّوْبَ.
المدرسُ: فاعلٌ؛ لأنه هو الذي فَعَلَ الضَّرْبَ. الطالبُ: مفعولٌ به؛ لأنه وَقَعَ عليه الضَّرْبُ.$source$, 13, 13, 2),
    (forms_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$مَنْ فَتَحَ البابَ؟ أنا فَتَحْتُهُ. مَنْ فَتَحَ النافذةَ؟ أنا فَتَحْتُهَا.
فَتَحْتُهُ: الضمير (ه) يَدُلُّ على المذكَّر.
فَتَحْتُهَا: الضمير (ها) يَدُلُّ على المؤنث.$source$, 13, 13, 2),
    (agreement_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$شَرِبَ الأولادُ القهوةَ ← الأولادُ شَرِبُوا القهوةَ.
سَمِعَ النَّاسُ الأذانَ. النَّاسُ سَمِعُوا الأذانَ.
قَتَلَتِ الطالباتُ الحَيَّةَ. الطالباتُ قَتَلْنَ الحَيَّةَ.
دَخَلَ الطلابُ الفصلَ وَجَلَسُوا. دَخَلَتِ الطالباتُ الفصلَ وَجَلَسْنَ.
قَرَأَ الطلابُ الدرسَ وَفَهِمُوهُ. ضَرَبَ الأولادُ الحيّةَ وَقَتَلُوهَا.
سَمِعَ النَّاسُ الأذانَ ✓  سَمِعُوا النَّاسُ الأذانَ ×  النَّاسُ سَمِعُوا الأذانَ ✓  النَّاسُ سَمِعَ الأذانَ ×
قَتَلَتِ الطالباتُ الحيّةَ ✓  قَتَلْنَ الطالباتُ الحيّةَ ×  الطالباتُ قَتَلْنَ الحيّةَ ✓  الطالباتُ قَتَلَتِ الحيّةَ ×$source$, 13, 13, 2),
    (subject_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$كَتَبْتُ الواجبَ (التاء) فاعلٌ. كَتَبُوا (واو الجماعة) فاعلٌ. ذَهَبْنَ (نون النسوة) فاعلٌ.
تاءُ التأنيثِ: حرفٌ يَدُلُّ على أَنَّ ما بعده مؤنَّثٌ.$source$, 13, 13, 2);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '5'
      and coalesce(rule_ar, '') = ''
  ) then
    raise exception 'Book 2 lesson 5 contains an empty rule_ar';
  end if;

  if exists (
    select 1 from public.rules r
    where r.course_name = 'Мединский курс (Том 2)'
      and r.lesson_number = '5'
      and not exists (select 1 from public.rule_sources s where s.rule_id = r.id)
  ) then
    raise exception 'Book 2 lesson 5 contains a rule without provenance';
  end if;
end;
$migration$;

commit;
