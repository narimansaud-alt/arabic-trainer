-- Preserve the complete public Russian rendering of Book 1 lesson 13.
-- Controlling source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 19-22.

begin;

do $$
declare v_count integer;
begin
  select count(*) into v_count from public.rules
  where course_name = 'Мединский курс (Том 1)' and lesson_number = '13'
    and id in (1518,1519,1520,1521,1522,1523,1524,1882,1883);
  if v_count <> 9 then
    raise exception 'Expected nine guarded Book 1 lesson 13 rules, found %', v_count;
  end if;
end;
$$;

-- The idafa card previously compressed four printed analyses into one generic scheme.
update public.rules
set content = $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страницы 19–20</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">إِضَافَةُ الْأَسْمَاءِ إِلَى الِاسْمِ الظَّاهِرِ، وَالضَّمِيرِ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Присоединение имён в конструкции <span dir="rtl" lang="ar">إِضَافَةٌ</span> к явному имени и к местоимению.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker">Оба вида второго члена идафы</span><div class="rule-meaning-grid">
    <div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">الِاسْمُ الظَّاهِرُ، نَحْوُ: مُحَمَّدٍ، حَامِدٍ، أَصْدِقَاءٍ، الطُّلَّابِ... إِلَخْ.</span><span class="rule-term-ru"><span dir="rtl" lang="ar">الِاسْمُ الظَّاهِرُ</span> — явное имя, например: Мухаммад, Хамид, друзья, студенты и так далее.</span></div>
    <div class="rule-meaning-card rule-term-jarr"><span class="rule-term-ar" dir="rtl" lang="ar">الضَّمِيرُ، نَحْوُ: هُوَ، هُمْ، كَ، كِ (كَافُ الْمُخَاطَبِ)، ي (يَاءُ الْمُتَكَلِّمِ).</span><span class="rule-term-ru"><span dir="rtl" lang="ar">الضَّمِيرُ</span> — местоимение, например: <span dir="rtl" lang="ar">هُوَ</span> «он», <span dir="rtl" lang="ar">هُمْ</span> «они», <span dir="rtl" lang="ar">كَ، كِ</span> — каф собеседника, <span dir="rtl" lang="ar">ي</span> — йа говорящего.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْإِضَافَةُ إِلَى الِاسْمِ الظَّاهِرِ</span> (идафа к явному имени)</span><div class="rule-example-list">
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَبْنَاءُ مُحَمَّدٍ. زُمَلَاءُ حَامِدٍ. أَصْدِقَاءُ الْمُدَرِّسِ.</span><span class="rule-example-ru">Сыновья Мухаммада. Товарищи Хамида. Друзья преподавателя.</span></div>
    <div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَسْمَاءُ الطُّلَّابِ. كِتَابُ الْمُدِيرِ.</span><span class="rule-example-ru">Имена студентов. Книга директора.</span></div>
  </div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْإِضَافَةُ إِلَى الضَّمِيرِ</span> (идафа к местоимению)</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>С формой <span dir="rtl" lang="ar">أَبْنَاءُ</span></th><th>Полный русский перевод</th><th>С формой <span dir="rtl" lang="ar">كِتَابُ</span></th><th>Полный русский перевод</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">أَبْنَاؤُهُ</td><td>его сыновья</td><td dir="rtl" lang="ar">كِتَابُهُ</td><td>его книга</td></tr>
    <tr><td dir="rtl" lang="ar">أَبْنَاؤُهُمْ</td><td>их сыновья</td><td dir="rtl" lang="ar">كِتَابُهُمْ</td><td>их книга</td></tr>
    <tr><td dir="rtl" lang="ar">أَبْنَاؤُكَ</td><td>твои сыновья</td><td dir="rtl" lang="ar">كِتَابُكَ</td><td>твоя книга</td></tr>
    <tr><td dir="rtl" lang="ar">أَبْنَائِي</td><td>мои сыновья</td><td dir="rtl" lang="ar">كِتَابِي</td><td>моя книга</td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker">Все четыре разбора автора</span><div class="tbl-wrap"><table><thead><tr><th>Сочетание</th><th><span dir="rtl" lang="ar">مُضَافٌ</span><br>первый член идафы</th><th><span dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ</span><br>второй член идафы</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">أَبْنَاءُ مُحَمَّدٍ</td><td dir="rtl" lang="ar">أَبْنَاءُ: مُضَافٌ</td><td dir="rtl" lang="ar">مُحَمَّدٍ: مُضَافٌ إِلَيْهِ</td></tr>
    <tr><td dir="rtl" lang="ar">أَبْنَاؤُهُ</td><td dir="rtl" lang="ar">أَبْنَاؤُ: مُضَافٌ</td><td dir="rtl" lang="ar">ـهُ: مُضَافٌ إِلَيْهِ</td></tr>
    <tr><td dir="rtl" lang="ar">أَبْنَاؤُكَ</td><td dir="rtl" lang="ar">أَبْنَاؤُ: مُضَافٌ</td><td dir="rtl" lang="ar">ـكَ: مُضَافٌ إِلَيْهِ</td></tr>
    <tr><td dir="rtl" lang="ar">كِتَابِي</td><td dir="rtl" lang="ar">كِتَابُ: مُضَافٌ</td><td dir="rtl" lang="ar">ـِي: مُضَافٌ إِلَيْهِ</td></tr>
  </tbody></table></div></div>
</div>
$html$
where id = 1518 and course_name = 'Мединский курс (Том 1)' and lesson_number = '13';

-- The remaining concept cards already preserve every printed example; label the complete
-- source blocks explicitly and keep their existing, source-backed translations.
update public.rules
set content = regexp_replace(
  replace(
    content,
    '<span class="rule-card-kicker">Правило</span>',
    case id
      when 1520 then '<span class="rule-card-kicker">Полный текст шарха · страница 19</span>'
      when 1521 then '<span class="rule-card-kicker">Полный текст шарха · страница 19</span>'
      when 1522 then '<span class="rule-card-kicker">Полный текст шарха · страница 20</span>'
      when 1523 then '<span class="rule-card-kicker">Полный текст шарха · страница 21</span>'
      when 1519 then '<span class="rule-card-kicker">Полный текст шарха · страница 21</span>'
      when 1882 then '<span class="rule-card-kicker">Полный текст шарха · страница 21</span>'
      when 1524 then '<span class="rule-card-kicker">Полный текст шарха · страницы 21–22</span>'
    end
  ),
  '<p class="rule-study-text">',
  '<p class="rule-study-text"><strong>Полный перевод:</strong> '
)
where course_name = 'Мединский курс (Том 1)' and lesson_number = '13'
  and id in (1519,1520,1521,1522,1523,1524,1882)
  and content not like '%Полный текст шарха ·%';

-- The review card reproduces the three printed tables from page 22 with every heading translated.
update public.rules
set content = $html$
<div class="rule-study">
  <div class="rule-study-card">
    <span class="rule-card-kicker">Полный текст шарха · страница 22</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ. أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ. الْأَسْمَاءُ الْمَوْصُولَةُ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> Указательные имена для близкого; указательные имена для далёкого; относительные имена.</p>
  </div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ</span> (указательные имена для близкого)</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Единственное число</th><th>Примеры</th><th>Разумное множественное</th><th>Пример</th></tr></thead><tbody>
    <tr><td><span dir="rtl" lang="ar">الْمُفْرَدُ الْمُذَكَّرُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ</span><br>ед. ч., м. р., разумное и неразумное</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذَا رَجُلٌ، هَذَا كِتَابٌ</span><span class="rule-table-ru">Это мужчина; это книга.</span></td><td><span dir="rtl" lang="ar">الْجَمْعُ الْمُذَكَّرُ الْعَاقِلُ</span><br>мн. ч., м. р., разумное</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَؤُلَاءِ رِجَالٌ</span><span class="rule-table-ru">Это мужчины.</span></td></tr>
    <tr><td><span dir="rtl" lang="ar">الْمُفْرَدُ الْمُؤَنَّثُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ</span><br>ед. ч., ж. р., разумное и неразумное</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذِهِ امْرَأَةٌ، هَذِهِ سَيَّارَةٌ</span><span class="rule-table-ru">Это женщина; это машина.</span></td><td><span dir="rtl" lang="ar">الْجَمْعُ الْمُؤَنَّثُ الْعَاقِلُ</span><br>мн. ч., ж. р., разумное</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَؤُلَاءِ نِسَاءٌ</span><span class="rule-table-ru">Это женщины.</span></td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ</span> (указательные имена для далёкого)</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Единственное число</th><th>Примеры</th><th>Разумное множественное</th><th>Пример</th></tr></thead><tbody>
    <tr><td><span dir="rtl" lang="ar">الْمُفْرَدُ الْمُذَكَّرُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ</span><br>ед. ч., м. р., разумное и неразумное</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ذَلِكَ رَجُلٌ، ذَلِكَ كِتَابٌ</span><span class="rule-table-ru">То — мужчина; то — книга.</span></td><td><span dir="rtl" lang="ar">الْجَمْعُ الْمُذَكَّرُ الْعَاقِلُ</span><br>мн. ч., м. р., разумное</td><td><span class="rule-table-ar" dir="rtl" lang="ar">أُولَئِكَ رِجَالٌ</span><span class="rule-table-ru">Те — мужчины.</span></td></tr>
    <tr><td><span dir="rtl" lang="ar">الْمُفْرَدُ الْمُؤَنَّثُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ</span><br>ед. ч., ж. р., разумное и неразумное</td><td><span class="rule-table-ar" dir="rtl" lang="ar">تِلْكَ امْرَأَةٌ، تِلْكَ سَيَّارَةٌ</span><span class="rule-table-ru">Та — женщина; то — машина.</span></td><td><span dir="rtl" lang="ar">الْجَمْعُ الْمُؤَنَّثُ الْعَاقِلُ</span><br>мн. ч., ж. р., разумное</td><td><span class="rule-table-ar" dir="rtl" lang="ar">أُولَئِكَ نِسَاءٌ</span><span class="rule-table-ru">Те — женщины.</span></td></tr>
  </tbody></table></div></div>
  <div class="rule-study-card"><span class="rule-card-kicker"><span dir="rtl" lang="ar">الْأَسْمَاءُ الْمَوْصُولَةُ</span> (относительные имена)</span><div class="tbl-wrap"><table class="rule-bilingual-table"><thead><tr><th>Разряд</th><th>Все примеры автора</th><th>Полный русский перевод</th></tr></thead><tbody>
    <tr><td><span dir="rtl" lang="ar">الْمُفْرَدُ الْمُذَكَّرُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ</span><br>ед. ч., м. р., разумное и неразумное</td><td dir="rtl" lang="ar">الطَّالِبُ الَّذِي ذَهَبَ مِنْ لِيبِيَا، الْكِتَابُ الَّذِي مَعَكَ كِتَابِي</td><td>Студент, который уехал из Ливии; книга, которая у тебя, — моя книга.</td></tr>
    <tr><td><span dir="rtl" lang="ar">الْمُفْرَدُ الْمُؤَنَّثُ الْعَاقِلُ وَغَيْرُ الْعَاقِلِ</span><br>ед. ч., ж. р., разумное и неразумное</td><td dir="rtl" lang="ar">الطَّالِبَةُ الَّتِي ذَهَبَتْ مِنَ السُّودَانِ، الْحَقِيبَةُ الَّتِي مَعَكَ حَقِيبَتِي</td><td>Студентка, которая уехала из Судана; сумка, которая у тебя, — моя сумка.</td></tr>
  </tbody></table></div></div>
</div>
$html$
where id = 1883 and course_name = 'Мединский курс (Том 1)' and lesson_number = '13';

-- Make every pre-existing wide table mobile-safe without duplicating wrappers on rerun.
update public.rules
set content = replace(replace(content, '<table', '<div class="tbl-wrap"><table'), '</table>', '</table></div>')
where course_name = 'Мединский курс (Том 1)' and lesson_number = '13'
  and id in (1519,1520,1521,1522,1523,1524,1882)
  and content like '%<table%'
  and content not like '%<div class="tbl-wrap"><table%';

-- Remove an explanatory alternative that was not printed in the source; retain only the source-backed reason.
update public.rules
set content = replace(
  content,
  'Неверно: для неразумного множественного «книги» употребляется форма единственного женского рода <span dir="rtl" lang="ar">تِلْكَ</span>.',
  'Неверно: <span dir="rtl" lang="ar">أُولَئِكَ</span> здесь соединено с неразумным множественным <span dir="rtl" lang="ar">كُتُبٌ</span>.'
)
where id = 1524 and course_name = 'Мединский курс (Том 1)' and lesson_number = '13';

do $$
begin
  if (select count(*) from public.rules where id in (1518,1519,1520,1521,1522,1523,1524,1882,1883) and content like '%Полный текст шарха ·%') <> 9 then
    raise exception 'Book 1 lesson 13 full-sharh markers are incomplete';
  end if;
  if not exists (select 1 from public.rules where id = 1518 and content like '%أَبْنَاءُ مُحَمَّدٍ%' and content like '%أَبْنَاؤُهُ%' and content like '%أَبْنَاؤُكَ%' and content like '%كِتَابِي%') then
    raise exception 'Book 1 lesson 13 must preserve all four idafa analyses';
  end if;
  if not exists (select 1 from public.rules where id = 1883 and content like '%أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ%' and content like '%أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ%' and content like '%الْأَسْمَاءُ الْمَوْصُولَةُ%') then
    raise exception 'Book 1 lesson 13 review tables are incomplete';
  end if;
end;
$$;

commit;
