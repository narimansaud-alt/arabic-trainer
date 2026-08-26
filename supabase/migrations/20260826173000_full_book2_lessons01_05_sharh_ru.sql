-- Complete Russian rendering of Medina Book 2, lessons 1-5.
-- Primary source: Podrobny_Sharkh_2_tom.pdf, PDF pages 2-19.
-- Supplementary source: Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 3-13.
-- The full sharh controls the rule; unique examples of the short sharh are retained.

begin;

create temp table _book2_full_sharh_batch01 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book2_full_sharh_batch01 values
  (1248, '1', 'Полный шарх: с. 2–5 · Дополнительный шарх: с. 3–4'),
  (1249, '1', 'Полный шарх: с. 3 · Дополнительный шарх: нет отдельного раздела'),
  (1250, '1', 'Полный шарх: с. 5–6 · Дополнительный шарх: с. 5'),
  (1251, '1', 'Полный шарх: с. 6 · Дополнительный шарх: с. 4–5'),
  (1894, '1', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 5–6'),
  (1252, '1', 'Полный шарх: с. 7 · Дополнительный шарх: с. 6'),
  (1253, '2', 'Полный шарх: с. 8–9 · Дополнительный шарх: с. 7–8'),
  (1254, '2', 'Полный шарх: с. 8–9 · Дополнительный шарх: с. 7–8'),
  (1255, '2', 'Полный шарх: с. 9–10 · Дополнительный шарх: с. 8'),
  (1885, '2', 'Полный шарх: с. 10 · Дополнительный шарх: нет отдельного раздела'),
  (1256, '3', 'Полный шарх: с. 11 · Дополнительный шарх: с. 9–10'),
  (1895, '3', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 9–10'),
  (1257, '3', 'Полный шарх: с. 12 · Дополнительный шарх: с. 10'),
  (1258, '3', 'Полный шарх: с. 12 · Дополнительный шарх: с. 10'),
  (1886, '3', 'Полный шарх: с. 13 · Дополнительный шарх: с. 10'),
  (1259, '3', 'Полный шарх: с. 14 · Дополнительный шарх: с. 11'),
  (1260, '3', 'Полный шарх: с. 14 · Дополнительный шарх: с. 11'),
  (1887, '3', 'Полный шарх: с. 14 · Дополнительный шарх: с. 11'),
  (1261, '4', 'Полный шарх: с. 15 · Дополнительный шарх: с. 12'),
  (1262, '4', 'Полный шарх: с. 15 · Дополнительный шарх: с. 12'),
  (1263, '4', 'Полный шарх: с. 15–16 · Дополнительный шарх: с. 12'),
  (1888, '5', 'Полный шарх: с. 17 · Дополнительный шарх: нет отдельного раздела'),
  (1889, '5', 'Полный шарх: с. 17 · Дополнительный шарх: нет отдельного раздела'),
  (1890, '5', 'Полный шарх: с. 17 · Дополнительный шарх: нет отдельного раздела'),
  (1264, '5', 'Полный шарх: с. 18 · Дополнительный шарх: с. 13'),
  (1265, '5', 'Полный шарх: с. 18 · Дополнительный шарх: с. 13'),
  (1266, '5', 'Полный шарх: с. 18 · Дополнительный шарх: с. 13'),
  (1267, '5', 'Полный шарх: с. 19 · Дополнительный шарх: с. 13'),
  (1891, '5', 'Полный шарх: с. 19 · Дополнительный шарх: нет отдельного раздела');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r
  join _book2_full_sharh_batch01 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 2)'
    and r.lesson_number = b.lesson_number;
  if v_count <> 29 then
    raise exception 'Expected 29 guarded Book 2 rules for lessons 1-5, found %', v_count;
  end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book2-full-sharh-batch01"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источники:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book2_full_sharh_batch01 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 2)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book2-full-sharh-batch01') = 0;

-- Lesson 1: all worked supplementary examples that were missing publicly.
update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l1-second-sharh-worked-examples">
  <span class="rule-card-kicker">Примеры дополнительного шарха: местоимения</span>
  <div class="rule-example-list">
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هُنَّ مُسْلِمَاتٌ ← إِنَّهُنَّ مُسْلِمَاتٌ · لَعَلَّهُنَّ مُسْلِمَاتٌ</span><span class="rule-example-ru">Они — мусульманки → Поистине, они мусульманки · Возможно, они мусульманки.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا مُسَافِرٌ ← إِنِّي مُسَافِرٌ · لَعَلِّي مُسَافِرٌ</span><span class="rule-example-ru">Я путешественник → Поистине, я путешественник · Возможно, я путешественник.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتِ طَبِيبَةٌ ← إِنَّكِ طَبِيبَةٌ · لَعَلَّكِ طَبِيبَةٌ</span><span class="rule-example-ru">Ты врач → Поистине, ты врач · Возможно, ты врач.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتُمْ أَطِبَّاءُ ← إِنَّكُمْ أَطِبَّاءُ · لَعَلَّكُمْ أَطِبَّاءُ</span><span class="rule-example-ru">Вы врачи → Поистине, вы врачи · Возможно, вы врачи.</span></div>
  </div>
</div>
<div class="rule-study-card">
  <span class="rule-card-kicker">Примеры дополнительного шарха: явные имена</span>
  <div class="rule-example-list">
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْمُدَرِّسُ جَدِيدٌ ← إِنَّ الْمُدَرِّسَ جَدِيدٌ · لَعَلَّ الْمُدَرِّسَ جَدِيدٌ</span><span class="rule-example-ru">Преподаватель новый → Поистине, преподаватель новый · Возможно, преподаватель новый.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">فَاطِمَةُ طَبِيبَةٌ ← إِنَّ فَاطِمَةَ طَبِيبَةٌ · لَعَلَّ فَاطِمَةَ طَبِيبَةٌ</span><span class="rule-example-ru">Фатима — врач → Поистине, Фатима врач · Возможно, Фатима врач.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">حَامِدٌ مُتَزَوِّجٌ ← إِنَّ حَامِدًا مُتَزَوِّجٌ · لَعَلَّ حَامِدًا مُتَزَوِّجٌ</span><span class="rule-example-ru">Хамид женат → Поистине, Хамид женат · Возможно, Хамид женат.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْقُرْآنُ كِتَابُ اللَّهِ ← إِنَّ الْقُرْآنَ كِتَابُ اللَّهِ</span><span class="rule-example-ru">Коран — Книга Аллаха → Поистине, Коран — Книга Аллаха.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْخَبَرُ صَحِيحٌ ← لَعَلَّ الْخَبَرَ صَحِيحٌ</span><span class="rule-example-ru">Сообщение верное → Возможно, сообщение верное.</span></div>
  </div>
</div>
</div>$html$)
where id = 1248 and course_name = 'Мединский курс (Том 2)'
  and strpos(content, 'book2-l1-second-sharh-worked-examples') = 0;

update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l1-five-nouns-complete">
  <span class="rule-card-kicker">Пять имён и формы ذُو</span>
  <span class="rule-main-ar" dir="rtl" lang="ar">الْأَسْمَاءُ الْخَمْسَةُ هِيَ: أَبٌ، أَخٌ، حَمٌ، فُو، ذُو.</span>
  <p class="rule-study-text"><strong>Перевод дополнительного пояснения:</strong> Пять имён — это «отец», «брат», «свёкор / тесть», «рот» и «обладающий». В именительном падеже они имеют показатель <span dir="rtl" lang="ar">و</span>; следующее за ними имя всегда является вторым членом идафы.</p>
  <div class="rule-example-list">
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الرَّجُلُ ذُو خُلُقٍ.</span><span class="rule-example-ru">Этот мужчина обладает хорошим нравом.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ الْمَرْأَةُ ذَاتُ خُلُقٍ.</span><span class="rule-example-ru">Эта женщина обладает хорошим нравом.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَؤُلَاءِ الرِّجَالُ ذَوُو خُلُقٍ.</span><span class="rule-example-ru">Эти мужчины обладают хорошим нравом.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَؤُلَاءِ النِّسَاءُ ذَوَاتُ خُلُقٍ.</span><span class="rule-example-ru">Эти женщины обладают хорошим нравом.</span></div>
  </div>
</div>
</div>$html$)
where id = 1250 and course_name = 'Мединский курс (Том 2)'
  and strpos(content, 'book2-l1-five-nouns-complete') = 0;

update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l1-expensive-books-example">
  <span class="rule-card-kicker">Пример дополнительного шарха</span>
  <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْكُتُبُ غَالِيَةٌ فِي بَلَدِنَا.</span><span class="rule-example-ru">Книги дорогие в нашей стране.</span></div>
</div>
</div>$html$)
where id = 1894 and course_name = 'Мединский курс (Том 2)'
  and strpos(content, 'book2-l1-expensive-books-example') = 0;

update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l1-hundred-thousand-extra-examples">
  <span class="rule-card-kicker">Примеры дополнительного шарха</span>
  <div class="rule-example-list">
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا التِّلْفَازُ بِأَلْفِ رِيَالٍ.</span><span class="rule-example-ru">Этот телевизор стоит тысячу риялов.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَرَأْتُ أَلْفَ صَفْحَةٍ.</span><span class="rule-example-ru">Я прочитал тысячу страниц.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">وَصَلَ إِلَى مَكَّةَ مِائَةُ حَاجٍّ وَحَاجَّةٍ.</span><span class="rule-example-ru">В Мекку прибыло сто паломников и паломниц.</span></div>
  </div>
</div>
</div>$html$)
where id = 1252 and course_name = 'Мединский курс (Том 2)'
  and strpos(content, 'book2-l1-hundred-thousand-extra-examples') = 0;

-- Lesson 2: complete examples. The full sharh remains authoritative.
update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l2-laysa-intro-examples">
  <span class="rule-card-kicker">Исходное предложение и отрицание</span>
  <div class="rule-example-list">
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْبَابُ مُغْلَقٌ ← لَيْسَ الْبَابُ مُغْلَقًا.</span><span class="rule-example-ru">Дверь закрыта → Дверь не закрыта.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَيْسَ الْمَاءُ بَارِدًا.</span><span class="rule-example-ru">Вода не холодная.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَيْسَ هِشَامٌ مَرِيضًا.</span><span class="rule-example-ru">Хишам не болен.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَيْسَ الْمَسْجِدُ بَعِيدًا.</span><span class="rule-example-ru">Мечеть не далеко.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَيْسَ الطِّفْلُ نَائِمًا.</span><span class="rule-example-ru">Ребёнок не спит.</span></div>
  </div>
</div>
</div>$html$)
where id = 1253 and course_name = 'Мединский курс (Том 2)'
  and strpos(content, 'book2-l2-laysa-intro-examples') = 0;

update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l2-laysa-ba-complete-table">
  <span class="rule-card-kicker">Полная таблица полного шарха</span>
  <p class="rule-study-text">В каждой строке допустимы обе формы: обычное сказуемое в винительном падеже и усиленная форма с добавочной <span dir="rtl" lang="ar">بِـ</span>, внешне стоящая в родительном падеже.</p>
  <div class="tbl-wrap"><table><thead><tr><th>Без بِـ</th><th>С добавочной بِـ</th><th>Перевод</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">أَنَا لَسْتُ مُدَرِّسًا</td><td dir="rtl" lang="ar">أَنَا لَسْتُ بِمُدَرِّسٍ</td><td>Я не преподаватель.</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتَ لَسْتَ كَبِيرًا</td><td dir="rtl" lang="ar">أَنْتَ لَسْتَ بِكَبِيرٍ</td><td>Ты не взрослый.</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتِ لَسْتِ كَبِيرَةً</td><td dir="rtl" lang="ar">أَنْتِ لَسْتِ بِكَبِيرَةٍ</td><td>Ты не взрослая.</td></tr>
    <tr><td dir="rtl" lang="ar">حَامِدٌ لَيْسَ طَالِبًا</td><td dir="rtl" lang="ar">حَامِدٌ لَيْسَ بِطَالِبٍ</td><td>Хамид не студент.</td></tr>
    <tr><td dir="rtl" lang="ar">آمِنَةُ لَيْسَتْ طَالِبَةً</td><td dir="rtl" lang="ar">آمِنَةُ لَيْسَتْ بِطَالِبَةٍ</td><td>Амина не студентка.</td></tr>
    <tr><td dir="rtl" lang="ar">نَحْنُ لَسْنَا طُلَّابًا</td><td dir="rtl" lang="ar">نَحْنُ لَسْنَا بِطُلَّابٍ</td><td>Мы не студенты.</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتُمْ لَسْتُمْ جُدُدًا</td><td dir="rtl" lang="ar">أَنْتُمْ لَسْتُمْ بِجُدُدٍ</td><td>Вы не новенькие.</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتُنَّ لَسْتُنَّ مُجْتَهِدَاتٍ</td><td dir="rtl" lang="ar">أَنْتُنَّ لَسْتُنَّ بِمُجْتَهِدَاتٍ</td><td>Вы не старательные.</td></tr>
    <tr><td dir="rtl" lang="ar">الطُّلَّابُ لَيْسُوا صِغَارًا</td><td dir="rtl" lang="ar">الطُّلَّابُ لَيْسُوا بِصِغَارٍ</td><td>Студенты не маленькие.</td></tr>
    <tr><td dir="rtl" lang="ar">الطَّالِبَاتُ لَسْنَ مُتَزَوِّجَاتٍ</td><td dir="rtl" lang="ar">الطَّالِبَاتُ لَسْنَ بِمُتَزَوِّجَاتٍ</td><td>Студентки не замужем.</td></tr>
  </tbody></table></div>
</div>
<div class="rule-study-card">
  <span class="rule-card-kicker">Отличающиеся примеры дополнительного шарха</span>
  <p class="rule-study-text" dir="rtl" lang="ar">آمِنَةُ لَيْسَتْ طَبِيبَةً / بِطَبِيبَةٍ. الْفَتَيَاتُ لَسْنَ مُتَزَوِّجَاتٍ / بِمُتَزَوِّجَاتٍ. نَحْنُ لَسْنَا جُدُدًا / بِجُدُدٍ. أَنْتِ لَسْتِ فَقِيرَةً / بِفَقِيرَةٍ. أَنْتُمْ لَسْتُمْ عَرَبًا / بِعَرَبٍ.</p>
  <p class="rule-study-text">Амина не врач. Девушки не замужем. Мы не новенькие. Ты не бедная. Вы не арабы.</p>
</div>
</div>$html$)
where id = 1254 and course_name = 'Мединский курс (Том 2)'
  and strpos(content, 'book2-l2-laysa-ba-complete-table') = 0;

update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l2-source-wording-difference">
  <span class="rule-card-kicker">Приоритет полного шарха</span>
  <span class="rule-main-ar" dir="rtl" lang="ar">يَجِبُ تَقْدِيمُ خَبَرَيْ إِنَّ وَلَيْسَ عَلَى اسْمَيْهِمَا إِذَا كَانَ الِاسْمُ نَكِرَةً وَالْخَبَرُ شِبْهَ جُمْلَةٍ.</span>
  <p class="rule-study-text"><strong>Полный шарх, с. 9–10:</strong> если имя <span dir="rtl" lang="ar">إِنَّ</span> или <span dir="rtl" lang="ar">لَيْسَ</span> неопределённое, а сказуемое является полупредложением, сказуемое <strong>обязательно</strong> ставится перед именем. Именно эта формулировка принята как правило урока.</p>
  <p class="rule-study-text"><strong>Дополнительный шарх, с. 8:</strong> <span dir="rtl" lang="ar">يَجُوزُ تَقْدِيمُ خَبَرِ إِنَّ عَلَى اسْمِهَا إِذَا كَانَ الْخَبَرُ جَارًّا وَمَجْرُورًا</span> — допускается поставить сказуемое <span dir="rtl" lang="ar">إِنَّ</span> перед её именем, если сказуемое — сочетание предлога с именем. Формулировка сохранена как пояснение второго источника и не заменяет правило полного шарха.</p>
</div>
<div class="rule-study-card">
  <span class="rule-card-kicker">Пять преобразований дополнительного шарха</span>
  <div class="rule-example-list">
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لِي ثَلَاثُ أَخَوَاتٍ ← إِنَّ لِي ثَلَاثَ أَخَوَاتٍ.</span><span class="rule-example-ru">У меня три сестры → Поистине, у меня три сестры.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">فِي الْفَصْلِ خَمْسَةُ طُلَّابٍ جُدُدٌ ← إِنَّ فِي الْفَصْلِ خَمْسَةَ طُلَّابٍ جُدُدًا.</span><span class="rule-example-ru">В классе пять новых студентов → Поистине, в классе пять новых студентов.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَنَا مُدَرِّسٌ جَيِّدٌ ← إِنَّ لَنَا مُدَرِّسًا جَيِّدًا.</span><span class="rule-example-ru">У нас хороший преподаватель → Поистине, у нас хороший преподаватель.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">فِي الْهِنْدِ أَنْهَارٌ كَثِيرَةٌ ← إِنَّ فِي الْهِنْدِ أَنْهَارًا كَثِيرَةً.</span><span class="rule-example-ru">В Индии много рек → Поистине, в Индии много рек.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">فِي جَيْبِي مِائَةُ رِيَالٍ ← إِنَّ فِي جَيْبِي مِائَةَ رِيَالٍ.</span><span class="rule-example-ru">В моём кармане сто риялов → Поистине, в моём кармане сто риялов.</span></div>
  </div>
</div>
</div>$html$)
where id = 1255 and course_name = 'Мединский курс (Том 2)'
  and strpos(content, 'book2-l2-source-wording-difference') = 0;

-- Lesson 3: exact rejected form from the full sharh.
update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l3-maqsur-no-tanwin">
  <span class="rule-card-kicker">Точное предостережение полного шарха</span>
  <p class="rule-study-text">У имени сравнения на конечный постоянный алиф падежный знак внешне не проявляется. Поэтому полный шарх прямо запрещает форму с танвином.</p>
  <div class="rule-example-list">
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا نَقُولُ: هُوَ أَذْكَىٌ مِنِّي.</span><span class="rule-example-ru">Не говорим с танвином после <span dir="rtl" lang="ar">أَذْكَى</span>.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">نَقُولُ: هُوَ أَذْكَى مِنِّي.</span><span class="rule-example-ru">Говорим без танвина: «Он умнее меня».</span></div>
  </div>
</div>
</div>$html$)
where id = 1256 and course_name = 'Мединский курс (Том 2)'
  and strpos(content, 'book2-l3-maqsur-no-tanwin') = 0;

-- Lesson 5: exact definitions and the one supplementary example absent publicly.
update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l5-exact-role-definitions">
  <span class="rule-card-kicker">Дословные определения дополнительного шарха</span>
  <span class="rule-main-ar" dir="rtl" lang="ar">الْفَاعِلُ: اسْمٌ مَرْفُوعٌ قَبْلَهُ فِعْلٌ، وَهُوَ الَّذِي فَعَلَ الْفِعْلَ. الْمَفْعُولُ بِهِ: اسْمٌ مَنْصُوبٌ وَقَعَ عَلَيْهِ فِعْلُ الْفَاعِلِ.</span>
  <p class="rule-study-text"><strong>Полный перевод:</strong> Исполнитель — имя в именительном падеже, перед которым стоит глагол; это тот, кто совершил действие. Прямое дополнение — имя в винительном падеже, на которое направлено действие исполнителя.</p>
  <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَرَأَ الطَّالِبُ الْقُرْآنَ.</span><span class="rule-example-ru">Студент прочитал Коран: <span dir="rtl" lang="ar">الطَّالِبُ</span> — исполнитель, <span dir="rtl" lang="ar">الْقُرْآنَ</span> — прямое дополнение.</span></div>
</div>
</div>$html$)
where id = 1264 and course_name = 'Мединский курс (Том 2)'
  and strpos(content, 'book2-l5-exact-role-definitions') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 2)';
  if v_count <> 148 then raise exception 'Book 2 must retain 148 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 2)';
  if v_count <> 290 then raise exception 'Book 2 must retain 290 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch01 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 2)'
    and r.lesson_number = b.lesson_number
    and strpos(r.content, 'book2-full-sharh-batch01') > 0;
  if v_count <> 29 then raise exception 'Book 2 lessons 1-5 full-sharh markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book2_full_sharh_batch01 b
    where not exists (select 1 from public.rule_sources s where s.rule_id = b.rule_id)
  ) then raise exception 'A completed Book 2 lesson 1-5 card has no source row'; end if;

  if not exists (select 1 from public.rules where id = 1248
    and content like '%هُنَّ مُسْلِمَاتٌ ← إِنَّهُنَّ مُسْلِمَاتٌ%'
    and content like '%الْقُرْآنُ كِتَابُ اللَّهِ ← إِنَّ الْقُرْآنَ كِتَابُ اللَّهِ%')
  then raise exception 'Lesson 1 worked إن/لعل examples incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1252
    and content like '%قَرَأْتُ أَلْفَ صَفْحَةٍ%'
    and content like '%مِائَةُ حَاجٍّ وَحَاجَّةٍ%')
  then raise exception 'Lesson 1 numeral examples incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1254
    and content like '%أَنْتُمْ لَسْتُمْ عَرَبًا / بِعَرَبٍ%'
    and content like '%الطَّالِبَاتُ لَسْنَ مُتَزَوِّجَاتٍ%')
  then raise exception 'Lesson 2 لَيْسَ alternatives incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1255
    and content like '%<strong>Полный шарх, с. 9–10:</strong>%'
    and content like '%<strong>обязательно</strong>%'
    and content like '%<strong>Дополнительный шарх, с. 8:</strong>%'
    and content like '%يَجُوزُ تَقْدِيمُ خَبَرِ إِنَّ%'
    and content like '%فِي جَيْبِي مِائَةُ رِيَالٍ%')
  then raise exception 'Lesson 2 source wording difference is not explicit'; end if;

  if not exists (select 1 from public.rules where id = 1256
    and content like '%لَا نَقُولُ: هُوَ أَذْكَىٌ مِنِّي%'
    and content like '%نَقُولُ: هُوَ أَذْكَى مِنِّي%')
  then raise exception 'Lesson 3 maqsur warning incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1264
    and content like '%الْفَاعِلُ: اسْمٌ مَرْفُوعٌ قَبْلَهُ فِعْلٌ%'
    and content like '%قَرَأَ الطَّالِبُ الْقُرْآنَ%')
  then raise exception 'Lesson 5 definitions incomplete'; end if;
end;
$assert$;

commit;
