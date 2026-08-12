-- Verify Medina Book 1 lesson 10 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 14-15.

begin;

do $migration$
declare
  pronouns_rule_id bigint;
  names_rule_id bigint;
  possession_rule_id bigint;
  maa_rule_id bigint;
begin
  select id into strict pronouns_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '10'
    and sort_order = 1;

  select id into strict names_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '10'
    and sort_order = 2;

  select id into strict possession_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '10'
    and sort_order = 3;

  select id into strict maa_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '10'
    and sort_order = 6;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '10'
  );

  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '10'
  );

  update public.rules
  set sort_order = sort_order + 100
  where id in (pronouns_rule_id, names_rule_id, possession_rule_id, maa_rule_id);

  delete from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '10'
    and id not in (pronouns_rule_id, names_rule_id, possession_rule_id, maa_rule_id);

  update public.rules
  set
    sort_order = 1,
    title = 'ضَمَائِرُ الْمُتَكَلِّمِ وَالْمُخَاطَبِ وَالْغَائِبِ (местоимения говорящего, собеседника и отсутствующего)',
    rule_ar = 'الضَّمَائِرُ ثَلَاثَةٌ: لِلْمُتَكَلِّمِ، وَلِلْمُخَاطَبِ، وَلِلْغَائِبِ؛ وَمِنْهَا ضَمَائِرُ مُتَّصِلَةٌ بِالِاسْمِ، نَحْوَ: بَيْتِي، وَبَيْتُكَ، وَبَيْتُكِ، وَبَيْتُهُ، وَبَيْتُهَا.',
    summary = 'الضَّمَائِرُ ثَلَاثَةٌ: لِلْمُتَكَلِّمِ، وَلِلْمُخَاطَبِ، وَلِلْغَائِبِ؛ وَمِنْهَا ضَمَائِرُ مُتَّصِلَةٌ بِالِاسْمِ، نَحْوَ: بَيْتِي، وَبَيْتُكَ، وَبَيْتُكِ، وَبَيْتُهُ، وَبَيْتُهَا.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الضَّمَائِرُ ثَلَاثَةٌ: لِلْمُتَكَلِّمِ، وَلِلْمُخَاطَبِ، وَلِلْغَائِبِ؛ وَمِنْهَا ضَمَائِرُ مُتَّصِلَةٌ بِالِاسْمِ.</span><p class="rule-study-text">Автор делит местоимения на три разряда: <span dir="rtl" lang="ar">الْمُتَكَلِّمُ</span> — говорящий, <span dir="rtl" lang="ar">الْمُخَاطَبُ</span> — собеседник и <span dir="rtl" lang="ar">الْغَائِبُ</span> — отсутствующее лицо. Присоединённое к имени местоимение передаёт принадлежность.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Основные формы</span><table><thead><tr><th>Лицо</th><th>Отдельное местоимение</th><th>Присоединённая форма</th><th>Пример</th></tr></thead><tbody><tr><td>Говорящий</td><td><span dir="rtl" lang="ar">أَنَا</span> — я</td><td><span dir="rtl" lang="ar">ـِي</span> — мой/моя</td><td><span dir="rtl" lang="ar">بَيْتِي</span> — мой дом</td></tr><tr><td>Собеседник, мужчина</td><td><span dir="rtl" lang="ar">أَنْتَ</span> — ты</td><td><span dir="rtl" lang="ar">ـكَ</span> — твой/твоя</td><td><span dir="rtl" lang="ar">بَيْتُكَ</span> — твой дом</td></tr><tr><td>Собеседница</td><td>—</td><td><span dir="rtl" lang="ar">ـكِ</span> — твой/твоя</td><td><span dir="rtl" lang="ar">بَيْتُكِ</span> — твой дом</td></tr><tr><td>Отсутствующий мужчина</td><td><span dir="rtl" lang="ar">هُوَ</span> — он</td><td><span dir="rtl" lang="ar">ـهُ</span> — его</td><td><span dir="rtl" lang="ar">بَيْتُهُ</span> — его дом</td></tr><tr><td>Отсутствующая женщина</td><td>—</td><td><span dir="rtl" lang="ar">ـهَا</span> — её</td><td><span dir="rtl" lang="ar">بَيْتُهَا</span> — её дом</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Говорящий: мужской и женский род</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتِي. اِسْمِي مُحَمَّدٌ. اِسْمِي فَاطِمَةُ.</span><span class="rule-example-ru">Это мой дом. Моё имя — Мухаммад. Моё имя — Фатима.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبِي وَأُمِّي فِي الْبَيْتِ. عِنْدِي قَلَمٌ. لِي أَخٌ.</span><span class="rule-example-ru">Мои отец и мать дома. У меня есть ручка. У меня есть брат.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Собеседник, мужчина</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتُكَ. مَا اسْمُكَ؟ سَيَّارَتُكَ جَمِيلَةٌ.</span><span class="rule-example-ru">Это твой дом. Как тебя зовут? Твоя машина красивая.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبُوكَ وَأُمُّكَ فِي الْبَيْتِ. أَعِنْدَكَ قَلَمٌ؟ أَلَكَ أَخٌ؟</span><span class="rule-example-ru">Твои отец и мать дома. У тебя есть ручка? У тебя есть брат?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Собеседница</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتُكِ. مَا اسْمُكِ؟ سَيَّارَتُكِ جَمِيلَةٌ.</span><span class="rule-example-ru">Это твой дом. Как тебя зовут? Твоя машина красивая.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبُوكِ وَأُمُّكِ فِي الْبَيْتِ. أَعِنْدَكِ قَلَمٌ؟ أَلَكِ أَخٌ؟</span><span class="rule-example-ru">Твои отец и мать дома. У тебя есть ручка? У тебя есть брат?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Отсутствующий мужчина</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتُهُ. مَا اسْمُهُ؟ سَيَّارَتُهُ جَمِيلَةٌ.</span><span class="rule-example-ru">Это его дом. Как его зовут? Его машина красивая.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبُوهُ وَأُمُّهُ فِي الْبَيْتِ. أَعِنْدَهُ قَلَمٌ؟ أَلَهُ أَخٌ؟</span><span class="rule-example-ru">Его отец и мать дома. У него есть ручка? У него есть брат?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Отсутствующая женщина</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتُهَا. مَا اسْمُهَا؟ سَيَّارَتُهَا جَمِيلَةٌ.</span><span class="rule-example-ru">Это её дом. Как её зовут? Её машина красивая.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبُوهَا وَأُمُّهَا فِي الْبَيْتِ. أَعِنْدَهَا قَلَمٌ؟ أَلَهَا أَخٌ؟</span><span class="rule-example-ru">Её отец и мать дома. У неё есть ручка? У неё есть брат?</span></div></div></div></div>$$
  where id = pronouns_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      pronouns_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الضَّمَائِرُ ثَلَاثَةٌ، هِيَ : ١- الْمُتَكَلِّمُ : أَنَا، بَيْتِي . ٢- الْمُخَاطَبُ : أَنْتَ، بَيْتُكَ .
٣- الْغَائِبُ : هُوَ، بَيْتُهُ .$$,
      14,
      14,
      1
    ),
    (
      pronouns_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْمُتَكَلِّمُ الْمُذَكَّرُ وَالْمُؤَنَّثُ : هَذَا بَيْتِي . اِسْمِي مُحَمَّدٌ . اِسْمِي فَاطِمَةُ . أَبِي وَأُمِّي فِي الْبَيْتِ .
عِنْدِي قَلَمٌ . لِي أَخٌ .

الْمُخَاطَبُ الْمُذَكَّرُ : هَذَا بَيْتُكَ . مَا اسْمُكَ ؟ سَيَّارَتُكَ جَمِيلَةٌ . أَبُوكَ وَأُمُّكَ فِي الْبَيْتِ .
أَعِنْدَكَ قَلَمٌ ؟ أَلَكَ أَخٌ ؟

الْمُخَاطَبُ الْمُؤَنَّثُ : هَذَا بَيْتُكِ . مَا اسْمُكِ ؟ سَيَّارَتُكِ جَمِيلَةٌ . أَبُوكِ وَأُمُّكِ فِي الْبَيْتِ .
أَعِنْدَكِ قَلَمٌ ؟ أَلَكِ أَخٌ ؟$$,
      14,
      14,
      2
    ),
    (
      pronouns_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْغَائِبُ الْمُذَكَّرُ : هَذَا بَيْتُهُ . مَا اسْمُهُ ؟ سَيَّارَتُهُ جَمِيلَةٌ . أَبُوهُ وَأُمُّهُ فِي الْبَيْتِ .
أَعِنْدَهُ قَلَمٌ ؟ أَلَهُ أَخٌ ؟

الْغَائِبُ الْمُؤَنَّثُ : هَذَا بَيْتُهَا . مَا اسْمُهَا ؟ سَيَّارَتُهَا جَمِيلَةٌ . أَبُوهَا وَأُمُّهَا فِي الْبَيْتِ .
أَعِنْدَهَا قَلَمٌ ؟ أَلَهَا أَخٌ ؟$$,
      14,
      14,
      3
    );

  update public.rules
  set
    sort_order = 2,
    title = 'عِنْدِي وَلِي (выбор конструкции «у меня есть»)',
    rule_ar = 'تُسْتَعْمَلُ عِنْدِي لِغَيْرِ الْعَاقِلِ، وَتُسْتَعْمَلُ لِي لِلْعَاقِلِ.',
    summary = 'تُسْتَعْمَلُ عِنْدِي لِغَيْرِ الْعَاقِلِ، وَتُسْتَعْمَلُ لِي لِلْعَاقِلِ.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило урока</span><span class="rule-main-ar" dir="rtl" lang="ar">تُسْتَعْمَلُ عِنْدِي لِغَيْرِ الْعَاقِلِ، وَتُسْتَعْمَلُ لِي لِلْعَاقِلِ.</span><p class="rule-study-text">В учебной схеме этой страницы <span dir="rtl" lang="ar">عِنْدِي</span> используется с неразумным, а <span dir="rtl" lang="ar">لِي</span> — с разумным.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Неразумное</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">عِنْدِي كِتَابٌ. عِنْدِي سَاعَةٌ. عِنْدِي دَرَّاجَةٌ.</span><span class="rule-example-ru">У меня есть книга. У меня есть часы. У меня есть велосипед.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Разумное</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">لِي أُخْتٌ وَاحِدَةٌ. لِي اِبْنٌ وَبِنْتٌ. لِي أُمٌّ وَأَبٌ.</span><span class="rule-example-ru">У меня одна сестра. У меня есть сын и дочь. У меня есть мать и отец.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Сопоставление автора</span><table><thead><tr><th>Отмечено ✓</th><th>Отмечено ✕</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">أَلَكَ أَخٌ؟</span></td><td><span dir="rtl" lang="ar">أَعِنْدَكَ أَخٌ؟</span></td></tr><tr><td><span dir="rtl" lang="ar">أَعِنْدَكَ كِتَابٌ؟</span></td><td><span dir="rtl" lang="ar">أَلَكَ كِتَابٌ؟</span></td></tr></tbody></table></div></div>$$
  where id = possession_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      possession_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$عِنْدِي، لِي
عِنْدِي : لِغَيْرِ الْعَاقِلِ ← عِنْدِي كِتَابٌ . عِنْدِي سَاعَةٌ . عِنْدِي دَرَّاجَةٌ .
لِي : لِلْعَاقِلِ ← لِي أُخْتٌ وَاحِدَةٌ . لِي اِبْنٌ وَبِنْتٌ . لِي أُمٌّ وَأَبٌ .$$,
      14,
      14,
      1
    ),
    (
      possession_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$أَلَكَ أَخٌ ؟ ✓ أَعِنْدَكَ أَخٌ ؟ ✕
أَعِنْدَكَ كِتَابٌ ؟ ✓ أَلَكَ كِتَابٌ ؟ ✕$$,
      14,
      14,
      2
    );

  update public.rules
  set
    sort_order = 3,
    title = 'مَعَ (вместе с: обстоятельство места и идафа)',
    rule_ar = '«مَعَ» ظَرْفُ مَكَانٍ، وَهِيَ مُضَافٌ، وَالِاسْمُ الَّذِي بَعْدَهَا مُضَافٌ إِلَيْهِ مَجْرُورٌ بِالْكَسْرَةِ.',
    summary = '«مَعَ» ظَرْفُ مَكَانٍ، وَهِيَ مُضَافٌ، وَالِاسْمُ الَّذِي بَعْدَهَا مُضَافٌ إِلَيْهِ مَجْرُورٌ بِالْكَسْرَةِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">«مَعَ» ظَرْفُ مَكَانٍ، وَهِيَ مُضَافٌ، وَالِاسْمُ الَّذِي بَعْدَهَا مُضَافٌ إِلَيْهِ مَجْرُورٌ بِالْكَسْرَةِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">مَعَ</span> — «вместе с». В разборе автора это <span dir="rtl" lang="ar">ظَرْفُ مَكَانٍ</span> и <span dir="rtl" lang="ar">مُضَافٌ</span>; следующее имя является <span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span> и получает касру.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">خَرَجَ حَامِدٌ مَعَ خَالِدٍ.</span><span class="rule-example-ru">Хамид вышел вместе с Халидом.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبَ الطَّبِيبُ مَعَ الْمُهَنْدِسِ.</span><span class="rule-example-ru">Врач пошёл вместе с инженером.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">عَائِشَةُ مَعَهَا زَوْجُهَا.</span><span class="rule-example-ru">Вместе с Аишей — её муж.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ مَعَكَ يَا عَلِيُّ؟ مَعِي زَمِيلِي.</span><span class="rule-example-ru">Кто с тобой, Али? Со мной мой товарищ.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Сверка форм</span><table><thead><tr><th>Отмечено ✓</th><th>Отмечено ✕</th><th>Что проверяется</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">مَعَ خَالِدٍ</span></td><td><span dir="rtl" lang="ar">مَعَ خَالِدٌ</span></td><td><span dir="rtl" lang="ar">جَرٌّ</span> после <span dir="rtl" lang="ar">مَعَ</span></td></tr><tr><td><span dir="rtl" lang="ar">عَائِشَةُ مَعَهَا زَوْجُهَا</span></td><td><span dir="rtl" lang="ar">عَائِشَةُ مَعَهُ زَوْجُهَا</span></td><td>женский суффикс <span dir="rtl" lang="ar">ـهَا</span></td></tr><tr><td><span dir="rtl" lang="ar">مَنْ مَعَكَ يَا عَلِيُّ؟ مَعِي زَمِيلِي</span></td><td><span dir="rtl" lang="ar">مَنْ مَعَكَ يَا عَلِيُّ؟ مَعَكَ زَمِيلِي</span></td><td>в ответе нужен суффикс говорящего <span dir="rtl" lang="ar">ـِي</span></td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-verb"><span class="rule-term-ar" dir="rtl" lang="ar">مَعَ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُضَافٌ</span> — первый член идафы</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">خَالِدٍ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ مَجْرُورٌ</span> — второй член идафы в родительном падеже</span></div></div></div></div>$$
  where id = maa_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      maa_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$مَعَ
خَرَجَ حَامِدٌ مَعَ خَالِدٍ . ذَهَبَ الطَّبِيبُ مَعَ الْمُهَنْدِسِ . عَائِشَةُ مَعَهَا زَوْجُهَا .
مَنْ مَعَكَ يَا عَلِيُّ ؟ مَعِي زَمِيلِي .$$,
      15,
      15,
      1
    ),
    (
      maa_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$مَعَ خَالِدٍ ✓ مَعَ خَالِدٌ ✕
عَائِشَةُ مَعَهَا زَوْجُهَا ✓ عَائِشَةُ مَعَهُ زَوْجُهَا ✕
مَنْ مَعَكَ يَا عَلِيُّ ؟ مَعِي زَمِيلِي ✓ مَنْ مَعَكَ يَا عَلِيُّ ؟ مَعَكَ زَمِيلِي ✕$$,
      15,
      15,
      2
    ),
    (
      maa_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$مَعَ خَالِدٍ
مَعَ : مُضَافٌ
خَالِدٍ : مُضَافٌ إِلَيْهِ

مَعَ : ظَرْفُ مَكَانٍ، الِاسْمُ الَّذِي بَعْدَهُ مَجْرُورٌ بِالْكَسْرَةِ .$$,
      15,
      15,
      3
    );

  update public.rules
  set
    sort_order = 4,
    title = 'الْعَلَمُ الْمُذَكَّرُ الْمَخْتُومُ بِتَاءِ التَّأْنِيثِ (мужское собственное имя с окончанием ة)',
    rule_ar = 'الْعَلَمُ الْمُذَكَّرُ الْمَخْتُومُ بِتَاءِ التَّأْنِيثِ لَا يُنَوَّنُ.',
    summary = 'الْعَلَمُ الْمُذَكَّرُ الْمَخْتُومُ بِتَاءِ التَّأْنِيثِ لَا يُنَوَّنُ.',
    rule_kind = 'important',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">الْعَلَمُ الْمُذَكَّرُ الْمَخْتُومُ بِتَاءِ التَّأْنِيثِ لَا يُنَوَّنُ.</span><p class="rule-study-text">Мужское имя собственное, оканчивающееся на <span dir="rtl" lang="ar">تَاءُ التَّأْنِيثِ</span> — показатель женского рода <span dir="rtl" lang="ar">ة</span>, — не принимает танвин.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Сравните имена</span><table><thead><tr><th>Обычное мужское имя</th><th>Мужское имя на ة без танвина</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">مُحَمَّدٌ</span></td><td><span dir="rtl" lang="ar">حَمْزَةُ</span></td></tr><tr><td><span dir="rtl" lang="ar">خَالِدٌ</span></td><td><span dir="rtl" lang="ar">طَلْحَةُ</span></td></tr><tr><td><span dir="rtl" lang="ar">مَحْمُودٌ</span></td><td><span dir="rtl" lang="ar">مُعَاوِيَةُ</span></td></tr><tr><td><span dir="rtl" lang="ar">حُسَيْنٌ</span></td><td><span dir="rtl" lang="ar">أُسَامَةُ</span></td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Проверка окончания</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">حَمْزَةُ ✓　حَمْزَةٌ ✕</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">طَلْحَةُ ✓　طَلْحَةٌ ✕</span></div></div></div></div>$$
  where id = names_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      names_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْعَلَمُ الْمُذَكَّرُ الْمَخْتُومُ بِتَاءِ التَّأْنِيثِ لَا يُنَوَّنُ$$,
      15,
      15,
      1
    ),
    (
      names_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$مُحَمَّدٌ : حَمْزَةُ
خَالِدٌ : طَلْحَةُ
مَحْمُودٌ : مُعَاوِيَةُ
حُسَيْنٌ : أُسَامَةُ

حَمْزَةُ ✓ حَمْزَةٌ ✕
طَلْحَةُ ✓ طَلْحَةٌ ✕$$,
      15,
      15,
      2
    );
end;
$migration$;

commit;
