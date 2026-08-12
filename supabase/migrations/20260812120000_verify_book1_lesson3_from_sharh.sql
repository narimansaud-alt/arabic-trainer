-- Verify Medina Book 1 lesson 3 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 6-7.

begin;

do $migration$
declare
  target_rule_id bigint;
begin
  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '3'
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '3'
    and sort_order = 1;

  update public.rules
  set
    title = 'أَلْ وَحَذْفُ التَّنْوِينِ (определённый артикль и удаление танвина)',
    rule_ar = 'أَلْ حَرْفُ تَعْرِيفٍ، وَيُحْذَفُ التَّنْوِينُ مِنَ الِاسْمِ عِنْدَ دُخُولِهَا عَلَيْهِ.',
    summary = 'أَلْ حَرْفُ تَعْرِيفٍ، وَيُحْذَفُ التَّنْوِينُ مِنَ الِاسْمِ عِنْدَ دُخُولِهَا عَلَيْهِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">أَلْ حَرْفُ تَعْرِيفٍ، وَيُحْذَفُ التَّنْوِينُ مِنَ الِاسْمِ عِنْدَ دُخُولِهَا عَلَيْهِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">أَلْ</span> — определённый артикль. Когда он входит в имя, танвин удаляется.</p></div><div class="rule-study-card"><span class="rule-card-kicker">До и после</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">بَيْتٌ ← الْبَيْتُ</span><span class="rule-term-ru">дом → определённый дом</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">مَسْجِدٌ ← الْمَسْجِدُ</span><span class="rule-term-ru">мечеть → определённая мечеть</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">قَلَمٌ ← الْقَلَمُ</span><span class="rule-term-ru">ручка → определённая ручка</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">الْقَلَمُ مَكْسُورٌ.</span><span class="rule-example-ru">Ручка сломана.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">الْبَابُ مَفْتُوحٌ.</span><span class="rule-example-ru">Дверь открыта.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">الْوَلَدُ جَالِسٌ.</span><span class="rule-example-ru">Мальчик сидит.</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$أَلْ : حَرْفُ تَعْرِيفٍ .

بَيْتٌ : الْبَيْتُ
مَسْجِدٌ : الْمَسْجِدُ
قَلَمٌ : الْقَلَمُ

( يُحْذَفُ التَّنْوِينُ عِنْدَ دُخُولِ أَلْ ) .$$,
      6,
      6,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْقَلَمُ مَكْسُورٌ ✓
الْبَابُ مَفْتُوحٌ ✓
الْوَلَدُ جَالِسٌ ✓$$,
      6,
      6,
      2
    );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '3'
    and sort_order = 2;

  update public.rules
  set
    title = 'النَّكِرَةُ وَالْمَعْرِفَةُ (неопределённое и определённое имя)',
    rule_ar = 'النَّكِرَةُ تَدُلُّ عَلَى شَيْءٍ غَيْرِ مُعَيَّنٍ، وَالْمَعْرِفَةُ تَدُلُّ عَلَى شَيْءٍ مُعَيَّنٍ.',
    summary = 'النَّكِرَةُ تَدُلُّ عَلَى شَيْءٍ غَيْرِ مُعَيَّنٍ، وَالْمَعْرِفَةُ تَدُلُّ عَلَى شَيْءٍ مُعَيَّنٍ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">النَّكِرَةُ تَدُلُّ عَلَى شَيْءٍ غَيْرِ مُعَيَّنٍ، وَالْمَعْرِفَةُ تَدُلُّ عَلَى شَيْءٍ مُعَيَّنٍ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">النَّكِرَةُ</span> обозначает неопределённый предмет, а <span dir="rtl" lang="ar">الْمَعْرِفَةُ</span> — определённый предмет.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Сравнение</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">بَيْتٌ، قَلَمٌ، رَجُلٌ، بِنْتٌ</span><span class="rule-term-ru">неопределённые: дом, ручка, мужчина, девочка</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">الْبَيْتُ، الْقَلَمُ، الرَّجُلُ، الْبِنْتُ</span><span class="rule-term-ru">определённые: дом, ручка, мужчина, девочка</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Смысл</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">بَيْتٌ</span><span class="rule-example-ru">охватывает любой дом и не указывает на конкретный дом</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">الْبَيْتُ</span><span class="rule-example-ru">указывает на конкретный дом</span></div></div></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values (
    target_rule_id,
    'Sharkh_na_1_tom_Med_kursa.pdf',
    $$النَّكِرَةُ : شَيْءٌ غَيْرُ مُعَيَّنٍ، نَحْوُ : بَيْتٌ، قَلَمٌ، رَجُلٌ، بِنْتٌ .
الْمَعْرِفَةُ : شَيْءٌ مُعَيَّنٌ، نَحْوُ : الْبَيْتُ، الْقَلَمُ، الرَّجُلُ، الْبِنْتُ .

بَيْتٌ : يَشْمَلُ كُلَّ الْبُيُوتِ، وَلَيْسَ بَيْتًا مُعَيَّنًا .
الْبَيْتُ : يَدُلُّ عَلَى بَيْتٍ مُعَيَّنٍ بِذَاتِهِ .$$,
    6,
    6,
    1
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '3'
    and sort_order = 3;

  update public.rules
  set
    title = 'الْحُرُوفُ الْقَمَرِيَّةُ وَالْحُرُوفُ الشَّمْسِيَّةُ (лунные и солнечные буквы)',
    rule_ar = 'فِي الْحُرُوفِ الْقَمَرِيَّةِ يُنْطَقُ السُّكُونُ عَلَى اللَّامِ، وَفِي الْحُرُوفِ الشَّمْسِيَّةِ لَا يُنْطَقُ السُّكُونُ عَلَى اللَّامِ وَتُوضَعُ شَدَّةٌ عَلَى الْحَرْفِ الَّذِي بَعْدَهُ.',
    summary = 'فِي الْحُرُوفِ الْقَمَرِيَّةِ يُنْطَقُ السُّكُونُ عَلَى اللَّامِ، وَفِي الْحُرُوفِ الشَّمْسِيَّةِ لَا يُنْطَقُ السُّكُونُ عَلَى اللَّامِ وَتُوضَعُ شَدَّةٌ عَلَى الْحَرْفِ الَّذِي بَعْدَهُ.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">فِي الْحُرُوفِ الْقَمَرِيَّةِ يُنْطَقُ السُّكُونُ عَلَى اللَّامِ، وَفِي الْحُرُوفِ الشَّمْسِيَّةِ لَا يُنْطَقُ السُّكُونُ عَلَى اللَّامِ وَتُوضَعُ شَدَّةٌ عَلَى الْحَرْفِ الَّذِي بَعْدَهُ.</span><p class="rule-study-text">Перед лунной буквой <span dir="rtl" lang="ar">لْ</span> артикля произносится. Перед солнечной буквой <span dir="rtl" lang="ar">لْ</span> не произносится, а следующая буква получает <span dir="rtl" lang="ar">شَدَّةً</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Лунные буквы</span><table><thead><tr><th>Буква</th><th>Пример</th><th>Перевод</th></tr></thead><tbody><tr><td>أ</td><td dir="rtl" lang="ar">الْأَبُ</td><td>отец</td></tr><tr><td>ب</td><td dir="rtl" lang="ar">الْبَابُ</td><td>дверь</td></tr><tr><td>ج</td><td dir="rtl" lang="ar">الْجَنَّةُ</td><td>рай</td></tr><tr><td>ح</td><td dir="rtl" lang="ar">الْحِمَارُ</td><td>осёл</td></tr><tr><td>خ</td><td dir="rtl" lang="ar">الْخُبْزُ</td><td>хлеб</td></tr><tr><td>ع</td><td dir="rtl" lang="ar">الْعَيْنُ</td><td>глаз</td></tr><tr><td>غ</td><td dir="rtl" lang="ar">الْغِذَاءُ</td><td>пища</td></tr><tr><td>ف</td><td dir="rtl" lang="ar">الْفَمُ</td><td>рот</td></tr><tr><td>ق</td><td dir="rtl" lang="ar">الْقَمَرُ</td><td>луна</td></tr><tr><td>ك</td><td dir="rtl" lang="ar">الْكَلْبُ</td><td>собака</td></tr><tr><td>م</td><td dir="rtl" lang="ar">الْمَاءُ</td><td>вода</td></tr><tr><td>و</td><td dir="rtl" lang="ar">الْوَلَدُ</td><td>мальчик</td></tr><tr><td>هـ</td><td dir="rtl" lang="ar">الْهَوَاءُ</td><td>воздух</td></tr><tr><td>ي</td><td dir="rtl" lang="ar">الْيَدُ</td><td>рука</td></tr></tbody></table></div><div class="rule-study-card"><span class="rule-card-kicker">Солнечные буквы</span><table><thead><tr><th>Буква</th><th>Пример</th><th>Перевод</th></tr></thead><tbody><tr><td>ت</td><td dir="rtl" lang="ar">التَّاجِرُ</td><td>торговец</td></tr><tr><td>ث</td><td dir="rtl" lang="ar">الثَّوْبُ</td><td>одежда</td></tr><tr><td>د</td><td dir="rtl" lang="ar">الدِّيكُ</td><td>петух</td></tr><tr><td>ذ</td><td dir="rtl" lang="ar">الذَّهَبُ</td><td>золото</td></tr><tr><td>ر</td><td dir="rtl" lang="ar">الرَّجُلُ</td><td>мужчина</td></tr><tr><td>ز</td><td dir="rtl" lang="ar">الزَّهْرَةُ</td><td>цветок</td></tr><tr><td>س</td><td dir="rtl" lang="ar">السَّمَكُ</td><td>рыба</td></tr><tr><td>ش</td><td dir="rtl" lang="ar">الشَّمْسُ</td><td>солнце</td></tr><tr><td>ص</td><td dir="rtl" lang="ar">الصَّدْرُ</td><td>грудь</td></tr><tr><td>ض</td><td dir="rtl" lang="ar">الضَّيْفُ</td><td>гость</td></tr><tr><td>ط</td><td dir="rtl" lang="ar">الطَّالِبُ</td><td>студент</td></tr><tr><td>ظ</td><td dir="rtl" lang="ar">الظَّهْرُ</td><td>спина</td></tr><tr><td>ل</td><td dir="rtl" lang="ar">اللَّحْمُ</td><td>мясо</td></tr><tr><td>ن</td><td dir="rtl" lang="ar">النَّجْمُ</td><td>звезда</td></tr></tbody></table></div></div>$$
  where id = target_rule_id;

  delete from public.rule_sources where rule_id = target_rule_id;
  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْحُرُوفُ الْقَمَرِيَّةُ : يُنْطَقُ السُّكُونُ عَلَى اللَّامِ ( الْقَمَرُ ) .
الْحُرُوفُ الشَّمْسِيَّةُ : لَا يُنْطَقُ السُّكُونُ عَلَى اللَّامِ، وَتُوضَعُ شَدَّةٌ عَلَى الْحَرْفِ الَّذِي بَعْدَهُ ( الشَّمْسُ ) .$$,
      6,
      6,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$الْحُرُوفُ الْقَمَرِيَّةُ، هِيَ :
أ : الْأَبُ
ب : الْبَابُ
ج : الْجَنَّةُ
ح : الْحِمَارُ
خ : الْخُبْزُ
ع : الْعَيْنُ
غ : الْغِذَاءُ
ف : الْفَمُ
ق : الْقَمَرُ
ك : الْكَلْبُ
م : الْمَاءُ
و : الْوَلَدُ
هـ : الْهَوَاءُ
ي : الْيَدُ

الْحُرُوفُ الشَّمْسِيَّةُ، هِيَ :
ت : التَّاجِرُ
ث : الثَّوْبُ
د : الدِّيكُ
ذ : الذَّهَبُ
ر : الرَّجُلُ
ز : الزَّهْرَةُ
س : السَّمَكُ
ش : الشَّمْسُ
ص : الصَّدْرُ
ض : الضَّيْفُ
ط : الطَّالِبُ
ظ : الظَّهْرُ
ل : اللَّحْمُ
ن : النَّجْمُ$$,
      7,
      7,
      2
    );
end;
$migration$;

commit;
