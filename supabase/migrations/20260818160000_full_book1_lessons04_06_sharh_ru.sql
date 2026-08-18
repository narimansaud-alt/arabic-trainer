-- Restore the complete public Russian sharh for Book 1 lessons 4-6.
-- The private source_text remains separate and is expanded only where the
-- visible PDF proves that an earlier transcription omitted printed lines.

begin;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number in ('4', '5', '6')
    and id in (1476,1477,1478,1479,1480,1483,1484,1485,1486,1487,1488);
  if v_count <> 11 then
    raise exception 'Expected 11 guarded Book 1 lesson 4-6 rules, found %', v_count;
  end if;
end;
$$;

update public.rules
set content = case id
when 1476 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 8</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">حُرُوفُ الْجَرِّ (فِي، عَلَى، مِنْ، إِلَى).</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Предлоги: <span dir="rtl" lang="ar">فِي</span> — «в», <span dir="rtl" lang="ar">عَلَى</span> — «на», <span dir="rtl" lang="ar">مِنْ</span> — «из, от», <span dir="rtl" lang="ar">إِلَى</span> — «к, в направлении».</p>
    <span class="rule-main-ar" dir="rtl" lang="ar">حُرُوفُ الْجَرِّ: يُجَرُّ الِاسْمُ الَّذِي بَعْدَهَا بِالْكَسْرَةِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Предлоги ставят следующее за ними имя в родительный падеж с касрой.</p>
  </div>
  <div class="rule-study-card">
    <span class="rule-card-kicker">Все примеры автора</span>
    <div class="tbl-wrap"><table><thead><tr><th>Предлог</th><th>Арабский пример</th><th>Русский перевод</th></tr></thead><tbody>
      <tr><td dir="rtl" lang="ar">فِي</td><td dir="rtl" lang="ar">مُحَمَّدٌ فِي الْبَيْتِ.</td><td>Мухаммад в доме.</td></tr>
      <tr><td dir="rtl" lang="ar">فِي</td><td dir="rtl" lang="ar">يَاسِرٌ فِي الْغُرْفَةِ.</td><td>Ясир в комнате.</td></tr>
      <tr><td dir="rtl" lang="ar">فِي</td><td dir="rtl" lang="ar">آمِنَةُ فِي الْمَطْبَخِ.</td><td>Амина на кухне.</td></tr>
      <tr><td dir="rtl" lang="ar">عَلَى</td><td dir="rtl" lang="ar">الْقَلَمُ عَلَى الْمَكْتَبِ.</td><td>Ручка на столе.</td></tr>
      <tr><td dir="rtl" lang="ar">عَلَى</td><td dir="rtl" lang="ar">الطِّفْلُ عَلَى السَّرِيرِ.</td><td>Ребёнок на кровати.</td></tr>
      <tr><td dir="rtl" lang="ar">عَلَى</td><td dir="rtl" lang="ar">الطَّالِبُ عَلَى الْكُرْسِيِّ.</td><td>Студент на стуле.</td></tr>
      <tr><td dir="rtl" lang="ar">مِنْ</td><td dir="rtl" lang="ar">خَرَجَ الْمُدَرِّسُ مِنَ الْفَصْلِ.</td><td>Преподаватель вышел из класса.</td></tr>
      <tr><td dir="rtl" lang="ar">مِنْ</td><td dir="rtl" lang="ar">فَاطِمَةُ مِنَ الْهِنْدِ.</td><td>Фатима из Индии.</td></tr>
      <tr><td dir="rtl" lang="ar">مِنْ</td><td dir="rtl" lang="ar">هَذَا الْقَلَمُ مِنْ مُحَمَّدٍ.</td><td>Эта ручка от Мухаммада.</td></tr>
      <tr><td dir="rtl" lang="ar">إِلَى</td><td dir="rtl" lang="ar">ذَهَبَ خَالِدٌ إِلَى الْمَعْهَدِ.</td><td>Халид пошёл в институт.</td></tr>
      <tr><td dir="rtl" lang="ar">إِلَى</td><td dir="rtl" lang="ar">ذَهَبَ عَلِيٌّ إِلَى الْمُدِيرِ.</td><td>Али пошёл к директору.</td></tr>
      <tr><td dir="rtl" lang="ar">إِلَى</td><td dir="rtl" lang="ar">ذَهَبَ الطَّالِبُ إِلَى الْمِرْحَاضِ.</td><td>Студент пошёл в уборную.</td></tr>
    </tbody></table></div>
  </div>
</div>
$html$
when 1477 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 8</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">أَيْنَ؟ سُؤَالٌ عَنِ الْمَكَانِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">أَيْنَ؟</span> — вопрос о месте: «где?».</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все примеры автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ مُحَمَّدٌ؟ مُحَمَّدٌ فِي الْغُرْفَةِ.</span><span class="rule-example-ru">Где Мухаммад? Мухаммад в комнате.</span></div>
    <div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ فَاطِمَةُ؟ فَاطِمَةُ فِي الْمَطْبَخِ.</span><span class="rule-example-ru">Где Фатима? Фатима на кухне.</span></div>
  </div></div>
</div>
$html$
when 1478 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 8</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">مَاذَا؟ = مَا هَذَا؟ لِغَيْرِ الْعَاقِلِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">مَاذَا؟</span> равнозначно <span dir="rtl" lang="ar">مَا هَذَا؟</span> и употребляется для вопроса о неразумном: «что?».</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все правильные и неправильные примеры автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">مَاذَا عَلَى الْمَكْتَبِ؟ الْقَلَمُ عَلَى الْمَكْتَبِ. ✓</span><span class="rule-example-ru">Что на столе? Ручка на столе. Верно.</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">مَاذَا عَلَى السَّرِيرِ؟ السَّاعَةُ عَلَى السَّرِيرِ. ✓</span><span class="rule-example-ru">Что на кровати? Часы на кровати. Верно.</span></div>
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">مَاذَا عَلَى الْمَكْتَبِ؟ مُحَمَّدٌ عَلَى الْمَكْتَبِ. ✕</span><span class="rule-example-ru">Что на столе? Мухаммад на столе. Неверно.</span></div>
  </div></div>
</div>
$html$
when 1479 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 8</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">الْعَلَمُ الْمُؤَنَّثُ لَا يُنَوَّنُ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Женское имя собственное не принимает танвин.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все сопоставления автора</span><div class="tbl-wrap"><table><thead><tr><th>Мужское имя</th><th>Женское имя без танвина</th><th>Русское чтение</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">مُحَمَّدٌ</td><td dir="rtl" lang="ar">عَائِشَةُ</td><td>Мухаммад — Аиша</td></tr>
    <tr><td dir="rtl" lang="ar">عَمَّارٌ</td><td dir="rtl" lang="ar">آمِنَةُ</td><td>Аммар — Амина</td></tr>
    <tr><td dir="rtl" lang="ar">يَاسِرٌ</td><td dir="rtl" lang="ar">مَرْيَمُ</td><td>Ясир — Марьям</td></tr>
    <tr><td dir="rtl" lang="ar">عَلِيٌّ</td><td dir="rtl" lang="ar">فَاطِمَةُ</td><td>Али — Фатима</td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все запрещённые формы автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">عَائِشَةٌ. ✕</span><span class="rule-example-ru">Форма имени «Аиша» с танвином неверна.</span></div>
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">آمِنَةٌ. ✕</span><span class="rule-example-ru">Форма имени «Амина» с танвином неверна.</span></div>
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">مَرْيَمٌ. ✕</span><span class="rule-example-ru">Форма имени «Марьям» с танвином неверна.</span></div>
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">فَاطِمَةٌ. ✕</span><span class="rule-example-ru">Форма имени «Фатима» с танвином неверна.</span></div>
  </div></div>
</div>
$html$
when 1480 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 8</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">مِنَ الْبَيْتِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Из дома.</p>
    <div class="rule-meaning-grid">
      <div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">أَصْلُهُ: مِنْ + ال.</span><span class="rule-term-ru">Исходная форма.</span></div>
      <div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">مِنَ ال.</span><span class="rule-term-ru">Произношение после устранения встречи двух сукунов.</span></div>
    </div>
    <span class="rule-main-ar" dir="rtl" lang="ar">حُرِّكَتِ النُّونُ بِالْفَتْحَةِ مَنْعًا لِالْتِقَاءِ السَّاكِنَيْنِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Буква нун огласована фатхой, чтобы не допустить встречи двух букв с сукуном.</p>
  </div>
</div>
$html$
when 1483 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 9</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">الْمُضَافُ، وَالْمُضَافُ إِلَيْهِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">الْمُضَافُ</span> — первый член идафы; <span dir="rtl" lang="ar">الْمُضَافُ إِلَيْهِ</span> — второй член идафы.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все схемы автора</span><div class="rule-meaning-grid">
    <div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">كِتَابٌ: مُحَمَّدٌ ← كِتَابُ مُحَمَّدٍ</span><span class="rule-term-ru">книга + Мухаммад → книга Мухаммада</span></div>
    <div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">بِنْتٌ: حَامِدٌ ← بِنْتُ حَامِدٍ</span><span class="rule-term-ru">дочь + Хамид → дочь Хамида</span></div>
    <div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">كِتَابٌ: اللَّهُ ← كِتَابُ اللَّهِ</span><span class="rule-term-ru">книга + Аллах → Книга Аллаха</span></div>
  </div><p class="rule-study-text"><span dir="rtl" lang="ar">كِتَابُ</span> — <span dir="rtl" lang="ar">مُضَافٌ</span> (первый член идафы); <span dir="rtl" lang="ar">مُحَمَّدٍ</span> — <span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span> (второй член идафы).</p></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все три проверки автора</span><div class="tbl-wrap"><table><thead><tr><th>Неверно</th><th>Верно</th><th>Полный перевод пояснения</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">كِتَابٌ مُحَمَّدٍ ✕</td><td dir="rtl" lang="ar">كِتَابُ مُحَمَّدٍ ✓</td><td>Танвин удаляется при идафе.</td></tr>
    <tr><td dir="rtl" lang="ar">الْكِتَابُ مُحَمَّدٍ ✕</td><td dir="rtl" lang="ar">كِتَابُ مُحَمَّدٍ ✓</td><td>Артикль <span dir="rtl" lang="ar">أَلْ</span> удаляется при идафе.</td></tr>
    <tr><td dir="rtl" lang="ar">كِتَابُ مُحَمَّدٌ ✕</td><td dir="rtl" lang="ar">كِتَابُ مُحَمَّدٍ ✓</td><td><span dir="rtl" lang="ar">الْمُضَافُ إِلَيْهِ</span> стоит в родительном падеже с касрой: <span dir="rtl" lang="ar">مُحَمَّدٍ</span>.</td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все дополнительные примеры автора для идафы</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">خَالُ حَامِدٍ فَقِيرٌ.</span><span class="rule-example-ru">Дядя Хамида по матери беден.</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">مَا اسْمُ الرَّجُلِ؟</span><span class="rule-example-ru">Как зовут мужчину? Дословно: «Каково имя мужчины?»</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">اِبْنُ مَنْ أَنْتَ؟</span><span class="rule-example-ru">Чей ты сын?</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا اِبْنُ خَالِدٍ.</span><span class="rule-example-ru">Я сын Халида.</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">مَا اسْمُ الْبِنْتِ؟</span><span class="rule-example-ru">Как зовут девочку? Дословно: «Каково имя девочки?»</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">اسْمُ الْبِنْتِ زَيْنَبُ.</span><span class="rule-example-ru">Девочку зовут Зайнаб. Дословно: «Имя девочки — Зайнаб».</span></div>
  </div></div>
</div>
$html$
when 1484 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 9</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">الْمُنَادَى: هُوَ بِمَعْنَى أَنْ تَقُولَ لِصَدِيقِكَ تَعَالَ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">الْمُنَادَى</span> (тот, к кому обращаются) означает, что ты говоришь своему другу: «Иди сюда».</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все примеры обращения автора</span><div class="rule-meaning-grid">
    <div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">يَا مُحَمَّدُ.</span><span class="rule-term-ru">О Мухаммад!</span></div>
    <div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">يَا أُسْتَاذُ.</span><span class="rule-term-ru">О учитель!</span></div>
    <div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">يَا وَلَدُ.</span><span class="rule-term-ru">О мальчик!</span></div>
    <div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">يَا بِنْتُ.</span><span class="rule-term-ru">О девочка!</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Правильная и неправильная формы автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">يَا شَيْخُ. ✓</span><span class="rule-example-ru">О шейх! Верно: танвин при обращении удаляется.</span></div>
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">يَا شَيْخٌ. ✕</span><span class="rule-example-ru">О шейх! Неверно: танвин при обращении не сохраняется.</span></div>
  </div></div>
</div>
$html$
when 1485 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 9</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">كِتَابُ مَنْ هَذَا؟ سُؤَالٌ عَنِ الْعَاقِلِ ← هَذَا كِتَابُ مُحَمَّدٍ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> «Чья это книга?» — вопрос о разумном владельце. Ответ: «Это книга Мухаммада».</p>
    <span class="rule-main-ar" dir="rtl" lang="ar">قَلَمُ مَنْ هَذَا؟ هَذَا قَلَمُ خَالِدٍ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Чья это ручка? Это ручка Халида.</p>
  </div>
</div>
$html$
when 1486 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 10</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">هَذِهِ: اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُؤَنَّثِ الْقَرِيبِ، الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">هَذِهِ</span> — указательное имя для близкого единственного женского рода, разумного и неразумного.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْعَاقِلُ</span> (разумное) — все примеры автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ خَدِيجَةُ.</span><span class="rule-example-ru">Это Хадиджа.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ بِنْتٌ.</span><span class="rule-example-ru">Это девочка.</span></div>
    <div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ أُخْتُ الْمُهَنْدِسِ.</span><span class="rule-example-ru">Это сестра инженера.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">غَيْرُ الْعَاقِلِ</span> (неразумное) — все примеры автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ سَيَّارَةٌ.</span><span class="rule-example-ru">Это автомобиль.</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ مِكْوَاةٌ.</span><span class="rule-example-ru">Это утюг.</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ دَرَّاجَةُ أَنَسٍ.</span><span class="rule-example-ru">Это велосипед Анаса.</span></div>
  </div></div>
</div>
$html$
when 1487 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 10</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">أَمْثِلَةٌ أُخْرَى.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Другие примеры.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все имена женского рода из шарха</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ أُذُنٌ وَهَذِهِ عَيْنٌ.</span><span class="rule-example-ru">Это ухо, а это глаз.</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ يَدٌ وَهَذِهِ رِجْلٌ.</span><span class="rule-example-ru">Это рука, а это нога.</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ مِلْعَقَةٌ وَهَذِهِ قِدْرٌ.</span><span class="rule-example-ru">Это ложка, а это кастрюля.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Мужской род — правильная и неправильная формы автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">هَذِهِ أَنْفٌ، وَهَذِهِ فَمٌ. ✕</span><span class="rule-example-ru">Это нос, а это рот. Форма с <span dir="rtl" lang="ar">هَذِهِ</span> неверна.</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">هَذَا أَنْفٌ، وَهَذَا فَمٌ. ✓</span><span class="rule-example-ru">Это нос, а это рот. Форма с <span dir="rtl" lang="ar">هَذَا</span> верна.</span></div>
  </div></div>
</div>
$html$
when 1488 then $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 10</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">الْجُمْلَةُ الِاسْمِيَّةُ: تَتَكَوَّنُ مِنْ كَلِمَتَيْنِ تُفِيدَانِ مَعْنًى تَامًّا مُفِيدًا. وَتُسَمَّى جُمْلَةً مُفِيدَةً.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Именное предложение состоит из двух слов, которые передают полный полезный смысл. Оно называется полезным, законченным предложением.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все десять предложений автора</span><div class="tbl-wrap"><table><thead><tr><th>Арабское предложение</th><th>Полный русский перевод</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">مُحَمَّدٌ طَالِبٌ.</td><td>Мухаммад — студент.</td></tr>
    <tr><td dir="rtl" lang="ar">الْبَابُ مُغْلَقٌ.</td><td>Дверь закрыта.</td></tr>
    <tr><td dir="rtl" lang="ar">الْمِنْدِيلُ وَسِخٌ.</td><td>Платок грязный.</td></tr>
    <tr><td dir="rtl" lang="ar">هُوَ مُسْلِمٌ.</td><td>Он — мусульманин.</td></tr>
    <tr><td dir="rtl" lang="ar">ذَلِكَ قَمَرٌ.</td><td>То — луна.</td></tr>
    <tr><td dir="rtl" lang="ar">فَاطِمَةُ طَالِبَةٌ.</td><td>Фатима — студентка.</td></tr>
    <tr><td dir="rtl" lang="ar">النَّافِذَةُ مَفْتُوحَةٌ.</td><td>Окно открыто.</td></tr>
    <tr><td dir="rtl" lang="ar">الْقَهْوَةُ لَذِيذَةٌ.</td><td>Кофе вкусный.</td></tr>
    <tr><td dir="rtl" lang="ar">هِيَ مُسْلِمَةٌ.</td><td>Она — мусульманка.</td></tr>
    <tr><td dir="rtl" lang="ar">تِلْكَ شَمْسٌ.</td><td>То — солнце.</td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Согласование указательного имени — обе формы автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">حَقِيبَةُ مَنْ هَذَا؟ ✕</span><span class="rule-example-ru">Чья это сумка? Мужская форма <span dir="rtl" lang="ar">هَذَا</span> неверна.</span></div>
    <div class="rule-example-card rule-term-default"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">حَقِيبَةُ مَنْ هَذِهِ؟ ✓</span><span class="rule-example-ru">Чья это сумка? Женская форма <span dir="rtl" lang="ar">هَذِهِ</span> верна.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Согласование сказуемого — обе формы автора</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-role"><span class="rule-example-ar rule-table-invalid" dir="rtl" lang="ar">الْغُرْفَةُ مَفْتُوحٌ. ✕</span><span class="rule-example-ru">Комната открыта. Форма мужского рода <span dir="rtl" lang="ar">مَفْتُوحٌ</span> неверна.</span></div>
    <div class="rule-example-card rule-term-predicate"><span class="rule-example-ar rule-table-valid" dir="rtl" lang="ar">الْغُرْفَةُ مَفْتُوحَةٌ. ✓</span><span class="rule-example-ru">Комната открыта. Форма женского рода <span dir="rtl" lang="ar">مَفْتُوحَةٌ</span> верна.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Полный грамматический разбор автора</span><div class="tbl-wrap"><table><thead><tr><th>Предложение</th><th><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">الْمُبْتَدَأُ</span><span class="rule-table-ru">мубтада — начальный член</span></th><th><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">الْخَبَرُ</span><span class="rule-table-ru">хабар — сказуемое</span></th><th>Полный перевод разбора</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">مُحَمَّدٌ طَالِبٌ.</td><td dir="rtl" lang="ar">مُحَمَّدٌ: مُبْتَدَأٌ</td><td dir="rtl" lang="ar">طَالِبٌ: خَبَرٌ</td><td><span dir="rtl" lang="ar">مُحَمَّدٌ</span> — <span dir="rtl" lang="ar">مُبْتَدَأٌ</span> (мубтада, начальный член); <span dir="rtl" lang="ar">طَالِبٌ</span> — <span dir="rtl" lang="ar">خَبَرٌ</span> (хабар, сказуемое).</td></tr>
    <tr><td dir="rtl" lang="ar">تِلْكَ شَمْسٌ.</td><td dir="rtl" lang="ar">تِلْكَ: مُبْتَدَأٌ</td><td dir="rtl" lang="ar">شَمْسٌ: خَبَرٌ</td><td><span dir="rtl" lang="ar">تِلْكَ</span> — <span dir="rtl" lang="ar">مُبْتَدَأٌ</span> (мубтада, начальный член); <span dir="rtl" lang="ar">شَمْسٌ</span> — <span dir="rtl" lang="ar">خَبَرٌ</span> (хабар, сказуемое).</td></tr>
  </tbody></table></div></div>
</div>
$html$
else content
end
where course_name = 'Мединский курс (Том 1)'
  and id in (1476,1477,1478,1479,1480,1483,1484,1485,1486,1487,1488);

update public.rules
set rule_ar = 'كِتَابُ مَنْ هٰذَا؟ سُؤَالٌ عَنِ الْعَاقِلِ الْمَالِكِ لِلْكِتَابِ.'
where id = 1485
  and course_name = 'Мединский курс (Том 1)'
  and lesson_number = '5';

update public.rule_sources
set source_text = $source$( الْعَلَمُ الْمُؤَنَّثُ لَا يُنَوَّنُ )

مُحَمَّدٌ : عَائِشَةُ
عَمَّارٌ : آمِنَةُ
يَاسِرٌ : مَرْيَمُ
عَلِيٌّ : فَاطِمَةُ

عَائِشَةٌ ✕
آمِنَةٌ ✕
مَرْيَمٌ ✕
فَاطِمَةٌ ✕$source$
where rule_id = 1479
  and source_document = 'Sharkh_na_1_tom_Med_kursa.pdf'
  and source_page_from = 8
  and source_page_to = 8
  and sort_order = 1;

update public.rule_sources
set source_text = $source$حَقِيبَةُ مَنْ هَذَا؟ ✕
حَقِيبَةُ مَنْ هَذِهِ؟ ✓

الْغُرْفَةُ مَفْتُوحٌ ✕
الْغُرْفَةُ مَفْتُوحَةٌ ✓

مُحَمَّدٌ طَالِبٌ ( مُحَمَّدٌ : مُبْتَدَأٌ، طَالِبٌ : خَبَرٌ ) .
تِلْكَ شَمْسٌ ( تِلْكَ : مُبْتَدَأٌ، شَمْسٌ : خَبَرٌ ) .$source$
where rule_id = 1488
  and source_document = 'Sharkh_na_1_tom_Med_kursa.pdf'
  and source_page_from = 10
  and source_page_to = 10
  and sort_order = 3;

-- These examples are printed inside the idafa explanation, before the vocative block.
update public.rule_sources
set rule_id = 1483,
    sort_order = 3
where id = 166
  and rule_id = 1485
  and source_document = 'Sharkh_na_1_tom_Med_kursa.pdf'
  and source_page_from = 9
  and source_page_to = 9
  and sort_order = 2;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number in ('4','5','6')
    and id in (1476,1477,1478,1479,1480,1483,1484,1485,1486,1487,1488)
    and content like '%Полный текст шарха%'
    and content like '%dir="rtl" lang="ar"%';
  if v_count <> 11 then
    raise exception 'Full sharh/RTL verification failed: % of 11 cards', v_count;
  end if;

  if not exists (select 1 from public.rules where id = 1479 and content like '%عَائِشَةٌ. ✕%' and content like '%فَاطِمَةٌ. ✕%') then
    raise exception 'Lesson 4 feminine-name examples were not fully restored';
  end if;
  if not exists (select 1 from public.rules where id = 1483 and content like '%خَالُ حَامِدٍ فَقِيرٌ.%' and content like '%اسْمُ الْبِنْتِ زَيْنَبُ.%') then
    raise exception 'Lesson 5 additional idafa examples were not fully restored';
  end if;
  if not exists (select 1 from public.rules where id = 1488 and content like '%حَقِيبَةُ مَنْ هَذَا؟ ✕%' and content like '%هِيَ مُسْلِمَةٌ.%' and content like '%تِلْكَ شَمْسٌ.%') then
    raise exception 'Lesson 6 omitted nominal-sentence examples were not fully restored';
  end if;
  if (select count(*) from public.rules where id in (1476,1479,1483,1488) and content like '%<div class="tbl-wrap"><table%') <> 4 then
    raise exception 'Responsive table wrappers are missing';
  end if;
  if not exists (select 1 from public.rule_sources where rule_id = 1479 and sort_order = 1 and source_text like '%عَمَّارٌ : آمِنَةُ%' and source_text like '%مَرْيَمٌ ✕%') then
    raise exception 'Lesson 4 verbatim source expansion failed';
  end if;
  if not exists (select 1 from public.rule_sources where rule_id = 1488 and sort_order = 3 and source_text like '%حَقِيبَةُ مَنْ هَذَا؟ ✕%') then
    raise exception 'Lesson 6 verbatim source expansion failed';
  end if;
  if not exists (select 1 from public.rule_sources where id = 166 and rule_id = 1483 and sort_order = 3 and source_text like '%أَمْثِلَةٌ أُخْرَى لِلْمُضَافِ%') then
    raise exception 'Lesson 5 idafa source fragment was not attached to the idafa rule';
  end if;
  if exists (select 1 from public.rules where id in (1476,1477,1478,1479,1480,1483,1484,1485,1486,1487,1488) and content like '%موضع غير واضح%') then
    raise exception 'Unexpected unclear-source placeholder remains';
  end if;
end;
$$;

commit;
