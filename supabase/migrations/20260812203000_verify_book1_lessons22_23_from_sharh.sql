-- Verify Medina Book 1 lessons 22 and 23 against their combined sharh section.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 35-36.

begin;

do $migration$
declare
  types_rule_id bigint;
  genitive_rule_id bigint;
  majrur_rule_id bigint;
begin
  select id into strict types_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '22' and sort_order = 1;
  select id into strict genitive_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '23' and sort_order = 1;
  select id into strict majrur_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '23' and sort_order = 2;

  delete from public.rule_sections where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number in ('22', '23')
  );
  delete from public.rule_sources where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number in ('22', '23')
  );
  update public.rules set sort_order = sort_order + 100 where id in (types_rule_id, genitive_rule_id, majrur_rule_id);

  update public.rules
  set sort_order = 1,
      title = 'الْمَمْنُوعُ مِنَ الصَّرْفِ وَأَنْوَاعُهُ (диптот и его виды)',
      rule_ar = 'الْمَمْنُوعُ مِنَ الصَّرْفِ اِسْمٌ لَا يُنَوَّنُ، وَيُجَرُّ بِالْفَتْحَةِ نِيَابَةً عَنِ الْكَسْرَةِ. وَمِنْ أَنْوَاعِهِ: الْعَلَمُ الْمُؤَنَّثُ، وَالْعَلَمُ الْمُؤَنَّثُ فِي اللَّفْظِ الْمُذَكَّرُ فِي الْمَعْنَى، وَالْعَلَمُ الْمَخْتُومُ بِأَلِفٍ وَنُونٍ زَائِدَتَيْنِ، وَالْعَلَمُ الَّذِي عَلَى وَزْنِ الْفِعْلِ، وَالْعَلَمُ الْأَعْجَمِيُّ، وَالصِّفَةُ الَّتِي عَلَى وَزْنِ أَفْعَلَ أَوْ فَعْلَانَ، وَالِاسْمُ الْمَخْتُومُ بِأَلِفٍ مَمْدُودَةٍ، وَالِاسْمُ الَّذِي عَلَى وَزْنِ مَفَاعِلَ أَوْ مَفَاعِيلَ.',
      summary = 'الْمَمْنُوعُ مِنَ الصَّرْفِ اِسْمٌ لَا يُنَوَّنُ، وَيُجَرُّ بِالْفَتْحَةِ نِيَابَةً عَنِ الْكَسْرَةِ. وَمِنْ أَنْوَاعِهِ: الْعَلَمُ الْمُؤَنَّثُ، وَالْعَلَمُ الْمُؤَنَّثُ فِي اللَّفْظِ الْمُذَكَّرُ فِي الْمَعْنَى، وَالْعَلَمُ الْمَخْتُومُ بِأَلِفٍ وَنُونٍ زَائِدَتَيْنِ، وَالْعَلَمُ الَّذِي عَلَى وَزْنِ الْفِعْلِ، وَالْعَلَمُ الْأَعْجَمِيُّ، وَالصِّفَةُ الَّتِي عَلَى وَزْنِ أَفْعَلَ أَوْ فَعْلَانَ، وَالِاسْمُ الْمَخْتُومُ بِأَلِفٍ مَمْدُودَةٍ، وَالِاسْمُ الَّذِي عَلَى وَزْنِ مَفَاعِلَ أَوْ مَفَاعِيلَ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Определение автора</span><span class="rule-main-ar" dir="rtl" lang="ar">الْمَمْنُوعُ مِنَ الصَّرْفِ: اِسْمٌ لَا يُنَوَّنُ، وَيُجَرُّ بِالْفَتْحَةِ نِيَابَةً عَنِ الْكَسْرَةِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">الْمَمْنُوعُ مِنَ الصَّرْفِ</span> — имя, которое не принимает танвин и в родительном падеже получает фатху вместо касры.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все 11 видов из шарха</span><table><thead><tr><th>№</th><th>Вид</th><th>Примеры автора</th><th>Русский смысл вида</th></tr></thead><tbody><tr><td>1</td><td><span dir="rtl" lang="ar">الْعَلَمُ الْمُؤَنَّثُ</span></td><td><span dir="rtl" lang="ar">مَرْيَمُ، زَيْنَبُ، عَائِشَةُ، مَكَّةُ، جُدَّةُ</span></td><td>женское собственное имя</td></tr><tr><td>2</td><td><span dir="rtl" lang="ar">الْعَلَمُ الْمُؤَنَّثُ فِي اللَّفْظِ، وَمَعْنَاهُ مُذَكَّرٌ</span></td><td><span dir="rtl" lang="ar">حَمْزَةُ، مُعَاوِيَةُ، طَلْحَةُ</span></td><td>собственное имя, женское по форме, но мужское по значению</td></tr><tr><td>3</td><td><span dir="rtl" lang="ar">الْعَلَمُ الْمَخْتُومُ بِأَلِفٍ وَنُونٍ زَائِدَتَيْنِ</span></td><td><span dir="rtl" lang="ar">عُثْمَانُ، عَفَّانُ، سُفْيَانُ، مَرْوَانُ، رَمَضَانُ</span></td><td>собственное имя с добавочными алифом и нуном в конце</td></tr><tr><td>4</td><td><span dir="rtl" lang="ar">الْعَلَمُ الَّذِي عَلَى وَزْنِ الْفِعْلِ</span></td><td><span dir="rtl" lang="ar">أَحْمَدُ، أَنْوَرُ، يَزِيدُ</span></td><td>собственное имя по модели глагола</td></tr><tr><td>5</td><td><span dir="rtl" lang="ar">الْعَلَمُ الْأَعْجَمِيُّ</span></td><td><span dir="rtl" lang="ar">إِبْرَاهِيمُ، يَعْقُوبُ، وَلِيَمُ، إِدْوَرْدُ، بَاكِسْتَانُ، بَارِيسُ</span></td><td>иноязычное собственное имя</td></tr><tr><td>6</td><td><span dir="rtl" lang="ar">الصِّفَةُ الَّتِي عَلَى وَزْنِ أَفْعَلَ</span></td><td><span dir="rtl" lang="ar">أَبْيَضُ، أَحْمَرُ، أَخْضَرُ</span></td><td>прилагательное по модели أَفْعَلُ</td></tr><tr><td>7</td><td><span dir="rtl" lang="ar">الصِّفَةُ الَّتِي عَلَى وَزْنِ فَعْلَانَ</span></td><td><span dir="rtl" lang="ar">كَسْلَانُ، جَوْعَانُ، عَطْشَانُ، غَضْبَانُ</span></td><td>прилагательное по модели فَعْلَانُ</td></tr><tr><td>8</td><td><span dir="rtl" lang="ar">الِاسْمُ الْمَخْتُومُ بِأَلِفٍ مَمْدُودَةٍ عَلَى وَزْنِ أَفْعِلَاءَ</span></td><td><span dir="rtl" lang="ar">أَغْنِيَاءُ، أَصْدِقَاءُ، أَطِبَّاءُ، أَقْوِيَاءُ</span></td><td>имя с длинным алифом и хамзой в конце по модели أَفْعِلَاءُ</td></tr><tr><td>9</td><td><span dir="rtl" lang="ar">الِاسْمُ الْمَخْتُومُ بِأَلِفٍ مَمْدُودَةٍ عَلَى وَزْنِ فُعَلَاءَ</span></td><td><span dir="rtl" lang="ar">فُقَرَاءُ، وُزَرَاءُ، زُمَلَاءُ، عُلَمَاءُ</span></td><td>имя с длинным алифом и хамзой в конце по модели فُعَلَاءُ</td></tr><tr><td>10</td><td><span dir="rtl" lang="ar">الِاسْمُ الَّذِي عَلَى وَزْنِ مَفَاعِلَ</span></td><td><span dir="rtl" lang="ar">مَسَاجِدُ، مَعَاهِدُ، فَنَادِقُ، مَكَاتِبُ</span></td><td>имя по модели مَفَاعِلُ</td></tr><tr><td>11</td><td><span dir="rtl" lang="ar">الِاسْمُ الَّذِي عَلَى وَزْنِ مَفَاعِيلَ</span></td><td><span dir="rtl" lang="ar">مَنَادِيلُ، مَفَاتِيحُ، فَنَاجِينُ، كَرَاسِيُّ</span></td><td>имя по модели مَفَاعِيلُ</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Без танвина</span><div class="rule-example-list"><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">مَرْيَمٌ ✕ · حَمْزَةٌ ✕ · عُثْمَانٌ ✕ · أَحْمَدٌ ✕ · إِبْرَاهِيمٌ ✕ · أَبْيَضٌ ✕</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">كَسْلَانٌ ✕ · أَغْنِيَاءٌ ✕ · فُقَرَاءٌ ✕ · مَسَاجِدٌ ✕ · مَنَادِيلٌ ✕</span></div></div></div></div>$$
  where id = types_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (types_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الدَّرْسَانِ الثَّانِي وَالْعِشْرُونَ، وَالثَّالِثُ وَالْعِشْرُونَ
الْمَمْنُوعُ مِنَ الصَّرْفِ
الْمَمْنُوعُ مِنَ الصَّرْفِ : اِسْمٌ لَا يُنَوَّنُ، وَيُجَرُّ بِالْفَتْحَةِ نِيَابَةً عَنِ الْكَسْرَةِ .
أَنْوَاعُ الْأَسْمَاءِ الْمَمْنُوعَةِ مِنَ الصَّرْفِ :
١- الْعَلَمُ الْمُؤَنَّثُ : مَرْيَمُ، زَيْنَبُ، عَائِشَةُ، مَكَّةُ، جُدَّةُ .
٢- الْعَلَمُ الْمُؤَنَّثُ فِي اللَّفْظِ، وَمَعْنَاهُ مُذَكَّرٌ : حَمْزَةُ، مُعَاوِيَةُ، طَلْحَةُ .
٣- الْعَلَمُ الْمَخْتُومُ بِأَلِفٍ وَنُونٍ زَائِدَتَيْنِ : عُثْمَانُ، عَفَّانُ، سُفْيَانُ، مَرْوَانُ، رَمَضَانُ .$$, 35, 35, 1),
    (types_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$٤- الْعَلَمُ الَّذِي عَلَى وَزْنِ الْفِعْلِ : أَحْمَدُ، أَنْوَرُ، يَزِيدُ .
٥- الْعَلَمُ الْأَعْجَمِيُّ : إِبْرَاهِيمُ، يَعْقُوبُ، وَلِيَمُ، إِدْوَرْدُ، بَاكِسْتَانُ، بَارِيسُ .
٦- الصِّفَةُ الَّتِي عَلَى وَزْنِ أَفْعَلَ : أَبْيَضُ، أَحْمَرُ، أَخْضَرُ .
٧- الصِّفَةُ الَّتِي عَلَى وَزْنِ فَعْلَانَ : كَسْلَانُ، جَوْعَانُ، عَطْشَانُ، غَضْبَانُ .
٨- الِاسْمُ الْمَخْتُومُ بِأَلِفٍ مَمْدُودَةٍ ( عَلَى وَزْنِ أَفْعِلَاءَ ) : أَغْنِيَاءُ، أَصْدِقَاءُ، أَطِبَّاءُ، أَقْوِيَاءُ .
٩- الِاسْمُ الْمَخْتُومُ بِأَلِفٍ مَمْدُودَةٍ ( عَلَى وَزْنِ فُعَلَاءَ ) : فُقَرَاءُ، وُزَرَاءُ، زُمَلَاءُ، عُلَمَاءُ .
١٠- الِاسْمُ الَّذِي عَلَى وَزْنِ مَفَاعِلَ : مَسَاجِدُ، مَعَاهِدُ، فَنَادِقُ، مَكَاتِبُ .
١١- الِاسْمُ الَّذِي عَلَى وَزْنِ مَفَاعِيلَ : مَنَادِيلُ، مَفَاتِيحُ، فَنَاجِينُ، كَرَاسِيُّ .$$, 35, 35, 2),
    (types_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$مَرْيَمٌ ✕ حَمْزَةٌ ✕ عُثْمَانٌ ✕ أَحْمَدٌ ✕ إِبْرَاهِيمٌ ✕ أَبْيَضٌ ✕
كَسْلَانٌ ✕ أَغْنِيَاءٌ ✕ فُقَرَاءٌ ✕ مَسَاجِدٌ ✕ مَنَادِيلٌ ✕$$, 36, 36, 3);

  update public.rules
  set sort_order = 1,
      title = 'جَرُّ الْمَمْنُوعِ مِنَ الصَّرْفِ بِالْفَتْحَةِ (родительный падеж диптота с фатхой)',
      rule_ar = 'الْمَمْنُوعُ مِنَ الصَّرْفِ يُجَرُّ بِالْفَتْحَةِ نِيَابَةً عَنِ الْكَسْرَةِ.',
      summary = 'الْمَمْنُوعُ مِنَ الصَّرْفِ يُجَرُّ بِالْفَتْحَةِ نِيَابَةً عَنِ الْكَسْرَةِ.',
      rule_kind = 'important',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الْمَمْنُوعُ مِنَ الصَّرْفِ يُجَرُّ بِالْفَتْحَةِ.</span><p class="rule-study-text">Диптот в родительном падеже получает фатху вместо обычной касры.</p></div><div class="rule-study-card"><span class="rule-card-kicker">После предлога</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبْتُ إِلَى زَيْنَبَ.</span><span class="rule-example-ru">Я пошёл к Зайнаб.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الْكِتَابُ لِأَحْمَدَ.</span><span class="rule-example-ru">Эта книга принадлежит Ахмаду.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا مِنْ بَاكِسْتَانَ. عَمَّارٌ فِي لَنْدَنَ. الْكَعْبَةُ فِي مَكَّةَ.</span><span class="rule-example-ru">Я из Пакистана. Аммар в Лондоне. Кааба в Мекке.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Сравнение автора</span><table><thead><tr><th>Обычное склоняемое имя</th><th>Диптот</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">هَذَا لِمُحَمَّدٍ.</span><br><span dir="rtl" lang="ar">مَجْرُورٌ بِالْكَسْرَةِ لِأَنَّهُ لَيْسَ مَمْنُوعًا مِنَ الصَّرْفِ.</span></td><td><span dir="rtl" lang="ar">هَذَا لِحَمْزَةَ.</span><br><span dir="rtl" lang="ar">مَجْرُورٌ بِالْفَتْحَةِ لِأَنَّهُ مَمْنُوعٌ مِنَ الصَّرْفِ.</span></td></tr><tr><td><span dir="rtl" lang="ar">كِتَابُ مُحَمَّدٍ ✓ · كِتَابُ مُحَمَّدَ ✕</span></td><td><span dir="rtl" lang="ar">كِتَابُ حَمْزَةَ ✓ · كِتَابُ حَمْزَةِ ✕</span></td></tr></tbody></table></div></div>$$
  where id = genitive_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (genitive_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْمَمْنُوعُ مِنَ الصَّرْفِ يُجَرُّ بِالْفَتْحَةِ :
ذَهَبْتُ إِلَى زَيْنَبَ . هَذَا الْكِتَابُ لِأَحْمَدَ . أَنَا مِنْ بَاكِسْتَانَ . عَمَّارٌ فِي لَنْدَنَ . الْكَعْبَةُ فِي مَكَّةَ .$$, 36, 36, 1),
    (genitive_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هَذَا لِمُحَمَّدٍ . مَجْرُورٌ بِالْكَسْرَةِ لِأَنَّهُ لَيْسَ مَمْنُوعًا مِنَ الصَّرْفِ .
هَذَا لِحَمْزَةَ . مَجْرُورٌ بِالْفَتْحَةِ لِأَنَّهُ مَمْنُوعٌ مِنَ الصَّرْفِ .
كِتَابُ مُحَمَّدٍ ✓ كِتَابُ مُحَمَّدَ ✕ كِتَابُ حَمْزَةَ ✓ كِتَابُ حَمْزَةِ ✕$$, 36, 36, 2);

  update public.rules
  set sort_order = 2,
      title = 'نَوْعَا الْمَجْرُورِ (два вида имени в родительном падеже)',
      rule_ar = 'الْمَجْرُورُ نَوْعَانِ: مَجْرُورٌ بِحَرْفِ الْجَرِّ، وَمَجْرُورٌ بِالْإِضَافَةِ.',
      summary = 'الْمَجْرُورُ نَوْعَانِ: مَجْرُورٌ بِحَرْفِ الْجَرِّ، وَمَجْرُورٌ بِالْإِضَافَةِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило автора</span><span class="rule-main-ar" dir="rtl" lang="ar">الْمَجْرُورُ نَوْعَانِ: مَجْرُورٌ بِحَرْفِ الْجَرِّ، وَمَجْرُورٌ بِالْإِضَافَةِ.</span><p class="rule-study-text">Имя становится <span dir="rtl" lang="ar">مَجْرُورًا</span> либо после предлога, либо как второй член идафы.</p></div><div class="rule-study-card"><span class="rule-card-kicker">1 · Предлог</span><p class="rule-study-text">Примеры: <span dir="rtl" lang="ar">إِلَى زَيْنَبَ، لِأَحْمَدَ، مِنْ بَاكِسْتَانَ، فِي لَنْدَنَ، فِي مَكَّةَ</span>. Предлог управляет следующим именем.</p></div><div class="rule-study-card"><span class="rule-card-kicker">2 · Идафа</span><table><thead><tr><th>Пример</th><th><span dir="rtl" lang="ar">مُضَافٌ</span><br>первый член</th><th><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span><br>второй член</th><th>Перевод</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">بَيْتُ زَيْنَبَ جَمِيلٌ</span></td><td><span dir="rtl" lang="ar">بَيْتُ</span></td><td><span dir="rtl" lang="ar">زَيْنَبَ</span></td><td>Дом Зайнаб красив.</td></tr><tr><td><span dir="rtl" lang="ar">هَذَا كِتَابُ أَحْمَدَ</span></td><td><span dir="rtl" lang="ar">كِتَابُ</span></td><td><span dir="rtl" lang="ar">أَحْمَدَ</span></td><td>Это книга Ахмада.</td></tr><tr><td><span dir="rtl" lang="ar">عِنْدِي خَمْسَةُ مَفَاتِيحَ</span></td><td><span dir="rtl" lang="ar">خَمْسَةُ</span></td><td><span dir="rtl" lang="ar">مَفَاتِيحَ</span></td><td>У меня пять ключей.</td></tr><tr><td><span dir="rtl" lang="ar">أُخْتُ مَرْوَانَ مَرِيضَةٌ</span></td><td><span dir="rtl" lang="ar">أُخْتُ</span></td><td><span dir="rtl" lang="ar">مَرْوَانَ</span></td><td>Сестра Марвана больна.</td></tr></tbody></table></div></div>$$
  where id = majrur_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (majrur_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْمَجْرُورُ نَوْعَانِ :
١- مَجْرُورٌ بِحَرْفِ الْجَرِّ، كَمَا فِي الْأَمْثِلَةِ السَّابِقَةِ .
٢- مَجْرُورٌ بِالْإِضَافَةِ : بَيْتُ زَيْنَبَ جَمِيلٌ . هَذَا كِتَابُ أَحْمَدَ . عِنْدِي خَمْسَةُ مَفَاتِيحَ . أُخْتُ مَرْوَانَ مَرِيضَةٌ .$$, 36, 36, 1),
    (majrur_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$بَيْتُ زَيْنَبَ : بَيْتُ مُضَافٌ، زَيْنَبَ مُضَافٌ إِلَيْهِ .
كِتَابُ أَحْمَدَ : كِتَابُ مُضَافٌ، أَحْمَدَ مُضَافٌ إِلَيْهِ .
خَمْسَةُ مَفَاتِيحَ : خَمْسَةُ مُضَافٌ، مَفَاتِيحَ مُضَافٌ إِلَيْهِ .
أُخْتُ مَرْوَانَ : أُخْتُ مُضَافٌ، مَرْوَانَ مُضَافٌ إِلَيْهِ .$$, 36, 36, 2);
end;
$migration$;

commit;
