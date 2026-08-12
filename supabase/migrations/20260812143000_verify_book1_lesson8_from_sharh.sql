-- Verify Medina Book 1 lesson 8 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF page 12.

begin;

do $migration$
declare
  target_rule_id bigint;
begin
  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '8'
  );

  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '8'
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '8'
    and sort_order = 1;

  update public.rules
  set
    title = 'الْإِشَارَةُ إِلَى الْمُعَرَّفِ بِـ«أَلْ» (указание на определённое имя с артиклем)',
    rule_ar = 'إِذَا جَاءَ بَعْدَ اِسْمِ الْإِشَارَةِ اِسْمٌ مُعَرَّفٌ بِـ«أَلْ»، أُعْرِبَ اِسْمُ الْإِشَارَةِ مُبْتَدَأً، وَالِاسْمُ الْمُعَرَّفُ بَدَلًا، وَمَا بَعْدَهُمَا خَبَرًا.',
    summary = 'إِذَا جَاءَ بَعْدَ اِسْمِ الْإِشَارَةِ اِسْمٌ مُعَرَّفٌ بِـ«أَلْ»، أُعْرِبَ اِسْمُ الْإِشَارَةِ مُبْتَدَأً، وَالِاسْمُ الْمُعَرَّفُ بَدَلًا، وَمَا بَعْدَهُمَا خَبَرًا.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا جَاءَ بَعْدَ اِسْمِ الْإِشَارَةِ اِسْمٌ مُعَرَّفٌ بِـ«أَلْ»، أُعْرِبَ اِسْمُ الْإِشَارَةِ مُبْتَدَأً، وَالِاسْمُ الْمُعَرَّفُ بَدَلًا، وَمَا بَعْدَهُمَا خَبَرًا.</span><p class="rule-study-text">Если после указательного имени стоит существительное с <span dir="rtl" lang="ar">أَلْ</span>, указательное имя является <span dir="rtl" lang="ar">مُبْتَدَأٌ</span> — подлежащим, определённое существительное — <span dir="rtl" lang="ar">بَدَلٌ</span> — приложением, а последующая часть — <span dir="rtl" lang="ar">خَبَرٌ</span> — сказуемым.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Правильные образцы из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا التَّاجِرُ تَاجِرٌ.</span><span class="rule-example-ru">Этот торговец — торговец.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">ذٰلِكَ الرَّجُلُ طَبِيبٌ.</span><span class="rule-example-ru">Тот мужчина — врач.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا الْبَيْتُ لِلتَّاجِرِ.</span><span class="rule-example-ru">Этот дом принадлежит торговцу.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">ذٰلِكَ الْبَيْتُ لِلطَّبِيبِ.</span><span class="rule-example-ru">Тот дом принадлежит врачу.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Не так</span><div class="rule-example-list"><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا الرَّجُلُ التَّاجِرُ. ✕</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">ذٰلِكَ الرَّجُلُ الطَّبِيبُ. ✕</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Разбор</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">هٰذَا / ذٰلِكَ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُبْتَدَأٌ</span> — подлежащее</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">الرَّجُلُ / الْبَيْتُ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">بَدَلٌ</span> — приложение</span></div><div class="rule-meaning-card rule-term-predicate"><span class="rule-term-ar" dir="rtl" lang="ar">تَاجِرٌ / لِلطَّبِيبِ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">خَبَرٌ</span> — сказуемое</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الإِشَارَةُ إِلَى الْمُعَرَّفِ بِأَلْ

هَذَا التَّاجِرُ تَاجِرٌ . ذَلِكَ الرَّجُلُ طَبِيبٌ . هَذَا الْبَيْتُ لِلتَّاجِرِ . ذَلِكَ الْبَيْتُ لِلطَّبِيبِ .
هَذَا الرَّجُلُ التَّاجِرُ . ✕ ذَلِكَ الرَّجُلُ الطَّبِيبُ . ✕$$,
      12,
      12,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$هَذَا الرَّجُلُ تَاجِرٌ
هَذَا : مُبْتَدَأٌ
الرَّجُلُ : بَدَلٌ
تَاجِرٌ : خَبَرٌ

ذَلِكَ الْبَيْتُ لِلطَّبِيبِ
ذَلِكَ : مُبْتَدَأٌ
الْبَيْتُ : بَدَلٌ
لِلطَّبِيبِ : خَبَرٌ$$,
      12,
      12,
      2
    );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '8'
    and sort_order = 2;

  update public.rules
  set
    title = 'لِمَنْ؟ (кому принадлежит? — вопрос о разумном)',
    rule_ar = 'لِمَنْ؟ سُؤَالٌ عَنِ الْعَاقِلِ.',
    summary = 'لِمَنْ؟ سُؤَالٌ عَنِ الْعَاقِلِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">لِمَنْ؟ سُؤَالٌ عَنِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">لِمَنْ؟</span> — «кому?», «чей?»; этим сочетанием спрашивают, какому разумному лицу что-либо принадлежит.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Близкий предмет</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنْ هٰذَا الْبَيْتُ؟</span><span class="rule-example-ru">Кому принадлежит этот дом?</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا الْبَيْتُ لِلتَّاجِرِ.</span><span class="rule-example-ru">Этот дом принадлежит торговцу.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Далёкий предмет</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنْ ذٰلِكَ الْبَيْتُ؟</span><span class="rule-example-ru">Кому принадлежит тот дом?</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">ذٰلِكَ الْبَيْتُ لِلطَّبِيبِ.</span><span class="rule-example-ru">Тот дом принадлежит врачу.</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Sharkh_na_1_tom_Med_kursa.pdf',
    $$لِمَنْ ؟
لِمَنْ ؟ سُؤَالٌ عَنِ الْعَاقِلِ . لِمَنْ هَذَا الْبَيْتُ ؟ هَذَا الْبَيْتُ لِلتَّاجِرِ .
لِمَنْ ذَلِكَ الْبَيْتُ ؟ ذَلِكَ الْبَيْتُ لِلطَّبِيبِ .$$,
    12,
    12,
    1
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '8'
    and sort_order = 3;

  update public.rules
  set
    title = 'أَمَامَ وَخَلْفَ (перед и позади: обстоятельства места)',
    rule_ar = '«أَمَامَ» وَ«خَلْفَ» ظَرْفَانِ لِلْمَكَانِ، وَكُلٌّ مِنْهُمَا مُضَافٌ، وَالِاسْمُ بَعْدَهُ مُضَافٌ إِلَيْهِ.',
    summary = '«أَمَامَ» وَ«خَلْفَ» ظَرْفَانِ لِلْمَكَانِ، وَكُلٌّ مِنْهُمَا مُضَافٌ، وَالِاسْمُ بَعْدَهُ مُضَافٌ إِلَيْهِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">«أَمَامَ» وَ«خَلْفَ» ظَرْفَانِ لِلْمَكَانِ، وَكُلٌّ مِنْهُمَا مُضَافٌ، وَالِاسْمُ بَعْدَهُ مُضَافٌ إِلَيْهِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">أَمَامَ</span> — «перед», <span dir="rtl" lang="ar">خَلْفَ</span> — «позади, за». Оба слова являются <span dir="rtl" lang="ar">ظَرْفُ مَكَانٍ</span> — обстоятельствами места. Они выступают как <span dir="rtl" lang="ar">مُضَافٌ</span>, а следующее имя — как <span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">السَّبُّورَةُ أَمَامَ الطُّلَّابِ.</span><span class="rule-example-ru">Доска перед учащимися.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">السَّبُّورَةُ خَلْفَ الْمُدَرِّسِ.</span><span class="rule-example-ru">Доска позади преподавателя.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ سَيَّارَةُ الْإِمَامِ؟ هِيَ أَمَامَ الْمَدْرَسَةِ.</span><span class="rule-example-ru">Где машина имама? Она перед школой.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ جَلَسَ حَامِدٌ؟ جَلَسَ خَلْفَ مَحْمُودٍ.</span><span class="rule-example-ru">Где сел Хамид? Он сел позади Махмуда.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Связь слов</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-verb"><span class="rule-term-ar" dir="rtl" lang="ar">خَلْفَ / أَمَامَ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُضَافٌ</span> — первый член идафы</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">مَحْمُودٍ / الطُّلَّابِ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span> — второй член идафы</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$أَمَامَ ، خَلْفَ
السَّبُّورَةُ أَمَامَ الطُّلَّابِ . السَّبُّورَةُ خَلْفَ الْمُدَرِّسِ . أَيْنَ سَيَّارَةُ الإِمَامِ ؟ هِيَ أَمَامَ الْمَدْرَسَةِ .
أَيْنَ جَلَسَ حَامِدٌ ؟ جَلَسَ خَلْفَ مَحْمُودٍ .$$,
      12,
      12,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$خَلْفَ مَحْمُودٍ
خَلْفَ : مُضَافٌ
مَحْمُودٍ : مُضَافٌ إِلَيْهِ

أَمَامَ الطُّلَّابِ
أَمَامَ : مُضَافٌ
الطُّلَّابِ : مُضَافٌ إِلَيْهِ

أَمَامَ : خَلْفَ
ظَرْفُ مَكَانٍ$$,
      12,
      12,
      2
    );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '8'
    and sort_order = 4;

  update public.rules
  set
    title = 'مَعَانِي حُرُوفِ الْجَرِّ (значения предлогов)',
    rule_ar = 'مِنْ تُفِيدُ الْبِدَايَةَ، وَإِلَى تُفِيدُ النِّهَايَةَ، وَفِي تُفِيدُ الظَّرْفِيَّةَ، وَعَلَى تُفِيدُ الِاسْتِعْلَاءَ، وَاللَّامُ تُفِيدُ الْمِلْكَ، وَهِيَ حَرْفُ جَرٍّ.',
    summary = 'مِنْ تُفِيدُ الْبِدَايَةَ، وَإِلَى تُفِيدُ النِّهَايَةَ، وَفِي تُفِيدُ الظَّرْفِيَّةَ، وَعَلَى تُفِيدُ الِاسْتِعْلَاءَ، وَاللَّامُ تُفِيدُ الْمِلْكَ، وَهِيَ حَرْفُ جَرٍّ.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Значения предлогов</span><span class="rule-main-ar" dir="rtl" lang="ar">مِنْ تُفِيدُ الْبِدَايَةَ، وَإِلَى تُفِيدُ النِّهَايَةَ، وَفِي تُفِيدُ الظَّرْفِيَّةَ، وَعَلَى تُفِيدُ الِاسْتِعْلَاءَ، وَاللَّامُ تُفِيدُ الْمِلْكَ.</span><table><thead><tr><th>Предлог</th><th>Арабское значение</th><th>Русский смысл</th></tr></thead><tbody><tr><td><span dir="rtl" lang="ar">مِنْ</span></td><td><span dir="rtl" lang="ar">الْبِدَايَةُ</span></td><td>начало, исходная точка: «из, от»</td></tr><tr><td><span dir="rtl" lang="ar">إِلَى</span></td><td><span dir="rtl" lang="ar">النِّهَايَةُ</span></td><td>конец, конечная точка: «до, к»</td></tr><tr><td><span dir="rtl" lang="ar">فِي</span></td><td><span dir="rtl" lang="ar">الظَّرْفِيَّةُ</span></td><td>нахождение внутри: «в»</td></tr><tr><td><span dir="rtl" lang="ar">عَلَى</span></td><td><span dir="rtl" lang="ar">الِاسْتِعْلَاءُ</span></td><td>нахождение сверху: «на, над»</td></tr><tr><td><span dir="rtl" lang="ar">لِـ</span></td><td><span dir="rtl" lang="ar">الْمِلْكُ</span></td><td>принадлежность: «для, у, принадлежит»</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Лям — предлог</span><p class="rule-study-text"><span dir="rtl" lang="ar">اللَّامُ حَرْفُ جَرٍّ.</span> После него имя стоит в родительном падеже: <span dir="rtl" lang="ar">مَجْرُورٌ</span>.</p><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هٰذَا الْبَيْتُ لِلتَّاجِرِ.</span><span class="rule-example-ru">Этот дом принадлежит торговцу.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">لِلتَّاجِرِ · لِلطَّبِيبِ · لِلْمُدَرِّسِ · لِمُحَمَّدٍ</span><span class="rule-example-ru">торговцу · врачу · преподавателю · Мухаммаду</span></div></div></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$هَذَا الْبَيْتُ لِلتَّاجِرِ . اللَّامُ : حَرْفُ جَرٍّ ← لِلتَّاجِرِ . لِلطَّبِيبِ . لِلْمُدَرِّسِ . لِمُحَمَّدٍ .$$,
      12,
      12,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$حُرُوفُ الْجَرِّ، مِنْ : تُفِيدُ الْبِدَايَةَ . إِلَى : تُفِيدُ النِّهَايَةَ . فِي : تُفِيدُ الظَّرْفِيَّةَ . عَلَى : تُفِيدُ الِاسْتِعْلَاءَ .
اللَّامُ : تُفِيدُ الْمِلْكَ .$$,
      12,
      12,
      2
    );
end;
$migration$;

commit;
