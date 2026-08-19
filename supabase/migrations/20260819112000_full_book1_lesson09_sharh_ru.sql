-- Publish the complete Russian sharh for Book 1 lesson 9 from PDF page 13.
-- Preserve every adjective analysis, valid/invalid example, and relative-clause example.

begin;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '9'
    and id in (1497,1499);
  if v_count <> 2 then
    raise exception 'Expected guarded Book 1 lesson 9 rules 1497 and 1499, found %', v_count;
  end if;
end;
$$;

update public.rules
set content = case id
when 1497 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 13</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">النَّعْتُ، وَالْمَنْعُوتُ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">الْمَنْعُوتُ</span> — определяемое имя; <span dir="rtl" lang="ar">النَّعْتُ</span> — определение этого имени.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все пять примеров и разборов автора</span><div class="tbl-wrap"><table><thead><tr><th>Предложение и полный перевод</th><th><span dir="rtl" lang="ar">الْمَنْعُوتُ</span><br>определяемое</th><th><span dir="rtl" lang="ar">النَّعْتُ</span><br>определение</th></tr></thead><tbody>
    <tr><td><span dir="rtl" lang="ar">هَذَا الرَّجُلُ الْكَرِيمُ طَبِيبٌ.</span><br>Этот благородный мужчина — врач.</td><td dir="rtl" lang="ar">الرَّجُلُ</td><td dir="rtl" lang="ar">الْكَرِيمُ</td></tr>
    <tr><td><span dir="rtl" lang="ar">عَبَّاسٌ تَاجِرٌ غَنِيٌّ.</span><br>Аббас — богатый торговец.</td><td dir="rtl" lang="ar">تَاجِرٌ</td><td dir="rtl" lang="ar">غَنِيٌّ</td></tr>
    <tr><td><span dir="rtl" lang="ar">الْعَرَبِيَّةُ لُغَةٌ جَمِيلَةٌ.</span><br>Арабский язык — красивый язык.</td><td dir="rtl" lang="ar">لُغَةٌ</td><td dir="rtl" lang="ar">جَمِيلَةٌ</td></tr>
    <tr><td><span dir="rtl" lang="ar">الْمِرْوَحَةُ فِي الْغُرْفَةِ الْكَبِيرَةِ.</span><br>Вентилятор находится в большой комнате.</td><td dir="rtl" lang="ar">الْغُرْفَةِ</td><td dir="rtl" lang="ar">الْكَبِيرَةِ</td></tr>
    <tr><td><span dir="rtl" lang="ar">الْكُوبُ لِلْمُدَرِّسِ الْجَدِيدِ.</span><br>Стакан принадлежит новому преподавателю.</td><td dir="rtl" lang="ar">الْمُدَرِّسِ</td><td dir="rtl" lang="ar">الْجَدِيدِ</td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все шесть неверных форм автора</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Форма из шарха</th><th>Почему неверно</th></tr></thead><tbody>
    <tr><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">هَذَا الرَّجُلُ كَرِيمٌ طَبِيبٌ. ✕</span><span class="rule-table-ru">Этот благородный мужчина — врач.</span></td><td>У определения пропущен артикль: требуется <span dir="rtl" lang="ar">الْكَرِيمُ</span>.</td></tr>
    <tr><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">عَبَّاسٌ تَاجِرٌ الْغَنِيُّ. ✕</span><span class="rule-table-ru">Аббас — богатый торговец.</span></td><td>Определяемое имя неопределённое, поэтому определение тоже должно быть неопределённым: <span dir="rtl" lang="ar">غَنِيٌّ</span>.</td></tr>
    <tr><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">الْعَرَبِيَّةُ لُغَةٌ جَمِيلٌ. ✕</span><span class="rule-table-ru">Арабский язык — красивый язык.</span></td><td>К женскому <span dir="rtl" lang="ar">لُغَةٌ</span> требуется женская форма <span dir="rtl" lang="ar">جَمِيلَةٌ</span>.</td></tr>
    <tr><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">لِمَنْ: تِلْكَ السَّيَّارَةُ الْجَدِيدَةِ. ✕</span><span class="rule-table-ru">Кому принадлежит та новая машина?</span></td><td>В вопросе требуется именительное окончание: <span dir="rtl" lang="ar">تِلْكَ السَّيَّارَةُ الْجَدِيدَةُ؟</span></td></tr>
    <tr><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">الْمِرْوَحَةُ فِي الْغُرْفَةِ الْكَبِيرُ. ✕</span><span class="rule-table-ru">Вентилятор находится в большой комнате.</span></td><td>Требуется согласованная форма женского рода и родительного падежа: <span dir="rtl" lang="ar">الْكَبِيرَةِ</span>.</td></tr>
    <tr><td><span class="rule-table-ar rule-table-invalid" dir="rtl" lang="ar">الْكُوبُ لِلْمُدَرِّسِ الْجَدِيدَةِ. ✕</span><span class="rule-table-ru">Стакан принадлежит новому преподавателю.</span></td><td>К мужскому <span dir="rtl" lang="ar">الْمُدَرِّسِ</span> требуется мужская форма <span dir="rtl" lang="ar">الْجَدِيدِ</span>.</td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card">
    <span class="rule-card-kicker">Итоговое правило автора</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">النَّعْتُ يَتْبَعُ الْمَنْعُوتَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ، وَالتَّعْرِيفِ وَالتَّنْكِيرِ، وَالْإِعْرَابِ، وَالْإِفْرَادِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Определение следует за определяемым именем в мужском и женском роде, определённости и неопределённости, падежном окончании и единственном числе.</p>
  </div>
</div>
$html$
when 1499 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 13</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">الَّذِي: اِسْمٌ مَوْصُولٌ لِلْمُفْرَدِ الْمُذَكَّرِ الْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">الَّذِي</span> — относительное имя «который» для единственного числа мужского рода; употребляется и с разумным, и с неразумным.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора с разумным</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّالِبُ الَّذِي خَرَجَ مِنَ الْهِنْدِ.</span><span class="rule-example-ru">Студент, который вышел из Индии.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">مَنِ الْوَلَدُ الصَّغِيرُ الَّذِي خَرَجَ؟</span><span class="rule-example-ru">Кто тот маленький мальчик, который вышел?</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">الْمُدَرِّسُ الَّذِي جَلَسَ عَلَى الْكُرْسِيِّ جَدِيدٌ.</span><span class="rule-example-ru">Преподаватель, который сел на стул, — новый.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора с неразумным</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">الْكِتَابُ الَّذِي عَلَى الْمَكْتَبِ لِلْمُدَرِّسِ.</span><span class="rule-example-ru">Книга, которая находится на столе, принадлежит преподавателю.</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَنِ الْقَلَمُ الَّذِي عَلَى الْمَكْتَبِ؟</span><span class="rule-example-ru">Кому принадлежит ручка, которая находится на столе?</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">الْبَيْتُ الْكَبِيرُ الَّذِي فِي الشَّارِعِ لِلْوَزِيرِ.</span><span class="rule-example-ru">Большой дом, который находится на улице, принадлежит министру.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все три неверных варианта без الَّذِي</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">مَنِ الْوَلَدُ الصَّغِيرُ خَرَجَ؟ ✕</span><span class="rule-example-ru">Неверно для смысла «Кто тот маленький мальчик, который вышел?»: пропущено <span dir="rtl" lang="ar">الَّذِي</span>.</span></div>
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">الْكِتَابُ عَلَى الْمَكْتَبِ لِلْمُدَرِّسِ. ✕</span><span class="rule-example-ru">Неверно для требуемой относительной связи «Книга, которая находится на столе, принадлежит преподавателю»: пропущено <span dir="rtl" lang="ar">الَّذِي</span>.</span></div>
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">لِمَنِ الْقَلَمُ عَلَى الْمَكْتَبِ؟ ✕</span><span class="rule-example-ru">Неверно для смысла «Кому принадлежит ручка, которая находится на столе?»: пропущено <span dir="rtl" lang="ar">الَّذِي</span>.</span></div>
  </div></div>
</div>
$html$
end
where course_name = 'Мединский курс (Том 1)'
  and lesson_number = '9'
  and id in (1497,1499);

do $$
begin
  if (select count(*) from public.rules where id in (1497,1499) and content like '%Полный текст шарха · страница 13%') <> 2 then
    raise exception 'Book 1 lesson 9 full-sharh markers are incomplete';
  end if;
  if not exists (select 1 from public.rules where id = 1497 and content like '%الْمُدَرِّسِ%' and content like '%النَّعْتُ يَتْبَعُ الْمَنْعُوتَ%') then
    raise exception 'Book 1 lesson 9 adjective content is incomplete';
  end if;
  if (select (length(content) - length(replace(content, 'rule-table-invalid', ''))) / length('rule-table-invalid') from public.rules where id = 1497) <> 6 then
    raise exception 'Book 1 lesson 9 must preserve six invalid adjective forms';
  end if;
  if (select (length(content) - length(replace(content, 'rule-table-invalid', ''))) / length('rule-table-invalid') from public.rules where id = 1499) <> 3 then
    raise exception 'Book 1 lesson 9 must preserve three invalid relative-clause forms';
  end if;
end;
$$;

commit;
