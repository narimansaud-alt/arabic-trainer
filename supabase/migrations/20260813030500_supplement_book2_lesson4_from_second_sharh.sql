-- Supplement Medina Book 2 lesson 4 from the second Arabic sharh.
-- Compatible material is merged; provenance remains separate by PDF.

begin;

do $migration$
declare
  past_rule_id bigint;
  maa_rule_id bigint;
  lianna_rule_id bigint;
  lesson_rule_count integer;
  updated_content text;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '4';

  if lesson_rule_count <> 3 then
    raise exception 'Expected 3 Book 2 lesson 4 rules before supplement, found %', lesson_rule_count;
  end if;

  select id into strict past_rule_id from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '4' and sort_order = 1;
  select id into strict maa_rule_id from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '4' and sort_order = 2;
  select id into strict lianna_rule_id from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '4' and sort_order = 3;

  -- 1. Distinguish the attached subjects, feminine ta, and obligatory hidden subject.
  select content into strict updated_content from public.rules where id = past_rule_id;
  updated_content := rtrim(updated_content);
  if right(updated_content, 6) <> '</div>' then
    raise exception 'Unexpected outer markup for Book 2 lesson 4 past-tense rule';
  end if;
  updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-past-subject-markers"><span class="rule-card-kicker">Показатели فَاعِلٌ — подлежащего</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الصِّيغَةُ</span><span class="rule-table-ru">форма</span></th><th><span class="rule-table-ar">الْعَلَامَةُ</span><span class="rule-table-ru">показатель</span></th><th><span class="rule-table-ar">وَظِيفَتُهَا</span><span class="rule-table-ru">грамматическая роль</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبْتُ، ذَهَبْتَ، ذَهَبْتِ</span><span class="rule-table-ru">я ушёл; ты ушёл; ты ушла</span></td><td><span class="rule-table-ar ar-tone-subject">التَّاءُ الْمُتَحَرِّكَةُ (تَاءُ الْفَاعِلِ)</span><span class="rule-table-ru">изменяемая ت — ت подлежащего</span></td><td><span class="rule-table-ar ar-tone-subject">ضَمِيرٌ مُتَّصِلٌ يَكُونُ فَاعِلًا</span><span class="rule-table-ru">слитное местоимение, являющееся подлежащим</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبُوا</span><span class="rule-table-ru">они, мужчины, ушли</span></td><td><span class="rule-table-ar ar-tone-subject">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">буква وَاو для мужского множественного</span></td><td><span class="rule-table-ar ar-tone-subject">ضَمِيرٌ مُتَّصِلٌ يَكُونُ فَاعِلًا</span><span class="rule-table-ru">слитное местоимение-подлежащее</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبْنَ</span><span class="rule-table-ru">они, женщины, ушли</span></td><td><span class="rule-table-ar ar-tone-subject">نُونُ النِّسْوَةِ</span><span class="rule-table-ru">женская ن множественного числа</span></td><td><span class="rule-table-ar ar-tone-subject">ضَمِيرٌ مُتَّصِلٌ يَكُونُ فَاعِلًا</span><span class="rule-table-ru">слитное местоимение-подлежащее</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb">ذَهَبَ، ذَهَبَتْ</span><span class="rule-table-ru">он ушёл; она ушла</span></td><td><span class="rule-table-ar ar-tone-subject">ضَمِيرٌ مُسْتَتِرٌ وُجُوبًا تَقْدِيرُهُ هُوَ أَوْ هِيَ</span><span class="rule-table-ru">обязательно скрытое местоимение «он» или «она»</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">الضَّمِيرُ فَاعِلٌ</span>، وَ<span class="ar-tone-particle">التَّاءُ حَرْفُ تَأْنِيثٍ</span></span><span class="rule-table-ru">скрытое местоимение — подлежащее; ت в ذَهَبَتْ — показатель женского рода</span></td></tr></tbody></table></div></div>
<div class="rule-study-card"><span class="rule-card-kicker">Все примеры второго шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا <span class="ar-tone-verb">ذَهَبْتُ</span> إِلَى الْمَطَارِ.</span><span class="rule-example-ru">Я поехал в аэропорт.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتَ <span class="ar-tone-verb">ذَهَبْتَ</span>.</span><span class="rule-example-ru">Ты, мужчина, ушёл.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتِ <span class="ar-tone-verb">ذَهَبْتِ</span>.</span><span class="rule-example-ru">Ты, женщина, ушла.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">الْأَوْلَادُ <span class="ar-tone-verb">ذَهَبُوا</span> إِلَى الْمَدْرَسَةِ.</span><span class="rule-example-ru">Мальчики пошли в школу.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">الرِّجَالُ <span class="ar-tone-verb">رَجَعُوا</span> مِنَ الْمَسْجِدِ.</span><span class="rule-example-ru">Мужчины вернулись из мечети.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّالِبَاتُ <span class="ar-tone-verb">ذَهَبْنَ</span> إِلَى الْكُلِّيَّةِ.</span><span class="rule-example-ru">Студентки пошли на факультет.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">النِّسَاءُ <span class="ar-tone-verb">رَجَعْنَ</span> مِنَ الْمَسْجِدِ.</span><span class="rule-example-ru">Женщины вернулись из мечети.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">مُحَمَّدٌ <span class="ar-tone-verb">ذَهَبَ</span>.</span><span class="rule-example-ru">Мухаммад ушёл.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">فَاطِمَةُ <span class="ar-tone-verb">ذَهَبَتْ</span>.</span><span class="rule-example-ru">Фатима ушла.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">الْمُدَرِّسُ <span class="ar-tone-verb">رَجَعَ</span>.</span><span class="rule-example-ru">Учитель вернулся.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">الْمُدَرِّسَةُ <span class="ar-tone-verb">رَجَعَتْ</span>.</span><span class="rule-example-ru">Учительница вернулась.</span></div></div></div>
</div>$html$;

  update public.rules
  set
    rule_ar = 'يُسْنَدُ الْفِعْلُ الْمَاضِي إِلَى الضَّمَائِرِ الْعَشَرَةِ، فَتَدُلُّ صِيغَتُهُ عَلَى الْمُتَكَلِّمِ أَوِ الْمُخَاطَبِ أَوِ الْغَائِبِ، وَعَلَى الْإِفْرَادِ أَوِ الْجَمْعِ، وَعَلَى التَّذْكِيرِ أَوِ التَّأْنِيثِ. وَالتَّاءُ الْمُتَحَرِّكَةُ وَوَاوُ الْجَمَاعَةِ وَنُونُ النِّسْوَةِ ضَمَائِرُ مُتَّصِلَةٌ تَكُونُ فَاعِلًا. وَفِي «ذَهَبَ» وَ«ذَهَبَتْ» لِلْغَائِبِ الْمُفْرَدِ يَكُونُ الْفَاعِلُ ضَمِيرًا مُسْتَتِرًا وُجُوبًا تَقْدِيرُهُ هُوَ أَوْ هِيَ، وَالتَّاءُ فِي «ذَهَبَتْ» حَرْفُ تَأْنِيثٍ.',
    summary = 'يُسْنَدُ الْفِعْلُ الْمَاضِي إِلَى الضَّمَائِرِ الْعَشَرَةِ، فَتَدُلُّ صِيغَتُهُ عَلَى الْمُتَكَلِّمِ أَوِ الْمُخَاطَبِ أَوِ الْغَائِبِ، وَعَلَى الْإِفْرَادِ أَوِ الْجَمْعِ، وَعَلَى التَّذْكِيرِ أَوِ التَّأْنِيثِ. وَالتَّاءُ الْمُتَحَرِّكَةُ وَوَاوُ الْجَمَاعَةِ وَنُونُ النِّسْوَةِ ضَمَائِرُ مُتَّصِلَةٌ تَكُونُ فَاعِلًا. وَفِي «ذَهَبَ» وَ«ذَهَبَتْ» لِلْغَائِبِ الْمُفْرَدِ يَكُونُ الْفَاعِلُ ضَمِيرًا مُسْتَتِرًا وُجُوبًا تَقْدِيرُهُ هُوَ أَوْ هِيَ، وَالتَّاءُ فِي «ذَهَبَتْ» حَرْفُ تَأْنِيثٍ.',
    content = updated_content
  where id = past_rule_id;

  -- 2. Add the general function and examples of مَا النَّافِيَةُ before the 80-page answer rule.
  select content into strict updated_content from public.rules where id = maa_rule_id;
  if position('book2-second-sharh-maa-general' in updated_content) = 0 then
    updated_content := replace(
      updated_content,
      '<div class="rule-study">',
      '<div class="rule-study">' || $html$<div class="rule-study-card book2-second-sharh-maa-general"><span class="rule-card-kicker">Общее отрицание прошедшего</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَا النَّافِيَةُ</span> حَرْفٌ يُنْفَى بِهِ <span class="ar-tone-verb">الْفِعْلُ الْمَاضِي</span>.</span><p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">مَا</span> ставится перед прошедшим глаголом и сообщает, что действие не произошло.</p><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَذَهَبْتَ إِلَى الْمَعْهَدِ؟ لَا، <span class="ar-tone-particle">مَا</span> <span class="ar-tone-verb">ذَهَبْتُ</span>.</span><span class="rule-example-ru">Ты ходил в институт? — Нет, я не ходил.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَرَجَعَ أَبُوكَ مِنَ الرِّيَاضِ؟ لَا، <span class="ar-tone-particle">مَا</span> <span class="ar-tone-verb">رَجَعَ</span>.</span><span class="rule-example-ru">Твой отец вернулся из Эр-Рияда? — Нет, не вернулся.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا الْيَوْمَ <span class="ar-tone-particle">مَا</span> <span class="ar-tone-verb">أَكَلْتُ</span> شَيْئًا.</span><span class="rule-example-ru">Сегодня я ничего не ел.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أُمِّي <span class="ar-tone-particle">مَا</span> <span class="ar-tone-verb">خَرَجَتْ</span> أَمْسِ.</span><span class="rule-example-ru">Моя мать вчера не выходила.</span></div></div></div>$html$
    );
  end if;

  update public.rules
  set
    title = 'مَا النَّافِيَةُ وَجَوَابُ السُّؤَالِ بِهَا (отрицание прошедшего и ответ на вопрос с مَا)',
    rule_ar = 'مَا النَّافِيَةُ حَرْفٌ يُنْفَى بِهِ الْفِعْلُ الْمَاضِي. وَإِذَا وَقَعَتْ «مَا» بَعْدَ هَمْزَةِ الِاسْتِفْهَامِ، أُجِيبَ بِـ«بَلَى» فِي الْإِثْبَاتِ، وَبِـ«نَعَمْ» فِي النَّفْيِ.',
    summary = 'مَا النَّافِيَةُ حَرْفٌ يُنْفَى بِهِ الْفِعْلُ الْمَاضِي. وَإِذَا وَقَعَتْ «مَا» بَعْدَ هَمْزَةِ الِاسْتِفْهَامِ، أُجِيبَ بِـ«بَلَى» فِي الْإِثْبَاتِ، وَبِـ«نَعَمْ» فِي النَّفْيِ.',
    content = updated_content
  where id = maa_rule_id;

  -- 3. Add all forms and examples of لِأَنَّ from the second sharh.
  select content into strict updated_content from public.rules where id = lianna_rule_id;
  updated_content := rtrim(updated_content);
  if right(updated_content, 6) <> '</div>' then
    raise exception 'Unexpected outer markup for Book 2 lesson 4 lianna rule';
  end if;
  updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-lianna-forms"><span class="rule-card-kicker">Формы с местоимениями</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الصِّيغَةُ</span><span class="rule-table-ru">форма</span></th><th><span class="rule-table-ar">الْمَعْنَى</span><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-particle">لِأَنَّهُ</span></td><td><span class="rule-table-ru">потому что он / оно</span></td></tr><tr><td><span class="rule-table-ar ar-tone-particle">لِأَنَّهَا</span></td><td><span class="rule-table-ru">потому что она</span></td></tr><tr><td><span class="rule-table-ar ar-tone-particle">لِأَنَّكَ</span></td><td><span class="rule-table-ru">потому что ты, мужчина</span></td></tr><tr><td><span class="rule-table-ar ar-tone-particle">لِأَنَّكِ</span></td><td><span class="rule-table-ru">потому что ты, женщина</span></td></tr><tr><td><span class="rule-table-ar ar-tone-particle">لِأَنِّي</span></td><td><span class="rule-table-ru">потому что я</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры второго шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">ذَهَبَ</span> إِلَى الْمُسْتَشْفَى <span class="ar-tone-particle">لِأَنَّهُ</span> مَرِيضٌ.</span><span class="rule-example-ru">Он пошёл в больницу, потому что болен.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">زُرْتُكَ</span> الْآنَ <span class="ar-tone-particle">لِأَنَّكَ</span> مُسَافِرٌ.</span><span class="rule-example-ru">Я навестил тебя сейчас, потому что ты уезжаешь.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">رَجَعَتْ</span> آمِنَةُ مِنَ الْمَدْرَسَةِ <span class="ar-tone-particle">لِأَنَّهَا</span> مَرِيضَةٌ.</span><span class="rule-example-ru">Амина вернулась из школы, потому что она больна.</span></div></div></div>
</div>$html$;
  update public.rules set content = updated_content where id = lianna_rule_id;

  delete from public.rule_sources
  where rule_id in (past_rule_id, maa_rule_id, lianna_rule_id)
    and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf';

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (past_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$إِسْنَادُ الْفِعْلِ الْمَاضِي إِلَى الضَّمَائِرِ
إسنادُ الفعلِ إلى التاءِ المتحرِّكةِ (تاءُ الفاعلِ): ذهبتُ، ذهبتَ، ذهبتِ.
تقولُ: أنا ذهبتُ إلى المطارِ. أنتَ ذهبتَ. أنتِ ذهبتِ. (الضميرُ التاءُ: فاعلٌ).
إسنادُ الفعلِ إلى واوِ الجماعةِ: ذهبوا.
تقولُ: الأولادُ ذهبوا إلى المدرسةِ. الرجالُ رجعوا من المسجدِ. (واوُ الجماعةِ: فاعلٌ).
إسنادُ الفعلِ إلى نونِ النسوةِ: ذهبنَ.
تقولُ: الطالباتُ ذهبنَ إلى الكليةِ. النساءُ رجعنَ من المسجدِ. (نونُ النسوةِ: فاعلٌ).
إسنادُ الفعلِ إلى ضميرِ الغائبِ المفردِ: ذهبَ (هو)، ذهبتْ (هي).
تقولُ: محمدٌ ذهبَ. فاطمةُ ذهبتْ. المدرسُ رجعَ. المدرسةُ رجعتْ.
(الفاعلُ ضميرٌ مستترٌ، تقديرُهُ: هو، أو هي). ذهبتْ ← التاءُ: حرفُ تأنيثٍ.$source$, 12, 12, 2),
    (past_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$ضميرُ الغائبِ للمفردِ مستترٌ وجوبًا (لا يظهرُ).$source$, 12, 12, 3),
    (maa_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$مَا النَّافِيَةُ: حرفٌ يُنْفَى به الفعلُ الماضي.
أذهبتَ إلى المعهدِ؟ لا. ما ذهبتُ.
أرجعَ أبوكَ من الرياضِ؟ لا. ما رجعَ.
أنا اليومَ ما أكلتُ شيئًا.
أمِّي ما خرجتْ أمسِ.$source$, 12, 12, 2),
    (lianna_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$لِأَنَّ: أصلُها ← لِ + أَنَّ (اللَّامُ: حرفُ جرٍّ، أَنَّ: حرفُ نصبٍ) لِأَنَّهُ، لِأَنَّهَا، لِأَنَّكَ، لِأَنَّكِ، لِأَنِّي.
تقولُ: ذهبَ إلى المستشفى لِأَنَّهُ مريضٌ. زرتُكَ الآنَ لِأَنَّكَ مسافرٌ.
رجعتْ آمنةُ من المدرسةِ لِأَنَّهَا مريضةٌ.$source$, 12, 12, 3),
    (lianna_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$لِأَنَّهُ: اللَّامُ تُفيدُ التعليلَ، أي: بيانُ السببِ.$source$, 12, 12, 4);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '4' and coalesce(rule_ar, '') = ''
  ) then
    raise exception 'Book 2 lesson 4 contains an empty rule_ar';
  end if;
  if exists (
    select 1 from public.rules r
    where r.course_name = 'Мединский курс (Том 2)' and r.lesson_number = '4'
      and not exists (select 1 from public.rule_sources s where s.rule_id = r.id)
  ) then
    raise exception 'Book 2 lesson 4 contains a rule without provenance';
  end if;
end;
$migration$;

commit;
