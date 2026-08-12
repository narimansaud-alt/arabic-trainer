-- Verify Medina Book 1 lesson 13 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 19-22.

begin;

do $migration$
declare
  idafa_rule_id bigint;
  taa_rule_id bigint;
  near_rule_id bigint;
  hum_rule_id bigint;
  waw_rule_id bigint;
  hunna_rule_id bigint;
  far_rule_id bigint;
  nun_rule_id bigint;
  review_rule_id bigint;
begin
  select id into strict idafa_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '13' and sort_order = 1;
  select id into strict taa_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '13' and sort_order = 2;
  select id into strict near_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '13' and sort_order = 3;
  select id into strict hum_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '13' and sort_order = 4;
  select id into strict waw_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '13' and sort_order = 5;
  select id into strict hunna_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '13' and sort_order = 6;
  select id into strict far_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '13' and sort_order = 7;

  delete from public.rule_sections where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '13'
  );
  delete from public.rule_sources where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '13'
  );
  update public.rules set sort_order = sort_order + 100
  where id in (idafa_rule_id, taa_rule_id, near_rule_id, hum_rule_id, waw_rule_id, hunna_rule_id, far_rule_id);

  update public.rules
  set sort_order = 1,
      title = 'هَؤُلَاءِ (эти: близкая группа разумных)',
      rule_ar = 'هَؤُلَاءِ اِسْمُ إِشَارَةٍ لِلْجَمْعِ الْقَرِيبِ الْعَاقِلِ الْمُذَكَّرِ وَالْمُؤَنَّثِ.',
      summary = 'هَؤُلَاءِ اِسْمُ إِشَارَةٍ لِلْجَمْعِ الْقَرِيبِ الْعَاقِلِ الْمُذَكَّرِ وَالْمُؤَنَّثِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">هَؤُلَاءِ اِسْمُ إِشَارَةٍ لِلْجَمْعِ الْقَرِيبِ الْعَاقِلِ الْمُذَكَّرِ وَالْمُؤَنَّثِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">هَؤُلَاءِ</span> — указательное имя «эти» для находящейся близко группы разумных лиц мужского или женского рода.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Мужской род</span><table><thead><tr><th>Единственное число</th><th>Множественное число</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">هَذَا رَجُلٌ</span></td><td><span dir="rtl" lang="ar">هَؤُلَاءِ رِجَالٌ</span></td></tr><tr><td><span dir="rtl" lang="ar">هَذَا طَبِيبٌ</span></td><td><span dir="rtl" lang="ar">هَؤُلَاءِ أَطِبَّاءُ</span></td></tr><tr><td><span dir="rtl" lang="ar">هَذَا طَوِيلٌ</span></td><td><span dir="rtl" lang="ar">هَؤُلَاءِ طِوَالٌ</span></td></tr><tr><td><span dir="rtl" lang="ar">هَذَا شَيْخٌ</span></td><td><span dir="rtl" lang="ar">هَؤُلَاءِ شُيُوخٌ</span></td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Женский род</span><table><thead><tr><th>Единственное число</th><th>Множественное число</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">هَذِهِ أُخْتٌ</span></td><td><span dir="rtl" lang="ar">هَؤُلَاءِ أَخَوَاتٌ</span></td></tr><tr><td><span dir="rtl" lang="ar">هَذِهِ طَبِيبَةٌ</span></td><td><span dir="rtl" lang="ar">هَؤُلَاءِ طَبِيبَاتٌ</span></td></tr><tr><td><span dir="rtl" lang="ar">هَذِهِ طَوِيلَةٌ</span></td><td><span dir="rtl" lang="ar">هَؤُلَاءِ طِوَالٌ</span></td></tr><tr><td><span dir="rtl" lang="ar">هَذِهِ فَتَاةٌ</span></td><td><span dir="rtl" lang="ar">هَؤُلَاءِ فَتَيَاتٌ</span></td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Граница употребления в этом уроке</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَؤُلَاءِ رِجَالٌ وَنِسَاءٌ. ✓</span><span class="rule-example-ru">Эти — мужчины и женщины.</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">هَؤُلَاءِ كُتُبٌ. ✕</span><span class="rule-example-ru">Так не указывают на обычное неразумное множественное.</span></div></div></div></div>$$
  where id = near_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (near_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هَؤُلَاءِ
هَؤُلَاءِ : اِسْمُ إِشَارَةٍ لِلْجَمْعِ الْقَرِيبِ الْعَاقِلِ الْمُذَكَّرِ، وَالْمُؤَنَّثِ .$$, 19, 19, 1),
    (near_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هَذَا رَجُلٌ : هَؤُلَاءِ رِجَالٌ . هَذَا طَبِيبٌ : هَؤُلَاءِ أَطِبَّاءُ . هَذَا طَوِيلٌ : هَؤُلَاءِ طِوَالٌ . هَذَا شَيْخٌ : هَؤُلَاءِ شُيُوخٌ .
هَذِهِ أُخْتٌ : هَؤُلَاءِ أَخَوَاتٌ . هَذِهِ طَبِيبَةٌ : هَؤُلَاءِ طَبِيبَاتٌ . هَذِهِ طَوِيلَةٌ : هَؤُلَاءِ طِوَالٌ . هَذِهِ فَتَاةٌ : هَؤُلَاءِ فَتَيَاتٌ .$$, 19, 19, 2),
    (near_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هَؤُلَاءِ رِجَالٌ وَنِسَاءٌ ✓ هَؤُلَاءِ كُتُبٌ ✕$$, 22, 22, 3);

  update public.rules
  set sort_order = 2,
      title = 'هُمْ (они: отсутствующие мужчины)',
      rule_ar = 'هُمْ ضَمِيرُ جَمْعِ الْغَائِبِ الْمُذَكَّرِ الْعَاقِلِ.',
      summary = 'هُمْ ضَمِيرُ جَمْعِ الْغَائِبِ الْمُذَكَّرِ الْعَاقِلِ.',
      rule_kind = 'rule',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">هُمْ ضَمِيرُ جَمْعِ الْغَائِبِ الْمُذَكَّرِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">هُمْ</span> — местоимение «они» для отсутствующей группы разумных лиц мужского рода.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هَؤُلَاءِ؟ هُمْ تُجَّارٌ.</span><span class="rule-example-ru">Кто эти люди? Они торговцы.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ زُمَلَاؤُكَ؟ هُمْ فِي الْمَهْجَعِ.</span><span class="rule-example-ru">Где твои товарищи? Они в общежитии.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هَؤُلَاءِ؟ أَهُمْ أَبْنَاؤُكَ؟ لَا. هُمْ أَبْنَاءُ أَخِي.</span><span class="rule-example-ru">Кто эти люди? Они твои сыновья? Нет. Они сыновья моего брата.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ الطُّلَّابُ الْجُدُدُ؟ بَعْضُهُمْ فِي الْفَصْلِ، وَبَعْضُهُمْ عِنْدَ الْمُدِيرِ.</span><span class="rule-example-ru">Где новые студенты? Некоторые из них в аудитории, а некоторые — у директора.</span></div></div></div></div>$$
  where id = hum_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (hum_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هُمْ
هُمْ : ضَمِيرُ جَمْعِ الْغَائِبِ الْمُذَكَّرِ الْعَاقِلِ .$$, 19, 19, 1),
    (hum_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$مَنْ هَؤُلَاءِ ؟ هُمْ تُجَّارٌ . أَيْنَ زُمَلَاؤُكَ ؟ هُمْ فِي الْمَهْجَعِ .
مَنْ هَؤُلَاءِ ؟ أَهُمْ أَبْنَاؤُكَ ؟ لَا . هُمْ أَبْنَاءُ أَخِي .
أَيْنَ الطُّلَّابُ الْجُدُدُ ؟ بَعْضُهُمْ فِي الْفَصْلِ، وَبَعْضُهُمْ عِنْدَ الْمُدِيرِ .$$, 19, 19, 2);

  update public.rules
  set sort_order = 3,
      title = 'إِضَافَةُ الْأَسْمَاءِ إِلَى الِاسْمِ الظَّاهِرِ وَالضَّمِيرِ (идафа к явному имени и местоимению)',
      rule_ar = 'تُضَافُ الْأَسْمَاءُ إِلَى الِاسْمِ الظَّاهِرِ أَوْ إِلَى الضَّمِيرِ، فَيَكُونُ الْمُضَافُ إِلَيْهِ اِسْمًا ظَاهِرًا أَوْ ضَمِيرًا.',
      summary = 'تُضَافُ الْأَسْمَاءُ إِلَى الِاسْمِ الظَّاهِرِ أَوْ إِلَى الضَّمِيرِ، فَيَكُونُ الْمُضَافُ إِلَيْهِ اِسْمًا ظَاهِرًا أَوْ ضَمِيرًا.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">تُضَافُ الْأَسْمَاءُ إِلَى الِاسْمِ الظَّاهِرِ أَوْ إِلَى الضَّمِيرِ، فَيَكُونُ الْمُضَافُ إِلَيْهِ اِسْمًا ظَاهِرًا أَوْ ضَمِيرًا.</span><p class="rule-study-text">Вторым членом идафы — <span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span> — может быть явное имя <span dir="rtl" lang="ar">اِسْمٌ ظَاهِرٌ</span> либо присоединённое местоимение <span dir="rtl" lang="ar">ضَمِيرٌ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Идафа к явному имени</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبْنَاءُ مُحَمَّدٍ · زُمَلَاءُ حَامِدٍ · أَصْدِقَاءُ الْمُدَرِّسِ</span><span class="rule-example-ru">сыновья Мухаммада · товарищи Хамида · друзья преподавателя</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَسْمَاءُ الطُّلَّابِ · كِتَابُ الْمُدِيرِ</span><span class="rule-example-ru">имена студентов · книга директора</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Идафа к местоимению</span><table><thead><tr><th>Слово «сыновья»</th><th>Слово «книга»</th><th>Русский смысл</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">أَبْنَاؤُهُ</span></td><td><span dir="rtl" lang="ar">كِتَابُهُ</span></td><td>его сыновья · его книга</td></tr><tr><td><span dir="rtl" lang="ar">أَبْنَاؤُهُمْ</span></td><td><span dir="rtl" lang="ar">كِتَابُهُمْ</span></td><td>их сыновья · их книга</td></tr><tr><td><span dir="rtl" lang="ar">أَبْنَاؤُكَ</span></td><td><span dir="rtl" lang="ar">كِتَابُكَ</span></td><td>твои сыновья · твоя книга</td></tr><tr><td><span dir="rtl" lang="ar">أَبْنَائِي</span></td><td><span dir="rtl" lang="ar">كِتَابِي</span></td><td>мои сыновья · моя книга</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор связи</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">أَبْنَاءُ / كِتَابُ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُضَافٌ</span> — первый член идафы</span></div><div class="rule-meaning-card rule-term-jarr"><span class="rule-term-ar" dir="rtl" lang="ar">مُحَمَّدٍ / ـهُ / ـكَ / ـِي</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span> — второй член идафы</span></div></div></div></div>$$
  where id = idafa_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (idafa_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$إِضَافَةُ الْأَسْمَاءِ إِلَى الِاسْمِ الظَّاهِرِ، وَالضَّمِيرِ
الِاسْمُ الظَّاهِرُ، نَحْوُ : مُحَمَّدٍ، حَامِدٍ، أَصْدِقَاءٍ، الطُّلَّابِ ... إِلَخْ .
الضَّمِيرُ، نَحْوُ : هُوَ، هُمْ، كَ، كِ ( كَافُ الْمُخَاطَبِ )، ي ( يَاءُ الْمُتَكَلِّمِ ) .$$, 19, 19, 1),
    (idafa_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْإِضَافَةُ إِلَى الِاسْمِ الظَّاهِرِ : أَبْنَاءُ مُحَمَّدٍ . زُمَلَاءُ حَامِدٍ . أَصْدِقَاءُ الْمُدَرِّسِ . أَسْمَاءُ الطُّلَّابِ . كِتَابُ الْمُدِيرِ .
الْإِضَافَةُ إِلَى الضَّمِيرِ : أَبْنَاؤُهُ . أَبْنَاؤُهُمْ . أَبْنَاؤُكَ . أَبْنَائِي . كِتَابُهُ . كِتَابُهُمْ . كِتَابُكَ . كِتَابِي .$$, 20, 20, 2),
    (idafa_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَبْنَاءُ مُحَمَّدٍ : أَبْنَاءُ مُضَافٌ، مُحَمَّدٍ مُضَافٌ إِلَيْهِ .
أَبْنَاؤُهُ : أَبْنَاءُ مُضَافٌ، ـهُ مُضَافٌ إِلَيْهِ .
أَبْنَاؤُكَ : أَبْنَاءُ مُضَافٌ، ـكَ مُضَافٌ إِلَيْهِ .
كِتَابِي : كِتَابُ مُضَافٌ، ـِي مُضَافٌ إِلَيْهِ .$$, 20, 20, 3);

  update public.rules
  set sort_order = 4,
      title = 'وَاوُ الْجَمَاعَةِ (вау группы: «они» при глаголе)',
      rule_ar = 'وَاوُ الْجَمَاعَةِ ضَمِيرٌ لِلْمُذَكَّرِ الْعَاقِلِ يَتَّصِلُ بِالْفِعْلِ، وَهُوَ الْفَاعِلُ.',
      summary = 'وَاوُ الْجَمَاعَةِ ضَمِيرٌ لِلْمُذَكَّرِ الْعَاقِلِ يَتَّصِلُ بِالْفِعْلِ، وَهُوَ الْفَاعِلُ.',
      rule_kind = 'rule',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ ضَمِيرٌ لِلْمُذَكَّرِ الْعَاقِلِ يَتَّصِلُ بِالْفِعْلِ، وَهُوَ الْفَاعِلُ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span> — местоимение разумной группы мужского рода. Оно присоединяется к глаголу и само является <span dir="rtl" lang="ar">فَاعِلٌ</span> — исполнителем действия.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Формы</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبُوا · جَلَسُوا · خَرَجُوا</span><span class="rule-example-ru">они ушли · они сели · они вышли</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Единственное и множественное</span><table><thead><tr><th>Один исполнитель</th><th>Группа</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">الْمُدَرِّسُ جَلَسَ فِي الْفَصْلِ.</span></td><td><span dir="rtl" lang="ar">الْمُدَرِّسُونَ جَلَسُوا فِي الْفَصْلِ.</span></td></tr><tr><td><span dir="rtl" lang="ar">التَّاجِرُ خَرَجَ.</span></td><td><span dir="rtl" lang="ar">التُّجَّارُ خَرَجُوا.</span></td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Пример</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ ذَهَبَ الطُّلَّابُ؟ الطُّلَّابُ ذَهَبُوا إِلَى الْمَطْعَمِ.</span><span class="rule-example-ru">Куда ушли студенты? Студенты пошли в столовую.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-verb"><span class="rule-term-ar" dir="rtl" lang="ar">خَرَجُـ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">فِعْلٌ</span> — глагол</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">ـوا</span><span class="rule-term-ru"><span dir="rtl" lang="ar">فَاعِلٌ</span> — исполнитель действия</span></div></div></div></div>$$
  where id = waw_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (waw_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$وَاوُ الْجَمَاعَةِ
وَاوُ الْجَمَاعَةِ : ضَمِيرٌ لِلْمُذَكَّرِ الْعَاقِلِ يَتَّصِلُ بِالْفِعْلِ، وَهُوَ الْفَاعِلُ .
ذَهَبُوا . جَلَسُوا . خَرَجُوا .$$, 20, 20, 1),
    (waw_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَيْنَ ذَهَبَ الطُّلَّابُ ؟ الطُّلَّابُ ذَهَبُوا إِلَى الْمَطْعَمِ .
الْمُدَرِّسُ جَلَسَ فِي الْفَصْلِ . الْمُدَرِّسُونَ جَلَسُوا فِي الْفَصْلِ .
التَّاجِرُ خَرَجَ . التُّجَّارُ خَرَجُوا .
خَرَجُوا : خَرَجُـ فِعْلٌ، ـوا فَاعِلٌ .$$, 20, 20, 2);

  update public.rules
  set sort_order = 5,
      title = 'هُنَّ (они: отсутствующие женщины)',
      rule_ar = 'هُنَّ ضَمِيرُ جَمْعِ الْغَائِبِ الْمُؤَنَّثِ الْعَاقِلِ.',
      summary = 'هُنَّ ضَمِيرُ جَمْعِ الْغَائِبِ الْمُؤَنَّثِ الْعَاقِلِ.',
      rule_kind = 'rule',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">هُنَّ ضَمِيرُ جَمْعِ الْغَائِبِ الْمُؤَنَّثِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">هُنَّ</span> — местоимение «они» для отсутствующей группы разумных лиц женского рода.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هَؤُلَاءِ؟ هُنَّ مُدَرِّسَاتٌ.</span><span class="rule-example-ru">Кто эти женщины? Они преподавательницы.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ زَمِيلَاتُكِ؟ هُنَّ فِي الْمَهْجَعِ.</span><span class="rule-example-ru">Где твои подруги? Они в общежитии.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ هَؤُلَاءِ؟ أَهُنَّ أَبْنَاؤُكِ؟ لَا. هُنَّ بَنَاتُ أَخِي.</span><span class="rule-example-ru">Кто эти женщины? Они твои сыновья? Нет. Они дочери моего брата.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ الطَّالِبَاتُ الْجُدُدُ؟ بَعْضُهُنَّ فِي الْفَصْلِ، وَبَعْضُهُنَّ عِنْدَ الْمُدِيرَةِ.</span><span class="rule-example-ru">Где новые студентки? Некоторые из них в аудитории, а некоторые — у директрисы.</span></div></div></div></div>$$
  where id = hunna_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (hunna_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$هُنَّ
هُنَّ : ضَمِيرُ جَمْعِ الْغَائِبِ الْمُؤَنَّثِ الْعَاقِلِ .$$, 21, 21, 1),
    (hunna_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$مَنْ هَؤُلَاءِ ؟ هُنَّ مُدَرِّسَاتٌ . أَيْنَ زَمِيلَاتُكِ ؟ هُنَّ فِي الْمَهْجَعِ .
مَنْ هَؤُلَاءِ ؟ أَهُنَّ أَبْنَاؤُكِ ؟ لَا . هُنَّ بَنَاتُ أَخِي .
أَيْنَ الطَّالِبَاتُ الْجُدُدُ ؟ بَعْضُهُنَّ فِي الْفَصْلِ، وَبَعْضُهُنَّ عِنْدَ الْمُدِيرَةِ .$$, 21, 21, 2);

  update public.rules
  set sort_order = 6,
      title = 'تَاءُ التَّأْنِيثِ (показатель женского рода при глаголе)',
      rule_ar = 'تَاءُ التَّأْنِيثِ حَرْفٌ سَاكِنٌ يَتَّصِلُ بِالْفِعْلِ، وَيَدُلُّ عَلَى أَنَّ الْفَاعِلَ مُؤَنَّثٌ.',
      summary = 'تَاءُ التَّأْنِيثِ حَرْفٌ سَاكِنٌ يَتَّصِلُ بِالْفِعْلِ، وَيَدُلُّ عَلَى أَنَّ الْفَاعِلَ مُؤَنَّثٌ.',
      rule_kind = 'important',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">تَاءُ التَّأْنِيثِ حَرْفٌ سَاكِنٌ يَتَّصِلُ بِالْفِعْلِ، وَيَدُلُّ عَلَى أَنَّ الْفَاعِلَ مُؤَنَّثٌ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">تَاءُ التَّأْنِيثِ</span> — неподвижная буква <span dir="rtl" lang="ar">تْ</span>, присоединяемая к глаголу; она указывает, что исполнитель действия женского рода.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">خَرَجَتْ فَاطِمَةُ.</span><span class="rule-example-ru">Фатима вышла.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّالِبَةُ جَلَسَتْ فِي الْفَصْلِ.</span><span class="rule-example-ru">Студентка села в аудитории.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبَتْ زَيْنَبُ إِلَى الْمَدْرَسَةِ.</span><span class="rule-example-ru">Зайнаб пошла в школу.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">خَدِيجَةُ ذَهَبَتْ.</span><span class="rule-example-ru">Хадиджа ушла.</span></div></div></div></div>$$
  where id = taa_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (taa_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$تَاءُ التَّأْنِيثِ
تَاءُ التَّأْنِيثِ : حَرْفٌ سَاكِنٌ يَتَّصِلُ بِالْفِعْلِ، وَيَدُلُّ عَلَى أَنَّ الْفَاعِلَ مُؤَنَّثٌ .$$, 21, 21, 1),
    (taa_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$خَرَجَتْ فَاطِمَةُ . الطَّالِبَةُ جَلَسَتْ فِي الْفَصْلِ . ذَهَبَتْ زَيْنَبُ إِلَى الْمَدْرَسَةِ . خَدِيجَةُ ذَهَبَتْ .$$, 21, 21, 2);

  insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values (
    'Мединский курс (Том 1)', '13',
    'نُونُ النِّسْوَةِ (нун женской группы: «они» при глаголе)',
    $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">نُونُ النِّسْوَةِ ضَمِيرٌ لِلْمُؤَنَّثِ الْعَاقِلِ يَتَّصِلُ بِالْفِعْلِ، وَهُوَ الْفَاعِلُ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span> — местоимение разумной группы женского рода. Оно присоединяется к глаголу и само является <span dir="rtl" lang="ar">فَاعِلٌ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّبِيبَاتُ خَرَجْنَ مِنَ الْمُسْتَشْفَى.</span><span class="rule-example-ru">Врачи-женщины вышли из больницы.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّالِبَاتُ جَلَسْنَ فِي الْفَصْلِ.</span><span class="rule-example-ru">Студентки сели в аудитории.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">الْمُدَرِّسَاتُ ذَهَبْنَ.</span><span class="rule-example-ru">Преподавательницы ушли.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-verb"><span class="rule-term-ar" dir="rtl" lang="ar">خَرَجْـ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">فِعْلٌ</span> — глагол</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">ـنَ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">فَاعِلٌ</span> — исполнитель действия</span></div></div></div></div>$$,
    7, 'rule',
    'نُونُ النِّسْوَةِ ضَمِيرٌ لِلْمُؤَنَّثِ الْعَاقِلِ يَتَّصِلُ بِالْفِعْلِ، وَهُوَ الْفَاعِلُ.',
    'نُونُ النِّسْوَةِ ضَمِيرٌ لِلْمُؤَنَّثِ الْعَاقِلِ يَتَّصِلُ بِالْفِعْلِ، وَهُوَ الْفَاعِلُ.'
  ) returning id into nun_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (nun_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$نُونُ النِّسْوَةِ
نُونُ النِّسْوَةِ : ضَمِيرٌ لِلْمُؤَنَّثِ الْعَاقِلِ يَتَّصِلُ بِالْفِعْلِ، وَهُوَ الْفَاعِلُ .$$, 21, 21, 1),
    (nun_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الطَّبِيبَاتُ خَرَجْنَ مِنَ الْمُسْتَشْفَى . الطَّالِبَاتُ جَلَسْنَ فِي الْفَصْلِ . الْمُدَرِّسَاتُ ذَهَبْنَ .
خَرَجْنَ : خَرَجْـ فِعْلٌ، ـنَ فَاعِلٌ .$$, 21, 21, 2);

  update public.rules
  set sort_order = 8,
      title = 'أُولَئِكَ (те: далёкая группа разумных)',
      rule_ar = 'أُولَئِكَ اِسْمُ إِشَارَةٍ لِلْجَمْعِ الْبَعِيدِ الْعَاقِلِ الْمُذَكَّرِ وَالْمُؤَنَّثِ.',
      summary = 'أُولَئِكَ اِسْمُ إِشَارَةٍ لِلْجَمْعِ الْبَعِيدِ الْعَاقِلِ الْمُذَكَّرِ وَالْمُؤَنَّثِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">أُولَئِكَ اِسْمُ إِشَارَةٍ لِلْجَمْعِ الْبَعِيدِ الْعَاقِلِ الْمُذَكَّرِ وَالْمُؤَنَّثِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">أُولَئِكَ</span> — указательное имя «те» для находящейся далеко группы разумных лиц мужского или женского рода.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Близко и далеко</span><table><thead><tr><th>Близкая группа</th><th>Далёкая группа</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">هَؤُلَاءِ رِجَالٌ.</span></td><td><span dir="rtl" lang="ar">أُولَئِكَ رِجَالٌ.</span></td></tr><tr><td><span dir="rtl" lang="ar">هَؤُلَاءِ نِسَاءٌ.</span></td><td><span dir="rtl" lang="ar">أُولَئِكَ نِسَاءٌ.</span></td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ أُولَئِكَ الرِّجَالُ الطِّوَالُ؟ هُمْ أَطِبَّاءُ.</span><span class="rule-example-ru">Кто те высокие мужчины? Они врачи.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ أُولَئِكَ النِّسَاءُ الطِّوَالُ؟ هُنَّ طَبِيبَاتٌ.</span><span class="rule-example-ru">Кто те высокие женщины? Они врачи.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Граница употребления в этом уроке</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أُولَئِكَ رِجَالٌ وَنِسَاءٌ. ✓</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">أُولَئِكَ كُتُبٌ. ✕</span></div></div></div></div>$$
  where id = far_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (far_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أُولَئِكَ
أُولَئِكَ : اِسْمُ إِشَارَةٍ لِلْجَمْعِ الْبَعِيدِ الْعَاقِلِ الْمُذَكَّرِ، وَالْمُؤَنَّثِ .
الْجَمْعُ الْقَرِيبُ : هَؤُلَاءِ رِجَالٌ . هَؤُلَاءِ نِسَاءٌ .
الْجَمْعُ الْبَعِيدُ : أُولَئِكَ رِجَالٌ . أُولَئِكَ نِسَاءٌ . مَنْ أُولَئِكَ الرِّجَالُ الطِّوَالُ ؟ هُمْ أَطِبَّاءُ .$$, 21, 21, 1),
    (far_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$مَنْ أُولَئِكَ النِّسَاءُ الطِّوَالُ ؟ هُنَّ طَبِيبَاتٌ .$$, 22, 22, 2),
    (far_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أُولَئِكَ رِجَالٌ وَنِسَاءٌ ✓ أُولَئِكَ كُتُبٌ ✕$$, 22, 22, 3);

  insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values (
    'Мединский курс (Том 1)', '13',
    'مُرَاجَعَةُ أَسْمَاءِ الْإِشَارَةِ وَالْأَسْمَاءِ الْمَوْصُولَةِ (сводные таблицы указательных и относительных имён)',
    $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Сводка автора</span><span class="rule-main-ar" dir="rtl" lang="ar">هٰذَا وَهٰذِهِ وَهَؤُلَاءِ لِلْقَرِيبِ، وَذٰلِكَ وَتِلْكَ وَأُولَئِكَ لِلْبَعِيدِ، وَالَّذِي لِلْمُفْرَدِ الْمُذَكَّرِ، وَالَّتِي لِلْمُفْرَدِ الْمُؤَنَّثِ.</span></div><div class="rule-study-card"><span class="rule-card-kicker">أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ — указательные имена для близкого</span><table><thead><tr><th>Род и число</th><th>Разумное и неразумное / разумное во множественном</th></tr></thead><tbody><tr><td>единственное, мужской</td><td><span dir="rtl" lang="ar">هٰذَا رَجُلٌ، هٰذَا كِتَابٌ</span></td></tr><tr><td>единственное, женский</td><td><span dir="rtl" lang="ar">هٰذِهِ امْرَأَةٌ، هٰذِهِ سَيَّارَةٌ</span></td></tr><tr><td>множественное, мужской</td><td><span dir="rtl" lang="ar">هَؤُلَاءِ رِجَالٌ</span></td></tr><tr><td>множественное, женский</td><td><span dir="rtl" lang="ar">هَؤُلَاءِ نِسَاءٌ</span></td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ — указательные имена для далёкого</span><table><thead><tr><th>Род и число</th><th>Разумное и неразумное / разумное во множественном</th></tr></thead><tbody><tr><td>единственное, мужской</td><td><span dir="rtl" lang="ar">ذٰلِكَ رَجُلٌ، ذٰلِكَ كِتَابٌ</span></td></tr><tr><td>единственное, женский</td><td><span dir="rtl" lang="ar">تِلْكَ امْرَأَةٌ، تِلْكَ سَيَّارَةٌ</span></td></tr><tr><td>множественное, мужской</td><td><span dir="rtl" lang="ar">أُولَئِكَ رِجَالٌ</span></td></tr><tr><td>множественное, женский</td><td><span dir="rtl" lang="ar">أُولَئِكَ نِسَاءٌ</span></td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">الْأَسْمَاءُ الْمَوْصُولَةُ — относительные имена</span><table><thead><tr><th>Форма</th><th>Примеры для разумного и неразумного</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">الَّذِي</span> — мужской род</td><td><span dir="rtl" lang="ar">الطَّالِبُ الَّذِي ذَهَبَ مِنْ لِيبِيَا، الْكِتَابُ الَّذِي مَعَكَ كِتَابِي</span></td></tr><tr><td><span dir="rtl" lang="ar">الَّتِي</span> — женский род</td><td><span dir="rtl" lang="ar">الطَّالِبَةُ الَّتِي ذَهَبَتْ مِنَ السُّودَانِ، الْحَقِيبَةُ الَّتِي مَعَكَ حَقِيبَتِي</span></td></tr></tbody></table></div></div>$$,
    9, 'note',
    'هٰذَا وَهٰذِهِ وَهَؤُلَاءِ لِلْقَرِيبِ، وَذٰلِكَ وَتِلْكَ وَأُولَئِكَ لِلْبَعِيدِ، وَالَّذِي لِلْمُفْرَدِ الْمُذَكَّرِ، وَالَّتِي لِلْمُفْرَدِ الْمُؤَنَّثِ.',
    'هٰذَا وَهٰذِهِ وَهَؤُلَاءِ لِلْقَرِيبِ، وَذٰلِكَ وَتِلْكَ وَأُولَئِكَ لِلْبَعِيدِ، وَالَّذِي لِلْمُفْرَدِ الْمُذَكَّرِ، وَالَّتِي لِلْمُفْرَدِ الْمُؤَنَّثِ.'
  ) returning id into review_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (review_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ
الْمُفْرَدُ الْمُذَكَّرُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ : هَذَا رَجُلٌ، هَذَا كِتَابٌ
الْمُفْرَدُ الْمُؤَنَّثُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ : هَذِهِ امْرَأَةٌ، هَذِهِ سَيَّارَةٌ
الْجَمْعُ الْمُذَكَّرُ الْعَاقِلُ : هَؤُلَاءِ رِجَالٌ
الْجَمْعُ الْمُؤَنَّثُ الْعَاقِلُ : هَؤُلَاءِ نِسَاءٌ$$, 22, 22, 1),
    (review_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ
الْمُفْرَدُ الْمُذَكَّرُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ : ذَلِكَ رَجُلٌ، ذَلِكَ كِتَابٌ
الْمُفْرَدُ الْمُؤَنَّثُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ : تِلْكَ امْرَأَةٌ، تِلْكَ سَيَّارَةٌ
الْجَمْعُ الْمُذَكَّرُ الْعَاقِلُ : أُولَئِكَ رِجَالٌ
الْجَمْعُ الْمُؤَنَّثُ الْعَاقِلُ : أُولَئِكَ نِسَاءٌ$$, 22, 22, 2),
    (review_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$الْأَسْمَاءُ الْمَوْصُولَةُ
الْمُفْرَدُ الْمُذَكَّرُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ : الطَّالِبُ الَّذِي ذَهَبَ مِنْ لِيبِيَا، الْكِتَابُ الَّذِي مَعَكَ كِتَابِي
الْمُفْرَدُ الْمُؤَنَّثُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ : الطَّالِبَةُ الَّتِي ذَهَبَتْ مِنَ السُّودَانِ، الْحَقِيبَةُ الَّتِي مَعَكَ حَقِيبَتِي$$, 22, 22, 3);
end;
$migration$;

commit;
