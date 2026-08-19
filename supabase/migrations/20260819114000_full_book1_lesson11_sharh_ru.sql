-- Preserve the complete public Russian rendering of Book 1 lesson 11.
-- Controlling source: Sharkh_na_1_tom_Med_kursa.pdf, PDF page 16.

begin;

do $$
declare v_count integer;
begin
  select count(*) into v_count from public.rules
  where course_name = 'Мединский курс (Том 1)' and lesson_number = '11' and id in (1509,1510);
  if v_count <> 2 then
    raise exception 'Expected guarded Book 1 lesson 11 rules 1509 and 1510, found %', v_count;
  end if;
end;
$$;

update public.rules
set content = case id
when 1509 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 16</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">فِي + ضَمِيرُ الْغَائِبِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Предлог <span dir="rtl" lang="ar">فِي</span> с местоимением отсутствующего лица.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все определения автора</span><div class="rule-meaning-grid">
    <div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">فِي: حَرْفُ جَرٍّ.</span><span class="rule-term-ru"><span dir="rtl" lang="ar">فِي</span> — предлог родительного падежа.</span></div>
    <div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ الْمُذَكَّرِ: فِيهِ.</span><span class="rule-term-ru">Местоимение отсутствующего лица мужского рода: <span dir="rtl" lang="ar">فِيهِ</span> — «в нём».</span></div>
    <div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ الْمُؤَنَّثِ: فِيهَا.</span><span class="rule-term-ru">Местоимение отсутствующего лица женского рода: <span dir="rtl" lang="ar">فِيهَا</span> — «в ней».</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">فِيهِ</span> (в нём)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">بَيْتِي فِيهِ حَدِيقَةٌ. فَصْلِي فِيهِ طُلَّابٌ.</span><span class="rule-example-ru">В моём доме есть сад. В моём классе есть учащиеся.</span></div>
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَاذَا فِي هَذَا الْبَيْتِ؟ فِيهِ أَثَاثٌ.</span><span class="rule-example-ru">Что находится в этом доме? В нём есть мебель.</span></div>
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ فِي الْمَكْتَبِ؟ مَا فِيهِ أَحَدٌ.</span><span class="rule-example-ru">Кто находится в кабинете? В нём никого нет.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">فِيهَا</span> (в ней)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">حَدِيقَتِي فِيهَا أَزْهَارٌ. غُرْفَتِي فِيهَا نَافِذَةٌ.</span><span class="rule-example-ru">В моём саду есть цветы. В моей комнате есть окно.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَاذَا فِي الْحَقِيبَةِ؟ فِيهَا كُتُبٌ.</span><span class="rule-example-ru">Что находится в сумке? В ней есть книги.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنْ فِي الْمَكْتَبَةِ؟ مَا فِيهَا أَحَدٌ.</span><span class="rule-example-ru">Кто находится в библиотеке? В ней никого нет.</span></div>
  </div></div>
</div>
$html$
when 1510 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 16</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">يَاءُ الْمُتَكَلِّمِ: ضَمِيرٌ لِلْمُتَكَلِّمِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">يَاءُ الْمُتَكَلِّمِ</span> — йа говорящего; это местоимение говорящего.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все формы из шарха и их перевод</span><div class="rule-meaning-grid">
    <div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">بَيْتِي · غُرْفَتِي · حَقِيبَتِي</span><span class="rule-term-ru">мой дом · моя комната · моя сумка</span></div>
    <div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">بَلَدِي · جَامِعَتِي</span><span class="rule-term-ru">моя страна · мой университет</span></div>
    <div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar" dir="rtl" lang="ar">أَبِي · أُمِّي</span><span class="rule-term-ru">мой отец · моя мать</span></div>
    <div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">أَخِي · أُخْتِي</span><span class="rule-term-ru">мой брат · моя сестра</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">بَيْتِي جَمِيلٌ. غُرْفَتِي كَبِيرَةٌ.</span><span class="rule-example-ru">Мой дом красивый. Моя комната большая.</span></div>
    <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أُحِبُّ بَلَدِي. جَامِعَتِي كَبِيرَةٌ.</span><span class="rule-example-ru">Я люблю свою страну. Мой университет большой.</span></div>
    <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أُحِبُّ أَبِي وَأُمِّي. أُحِبُّ أَخِي وَأُخْتِي.</span><span class="rule-example-ru">Я люблю своего отца и свою мать. Я люблю своего брата и свою сестру.</span></div>
  </div></div>
</div>
$html$
end
where course_name = 'Мединский курс (Том 1)' and lesson_number = '11' and id in (1509,1510);

do $$
begin
  if (select count(*) from public.rules where id in (1509,1510) and content like '%Полный текст шарха · страница 16%') <> 2 then
    raise exception 'Book 1 lesson 11 full-sharh markers are incomplete';
  end if;
  if not exists (select 1 from public.rules where id = 1509 and content like '%مَنْ فِي الْمَكْتَبِ؟ مَا فِيهِ أَحَدٌ.%' and content like '%مَنْ فِي الْمَكْتَبَةِ؟ مَا فِيهَا أَحَدٌ.%') then
    raise exception 'Book 1 lesson 11 فِيهِ/فِيهَا examples are incomplete';
  end if;
end;
$$;

commit;
