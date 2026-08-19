-- Preserve the complete public Russian rendering of Book 1 lesson 12.
-- Controlling source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 17-18.
-- Hamzat al-wasl in the connected-reading scheme is stored without the old stray fatha.

begin;

do $$
declare v_count integer;
begin
  select count(*) into v_count from public.rules
  where course_name = 'Мединский курс (Том 1)' and lesson_number = '12' and id in (1513,1514,1515,1516,1517);
  if v_count <> 5 then
    raise exception 'Expected guarded Book 1 lesson 12 rules 1513-1517, found %', v_count;
  end if;
end;
$$;

update public.rules
set content = case id
when 1513 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 17</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">كَافُ الْمُخَاطَبِ: ضَمِيرٌ لِلْمُخَاطَبِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">كَافُ الْمُخَاطَبِ</span> — каф собеседника; это местоимение собеседника.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">ضَمِيرُ الْمُخَاطَبِ الْمُذَكَّرِ</span> (местоимение собеседника мужского рода)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَا اسْمُكَ؟ كَيْفَ حَالُكَ يَا أَبِي؟ بَيْتُكَ جَمِيلٌ.</span><span class="rule-example-ru">Как тебя зовут? Как твои дела, о мой отец? Твой дом красивый.</span></div>
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَلَكَ هَذَا الْقَلَمُ يَا خَالِدُ؟</span><span class="rule-example-ru">Тебе принадлежит эта ручка, о Халид?</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">ضَمِيرُ الْمُخَاطَبِ الْمُؤَنَّثِ</span> (местоимение собеседницы)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَا اسْمُكِ؟ كَيْفَ حَالُكِ يَا أُمِّي؟ بَيْتُكِ جَمِيلٌ.</span><span class="rule-example-ru">Как тебя зовут? Как твои дела, о моя мать? Твой дом красивый.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَلَكِ هَذَا الْقَلَمُ يَا فَاطِمَةُ؟</span><span class="rule-example-ru">Тебе принадлежит эта ручка, о Фатима?</span></div>
  </div></div>
</div>
$html$
when 1516 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 17</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">أَنَا، وَأَنْتَ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">أَنَا</span> — «я»; <span dir="rtl" lang="ar">أَنْتَ</span> — «ты» при обращении к мужчине.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Определения автора</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Местоимение</th><th>Арабское определение</th><th>Полный русский перевод</th></tr></thead><tbody>
    <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты</span></td><td dir="rtl" lang="ar">أَنْتَ: ضَمِيرٌ لِلْمُخَاطَبِ.</td><td><span dir="rtl" lang="ar">أَنْتَ</span> — местоимение собеседника.</td></tr>
    <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span><span class="rule-table-ru">я</span></td><td dir="rtl" lang="ar">أَنَا: ضَمِيرٌ لِلْمُتَكَلِّمِ.</td><td><span dir="rtl" lang="ar">أَنَا</span> — местоимение говорящего.</td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْمُتَكَلِّمُ الْمُذَكَّرُ وَالْمُؤَنَّثُ: أَنَا</span> (говорящий мужского и женского рода: «я»)</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا طَالِبٌ. أَنَا طَالِبَةٌ. أَنَا مُحَمَّدٌ. أَنَا خَدِيجَةُ.</span><span class="rule-example-ru">Я студент. Я студентка. Я — Мухаммад. Я — Хадиджа.</span></div></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْمُخَاطَبُ الْمُذَكَّرُ: أَنْتَ</span> (собеседник мужского рода: «ты»)</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتَ مُهَنْدِسٌ. أَنْتَ طَبِيبٌ. مَنْ أَنْتَ؟ أَأَنْتَ مُدَرِّسٌ؟</span><span class="rule-example-ru">Ты инженер. Ты врач. Кто ты? Ты преподаватель?</span></div></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْمُخَاطَبُ الْمُؤَنَّثُ: أَنْتِ</span> (собеседница: «ты»)</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتِ مُهَنْدِسَةٌ. أَنْتِ طَبِيبَةٌ. مَنْ أَنْتِ؟ أَأَنْتِ مُدَرِّسَةٌ؟</span><span class="rule-example-ru">Ты инженер. Ты врач. Кто ты? Ты преподавательница?</span></div></div></div>
</div>
$html$
when 1514 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 17</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">تَأْنِيثُ الْفَاعِلِ. الْفَاعِلُ: هُوَ الَّذِي يَقَعُ بَعْدَ الْفِعْلِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Женский род исполнителя действия. <span dir="rtl" lang="ar">الْفَاعِلُ</span> (исполнитель действия, подлежащее при глаголе) — это тот, кто стоит после глагола.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Обе схемы автора</span><div class="tbl-wrap"><table><thead><tr><th>Предложение</th><th>Глагол</th><th><span dir="rtl" lang="ar">فَاعِلٌ</span><br>исполнитель действия</th><th>Полный перевод</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">خَرَجَ مُحَمَّدٌ.</td><td dir="rtl" lang="ar">خَرَجَ: فِعْلٌ</td><td dir="rtl" lang="ar">مُحَمَّدٌ: فَاعِلٌ</td><td>Мухаммад вышел.</td></tr>
    <tr><td dir="rtl" lang="ar">خَرَجَتْ آمِنَةُ.</td><td dir="rtl" lang="ar">خَرَجَتْ: فِعْلٌ</td><td dir="rtl" lang="ar">آمِنَةُ: فَاعِلٌ</td><td>Амина вышла.</td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все остальные примеры автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبَ سَعِيدٌ. خَرَجَ أَخِي. خَرَجَتْ أُمِّي.</span><span class="rule-example-ru">Саид ушёл. Мой брат вышел. Моя мать вышла.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبَ الطَّالِبُ. ذَهَبَتِ الطَّالِبَةُ.</span><span class="rule-example-ru">Студент ушёл. Студентка ушла.</span></div>
  </div></div>
</div>
$html$
when 1515 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 18</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">الَّذِي، الَّتِي.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Относительные имена <span dir="rtl" lang="ar">الَّذِي</span> — «который» и <span dir="rtl" lang="ar">الَّتِي</span> — «которая».</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Полные определения автора</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Форма</th><th>Арабское определение</th><th>Полный русский перевод</th></tr></thead><tbody>
    <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الَّذِي</span><span class="rule-table-ru">который</span></td><td dir="rtl" lang="ar">الَّذِي: اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ.</td><td>Относительное имя для единственного числа мужского рода, разумного и неразумного.</td></tr>
    <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الَّتِي</span><span class="rule-table-ru">которая</span></td><td dir="rtl" lang="ar">الَّتِي: اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُؤَنَّثِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ.</td><td>Относительное имя для единственного числа женского рода, разумного и неразумного.</td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الِاسْمُ الْمَوْصُولُ الْمُذَكَّرُ الْعَاقِلُ</span> (мужской род, разумное)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الْفَتَى الَّذِي خَرَجَ الْآنَ ابْنُ عَمِّي.</span><span class="rule-example-ru">Юноша, который сейчас вышел, — сын моего дяди по отцу.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنِ الرَّجُلُ الَّذِي جَلَسَ فِي الْحَدِيقَةِ؟</span><span class="rule-example-ru">Кто тот мужчина, который сидел в саду?</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الِاسْمُ الْمَوْصُولُ الْمُذَكَّرُ غَيْرُ الْعَاقِلِ</span> (мужской род, неразумное)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">الْقَلَمُ الَّذِي مَعَكَ مَكْسُورٌ.</span><span class="rule-example-ru">Ручка, которая у тебя, сломана.</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنِ الْكِتَابُ الَّذِي عَلَى الْمَكْتَبِ؟</span><span class="rule-example-ru">Кому принадлежит книга, которая находится на столе?</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الِاسْمُ الْمَوْصُولُ الْمُؤَنَّثُ الْعَاقِلُ</span> (женский род, разумное)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الْفَتَاةُ الَّتِي خَرَجَتِ الْآنَ بِنْتُ عَمِّي.</span><span class="rule-example-ru">Девушка, которая сейчас вышла, — дочь моего дяди по отцу.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنِ الْمُدَرِّسَةُ الَّتِي جَلَسَتْ فِي الْحَدِيقَةِ؟</span><span class="rule-example-ru">Кто та преподавательница, которая сидела в саду?</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الِاسْمُ الْمَوْصُولُ الْمُؤَنَّثُ غَيْرُ الْعَاقِلِ</span> (женский род, неразумное)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">السَّاعَةُ الَّتِي مَعَكَ مَكْسُورَةٌ.</span><span class="rule-example-ru">Часы, которые у тебя, сломаны.</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنِ الْحَقِيبَةُ الَّتِي عَلَى الْمَكْتَبِ؟</span><span class="rule-example-ru">Кому принадлежит сумка, которая находится на столе?</span></div>
  </div></div>
</div>
$html$
when 1517 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 18</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">ذَهَبَتِ الطَّالِبَةُ: أَصْلُهُ: ذَهَبَتْ الطَّالِبَةُ ← ذَهَبَتْ + الْـ ← ذَهَبَتِ الْـ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> В предложении «студентка ушла» исходная форма глагола — <span dir="rtl" lang="ar">ذَهَبَتْ</span>. При соединении с артиклем <span dir="rtl" lang="ar">الْـ</span> неподвижная <span dir="rtl" lang="ar">تْ</span> получает касру и произносится <span dir="rtl" lang="ar">تِ</span>. Хамзат аль-васл при слитном чтении не произносится.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Пример внутри относительного предложения</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الْفَتَاةُ الَّتِي خَرَجَتِ الْآنَ بِنْتُ عَمِّي.</span><span class="rule-example-ru">Девушка, которая сейчас вышла, — дочь моего дяди по отцу.</span></div></div></div>
</div>
$html$
end
where course_name = 'Мединский курс (Том 1)' and lesson_number = '12' and id in (1513,1514,1515,1516,1517);

update public.rule_sources
set source_text = $source$ذَهَبَتِ الطَّالِبَةُ : أَصْلُهُ : ذَهَبَتْ الطَّالِبَةُ ← ذَهَبَتْ + الْ ذَهَبَتِ الْ .$source$
where rule_id = 1517 and source_document = 'Sharkh_na_1_tom_Med_kursa.pdf'
  and source_page_from = 18 and source_page_to = 18 and sort_order = 1;

do $$
begin
  if (select count(*) from public.rules where id in (1513,1514,1515,1516,1517) and content like '%Полный текст шарха · страница%') <> 5 then
    raise exception 'Book 1 lesson 12 full-sharh markers are incomplete';
  end if;
  if exists (select 1 from public.rules where id = 1517 and content like '%اَلْ%') then
    raise exception 'Book 1 lesson 12 still contains the stray fatha over hamzat al-wasl';
  end if;
  if not exists (select 1 from public.rules where id = 1515 and content like '%لِمَنِ الْحَقِيبَةُ الَّتِي عَلَى الْمَكْتَبِ؟%') then
    raise exception 'Book 1 lesson 12 relative-pronoun examples are incomplete';
  end if;
end;
$$;

commit;
