-- Supplement Book 2 lesson 26 with matching material found on page 49,
-- the final page of lesson 26 in the second sharh. Public duplicates remain consolidated.

begin;

do $migration$
declare
  rule_4_id bigint;
  rule_5_id bigint;
begin
  select id into strict rule_4_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '26'
    and sort_order = 4;

  select id into strict rule_5_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '26'
    and sort_order = 5;

  delete from public.rule_sources
  where rule_id in (rule_4_id, rule_5_id)
    and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf'
    and source_page_from = 49
    and source_page_to = 49;

  update public.rules
  set
    title = 'الْمَصْدَرُ عَلَى وَزْنِ فَعَالٍ (масдар по модели فَعَالٌ)',
    rule_ar = 'مَصْدَرُ الْفِعْلِ «ذَهَبَ» هُوَ «ذَهَابٌ»، وَهُوَ عَلَى وَزْنِ «فَعَالٍ»، وَمِثْلُهُ «نَجَاحٌ».',
    summary = 'Подробный шарх фиксирует масдар ذَهَابٌ от ذَهَبَ и его морфологическую модель فَعَالٌ; к той же модели отнесено слово نَجَاحٌ. Второй шарх добавляет три самостоятельных примера употребления ذَهَابٌ.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Масдар и модель</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Слово</th><th>Морфологическая модель</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">ذَهَابٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">فَعَالٌ</span></td><td>уход, отправление; масдар глагола <span class="ar-inline" dir="rtl" lang="ar">ذَهَبَ</span> «пошёл»</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَجَاحٌ</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">فَعَالٌ</span></td><td>успех; слово той же модели</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Дополнительные примеры второго шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أُرِيدُ الذَّهَابَ إِلَى الْبَيْتِ.</span><span class="rule-example-ru">Я хочу пойти домой.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَرْجُو أَنْ تَسْمَحَ لِي بِالذَّهَابِ إِلَى الْمُسْتَشْفَى.</span><span class="rule-example-ru">Я прошу разрешить мне пойти в больницу.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ تَذْكِرَةُ طَائِرَةٍ إِلَى دِمَشْقَ ذَهَابًا وَإِيَابًا.</span><span class="rule-example-ru">Это билет на самолёт до Дамаска туда и обратно.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$مصدر الفعل ذهب: ذهاب.
أمثلة: أريد الذهاب إلى البيت. أرجو أن تسمح لي بالذهاب إلى المستشفى. هذه تذكرة طائرة إلى دمشق ذهابا وإيابا.$$,
      49, 49, 2),
    (rule_5_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$ها هو ذا:
ها هو ذا؛ أصله: الضمير (هو) واسم الإشارة (هذا)، فصل بين هاء التنبيه واسم الإشارة.
ها: هاء التنبيه. هو: الضمير. ذا: اسم الإشارة.$$,
      49, 49, 2);

  if (
    select count(*)
    from public.rule_sources rs
    join public.rules r on r.id = rs.rule_id
    where r.course_name = 'Мединский курс (Том 2)'
      and r.lesson_number = '26'
  ) <> 10 then
    raise exception 'Expected 10 Book 2 lesson 26 source rows after second-sharh supplement';
  end if;

  if exists (
    select 1 from public.rules
    where id = rule_4_id
      and (content::text like '%←%' or content::text like '%→%')
  ) then
    raise exception 'Book 2 lesson 26 supplement contains an RTL-hostile arrow';
  end if;
end
$migration$;

commit;
