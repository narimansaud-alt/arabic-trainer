-- Verify Medina Book 1 lessons 16 and 17 against their combined sharh section.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 28-29.

begin;

do $migration$
declare
  lesson16_rule_id bigint;
  lesson16_extra_id bigint;
  lesson17_rule_id bigint;
  lesson17_plurals_id bigint;
  lesson17_extra_id bigint;
begin
  select id into strict lesson16_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '16' and sort_order = 1;
  select id into strict lesson16_extra_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '16' and sort_order = 2;
  select id into strict lesson17_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '17' and sort_order = 1;
  select id into strict lesson17_plurals_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '17' and sort_order = 2;
  select id into strict lesson17_extra_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '17' and sort_order = 3;

  delete from public.rule_sections where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number in ('16', '17')
  );
  delete from public.rule_sources where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number in ('16', '17')
  );
  delete from public.rules where id in (lesson16_extra_id, lesson17_extra_id);
  update public.rules set sort_order = sort_order + 100
  where id in (lesson16_rule_id, lesson17_rule_id, lesson17_plurals_id);

  update public.rules
  set sort_order = 1,
      title = 'الْمُبْتَدَأُ وَالْخَبَرُ (мубтада и хабар)',
      rule_ar = 'الْمُبْتَدَأُ اِسْمٌ يَقَعُ فِي أَوَّلِ الْجُمْلَةِ، وَالْخَبَرُ اِسْمٌ يَقَعُ بَعْدَ الْمُبْتَدَأِ وَتَحْصُلُ بِهِ الْفَائِدَةُ.',
      summary = 'الْمُبْتَدَأُ اِسْمٌ يَقَعُ فِي أَوَّلِ الْجُمْلَةِ، وَالْخَبَرُ اِسْمٌ يَقَعُ بَعْدَ الْمُبْتَدَأِ وَتَحْصُلُ بِهِ الْفَائِدَةُ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Определения автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الْمُبْتَدَأُ: اِسْمٌ يَقَعُ فِي أَوَّلِ الْجُمْلَةِ.</span><span class="rule-example-ru"><span dir="rtl" lang="ar">الْمُبْتَدَأُ</span> — имя, которое находится в начале предложения.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">الْخَبَرُ: اِسْمٌ يَقَعُ بَعْدَ الْمُبْتَدَأِ، وَتَحْصُلُ بِهِ الْفَائِدَةُ.</span><span class="rule-example-ru"><span dir="rtl" lang="ar">الْخَبَرُ</span> — имя, которое следует после мубтада и завершает полезное сообщение.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Все примеры таблицы</span><table><thead><tr><th><span dir="rtl" lang="ar">الْمُبْتَدَأُ</span></th><th><span dir="rtl" lang="ar">الْخَبَرُ</span></th><th>Перевод</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">هَذَا</span></td><td><span dir="rtl" lang="ar">طَالِبٌ</span></td><td>Это студент.</td></tr><tr><td><span dir="rtl" lang="ar">الْبَابُ</span></td><td><span dir="rtl" lang="ar">مَفْتُوحٌ</span></td><td>Дверь открыта.</td></tr><tr><td><span dir="rtl" lang="ar">هَؤُلَاءِ</span></td><td><span dir="rtl" lang="ar">مُهَنْدِسُونَ</span></td><td>Эти люди — инженеры.</td></tr><tr><td><span dir="rtl" lang="ar">هُوَ</span></td><td><span dir="rtl" lang="ar">مُجْتَهِدٌ</span></td><td>Он усердный.</td></tr><tr><td><span dir="rtl" lang="ar">هُمْ</span></td><td><span dir="rtl" lang="ar">أَذْكِيَاءُ</span></td><td>Они умные.</td></tr><tr><td><span dir="rtl" lang="ar">النُّجُومُ</span></td><td><span dir="rtl" lang="ar">جَمِيلَةٌ</span></td><td>Звёзды красивые.</td></tr><tr><td><span dir="rtl" lang="ar">أَنْتَ</span></td><td><span dir="rtl" lang="ar">ذَكِيٌّ</span></td><td>Ты умный.</td></tr><tr><td><span dir="rtl" lang="ar">أَنْتُنَّ</span></td><td><span dir="rtl" lang="ar">طَبِيبَاتٌ</span></td><td>Вы — врачи-женщины.</td></tr><tr><td><span dir="rtl" lang="ar">الطُّلَّابُ</span></td><td><span dir="rtl" lang="ar">نَاجِحُونَ</span></td><td>Студенты успешны.</td></tr></tbody></table></div></div>$$
  where id = lesson16_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (lesson16_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الدَّرْسَانِ السَّادِسَ عَشَرَ، وَالسَّابِعَ عَشَرَ
الْمُبْتَدَأُ، وَالْخَبَرُ
الْمُبْتَدَأُ : اِسْمٌ يَقَعُ فِي أَوَّلِ الْجُمْلَةِ .
الْخَبَرُ : اِسْمٌ يَقَعُ بَعْدَ الْمُبْتَدَأِ، وَتَحْصُلُ بِهِ الْفَائِدَةُ .$$, 28, 28, 1),
    (lesson16_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَمْثِلَةٌ لِلْمُبْتَدَأِ وَالْخَبَرِ :
هَذَا طَالِبٌ . الْبَابُ مَفْتُوحٌ . هَؤُلَاءِ مُهَنْدِسُونَ . هُوَ مُجْتَهِدٌ . هُمْ أَذْكِيَاءُ .
النُّجُومُ جَمِيلَةٌ . أَنْتَ ذَكِيٌّ . أَنْتُنَّ طَبِيبَاتٌ . الطُّلَّابُ نَاجِحُونَ .$$, 28, 28, 2);

  update public.rules
  set sort_order = 1,
      title = 'الْإِشَارَةُ إِلَى جَمْعِ غَيْرِ الْعَاقِلِ (указание на неразумное множественное)',
      rule_ar = 'يُشَارُ إِلَى جَمْعِ غَيْرِ الْعَاقِلِ بِـ«هَذِهِ» إِذَا كَانَ قَرِيبًا، وَبِـ«تِلْكَ» إِذَا كَانَ بَعِيدًا، وَيُعَامَلُ مُعَامَلَةَ الْمُفْرَدِ الْمُؤَنَّثِ.',
      summary = 'يُشَارُ إِلَى جَمْعِ غَيْرِ الْعَاقِلِ بِـ«هَذِهِ» إِذَا كَانَ قَرِيبًا، وَبِـ«تِلْكَ» إِذَا كَانَ بَعِيدًا، وَيُعَامَلُ مُعَامَلَةَ الْمُفْرَدِ الْمُؤَنَّثِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">جَمْعُ غَيْرِ الْعَاقِلِ: هَذِهِ لِلْقَرِيبِ، وَتِلْكَ لِلْبَعِيدِ.</span><p class="rule-study-text">На неразумное множественное число указывают формой женского рода единственного числа: <span dir="rtl" lang="ar">هَذِهِ</span> для близкого и <span dir="rtl" lang="ar">تِلْكَ</span> для далёкого. Сказуемое в примерах автора также имеет форму женского рода единственного числа.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Близко: هَذِهِ</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ كُتُبٌ. هَذِهِ بُيُوتٌ.</span><span class="rule-example-ru">Это книги. Это дома.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ الْأَبْوَابُ مَفْتُوحَةٌ. هَذِهِ الدُّرُوسُ سَهْلَةٌ.</span><span class="rule-example-ru">Эти двери открыты. Эти уроки лёгкие.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Далеко: تِلْكَ</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">تِلْكَ كُتُبٌ. تِلْكَ بُيُوتٌ.</span><span class="rule-example-ru">То книги. То дома.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">تِلْكَ النَّوَافِذُ مُغْلَقَةٌ. تِلْكَ الطَّائِرَاتُ كَبِيرَةٌ.</span><span class="rule-example-ru">Те окна закрыты. Те самолёты большие.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Выбор указательного имени</span><table><thead><tr><th>Верно</th><th>Неверно</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">هَذِهِ كُتُبٌ ✓</span></td><td><span dir="rtl" lang="ar">هَذَا كُتُبٌ ✕ · هَؤُلَاءِ كُتُبٌ ✕</span></td></tr><tr><td><span dir="rtl" lang="ar">تِلْكَ كُتُبٌ ✓</span></td><td><span dir="rtl" lang="ar">ذَلِكَ كُتُبٌ ✕ · أُولَئِكَ كُتُبٌ ✕</span></td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор автора</span><table><thead><tr><th>Пример</th><th>Указательное имя</th><th>Следующее имя</th><th>Сообщение</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">هَذِهِ الْأَبْوَابُ مَفْتُوحَةٌ</span></td><td><span dir="rtl" lang="ar">هَذِهِ — مُبْتَدَأٌ</span></td><td><span dir="rtl" lang="ar">الْأَبْوَابُ — بَدَلٌ</span></td><td><span dir="rtl" lang="ar">مَفْتُوحَةٌ — خَبَرٌ</span></td></tr><tr><td><span dir="rtl" lang="ar">تِلْكَ النَّوَافِذُ مُغْلَقَةٌ</span></td><td><span dir="rtl" lang="ar">تِلْكَ — مُبْتَدَأٌ</span></td><td><span dir="rtl" lang="ar">النَّوَافِذُ — بَدَلٌ</span></td><td><span dir="rtl" lang="ar">مُغْلَقَةٌ — خَبَرٌ</span></td></tr></tbody></table></div></div>$$
  where id = lesson17_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (lesson17_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْإِشَارَةُ إِلَى جَمْعِ غَيْرِ الْعَاقِلِ
الْجَمْعُ غَيْرُ الْعَاقِلِ لِلْقَرِيبِ ( هَذِهِ ) : هَذِهِ كُتُبٌ . هَذِهِ بُيُوتٌ . هَذِهِ الْأَبْوَابُ مَفْتُوحَةٌ . هَذِهِ الدُّرُوسُ سَهْلَةٌ .
الْجَمْعُ غَيْرُ الْعَاقِلِ لِلْبَعِيدِ ( تِلْكَ ) : تِلْكَ كُتُبٌ . تِلْكَ بُيُوتٌ . تِلْكَ النَّوَافِذُ مُغْلَقَةٌ . تِلْكَ الطَّائِرَاتُ كَبِيرَةٌ .$$, 29, 29, 1),
    (lesson17_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هَذِهِ كُتُبٌ ✓ هَذَا كُتُبٌ ✕ هَؤُلَاءِ كُتُبٌ ✕
تِلْكَ كُتُبٌ ✓ ذَلِكَ كُتُبٌ ✕ أُولَئِكَ كُتُبٌ ✕$$, 29, 29, 2),
    (lesson17_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هَذِهِ الْأَبْوَابُ مَفْتُوحَةٌ : هَذِهِ مُبْتَدَأٌ، الْأَبْوَابُ بَدَلٌ، مَفْتُوحَةٌ خَبَرٌ .
تِلْكَ النَّوَافِذُ مُغْلَقَةٌ : تِلْكَ مُبْتَدَأٌ، النَّوَافِذُ بَدَلٌ، مُغْلَقَةٌ خَبَرٌ .$$, 29, 29, 3);

  update public.rules
  set sort_order = 2,
      title = 'جَمْعُ بَعْضِ الْكَلِمَاتِ (множественное число некоторых слов)',
      rule_ar = 'لِبَعْضِ الْكَلِمَاتِ جَمْعٌ وَاحِدٌ، وَلِبَعْضِهَا أَكْثَرُ مِنْ جَمْعٍ، مِثْلَ: «حِمَارٌ: حَمِيرٌ وَحُمُرٌ»، وَ«بَحْرٌ: بِحَارٌ وَبُحُورٌ»، وَ«قَمِيصٌ: قُمْصَانٌ وَأَقْمِصَةٌ».',
      summary = 'لِبَعْضِ الْكَلِمَاتِ جَمْعٌ وَاحِدٌ، وَلِبَعْضِهَا أَكْثَرُ مِنْ جَمْعٍ، مِثْلَ: «حِمَارٌ: حَمِيرٌ وَحُمُرٌ»، وَ«بَحْرٌ: بِحَارٌ وَبُحُورٌ»، وَ«قَمِيصٌ: قُمْصَانٌ وَأَقْمِصَةٌ».',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Список автора</span><span class="rule-main-ar" dir="rtl" lang="ar">جَمْعُ بَعْضِ الْكَلِمَاتِ</span><p class="rule-study-text">В таблице сохранены все формы со страницы шарха. У некоторых слов автор приводит два допустимых варианта множественного числа.</p></div><div class="rule-study-card"><table><thead><tr><th>Единственное число</th><th>Множественное число</th><th>Русский смысл</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">بَابٌ</span></td><td><span dir="rtl" lang="ar">أَبْوَابٌ</span></td><td>дверь → двери</td></tr><tr><td><span dir="rtl" lang="ar">بَيْتٌ</span></td><td><span dir="rtl" lang="ar">بُيُوتٌ</span></td><td>дом → дома</td></tr><tr><td><span dir="rtl" lang="ar">نَجْمٌ</span></td><td><span dir="rtl" lang="ar">نُجُومٌ</span></td><td>звезда → звёзды</td></tr><tr><td><span dir="rtl" lang="ar">قَلَمٌ</span></td><td><span dir="rtl" lang="ar">أَقْلَامٌ</span></td><td>ручка → ручки</td></tr><tr><td><span dir="rtl" lang="ar">حِمَارٌ</span></td><td><span dir="rtl" lang="ar">حَمِيرٌ، وَحُمُرٌ</span></td><td>осёл → ослы</td></tr><tr><td><span dir="rtl" lang="ar">سَرِيرٌ</span></td><td><span dir="rtl" lang="ar">سُرُرٌ</span></td><td>кровать → кровати</td></tr><tr><td><span dir="rtl" lang="ar">نَهْرٌ</span></td><td><span dir="rtl" lang="ar">أَنْهَارٌ</span></td><td>река → реки</td></tr><tr><td><span dir="rtl" lang="ar">سَيَّارَةٌ</span></td><td><span dir="rtl" lang="ar">سَيَّارَاتٌ</span></td><td>машина → машины</td></tr><tr><td><span dir="rtl" lang="ar">كَلْبٌ</span></td><td><span dir="rtl" lang="ar">كِلَابٌ</span></td><td>собака → собаки</td></tr><tr><td><span dir="rtl" lang="ar">طَائِرَةٌ</span></td><td><span dir="rtl" lang="ar">طَائِرَاتٌ</span></td><td>самолёт → самолёты</td></tr><tr><td><span dir="rtl" lang="ar">دَرْسٌ</span></td><td><span dir="rtl" lang="ar">دُرُوسٌ</span></td><td>урок → уроки</td></tr><tr><td><span dir="rtl" lang="ar">بَحْرٌ</span></td><td><span dir="rtl" lang="ar">بِحَارٌ، وَبُحُورٌ</span></td><td>море → моря</td></tr><tr><td><span dir="rtl" lang="ar">كِتَابٌ</span></td><td><span dir="rtl" lang="ar">كُتُبٌ</span></td><td>книга → книги</td></tr><tr><td><span dir="rtl" lang="ar">قَمِيصٌ</span></td><td><span dir="rtl" lang="ar">قُمْصَانٌ، وَأَقْمِصَةٌ</span></td><td>рубашка → рубашки</td></tr><tr><td><span dir="rtl" lang="ar">دَرَّاجَةٌ</span></td><td><span dir="rtl" lang="ar">دَرَّاجَاتٌ</span></td><td>велосипед → велосипеды</td></tr><tr><td><span dir="rtl" lang="ar">حَقْلٌ</span></td><td><span dir="rtl" lang="ar">حُقُولٌ</span></td><td>поле → поля</td></tr><tr><td><span dir="rtl" lang="ar">جَبَلٌ</span></td><td><span dir="rtl" lang="ar">جِبَالٌ</span></td><td>гора → горы</td></tr><tr><td><span dir="rtl" lang="ar">بِنْتٌ</span></td><td><span dir="rtl" lang="ar">بَنَاتٌ</span></td><td>девочка / дочь → девочки / дочери</td></tr></tbody></table></div></div>$$
  where id = lesson17_plurals_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (lesson17_plurals_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$جَمْعُ بَعْضِ الْكَلِمَاتِ :
بَابٌ : أَبْوَابٌ . بَيْتٌ : بُيُوتٌ . نَجْمٌ : نُجُومٌ .
قَلَمٌ : أَقْلَامٌ . حِمَارٌ : حَمِيرٌ، وَحُمُرٌ . سَرِيرٌ : سُرُرٌ .
نَهْرٌ : أَنْهَارٌ . سَيَّارَةٌ : سَيَّارَاتٌ . كَلْبٌ : كِلَابٌ .
طَائِرَةٌ : طَائِرَاتٌ . دَرْسٌ : دُرُوسٌ . بَحْرٌ : بِحَارٌ، وَبُحُورٌ .
كِتَابٌ : كُتُبٌ . قَمِيصٌ : قُمْصَانٌ، وَأَقْمِصَةٌ . دَرَّاجَةٌ : دَرَّاجَاتٌ .
حَقْلٌ : حُقُولٌ . جَبَلٌ : جِبَالٌ . بِنْتٌ : بَنَاتٌ .$$, 29, 29, 1);
end;
$migration$;

commit;
