-- Verify Medina Book 2 lesson 16 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 36-39.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 31-33.
-- The second PDF has a damaged logical text layer. Its source_text below is a
-- literal manual transcription from the rendered pages, authorized by the owner.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
  rule_4_id bigint;
  rule_5_id bigint;
  rule_6_id bigint;
  rule_7_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '16';

  if lesson_rule_count not in (6, 7) then
    raise exception 'Expected 6 or 7 Book 2 lesson 16 rules, found %', lesson_rule_count;
  end if;

  if lesson_rule_count = 6 then
    -- Preserve the six production rows and split the old combined last block.
    select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 1;
    select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 2;
    select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 3;
    select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 4;
    select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 5;
    select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 6;

    update public.rules
    set sort_order = sort_order + 100
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '16';

    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values
      ('Мединский курс (Том 2)', '16', '', '', 7, 'rule', '', '')
    returning id into rule_7_id;
  else
    select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 1;
    select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 2;
    select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 3;
    select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 4;
    select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 5;
    select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 6;
    select id into strict rule_7_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '16' and sort_order = 7;
  end if;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '16'
  );

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id, rule_7_id);

  -- 1. Complete conjugation of arada/yuridu and attribution of the present forms.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'أَرَادَ ـ يُرِيدُ (хотеть)',
    rule_ar = 'يُصَرَّفُ الْفِعْلُ «أَرَادَ ـ يُرِيدُ» مَعَ الضَّمَائِرِ، وَيَكُونُ فَاعِلُهُ اسْمًا ظَاهِرًا، أَوْ ضَمِيرًا مُسْتَتِرًا، أَوْ وَاوَ الْجَمَاعَةِ، أَوْ يَاءَ الْمُخَاطَبَةِ، أَوْ نُونَ النِّسْوَةِ.',
    summary = 'Полная таблица форм глагола «хотеть» в прошедшем и настоящем/будущем времени, а также способы выражения исполнителя действия.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Правило из двух шархов</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">يُصَرَّفُ <span class="ar-tone-verb">الْفِعْلُ «أَرَادَ ـ يُرِيدُ»</span> مَعَ الضَّمَائِرِ، وَيَكُونُ <span class="ar-tone-subject">فَاعِلُهُ</span> اسْمًا ظَاهِرًا، أَوْ ضَمِيرًا مُسْتَتِرًا، أَوْ وَاوَ الْجَمَاعَةِ، أَوْ يَاءَ الْمُخَاطَبَةِ، أَوْ نُونَ النِّسْوَةِ.</span>
        <p class="rule-study-text">Глагол <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">أَرَادَ ـ يُرِيدُ</span> — «хотеть» — изменяется по местоимениям. Исполнитель выражается явным именем, скрытым местоимением либо присоединённым местоимением.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полная таблица форм</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th>Прошедшее время</th><th>Настоящее/будущее время</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَدْتُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أُرِيدُ</span></td><td>я хотел / хочу</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَدْتَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تُرِيدُ</span></td><td>ты хотел / хочешь</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَدْتِ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تُرِيدِينَ</span></td><td>ты хотела / хочешь</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَادَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يُرِيدُ</span></td><td>он хотел / хочет</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَادَتْ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تُرِيدُ</span></td><td>она хотела / хочет</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَدْنَا</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نُرِيدُ</span></td><td>мы хотели / хотим</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَدْتُمْ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تُرِيدُونَ</span></td><td>вы хотели / хотите</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَدْتُنَّ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تُرِدْنَ</span></td><td>вы хотели / хотите</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَادُوا</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يُرِيدُونَ</span></td><td>они хотели / хотят</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span><span class="rule-table-ru">они, женщины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرَدْنَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يُرِدْنَ</span></td><td>они хотели / хотят</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Кто является исполнителем</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Пример</th><th>Исполнитель по-арабски</th><th>Русское объяснение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">حَامِدٌ يُرِيدُ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هُوَ»</span></td><td>Скрытое местоимение «он».</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الطُّلَّابُ يُرِيدُونَ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span></td><td><span class="ar-inline" dir="rtl" lang="ar">وَاوٌ</span> множественного числа.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">آمِنَةُ تُرِيدُ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هِيَ»</span></td><td>Скрытое местоимение «она».</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الطَّالِبَاتُ يُرِدْنَ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span></td><td><span class="ar-inline" dir="rtl" lang="ar">نُونٌ</span> женского множественного числа.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَنْتَ تُرِيدُ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنْتَ»</span></td><td>Скрытое местоимение «ты», мужчина.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَنْتُمْ تُرِيدُونَ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span></td><td><span class="ar-inline" dir="rtl" lang="ar">وَاوٌ</span> множественного числа.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَنْتِ تُرِيدِينَ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span></td><td><span class="ar-inline" dir="rtl" lang="ar">يَاءٌ</span> обращения к женщине.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَنْتُنَّ تُرِدْنَ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span></td><td><span class="ar-inline" dir="rtl" lang="ar">نُونٌ</span> женского множественного числа.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَنَا أُرِيدُ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنَا»</span></td><td>Скрытое местоимение «я».</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَحْنُ نُرِيدُ.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «نَحْنُ»</span></td><td>Скрытое местоимение «мы».</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$إسناد الفعل «أراد - يريد» إلى الضمائر
أنا أردت | أنا أريد
أنت أردت | أنت تريد
أنت أردت | أنت تريدين
هو أراد | هو يريد
هي أرادت | هي تريد
نحن أردنا | نحن نريد
أنتم أردتم | أنتم تريدون
أنتن أردتن | أنتن تردن
هم أرادوا | هم يريدون
هن أردن | هن يردن$$, 36, 36, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إِسْنَادُ الْفِعْلِ «يُرِيدُ» إِلَى الضَّمَائِرِ
حَامِدٌ يُرِيدُ | ضَمِيرٌ مُسْتَتِرٌ (هُوَ)
الطُّلَّابُ يُرِيدُونَ | وَاوُ الْجَمَاعَةِ
آمِنَةُ تُرِيدُ | ضَمِيرٌ مُسْتَتِرٌ (هِيَ)
الطَّالِبَاتُ يُرِدْنَ | نُونُ النِّسْوَةِ
أَنْتَ تُرِيدُ | ضَمِيرٌ مُسْتَتِرٌ (أَنْتَ)
أَنْتُمْ تُرِيدُونَ | وَاوُ الْجَمَاعَةِ
أَنْتِ تُرِيدِينَ | يَاءُ الْمُخَاطَبَةِ
أَنْتُنَّ تُرِدْنَ | نُونُ النِّسْوَةِ
أَنَا أُرِيدُ | ضَمِيرٌ مُسْتَتِرٌ (أَنَا)
نَحْنُ نُرِيدُ | ضَمِيرٌ مُسْتَتِرٌ (نَحْنُ)$$, 31, 31, 2);

  -- 2. Masculine, feminine, and plural color patterns.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'جَمْعُ أَفْعَلَ الَّذِي مُؤَنَّثُهُ فَعْلَاءُ (цвета типа أَفْعَلُ)',
    rule_ar = 'إِذَا كَانَ اللَّوْنُ عَلَى وَزْنِ أَفْعَلَ كَانَ مُؤَنَّثُهُ عَلَى وَزْنِ فَعْلَاءَ، وَجَمْعُهُمَا عَلَى وَزْنِ فُعْلٍ، وَأَفْعَلُ وَفَعْلَاءُ مَمْنُوعَانِ مِنَ الصَّرْفِ.',
    summary = 'Цвет типа أَفْعَلُ образует женскую форму по модели فَعْلَاءُ и общий тип множественного числа فُعْلٌ; формы أَفْعَلُ и فَعْلَاءُ не принимают танвин.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Модели форм</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">إِذَا كَانَ <span class="ar-tone-structure">اللَّوْنُ</span> عَلَى وَزْنِ <span class="ar-tone-raf">أَفْعَلَ</span> كَانَ مُؤَنَّثُهُ عَلَى وَزْنِ <span class="ar-tone-nasb">فَعْلَاءَ</span>، وَجَمْعُهُمَا عَلَى وَزْنِ <span class="ar-tone-subject">فُعْلٍ</span>.</span>
        <p class="rule-study-text">Если название цвета имеет мужскую модель <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">أَفْعَلُ</span>, его женская форма строится по модели <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">فَعْلَاءُ</span>, а общий тип множественного числа — <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">فُعْلٌ</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Таблица цветов</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Мужской род</th><th>Женский род</th><th>Множественное число</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">أَبْيَضُ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">بَيْضَاءُ</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">بِيضٌ</span><span class="rule-table-ru">исходная модель: <span class="ar-inline" dir="rtl" lang="ar">بُيْضٌ</span></span></td><td>белый / белая / белые</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">أَسْوَدُ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">سَوْدَاءُ</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">سُودٌ</span></td><td>чёрный / чёрная / чёрные</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">أَحْمَرُ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">حَمْرَاءُ</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">حُمْرٌ</span></td><td>красный / красная / красные</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">أَزْرَقُ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">زَرْقَاءُ</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">زُرْقٌ</span></td><td>синий / синяя / синие</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">أَخْضَرُ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">خَضْرَاءُ</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">خُضْرٌ</span></td><td>зелёный / зелёная / зелёные</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">أَصْفَرُ</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">صَفْرَاءُ</span></td><td>—</td><td>жёлтый / жёлтая</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Примеры второго шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لِحْيَةُ إِبْرَاهِيمَ <span class="ar-tone-nasb">بَيْضَاءُ</span> وَلِحْيَتُكَ <span class="ar-tone-nasb">سَوْدَاءُ</span>.</span><span class="rule-example-ru">Борода Ибрахима белая, а твоя борода чёрная.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ السَّيَّارَةُ <span class="ar-tone-nasb">خَضْرَاءُ</span> وَتِلْكَ <span class="ar-tone-nasb">زَرْقَاءُ</span>.</span><span class="rule-example-ru">Эта машина зелёная, а та — синяя.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الْقَلَمُ <span class="ar-tone-raf">الْأَحْمَرُ</span> جَمِيلٌ وَتِلْكَ الْحَقِيبَةُ <span class="ar-tone-nasb">الْحَمْرَاءُ</span> جَمِيلَةٌ.</span><span class="rule-example-ru">Эта красная ручка красивая, и та красная сумка красивая.</span></div>
        </div>
      </div>
      <div class="rule-check-card"><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">أَفْعَلُ</span> وَ<span class="ar-tone-nasb">فَعْلَاءُ</span> مَمْنُوعَانِ مِنَ الصَّرْفِ.</span><span>Формы <span class="ar-inline" dir="rtl" lang="ar">أَفْعَلُ</span> и <span class="ar-inline" dir="rtl" lang="ar">فَعْلَاءُ</span> относятся к словам, не принимающим танвин.</span></div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$جمع «أفعل» الذي مؤنثه «فعلاء»
المذكر: أفعل | المؤنث: فعلاء | الجمع للمذكر والمؤنث: فعل
أبيض | بيضاء | بيض (أصله: بيض)
أسود | سوداء | سود
أحمر | حمراء | حمر
أزرق | زرقاء | زرق
أخضر | خضراء | خضر$$, 36, 36, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$أَحْمَرُ | حَمْرَاءُ
أَبْيَضُ | بَيْضَاءُ
أَسْوَدُ | سَوْدَاءُ
أَصْفَرُ | صَفْرَاءُ
لِحْيَةُ إِبْرَاهِيمَ بَيْضَاءُ وَلِحْيَتُكَ سَوْدَاءُ.
هَذِهِ السَّيَّارَةُ خَضْرَاءُ وَتِلْكَ زَرْقَاءُ.
هَذَا الْقَلَمُ الْأَحْمَرُ جَمِيلٌ وَتِلْكَ الْحَقِيبَةُ الْحَمْرَاءُ جَمِيلَةٌ.
أَفْعَلُ وَفَعْلَاءُ مَمْنُوعَانِ مِنَ الصَّرْفِ.$$, 31, 31, 2);

  -- 3. Adjusted proper nouns and the full Umar/Amr comparison.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'الْعَلَمُ الْمَعْدُولُ عَلَى وَزْنِ فُعَلَ (изменённое имя модели فُعَلُ)',
    rule_ar = 'الْعَلَمُ الْمَعْدُولُ عَلَى وَزْنِ فُعَلَ مَمْنُوعٌ مِنَ الصَّرْفِ، فَيُرْفَعُ بِالضَّمَّةِ، وَيُنْصَبُ وَيُجَرُّ بِالْفَتْحَةِ. وَيُكْتَبُ فِي آخِرِ «عَمْرٍو» وَاوٌ لِلتَّفْرِيقِ بَيْنَهُ وَبَيْنَ «عُمَرَ»، وَتَنْقَلِبُ هَذِهِ الْوَاوُ أَلِفًا فِي حَالَةِ النَّصْبِ.',
    summary = 'Изменённое собственное имя модели فُعَلُ не принимает танвин; карточка также показывает четыре различия между عُمَرُ и عَمْرٌو.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Правило</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الْعَلَمُ الْمَعْدُولُ عَلَى وَزْنِ فُعَلَ</span> مَمْنُوعٌ مِنَ الصَّرْفِ، فَيُرْفَعُ <span class="ar-tone-raf">بِالضَّمَّةِ</span>، وَيُنْصَبُ وَيُجَرُّ <span class="ar-tone-nasb">بِالْفَتْحَةِ</span>.</span>
        <p class="rule-study-text">Изменённое собственное имя по модели <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">فُعَلُ</span> не принимает танвин: именительный падеж обозначается даммой, а винительный и родительный — фатхой.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Примеры изменённых имён</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Имя</th><th>Что обозначает</th><th>Предполагаемая исходная форма</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">عُمَرُ</span></td><td>имя человека</td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَامِرٌ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">زُفَرُ</span></td><td>имя человека</td><td><span class="rule-table-ar" dir="rtl" lang="ar">زَافِرٌ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُبَلُ</span></td><td>название идола</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَابِلٌ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">زُحَلُ</span></td><td>планета Сатурн</td><td><span class="rule-table-ar" dir="rtl" lang="ar">زَاحِلٌ</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-check-card"><span class="ar-inline" dir="rtl" lang="ar">قِيلَ إِنَّ أُصُولَهَا هَذِهِ الْأَلْفَاظُ.</span> Второй шарх передаёт эти исходные формы с оговоркой «было сказано», а не как бесспорное утверждение.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре различия между عُمَرُ и عَمْرٌو</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Признак</th><th><span class="rule-table-ar" dir="rtl" lang="ar">عُمَرُ</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">عَمْرٌو</span></th></tr></thead>
          <tbody>
            <tr><td>Танвин</td><td>не принимает танвин</td><td>принимает танвин</td></tr>
            <tr><td>Написание</td><td>без добавочной буквы</td><td>добавочная <span class="ar-inline" dir="rtl" lang="ar">وَاوٌ</span> отличает имя на письме</td></tr>
            <tr><td>Падежные показатели</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ضَمَّةٌ، فَتْحَةٌ، فَتْحَةٌ</span><span class="rule-table-ru">дамма, фатха, фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ضَمَّةٌ، فَتْحَةٌ، كَسْرَةٌ</span><span class="rule-table-ru">дамма, фатха, касра</span></td></tr>
            <tr><td>Добавочная буква</td><td>—</td><td><span class="ar-inline" dir="rtl" lang="ar">وَاوٌ</span> остаётся в именительном и родительном; в винительном заменяется на <span class="ar-inline" dir="rtl" lang="ar">أَلِفٌ</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Падежные формы</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th>عَمْرٌو</th><th>عُمَرُ</th></tr></thead>
          <tbody>
            <tr><td>Именительный</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">عَمْرٌو</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">عُمَرُ</span></td></tr>
            <tr><td>Винительный</td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">عَمْرًا</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">عُمَرَ</span></td></tr>
            <tr><td>Родительный</td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">عَمْرٍو</span></td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">عُمَرَ</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِسْمِي <span class="ar-tone-raf">عُمَرُ</span>.</span><span class="rule-example-ru">Меня зовут Умар.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عُمَرَ</span>.</span><span class="rule-example-ru">Я видел Умара.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">عُمَرَ</span>.</span><span class="rule-example-ru">Я поприветствовал Умара.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِسْمِي <span class="ar-tone-raf">عَمْرٌو</span>.</span><span class="rule-example-ru">Меня зовут Амр.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عَمْرًا</span>.</span><span class="rule-example-ru">Я видел Амра.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">عَمْرٍو</span>.</span><span class="rule-example-ru">Я поприветствовал Амра.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ <span class="ar-tone-raf">عَمْرٌو</span> وَأَيْنَ <span class="ar-tone-raf">عُمَرُ</span>؟</span><span class="rule-example-ru">Где Амр и где Умар?</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عَمْرًا</span> وَ<span class="ar-tone-nasb">عُمَرَ</span>.</span><span class="rule-example-ru">Я видел Амра и Умара.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبْتُ إِلَى <span class="ar-tone-jarr">عَمْرٍو</span> وَ<span class="ar-tone-jarr">عُمَرَ</span>.</span><span class="rule-example-ru">Я пошёл к Амру и Умару.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$العلم المعدول على وزن «فعل» ممنوع من الصرف، نحو: عمر، زحل، هبل.
اسمي عمر. رأيت عمر. سلمت على عمر.
عمر ممنوع من الصرف، وعمرو مصروف.
اسمي عمرو. رأيت عمرا. سلمت على عمرو.$$, 37, 37, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الْعَلَمُ الْمَعْدُولُ عَلَى وَزْنِ فُعَلَ مَمْنُوعٌ مِنَ الصَّرْفِ.
عُمَرُ، زُفَرُ، هُبَلُ، زُحَلُ.
قِيلَ إِنَّ أَصْلَهَا: عَامِرٌ، زَافِرٌ، هَابِلٌ، زَاحِلٌ.
أَيْنَ عَمْرٌو وَأَيْنَ عُمَرُ؟
رَأَيْتُ عَمْرًا وَعُمَرَ.
ذَهَبْتُ إِلَى عَمْرٍو وَعُمَرَ.$$, 31, 32, 2);

  -- 4. The three types of ma explained in the lesson.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'أَنْوَاعُ مَا (виды مَا)',
    rule_ar = 'تَأْتِي «مَا» مَوْصُولَةً بِمَعْنَى «الَّذِي»، وَاسْتِفْهَامِيَّةً لِلسُّؤَالِ، وَنَافِيَةً لِنَفْيِ الْجُمْلَةِ الِاسْمِيَّةِ أَوِ الْفِعْلِيَّةِ.',
    summary = 'В уроке различаются относительная مَا со значением «то, что», вопросительная مَا и отрицательная مَا.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три значения</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">مَا الْمَوْصُولَةُ</span><span class="rule-term-ru">относительная <span class="ar-inline" dir="rtl" lang="ar">مَا</span>: «то, что; то, которое», равна по смыслу <span class="ar-inline" dir="rtl" lang="ar">الَّذِي</span>.</span></div>
          <div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">مَا الِاسْتِفْهَامِيَّةُ</span><span class="rule-term-ru">вопросительная <span class="ar-inline" dir="rtl" lang="ar">مَا</span>: «что?».</span></div>
          <div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">مَا النَّافِيَةُ</span><span class="rule-term-ru">отрицательная <span class="ar-inline" dir="rtl" lang="ar">مَا</span>: «не; нет».</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">مَا الْمَوْصُولَةُ — относительная مَا</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَأَشْتَرِي <span class="ar-tone-particle">مَا</span> تُرِيدُونَ، أَيْ: الَّذِي تُرِيدُونَ.</span><span class="rule-example-ru">Я куплю то, что вы хотите, то есть то, которое вы хотите.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَشْرَبُ <span class="ar-tone-particle">مَا</span> تَشْرَبُ، أَيْ: الَّذِي تَشْرَبُ.</span><span class="rule-example-ru">Я пью то, что пьёшь ты, то есть то, которое ты пьёшь.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">إِنِّي أَعْلَمُ <span class="ar-tone-particle">مَا</span> لَا تَعْلَمُونَ.</span><span class="rule-example-ru">Поистине, я знаю то, чего вы не знаете.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">آكُلُ <span class="ar-tone-particle">مَا</span> تَأْكُلُ.</span><span class="rule-example-ru">Я ем то, что ешь ты.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">نَسِيتُ <span class="ar-tone-particle">مَا</span> قُلْتَ لِي.</span><span class="rule-example-ru">Я забыл то, что ты мне сказал.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَفْهَمُ <span class="ar-tone-particle">مَا</span> تَقُولُ.</span><span class="rule-example-ru">Я понимаю то, что ты говоришь.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَأَشْتَرِي <span class="ar-tone-particle">مَا</span> تُرِيدُ.</span><span class="rule-example-ru">Я куплю то, что ты хочешь.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">مَا الِاسْتِفْهَامِيَّةُ — вопросительная مَا</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَالُوا <span class="ar-tone-particle">مَاذَا</span> قَالَ رَبُّكُمْ.</span><span class="rule-example-ru">Они сказали: «Что сказал ваш Господь?»</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَا</span> اسْمُكَ؟</span><span class="rule-example-ru">Как тебя зовут?</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَا</span> هَذَا؟</span><span class="rule-example-ru">Что это?</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَاذَا</span> تَكْتُبُ؟</span><span class="rule-example-ru">Что ты пишешь?</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">مَا النَّافِيَةُ — отрицательная مَا</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَا</span> عِنْدِي كِتَابٌ.</span><span class="rule-example-ru">У меня нет книги.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَا</span> فَهِمْتُ الدَّرْسَ.</span><span class="rule-example-ru">Я не понял урок.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَا</span> أَدْرِي.</span><span class="rule-example-ru">Я не знаю.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$«ما» الموصولة بمعنى «الذي»
سأشتري ما تريدون (أي: الذي تريدون).
أشرب ما تشرب (أي: الذي تشرب).
أنواع «ما»
الاستفهامية: قالوا ماذا قال ربكم.
الموصولة: إني أعلم ما لا تعلمون.
النافية: ما عندي كتاب.$$, 38, 39, 1),
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$مَا الْمَوْصُولَةُ بِمَعْنَى «الَّذِي»
آكُلُ مَا تَأْكُلُ.
نَسِيتُ مَا قُلْتَ لِي.
أَفْهَمُ مَا تَقُولُ.
سَأَشْتَرِي مَا تُرِيدُ.
مَا الِاسْتِفْهَامِيَّةُ: مَا اسْمُكَ؟ مَا هَذَا؟ مَاذَا تَكْتُبُ؟
مَا النَّافِيَةُ: مَا عِنْدِي كِتَابٌ، مَا فَهِمْتُ الدَّرْسَ، مَا أَدْرِي.$$, 33, 33, 2);

  -- 5. Dhu in the nominative and dha in the accusative, exactly as this lesson presents them.
  update public.rules
  set
    sort_order = 5,
    rule_kind = 'rule',
    title = 'ذُو (обладатель; одно из пяти имён)',
    rule_ar = '«ذُو» مِنَ الْأَسْمَاءِ الْخَمْسَةِ، وَهُوَ بِمَعْنَى «صَاحِبٍ»، وَيَكُونُ مُفْرَدًا، وَيُضَافُ دَائِمًا، وَيُرْفَعُ بِالْوَاوِ، وَيُنْصَبُ بِالْأَلِفِ، وَيَكُونُ مَا بَعْدَهُ مُضَافًا إِلَيْهِ مَجْرُورًا.',
    summary = 'В этом уроке шархи показывают именительную форму ذُو и винительную ذَا, обязательную идафу и полный разбор примера.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три условия</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">الْإِضَافَةُ</span><span class="rule-term-ru">обязательная идафа: после слова должен стоять родительный компонент</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">بِمَعْنَى صَاحِبٍ</span><span class="rule-term-ru">значение «обладатель, владелец»</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">الْإِفْرَادُ</span><span class="rule-term-ru">употребление в единственном числе</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Формы, приведённые в уроке</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th>Форма</th><th>Показатель</th><th>Русское объяснение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">именительный</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ذُو</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْوَاوُ</span><span class="rule-table-ru">буква واو</span></td><td>«обладающий» в именительном падеже</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">винительный</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">ذَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْأَلِفُ</span><span class="rule-table-ru">буква алиф</span></td><td>«обладающего» в винительном падеже</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الدَّفْتَرُ <span class="ar-tone-raf">ذُو</span> وَرَقٍ مُسَطَّرٍ.</span><span class="rule-example-ru">Эта тетрадь — с разлинованной бумагой.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أُرِيدُ دَفْتَرًا <span class="ar-tone-nasb">ذَا</span> وَرَقٍ مُسَطَّرٍ.</span><span class="rule-example-ru">Я хочу тетрадь с разлинованной бумагой.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">عِنْدِي دَفْتَرٌ <span class="ar-tone-raf">ذُو</span> وَرَقٍ مُسَطَّرٍ.</span><span class="rule-example-ru">У меня есть тетрадь с разлинованной бумагой.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِشْتَرَيْتُ دَفْتَرًا <span class="ar-tone-nasb">ذَا</span> وَرَقٍ مُسَطَّرٍ.</span><span class="rule-example-ru">Я купил тетрадь с разлинованной бумагой.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">فِي قَرْيَتِي مَسْجِدٌ <span class="ar-tone-raf">ذُو</span> مَنَارَةٍ عَالِيَةٍ.</span><span class="rule-example-ru">В моей деревне есть мечеть с высоким минаретом.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ مَسْجِدًا <span class="ar-tone-nasb">ذَا</span> مَنَارَةٍ عَالِيَةٍ.</span><span class="rule-example-ru">Я увидел мечеть с высоким минаретом.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">إِعْرَابٌ — полный грамматический разбор</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">أُرِيدُ دَفْتَرًا ذَا وَرَقٍ مُسَطَّرٍ.</span>
        <div class="rule-analysis-list">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أُرِيدُ</span>: فِعْلٌ مُضَارِعٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ عَلَى آخِرِهِ، وَالْفَاعِلُ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنَا».</span><span class="rule-analysis-ru">Глагол настоящего/будущего времени в именительном состоянии; показатель — явная дамма на конце. Исполнитель — скрытое местоимение со значением «я».</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">دَفْتَرًا</span>: مَفْعُولٌ بِهِ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-analysis-ru">Прямое дополнение в винительном падеже; показатель — явная фатха на конце.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">ذَا</span>: نَعْتٌ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْأَلِفُ لِأَنَّهُ مِنَ الْأَسْمَاءِ الْخَمْسَةِ، وَهُوَ مُضَافٌ.</span><span class="rule-analysis-ru">Определение в винительном падеже; показатель — алиф, поскольку слово относится к пяти именам; оно является первым членом идафы.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-jarr">وَرَقٍ</span>: مُضَافٌ إِلَيْهِ مَجْرُورٌ، وَعَلَامَةُ جَرِّهِ الْكَسْرَةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-analysis-ru">Второй член идафы в родительном падеже; показатель — явная касра на конце.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-jarr">مُسَطَّرٍ</span>: نَعْتٌ لِوَرَقٍ مَجْرُورٌ، وَعَلَامَةُ جَرِّهِ الْكَسْرَةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-analysis-ru">Определение к слову «бумага» в родительном падеже; показатель — явная касра на конце.</span></div>
        </div>
      </div>
      <div class="rule-check-card">В карточке намеренно даны только формы <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">ذُو</span> и <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">ذَا</span>: именно их объясняют страницы урока 16 в двух предоставленных шархах.</div>
    </div>$$
  where id = rule_5_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$«ذو» من الأسماء الخمسة
شروطه: الإضافة، أن يكون بمعنى صاحب، أن يكون مفردا.
هذا الدفتر ذو ورق مسطر.
أريد دفترا ذا ورق مسطر.
الإعراب:
أريد: فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره «أنا».
دفترا: مفعول به منصوب وعلامة نصبه الفتحة الظاهرة على آخره.
ذا: نعت منصوب وعلامة نصبه الألف؛ لأنه من الأسماء الخمسة، وهو مضاف.
ورق: مضاف إليه مجرور وعلامة جره الكسرة الظاهرة على آخره.
مسطر: نعت لورق مجرور وعلامة جره الكسرة الظاهرة على آخره.$$, 38, 38, 1),
    (rule_5_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$ذُو مِنَ الْأَسْمَاءِ الْخَمْسَةِ، تُرْفَعُ بِالْوَاوِ، وَتُنْصَبُ بِالْأَلِفِ «ذَا»، وَمَا بَعْدَهَا مُضَافٌ إِلَيْهِ مَجْرُورٌ.
عِنْدِي دَفْتَرٌ ذُو وَرَقٍ مُسَطَّرٍ.
اِشْتَرَيْتُ دَفْتَرًا ذَا وَرَقٍ مُسَطَّرٍ.
فِي قَرْيَتِي مَسْجِدٌ ذُو مَنَارَةٍ عَالِيَةٍ.
رَأَيْتُ مَسْجِدًا ذَا مَنَارَةٍ عَالِيَةٍ.$$, 32, 32, 2);

  -- 6. Akhar and ukhra as separate source topic.
  update public.rules
  set
    sort_order = 6,
    rule_kind = 'rule',
    title = 'آخَرُ وَأُخْرَى (другой и другая)',
    rule_ar = '«آخَرُ» اسْمُ تَفْضِيلٍ مُذَكَّرٌ، وَمُؤَنَّثُهُ «أُخْرَى»، وَهُمَا مَمْنُوعَانِ مِنَ الصَّرْفِ، وَيَقَعَانِ نَعْتًا.',
    summary = 'آخَرُ — мужская форма «другой», أُخْرَى — женская; обе формы не принимают танвин и употребляются как определение.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Формы и синтаксическая роль</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">آخَرُ</span><span class="rule-term-ru">«другой» — мужская форма, <span class="ar-inline" dir="rtl" lang="ar">اسْمُ تَفْضِيلٍ مُذَكَّرٌ</span></span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">أُخْرَى</span><span class="rule-term-ru">«другая» — женская форма, <span class="ar-inline" dir="rtl" lang="ar">مُؤَنَّثٌ</span></span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">نَعْتٌ</span><span class="rule-term-ru">обе формы употребляются как определение</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">مَمْنُوعَانِ مِنَ الصَّرْفِ</span><span class="rule-term-ru">обе формы не принимают танвин</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا بَيْتُنَا وَلَنَا بَيْتٌ <span class="ar-tone-predicate">آخَرُ</span>.</span><span class="rule-example-ru">Это наш дом, и у нас есть другой дом.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ حَقِيبَتِي وَعِنْدِي حَقِيبَةٌ <span class="ar-tone-predicate">أُخْرَى</span>.</span><span class="rule-example-ru">Это моя сумка, и у меня есть другая сумка.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">خَرَجَ مِنَ الْفَصْلِ حَمْزَةُ وَطَالِبٌ <span class="ar-tone-predicate">آخَرُ</span>.</span><span class="rule-example-ru">Из класса вышли Хамза и другой студент.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">خَرَجَتْ مِنَ الْفَصْلِ سُعَادُ وَطَالِبَةٌ <span class="ar-tone-predicate">أُخْرَى</span>.</span><span class="rule-example-ru">Из класса вышли Суад и другая студентка.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ الْيَوْمَ مُدَرِّسَنَا وَمُدَرِّسًا <span class="ar-tone-nasb">آخَرَ</span> لَا أَعْرِفُهُ.</span><span class="rule-example-ru">Сегодня я увидел нашего преподавателя и другого преподавателя, которого не знаю.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">حَفِظْتُ سُورَةَ الرَّحْمَنِ وَسُورَةً <span class="ar-tone-nasb">أُخْرَى</span>.</span><span class="rule-example-ru">Я выучил суру «Ар-Рахман» и ещё одну суру.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_6_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_6_id, 'Podrobny_Sharkh_2_tom.pdf', $$«آخر» اسم تفضيل للمذكر، ومؤنثه «أخرى»، وهما ممنوعان من الصرف، ويكونان نعتا.
هذا بيتنا ولنا بيت آخر.
هذه حقيبتي وعندي حقيبة أخرى.$$, 39, 39, 1),
    (rule_6_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$آخَرُ وَأُخْرَى مَمْنُوعَانِ مِنَ الصَّرْفِ.
خَرَجَ مِنَ الْفَصْلِ حَمْزَةُ وَطَالِبٌ آخَرُ.
خَرَجَتْ مِنَ الْفَصْلِ سُعَادُ وَطَالِبَةٌ أُخْرَى.
رَأَيْتُ الْيَوْمَ مُدَرِّسَنَا وَمُدَرِّسًا آخَرَ لَا أَعْرِفُهُ.
حَفِظْتُ سُورَةَ الرَّحْمَنِ وَسُورَةً أُخْرَى.$$, 32, 32, 2);

  -- 7. Ghayru, kept separate from akhar/ukhra as in both sources.
  update public.rules
  set
    sort_order = 7,
    rule_kind = 'rule',
    title = 'غَيْرُ (не; иной; отличный от)',
    rule_ar = '«غَيْرُ» اسْمٌ يَدُلُّ عَلَى النَّفْيِ، وَهُوَ مُلَازِمٌ لِلْإِضَافَةِ، وَمَا بَعْدَهُ مُضَافٌ إِلَيْهِ مَجْرُورٌ.',
    summary = 'غَيْرُ передаёт отрицание или отличие, всегда является первым членом идафы, а следующее слово стоит в родительном падеже.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Значение и управление</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">غَيْرُ</span> اسْمٌ يَدُلُّ عَلَى النَّفْيِ، وَهُوَ مُلَازِمٌ لِلْإِضَافَةِ، وَمَا بَعْدَهُ <span class="ar-tone-jarr">مُضَافٌ إِلَيْهِ مَجْرُورٌ</span>.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">غَيْرُ</span> означает «не; иной; отличный от». Оно всегда является первым членом идафы, поэтому следующее слово — <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ مَجْرُورٌ</span>, то есть второй член идафы в родительном падеже.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الْمَاءُ <span class="ar-tone-particle">غَيْرُ</span> <span class="ar-tone-jarr">بَارِدٍ</span>.</span><span class="rule-example-ru">Эта вода не холодная.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">عِنْدِي وَرَقٌ مُسَطَّرٌ وَوَرَقٌ <span class="ar-tone-particle">غَيْرُ</span> <span class="ar-tone-jarr">مُسَطَّرٍ</span>.</span><span class="rule-example-ru">У меня есть разлинованная и неразлинованная бумага.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الْخَبَرُ صَحِيحٌ وَذَاكَ الْخَبَرُ <span class="ar-tone-particle">غَيْرُ</span> <span class="ar-tone-jarr">صَحِيحٍ</span>.</span><span class="rule-example-ru">Это сообщение верное, а то сообщение неверное.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_7_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_7_id, 'Podrobny_Sharkh_2_tom.pdf', $$«غير» تأتي للنفي، وهي ملازمة للإضافة، وما بعدها مضاف إليه.
هذا الماء غير بارد.$$, 39, 39, 1),
    (rule_7_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$غَيْرُ اسْمٌ يُسْتَعْمَلُ لِلنَّفْيِ، وَمَا بَعْدَهُ مُضَافٌ إِلَيْهِ مَجْرُورٌ.
عِنْدِي وَرَقٌ مُسَطَّرٌ وَوَرَقٌ غَيْرُ مُسَطَّرٍ.
هَذَا الْخَبَرُ صَحِيحٌ وَذَاكَ الْخَبَرُ غَيْرُ صَحِيحٍ.$$, 33, 33, 2);
end
$migration$;

commit;
