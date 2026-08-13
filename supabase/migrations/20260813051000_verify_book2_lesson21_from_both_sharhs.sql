-- Verify Medina Book 2 lesson 21 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 47-52.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 40-41.

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
    and lesson_number = '21';

  if lesson_rule_count not in (5, 7) then
    raise exception 'Expected 5 or 7 Book 2 lesson 21 rules, found %', lesson_rule_count;
  end if;

  if lesson_rule_count = 5 then
    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values
      ('Мединский курс (Том 2)', '21', '', '', 6, 'rule', '', '')
    returning id into rule_6_id;

    insert into public.rules
      (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values
      ('Мединский курс (Том 2)', '21', '', '', 7, 'note', '', '')
    returning id into rule_7_id;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '21' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '21' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '21' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '21' and sort_order = 4;
  select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '21' and sort_order = 5;
  select id into strict rule_6_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '21' and sort_order = 6;
  select id into strict rule_7_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '21' and sort_order = 7;

  delete from public.rule_sections
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id, rule_7_id);

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id, rule_7_id);

  -- 1. Lam and lamma: government, meanings, ten forms, signs, omission, and i'rab.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'جَزْمُ الْفِعْلِ الْمُضَارِعِ بِـ«لَمْ» وَ«لَمَّا» (джазм настоящего глагола частицами «не» и «ещё не»)',
    rule_ar = '«لَمْ» وَ«لَمَّا» حَرْفَا جَزْمٍ وَنَفْيٍ يَجْزِمَانِ الْفِعْلَ الْمُضَارِعَ وَيَقْلِبَانِ زَمَنَهُ إِلَى الْمَاضِي؛ وَتَدُلُّ «لَمَّا» عَلَى أَنَّ الْفِعْلَ لَمْ يَقَعْ إِلَى الْآنِ مَعَ تَوَقُّعِ وُقُوعِهِ. وَعَلَامَةُ الْجَزْمِ السُّكُونُ، أَوْ حَذْفُ النُّونِ فِي الْأَفْعَالِ الْخَمْسَةِ؛ وَالْمُضَارِعُ الْمُتَّصِلُ بِنُونِ النِّسْوَةِ مَبْنِيٌّ عَلَى السُّكُونِ.',
    summary = 'Обе частицы отрицают действие и ставят настоящий глагол в джазм. لَمْ сообщает о несовершившемся прошлом, а لَمَّا означает «ещё не» и выражает ожидание действия; сохранены все десять форм, признаки и разборы двух шархов.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Значение и различие</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">لَمْ</span><span class="rule-term-ru">«не»: отрицает действие и переносит значение настоящего глагола в прошлое. После ответа действие в будущем может произойти, а может и не произойти.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">لَمَّا</span><span class="rule-term-ru">«ещё не»: действие не произошло до настоящего момента, но ожидается позднее.</span></div>
        </div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">أَكْتُبْ</span>.</span><span class="rule-example-ru">Я не написал.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">أَكْتُبْ</span>.</span><span class="rule-example-ru">Я ещё не написал; напишу, если пожелает Аллах.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все десять форм из второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Лицо</th><th><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ</span><span class="rule-table-ru">не сделал</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">لَمَّا</span><span class="rule-table-ru">ещё не сделал</span></th><th>Исполнитель</th><th>Признак</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَامِدٌ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">يَذْهَبْ</span>.</span><span class="rule-table-ru">Хамид не ушёл.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَامِدٌ <span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">يَذْهَبْ</span>.</span><span class="rule-table-ru">Хамид ещё не ушёл.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هُوَ»</span><span class="rule-table-ru">скрытое «он»</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span><span class="rule-table-ru">они, мужской род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطُّلَّابُ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">يَذْهَبُوا</span>.</span><span class="rule-table-ru">Студенты не ушли.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطُّلَّابُ <span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">يَذْهَبُوا</span>.</span><span class="rule-table-ru">Студенты ещё не ушли.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">вау множественного числа</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нуна</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَائِشَةُ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">تَذْهَبْ</span>.</span><span class="rule-table-ru">Аиша не ушла.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَائِشَةُ <span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">تَذْهَبْ</span>.</span><span class="rule-table-ru">Аиша ещё не ушла.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هِيَ»</span><span class="rule-table-ru">скрытое «она»</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span><span class="rule-table-ru">они, женский род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَاتُ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">يَذْهَبْنَ</span>.</span><span class="rule-table-ru">Студентки не ушли.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَاتُ <span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">يَذْهَبْنَ</span>.</span><span class="rule-table-ru">Студентки ещё не ушли.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span><span class="rule-table-ru">нун женского множественного числа</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">неизменяем на сукуне</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">تَذْهَبْ</span>.</span><span class="rule-table-ru">Ты не ушёл.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ <span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">تَذْهَبْ</span>.</span><span class="rule-table-ru">Ты ещё не ушёл.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنْتَ»</span><span class="rule-table-ru">скрытое «ты»</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">تَذْهَبُوا</span>.</span><span class="rule-table-ru">Вы не ушли.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ <span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">تَذْهَبُوا</span>.</span><span class="rule-table-ru">Вы ещё не ушли.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">вау множественного числа</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нуна</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">تَذْهَبِي</span>.</span><span class="rule-table-ru">Ты не ушла.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ <span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">تَذْهَبِي</span>.</span><span class="rule-table-ru">Ты ещё не ушла.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span><span class="rule-table-ru">йа обращения к женщине</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нуна</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">تَذْهَبْنَ</span>.</span><span class="rule-table-ru">Вы не ушли.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ <span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">تَذْهَبْنَ</span>.</span><span class="rule-table-ru">Вы ещё не ушли.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span><span class="rule-table-ru">нун женского множественного числа</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-table-ru">неизменяем на сукуне</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">أَذْهَبْ</span>.</span><span class="rule-table-ru">Я не ушёл или не ушла.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا <span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">أَذْهَبْ</span>.</span><span class="rule-table-ru">Я ещё не ушёл или не ушла.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنَا»</span><span class="rule-table-ru">скрытое «я»</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">نَذْهَبْ</span>.</span><span class="rule-table-ru">Мы не ушли.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ <span class="ar-tone-particle">لَمَّا</span> <span class="ar-tone-verb">نَذْهَبْ</span>.</span><span class="rule-table-ru">Мы ещё не ушли.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «نَحْنُ»</span><span class="rule-table-ru">скрытое «мы»</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Разбор и допустимый краткий ответ</span>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span>: حَرْفُ جَزْمٍ وَنَفْيٍ مَبْنِيٌّ عَلَى السُّكُونِ.</span><span class="rule-analysis-ru">Частица джазма и отрицания, неизменяемая на сукуне.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">أَكْتُبْ</span>: فِعْلٌ مُضَارِعٌ مَجْزُومٌ بِـ«لَمْ»، وَعَلَامَةُ جَزْمِهِ السُّكُونُ عَلَى آخِرِهِ.</span><span class="rule-analysis-ru">Глагол настоящего времени в джазме после <span class="ar-inline" dir="rtl" lang="ar">لَمْ</span>; показатель джазма — сукун в конце.</span></div>
        </div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَكَتَبْتَ الْوَاجِبَ؟ <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">أَكْتُبْ</span>.</span><span class="rule-example-ru">Ты написал домашнее задание? Я не написал. После <span class="ar-inline" dir="rtl" lang="ar">لَمْ</span> глагол опускать нельзя.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَكَتَبْتَ الْوَاجِبَ؟ <span class="ar-tone-particle">لَمَّا</span>.</span><span class="rule-example-ru">Ты написал домашнее задание? Ещё нет. После <span class="ar-inline" dir="rtl" lang="ar">لَمَّا</span> глагол можно опустить.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَخَرَجَ الطُّلَّابُ؟ <span class="ar-tone-particle">لَمَّا</span>. أَيْ: <span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">يَخْرُجُوا</span>.</span><span class="rule-example-ru">Студенты вышли? Ещё нет, то есть они ещё не вышли.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الحادي والعشرون
جزم الفعل المضارع بـ"لم" و"لما"
لم ولما: حرفا جزم ونفي يجزمان الفعل المضارع.
المدرس: أكتبت ما على السبورة يا حامد؟
حامد: لا، لم أكتب (بمعنى ما كتبته).
المدرس: أتكتب ما على السبورة يا حامد؟
حامد: لما أكتب (بمعنى ما كتبته إلى الآن وسأكتبه بعد قليل).
الإعراب:
لم: حرف الجزم مبني على السكون.
أكتب: فعل مضارع مجزوم بـ(لم) وعلامة جزمه السكون على آخره.
تنبيه: يجوز حذف الفعل بعد لما.
نحو: أخرج الطلاب؟ لما (أي: لم يخرجوا).
تنبيه: يبنى الفعل المضارع على السكون إذا اتصلت به نون النسوة.$$,
      47, 48, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الدرس الحادي والعشرون
جزم المضارع بـ(لم، ولما)
إسناد الفعل المضارع المجزوم بـ(لم، ولما) إلى الضمائر.
حامد لم يذهب. حامد لما يذهب.
الطلاب لم يذهبوا. الطلاب لما يذهبوا.
عائشة لم تذهب. عائشة لما تذهب.
الطالبات لم يذهبن. الطالبات لما يذهبن.
أنت لم تذهب. أنتم لم تذهبوا. أنت لم تذهبي. أنتن لم تذهبن.
أنا لم أذهب. نحن لم نذهب.
لم أذهب، لما تذهب، لم يذهب، لما نذهب: علامة الجزم السكون.
لم يذهبوا، لما تذهبي: علامة الجزم حذف النون.
لم يذهبن، لما تذهبن: مبني على السكون.
لم: حرف جزم ونفي يجزم الفعل المضارع، ويقلب زمنه إلى الزمن الماضي.
لما: حرف جزم ونفي يجزم الفعل المضارع، ويقلب زمنه إلى الزمن الماضي.
لم أكتب، معناه: استمرار النفي، أي عدم الكتابة (قد يكتب، وقد لا يكتب).
لما أكتب، معناه: ما كتبت إلى الآن، وسأكتب إن شاء الله.
أكتبت الواجب؟ لم أكتب، لا يجوز حذف الفعل.
أكتبت الواجب؟ لما أكتب، يجوز حذف الفعل، وتقول في الجواب: لما.$$,
      40, 40, 2);

  -- 2. The three word classes and their meanings.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'أَقْسَامُ الْكَلِمَةِ (три части слова)',
    rule_ar = 'الْكَلِمَةُ ثَلَاثَةُ أَقْسَامٍ: اِسْمٌ لَهُ مَعْنًى وَلَيْسَ لَهُ زَمَنٌ، وَفِعْلٌ لَهُ مَعْنًى وَلَهُ زَمَنٌ، وَحَرْفٌ لَيْسَ لَهُ مَعْنًى إِلَّا فِي الْجُمْلَةِ.',
    summary = 'Слово относится к имени, глаголу или частице. Имя имеет значение без времени, глагол имеет значение и время, а значение частицы раскрывается только в предложении.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три части</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">اِسْمٌ</span><span class="rule-term-ru">имя: имеет собственное значение, но не обозначает время.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلٌ</span><span class="rule-term-ru">глагол: имеет значение и обозначает время.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">حَرْفٌ</span><span class="rule-term-ru">частица: её значение проявляется только внутри предложения.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Примеры обоих шархов</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Часть</th><th>Арабские примеры</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">اِسْمٌ</span><span class="rule-table-ru">имя</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مُحَمَّدٌ، الْمَعْهَدُ، قَلَمٌ، كِتَابٌ، الْكِتَابُ، الْمُدَرِّسُ، هُوَ.</span></td><td>Мухаммад, институт, ручка, книга, определённая книга, преподаватель, он.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلٌ</span><span class="rule-table-ru">глагол</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَرَأَ، كَتَبَ، كَتَبُوا؛ يَقْرَأُ، يَكْتُبُ، يَكْتُبُونَ، تَكْتُبِينَ؛ اِقْرَأْ، اُكْتُبْ، اُكْتُبِي، اُكْتُبُوا.</span></td><td>Прочитал, написал, они написали; читает, пишет, они пишут, ты пишешь; читай, пиши, пиши женщине, пишите.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">حَرْفٌ</span><span class="rule-table-ru">частица</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِي، إِلَى، عَنْ، هَلْ، قَدْ، لَمْ، لَمَّا، لَا، لَنْ، أَنْ.</span></td><td>В, к, от или о, вопросительная частица, уже или действительно, не, ещё не, не, не будет, чтобы.</td></tr>
          </tbody>
        </table></div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا <span class="ar-tone-particle">فِي</span> الْبَيْتِ.</span><span class="rule-example-ru">Я дома.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَمْ</span> <span class="ar-tone-verb">أَخْرُجْ</span>.</span><span class="rule-example-ru">Я не вышел.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">هَلْ</span> <span class="ar-tone-verb">تُسَافِرُ</span> مَعِي؟</span><span class="rule-example-ru">Ты поедешь со мной?</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَا</span> <span class="ar-tone-verb">تَلْعَبْ</span>.</span><span class="rule-example-ru">Не играй.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$أقسام الكلمة
الكلمة تنقسم إلى ثلاثة أقسام:
1. الاسم، نحو: المدرس، الكتاب، هو.
2. الفعل، نحو: ذهبت، أذهب، اذهب.
3. الحرف، نحو: في، إلى، عن، هل، قد.$$,
      48, 50, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$أقسام الكلمة
الكلمة ثلاثة أقسام، هي:
1- الاسم، له معنى، وليس له زمن، نحو: محمد، المعهد، قلم، كتاب، الكتاب.
2- الفعل، له معنى، وله زمن، والزمن ثلاثة أقسام، هي:
أ- الماضي: قرأ، كتب، كتبوا.
ب- المضارع: يقرأ، يكتب، يكتبون، تكتبين.
ج- الأمر: اقرأ، اكتب، اكتبي، اكتبوا.
3- الحرف، ليس له معنى إلا في الجملة، نحو: في، إلى، عن، هل، قد، لم، لما، لا، لن، أن.
تقول: أنا في البيت. لم أخرج. هل تسافر معي؟ لا تلعب.$$,
      41, 41, 2);

  -- 3. Detailed noun divisions and signs from the 80-page sharh.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'أَقْسَامُ الِاسْمِ وَعَلَامَاتُهُ (виды и признаки имени)',
    rule_ar = 'يَنْقَسِمُ الِاسْمُ بِاعْتِبَارِ الْجِنْسِ إِلَى مُذَكَّرٍ وَمُؤَنَّثٍ، وَبِاعْتِبَارِ الْعَدَدِ إِلَى مُفْرَدٍ وَمُثَنًّى وَجَمْعٍ؛ وَمِنْ أَنْوَاعِهِ اِسْمُ الْجَمْعِ، وَاِسْمُ الْجِنْسِ الْجَمْعِيُّ، وَاِسْمُ الْجِنْسِ الْإِفْرَادِيُّ. وَمِنْ عَلَامَاتِ الِاسْمِ الْجَرُّ، وَالتَّنْوِينُ، وَالنِّدَاءُ، وَ«أَلْ» التَّعْرِيفُ، وَالْإِسْنَادُ إِلَيْهِ.',
    summary = 'Подробный шарх делит имя по роду и числу, объясняет три вида множественного числа, собирательные и родовые имена и перечисляет пять признаков имени.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Род, число и виды множественного числа</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Основание</th><th>Арабское название</th><th>Пример</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td>Род</td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُذَكَّرٌ</span><span class="rule-table-ru">мужской род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَجُلٌ، جَمَلٌ.</span></td><td>Мужчина, верблюд.</td></tr>
            <tr><td>Род</td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُؤَنَّثٌ</span><span class="rule-table-ru">женский род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِمْرَأَةٌ، نَاقَةٌ.</span></td><td>Женщина, верблюдица.</td></tr>
            <tr><td>Число</td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُفْرَدٌ</span><span class="rule-table-ru">единственное число</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبُ.</span></td><td>Студент.</td></tr>
            <tr><td>Число</td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُثَنًّى</span><span class="rule-table-ru">двойственное число</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَانِ.</span></td><td>Два студента.</td></tr>
            <tr><td>Число</td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">جَمْعٌ</span><span class="rule-table-ru">множественное число</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطُّلَّابُ.</span></td><td>Студенты.</td></tr>
            <tr><td>Вид множественного числа</td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">جَمْعُ مُذَكَّرٍ سَالِمٌ</span><span class="rule-table-ru">правильное мужское множественное</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُدَرِّسُونَ؛ جَمْعُ «الْمُدَرِّسِ».</span></td><td>Преподаватели; множественное от «преподаватель».</td></tr>
            <tr><td>Вид множественного числа</td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">جَمْعُ مُؤَنَّثٍ سَالِمٌ</span><span class="rule-table-ru">правильное женское множественное</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">طَالِبَاتٌ؛ جَمْعُ «طَالِبَةٍ».</span></td><td>Студентки; множественное от «студентка».</td></tr>
            <tr><td>Вид множественного числа</td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">جَمْعُ تَكْسِيرٍ</span><span class="rule-table-ru">ломаное множественное</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">طُلَّابٌ؛ جَمْعُ «طَالِبٍ».</span></td><td>Студенты; множественное от «студент».</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Собирательные и родовые имена</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">اِسْمُ الْجَمْعِ: قَوْمٌ، جَيْشٌ.</span><span class="rule-term-ru">собирательное имя: народ, войско.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">اِسْمُ الْجِنْسِ الْجَمْعِيُّ</span><span class="rule-term-ru">собирательно-родовое имя: обозначает три предмета и более. Единственное отличается либо круглой та: <span class="ar-inline" dir="rtl" lang="ar">تَمْرٌ؛ تَمْرَةٌ</span> — финики; один финик, либо относительной йа: <span class="ar-inline" dir="rtl" lang="ar">يَهُودٌ؛ يَهُودِيٌّ</span> — иудеи; иудей.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">اِسْمُ الْجِنْسِ الْإِفْرَادِيُّ: مَاءٌ، زَيْتٌ.</span><span class="rule-term-ru">индивидуально-родовое имя: одним словом обозначает малое и большое количество одного вещества — вода, масло.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Пять признаков имени</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Арабский термин</th><th>Пример</th><th>Русское объяснение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр, родительный падеж</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَخَلْتُ <span class="ar-tone-particle">فِي</span> <span class="ar-tone-jarr">الْفَصْلِ</span>.</span><span class="rule-table-ru">Я вошёл в аудиторию.</span></td><td>Имя принимает состояние джарр.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">التَّنْوِينُ</span><span class="rule-table-ru">танвин</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَلَمٌ.</span><span class="rule-table-ru">Ручка.</span></td><td>Имя может принимать танвин.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">النِّدَاءُ</span><span class="rule-table-ru">обращение</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">يَا</span> مُحَمَّدُ.</span><span class="rule-table-ru">О Мухаммад!</span></td><td>К имени обращаются посредством частицы обращения.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">«أَلْ» التَّعْرِيفُ</span><span class="rule-table-ru">определённый артикль</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُدَرِّسُ.</span><span class="rule-table-ru">Преподаватель.</span></td><td>К имени присоединяется определённый артикль.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْإِسْنَادُ إِلَيْهِ</span><span class="rule-table-ru">приписывание сообщения имени</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا طَالِبٌ.</span><span class="rule-table-ru">Я студент.</span></td><td>Об имени можно сообщить признак или действие.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$ينقسم الاسم باعتبار الجنس إلى:
مذكر، نحو: رجل، جمل.
مؤنث، نحو: امرأة، ناقة.
ينقسم الاسم باعتبار العدد إلى:
مفرد، نحو: الطالب. مثنى، نحو: الطالبان. جمع، نحو: الطلاب.
ينقسم الجمع إلى: جمع مذكر سالم، نحو: المدرسون جمع المدرس. جمع مؤنث سالم، نحو: طالبات جمع طالبة. جمع التكسير، نحو: طلاب جمع طالب.
ينقسم الاسم كذلك إلى:
اسم الجمع، نحو: قوم، جيش.
اسم الجنس وينقسم إلى قسمين:
اسم الجنس الجمعي، هو ما دل على ثلاثة فأكثر، نحو: تمر، يهود. هذا القسم يكون الفرق بين مفرده وبين جمعه إما بالتاء المربوطة، نحو: تمر، تمرة، وإما بالياء المشددة، نحو: يهود، يهودي.
اسم الجنس الإفرادي، هو ما دل على القليل والكثير من جنس واحد بلفظ واحد، نحو: ماء، زيت.
علامات الاسم:
الجر، نحو: دخلت في الفصل. التنوين، نحو: قلم. النداء، نحو: يا محمد. أل التعريف، نحو: المدرس. الإسناد إليه، نحو: أنا طالب.$$,
      48, 49, 1);

  -- 4. Verb divisions and signs, building/meaning letters, and the i'rab matrix.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'أَقْسَامُ الْفِعْلِ وَعَلَامَاتُهُ، وَأَقْسَامُ الْحُرُوفِ (виды и признаки глагола; виды букв и частиц)',
    rule_ar = 'يَنْقَسِمُ الْفِعْلُ بِاعْتِبَارِ زَمَنِهِ إِلَى مَاضٍ وَمُضَارِعٍ وَأَمْرٍ. وَمِنْ عَلَامَاتِ الْمَاضِي قَبُولُ تَاءِ الْفَاعِلِ وَتَاءِ التَّأْنِيثِ السَّاكِنَةِ، وَمِنْ عَلَامَاتِ الْمُضَارِعِ قَبُولُ «لَمْ» وَالسِّينِ وَ«سَوْفَ»، وَمِنْ عَلَامَاتِ الْأَمْرِ دَلَالَتُهُ عَلَى الطَّلَبِ مَعَ قَبُولِ نُونِ التَّوْكِيدِ أَوْ يَاءِ الْمُخَاطَبَةِ. وَالْحُرُوفُ قِسْمَانِ: حُرُوفُ مَبَانٍ، وَحُرُوفُ مَعَانٍ.',
    summary = 'Глагол делится на прошедший, настоящий и повелительный; подробный шарх перечисляет признаки каждого. Также различены буквы построения слова и смысловые частицы и показаны допустимые виды إعراب для имени и настоящего глагола.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три вида глагола</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Арабское название</th><th>Примеры</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمَاضِي</span><span class="rule-table-ru">прошедший глагол</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ذَهَبَ؛ قَرَأَ، كَتَبَ، كَتَبُوا.</span></td><td>Ушёл; прочитал, написал, они написали.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمُضَارِعُ</span><span class="rule-table-ru">настоящий или будущий глагол</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَذْهَبُ؛ يَقْرَأُ، يَكْتُبُ، يَكْتُبُونَ، تَكْتُبِينَ.</span></td><td>Я иду; он читает, пишет, они пишут, ты пишешь.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلُ الْأَمْرِ</span><span class="rule-table-ru">повелительный глагол</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اِذْهَبْ؛ اِقْرَأْ، اُكْتُبْ، اُكْتُبِي، اُكْتُبُوا.</span></td><td>Иди; читай, пиши, пиши женщине, пишите.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Признаки каждого вида</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمَاضِي</span><span class="rule-term-ru">принимает <span class="ar-inline" dir="rtl" lang="ar">تَاءَ الْفَاعِلِ</span> — та исполнителя: <span class="ar-inline" dir="rtl" lang="ar">ذَهَبْتُ، قُلْتُ، أَكَلْتُ</span>; и <span class="ar-inline" dir="rtl" lang="ar">تَاءَ التَّأْنِيثِ السَّاكِنَةَ</span> — неподвижную та женского рода: <span class="ar-inline" dir="rtl" lang="ar">جَاءَتْ فَاطِمَةُ وَذَهَبَتْ</span>.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمُضَارِعُ</span><span class="rule-term-ru">принимает <span class="ar-inline" dir="rtl" lang="ar">لَمْ</span>: <span class="ar-inline" dir="rtl" lang="ar">الطَّالِبُ لَمْ يَخْرُجْ</span>; а также син или <span class="ar-inline" dir="rtl" lang="ar">سَوْفَ</span>: <span class="ar-inline" dir="rtl" lang="ar">سَأَذْهَبُ، سَوْفَ أَذْهَبُ</span>.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلُ الْأَمْرِ</span><span class="rule-term-ru">выражает требование и принимает <span class="ar-inline" dir="rtl" lang="ar">نُونَ التَّوْكِيدِ</span> — усилительный нун: <span class="ar-inline" dir="rtl" lang="ar">اِقْرَأَنَّ</span>; либо <span class="ar-inline" dir="rtl" lang="ar">يَاءَ الْمُخَاطَبَةِ</span> — йа обращения к женщине: <span class="ar-inline" dir="rtl" lang="ar">اِذْهَبِي</span>.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Два вида букв</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">حُرُوفُ مَبَانٍ</span><span class="rule-term-ru">буквы алфавита, из которых строится слово: <span class="ar-inline" dir="rtl" lang="ar">السِّينُ فِي كَلِمَةِ «السَّيَّارَةِ»</span> — буква син в слове «машина».</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">حُرُوفُ مَعَانٍ</span><span class="rule-term-ru">смысловые частицы, являющиеся частью речи: <span class="ar-inline" dir="rtl" lang="ar">السِّينُ فِي جُمْلَةِ «سَأَكْتُبُ»</span> — син будущего времени в предложении «я напишу».</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Виды إعراب у имени и настоящего глагола</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Категория</th><th><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ</span></th><th><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></th><th><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></th><th><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">الْجَزْمُ</span><span class="rule-table-ru">джазм</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الِاسْمُ</span><span class="rule-table-ru">имя</span></td><td>есть</td><td>есть</td><td>есть</td><td>нет</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمُضَارِعُ</span><span class="rule-table-ru">настоящий глагол</span></td><td>есть</td><td>есть</td><td>нет</td><td>есть</td></tr>
          </tbody>
        </table></div>
        <span class="rule-main-ar" dir="rtl" lang="ar">لَا جَزْمَ فِي الْأَسْمَاءِ، وَلَا جَرَّ فِي الْأَفْعَالِ.</span>
        <p class="rule-study-text">У имён не бывает джазма, а у глаголов не бывает джарра.</p>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$الفعل، نحو: ذهبت، أذهب، اذهب.
ينقسم الفعل باعتبار زمانه إلى ثلاثة أقسام: الماضي، نحو: ذهب. المضارع، نحو: أذهب. الأمر، نحو: اذهب.
علامات الفعل:
الفعل الماضي: قبوله تاء الفاعل، نحو: ذهبت، قلت، أكلت. قبوله تاء التأنيث الساكنة، نحو: جاءت فاطمة وذهبت.
الفعل المضارع: قبوله (لم)، نحو: الطالب لم يخرج. قبوله السين، أو سوف، نحو: سأذهب، سوف أذهب.
فعل الأمر: الدلالة على الطلب مع قبوله نون التوكيد، نحو: اقرأن. الدلالة على الطلب مع قبوله ياء المخاطبة، نحو: اذهبي.
الحرف، نحو: في، إلى، عن، هل، قد.
الحروف تنقسم إلى قسمين:
حروف مبان، هي حروف الهجاء التي تبنى منها الكلمة، نحو: السين في كلمة السيارة.
حروف معان، نحو: السين في جملة سأكتب.
أنواع الإعراب في الاسم والفعل المضارع:
الاسم: الرفع، والنصب، والجر، ولا جزم فيه.
الفعل المضارع: الرفع، والنصب، والجزم، ولا جر فيه.
تنبيه: لا جزم في الأسماء ولا جر في الأفعال.$$,
      49, 50, 1),
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الفعل، له معنى، وله زمن، والزمن ثلاثة أقسام، هي:
الماضي: قرأ، كتب، كتبوا.
المضارع: يقرأ، يكتب، يكتبون، تكتبين.
الأمر: اقرأ، اكتب، اكتبي، اكتبوا.
الحرف، ليس له معنى إلا في الجملة، نحو: في، إلى، عن، هل، قد، لم، لما، لا، لن، أن.$$,
      41, 41, 2);

  -- 5. Nominal and verbal sentences, predicate types and order, and full i'rab.
  update public.rules
  set
    sort_order = 5,
    rule_kind = 'rule',
    title = 'الْجُمْلَةُ الِاسْمِيَّةُ وَالْجُمْلَةُ الْفِعْلِيَّةُ (именное и глагольное предложения)',
    rule_ar = 'الْجُمْلَةُ الِاسْمِيَّةُ تَبْدَأُ بِاسْمٍ وَتَتَكَوَّنُ مِنْ مُبْتَدَأٍ وَخَبَرٍ، وَهُمَا مَرْفُوعَانِ؛ وَالْجُمْلَةُ الْفِعْلِيَّةُ تَبْدَأُ بِفِعْلٍ وَتَتَكَوَّنُ مِنْ فِعْلٍ وَفَاعِلٍ، وَالْفَاعِلُ دَائِمًا مَرْفُوعٌ. وَيَكُونُ خَبَرُ الْمُبْتَدَإِ مُفْرَدًا، أَوْ جُمْلَةً، أَوْ شِبْهَ جُمْلَةٍ، وَقَدْ يَتَقَدَّمُ الْخَبَرُ عَلَى الْمُبْتَدَإِ فِي الْمَوَاضِعِ الْمَذْكُورَةِ.',
    summary = 'Именное предложение начинается именем и состоит из مبتدأ и خبر; глагольное начинается глаголом и состоит из глагола и исполнителя. Сохранены разборы, виды сказуемого и случаи его постановки перед подлежащим.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Строение двух предложений</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Вид</th><th>Правило</th><th>Пример</th><th>Члены предложения</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْجُمْلَةُ الِاسْمِيَّةُ</span><span class="rule-table-ru">именное предложение</span></td><td>Начинается именем.</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">الطَّالِبُ</span> <span class="ar-tone-khabar">مُجْتَهِدٌ</span>.</span><span class="rule-table-ru">Студент усердный.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُبْتَدَأٌ مَرْفُوعٌ</span><span class="rule-table-ru">подлежащее в рафъ</span><span class="rule-table-ar ar-tone-khabar" dir="rtl" lang="ar">خَبَرٌ مَرْفُوعٌ</span><span class="rule-table-ru">сказуемое в рафъ</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْجُمْلَةُ الِاسْمِيَّةُ</span><span class="rule-table-ru">именное предложение со сказуемым-предложением</span></td><td>Начинается именем.</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">الْمُدَرِّسُ</span> <span class="ar-tone-khabar">خَرَجَ</span>.</span><span class="rule-table-ru">Преподаватель вышел.</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُبْتَدَأٌ مَرْفُوعٌ</span><span class="rule-table-ru">подлежащее в рафъ</span><span class="rule-table-ar ar-tone-khabar" dir="rtl" lang="ar">خَبَرٌ فِي مَحَلِّ رَفْعٍ</span><span class="rule-table-ru">предложение-сказуемое занимает место рафъ</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْجُمْلَةُ الْفِعْلِيَّةُ</span><span class="rule-table-ru">глагольное предложение</span></td><td>Начинается глаголом.</td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">خَرَجَ</span> <span class="ar-tone-subject">الْمُدَرِّسُ</span>.</span><span class="rule-table-ru">Преподаватель вышел.</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلٌ</span><span class="rule-table-ru">глагол</span><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">فَاعِلٌ مَرْفُوعٌ</span><span class="rule-table-ru">исполнитель в рафъ</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اللَّهُ أَكْبَرُ. الطَّالِبُ مُجْتَهِدٌ. الْمُدَرِّسُ خَرَجَ. الطَّالِبَةُ تَكْتُبُ الْوَاجِبَ.</span><span class="rule-example-ru">Аллах превыше всего. Студент усерден. Преподаватель вышел. Студентка пишет домашнее задание.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">خَرَجَ الْمُدَرِّسُ. تَكْتُبُ الطَّالِبَةُ الْوَاجِبَ. اُكْتُبْ وَاجِبَكَ.</span><span class="rule-example-ru">Преподаватель вышел. Студентка пишет домашнее задание. Напиши своё домашнее задание.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный разбор именного предложения</span>
        <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">الْمُدَرِّسُ</span> <span class="ar-tone-khabar">خَرَجَ</span>.</span><span class="rule-example-ru">Преподаватель вышел.</span></div>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">الْمُدَرِّسُ</span>: مُبْتَدَأٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-analysis-ru">«Преподаватель» — подлежащее именного предложения в рафъ; показатель — явная дамма в конце.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">خَرَجَ</span>: فِعْلٌ مَاضٍ مَبْنِيٌّ عَلَى الْفَتْحِ، وَالْفَاعِلُ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «هُوَ»، وَجُمْلَةُ «خَرَجَ» فِي مَحَلِّ رَفْعٍ خَبَرٌ.</span><span class="rule-analysis-ru">«Вышел» — прошедший глагол, неизменяемый на фатхе; исполнитель — скрытое местоимение «он». Всё глагольное предложение занимает позицию сказуемого в рафъ.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Виды сказуемого</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Арабское название</th><th>Пример</th><th>Русское объяснение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-khabar" dir="rtl" lang="ar">خَبَرٌ مُفْرَدٌ</span><span class="rule-table-ru">одиночное сказуемое</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُدَرِّسُ <span class="ar-tone-khabar">جَدِيدٌ</span>.</span><span class="rule-table-ru">Преподаватель новый.</span></td><td>Сказуемое не является предложением или شبه جملة.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-khabar" dir="rtl" lang="ar">خَبَرٌ جُمْلَةٌ اسْمِيَّةٌ</span><span class="rule-table-ru">сказуемое — именное предложение</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُدَرِّسُ <span class="ar-tone-khabar">خَطُّهُ جَمِيلٌ</span>.</span><span class="rule-table-ru">У преподавателя красивый почерк.</span></td><td>Сказуемым служит целое именное предложение.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-khabar" dir="rtl" lang="ar">خَبَرٌ جُمْلَةٌ فِعْلِيَّةٌ</span><span class="rule-table-ru">сказуемое — глагольное предложение</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُدَرِّسُ <span class="ar-tone-khabar">دَخَلَ</span>.</span><span class="rule-table-ru">Преподаватель вошёл.</span></td><td>Сказуемым служит целое глагольное предложение.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-khabar" dir="rtl" lang="ar">خَبَرٌ شِبْهُ جُمْلَةٍ: جَارٌّ وَمَجْرُورٌ</span><span class="rule-table-ru">сказуемое-полупредложение: предлог с именем</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُدَرِّسُ <span class="ar-tone-khabar">فِي الْفَصْلِ</span>.</span><span class="rule-table-ru">Преподаватель в аудитории.</span></td><td>Сказуемое выражено предложной конструкцией.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-khabar" dir="rtl" lang="ar">خَبَرٌ شِبْهُ جُمْلَةٍ: ظَرْفٌ</span><span class="rule-table-ru">сказуемое-полупредложение: обстоятельство места</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُدَرِّسُ <span class="ar-tone-khabar">أَمَامَ الْمَسْجِدِ</span>.</span><span class="rule-table-ru">Преподаватель перед мечетью.</span></td><td>Сказуемое выражено обстоятельством.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Порядок подлежащего и сказуемого</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">الْأَصْلُ فِي الْمُبْتَدَإِ أَنْ يَتَقَدَّمَ عَلَى الْخَبَرِ: <span class="ar-tone-subject">الطَّالِبُ</span> <span class="ar-tone-khabar">جَالِسٌ</span>.</span>
        <p class="rule-study-text">Обычный порядок: сначала <span class="ar-inline" dir="rtl" lang="ar">الْمُبْتَدَأُ</span> — подлежащее, затем <span class="ar-inline" dir="rtl" lang="ar">الْخَبَرُ</span> — сказуемое.</p>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-khabar">أَيْنَ</span> <span class="ar-tone-subject">الْكِتَابُ</span>؟ <span class="ar-tone-khabar">كَيْفَ</span> <span class="ar-tone-subject">حَالُكَ</span>؟</span><span class="rule-example-ru">Где книга? Как твоё состояние? Если сказуемое — вопросительное слово, оно ставится первым.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-khabar">عِنْدِي</span> <span class="ar-tone-subject">قَلَمٌ</span>. <span class="ar-tone-khabar">لِي</span> <span class="ar-tone-subject">أَخٌ</span>. <span class="ar-tone-khabar">فِي الْفَصْلِ</span> <span class="ar-tone-subject">قِطٌّ</span>.</span><span class="rule-example-ru">У меня есть ручка. У меня есть брат. В аудитории есть кот. Если неопределённое подлежащее следует за شبه جملة, сказуемое ставится первым.</span></div>
        </div>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-khabar">أَيْنَ</span> وَ<span class="ar-tone-khabar">عِنْدِي</span>: خَبَرَانِ مُقَدَّمَانِ فِي مَحَلِّ رَفْعٍ.</span><span class="rule-analysis-ru">«Где» и «у меня» — два поставленных впереди сказуемых, каждое занимает место рафъ.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">الْكِتَابُ</span> وَ<span class="ar-tone-subject">قَلَمٌ</span>: مُبْتَدَآنِ مُؤَخَّرَانِ.</span><span class="rule-analysis-ru">«Книга» и «ручка» — два отложенных подлежащих.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный разбор глагольного предложения</span>
        <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">خَرَجَ</span> <span class="ar-tone-subject">مُحَمَّدٌ</span>.</span><span class="rule-example-ru">Мухаммад вышел.</span></div>
        <div class="rule-analysis">
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">خَرَجَ</span>: فِعْلٌ مَاضٍ مَبْنِيٌّ عَلَى الْفَتْحِ.</span><span class="rule-analysis-ru">Прошедший глагол, неизменяемый на фатхе.</span></div>
          <div class="rule-analysis-row"><span class="rule-analysis-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">مُحَمَّدٌ</span>: فَاعِلٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ عَلَى آخِرِهِ.</span><span class="rule-analysis-ru">Исполнитель в рафъ; показатель — явная дамма в конце.</span></div>
        </div>
        <span class="rule-main-ar ar-tone-subject" dir="rtl" lang="ar">الْفَاعِلُ دَائِمًا مَرْفُوعٌ.</span>
        <p class="rule-study-text">Исполнитель всегда стоит в состоянии рафъ.</p>
      </div>
    </div>$$
  where id = rule_5_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$الجملة الاسمية والجملة الفعلية
الجملة الاسمية: هي التي تبدأ باسم، نحو: المدرس خرج.
الجملة الاسمية تتكون من المبتدأ والخبر، والمبتدأ والخبر مرفوعان.
المدرس: مبتدأ مرفوع وعلامة رفعه الضمة الظاهرة على آخره.
خرج: فعل ماض مبني على الفتحة والفاعل ضمير مستتر تقديره "هو"، وجملة (خرج) في محل رفع خبر.
الخبر ثلاثة أنواع:
1. مفرد (ما ليس جملة ولا شبه جملة)، نحو: المدرس جديد.
2. جملة، وتنقسم إلى قسمين: جملة اسمية، نحو: المدرس خطه جميل. جملة فعلية، نحو: المدرس دخل.
3. شبه جملة، وتنقسم إلى قسمين: جار ومجرور، نحو: المدرس في الفصل. ظرف، نحو: المدرس أمام المسجد.
الأصل في المبتدأ أن يتقدم على الخبر، نحو: الطالب جالس.
لكن يتقدم الخبر على المبتدأ إذا كان الخبر اسم استفهام، أو إذا كان المبتدأ نكرة واسمه شبه جملة، نحو: أين الكتاب؟ كيف حالك؟ عندي قلم. لي أخ. في الفصل قط.
فيها (أين وعندي) خبر مقدم في محل رفع و(الكتاب وقلم) مبتدأ مؤخر.
الجملة الفعلية: هي التي تبدأ بفعل، نحو: خرج محمد.
خرج: فعل ماض مبني على الفتحة.
محمد: فاعل مرفوع وعلامة رفعه الضمة الظاهرة على آخره.
تنبيه: الفاعل دائما مرفوع.$$,
      51, 52, 1),
    (rule_5_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الجملتان الاسمية، والفعلية
الجملة الاسمية: تبدأ بالاسم، وتتكون من مبتدإ، وخبر.
أمثلة: الله أكبر، الطالب مجتهد، المدرس خرج، الطالبة تكتب الواجب.
الجملة الفعلية: تبدأ بالفعل، وتتكون من فعل، وفاعل.
أمثلة: خرج المدرس، تكتب الطالبة الواجب، اكتب واجبك.
الطالب مجتهد: مبتدأ مرفوع، خبر مرفوع.
المدرس خرج: مبتدأ مرفوع، خبر في محل رفع.
خرج المدرس: فعل، فاعل مرفوع.$$,
      41, 41, 2);

  -- 6. Feminine plural relative pronouns and the source explanation of "in the position of raf'".
  update public.rules
  set
    sort_order = 6,
    rule_kind = 'rule',
    title = 'اللَّاتِي وَاللَّائِي (относительные имена женского множественного числа)',
    rule_ar = '«اللَّاتِي» وَ«اللَّائِي» اسْمَانِ مَوْصُولَانِ يُسْتَعْمَلَانِ لِجَمْعِ الْمُؤَنَّثِ. وَمَعْنَى «فِي مَحَلِّ رَفْعٍ» أَنَّ التَّرْكِيبَ حَلَّ مَحَلَّ اسْمٍ مَرْفُوعٍ.',
    summary = 'Обе формы означают «которые» для женского множественного числа. Второй шарх также разъясняет выражение فِي مَحَلِّ رَفْعٍ как занятие позиции имени в рафъ.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Две равноправные формы</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">اللَّاتِي</span><span class="rule-term-ru">которые — для группы женского рода.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">اللَّائِي</span><span class="rule-term-ru">которые — вторая форма для группы женского рода.</span></div>
        </div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّالِبَاتُ <span class="ar-tone-structure">اللَّاتِي</span> خَرَجْنَ الْآنَ مِنَ الْيَابَانِ.</span><span class="rule-example-ru">Студентки, которые сейчас вышли, — из Японии.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّالِبَاتُ <span class="ar-tone-structure">اللَّائِي</span> خَرَجْنَ الْآنَ مِنَ الْيَابَانِ.</span><span class="rule-example-ru">Студентки, которые сейчас вышли, — из Японии.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّالِبَاتُ <span class="ar-tone-structure">اللَّاتِي</span> خَرَجْنَ مِنَ الْفَصْلِ الْآنَ مِنَ الْفِلِبِّينَ.</span><span class="rule-example-ru">Студентки, которые сейчас вышли из аудитории, — с Филиппин.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الطَّالِبَاتُ <span class="ar-tone-structure">اللَّائِي</span> خَرَجْنَ مِنَ الْفَصْلِ الْآنَ مِنَ الْفِلِبِّينَ.</span><span class="rule-example-ru">Студентки, которые сейчас вышли из аудитории, — с Филиппин.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Значение выражения в разборе</span>
        <span class="rule-main-ar ar-tone-raf" dir="rtl" lang="ar">فِي مَحَلِّ رَفْعٍ: مَعْنَاهُ أَنَّهُ حَلَّ مَحَلَّ اسْمٍ مَرْفُوعٍ.</span>
        <p class="rule-study-text">«В позиции рафъ» означает: конструкция заняла место имени, которое стояло бы в состоянии рафъ.</p>
      </div>
    </div>$$
  where id = rule_6_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_6_id, 'Podrobny_Sharkh_2_tom.pdf', $$اللاتي واللائي
اللاتي واللائي: اسمان موصولان يستعملان لجمع المؤنث.
الطالبات اللاتي (اللائي) خرجن الآن من اليابان.$$,
      52, 52, 1),
    (rule_6_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$اللاتي، واللائي
اللاتي، واللائي: اسمان موصولان لجمع المؤنث.
تقول: الطالبات اللاتي خرجن من الفصل الآن من الفلبين.
الطالبات اللائي خرجن من الفصل الآن من الفلبين.
في محل رفع: معناه أنه حل محل اسم مرفوع.$$,
      41, 41, 2);

  -- 7. Detailed-sharh note on foreign proper names and diptotes.
  update public.rules
  set
    sort_order = 7,
    rule_kind = 'note',
    title = 'الْعَلَمُ الْأَعْجَمِيُّ وَالْمَمْنُوعُ مِنَ الصَّرْفِ (иностранное собственное имя и диптот)',
    rule_ar = 'الْعَلَمُ الْأَعْجَمِيُّ مَمْنُوعٌ مِنَ الصَّرْفِ، إِلَّا إِذَا كَانَ ثُلَاثِيًّا سَاكِنَ الْوَسَطِ مُذَكَّرًا فَيَكُونُ مَصْرُوفًا؛ وَإِذَا كَانَ مُؤَنَّثًا مُنِعَ مِنَ الصَّرْفِ.',
    summary = 'Подробный шарх отмечает, что Харун — иностранное собственное имя и диптот. Иностранное трёхбуквенное мужское имя с неподвижной средней буквой склоняется полностью, а женское — не полностью.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Примечание автора</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">هَارُونُ: عَلَمٌ أَعْجَمِيٌّ مَمْنُوعٌ مِنَ الصَّرْفِ.</span><span class="rule-term-ru">Харун — иностранное собственное имя, не принимающее полное склонение.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">ثُلَاثِيٌّ سَاكِنُ الْوَسَطِ مُذَكَّرٌ</span><span class="rule-term-ru">если иностранное имя состоит из трёх букв, имеет сукун на средней и является мужским, оно склоняется полностью.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">ثُلَاثِيٌّ سَاكِنُ الْوَسَطِ مُؤَنَّثٌ</span><span class="rule-term-ru">если такое трёхбуквенное имя женского рода, оно является диптотом.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры подробного шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Разряд</th><th>Имена</th><th>Русская передача</th></tr></thead>
          <tbody>
            <tr><td>Полностью склоняемые мужские</td><td><span class="rule-table-ar" dir="rtl" lang="ar">نُوحٌ، خَانٌ، جُرْجٌ، شِيثٌ، لُوطٌ.</span></td><td>Нух, Хан, Джурдж, Шис, Лут.</td></tr>
            <tr><td>Женские диптоты</td><td><span class="rule-table-ar" dir="rtl" lang="ar">بَلْخُ، وَيْسُ.</span></td><td>Балх, Вайс.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_7_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_7_id, 'Podrobny_Sharkh_2_tom.pdf', $$فائدة:
جاء في هذا الدرس، هارون وهو علم أعجمي ممنوع من الصرف.
العلم الأعجمي إذا كان ثلاثيا ساكن الوسط مذكرا، يكون مصروفا، نحو: نوح، خان، جرج، شيث، لوط.
إذا كان مؤنثا منع من الصرف، نحو: بلخ، ويس.$$,
      52, 52, 1);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '21'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 21 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '21'
  ) <> 7 then
    raise exception 'Expected 7 Book 2 lesson 21 rules after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id, rule_6_id, rule_7_id)
  ) <> 12 then
    raise exception 'Expected 12 Book 2 lesson 21 source rows';
  end if;
end
$migration$;

commit;
