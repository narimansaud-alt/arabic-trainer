-- Certify Medina Book 2 lesson 31 and the completed 31-lesson sharh audit.
-- Primary source: Podrobny_Sharkh_2_tom.pdf, PDF page 75.
-- Supplementary source: Sharkh_na_2_tom_Med_kursa.pdf, PDF page 62.
-- The full sharh controls the explanation; the supplementary sharh supplies
-- definitions, its complete case table and its two detailed analyses.

begin;

create temp table _book2_full_sharh_batch07 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book2_full_sharh_batch07 values
  (1370, '31', 'Полный шарх: с. 75 · Дополнительный шарх: с. 62'),
  (1371, '31', 'Полный шарх: с. 75 · Дополнительный шарх: с. 62'),
  (1372, '31', 'Полный шарх: с. 75 · Дополнительный шарх: с. 62');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch07 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 2)' and r.lesson_number = b.lesson_number;
  if v_count <> 3 then raise exception 'Expected 3 guarded Book 2 rules for lesson 31, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 2)';
  if v_count <> 148 then raise exception 'Book 2 must retain 148 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 2)';
  if v_count <> 291 then raise exception 'Book 2 must retain 291 source rows, found %', v_count; end if;
end;
$guard$;

-- The three public cards already contain all source-backed material. Add the
-- final certification only after the primary and supplementary pages have
-- both been read visually and compared with the rendered cards.
update public.rules r
set content = regexp_replace(
  r.content, '</div>[[:space:]]*$',
  '<div class="rule-study-card book2-full-sharh-batch07"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источники:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book2_full_sharh_batch07 b
where r.id = b.rule_id and r.course_name = 'Мединский курс (Том 2)'
  and r.lesson_number = b.lesson_number and strpos(r.content, 'book2-full-sharh-batch07') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch07 b on b.rule_id = r.id
  where strpos(r.content, 'book2-full-sharh-batch07') > 0;
  if v_count <> 3 then raise exception 'Book 2 lesson 31 markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book2_full_sharh_batch07 b
    where not exists (select 1 from public.rule_sources s where s.rule_id = b.rule_id)
  ) then raise exception 'A completed Book 2 lesson 31 card has no source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1370
      and rule_ar like '%النَّعْتُ%'
      and rule_ar like '%الْمَنْعُوتُ%'
      and rule_ar like '%صِفَةً%'
      and rule_ar like '%مَوْصُوفًا%'
      and content like '%الصِّفَةُ%'
      and content like '%الْمَوْصُوفُ%'
  ) then raise exception 'Lesson 31 terminology is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1371
      and rule_ar like '%الْإِعْرَابِ%التَّذْكِيرِ وَالتَّأْنِيثِ%الْإِفْرَادِ وَالتَّثْنِيَةِ وَالْجَمْعِ%التَّعْرِيفِ وَالتَّنْكِيرِ%'
      and content like '%وَلَدٌ صَغِيرٌ%'
      and content like '%بِنْتٌ صَغِيرَةٌ%'
      and content like '%الْوَلَدَانِ الصَّغِيرَانِ%'
      and content like '%الْبَنَاتُ الصَّغِيرَاتُ%'
      and content like '%هَذِهِ كُتُبٌ جَدِيدَةٌ%'
  ) then raise exception 'Lesson 31 four-way agreement or source examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1372
      and content like '%هَذَا كِتَابٌ جَدِيدٌ%'
      and content like '%تَزَوَّجْتُ الْمَرْأَتَيْنِ الصَّالِحَتَيْنِ%'
      and content like '%مَرْفُوعٌ، مُذَكَّرٌ، مُفْرَدٌ، نَكِرَةٌ%'
      and content like '%مَنْصُوبٌ، مُؤَنَّثٌ، مُثَنًّى، مَعْرِفَةٌ%'
  ) then raise exception 'Lesson 31 detailed analyses are incomplete'; end if;

  select count(*) into v_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and content ~ 'book2-full-sharh-batch0[1-7]';
  if v_count <> 148 then raise exception 'Final Book 2 sharh certification covers % of 148 rules', v_count; end if;

  select count(distinct lesson_number) into v_count
  from public.rules where course_name = 'Мединский курс (Том 2)';
  if v_count <> 31 then raise exception 'Final Book 2 audit must cover 31 lessons, found %', v_count; end if;

  if exists (
    select 1 from generate_series(1, 31) expected(lesson_number)
    where not exists (
      select 1 from public.rules r
      where r.course_name = 'Мединский курс (Том 2)'
        and r.lesson_number = expected.lesson_number::text
    )
  ) then raise exception 'Final Book 2 audit has a missing lesson number'; end if;

  if exists (
    select 1 from public.rules r
    where r.course_name = 'Мединский курс (Том 2)'
      and (
        nullif(btrim(r.title), '') is null
        or nullif(btrim(r.rule_ar), '') is null
        or nullif(btrim(r.summary), '') is null
        or nullif(btrim(r.content), '') is null
      )
  ) then raise exception 'Final Book 2 audit found an empty public rule field'; end if;

  if exists (
    select 1 from public.rules r
    where r.course_name = 'Мединский курс (Том 2)'
      and not exists (select 1 from public.rule_sources s where s.rule_id = r.id)
  ) then raise exception 'Final Book 2 audit found a rule without provenance'; end if;

  if exists (
    select 1 from public.rule_sources s join public.rules r on r.id = s.rule_id
    where r.course_name = 'Мединский курс (Том 2)'
      and (
        nullif(btrim(s.source_document), '') is null
        or nullif(btrim(s.source_text), '') is null
        or s.source_page_from is null
        or s.source_page_to is null
        or s.source_page_from > s.source_page_to
      )
  ) then raise exception 'Final Book 2 audit found an invalid provenance row'; end if;
end;
$assert$;

commit;
