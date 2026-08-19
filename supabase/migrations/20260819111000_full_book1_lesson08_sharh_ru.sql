-- Publish the complete Russian sharh for Book 1 lesson 8 from PDF page 12.
-- Fix the public example هَذَا الرَّجُلُ تَاجِرٌ against the visible source.
-- Keep private verbatim source_text rows separate and unchanged.

begin;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '8'
    and id in (1493,1494,1495,1496);
  if v_count <> 4 then
    raise exception 'Expected four guarded Book 1 lesson 8 rules, found %', v_count;
  end if;
end;
$$;

update public.rules
set content = case id
when 1493 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 12</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">الْإِشَارَةُ إِلَى الْمُعَرَّفِ بِـ«أَلْ».</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Указание на имя, определённое артиклем <span dir="rtl" lang="ar">أَلْ</span>.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все правильные примеры автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الرَّجُلُ تَاجِرٌ.</span><span class="rule-example-ru">Этот мужчина — торговец.</span></div>
    <div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ الرَّجُلُ طَبِيبٌ.</span><span class="rule-example-ru">Тот мужчина — врач.</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الْبَيْتُ لِلتَّاجِرِ.</span><span class="rule-example-ru">Этот дом принадлежит торговцу.</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ الْبَيْتُ لِلطَّبِيبِ.</span><span class="rule-example-ru">Тот дом принадлежит врачу.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Обе неверные формы автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">هَذَا الرَّجُلُ التَّاجِرُ. ✕</span><span class="rule-example-ru">Неверно для смысла «Этот мужчина — торговец»: сказуемое <span dir="rtl" lang="ar">تَاجِرٌ</span> должно быть неопределённым.</span></div>
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">ذَلِكَ الرَّجُلُ الطَّبِيبُ. ✕</span><span class="rule-example-ru">Неверно для смысла «Тот мужчина — врач»: сказуемое <span dir="rtl" lang="ar">طَبِيبٌ</span> должно быть неопределённым.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Оба полных разбора автора</span><div class="tbl-wrap"><table><thead><tr><th>Предложение</th><th>Указательное имя</th><th>Имя с أَلْ</th><th>Сказуемое</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">هَذَا الرَّجُلُ تَاجِرٌ.</td><td><span dir="rtl" lang="ar">هَذَا: مُبْتَدَأٌ</span><br>подлежащее</td><td><span dir="rtl" lang="ar">الرَّجُلُ: بَدَلٌ</span><br>приложение</td><td><span dir="rtl" lang="ar">تَاجِرٌ: خَبَرٌ</span><br>сказуемое</td></tr>
    <tr><td dir="rtl" lang="ar">ذَلِكَ الْبَيْتُ لِلطَّبِيبِ.</td><td><span dir="rtl" lang="ar">ذَلِكَ: مُبْتَدَأٌ</span><br>подлежащее</td><td><span dir="rtl" lang="ar">الْبَيْتُ: بَدَلٌ</span><br>приложение</td><td><span dir="rtl" lang="ar">لِلطَّبِيبِ: خَبَرٌ</span><br>сказуемое</td></tr>
  </tbody></table></div></div>
</div>
$html$
when 1494 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 12</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">لِمَنْ؟ سُؤَالٌ عَنِ الْعَاقِلِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">لِمَنْ؟</span> — вопрос о разумном: «кому принадлежит?», «чей?».</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنْ هَذَا الْبَيْتُ؟ هَذَا الْبَيْتُ لِلتَّاجِرِ.</span><span class="rule-example-ru">Кому принадлежит этот дом? Этот дом принадлежит торговцу.</span></div>
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنْ ذَلِكَ الْبَيْتُ؟ ذَلِكَ الْبَيْتُ لِلطَّبِيبِ.</span><span class="rule-example-ru">Кому принадлежит тот дом? Тот дом принадлежит врачу.</span></div>
  </div></div>
</div>
$html$
when 1495 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 12</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">أَمَامَ، خَلْفَ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">أَمَامَ</span> — «перед»; <span dir="rtl" lang="ar">خَلْفَ</span> — «позади, за».</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">السَّبُّورَةُ أَمَامَ الطُّلَّابِ.</span><span class="rule-example-ru">Доска перед студентами.</span></div>
    <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">السَّبُّورَةُ خَلْفَ الْمُدَرِّسِ.</span><span class="rule-example-ru">Доска позади преподавателя.</span></div>
    <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ سَيَّارَةُ الْإِمَامِ؟ هِيَ أَمَامَ الْمَدْرَسَةِ.</span><span class="rule-example-ru">Где машина имама? Она перед школой.</span></div>
    <div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ جَلَسَ حَامِدٌ؟ جَلَسَ خَلْفَ مَحْمُودٍ.</span><span class="rule-example-ru">Где сел Хамид? Он сел позади Махмуда.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Полный разбор автора</span><div class="tbl-wrap"><table><thead><tr><th>Сочетание</th><th>Первый член</th><th>Второй член</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">خَلْفَ مَحْمُودٍ</td><td><span dir="rtl" lang="ar">خَلْفَ: مُضَافٌ</span><br>первый член идафы</td><td><span dir="rtl" lang="ar">مَحْمُودٍ: مُضَافٌ إِلَيْهِ</span><br>второй член идафы, родительный падеж</td></tr>
    <tr><td dir="rtl" lang="ar">أَمَامَ الطُّلَّابِ</td><td><span dir="rtl" lang="ar">أَمَامَ: مُضَافٌ</span><br>первый член идафы</td><td><span dir="rtl" lang="ar">الطُّلَّابِ: مُضَافٌ إِلَيْهِ</span><br>второй член идафы, родительный падеж</td></tr>
  </tbody></table></div></div>
</div>
$html$
when 1496 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 12</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">حُرُوفُ الْجَرِّ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Значения предлогов родительного падежа.</p>
    <div class="tbl-wrap"><table><thead><tr><th>Предлог</th><th>Формулировка автора</th><th>Полный русский перевод</th></tr></thead><tbody>
      <tr><td dir="rtl" lang="ar">مِنْ</td><td dir="rtl" lang="ar">تُفِيدُ الْبِدَايَةَ.</td><td>Указывает на начало, исходную точку: «из, от».</td></tr>
      <tr><td dir="rtl" lang="ar">إِلَى</td><td dir="rtl" lang="ar">تُفِيدُ النِّهَايَةَ.</td><td>Указывает на конец, конечную точку: «до, к».</td></tr>
      <tr><td dir="rtl" lang="ar">فِي</td><td dir="rtl" lang="ar">تُفِيدُ الظَّرْفِيَّةَ.</td><td>Указывает на нахождение внутри: «в».</td></tr>
      <tr><td dir="rtl" lang="ar">عَلَى</td><td dir="rtl" lang="ar">تُفِيدُ الِاسْتِعْلَاءَ.</td><td>Указывает на нахождение сверху: «на, над».</td></tr>
      <tr><td dir="rtl" lang="ar">اللَّامُ</td><td dir="rtl" lang="ar">تُفِيدُ الْمِلْكَ.</td><td>Указывает на принадлежность: «для, у, принадлежит».</td></tr>
    </tbody></table></div>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все пояснения и примеры автора о لِـ</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">هَذَا الْبَيْتُ لِلتَّاجِرِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Этот дом принадлежит торговцу.</p>
    <span class="rule-main-ar" dir="rtl" lang="ar">اللَّامُ: حَرْفُ جَرٍّ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Лям — предлог родительного падежа.</p>
    <div class="rule-example-list">
      <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">لِلتَّاجِرِ.</span><span class="rule-example-ru">Торговцу.</span></div>
      <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">لِلطَّبِيبِ.</span><span class="rule-example-ru">Врачу.</span></div>
      <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">لِلْمُدَرِّسِ.</span><span class="rule-example-ru">Преподавателю.</span></div>
      <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">لِمُحَمَّدٍ.</span><span class="rule-example-ru">Мухаммаду.</span></div>
    </div>
  </div>
</div>
$html$
end
where course_name = 'Мединский курс (Том 1)'
  and lesson_number = '8'
  and id in (1493,1494,1495,1496);

do $$
begin
  if (select count(*) from public.rules where id in (1493,1494,1495,1496) and content like '%Полный текст шарха · страница 12%') <> 4 then
    raise exception 'Book 1 lesson 8 full-sharh markers are incomplete';
  end if;
  if not exists (select 1 from public.rules where id = 1493 and content like '%هَذَا الرَّجُلُ تَاجِرٌ.%' and content not like '%هٰذَا التَّاجِرُ تَاجِرٌ.%') then
    raise exception 'Book 1 lesson 8 first example was not corrected';
  end if;
  if not exists (select 1 from public.rules where id = 1496 and content like '%تُفِيدُ الْبِدَايَةَ.%' and content like '%تُفِيدُ الْمِلْكَ.%') then
    raise exception 'Book 1 lesson 8 preposition meanings are incomplete';
  end if;
end;
$$;

commit;
