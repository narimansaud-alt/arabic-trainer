-- Publish the complete Russian sharh for Book 1 lesson 7 from PDF page 11.
-- Keep the private verbatim source_text rows separate and unchanged.

begin;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '7'
    and id in (1492, 1881);
  if v_count <> 2 then
    raise exception 'Expected guarded Book 1 lesson 7 rules 1492 and 1881, found %', v_count;
  end if;
end;
$$;

update public.rules
set
  rule_ar = case id
    when 1492 then 'تِلْكَ اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُؤَنَّثِ الْبَعِيدِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.'
    when 1881 then 'هَمْزَةُ الِاسْتِفْهَامِ «أَ» جَوَابُهَا نَعَمْ أَوْ لَا.'
  end,
  content = case id
    when 1492 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 11</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">تِلْكَ: اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُؤَنَّثِ الْبَعِيدِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">تِلْكَ</span> — указательное имя для единственного числа женского рода, находящегося далеко; употребляется и для разумного, и для неразумного.</p>
  </div>
  <div class="rule-study-card">
    <span class="rule-card-kicker">Все примеры автора: разумное и неразумное</span>
    <div class="tbl-wrap"><table><thead><tr><th>Разряд</th><th>Арабский пример</th><th>Русский перевод</th></tr></thead><tbody>
      <tr><th rowspan="3"><span dir="rtl" lang="ar">الْعَاقِلُ</span><br>разумное</th><td dir="rtl" lang="ar">تِلْكَ سُمَيَّةُ.</td><td>Та — Сумайя.</td></tr>
      <tr><td dir="rtl" lang="ar">تِلْكَ طَبِيبَةٌ.</td><td>Та — врач.</td></tr>
      <tr><td dir="rtl" lang="ar">تِلْكَ طَوِيلَةٌ.</td><td>Та — высокая.</td></tr>
      <tr><th rowspan="3"><span dir="rtl" lang="ar">غَيْرُ الْعَاقِلِ</span><br>неразумное</th><td dir="rtl" lang="ar">تِلْكَ بَطَّةٌ.</td><td>То — утка.</td></tr>
      <tr><td dir="rtl" lang="ar">تِلْكَ بَيْضَةٌ.</td><td>То — яйцо.</td></tr>
      <tr><td dir="rtl" lang="ar">تِلْكَ نَاقَةٌ.</td><td>То — верблюдица.</td></tr>
    </tbody></table></div>
  </div>
  <div class="rule-study-card">
    <span class="rule-card-kicker">Все указательные имена и примеры автора</span>
    <div class="tbl-wrap"><table><thead><tr><th>Род</th><th><span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ</span><br>для близкого</th><th><span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ</span><br>для далёкого</th></tr></thead><tbody>
      <tr><th><span dir="rtl" lang="ar">الْمُذَكَّرُ</span><br>мужской</th><td><span dir="rtl" lang="ar">هَذَا حُسَيْنٌ.</span><br>Это Хусейн.<br><span dir="rtl" lang="ar">هَذَا قَمِيصٌ.</span><br>Это рубашка.</td><td><span dir="rtl" lang="ar">ذَلِكَ مُؤَذِّنٌ.</span><br>Тот — муэдзин.<br><span dir="rtl" lang="ar">ذَلِكَ حَجَرٌ.</span><br>То — камень.</td></tr>
      <tr><th><span dir="rtl" lang="ar">الْمُؤَنَّثُ</span><br>женский</th><td><span dir="rtl" lang="ar">هَذِهِ رُقَيَّةُ.</span><br>Это Рукайя.<br><span dir="rtl" lang="ar">هَذِهِ حَدِيقَةٌ.</span><br>Это сад.</td><td><span dir="rtl" lang="ar">تِلْكَ مُمَرِّضَةٌ.</span><br>Та — медсестра.<br><span dir="rtl" lang="ar">تِلْكَ دَجَاجَةٌ.</span><br>То — курица.</td></tr>
    </tbody></table></div>
  </div>
</div>
$html$
    when 1881 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 11</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">أَسَاعَةُ عَبَّاسٍ هَذِهِ؟ لَا. هَذِهِ سَاعَةُ حَامِدٍ، تِلْكَ سَاعَةُ عَبَّاسٍ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Это часы Аббаса? Нет. Это часы Хамида, а те — часы Аббаса.</p>
  </div>
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный разбор автора</span>
    <div class="rule-meaning-grid">
      <div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">أَ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">هَمْزَةُ الِاسْتِفْهَامِ</span> — вопросительная хамза. Ответ на такой вопрос: <span dir="rtl" lang="ar">نَعَمْ</span> («да») или <span dir="rtl" lang="ar">لَا</span> («нет»).</span></div>
      <div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">هَذِهِ</span><span class="rule-term-ru">Указательное имя для близкого неразумного предмета женского рода — <span dir="rtl" lang="ar">سَاعَةٌ</span> («часы»).</span></div>
      <div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">حَامِدٍ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span> — второй член идафы, стоящий в родительном падеже.</span></div>
      <div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">تِلْكَ</span><span class="rule-term-ru">Указательное имя для далёкого неразумного предмета женского рода — <span dir="rtl" lang="ar">سَاعَةٌ</span> («часы»).</span></div>
      <div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">عَبَّاسٍ</span><span class="rule-term-ru"><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span> — второй член идафы, стоящий в родительном падеже.</span></div>
    </div>
  </div>
</div>
$html$
  end
where course_name = 'Мединский курс (Том 1)'
  and lesson_number = '7'
  and id in (1492, 1881);

do $$
begin
  if (select count(*) from public.rules where id in (1492,1881) and content like '%Полный текст шарха · страница 11%') <> 2 then
    raise exception 'Book 1 lesson 7 full-sharh markers are incomplete';
  end if;
  if not exists (select 1 from public.rules where id = 1492 and content like '%تِلْكَ سُمَيَّةُ.%' and content like '%تِلْكَ دَجَاجَةٌ.%') then
    raise exception 'Book 1 lesson 7 examples are incomplete';
  end if;
  if not exists (select 1 from public.rules where id = 1881 and content like '%هَمْزَةُ الِاسْتِفْهَامِ%' and content like '%عَبَّاسٍ%') then
    raise exception 'Book 1 lesson 7 analysis is incomplete';
  end if;
end;
$$;

commit;
