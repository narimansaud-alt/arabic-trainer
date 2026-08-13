-- Complete Medina Book 2 lesson 8 from the manually checked second Arabic
-- sharh, PDF page 20. The existing detailed-sharh review card is preserved
-- and expanded; source_text remains separate from the formulated rule_ar.

begin;

do $migration$
declare
  review_rule_id bigint;
  lesson_rule_count integer;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '8';

  if lesson_rule_count <> 1 then
    raise exception 'Expected 1 Book 2 lesson 8 rule before supplement, found %', lesson_rule_count;
  end if;

  select id into strict review_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '8'
    and sort_order = 1;

  update public.rules
  set
    title = 'مُرَاجَعَةُ إِسْنَادِ الْفِعْلِ الْمَاضِي إِلَى الضَّمَائِرِ (повторение присоединения глагола прошедшего времени к местоимениям)',
    rule_ar = 'يُسْنَدُ الْفِعْلُ الْمَاضِي إِلَى ضَمَائِرِ الْفَاعِلِ، فَيَكُونُ فَاعِلُهُ ضَمِيرًا مُسْتَتِرًا أَوْ بَارِزًا. وَالضَّمِيرُ الْبَارِزُ إِمَّا مُتَّصِلٌ وَإِمَّا مُنْفَصِلٌ، وَالضَّمَائِرُ الْمَذْكُورَةُ فِي هَذَا الدَّرْسِ ضَمَائِرُ رَفْعٍ. وَالتَّاءُ السَّاكِنَةُ فِي «ذَهَبَتْ» عَلَامَةُ التَّأْنِيثِ، وَالْمِيمُ فِي «ذَهَبْتُمْ» عَلَامَةُ جَمْعِ الْمُذَكَّرِ، وَالنُّونُ فِي «ذَهَبْتُنَّ» عَلَامَةُ جَمْعِ الْمُؤَنَّثِ، وَلَيْسَتْ هَذِهِ الْعَلَامَاتُ ضَمَائِرَ.',
    summary = 'يُسْنَدُ الْفِعْلُ الْمَاضِي إِلَى ضَمَائِرِ الْفَاعِلِ، فَيَكُونُ فَاعِلُهُ ضَمِيرًا مُسْتَتِرًا أَوْ بَارِزًا. وَالضَّمِيرُ الْبَارِزُ إِمَّا مُتَّصِلٌ وَإِمَّا مُنْفَصِلٌ، وَالضَّمَائِرُ الْمَذْكُورَةُ فِي هَذَا الدَّرْسِ ضَمَائِرُ رَفْعٍ. وَالتَّاءُ السَّاكِنَةُ فِي «ذَهَبَتْ» عَلَامَةُ التَّأْنِيثِ، وَالْمِيمُ فِي «ذَهَبْتُمْ» عَلَامَةُ جَمْعِ الْمُذَكَّرِ، وَالنُّونُ فِي «ذَهَبْتُنَّ» عَلَامَةُ جَمْعِ الْمُؤَنَّثِ، وَلَيْسَتْ هَذِهِ الْعَلَامَاتُ ضَمَائِرَ.',
    content = $html$<div class="rule-study">
<div class="rule-study-card"><span class="rule-card-kicker">Полная схема двух шархов</span><span class="rule-main-ar" dir="rtl" lang="ar">يُسْنَدُ <span class="ar-tone-verb">الْفِعْلُ الْمَاضِي</span> إِلَى <span class="ar-tone-subject">ضَمَائِرِ الْفَاعِلِ</span>.</span><p class="rule-study-text">Глагол прошедшего времени присоединяется к местоимениям исполнителя. В таблице отдельно показаны лицо, род, число, форма глагола и то, что является исполнителем внутри глагольной формы.</p></div>
<div class="rule-study-card"><span class="rule-card-kicker">Все формы таблицы страницы 20</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">رُتْبَةُ الضَّمِيرِ</span><span class="rule-table-ru">лицо, род и число</span></th><th><span class="rule-table-ar">الضَّمِيرُ الْمُنْفَصِلُ</span><span class="rule-table-ru">раздельное местоимение</span></th><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример и перевод</span></th><th><span class="rule-table-ar">الْفَاعِلُ</span><span class="rule-table-ru">исполнитель в форме глагола</span></th></tr></thead><tbody>
<tr><td><span class="rule-table-ar ar-tone-structure">الْغَائِبُ الْمُذَكَّرُ الْمُفْرَدُ</span><span class="rule-table-ru">3-е лицо, м. р., ед. ч.</span></td><td><span class="rule-table-ar ar-tone-subject">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">حَامِدٌ</span> <span class="ar-tone-verb">ذَهَبَ</span></span><span class="rule-table-ru">Хамид ушёл.</span></td><td><span class="rule-table-ar ar-tone-subject">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هُوَ»</span><span class="rule-table-ru">скрытое местоимение «он»</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-structure">الْغَائِبُ الْمُذَكَّرُ الْجَمْعُ</span><span class="rule-table-ru">3-е лицо, м. р., мн. ч.</span></td><td><span class="rule-table-ar ar-tone-subject">هُمْ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">الطُّلَّابُ</span> <span class="ar-tone-verb">ذَهَبُوا</span></span><span class="rule-table-ru">Студенты ушли.</span></td><td><span class="rule-table-ar ar-tone-subject">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">вау мужского множественного</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-structure">الْغَائِبُ الْمُؤَنَّثُ الْمُفْرَدُ</span><span class="rule-table-ru">3-е лицо, ж. р., ед. ч.</span></td><td><span class="rule-table-ar ar-tone-subject">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">آمِنَةُ</span> <span class="ar-tone-verb">ذَهَبَتْ</span></span><span class="rule-table-ru">Амина ушла.</span></td><td><span class="rule-table-ar ar-tone-subject">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هِيَ»</span><span class="rule-table-ru">скрытое местоимение «она»</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-structure">الْغَائِبُ الْمُؤَنَّثُ الْجَمْعُ</span><span class="rule-table-ru">3-е лицо, ж. р., мн. ч.</span></td><td><span class="rule-table-ar ar-tone-subject">هُنَّ</span><span class="rule-table-ru">они, женщины</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">الطَّالِبَاتُ</span> <span class="ar-tone-verb">ذَهَبْنَ</span></span><span class="rule-table-ru">Студентки ушли.</span></td><td><span class="rule-table-ar ar-tone-subject">نُونُ النِّسْوَةِ</span><span class="rule-table-ru">нун женского множественного</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-structure">الْمُخَاطَبُ الْمُذَكَّرُ الْمُفْرَدُ</span><span class="rule-table-ru">2-е лицо, м. р., ед. ч.</span></td><td><span class="rule-table-ar ar-tone-subject">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">أَنْتَ</span> <span class="ar-tone-verb">ذَهَبْتَ</span></span><span class="rule-table-ru">Ты ушёл.</span></td><td><span class="rule-table-ar ar-tone-subject">تَاءُ الْفَاعِلِ «تَ»</span><span class="rule-table-ru">та исполнителя с фатхой</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-structure">الْمُخَاطَبُ الْمُذَكَّرُ الْجَمْعُ</span><span class="rule-table-ru">2-е лицо, м. р., мн. ч.</span></td><td><span class="rule-table-ar ar-tone-subject">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">أَنْتُمْ</span> <span class="ar-tone-verb">ذَهَبْتُمْ</span></span><span class="rule-table-ru">Вы ушли.</span></td><td><span class="rule-table-ar ar-tone-subject">تَاءُ الْفَاعِلِ «تُ»</span><span class="rule-table-ru">та исполнителя с даммой</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-structure">الْمُخَاطَبُ الْمُؤَنَّثُ الْمُفْرَدُ</span><span class="rule-table-ru">2-е лицо, ж. р., ед. ч.</span></td><td><span class="rule-table-ar ar-tone-subject">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">أَنْتِ</span> <span class="ar-tone-verb">ذَهَبْتِ</span></span><span class="rule-table-ru">Ты ушла.</span></td><td><span class="rule-table-ar ar-tone-subject">تَاءُ الْفَاعِلِ «تِ»</span><span class="rule-table-ru">та исполнителя с касрой</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-structure">الْمُخَاطَبُ الْمُؤَنَّثُ الْجَمْعُ</span><span class="rule-table-ru">2-е лицо, ж. р., мн. ч.</span></td><td><span class="rule-table-ar ar-tone-subject">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">أَنْتُنَّ</span> <span class="ar-tone-verb">ذَهَبْتُنَّ</span></span><span class="rule-table-ru">Вы ушли.</span></td><td><span class="rule-table-ar ar-tone-subject">تَاءُ الْفَاعِلِ «تُ»</span><span class="rule-table-ru">та исполнителя с даммой</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-structure">الْمُتَكَلِّمُ الْمُفْرَدُ</span><span class="rule-table-ru">1-е лицо, ед. ч.</span></td><td><span class="rule-table-ar ar-tone-subject">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">أَنَا</span> <span class="ar-tone-verb">ذَهَبْتُ</span></span><span class="rule-table-ru">Я ушёл / ушла.</span></td><td><span class="rule-table-ar ar-tone-subject">تَاءُ الْفَاعِلِ «تُ»</span><span class="rule-table-ru">та исполнителя с даммой</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-structure">الْمُتَكَلِّمُ الْجَمْعُ</span><span class="rule-table-ru">1-е лицо, мн. ч.</span></td><td><span class="rule-table-ar ar-tone-subject">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">نَحْنُ</span> <span class="ar-tone-verb">ذَهَبْنَا</span></span><span class="rule-table-ru">Мы ушли.</span></td><td><span class="rule-table-ar ar-tone-subject">الضَّمِيرُ «نَا»</span><span class="rule-table-ru">слитное местоимение «на»</span></td></tr>
</tbody></table></div></div>
<div class="rule-study-card"><span class="rule-card-kicker">Не путайте местоимение и показатель формы</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">ذَهَبَتْ</span></span><span class="rule-example-ru"><b>تْ</b> — показатель женского рода, а не местоимение: «она ушла».</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">ذَهَبْتُمْ</span></span><span class="rule-example-ru"><b>مْ</b> — показатель мужского множественного, а не местоимение: «вы, мужчины, ушли».</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">ذَهَبْتُنَّ</span></span><span class="rule-example-ru"><b>نَّ</b> — показатель женского множественного, а не местоимение: «вы, женщины, ушли».</span></div></div><div class="rule-check-card"><b>Сравнение двух форм.</b> В <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">ذَهَبْنَ</span> буква <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">نَ</span> является местоимением-исполнителем <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span>; в <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">ذَهَبْتُنَّ</span> исполнителем является <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">تَاءُ الْفَاعِلِ</span>, а <span class="ar-inline" dir="rtl" lang="ar">نَّ</span> только показывает женское множественное число.</div></div>
<div class="rule-study-card"><span class="rule-card-kicker">Видимость местоимения</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">النَّوْعُ</span><span class="rule-table-ru">вид</span></th><th><span class="rule-table-ar">الْمَعْنَى</span><span class="rule-table-ru">значение</span></th><th><span class="rule-table-ar">الْأَمْثِلَةُ</span><span class="rule-table-ru">примеры и перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-structure">ضَمِيرٌ مُسْتَتِرٌ</span><span class="rule-table-ru">скрытое местоимение</span></td><td><span class="rule-table-ru">Не произносится и не пишется отдельно, но подразумевается в глаголе.</span></td><td><span class="rule-table-ar"><span class="ar-tone-subject">الطَّالِبُ</span> <span class="ar-tone-verb">خَرَجَ</span></span><span class="rule-table-ru">Студент вышел; в глаголе скрыто «он».</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure">ضَمِيرٌ بَارِزٌ</span><span class="rule-table-ru">явно выраженное местоимение</span></td><td><span class="rule-table-ru">Имеет видимое и произносимое выражение.</span></td><td><span class="rule-table-ar ar-tone-verb">خَرَجْتُ، خَرَجُوا، خَرَجْنَ، خَرَجْنَا</span><span class="rule-table-ru">я вышел; они, мужчины, вышли; они, женщины, вышли; мы вышли.</span></td></tr></tbody></table></div></div>
<div class="rule-study-card"><span class="rule-card-kicker">Способ написания местоимения</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">النَّوْعُ</span><span class="rule-table-ru">вид</span></th><th><span class="rule-table-ar">تَعْرِيفُهُ</span><span class="rule-table-ru">определение</span></th><th><span class="rule-table-ar">الْأَمْثِلَةُ وَمَعَانِيهَا</span><span class="rule-table-ru">примеры и русские значения</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-structure">ضَمِيرٌ مُتَّصِلٌ</span><span class="rule-table-ru">слитное местоимение</span></td><td><span class="rule-table-ru">Пишется и произносится слитно с глаголом.</span></td><td><span class="rule-table-ar ar-tone-subject">تَاءُ الْفَاعِلِ، نَا، نُونُ النِّسْوَةِ، وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">та исполнителя; «на»; нун женского множественного; вау мужского множественного.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure">ضَمِيرٌ مُنْفَصِلٌ</span><span class="rule-table-ru">раздельное местоимение</span></td><td><span class="rule-table-ru">Пишется и произносится отдельно от глагола.</span></td><td><span class="rule-table-ar ar-tone-subject">أَنَا، نَحْنُ، أَنْتَ، أَنْتُمْ، أَنْتُنَّ، هُوَ، هِيَ</span><span class="rule-table-ru">я; мы; ты, мужчина; вы, мужчины; вы, женщины; он; она.</span></td></tr></tbody></table></div><p class="rule-study-text"><span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">ضَمَائِرُ رَفْعٍ</span> — местоимения именительного падежа. Все местоимения, перечисленные в таблице и заключительном списке шарха, относятся к этой группе.</p></div>
</div>$html$,
    sort_order = 1,
    rule_kind = 'rule'
  where id = review_rule_id;

  delete from public.rule_sources
  where rule_id = review_rule_id
    and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf';

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (review_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الدَّرْسُ الثَّامِنُ
إِسْنَادُ الْفِعْلِ الْمَاضِي إِلَى الضَّمَائِرِ

رُتَبُ الضَّمَائِرِ | الْمُذَكَّرُ وَالْمُؤَنَّثُ | ضَمَائِرُ الْفَاعِلِ الْمُفْرَدِ | الْفَاعِلُ | ضَمَائِرُ الْفَاعِلِ الْجَمْعِ | الْفَاعِلُ
الْغَائِبُ | الْمُذَكَّرُ | حامدٌ ذهبَ | ضميرٌ مستترٌ (هو) | الطلابُ ذهبوا | واوُ الجماعةِ
الْغَائِبُ | الْمُؤَنَّثُ | آمنةُ ذهبتْ | ضميرٌ مستترٌ (هي) | الطالباتُ ذهبنَ | نونُ النسوةِ
الْمُخَاطَبُ | الْمُذَكَّرُ | أنتَ ذهبتَ | التاءُ (تَ) | أنتم ذهبتم | التاءُ (تُمْ)
الْمُخَاطَبُ | الْمُؤَنَّثُ | أنتِ ذهبتِ | التاءُ (تِ) | أنتنَّ ذهبتنَّ | التاءُ (تُنَّ)
الْمُتَكَلِّمُ | الْمُذَكَّرُ وَالْمُؤَنَّثُ | أنا ذهبتُ | التاءُ (تُ) | نحن ذهبنا | نا$source$, 20, 20, 2),
    (review_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$ذهبتْ: التاءُ الساكنةُ علامةُ التأنيثِ، وليست ضميراً.
ذهبتم: الميمُ علامةُ جمعِ المذكّرِ، وليست ضميراً.
ذهبتنَّ: النونُ علامةُ جمعِ المؤنثِ، وليست ضميراً.$source$, 20, 20, 3),
    (review_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$تنقسم الضمائر إلى: ١- ضميرٌ مستترٌ، نحو: الطالب خرج. (خَفِيٌّ لا تراهُ).
٢- ضميرٌ بارزٌ، نحو: خرجتُ، خرجوا، خرجنَ، خرجنا. (ظَاهِرٌ تراهُ).

وتنقسم الضمائر أيضاً إلى: ١- ضمائرٌ متصلةٌ: هي التي تُكْتَبُ وتُنْطَقُ متصلةً بالفعل، كالضمائر التي وقعت فاعلاً في الجدول السابق.
٢- ضمائرٌ منفصلةٌ: هي التي تُكْتَبُ وتُنْطَقُ وحدها منفصلةً من الفعل، نحو: أنا، نحن، أنت، أنتم، أنتنَّ.

* الضمائر المذكورة في الجدول (التاء، نا، نون النسوة، واو الجماعة، أنا، نحن، أنت، أنتم، أنتن، هو، هي) ضمائرُ رفعٍ.$source$, 20, 20, 4);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '8'
      and coalesce(rule_ar, '') = ''
  ) then
    raise exception 'Book 2 lesson 8 contains an empty rule_ar';
  end if;

  if exists (
    select 1 from public.rules r
    where r.course_name = 'Мединский курс (Том 2)'
      and r.lesson_number = '8'
      and not exists (select 1 from public.rule_sources s where s.rule_id = r.id)
  ) then
    raise exception 'Book 2 lesson 8 contains a rule without provenance';
  end if;
end;
$migration$;

commit;
