-- Add the two unique rules from page 49, the final page of lesson 26 in the
-- second sharh. Page 50 begins lesson 27 and its ajwaf section matches the
-- lesson numbering of the 80-page main sharh.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_6_id bigint;
  rule_7_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '26';

  if lesson_rule_count <> 5 then
    raise exception 'Expected 5 Book 2 lesson 26 rules before supplement, found %', lesson_rule_count;
  end if;

  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values
    ('Мединский курс (Том 2)', '26',
     'اسْمُ التَّفْضِيلِ مِنَ الْفِعْلِ الثُّلَاثِيِّ وَالْمُضَعَّفِ (сравнительная степень от трёхбуквенного и удвоенного глагола)',
     $$<div class="rule-study">
       <div class="rule-study-card">
         <span class="rule-card-kicker">Основная модель</span>
         <div class="rule-meaning-grid">
           <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-pattern" dir="rtl" lang="ar">أَفْعَلُ</span><span class="rule-term-ru">модель имени сравнительной или превосходной степени от трёхбуквенного глагола.</span></div>
           <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">اسْمُ التَّفْضِيلِ</span><span class="rule-term-ru">имя предпочтения: «лучше, больше, сильнее» и подобные значения сравнения.</span></div>
         </div>
         <div class="rule-example-list">
           <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مُحَمَّدٌ أَفْضَلُ مِنْ خَالِدٍ.</span><span class="rule-example-ru">Мухаммад лучше Халида.</span></div>
           <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">فَاطِمَةُ أَطْوَلُ مِنْ زَيْنَبَ.</span><span class="rule-example-ru">Фатима выше Зайнаб.</span></div>
         </div>
       </div>
       <div class="rule-study-card">
         <span class="rule-card-kicker">Если исходный глагол удвоенный</span>
         <div class="tbl-wrap"><table>
           <thead><tr><th>Глагол и связанное имя</th><th><span class="rule-table-ar" dir="rtl" lang="ar">اسْمُ التَّفْضِيلِ</span><span class="rule-table-ru">форма сравнения</span></th><th>Пример и перевод</th></tr></thead>
           <tbody>
             <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">قَلَّ، قَلِيلٌ</span><span class="rule-table-ru">был малочисленным; малый</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">أَقَلُّ</span><span class="rule-table-ru">меньше</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">طُلَّابُ فَصْلِنَا أَقَلُّ مِنْ طُلَّابِ فَصْلِكُمْ.</span><span class="rule-table-ru">Учеников в нашем классе меньше, чем в вашем.</span></td></tr>
             <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">حَبَّ، حَبِيبٌ</span><span class="rule-table-ru">любил; любимый</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">أَحَبُّ</span><span class="rule-table-ru">более любимый</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَبِي حَبِيبٌ إِلَيَّ، وَأُمِّي أَحَبُّ إِلَيَّ مِنْهُ.</span><span class="rule-table-ru">Отец дорог мне, а мать мне ещё дороже.</span></td></tr>
             <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">شَدَّ، شَدِيدٌ</span><span class="rule-table-ru">усилил; сильный</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">أَشَدُّ</span><span class="rule-table-ru">сильнее</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْبَرْدُ الْيَوْمَ أَشَدُّ.</span><span class="rule-table-ru">Сегодня холод сильнее.</span></td></tr>
             <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">لَذَّ، لَذِيذٌ</span><span class="rule-table-ru">был вкусным; вкусный</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">أَلَذُّ</span><span class="rule-table-ru">вкуснее</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْبُرْتُقَالُ لَذِيذٌ، وَالتُّفَّاحُ أَلَذُّ مِنْهُ.</span><span class="rule-table-ru">Апельсин вкусный, а яблоко вкуснее него.</span></td></tr>
           </tbody>
         </table></div>
         <div class="rule-note"><span class="rule-note-label">Что происходит с удвоением</span>Удвоение исходного глагола сохраняется в конечной коренной букве формы <span class="ar-inline" dir="rtl" lang="ar">أَفْعَلُ</span>: <span class="ar-inline" dir="rtl" lang="ar">قَلَّ، أَقَلُّ</span>.</div>
       </div>
     </div>$$,
     6, 'rule',
     'Имя сравнительной или превосходной степени образуется от трёхбуквенного глагола по модели أَفْعَلُ. Если исходный глагол удвоенный, удвоение сохраняется и в اسْمُ التَّفْضِيلِ.',
     'يُصَاغُ اسْمُ التَّفْضِيلِ مِنَ الْفِعْلِ الثُّلَاثِيِّ عَلَى وَزْنِ «أَفْعَلُ». وَإِذَا كَانَ الْفِعْلُ مُضَعَّفًا انْتَقَلَ التَّضْعِيفُ إِلَى اسْمِ التَّفْضِيلِ، نَحْوُ: قَلَّ، أَقَلُّ؛ وَحَبَّ، أَحَبُّ؛ وَشَدَّ، أَشَدُّ؛ وَلَذَّ، أَلَذُّ.')
  returning id into rule_6_id;

  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values
    ('Мединский курс (Том 2)', '26',
     'الْفِعْلُ «يَجِبُ» وَالْمَصْدَرُ الْمُؤَوَّلُ (глагол «необходимо» и истолкованный масдар)',
     $$<div class="rule-study">
       <div class="rule-study-card">
         <span class="rule-card-kicker">Конструкция после يَجِبُ</span>
         <div class="rule-meaning-grid">
           <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">يَجِبُ</span><span class="rule-term-ru">необходимо, следует, нужно.</span></div>
           <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">مَصْدَرٌ مُؤَوَّلٌ</span><span class="rule-term-ru">истолкованный масдар: сочетание, которое по смыслу заменяется обычным масдаром.</span></div>
           <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">أَنْ وَفِعْلٌ مُضَارِعٌ</span><span class="rule-term-ru">частица أَنْ и глагол настоящего времени образуют здесь истолкованный масдар.</span></div>
         </div>
         <div class="rule-example-list">
           <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَجِبُ أَنْ أَخْرُجَ.</span><span class="rule-example-ru">Мне необходимо выйти.</span></div>
           <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَجِبُ الْخُرُوجُ.</span><span class="rule-example-ru">Необходимо выйти. Это передача того же смысла явным масдаром.</span></div>
         </div>
       </div>
       <div class="rule-study-card">
         <span class="rule-card-kicker">С предлогом عَلَى</span>
         <div class="rule-example-list">
           <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَجِبُ عَلَيْنَا أَنْ نَفْهَمَ الْقُرْآنَ وَنَعْمَلَ بِهِ.</span><span class="rule-example-ru">Нам необходимо понимать Коран и поступать согласно ему.</span></div>
         </div>
         <div class="rule-note"><span class="rule-note-label">Управление</span>Перед тем, на ком лежит обязанность, может стоять предлог <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">عَلَى</span>: <span class="ar-inline" dir="rtl" lang="ar">عَلَيْنَا</span> — «на нас, нам».</div>
       </div>
     </div>$$,
     7, 'rule',
     'После يَجِبُ употребляется истолкованный масдар из أَنْ и глагола настоящего времени. Глагол يَجِبُ может соединяться с عَلَى, указывая, на ком лежит необходимость.',
     'يَأْتِي بَعْدَ الْفِعْلِ «يَجِبُ» مَصْدَرٌ مُؤَوَّلٌ مِنْ «أَنْ» وَفِعْلٍ مُضَارِعٍ، وَيَجُوزُ أَنْ يَدْخُلَ عَلَيْهِ حَرْفُ الْجَرِّ «عَلَى»، نَحْوُ: يَجِبُ عَلَيْنَا أَنْ نَفْهَمَ الْقُرْآنَ وَنَعْمَلَ بِهِ.')
  returning id into rule_7_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_6_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$اسم التفضيل:
يصاغ من الفعل الثلاثي على وزن (أفعل)؛ تقول: محمد أفضل من خالد. فاطمة أطول من زينب.
فإذا كان الفعل مضعفا انتقل التضعيف إلى اسم التفضيل، مثال ذلك:
قل (قليل): اسم التفضيل منه أقل؛ تقول: طلاب فصلنا أقل من طلاب فصلكم.
حب (حبيب): أحب؛ أبي حبيب إلي وأمي أحب إلي منه.
شد (شديد): أشد؛ البرد اليوم أشد.
لذ (لذيذ): ألذ؛ البرتقال لذيذ والتفاح ألذ منه.$$,
      49, 49, 1),
    (rule_7_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الفعل يجب: يأتي بعده مصدر مؤول (أن + فعل مضارع)، تقول: يجب أن أخرج (أي: يجب الخروج).
ويجوز أن يدخل عليه حرف الجر (على): يجب علينا أن نفهم القرآن ونعمل به.$$,
      49, 49, 1);

  if (
    select count(*) from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '26'
  ) <> 7 then
    raise exception 'Expected 7 Book 2 lesson 26 rules after unique supplement';
  end if;

  if (
    select count(*)
    from public.rule_sources rs
    join public.rules r on r.id = rs.rule_id
    where r.course_name = 'Мединский курс (Том 2)'
      and r.lesson_number = '26'
  ) <> 12 then
    raise exception 'Expected 12 Book 2 lesson 26 source rows after unique supplement';
  end if;

  if exists (
    select 1 from public.rules
    where id in (rule_6_id, rule_7_id)
      and (content::text like '%←%' or content::text like '%→%')
  ) then
    raise exception 'Book 2 lesson 26 unique supplement contains an RTL-hostile arrow';
  end if;
end
$migration$;

commit;
