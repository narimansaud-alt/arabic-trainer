-- Complete Russian rendering of Medina Book 2, lessons 6-10.
-- Primary source: Podrobny_Sharkh_2_tom.pdf, PDF pages 20-30.
-- Supplementary source: Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 14-23.
-- The full sharh controls the rule; unique examples of the short sharh are retained.

begin;

create temp table _book2_full_sharh_batch02 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book2_full_sharh_batch02 values
  (1268, '6', 'Полный шарх: с. 20 · Дополнительный шарх: с. 14'),
  (1269, '6', 'Полный шарх: с. 21 · Дополнительный шарх: нет отдельного раздела'),
  (1270, '6', 'Полный шарх: с. 21 · Дополнительный шарх: с. 15'),
  (1907, '6', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 15–16'),
  (1271, '6', 'Полный шарх: с. 21 · Дополнительный шарх: с. 16'),
  (1272, '6', 'Полный шарх: с. 21 · Дополнительный шарх: с. 17'),
  (1908, '6', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 17'),
  (1273, '6', 'Полный шарх: с. 22 · Дополнительный шарх: с. 17'),
  (1909, '7', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 18'),
  (1274, '7', 'Полный шарх: с. 23 · Дополнительный шарх: с. 18'),
  (1275, '7', 'Полный шарх: с. 23 · Дополнительный шарх: нет отдельного раздела'),
  (1892, '7', 'Полный шарх: с. 24 · Дополнительный шарх: нет отдельного раздела'),
  (1276, '7', 'Полный шарх: с. 24 · Дополнительный шарх: с. 18'),
  (1893, '7', 'Полный шарх: с. 24 · Дополнительный шарх: нет отдельного раздела'),
  (1277, '7', 'Полный шарх: с. 24 · Дополнительный шарх: с. 18–19'),
  (1910, '7', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 19'),
  (1911, '7', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 19'),
  (1278, '8', 'Полный шарх: с. 25 · Дополнительный шарх: с. 20'),
  (1284, '9', 'Полный шарх: с. 25 · Дополнительный шарх: с. 21'),
  (1282, '9', 'Полный шарх: с. 25 · Дополнительный шарх: с. 21'),
  (1283, '9', 'Полный шарх: с. 25 · Дополнительный шарх: с. 21'),
  (1285, '9', 'Полный шарх: с. 26 · Дополнительный шарх: с. 21'),
  (1912, '9', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 22'),
  (1287, '9', 'Полный шарх: с. 26 · Дополнительный шарх: с. 22'),
  (1288, '9', 'Полный шарх: с. 26 · Дополнительный шарх: с. 22'),
  (1286, '9', 'Полный шарх: с. 26 · Дополнительный шарх: нет отдельного раздела'),
  (1289, '10', 'Полный шарх: с. 29 · Дополнительный шарх: с. 23'),
  (1290, '10', 'Полный шарх: с. 27 · Дополнительный шарх: с. 23'),
  (1291, '10', 'Полный шарх: с. 28 · Дополнительный шарх: с. 23'),
  (1292, '10', 'Полный шарх: с. 30 · Дополнительный шарх: нет отдельного раздела');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch02 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 2)' and r.lesson_number = b.lesson_number;
  if v_count <> 30 then raise exception 'Expected 30 guarded Book 2 rules for lessons 6-10, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 2)';
  if v_count <> 148 then raise exception 'Book 2 must retain 148 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 2)';
  if v_count not in (290, 291) then
    raise exception 'Expected 290 source rows before this completion (or 291 on an idempotent rerun), found %', v_count;
  end if;
end;
$guard$;

-- Full sharh, page 27: the old provenance omitted the ten-form present-tense table.
update public.rule_sources
set source_text = source_text || E'\n\nإسناد الفعل المضارع (الفعل: يذهب)\nالفعل | الإعراب (الفعل والفاعل)\nأذهبُ | فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "أنا"\nتذهبُ | فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "أنت"\nتذهبينَ | فعل مضارع مرفوع وعلامة رفعه ثبوت النون، والفاعل ياء المخاطبة\nيذهبُ | فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "هو"\nتذهبُ | فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "هي"\nنذهبُ | فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة على آخره، والفاعل ضمير مستتر تقديره "نحن"\nتذهبونَ | فعل مضارع مرفوع وعلامة رفعه ثبوت النون، والفاعل واو الجماعة\nتذهبنَ | فعل مضارع مبني على السكون، والفاعل نون النسوة\nيذهبونَ | فعل مضارع مرفوع وعلامة رفعه ثبوت النون، والفاعل واو الجماعة\nيذهبنَ | فعل مضارع مبني على السكون، والفاعل نون النسوة'
where rule_id = 1290
  and source_document = 'Podrobny_Sharkh_2_tom.pdf'
  and source_page_from = 27 and source_page_to = 27
  and strpos(source_text, 'إسناد الفعل المضارع') = 0;

update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l10-present-conjugation-complete">
  <span class="rule-card-kicker">Полная таблица полного шарха</span>
  <span class="rule-main-ar" dir="rtl" lang="ar">إِسْنَادُ الْفِعْلِ الْمُضَارِعِ (الْفِعْلُ: يَذْهَبُ)</span>
  <p class="rule-study-text">Полный шарх приводит десять форм глагола <span dir="rtl" lang="ar">يَذْهَبُ</span> и для каждой указывает состояние глагола и его исполнителя.</p>
  <div class="tbl-wrap"><table><thead><tr><th>Местоимение</th><th>Форма</th><th>Разбор полного шарха</th><th>Перевод</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">أَنَا</td><td dir="rtl" lang="ar">أَذْهَبُ</td><td>В раф‘ с явной даммой; исполнитель — скрытое «я».</td><td>Я иду.</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتَ</td><td dir="rtl" lang="ar">تَذْهَبُ</td><td>В раф‘ с явной даммой; исполнитель — скрытое «ты».</td><td>Ты идёшь, мужчина.</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتِ</td><td dir="rtl" lang="ar">تَذْهَبِينَ</td><td>В раф‘; показатель — сохранение нун; исполнитель — йа обращённой женщины.</td><td>Ты идёшь, женщина.</td></tr>
    <tr><td dir="rtl" lang="ar">هُوَ</td><td dir="rtl" lang="ar">يَذْهَبُ</td><td>В раф‘ с явной даммой; исполнитель — скрытое «он».</td><td>Он идёт.</td></tr>
    <tr><td dir="rtl" lang="ar">هِيَ</td><td dir="rtl" lang="ar">تَذْهَبُ</td><td>В раф‘ с явной даммой; исполнитель — скрытое «она».</td><td>Она идёт.</td></tr>
    <tr><td dir="rtl" lang="ar">نَحْنُ</td><td dir="rtl" lang="ar">نَذْهَبُ</td><td>В раф‘ с явной даммой; исполнитель — скрытое «мы».</td><td>Мы идём.</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتُمْ</td><td dir="rtl" lang="ar">تَذْهَبُونَ</td><td>В раф‘; показатель — сохранение нун; исполнитель — вау группы.</td><td>Вы идёте, мужчины.</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتُنَّ</td><td dir="rtl" lang="ar">تَذْهَبْنَ</td><td>Построен на сукуне; исполнитель — нун женщин.</td><td>Вы идёте, женщины.</td></tr>
    <tr><td dir="rtl" lang="ar">هُمْ</td><td dir="rtl" lang="ar">يَذْهَبُونَ</td><td>В раф‘; показатель — сохранение нун; исполнитель — вау группы.</td><td>Они идут, мужчины.</td></tr>
    <tr><td dir="rtl" lang="ar">هُنَّ</td><td dir="rtl" lang="ar">يَذْهَبْنَ</td><td>Построен на сукуне; исполнитель — нун женщин.</td><td>Они идут, женщины.</td></tr>
  </tbody></table></div>
  <p class="rule-study-text">Во всех строках речь идёт о глаголе настоящего/будущего времени. Формулировки <span dir="rtl" lang="ar">مَرْفُوعٌ</span>, <span dir="rtl" lang="ar">ثُبُوتُ النُّونِ</span>, <span dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span> и названия исполнителей переведены без сокращения правила.</p>
</div>
</div>$html$)
where id = 1290 and course_name = 'Мединский курс (Том 2)' and lesson_number = '10'
  and strpos(content, 'book2-l10-present-conjugation-complete') = 0;

-- Full sharh, page 29: this entire page was absent from the old source map.
do $source$
begin
  if not exists (
    select 1 from public.rule_sources
    where rule_id = 1289 and source_document = 'Podrobny_Sharkh_2_tom.pdf'
      and source_page_from = 29 and source_page_to = 29
  ) then
    update public.rule_sources set sort_order = 2
    where rule_id = 1289 and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf' and sort_order = 1;

    insert into public.rule_sources (
      rule_id, source_document, source_text, source_page_from, source_page_to, sort_order
    ) values (
      1289, 'Podrobny_Sharkh_2_tom.pdf',
      $source_text$الفرق بين "ما" و"لا" النافيتين
"ما" النافية تستعمل مع الفعل الماضي، نحو:
ما شرب أبي القهوة أمس.
"لا" النافية تستعمل مع الفعل المضارع، نحو:
لا يشرب أبي الشاي.
قد تستعمل "ما" النافية مع الفعل المضارع، نحو:
ما أشرب الشاي (هذا يعني لا أشرب الشاي الآن لكن سأشربه فيما بعد إن شاء الله).$source_text$,
      29, 29, 1
    );
  end if;
end;
$source$;

update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l10-ma-la-negation-complete">
  <span class="rule-card-kicker">Различие отрицательных مَا и لَا — полный шарх</span>
  <span class="rule-main-ar" dir="rtl" lang="ar">الْفَرْقُ بَيْنَ «مَا» وَ«لَا» النَّافِيَتَيْنِ</span>
  <div class="rule-example-list">
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">«مَا» النَّافِيَةُ تُسْتَعْمَلُ مَعَ الْفِعْلِ الْمَاضِي: مَا شَرِبَ أَبِي الْقَهْوَةَ أَمْسِ.</span><span class="rule-example-ru">Отрицательная <span dir="rtl" lang="ar">مَا</span> употребляется с прошедшим глаголом: «Мой отец вчера не пил кофе».</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">«لَا» النَّافِيَةُ تُسْتَعْمَلُ مَعَ الْفِعْلِ الْمُضَارِعِ: لَا يَشْرَبُ أَبِي الشَّايَ.</span><span class="rule-example-ru">Отрицательная <span dir="rtl" lang="ar">لَا</span> употребляется с глаголом настоящего/будущего времени: «Мой отец не пьёт чай».</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَدْ تُسْتَعْمَلُ «مَا» النَّافِيَةُ مَعَ الْفِعْلِ الْمُضَارِعِ: مَا أَشْرَبُ الشَّايَ.</span><span class="rule-example-ru">Отрицательная <span dir="rtl" lang="ar">مَا</span> может употребляться и с настоящим временем. Смысл примера: «Сейчас я не пью чай, но выпью его позднее, если пожелает Аллах».</span></div>
  </div>
</div>
</div>$html$)
where id = 1289 and course_name = 'Мединский курс (Том 2)' and lesson_number = '10'
  and strpos(content, 'book2-l10-ma-la-negation-complete') = 0;

update public.rules r
set content = regexp_replace(
  r.content, '</div>[[:space:]]*$',
  '<div class="rule-study-card book2-full-sharh-batch02"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источники:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book2_full_sharh_batch02 b
where r.id = b.rule_id and r.course_name = 'Мединский курс (Том 2)'
  and r.lesson_number = b.lesson_number and strpos(r.content, 'book2-full-sharh-batch02') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 2)';
  if v_count <> 148 then raise exception 'Book 2 must retain 148 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 2)';
  if v_count <> 291 then raise exception 'Book 2 must have 291 source rows after restoring page 29, found %', v_count; end if;

  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch02 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 2)' and r.lesson_number = b.lesson_number
    and strpos(r.content, 'book2-full-sharh-batch02') > 0;
  if v_count <> 30 then raise exception 'Book 2 lessons 6-10 markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book2_full_sharh_batch02 b
    where not exists (select 1 from public.rule_sources s where s.rule_id = b.rule_id)
  ) then raise exception 'A completed Book 2 lesson 6-10 card has no source row'; end if;

  if not exists (
    select 1 from public.rule_sources
    where rule_id = 1290 and source_document = 'Podrobny_Sharkh_2_tom.pdf'
      and source_page_from = 27
      and source_text like '%تذهبينَ | فعل مضارع مرفوع وعلامة رفعه ثبوت النون%'
      and source_text like '%يذهبنَ | فعل مضارع مبني على السكون%'
  ) then raise exception 'Lesson 10 present-tense source table is incomplete'; end if;

  if not exists (
    select 1 from public.rule_sources
    where rule_id = 1289 and source_document = 'Podrobny_Sharkh_2_tom.pdf'
      and source_page_from = 29 and source_page_to = 29 and sort_order = 1
      and source_text like '%الفرق بين "ما" و"لا" النافيتين%'
  ) then raise exception 'Lesson 10 full-sharh negation source is missing'; end if;

  if not exists (
    select 1 from public.rule_sources
    where rule_id = 1289 and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf' and sort_order = 2
  ) then raise exception 'Lesson 10 supplementary source no longer follows the full sharh'; end if;

  if not exists (
    select 1 from public.rules
    where id = 1290 and content like '%book2-l10-present-conjugation-complete%'
      and content like '%تَذْهَبِينَ%' and content like '%تَذْهَبْنَ%'
      and content like '%يَذْهَبُونَ%' and content like '%يَذْهَبْنَ%'
  ) then raise exception 'Lesson 10 public present-tense table is incomplete'; end if;

  if not exists (
    select 1 from public.rules
    where id = 1289 and content like '%book2-l10-ma-la-negation-complete%'
      and content like '%مَا شَرِبَ أَبِي الْقَهْوَةَ أَمْسِ%'
      and content like '%لَا يَشْرَبُ أَبِي الشَّايَ%' and content like '%مَا أَشْرَبُ الشَّايَ%'
  ) then raise exception 'Lesson 10 public ما/لا explanation is incomplete'; end if;
end;
$assert$;

commit;
