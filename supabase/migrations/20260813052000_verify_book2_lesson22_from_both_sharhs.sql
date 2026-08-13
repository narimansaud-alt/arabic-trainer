-- Verify Medina Book 2 lesson 22 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF page 52.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 42.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '22';

  if lesson_rule_count <> 1 then
    raise exception 'Expected 1 Book 2 lesson 22 rule, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '22'
    and sort_order = 1;

  delete from public.rule_sections where rule_id = rule_1_id;
  delete from public.rule_sources where rule_id = rule_1_id;

  update public.rules
  set
    sort_order = 1,
    rule_kind = 'table',
    title = 'حَالَاتُ الْفِعْلِ الْمُضَارِعِ الثَّلَاثُ (три состояния глагола настоящего времени)',
    rule_ar = 'لِلْفِعْلِ الْمُضَارِعِ ثَلَاثُ حَالَاتٍ: الرَّفْعُ، وَعَلَامَتُهُ الضَّمَّةُ أَوْ ثُبُوتُ النُّونِ؛ وَالنَّصْبُ بَعْدَ «لَنْ»، وَعَلَامَتُهُ الْفَتْحَةُ أَوْ حَذْفُ النُّونِ؛ وَالْجَزْمُ بَعْدَ «لَمْ»، وَعَلَامَتُهُ السُّكُونُ أَوْ حَذْفُ النُّونِ. وَالْمُضَارِعُ الْمُتَّصِلُ بِنُونِ النِّسْوَةِ مَبْنِيٌّ عَلَى السُّكُونِ فِي الْحَالَاتِ الثَّلَاثِ.',
    summary = 'Таблица сопоставляет рафъ, насб после «не будет» и джазм после «не» во всех десяти формах. Для обычных форм меняется последняя огласовка, у пяти глаголов сохраняется или удаляется нун, а формы с нуном женского множественного числа остаются неизменяемыми на сукуне.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три состояния и их показатели</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-raf" dir="rtl" lang="ar">الْمُضَارِعُ الْمَرْفُوعُ</span><span class="rule-term-ru">настоящий глагол в рафъ: показатель — <span class="ar-inline" dir="rtl" lang="ar">الضَّمَّةُ</span> дамма или <span class="ar-inline" dir="rtl" lang="ar">ثُبُوتُ النُّونِ</span> сохранение нуна.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-nasb" dir="rtl" lang="ar">الْمُضَارِعُ الْمَنْصُوبُ</span><span class="rule-term-ru">настоящий глагол в насбе после <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">لَنْ</span> «не будет»: показатель — <span class="ar-inline" dir="rtl" lang="ar">الْفَتْحَةُ</span> фатха или <span class="ar-inline" dir="rtl" lang="ar">حَذْفُ النُّونِ</span> удаление нуна.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-jazm" dir="rtl" lang="ar">الْمُضَارِعُ الْمَجْزُومُ</span><span class="rule-term-ru">настоящий глагол в джазме после <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">لَمْ</span> «не»: показатель — <span class="ar-inline" dir="rtl" lang="ar">السُّكُونُ</span> сукун или <span class="ar-inline" dir="rtl" lang="ar">حَذْفُ النُّونِ</span> удаление нуна.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полная таблица второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead>
            <tr>
              <th>Разряд</th>
              <th>Лицо и род</th>
              <th><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الْمُضَارِعُ الْمَرْفُوعُ</span><span class="rule-table-ru">форма в рафъ</span></th>
              <th><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">عَلَامَةُ الرَّفْعِ</span><span class="rule-table-ru">показатель рафъ</span></th>
              <th><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">الْمُضَارِعُ الْمَنْصُوبُ</span><span class="rule-table-ru">форма в насбе</span></th>
              <th><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">عَلَامَةُ النَّصْبِ</span><span class="rule-table-ru">показатель насба</span></th>
              <th><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">الْمُضَارِعُ الْمَجْزُومُ</span><span class="rule-table-ru">форма в джазме</span></th>
              <th><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">عَلَامَةُ الْجَزْمِ</span><span class="rule-table-ru">показатель джазма</span></th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td rowspan="4"><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْغَائِبُ</span><span class="rule-table-ru">третье лицо</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span><span class="rule-table-ru">он</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">حَامِدٌ <span class="ar-tone-verb">يَشْرَبُ</span>.</span><span class="rule-table-ru">Хамид пьёт.</span></td>
              <td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الضَّمَّةُ</span><span class="rule-table-ru">дамма</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb ar-tone-nasb">يَشْرَبَ</span>.</span><span class="rule-table-ru">Он не будет пить.</span></td>
              <td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">الْفَتْحَةُ</span><span class="rule-table-ru">фатха</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb ar-tone-jazm">يَشْرَبْ</span>.</span><span class="rule-table-ru">Он не пил.</span></td>
              <td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td>
            </tr>
            <tr>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span><span class="rule-table-ru">она</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">آمِنَةُ <span class="ar-tone-verb">تَشْرَبُ</span>.</span><span class="rule-table-ru">Амина пьёт.</span></td>
              <td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الضَّمَّةُ</span><span class="rule-table-ru">дамма</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb ar-tone-nasb">تَشْرَبَ</span>.</span><span class="rule-table-ru">Она не будет пить.</span></td>
              <td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">الْفَتْحَةُ</span><span class="rule-table-ru">фатха</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb ar-tone-jazm">تَشْرَبْ</span>.</span><span class="rule-table-ru">Она не пила.</span></td>
              <td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td>
            </tr>
            <tr>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span><span class="rule-table-ru">они, мужской род</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">الطُّلَّابُ <span class="ar-tone-verb">يَشْرَبُونَ</span>.</span><span class="rule-table-ru">Студенты пьют.</span></td>
              <td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ثُبُوتُ النُّونِ</span><span class="rule-table-ru">сохранение нуна</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb ar-tone-nasb">يَشْرَبُوا</span>.</span><span class="rule-table-ru">Они не будут пить.</span></td>
              <td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нуна</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb ar-tone-jazm">يَشْرَبُوا</span>.</span><span class="rule-table-ru">Они не пили.</span></td>
              <td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нуна</span></td>
            </tr>
            <tr>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span><span class="rule-table-ru">они, женский род</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَاتُ <span class="ar-tone-verb">يَشْرَبْنَ</span>.</span><span class="rule-table-ru">Студентки пьют.</span></td>
              <td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">неизменяем на сукуне</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb">يَشْرَبْنَ</span>.</span><span class="rule-table-ru">Они не будут пить.</span></td>
              <td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">неизменяем на сукуне</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">يَشْرَبْنَ</span>.</span><span class="rule-table-ru">Они не пили.</span></td>
              <td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">неизменяем на сукуне</span></td>
            </tr>
            <tr>
              <td rowspan="4"><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْمُخَاطَبُ</span><span class="rule-table-ru">второе лицо</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ <span class="ar-tone-verb">تَشْرَبُ</span>.</span><span class="rule-table-ru">Ты пьёшь.</span></td>
              <td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الضَّمَّةُ</span><span class="rule-table-ru">дамма</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb ar-tone-nasb">تَشْرَبَ</span>.</span><span class="rule-table-ru">Ты не будешь пить.</span></td>
              <td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">الْفَتْحَةُ</span><span class="rule-table-ru">фатха</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb ar-tone-jazm">تَشْرَبْ</span>.</span><span class="rule-table-ru">Ты не пил.</span></td>
              <td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td>
            </tr>
            <tr>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ <span class="ar-tone-verb">تَشْرَبِينَ</span>.</span><span class="rule-table-ru">Ты пьёшь.</span></td>
              <td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ثُبُوتُ النُّونِ</span><span class="rule-table-ru">сохранение нуна</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb ar-tone-nasb">تَشْرَبِي</span>.</span><span class="rule-table-ru">Ты не будешь пить.</span></td>
              <td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нуна</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb ar-tone-jazm">تَشْرَبِي</span>.</span><span class="rule-table-ru">Ты не пила.</span></td>
              <td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нуна</span></td>
            </tr>
            <tr>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ <span class="ar-tone-verb">تَشْرَبُونَ</span>.</span><span class="rule-table-ru">Вы пьёте.</span></td>
              <td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ثُبُوتُ النُّونِ</span><span class="rule-table-ru">сохранение нуна</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb ar-tone-nasb">تَشْرَبُوا</span>.</span><span class="rule-table-ru">Вы не будете пить.</span></td>
              <td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нуна</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb ar-tone-jazm">تَشْرَبُوا</span>.</span><span class="rule-table-ru">Вы не пили.</span></td>
              <td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нуна</span></td>
            </tr>
            <tr>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ <span class="ar-tone-verb">تَشْرَبْنَ</span>.</span><span class="rule-table-ru">Вы пьёте.</span></td>
              <td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">неизменяем на сукуне</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb">تَشْرَبْنَ</span>.</span><span class="rule-table-ru">Вы не будете пить.</span></td>
              <td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">неизменяем на сукуне</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">تَشْرَبْنَ</span>.</span><span class="rule-table-ru">Вы не пили.</span></td>
              <td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">неизменяем на сукуне</span></td>
            </tr>
            <tr>
              <td rowspan="2"><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْمُتَكَلِّمُ</span><span class="rule-table-ru">первое лицо</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span><span class="rule-table-ru">я</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا <span class="ar-tone-verb">أَشْرَبُ</span>.</span><span class="rule-table-ru">Я пью.</span></td>
              <td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الضَّمَّةُ</span><span class="rule-table-ru">дамма</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb ar-tone-nasb">أَشْرَبَ</span>.</span><span class="rule-table-ru">Я не буду пить.</span></td>
              <td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">الْفَتْحَةُ</span><span class="rule-table-ru">фатха</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb ar-tone-jazm">أَشْرَبْ</span>.</span><span class="rule-table-ru">Я не пил или не пила.</span></td>
              <td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td>
            </tr>
            <tr>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span><span class="rule-table-ru">мы</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ <span class="ar-tone-verb">نَشْرَبُ</span>.</span><span class="rule-table-ru">Мы пьём.</span></td>
              <td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الضَّمَّةُ</span><span class="rule-table-ru">дамма</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb ar-tone-nasb">نَشْرَبَ</span>.</span><span class="rule-table-ru">Мы не будем пить.</span></td>
              <td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">الْفَتْحَةُ</span><span class="rule-table-ru">фатха</span></td>
              <td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb ar-tone-jazm">نَشْرَبْ</span>.</span><span class="rule-table-ru">Мы не пили.</span></td>
              <td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td>
            </tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Формы с نُونُ النِّسْوَةِ</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">يَشْرَبْنَ</span>، <span class="ar-tone-particle">لَنْ</span> <span class="ar-tone-verb">يَشْرَبْنَ</span>، <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">يَشْرَبْنَ</span>: <span class="ar-tone-structure">مَبْنِيٌّ عَلَى السُّكُونِ</span>.</span>
        <p class="rule-study-text">При присоединении <span class="ar-inline" dir="rtl" lang="ar">نُونِ النِّسْوَةِ</span> — нуна женского множественного числа — форма глагола остаётся неизменяемой на сукуне во всех трёх колонках.</p>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الثاني والعشرون
حالات الفعل المضارع الثلاث
انظر كتاب التدريبات للمستوى الثاني ص ١٥٣.$$,
      52, 52, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الدرس الثاني والعشرون
حالات المضارع الثلاث
رتب الضمائر
المضارع المرفوع
علامة الرفع
المضارع المنصوب
علامة النصب
المضارع المجزوم
علامة الجزم
الغائب
حامد يشرب
الضمة
لن يشرب
الفتحة
لم يشرب
السكون
آمنة تشرب
الضمة
لن تشرب
الفتحة
لم تشرب
السكون
الطلاب يشربون
ثبوت النون
لن يشربوا
حذف النون
لم يشربوا
حذف النون
الطالبات يشربن
مبني على السكون
لن يشربن
مبني على السكون
لم يشربن
مبني على السكون
المخاطب
أنت تشرب
الضمة
لن تشرب
الفتحة
لم تشرب
السكون
أنت تشربين
ثبوت النون
لن تشربي
حذف النون
لم تشربي
حذف النون
أنتم تشربون
ثبوت النون
لن تشربوا
حذف النون
لم تشربوا
حذف النون
أنتن تشربن
مبني على السكون
لن تشربن
مبني على السكون
لم تشربن
مبني على السكون
المتكلم
أنا أشرب
الضمة
لن أشرب
الفتحة
لم أشرب
السكون
نحن نشرب
الضمة
لن نشرب
الفتحة
لم نشرب
السكون$$,
      42, 42, 2);

  if exists (
    select 1 from public.rules
    where id = rule_1_id
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 22 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources where rule_id = rule_1_id
  ) <> 2 then
    raise exception 'Expected 2 Book 2 lesson 22 source rows';
  end if;
end
$migration$;

commit;
