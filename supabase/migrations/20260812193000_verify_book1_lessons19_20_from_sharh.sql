-- Verify Medina Book 1 lessons 19 and 20 against their combined sharh section.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF page 32.

begin;

do $migration$
declare
  masculine_rule_id bigint;
  feminine_rule_id bigint;
  lesson19_extra_id bigint;
begin
  select id into strict lesson19_extra_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '19' and sort_order = 1;
  select id into strict masculine_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '19' and sort_order = 2;
  select id into strict feminine_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '20' and sort_order = 1;

  delete from public.rule_sections where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number in ('19', '20')
  );
  delete from public.rule_sources where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number in ('19', '20')
  );
  delete from public.rules where id = lesson19_extra_id;
  update public.rules set sort_order = sort_order + 100 where id in (masculine_rule_id, feminine_rule_id);

  update public.rules
  set sort_order = 1,
      title = 'الْعَدَدُ مِنْ ثَلَاثَةٍ إِلَى عَشَرَةٍ مَعَ الْمَعْدُودِ الْمُذَكَّرِ (числа 3–10 с существительным мужского рода)',
      rule_ar = 'الْعَدَدُ مِنْ ثَلَاثَةٍ إِلَى عَشَرَةٍ يُخَالِفُ الْمَعْدُودَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَالْمَعْدُودُ يَكُونُ جَمْعًا مَجْرُورًا بِالْإِضَافَةِ، وَالْحُكْمُ فِي تَذْكِيرِ الْعَدَدِ وَتَأْنِيثِهِ عَلَى مُفْرَدِ الْمَعْدُودِ لَا عَلَى جَمْعِهِ.',
      summary = 'الْعَدَدُ مِنْ ثَلَاثَةٍ إِلَى عَشَرَةٍ يُخَالِفُ الْمَعْدُودَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَالْمَعْدُودُ يَكُونُ جَمْعًا مَجْرُورًا بِالْإِضَافَةِ، وَالْحُكْمُ فِي تَذْكِيرِ الْعَدَدِ وَتَأْنِيثِهِ عَلَى مُفْرَدِ الْمَعْدُودِ لَا عَلَى جَمْعِهِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Общее правило 3–10</span><span class="rule-main-ar" dir="rtl" lang="ar">الْعَدَدُ يُخَالِفُ الْمَعْدُودَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَالْمَعْدُودُ جَمْعٌ مَجْرُورٌ بِالْإِضَافَةِ.</span><p class="rule-study-text">В числах от трёх до десяти числительное противоположно считаемому слову по роду. После числа ставится множественное число в родительном падеже как <span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span>. Род определяют по единственному числу считаемого слова, а не по форме множественного.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Мужской род считаемого слова</span><p class="rule-study-text">Если единственное число считаемого слова мужского рода, число имеет форму с <span dir="rtl" lang="ar">تَاءٍ مَرْبُوطَةٍ</span>: <span dir="rtl" lang="ar">ثَلَاثَةُ، أَرْبَعَةُ، خَمْسَةُ، سِتَّةُ، سَبْعَةُ، ثَمَانِيَةُ، تِسْعَةُ، عَشَرَةُ</span>.</p><div class="rule-example-list"><div class="rule-example-card rule-term-number"><span class="rule-example-ar" dir="rtl" lang="ar">ثَلَاثَةُ طُلَّابٍ · أَرْبَعَةُ رِجَالٍ · خَمْسَةُ كُتُبٍ · سِتَّةُ أَبْوَابٍ</span><span class="rule-example-ru">три студента · четыре мужчины · пять книг · шесть дверей</span></div><div class="rule-example-card rule-term-number"><span class="rule-example-ar" dir="rtl" lang="ar">عِنْدِي سَبْعَةُ أَقْلَامٍ.</span><span class="rule-example-ru">У меня семь ручек.</span></div><div class="rule-example-card rule-term-number"><span class="rule-example-ar" dir="rtl" lang="ar">ثَمَنُ هَذَا الْكِتَابِ ثَمَانِيَةُ رِيَالَاتٍ.</span><span class="rule-example-ru">Цена этой книги — восемь риалов.</span></div><div class="rule-example-card rule-term-number"><span class="rule-example-ar" dir="rtl" lang="ar">لِي تِسْعَةُ أَعْمَامٍ. فِي هَذَا الْفَصْلِ عَشَرَةُ طُلَّابٍ.</span><span class="rule-example-ru">У меня девять дядей по отцу. В этой аудитории десять студентов.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор рода</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">خَمْسَةُ كُتُبٍ</span><span class="rule-example-ru">Число خَمْسَةُ имеет форму женского рода, потому что единственное число считаемого слова كِتَابٌ — мужского рода.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">ثَمَانِيَةُ رِيَالَاتٍ</span><span class="rule-example-ru">Число ثَمَانِيَةُ имеет форму женского рода, потому что единственное число считаемого слова رِيَالٌ — мужского рода.</span></div></div></div></div>$$
  where id = masculine_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (masculine_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْعَدَدُ مِنْ ( ٣ إِلَى ١٠ ) يُخَالِفُ الْمَعْدُودَ فِي التَّذْكِيرِ، وَالتَّأْنِيثِ ( أَيْ : إِذَا كَانَ الْمَعْدُودُ مُذَكَّرًا فَإِنَّ الْعَدَدَ يَكُونُ مُؤَنَّثًا، وَإِذَا كَانَ الْمَعْدُودُ مُؤَنَّثًا فَإِنَّ الْعَدَدَ يَكُونُ مُذَكَّرًا ) .
وَالْمَعْدُودُ يَكُونُ جَمْعًا مَجْرُورًا بِالْإِضَافَةِ ( أَيْ يَكُونُ مُضَافًا إِلَيْهِ ) .$$, 32, 32, 1),
    (masculine_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَمْثِلَةٌ لِلْمَعْدُودِ الْمُذَكَّرِ : ثَلَاثَةُ طُلَّابٍ . أَرْبَعَةُ رِجَالٍ . خَمْسَةُ كُتُبٍ . سِتَّةُ أَبْوَابٍ .
عِنْدِي سَبْعَةُ أَقْلَامٍ . ثَمَنُ هَذَا الْكِتَابِ ثَمَانِيَةُ رِيَالَاتٍ . لِي تِسْعَةُ أَعْمَامٍ . فِي هَذَا الْفَصْلِ عَشَرَةُ طُلَّابٍ .$$, 32, 32, 2),
    (masculine_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْحُكْمُ فِي تَذْكِيرِ الْعَدَدِ، وَتَأْنِيثِهِ عَلَى الْمُفْرَدِ فِي الْمَعْدُودِ، وَلَيْسَ عَلَى الْجَمْعِ .
أَمْثِلَةٌ : خَمْسَةُ كُتُبٍ . أُنِّثَ الْعَدَدُ ( خَمْسَةٌ ) لِأَنَّ الْمُفْرَدَ فِي الْمَعْدُودِ مُذَكَّرٌ ( كِتَابٌ ) .
ثَمَانِيَةُ رِيَالَاتٍ . أُنِّثَ الْعَدَدُ ( ثَمَانِيَةٌ ) لِأَنَّ الْمُفْرَدَ فِي الْمَعْدُودِ مُذَكَّرٌ ( رِيَالٌ ) .$$, 32, 32, 3);

  update public.rules
  set sort_order = 1,
      title = 'الْعَدَدُ مِنْ ثَلَاثَةٍ إِلَى عَشَرَةٍ مَعَ الْمَعْدُودِ الْمُؤَنَّثِ (числа 3–10 с существительным женского рода)',
      rule_ar = 'إِذَا كَانَ الْمَعْدُودُ مُؤَنَّثًا جَاءَ الْعَدَدُ مِنْ ثَلَاثَةٍ إِلَى عَشَرَةٍ مُذَكَّرًا، وَجَاءَ الْمَعْدُودُ جَمْعًا مَجْرُورًا بِالْإِضَافَةِ.',
      summary = 'إِذَا كَانَ الْمَعْدُودُ مُؤَنَّثًا جَاءَ الْعَدَدُ مِنْ ثَلَاثَةٍ إِلَى عَشَرَةٍ مُذَكَّرًا، وَجَاءَ الْمَعْدُودُ جَمْعًا مَجْرُورًا بِالْإِضَافَةِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Женский род считаемого слова</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا كَانَ الْمَعْدُودُ مُؤَنَّثًا جَاءَ الْعَدَدُ مُذَكَّرًا.</span><p class="rule-study-text">Если единственное число считаемого слова женского рода, число от трёх до десяти имеет форму без <span dir="rtl" lang="ar">تَاءٍ مَرْبُوطَةٍ</span>: <span dir="rtl" lang="ar">ثَلَاثُ، أَرْبَعُ، خَمْسُ، سِتُّ، سَبْعُ، ثَمَانِي، تِسْعُ، عَشْرُ</span>. Считаемое слово остаётся множественным и родительным.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-number"><span class="rule-example-ar" dir="rtl" lang="ar">ثَلَاثُ طَالِبَاتٍ · أَرْبَعُ نِسَاءٍ · خَمْسُ كَلِمَاتٍ · سِتُّ سَاعَاتٍ</span><span class="rule-example-ru">три студентки · четыре женщины · пять слов · шесть часов</span></div><div class="rule-example-card rule-term-number"><span class="rule-example-ar" dir="rtl" lang="ar">عِنْدِي سَبْعُ دَرَّاجَاتٍ.</span><span class="rule-example-ru">У меня семь велосипедов.</span></div><div class="rule-example-card rule-term-number"><span class="rule-example-ar" dir="rtl" lang="ar">ثَمَنُ هَذَا الْكِتَابِ ثَمَانِي رُوبِيَّاتٍ.</span><span class="rule-example-ru">Цена этой книги — восемь рупий.</span></div><div class="rule-example-card rule-term-number"><span class="rule-example-ar" dir="rtl" lang="ar">لِي تِسْعُ عَمَّاتٍ. فِي هَذَا الْفَصْلِ عَشْرُ طَالِبَاتٍ.</span><span class="rule-example-ru">У меня девять тёток по отцу. В этой аудитории десять студенток.</span></div></div></div></div>$$
  where id = feminine_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (feminine_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَمْثِلَةٌ لِلْمَعْدُودِ الْمُؤَنَّثِ : ثَلَاثُ طَالِبَاتٍ . أَرْبَعُ نِسَاءٍ . خَمْسُ كَلِمَاتٍ . سِتُّ سَاعَاتٍ .
عِنْدِي سَبْعُ دَرَّاجَاتٍ . ثَمَنُ هَذَا الْكِتَابِ ثَمَانِي رُوبِيَّاتٍ . لِي تِسْعُ عَمَّاتٍ . فِي هَذَا الْفَصْلِ عَشْرُ طَالِبَاتٍ .$$, 32, 32, 1),
    (feminine_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْعَدَدُ مِنْ ( ٣ إِلَى ١٠ ) يُخَالِفُ الْمَعْدُودَ فِي التَّذْكِيرِ، وَالتَّأْنِيثِ ( أَيْ : إِذَا كَانَ الْمَعْدُودُ مُذَكَّرًا فَإِنَّ الْعَدَدَ يَكُونُ مُؤَنَّثًا، وَإِذَا كَانَ الْمَعْدُودُ مُؤَنَّثًا فَإِنَّ الْعَدَدَ يَكُونُ مُذَكَّرًا ) .
وَالْمَعْدُودُ يَكُونُ جَمْعًا مَجْرُورًا بِالْإِضَافَةِ ( أَيْ يَكُونُ مُضَافًا إِلَيْهِ ) .$$, 32, 32, 2);
end;
$migration$;

commit;
