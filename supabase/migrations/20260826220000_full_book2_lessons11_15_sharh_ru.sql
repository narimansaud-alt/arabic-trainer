-- Certify the complete Russian rendering of Medina Book 2, lessons 11-15.
-- Primary source: Podrobny_Sharkh_2_tom.pdf, PDF pages 27, 29 and 31-35.
-- Supplementary source: Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 24-30.
-- The full sharh controls every overlapping rule; the short sharh only supplements it.

begin;

create temp table _book2_full_sharh_batch03 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book2_full_sharh_batch03 values
  (1293, '11', 'Полный шарх: с. 27 · Дополнительный шарх: с. 24'),
  (1294, '11', 'Полный шарх: с. 27 · Дополнительный шарх: с. 24'),
  (1295, '11', 'Полный шарх: с. 29 · Дополнительный шарх: с. 24'),
  (1896, '11', 'Полный шарх: с. 31 · Дополнительный шарх: с. 24–25'),
  (1296, '11', 'Полный шарх: с. 31 · Дополнительный шарх: с. 25'),
  (1297, '11', 'Полный шарх: с. 31 · Дополнительный шарх: с. 25'),
  (1298, '11', 'Полный шарх: с. 31 · Дополнительный шарх: с. 25'),
  (1300, '12', 'Полный шарх: с. 32 · Дополнительный шарх: нет отдельного раздела'),
  (1302, '13', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 26'),
  (1303, '13', 'Полный шарх: с. 32 · Дополнительный шарх: с. 26'),
  (1304, '14', 'Полный шарх: с. 33 · Дополнительный шарх: с. 27–28'),
  (1305, '14', 'Полный шарх: с. 33 · Дополнительный шарх: с. 27'),
  (1306, '14', 'Полный шарх: с. 34 · Дополнительный шарх: с. 27–28'),
  (1307, '15', 'Полный шарх: с. 35 · Дополнительный шарх: с. 29'),
  (1308, '15', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 29'),
  (1309, '15', 'Полный шарх: с. 35 · Дополнительный шарх: с. 30'),
  (1310, '15', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 30');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch03 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 2)' and r.lesson_number = b.lesson_number;
  if v_count <> 17 then raise exception 'Expected 17 guarded Book 2 rules for lessons 11-15, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 2)';
  if v_count <> 148 then raise exception 'Book 2 must retain 148 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 2)';
  if v_count <> 291 then raise exception 'Book 2 must retain 291 source rows, found %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content, '</div>[[:space:]]*$',
  '<div class="rule-study-card book2-full-sharh-batch03"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источники:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book2_full_sharh_batch03 b
where r.id = b.rule_id and r.course_name = 'Мединский курс (Том 2)'
  and r.lesson_number = b.lesson_number and strpos(r.content, 'book2-full-sharh-batch03') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch03 b on b.rule_id = r.id
  where strpos(r.content, 'book2-full-sharh-batch03') > 0;
  if v_count <> 17 then raise exception 'Book 2 lessons 11-15 markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book2_full_sharh_batch03 b
    where not exists (select 1 from public.rule_sources s where s.rule_id = b.rule_id)
  ) then raise exception 'A completed Book 2 lesson 11-15 card has no source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1293
      and content like '%أَنَا أَذْهَبُ%' and content like '%أَنْتُنَّ تَذْهَبْنَ%'
      and content like '%هُمْ يَذْهَبُونَ%' and content like '%هُنَّ يَذْهَبْنَ%'
  ) then raise exception 'Lesson 11 present conjugation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1297
      and content like '%فَأَمَّا ٱلۡيَتِيمَ فَلَا تَقۡهَرۡ%'
      and content like '%وَأَمَّا ٱلسَّآئِلَ فَلَا تَنۡهَرۡ%'
      and content like '%وَأَمَّا بِنِعۡمَةِ رَبِّكَ فَحَدِّثۡ%'
  ) then raise exception 'Lesson 11 أما explanation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1300
      and content like '%يَوْمُ السَّبْتِ%' and content like '%يَوْمُ الْجُمُعَةِ%'
  ) then raise exception 'Lesson 12 weekdays are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1302
      and content like '%فِي ابْتِدَاءِ الْكَلَامِ%' and content like '%قَالَ الْمُرَاقِبُ%'
      and content like '%أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ%'
      and content like '%не употребляется в начале речи%'
  ) then raise exception 'Lesson 13 إن/أن explanation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1305
      and content like '%اِذْهَبْ%' and content like '%اِذْهَبَا%' and content like '%اِذْهَبِي%'
      and content like '%اِذْهَبُوا%' and content like '%اِذْهَبْنَ%'
      and content like '%حَذْفُ حَرْفِ الْعِلَّةِ%' and content like '%نُونِ التَّوْكِيدِ%'
  ) then raise exception 'Lesson 14 imperative building table is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1306
      and content like '%تَذْهَبُ%' and content like '%ذْهَبْ%' and content like '%اِذْهَبْ%'
      and content like '%أَحْرُفُ الْمُضَارَعَةِ أَرْبَعَةٌ%'
      and content like '%اِشْرَبِ الْقَهْوَةَ%' and content like '%اُخْرُجْ وَالْعَبْ%'
      and content like '%كُلْ، خُذْ%'
  ) then raise exception 'Lesson 14 imperative derivation and warnings are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1307
      and content like '%لَا تَذْهَبْ%' and content like '%لَا تَذْهَبُوا%'
      and content like '%لَا تَذْهَبِي%' and content like '%لَا تَذْهَبْنَ%'
  ) then raise exception 'Lesson 15 prohibitive forms are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1309
      and content like '%كَادَ مُحَمَّدٌ يَخْرُجُ%'
      and content like '%فِعْلٌ مَاضٍ نَاقِصٌ مَبْنِيٌّ عَلَى الْفَتْحِ%'
      and content like '%فِي مَحَلِّ نَصْبٍ خَبَرُ كَادَ%'
  ) then raise exception 'Lesson 15 كاد explanation and parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1310
      and content like '%مَا أَطْوَلَ حَامِدًا%' and content like '%مَا أَصْغَرَ السَّيَّارَةَ%'
  ) then raise exception 'Lesson 15 exclamation examples are incomplete'; end if;
end;
$assert$;

commit;
