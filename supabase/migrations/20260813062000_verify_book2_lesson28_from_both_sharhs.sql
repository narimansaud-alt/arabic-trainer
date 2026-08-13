-- Verify Medina Book 2 lesson 28 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 65-69.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 54-57.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
  rule_4_id bigint;
  rule_5_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '28';

  if lesson_rule_count not in (4, 5) then
    raise exception 'Expected 4 or 5 Book 2 lesson 28 rules, found %', lesson_rule_count;
  end if;

  if lesson_rule_count = 4 then
    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values
      ('Мединский курс (Том 2)', '28', '', '', 5, 'rule', '', '')
    returning id into rule_5_id;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '28' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '28' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '28' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '28' and sort_order = 4;
  select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '28' and sort_order = 5;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);

  -- 1. Definition and the waw/ya types.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'الْفِعْلُ النَّاقِصُ وَنَوْعَاهُ (конечнослабый глагол и два его вида)',
    rule_ar = 'الْفِعْلُ الْمُعْتَلُّ اللَّامِ هُوَ مَا كَانَ فِي آخِرِهِ حَرْفُ عِلَّةٍ، وَيُسَمَّى نَاقِصًا. فَإِنْ كَانَتْ لَامُهُ وَاوًا فَهُوَ نَاقِصٌ وَاوِيٌّ، نَحْوُ: دَعَا، يَدْعُو، دَعْوَةٌ؛ وَإِنْ كَانَتْ لَامُهُ يَاءً فَهُوَ نَاقِصٌ يَائِيٌّ، نَحْوُ: مَشَى، يَمْشِي، مَشْيًا؛ وَنَسِيَ، يَنْسَى، نِسْيَانًا؛ وَبَقِيَ، يَبْقَى، بَقَاءً.',
    summary = 'Конечнослабым называется глагол, последняя коренная которого — буква слабости. По происхождению это نَاقِصٌ وَاوِيٌّ или نَاقِصٌ يَائِيٌّ; вид подтверждается настоящим временем и масдаром.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Определение</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمُعْتَلُّ اللَّامِ</span><span class="rule-term-ru">глагол, у которого последняя коренная буква является буквой слабости.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ النَّاقِصُ</span><span class="rule-term-ru">другое название конечнослабого глагола.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Два вида и основные формы</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Вид</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَاضِي</span><span class="rule-table-ru">прошедшее</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمُضَارِعُ</span><span class="rule-table-ru">настоящее</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَصْدَرُ</span><span class="rule-table-ru">масдар</span></th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَاقِصٌ وَاوِيٌّ</span><span class="rule-table-ru">исходный و</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُو</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعْوَةٌ</span></td><td>позвал; зовёт; призыв</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَاقِصٌ يَائِيٌّ</span><span class="rule-table-ru">исходный ي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشْيًا</span></td><td>шёл; идёт; хождение</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَاقِصٌ يَائِيٌّ</span><span class="rule-table-ru">явная ي в прошедшем</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نِسْيَانٌ</span></td><td>забыл; забывает; забывание</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَاقِصٌ يَائِيٌّ</span><span class="rule-table-ru">явная ي в прошедшем</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بَقِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَبْقَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بَقَاءٌ</span></td><td>остался; остаётся; пребывание</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الفعل المعتل اللام (الناقص):
الناقص الواوي: دعا يدعو.
الناقص اليائي: بكى يبكي، بقي يبقى.$$,
      65, 65, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الفعل معتل اللام: هو الذي في آخره حرف علة، نحو: مشى، نسي، دعا.
حرف العلة إذا كان في آخر الفعل سمي الفعل ناقصا.
مشى: الألف أصلها الياء: يمشي مشي.
نسي: الياء بقيت على أصلها: ينسى نسيان.
دعا: الألف أصلها الواو: يدعو دعوة.$$,
      54, 54, 2);

  -- 2. Past tense with ten pronouns.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'إِسْنَادُ النَّاقِصِ فِي الْمَاضِي (присоединение местоимений к конечнослабому глаголу в прошедшем времени)',
    rule_ar = 'عِنْدَ إِسْنَادِ الْمَاضِي النَّاقِصِ إِلَى التَّاءِ الْمُتَحَرِّكَةِ وَنُونِ النِّسْوَةِ وَنَا الْفَاعِلِينَ يَرْجِعُ حَرْفُ الْعِلَّةِ إِلَى أَصْلِهِ، نَحْوُ: مَشَيْتُ، وَنَسِيتُ، وَدَعَوْتُ. وَعِنْدَ إِسْنَادِهِ إِلَى وَاوِ الْجَمَاعَةِ يُحْذَفُ حَرْفُ الْعِلَّةِ لِلتَّخَلُّصِ مِنِ الْتِقَاءِ السَّاكِنَيْنِ، نَحْوُ: مَشَوْا، وَنَسُوا، وَدَعَوْا. وَتُحْذَفُ الْأَلِفُ أَيْضًا فِي نَحْوِ مَشَتْ وَدَعَتْ، أَمَّا الْيَاءُ الظَّاهِرَةُ فَتَبْقَى فِي نَحْوِ نَسِيَتْ وَبَقِيَتْ.',
    summary = 'С подвижной ت, نُونُ النِّسْوَةِ и نَا исходный و или ي возвращается. Перед وَاوُ الْجَمَاعَةِ и в форме с ت женского рода слабая буква может удаляться ради устранения двух сукунов; явная ي сохраняется.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три изменения при присоединении</span>
        <ol class="rule-step-list">
          <li><span class="rule-step-ar" dir="rtl" lang="ar">حَذْفُ لَامِ الْفِعْلِ</span><span class="rule-step-ru">Последняя слабая коренная удаляется там, где встречаются два сукуна.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">فَتْحُ مَا قَبْلَ الْأَلِفِ</span><span class="rule-step-ru">Перед исходной формой с алифом стоит фатха.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">ضَمُّ مَا قَبْلَ الْوَاوِ</span><span class="rule-step-ru">Перед показателем мужского множественного числа ставится дамма.</span></li>
        </ol>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений и три модели</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th><span class="rule-table-ar" dir="rtl" lang="ar">مَشَى</span><span class="rule-table-ru">шёл</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">نَسِيَ</span><span class="rule-table-ru">забыл</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">دَعَا</span><span class="rule-table-ru">позвал</span></th><th>Правило формы</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَا</span></td><td>исходная форма</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَوْا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَوْا</span></td><td>слабая буква удалена перед وَاوُ الْجَمَاعَةِ</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَتْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسِيَتْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَتْ</span></td><td>алиф удалён; явная ي сохранена</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَيْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَوْنَ</span></td><td>исходный ي или و возвращается</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَيْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسِيتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَوْتَ</span></td><td>исходный ي или و возвращается</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَيْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسِيتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَوْتُمْ</span></td><td>исходный ي или و возвращается</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَيْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسِيتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَوْتِ</span></td><td>исходный ي или و возвращается</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَيْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسِيتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَوْتُنَّ</span></td><td>исходный ي или و возвращается</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَيْتُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسِيتُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَوْتُ</span></td><td>исходный ي или و возвращается</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَشَيْنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَسِينَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَعَوْنَا</span></td><td>исходный ي или و возвращается</td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Почему مَشَوْا, نَسُوا и دَعَوْا</span>Исходные формы <span class="ar-inline" dir="rtl" lang="ar">مَشَيُوا، نَسِيُوا، دَعَوُوا</span> теряют дамму из-за тяжести произношения, затем слабую букву из-за встречи двух сукунов.</div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$إسناد الفعل الماضي إلى الضمائر العشرة: دعا، بكى، بقي.
تحذف حرف العلة لالتقاء الساكنين إلا في الأفعال آخرها ياء ظاهرة، نحو: بقي.
في إسناد الفعل الماضي ثلاثة أمور:
1. تحذف لام الفعل.
2. تفتح ما قبل الألف.
3. تضم ما قبل الواو.$$,
      66, 66, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إسناد الفعل الماضي المعتل اللام إلى الضمائر:
مشى، مشوا، مشت، مشين، مشيت، مشيتم، مشيت، مشيتن، مشيت، مشينا.
نسي، نسوا، نسيت، نسين، نسيت، نسيتم، نسيت، نسيتن، نسيت، نسينا.
دعا، دعوا، دعت، دعون، دعوت، دعوتم، دعوت، دعوتن، دعوت، دعونا.
مشى، دعا: مبنيان على فتحة مقدرة منع من ظهورها التعذر.
مشيت، نسيت، دعوت: يرجع حرف العلة إلى أصله عند إسناده إلى التاء ونون النسوة ونا.
مشوا، نسوا، دعوا: أصلها مشيوا، نسيوا، دعووا؛ حذفت الضمة لثقلها في النطق، وحذف حرف العلة لالتقاء الساكنين.$$,
      54, 55, 2);

  -- 3. Present tense: ten pronouns and case/mood signs.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'إِسْنَادُ النَّاقِصِ فِي الْمُضَارِعِ وَإِعْرَابُهُ (конечнослабый глагол в настоящем времени и его изменение)',
    rule_ar = 'عَلَامَةُ رَفْعِ الْمُضَارِعِ الْمُعْتَلِّ الْآخِرِ الضَّمَّةُ الْمُقَدَّرَةُ؛ فَيَمْنَعُ مِنْ ظُهُورِهَا الثِّقَلُ عَلَى الْوَاوِ وَالْيَاءِ، وَالتَّعَذُّرُ عَلَى الْأَلِفِ. وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ عَلَى الْوَاوِ وَالْيَاءِ وَالْمُقَدَّرَةُ عَلَى الْأَلِفِ. وَعَلَامَةُ جَزْمِهِ حَذْفُ حَرْفِ الْعِلَّةِ. وَفِي الْأَفْعَالِ الْخَمْسَةِ تَثْبُتُ النُّونُ فِي الرَّفْعِ وَتُحْذَفُ فِي النَّصْبِ وَالْجَزْمِ، أَمَّا الْمُتَّصِلُ بِنُونِ النِّسْوَةِ فَمَبْنِيٌّ عَلَى السُّكُونِ.',
    summary = 'У конечнослабого настоящего глагола дамма раф‘ скрыта; фатха насба явна на و и ي, но скрыта на ا; в джазме слабая буква удаляется. Полные формы десяти местоимений сохранены.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Раф‘, насб и джазм</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Конечная буква</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">раф‘</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْجَزْمُ</span><span class="rule-table-ru">джазм</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْأَلِفُ</span><span class="rule-table-ru">алиф</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَبْقَى</span><span class="rule-table-ru">скрытая дамма из-за невозможности проявления</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَبْقَى</span><span class="rule-table-ru">скрытая фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَبْقَ</span><span class="rule-table-ru">удаление слабой буквы</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْوَاوُ</span><span class="rule-table-ru">вау</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُو</span><span class="rule-table-ru">скрытая дамма из-за тяжести</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَدْعُوَ</span><span class="rule-table-ru">явная фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَدْعُ</span><span class="rule-table-ru">удаление слабой буквы</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْيَاءُ</span><span class="rule-table-ru">йа</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِي</span><span class="rule-table-ru">скрытая дамма из-за тяжести</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَمْشِيَ</span><span class="rule-table-ru">явная фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَمْشِ</span><span class="rule-table-ru">удаление слабой буквы</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений: формы в раф‘</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِي</span><span class="rule-table-ru">идти</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَى</span><span class="rule-table-ru">забывать</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُو</span><span class="rule-table-ru">звать</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُو</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَوْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُونَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُو</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَيْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُونَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُو</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَوْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُونَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَيْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعِينَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَيْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُونَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَدْعُو</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَدْعُو</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Две одинаковые записи يَدْعُونَ</span>В <span class="ar-inline" dir="rtl" lang="ar">الطُّلَّابُ يَدْعُونَ</span> конечный <span class="ar-inline" dir="rtl" lang="ar">و</span> — وَاوُ الْجَمَاعَةِ, исполнитель, а коренная слабая буква удалена. В <span class="ar-inline" dir="rtl" lang="ar">الطَّالِبَاتُ يَدْعُونَ</span> конечная <span class="ar-inline" dir="rtl" lang="ar">ن</span> — نُونُ النِّسْوَةِ, исполнитель, а коренная <span class="ar-inline" dir="rtl" lang="ar">و</span> сохранена.</div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$إسناد الفعل المضارع إلى الضمائر العشرة: بكى، دعا، بقي.
في إسناد الفعل المضارع إلى الضمير أنت ثلاثة أمور:
1. تحذف لام الفعل.
2. تكسر ما قبل الواو والياء.
نقول: أنت تدعون وهي تدعون فتأمل. ونقول: أنت تبقين وأنتن تبقين فتأمل.
المضارع المرفوع والمنصوب والمجزوم:
يبقى، لن يبقى، لم يبق.
يدعو، لن يدعو، لم يدع.
يبكي، لن يبكي، لم يبك.$$,
      67, 68, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إسناد الفعل المضارع المعتل اللام إلى الضمائر: يمشي، ينسى، يدعو، مع ضمائر الغائب والمخاطب والمتكلم.
علامة الرفع في الفعل المضارع المعتل الآخر الضمة المقدرة؛ منع من ظهورها الثقل في المعتل بالواو أو الياء، أما المعتل بالألف فمنع من ظهورها التعذر.
علامة النصب الفتحة الظاهرة: لن أمشي، لن أدعو. أما المعتل بالألف فالفتحة مقدرة.
علامة الجزم حذف حرف العلة: لم أمش، لم أنس، لم أدع.
يمشون، ينسون، يدعون: أصلها يمشيون، ينسيون، يدعوون؛ حذفت الضمة لثقلها في النطق ثم حذف حرف العلة لالتقاء الساكنين.
الطلاب يدعون: واو الجماعة فاعل وحرف العلة محذوف. الطالبات يدعون: نون النسوة فاعل وحرف العلة من أصل الفعل.$$,
      55, 57, 2);

  -- 4. Imperative derivation and assignment.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'صِيَاغَةُ أَمْرِ النَّاقِصِ وَإِسْنَادُهُ (образование и присоединение форм повелительного конечнослабого глагола)',
    rule_ar = 'يُصَاغُ أَمْرُ النَّاقِصِ مِنَ الْمُضَارِعِ بِحَذْفِ حَرْفِ الْمُضَارَعَةِ، ثُمَّ يُؤْتَى بِهَمْزَةِ الْوَصْلِ إِذَا صَارَ أَوَّلُهُ سَاكِنًا، وَيُبْنَى عَلَى حَذْفِ حَرْفِ الْعِلَّةِ فِي الْمُفْرَدِ الْمُذَكَّرِ، وَعَلَى حَذْفِ النُّونِ مَعَ وَاوِ الْجَمَاعَةِ وَيَاءِ الْمُخَاطَبَةِ، وَعَلَى السُّكُونِ مَعَ نُونِ النِّسْوَةِ. وَتَكُونُ حَرَكَةُ هَمْزَةِ الْوَصْلِ مُنَاسِبَةً لِحَرَكَةِ عَيْنِ الْفِعْلِ.',
    summary = 'Повелительное образуется от настоящего удалением префикса. Если начало становится без огласовки, добавляется хамзатуль-васл с подходящей гласной. Построение зависит от формы обращения.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Как получить اُدْعُ из تَدْعُو</span>
        <ol class="rule-step-list">
          <li><span class="rule-step-ar" dir="rtl" lang="ar">تَدْعُو</span><span class="rule-step-ru">Берём настоящее время «ты зовёшь».</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">دْعُو</span><span class="rule-step-ru">Удаляем ت настоящего времени.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">اُدْعُو</span><span class="rule-step-ru">Добавляем хамзатуль-васл, потому что первая коренная имеет сукун; здесь она произносится с даммой.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">اُدْعُ</span><span class="rule-step-ru">Удаляем последнюю слабую букву: форма строится на её удалении.</span></li>
        </ol>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре формы трёх глаголов</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Обращение</th><th>Идти</th><th>Забывать</th><th>Звать</th><th>Построение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِمْشِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِنْسَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُدْعُ</span></td><td>удаление слабой буквы</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِمْشُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِنْسَوْا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُدْعُوا</span></td><td>удаление ن; коренная слабая удалена</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِنْسَيْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُدْعِي</span></td><td>удаление ن; коренная слабая удалена</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِمْشِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِنْسَيْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُدْعُونَ</span></td><td>сукун; слабая буква сохранена</td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Исполнитель</span>В формах с <span class="ar-inline" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span> или <span class="ar-inline" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span> эта буква является исполнителем, а коренная слабая буква удалена. С <span class="ar-inline" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span> коренная слабая буква сохраняется.</div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$كيف يصاغ فعل الأمر من الفعل الناقص؟
1. نأتي بالفعل المضارع: تدعو.
2. نحذف حرف المضارعة: دعو.
3. نأتي بهمزة الوصل لأن أوله ساكن، ونحركها بحركة عين الفعل: ادعو.
4. نحذف حرف العلة: ادع.
نقول: يا أحمد ادع، يا فاطمة ادعي، يا أولاد ادعوا، يا بنات ادعون.
ادع: مبني على حذف حرف العلة. ادعي وادعوا: مبني على حذف النون لأنهما من الأفعال الخمسة. ادعون: مبني على السكون.$$,
      68, 68, 1),
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إسناد فعل الأمر معتل اللام إلى الضمائر:
امش، امشوا، امشي، امشين.
انس، انسوا، انسي، انسين.
ادع، ادعوا، ادعي، ادعون.
امشي، انسي، ادعي: ياء المخاطبة فاعل، وحرف العلة محذوف لنفس الأسباب التي في المضارع.
امشوا، انسوا، ادعوا: واو الجماعة فاعل، وحرف العلة محذوف لنفس الأسباب التي في المضارع.
امشين، انسين، ادعون: حرف العلة لا يحذف، ونون النسوة فاعل.$$,
      57, 57, 2);

  -- 5. Arini: morphological derivation, parsing, and forms.
  update public.rules
  set
    sort_order = 5,
    rule_kind = 'rule',
    title = 'فِعْلُ الْأَمْرِ «أَرِنِي» وَإِعْرَابُهُ (повелительное «покажи мне» и его разбор)',
    rule_ar = '«أَرِنِي» فِعْلُ أَمْرٍ مِنْ بَابِ «أَفْعَلَ»، وَفِعْلُهُ «أَرَى»، وَأَصْلُهُ «أَرْأَى»، فَحُذِفَتِ الْهَمْزَةُ تَخْفِيفًا. وَ«أَرِ» مَبْنِيٌّ عَلَى حَذْفِ حَرْفِ الْعِلَّةِ لِأَنَّهُ فِعْلٌ نَاقِصٌ، وَالنُّونُ نُونُ الْوِقَايَةِ لَا مَحَلَّ لَهَا مِنَ الْإِعْرَابِ، وَالْيَاءُ يَاءُ الْمُتَكَلِّمِ، وَهِيَ فِي مَحَلِّ نَصْبٍ، وَهِيَ مَفْعُولٌ بِهِ.',
    summary = 'أَرِنِي происходит от أَرَى, بَابُ أَفْعَلَ; одна хамза удалена для облегчения. Карточка сохраняет полный морфологический и синтаксический разбор, а также четыре обращения подробного шарха.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Происхождение формы</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">أَرَى</span><span class="rule-term-ru">показывать; глагол четвёртой породы, بَابُ أَفْعَلَ.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">أَصْلُهُ «أَرْأَى»</span><span class="rule-term-ru">исходная форма содержала две хамзы; одна удалена для облегчения произношения.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный разбор أَرِنِي</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Часть</th><th>Арабский разбор</th><th>Русское объяснение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَرِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلُ أَمْرٍ مَبْنِيٌّ عَلَى حَذْفِ حَرْفِ الْعِلَّةِ لِأَنَّهُ فِعْلٌ نَاقِصٌ</span></td><td>повелительный глагол, построенный на удалении слабой конечной буквы.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">نِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نُونُ الْوِقَايَةِ، لَا مَحَلَّ لَهَا مِنَ الْإِعْرَابِ</span></td><td>предохранительный нун; не занимает синтаксической позиции.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-object" dir="rtl" lang="ar">ي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَاءُ الْمُتَكَلِّمِ فِي مَحَلِّ نَصْبٍ، وَهِيَ مَفْعُولٌ بِهِ</span></td><td>местоимение «меня, мне» в позиции прямого дополнения.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Формы обращения из подробного шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَحْمَدُ، أَرِنِي الْكِتَابَ.</span><span class="rule-example-ru">Ахмад, покажи мне книгу.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا فَاطِمَةُ، أَرِينِي الْكِتَابَ.</span><span class="rule-example-ru">Фатима, покажи мне книгу.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَوْلَادُ، أَرُونِي الْكِتَابَ.</span><span class="rule-example-ru">Мальчики, покажите мне книгу.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا بَنَاتُ، أَرِينَنِي الْكِتَابَ.</span><span class="rule-example-ru">Девочки, покажите мне книгу.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_5_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$«أرني»: فعل أمر من باب «أفعل»، وفعله «أرى»، وأصله «أرأى»، حذفت الهمزة تخفيفا.
أر: مبني على حذف حرف العلة لأنه فعل ناقص.
ن: نون الوقاية، لا محل لها من الإعراب.
ي: ياء المتكلم في محل نصب مفعول به.
نقول في الأمر: يا أحمد أرني الكتاب، يا فاطمة أريني الكتاب، يا أولاد أروني الكتاب، يا بنات أرينني الكتاب.$$,
      69, 69, 1);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '28'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 28 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id)
  ) <> 9 then
    raise exception 'Expected 9 Book 2 lesson 28 source rows';
  end if;

  if exists (
    select 1 from public.rules
    where id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id)
      and (content::text like '%←%' or content::text like '%→%')
  ) then
    raise exception 'Book 2 lesson 28 contains an RTL-hostile arrow';
  end if;
end
$migration$;

commit;
