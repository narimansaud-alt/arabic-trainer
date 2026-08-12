-- Verify Medina Book 1 lesson 15 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 26-27.

begin;

do $migration$
declare
  detached_rule_id bigint;
  kaf_rule_id bigint;
  verb_rule_id bigint;
  time_rule_id bigint;
begin
  select id into strict detached_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '15' and sort_order = 1;
  select id into strict kaf_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '15' and sort_order = 2;
  select id into strict verb_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '15' and sort_order = 3;
  select id into strict time_rule_id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '15' and sort_order = 4;

  delete from public.rule_sections where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '15'
  );
  delete from public.rule_sources where rule_id in (
    select id from public.rules where course_name = 'Мединский курс (Том 1)' and lesson_number = '15'
  );
  update public.rules set sort_order = sort_order + 100
  where id in (detached_rule_id, kaf_rule_id, verb_rule_id, time_rule_id);

  update public.rules
  set sort_order = 1,
      title = 'الضَّمَائِرُ الْمُنْفَصِلَةُ (отдельные личные местоимения)',
      rule_ar = 'الضَّمَائِرُ الْمُنْفَصِلَةُ تُكْتَبُ وَتُنْطَقُ فِي أَوَّلِ الْكَلَامِ، وَمِنْهَا ضَمَائِرُ الْمُخَاطَبِ: «أَنْتَ»، وَ«أَنْتِ»، وَ«أَنْتُمْ»، وَ«أَنْتُنَّ».',
      summary = 'الضَّمَائِرُ الْمُنْفَصِلَةُ تُكْتَبُ وَتُنْطَقُ فِي أَوَّلِ الْكَلَامِ، وَمِنْهَا ضَمَائِرُ الْمُخَاطَبِ: «أَنْتَ»، وَ«أَنْتِ»، وَ«أَنْتُمْ»، وَ«أَنْتُنَّ».',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الضَّمَائِرُ الْمُنْفَصِلَةُ تُكْتَبُ وَتُنْطَقُ فِي أَوَّلِ الْكَلَامِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">الضَّمِيرُ الْمُنْفَصِلُ</span> — отдельное местоимение: оно пишется отдельно и может произноситься в начале высказывания.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Полная таблица шарха</span><table><thead><tr><th>Лицо и число</th><th><span dir="rtl" lang="ar">الْمُتَكَلِّمُ</span><br>говорящий</th><th><span dir="rtl" lang="ar">الْمُخَاطَبُ</span><br>собеседник</th><th><span dir="rtl" lang="ar">الْغَائِبُ</span><br>отсутствующий</th></tr></thead><tbody><tr><td>ед. ч., муж. род</td><td><span dir="rtl" lang="ar">أَنَا طَالِبٌ</span><br>я студент</td><td><span dir="rtl" lang="ar">أَنْتَ طَالِبٌ</span><br>ты студент</td><td><span dir="rtl" lang="ar">هُوَ طَالِبٌ</span><br>он студент</td></tr><tr><td>ед. ч., жен. род</td><td><span dir="rtl" lang="ar">أَنَا طَالِبَةٌ</span><br>я студентка</td><td><span dir="rtl" lang="ar">أَنْتِ طَالِبَةٌ</span><br>ты студентка</td><td><span dir="rtl" lang="ar">هِيَ طَالِبَةٌ</span><br>она студентка</td></tr><tr><td>мн. ч., муж. род</td><td><span dir="rtl" lang="ar">نَحْنُ طُلَّابٌ</span><br>мы студенты</td><td><span dir="rtl" lang="ar">أَنْتُمْ طُلَّابٌ</span><br>вы студенты</td><td><span dir="rtl" lang="ar">هُمْ طُلَّابٌ</span><br>они студенты</td></tr><tr><td>мн. ч., жен. род</td><td><span dir="rtl" lang="ar">نَحْنُ طَالِبَاتٌ</span><br>мы студентки</td><td><span dir="rtl" lang="ar">أَنْتُنَّ طَالِبَاتٌ</span><br>вы студентки</td><td><span dir="rtl" lang="ar">هُنَّ طَالِبَاتٌ</span><br>они студентки</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Четыре формы обращения</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتَ طَالِبٌ. أَنْتَ مُعَلِّمٌ. أَنْتَ مُجْتَهِدٌ يَا مُحَمَّدُ.</span><span class="rule-example-ru">Ты студент. Ты преподаватель. Ты усердный, Мухаммад.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتِ طَالِبَةٌ. أَنْتِ مُعَلِّمَةٌ. أَنْتِ مُجْتَهِدَةٌ يَا فَاطِمَةُ.</span><span class="rule-example-ru">Ты студентка. Ты преподавательница. Ты усердная, Фатима.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتُمْ طُلَّابٌ. أَنْتُمْ مُعَلِّمُونَ. أَنْتُمْ مُجْتَهِدُونَ يَا طُلَّابَ الْمَعْهَدِ.</span><span class="rule-example-ru">Вы студенты. Вы преподаватели. Вы усердны, студенты института.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتُنَّ طَالِبَاتٌ. أَنْتُنَّ مُعَلِّمَاتٌ. أَنْتُنَّ مُجْتَهِدَاتٌ يَا طَالِبَاتِ الْمَعْهَدِ.</span><span class="rule-example-ru">Вы студентки. Вы преподавательницы. Вы усердны, студентки института.</span></div></div></div></div>$$
  where id = detached_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (detached_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$ضَمَائِرُ الْمُخَاطَبِ
أَنْتَ : ضَمِيرُ الْمُخَاطَبِ الْمُفْرَدِ الْمُذَكَّرِ . أَنْتَ طَالِبٌ . أَنْتَ مُعَلِّمٌ . أَنْتَ مُجْتَهِدٌ يَا مُحَمَّدُ .
أَنْتِ : ضَمِيرُ الْمُخَاطَبِ الْمُفْرَدِ الْمُؤَنَّثِ . أَنْتِ طَالِبَةٌ . أَنْتِ مُعَلِّمَةٌ . أَنْتِ مُجْتَهِدَةٌ يَا فَاطِمَةُ .
أَنْتُمْ : ضَمِيرُ الْمُخَاطَبِ الْجَمْعِ الْمُذَكَّرِ : أَنْتُمْ طُلَّابٌ . أَنْتُمْ مُعَلِّمُونَ . أَنْتُمْ مُجْتَهِدُونَ يَا طُلَّابَ الْمَعْهَدِ .
أَنْتُنَّ : ضَمِيرُ الْمُخَاطَبِ الْجَمْعِ الْمُؤَنَّثِ : أَنْتُنَّ طَالِبَاتٌ . أَنْتُنَّ مُعَلِّمَاتٌ . أَنْتُنَّ مُجْتَهِدَاتٌ يَا طَالِبَاتِ الْمَعْهَدِ .$$, 26, 26, 1),
    (detached_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$جَدْوَلٌ لِلضَّمَائِرِ الْمُنْفَصِلَةِ
الْمُتَكَلِّمُ : الْمُفْرَدُ الْمُذَكَّرُ : أَنَا طَالِبٌ . الْمُفْرَدُ الْمُؤَنَّثُ : أَنَا طَالِبَةٌ . الْجَمْعُ الْمُذَكَّرُ : نَحْنُ طُلَّابٌ . الْجَمْعُ الْمُؤَنَّثُ : نَحْنُ طَالِبَاتٌ .
الْمُخَاطَبُ : الْمُفْرَدُ الْمُذَكَّرُ : أَنْتَ طَالِبٌ . الْمُفْرَدُ الْمُؤَنَّثُ : أَنْتِ طَالِبَةٌ . الْجَمْعُ الْمُذَكَّرُ : أَنْتُمْ طُلَّابٌ . الْجَمْعُ الْمُؤَنَّثُ : أَنْتُنَّ طَالِبَاتٌ .
الْغَائِبُ : الْمُفْرَدُ الْمُذَكَّرُ : هُوَ طَالِبٌ . الْمُفْرَدُ الْمُؤَنَّثُ : هِيَ طَالِبَةٌ . الْجَمْعُ الْمُذَكَّرُ : هُمْ طُلَّابٌ . الْجَمْعُ الْمُؤَنَّثُ : هُنَّ طَالِبَاتٌ .
الضَّمَائِرُ الْمُنْفَصِلَةُ : تُكْتَبُ، وَتُنْطَقُ فِي أَوَّلِ الْكَلَامِ .$$, 27, 27, 2);

  update public.rules
  set sort_order = 2,
      title = 'كَافُ الْمُخَاطَبِ وَالضَّمَائِرُ الْمُتَّصِلَةُ (каф обращения и слитные местоимения)',
      rule_ar = 'كَافُ الْمُخَاطَبِ لَهَا أَرْبَعُ صُوَرٍ: «ـكَ» لِلْمُفْرَدِ الْمُذَكَّرِ، وَ«ـكِ» لِلْمُفْرَدِ الْمُؤَنَّثِ، وَ«ـكُمْ» لِلْجَمْعِ الْمُذَكَّرِ، وَ«ـكُنَّ» لِلْجَمْعِ الْمُؤَنَّثِ، وَهِيَ ضَمَائِرُ مُتَّصِلَةٌ تُكْتَبُ مُتَّصِلَةً بِالْكَلِمَةِ، وَلَا تُكْتَبُ وَلَا تُنْطَقُ وَحْدَهَا فِي أَوَّلِ الْكَلَامِ.',
      summary = 'كَافُ الْمُخَاطَبِ لَهَا أَرْبَعُ صُوَرٍ: «ـكَ» لِلْمُفْرَدِ الْمُذَكَّرِ، وَ«ـكِ» لِلْمُفْرَدِ الْمُؤَنَّثِ، وَ«ـكُمْ» لِلْجَمْعِ الْمُذَكَّرِ، وَ«ـكُنَّ» لِلْجَمْعِ الْمُؤَنَّثِ، وَهِيَ ضَمَائِرُ مُتَّصِلَةٌ تُكْتَبُ مُتَّصِلَةً بِالْكَلِمَةِ، وَلَا تُكْتَبُ وَلَا تُنْطَقُ وَحْدَهَا فِي أَوَّلِ الْكَلَامِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">كَافُ الْمُخَاطَبِ: ـكَ · ـكِ · ـكُمْ · ـكُنَّ</span><p class="rule-study-text">Эти формы передают значение «твой / твоя / твоё», «ваш / ваша / ваше». Это <span dir="rtl" lang="ar">ضَمَائِرُ مُتَّصِلَةٌ</span> — слитные местоимения: пишутся вместе со словом и не употребляются самостоятельно в начале речи.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Формы и адресаты</span><table><thead><tr><th>Форма</th><th>К кому обращаются</th><th>Пример</th><th>Перевод</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">ـكَ</span></td><td>один мужчина</td><td><span dir="rtl" lang="ar">كَيْفَ حَالُكَ؟ بَيْتُكَ جَمِيلٌ. أَهَذَا عَمُّكَ يَا أَخِي؟</span></td><td>Как твои дела? Твой дом красив. Это твой дядя, брат мой?</td></tr><tr><td><span dir="rtl" lang="ar">ـكِ</span></td><td>одна женщина</td><td><span dir="rtl" lang="ar">كَيْفَ حَالُكِ؟ بَيْتُكِ جَمِيلٌ. أَهَذَا عَمُّكِ يَا أُخْتِي؟</span></td><td>Как твои дела? Твой дом красив. Это твой дядя, сестра моя?</td></tr><tr><td><span dir="rtl" lang="ar">ـكُمْ</span></td><td>группа мужчин</td><td><span dir="rtl" lang="ar">كَيْفَ حَالُكُمْ؟ بَيْتُكُمْ جَمِيلٌ. أَهَذَا عَمُّكُمْ يَا إِخْوَانُ؟</span></td><td>Как ваши дела? Ваш дом красив. Это ваш дядя, братья?</td></tr><tr><td><span dir="rtl" lang="ar">ـكُنَّ</span></td><td>группа женщин</td><td><span dir="rtl" lang="ar">كَيْفَ حَالُكُنَّ؟ بَيْتُكُنَّ جَمِيلٌ. أَهَذَا عَمُّكُنَّ يَا أَخَوَاتُ؟</span></td><td>Как ваши дела? Ваш дом красив. Это ваш дядя, сёстры?</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Пишется слитно</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ بَيْتُكَ؟ · أَيْنَ بَيْتُكِ؟ · أَيْنَ بَيْتُكُمْ؟ · أَيْنَ بَيْتُكُنَّ؟</span><span class="rule-example-ru">Где твой дом? · Где твой дом? · Где ваш дом? · Где ваш дом?</span></div></div></div></div>$$
  where id = kaf_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (kaf_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$كَافُ الْمُخَاطَبِ ( كَ ) لِلْمُفْرَدِ الْمُذَكَّرِ : كَيْفَ حَالُكَ ؟ بَيْتُكَ جَمِيلٌ . أَهَذَا عَمُّكَ يَا أَخِي ؟
كَافُ الْمُخَاطَبِ ( كِ ) لِلْمُفْرَدِ الْمُؤَنَّثِ : كَيْفَ حَالُكِ ؟ بَيْتُكِ جَمِيلٌ . أَهَذَا عَمُّكِ يَا أُخْتِي ؟
كَافُ الْمُخَاطَبِ ( كُمْ ) لِلْجَمْعِ الْمُذَكَّرِ : كَيْفَ حَالُكُمْ ؟ بَيْتُكُمْ جَمِيلٌ . أَهَذَا عَمُّكُمْ يَا إِخْوَانُ ؟
كَافُ الْمُخَاطَبِ ( كُنَّ ) لِلْجَمْعِ الْمُؤَنَّثِ : كَيْفَ حَالُكُنَّ ؟ بَيْتُكُنَّ جَمِيلٌ . أَهَذَا عَمُّكُنَّ يَا أَخَوَاتُ ؟$$, 26, 26, 1),
    (kaf_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$( كَ، كِ، كُمْ، كُنَّ ) تُسَمَّى ضَمَائِرَ مُتَّصِلَةً؛ لِأَنَّهَا تُكْتَبُ مُتَّصِلَةً بِالْكَلِمَةِ، وَلَا تُكْتَبُ، وَلَا تُنْطَقُ وَحْدَهَا فِي أَوَّلِ الْكَلَامِ .
أَيْنَ بَيْتُكَ ؟ ← أَيْنَ بَيْتُ كَ ؟ أَيْنَ بَيْتُكُمْ ؟ أَيْنَ بَيْتُكُنَّ ؟$$, 26, 26, 2);

  update public.rules
  set sort_order = 3,
      title = 'الضَّمَائِرُ الْمُتَّصِلَةُ بِالْفِعْلِ (местоименные окончания при глаголе)',
      rule_ar = 'تَتَّصِلُ بِالْفِعْلِ الْمَاضِي ضَمَائِرُ الْفَاعِلِ: «ـتُ» لِلْمُتَكَلِّمِ الْمُفْرَدِ مُذَكَّرًا كَانَ أَوْ مُؤَنَّثًا، وَ«ـتَ» لِلْمُخَاطَبِ، وَ«ـتِ» لِلْمُخَاطَبَةِ، وَ«ـنَا» لِجَمْعِ الْمُتَكَلِّمِينَ وَالْمُتَكَلِّمَاتِ، وَ«ـتُمْ» لِجَمْعِ الْمُخَاطَبِينَ، وَ«ـتُنَّ» لِجَمْعِ الْمُخَاطَبَاتِ.',
      summary = 'تَتَّصِلُ بِالْفِعْلِ الْمَاضِي ضَمَائِرُ الْفَاعِلِ: «ـتُ» لِلْمُتَكَلِّمِ الْمُفْرَدِ مُذَكَّرًا كَانَ أَوْ مُؤَنَّثًا، وَ«ـتَ» لِلْمُخَاطَبِ، وَ«ـتِ» لِلْمُخَاطَبَةِ، وَ«ـنَا» لِجَمْعِ الْمُتَكَلِّمِينَ وَالْمُتَكَلِّمَاتِ، وَ«ـتُمْ» لِجَمْعِ الْمُخَاطَبِينَ، وَ«ـتُنَّ» لِجَمْعِ الْمُخَاطَبَاتِ.',
      rule_kind = 'table',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Таблица шарха</span><span class="rule-main-ar" dir="rtl" lang="ar">جَدْوَلٌ لِلضَّمَائِرِ الْمُتَّصِلَةِ بِالْفِعْلِ</span><table><thead><tr><th>Говорящий / собеседник</th><th>Мужской род</th><th>Женский род</th><th>Русский смысл</th></tr></thead><tbody><tr><td>ед. ч., говорящий</td><td><span dir="rtl" lang="ar">أَنَا ذَهَبْتُ</span></td><td><span dir="rtl" lang="ar">أَنَا ذَهَبْتُ</span></td><td>я пошёл / я пошла</td></tr><tr><td>ед. ч., собеседник</td><td><span dir="rtl" lang="ar">أَنْتَ ذَهَبْتَ</span></td><td><span dir="rtl" lang="ar">أَنْتِ ذَهَبْتِ</span></td><td>ты пошёл / ты пошла</td></tr><tr><td>мн. ч., говорящие</td><td><span dir="rtl" lang="ar">نَحْنُ ذَهَبْنَا</span></td><td><span dir="rtl" lang="ar">نَحْنُ ذَهَبْنَا</span></td><td>мы пошли</td></tr><tr><td>мн. ч., собеседники</td><td><span dir="rtl" lang="ar">أَنْتُمْ ذَهَبْتُمْ</span></td><td><span dir="rtl" lang="ar">أَنْتُنَّ ذَهَبْتُنَّ</span></td><td>вы пошли</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Окончания</span><table><thead><tr><th>Окончание</th><th>Значение</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">ـتُ</span></td><td>я, мужчина или женщина</td></tr><tr><td><span dir="rtl" lang="ar">ـتَ</span></td><td>ты, мужчина</td></tr><tr><td><span dir="rtl" lang="ar">ـتِ</span></td><td>ты, женщина</td></tr><tr><td><span dir="rtl" lang="ar">ـنَا</span></td><td>мы, мужчины или женщины</td></tr><tr><td><span dir="rtl" lang="ar">ـتُمْ</span></td><td>вы, мужчины</td></tr><tr><td><span dir="rtl" lang="ar">ـتُنَّ</span></td><td>вы, женщины</td></tr></tbody></table></div></div>$$
  where id = verb_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (verb_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$جَدْوَلٌ لِلضَّمَائِرِ الْمُتَّصِلَةِ بِالْفِعْلِ
الْمُفْرَدُ الْمُذَكَّرُ الْمُتَكَلِّمُ : أَنَا ذَهَبْتُ . الْمُفْرَدُ الْمُؤَنَّثُ الْمُتَكَلِّمُ : أَنَا ذَهَبْتُ .
الْمُفْرَدُ الْمُذَكَّرُ الْمُخَاطَبُ : أَنْتَ ذَهَبْتَ . الْمُفْرَدُ الْمُؤَنَّثُ الْمُخَاطَبُ : أَنْتِ ذَهَبْتِ .
الْجَمْعُ الْمُذَكَّرُ الْمُتَكَلِّمُ : نَحْنُ ذَهَبْنَا . الْجَمْعُ الْمُؤَنَّثُ الْمُتَكَلِّمُ : نَحْنُ ذَهَبْنَا .
الْجَمْعُ الْمُذَكَّرُ الْمُخَاطَبُ : أَنْتُمْ ذَهَبْتُمْ . الْجَمْعُ الْمُؤَنَّثُ الْمُخَاطَبُ : أَنْتُنَّ ذَهَبْتُنَّ .$$, 27, 27, 1);

  update public.rules
  set sort_order = 4,
      title = 'قَبْلَ وَبَعْدَ (до и после)',
      rule_ar = 'قَبْلَ وَبَعْدَ ظَرْفَا زَمَانٍ، وَالِاسْمُ الَّذِي بَعْدَهُمَا مُضَافٌ إِلَيْهِ مَجْرُورٌ.',
      summary = 'قَبْلَ وَبَعْدَ ظَرْفَا زَمَانٍ، وَالِاسْمُ الَّذِي بَعْدَهُمَا مُضَافٌ إِلَيْهِ مَجْرُورٌ.',
      rule_kind = 'important',
      content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">قَبْلَ وَبَعْدَ ظَرْفَا زَمَانٍ، وَالِاسْمُ الَّذِي بَعْدَهُمَا مُضَافٌ إِلَيْهِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">قَبْلَ</span> — «до, перед», <span dir="rtl" lang="ar">بَعْدَ</span> — «после, через». В конструкции урока каждое из них является <span dir="rtl" lang="ar">ظَرْفُ زَمَانٍ</span> и первым членом идафы; следующее имя — <span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ مَجْرُورٌ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры автора</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">سَافَرَ أَبِي قَبْلَ أُسْبُوعٍ.</span><span class="rule-example-ru">Мой отец уехал неделю назад.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">خَرَجْتُ بَعْدَ الدَّرْسِ.</span><span class="rule-example-ru">Я вышел после урока.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبْتُ إِلَى الْمَسْجِدِ قَبْلَ الْأَذَانِ.</span><span class="rule-example-ru">Я пошёл в мечеть до азана.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أُسَافِرُ بَعْدَ شَهْرٍ.</span><span class="rule-example-ru">Я уеду через месяц.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Структура и окончание</span><table><thead><tr><th>Сочетание</th><th>Первое слово</th><th>Следующее слово</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">قَبْلَ أُسْبُوعٍ</span></td><td><span dir="rtl" lang="ar">ظَرْفُ زَمَانٍ</span></td><td><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span></td></tr><tr><td><span dir="rtl" lang="ar">بَعْدَ الدَّرْسِ</span></td><td><span dir="rtl" lang="ar">ظَرْفُ زَمَانٍ</span></td><td><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span></td></tr></tbody></table><div class="rule-example-list"><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">قَبْلُ أُسْبُوعٍ ✕ · بَعْدُ الدَّرْسِ ✕</span><span class="rule-example-ru">В приведённых конструкциях нельзя заменять фатху у قَبْلَ и بَعْدَ на дамму.</span></div></div></div></div>$$
  where id = time_rule_id;

  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order) values
    (time_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$قَبْلَ وَبَعْدَ
قَبْلَ، وَبَعْدَ : ظَرْفَانِ لِلزَّمَانِ، وَالِاسْمُ الَّذِي بَعْدَهُمَا مُضَافٌ إِلَيْهِ .$$, 27, 27, 1),
    (time_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$سَافَرَ أَبِي قَبْلَ أُسْبُوعٍ . خَرَجْتُ بَعْدَ الدَّرْسِ . ذَهَبْتُ إِلَى الْمَسْجِدِ قَبْلَ الْأَذَانِ .
أُسَافِرُ بَعْدَ شَهْرٍ .$$, 27, 27, 2),
    (time_rule_id, 'Sharkh_na_1_tom_Med_kursa.pdf', $$قَبْلَ أُسْبُوعٍ : قَبْلَ ظَرْفُ زَمَانٍ، أُسْبُوعٍ مُضَافٌ إِلَيْهِ .
بَعْدَ الدَّرْسِ : بَعْدَ ظَرْفُ زَمَانٍ، الدَّرْسِ مُضَافٌ إِلَيْهِ .
قَبْلُ أُسْبُوعٍ ✕ بَعْدُ الدَّرْسِ ✕$$, 27, 27, 3);
end;
$migration$;

commit;
