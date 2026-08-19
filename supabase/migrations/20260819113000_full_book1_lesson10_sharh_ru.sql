-- Preserve the complete public Russian rendering of Book 1 lesson 10.
-- Controlling source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 14-15.
-- Also correct the previously mistranscribed invalid مَعَ forms in source_text.

begin;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '10'
    and id in (1502,1503,1504,1507);
  if v_count <> 4 then
    raise exception 'Expected guarded Book 1 lesson 10 rules 1502, 1503, 1504 and 1507, found %', v_count;
  end if;
end;
$$;

update public.rules
set
  rule_ar = case id
    when 1502 then 'الضَّمَائِرُ ثَلَاثَةٌ: ضَمِيرُ الْمُتَكَلِّمِ، وَضَمِيرُ الْمُخَاطَبِ، وَضَمِيرُ الْغَائِبِ.'
    when 1504 then 'تُسْتَعْمَلُ «عِنْدِي» لِغَيْرِ الْعَاقِلِ، وَتُسْتَعْمَلُ «لِي» لِلْعَاقِلِ.'
    when 1507 then '«مَعَ» ظَرْفُ مَكَانٍ، وَهُوَ مُضَافٌ، وَالِاسْمُ الَّذِي بَعْدَهُ مُضَافٌ إِلَيْهِ مَجْرُورٌ بِالْكَسْرَةِ.'
    when 1503 then 'الْعَلَمُ الْمُذَكَّرُ الْمَخْتُومُ بِتَاءِ التَّأْنِيثِ لَا يُنَوَّنُ.'
  end,
  summary = case id
    when 1502 then 'الضَّمَائِرُ ثَلَاثَةٌ: ضَمِيرُ الْمُتَكَلِّمِ، وَضَمِيرُ الْمُخَاطَبِ، وَضَمِيرُ الْغَائِبِ.'
    when 1504 then 'تُسْتَعْمَلُ «عِنْدِي» لِغَيْرِ الْعَاقِلِ، وَتُسْتَعْمَلُ «لِي» لِلْعَاقِلِ.'
    when 1507 then '«مَعَ» ظَرْفُ مَكَانٍ، وَهُوَ مُضَافٌ، وَالِاسْمُ الَّذِي بَعْدَهُ مُضَافٌ إِلَيْهِ مَجْرُورٌ بِالْكَسْرَةِ.'
    when 1503 then 'الْعَلَمُ الْمُذَكَّرُ الْمَخْتُومُ بِتَاءِ التَّأْنِيثِ لَا يُنَوَّنُ.'
  end,
  content = case id
when 1502 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 14</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">الضَّمَائِرُ ثَلَاثَةٌ، هِيَ: ١- الْمُتَكَلِّمُ: أَنَا، بَيْتِي. ٢- الْمُخَاطَبُ: أَنْتَ، بَيْتُكَ. ٣- الْغَائِبُ: هُوَ، بَيْتُهُ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Местоимения делятся на три разряда: 1) <span dir="rtl" lang="ar">الْمُتَكَلِّمُ</span> — говорящий: <span dir="rtl" lang="ar">أَنَا</span> — «я», <span dir="rtl" lang="ar">بَيْتِي</span> — «мой дом»; 2) <span dir="rtl" lang="ar">الْمُخَاطَبُ</span> — собеседник: <span dir="rtl" lang="ar">أَنْتَ</span> — «ты», <span dir="rtl" lang="ar">بَيْتُكَ</span> — «твой дом»; 3) <span dir="rtl" lang="ar">الْغَائِبُ</span> — отсутствующий: <span dir="rtl" lang="ar">هُوَ</span> — «он», <span dir="rtl" lang="ar">بَيْتُهُ</span> — «его дом».</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْمُتَكَلِّمُ الْمُذَكَّرُ وَالْمُؤَنَّثُ</span> (говорящий мужского и женского рода)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتِي. اِسْمِي مُحَمَّدٌ. اِسْمِي فَاطِمَةُ.</span><span class="rule-example-ru">Это мой дом. Моё имя — Мухаммад. Моё имя — Фатима.</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبِي وَأُمِّي فِي الْبَيْتِ. عِنْدِي قَلَمٌ. لِي أَخٌ.</span><span class="rule-example-ru">Мои отец и мать находятся в доме. У меня есть ручка. У меня есть брат.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْمُخَاطَبُ الْمُذَكَّرُ</span> (собеседник мужского рода)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتُكَ. مَا اسْمُكَ؟ سَيَّارَتُكَ جَمِيلَةٌ.</span><span class="rule-example-ru">Это твой дом. Как тебя зовут? Твоя машина красивая.</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبُوكَ وَأُمُّكَ فِي الْبَيْتِ. أَعِنْدَكَ قَلَمٌ؟ أَلَكَ أَخٌ؟</span><span class="rule-example-ru">Твои отец и мать находятся в доме. У тебя есть ручка? У тебя есть брат?</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْمُخَاطَبُ الْمُؤَنَّثُ</span> (собеседница)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتُكِ. مَا اسْمُكِ؟ سَيَّارَتُكِ جَمِيلَةٌ.</span><span class="rule-example-ru">Это твой дом. Как тебя зовут? Твоя машина красивая.</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبُوكِ وَأُمُّكِ فِي الْبَيْتِ. أَعِنْدَكِ قَلَمٌ؟ أَلَكِ أَخٌ؟</span><span class="rule-example-ru">Твои отец и мать находятся в доме. У тебя есть ручка? У тебя есть брат?</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْغَائِبُ الْمُذَكَّرُ</span> (отсутствующий мужчина)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتُهُ. مَا اسْمُهُ؟ سَيَّارَتُهُ جَمِيلَةٌ.</span><span class="rule-example-ru">Это его дом. Как его зовут? Его машина красивая.</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبُوهُ وَأُمُّهُ فِي الْبَيْتِ. أَعِنْدَهُ قَلَمٌ؟ أَلَهُ أَخٌ؟</span><span class="rule-example-ru">Его отец и мать находятся в доме. У него есть ручка? У него есть брат?</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْغَائِبُ الْمُؤَنَّثُ</span> (отсутствующая женщина)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتُهَا. مَا اسْمُهَا؟ سَيَّارَتُهَا جَمِيلَةٌ.</span><span class="rule-example-ru">Это её дом. Как её зовут? Её машина красивая.</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبُوهَا وَأُمُّهَا فِي الْبَيْتِ. أَعِنْدَهَا قَلَمٌ؟ أَلَهَا أَخٌ؟</span><span class="rule-example-ru">Её отец и мать находятся в доме. У неё есть ручка? У неё есть брат?</span></div>
  </div></div>
</div>
$html$
when 1504 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 14</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">عِنْدِي، لِي.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Две конструкции со значением обладания: <span dir="rtl" lang="ar">عِنْدِي</span> и <span dir="rtl" lang="ar">لِي</span>.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">عِنْدِي: لِغَيْرِ الْعَاقِلِ</span> (для неразумного)</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">عِنْدِي كِتَابٌ. عِنْدِي سَاعَةٌ. عِنْدِي دَرَّاجَةٌ.</span><span class="rule-example-ru">У меня есть книга. У меня есть часы. У меня есть велосипед.</span></div></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">لِي: لِلْعَاقِلِ</span> (для разумного)</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">لِي أُخْتٌ وَاحِدَةٌ. لِي اِبْنٌ وَبِنْتٌ. لِي أُمٌّ وَأَبٌ.</span><span class="rule-example-ru">У меня одна сестра. У меня есть сын и дочь. У меня есть мать и отец.</span></div></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все четыре формы, отмеченные автором</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Верная форма ✓</th><th>Неверная форма ✕</th></tr></thead><tbody>
    <tr><td><span class="rule-table-ar rule-table-valid" dir="rtl" lang="ar">أَلَكَ أَخٌ؟ ✓</span><span class="rule-table-ru">У тебя есть брат?</span></td><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">أَعِنْدَكَ أَخٌ؟ ✕</span><span class="rule-table-ru">Неверная форма для этого примера.</span></td></tr>
    <tr><td><span class="rule-table-ar rule-table-valid" dir="rtl" lang="ar">أَعِنْدَكَ كِتَابٌ؟ ✓</span><span class="rule-table-ru">У тебя есть книга?</span></td><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">أَلَكَ كِتَابٌ؟ ✕</span><span class="rule-table-ru">Неверная форма для этого примера.</span></td></tr>
  </tbody></table></div></div>
</div>
$html$
when 1507 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 15</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">مَعَ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">مَعَ</span> — «вместе с».</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">خَرَجَ حَامِدٌ مَعَ خَالِدٍ.</span><span class="rule-example-ru">Хамид вышел вместе с Халидом.</span></div>
    <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبَ الطَّبِيبُ مَعَ الْمُهَنْدِسِ.</span><span class="rule-example-ru">Врач пошёл вместе с инженером.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">عَائِشَةُ مَعَهَا زَوْجُهَا.</span><span class="rule-example-ru">С Аишей — её муж.</span></div>
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ مَعَكَ يَا عَلِيُّ؟ مَعِي زَمِيلِي.</span><span class="rule-example-ru">Кто с тобой, о Али? Со мной мой товарищ.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все сопоставления автора</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Верная форма ✓</th><th>Неверная форма ✕</th></tr></thead><tbody>
    <tr><td><span class="rule-table-ar rule-table-valid" dir="rtl" lang="ar">مَعَ خَالِدٍ ✓</span><span class="rule-table-ru">Вместе с Халидом.</span></td><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">مَعُ خَالِدٍ ✕</span><span class="rule-table-ru">Неверная форма того же сочетания.</span></td></tr>
    <tr><td><span class="rule-table-ar rule-table-valid" dir="rtl" lang="ar">عَائِشَةُ مَعَهَا زَوْجُهَا ✓</span><span class="rule-table-ru">С Аишей — её муж.</span></td><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">عَائِشَةُ مَعُهَا زَوْجُهَا ✕</span><span class="rule-table-ru">Неверная форма того же предложения.</span></td></tr>
    <tr><td><span class="rule-table-ar rule-table-valid" dir="rtl" lang="ar">مَنْ مَعَكَ يَا عَلِيُّ؟ مَعِي زَمِيلِي. ✓</span><span class="rule-table-ru">Кто с тобой, о Али? Со мной мой товарищ.</span></td><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">مَنْ مَعُكَ يَا عَلِيُّ؟ مَعُكَ زَمِيلِي. ✕</span><span class="rule-table-ru">Неверная форма того же вопроса и ответа.</span></td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Полный разбор автора</span><div class="tbl-wrap"><table><thead><tr><th>Сочетание</th><th>Разбор</th><th>Русский перевод термина</th></tr></thead><tbody>
    <tr><td rowspan="2" dir="rtl" lang="ar">مَعَ خَالِدٍ</td><td dir="rtl" lang="ar">مَعَ: مُضَافٌ</td><td><span dir="rtl" lang="ar">مُضَافٌ</span> — первый член идафы.</td></tr>
    <tr><td dir="rtl" lang="ar">خَالِدٍ: مُضَافٌ إِلَيْهِ</td><td><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span> — второй член идафы.</td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card">
    <span class="rule-card-kicker">Заключительное правило автора</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">مَعَ: ظَرْفُ مَكَانٍ، الِاسْمُ الَّذِي بَعْدَهُ مَجْرُورٌ بِالْكَسْرَةِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">مَعَ</span> — обстоятельство места; имя, стоящее после него, находится в родительном падеже, признаком которого является касра.</p>
  </div>
</div>
$html$
when 1503 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 15</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">الْعَلَمُ الْمُذَكَّرُ الْمَخْتُومُ بِتَاءِ التَّأْنِيثِ لَا يُنَوَّنُ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Мужское имя собственное, оканчивающееся на <span dir="rtl" lang="ar">تَاءُ التَّأْنِيثِ</span> (показатель женского рода <span dir="rtl" lang="ar">ة</span>), не принимает танвин.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все сопоставления автора</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Мужское имя с танвином</th><th>Мужское имя на <span dir="rtl" lang="ar">ة</span> без танвина</th></tr></thead><tbody>
    <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">مُحَمَّدٌ</span><span class="rule-table-ru">Мухаммад</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَمْزَةُ</span><span class="rule-table-ru">Хамза</span></td></tr>
    <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">خَالِدٌ</span><span class="rule-table-ru">Халид</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">طَلْحَةُ</span><span class="rule-table-ru">Тальха</span></td></tr>
    <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">مَحْمُودٌ</span><span class="rule-table-ru">Махмуд</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مُعَاوِيَةُ</span><span class="rule-table-ru">Муавия</span></td></tr>
    <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">حُسَيْنٌ</span><span class="rule-table-ru">Хусейн</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أُسَامَةُ</span><span class="rule-table-ru">Усама</span></td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Обе проверки окончания</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">حَمْزَةُ ✓　حَمْزَةٌ ✕</span><span class="rule-example-ru"><span dir="rtl" lang="ar">حَمْزَةُ</span> — верно; <span dir="rtl" lang="ar">حَمْزَةٌ</span> с танвином — неверно.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">طَلْحَةُ ✓　طَلْحَةٌ ✕</span><span class="rule-example-ru"><span dir="rtl" lang="ar">طَلْحَةُ</span> — верно; <span dir="rtl" lang="ar">طَلْحَةٌ</span> с танвином — неверно.</span></div>
  </div></div>
</div>
$html$
  end
where course_name = 'Мединский курс (Том 1)'
  and lesson_number = '10'
  and id in (1502,1503,1504,1507);

update public.rule_sources
set source_text = $source$مَعَ خَالِدٍ ✓ مَعُ خَالِدٍ ✕
عَائِشَةُ مَعَهَا زَوْجُهَا ✓ عَائِشَةُ مَعُهَا زَوْجُهَا ✕
مَنْ مَعَكَ يَا عَلِيُّ ؟ مَعِي زَمِيلِي ✓ مَنْ مَعُكَ يَا عَلِيُّ ؟ مَعُكَ زَمِيلِي ✕$source$
where rule_id = 1507
  and source_document = 'Sharkh_na_1_tom_Med_kursa.pdf'
  and source_page_from = 15
  and source_page_to = 15
  and sort_order = 2;

do $$
begin
  if (select count(*) from public.rules where id in (1502,1503,1504,1507) and content like '%Полный текст шарха · страница%') <> 4 then
    raise exception 'Book 1 lesson 10 full-sharh markers are incomplete';
  end if;
  if not exists (select 1 from public.rules where id = 1507 and content like '%مَعُ خَالِدٍ ✕%' and content like '%عَائِشَةُ مَعُهَا زَوْجُهَا ✕%' and content like '%مَنْ مَعُكَ يَا عَلِيُّ؟ مَعُكَ زَمِيلِي. ✕%') then
    raise exception 'Book 1 lesson 10 مَعَ contrasts do not match PDF page 15';
  end if;
  if not exists (select 1 from public.rule_sources where rule_id = 1507 and sort_order = 2 and source_text like '%مَعُ خَالِدٍ ✕%' and source_text like '%مَعُهَا زَوْجُهَا ✕%') then
    raise exception 'Book 1 lesson 10 private مَعَ source transcription is not corrected';
  end if;
end;
$$;

commit;
