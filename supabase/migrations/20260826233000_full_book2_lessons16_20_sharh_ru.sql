-- Certify the complete Russian rendering of Medina Book 2, lessons 16-20.
-- Primary source: Podrobny_Sharkh_2_tom.pdf, PDF pages 36-46.
-- Supplementary source: Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 31-39.
-- The full sharh controls every overlapping rule; the short sharh only supplies
-- additional examples and sections absent from the full source.

begin;

create temp table _book2_full_sharh_batch04 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book2_full_sharh_batch04 values
  (1311, '16', 'Полный шарх: с. 36 · Дополнительный шарх: с. 31'),
  (1313, '16', 'Полный шарх: с. 36 · Дополнительный шарх: с. 31'),
  (1314, '16', 'Полный шарх: с. 37 · Дополнительный шарх: с. 31–32'),
  (1312, '16', 'Полный шарх: с. 38–39 · Дополнительный шарх: с. 33'),
  (1316, '16', 'Полный шарх: с. 38 · Дополнительный шарх: с. 32'),
  (1315, '16', 'Полный шарх: с. 39 · Дополнительный шарх: с. 32'),
  (1897, '16', 'Полный шарх: с. 39 · Дополнительный шарх: с. 33'),
  (1317, '17', 'Полный шарх: с. 40 · Дополнительный шарх: с. 34–35'),
  (1318, '17', 'Полный шарх: с. 40 · Дополнительный шарх: с. 36'),
  (1319, '17', 'Полный шарх: с. 41 · Дополнительный шарх: с. 35'),
  (1320, '17', 'Полный шарх: с. 41 · Дополнительный шарх: с. 35'),
  (1321, '17', 'Полный шарх: с. 42 · Дополнительный шарх: с. 36'),
  (1322, '18', 'Полный шарх: с. 43 · Дополнительный шарх: с. 37'),
  (1323, '18', 'Полный шарх: с. 44 · Дополнительный шарх: нет отдельного раздела'),
  (1324, '18', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 37'),
  (1325, '18', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 37'),
  (1326, '18', 'Полный шарх: с. 44 · Дополнительный шарх: с. 37'),
  (1898, '19', 'Полный шарх: с. 45 · Дополнительный шарх: нет отдельного раздела'),
  (1328, '19', 'Полный шарх: с. 45 · Дополнительный шарх: с. 38'),
  (1327, '19', 'Полный шарх: с. 45 · Дополнительный шарх: с. 38'),
  (1329, '20', 'Полный шарх: с. 46 · Дополнительный шарх: с. 39'),
  (1330, '20', 'Полный шарх: с. 46 · Дополнительный шарх: с. 39'),
  (1331, '20', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 39');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch04 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 2)' and r.lesson_number = b.lesson_number;
  if v_count <> 23 then raise exception 'Expected 23 guarded Book 2 rules for lessons 16-20, found %', v_count; end if;

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
  '<div class="rule-study-card book2-full-sharh-batch04"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источники:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book2_full_sharh_batch04 b
where r.id = b.rule_id and r.course_name = 'Мединский курс (Том 2)'
  and r.lesson_number = b.lesson_number and strpos(r.content, 'book2-full-sharh-batch04') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch04 b on b.rule_id = r.id
  where strpos(r.content, 'book2-full-sharh-batch04') > 0;
  if v_count <> 23 then raise exception 'Book 2 lessons 16-20 markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book2_full_sharh_batch04 b
    where not exists (select 1 from public.rule_sources s where s.rule_id = b.rule_id)
  ) then raise exception 'A completed Book 2 lesson 16-20 card has no source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1311
      and content like '%أَرَدْتُنَّ%' and content like '%أَرَادُوا%'
      and content like '%يُرِدْنَ%'
  ) then raise exception 'Lesson 16 أراد conjugation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1314
      and content like '%عُمَرُ%' and content like '%عَمْرٌ%'
      and content like '%عَمْرًا%' and content like '%عَمْرٍ%'
  ) then raise exception 'Lesson 16 Umar/Amr distinction is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1312
      and content like '%مَا الْمَوْصُولَةُ%' and content like '%مَا النَّافِيَةُ%'
      and content like '%مَا الِاسْتِفْهَامِيَّةُ%'
  ) then raise exception 'Lesson 16 three uses of ما are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1316
      and content like '%ذُو%' and content like '%ذَا%'
      and content like '%عَلَامَةُ نَصْبِهِ الْأَلِفُ%'
      and content like '%وَرَقٍ%' and content like '%مُضَافٌ إِلَيْهِ مَجْرُورٌ%'
  ) then raise exception 'Lesson 16 ذو conditions and parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1317
      and content like '%تَذْهَبِي%' and content like '%تَذْهَبُوا%'
      and content like '%أَخَرَجْتُنَّ%' and content like '%لِنَذْهَبَ%'
      and rule_ar like '%حَذْفُ النُّونِ%'
  ) then raise exception 'Lesson 17 present-tense nasb table is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1318
      and content like '%أُرِيدُ%' and content like '%أَنْ أَخْرُجَ%'
      and content like '%الْخُرُوجَ%' and content like '%لِأَشْرَبَ%'
      and content like '%أَنْ أَجْلِسَ%' and content like '%مَصْدَرٌ مُؤَوَّلٌ%'
  ) then raise exception 'Lesson 17 interpreted verbal noun explanation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1320
      and content like '%حَرْفَا جَرٍّ%' and content like '%وَظَرْفَانِ%'
      and content like '%اسْمٌ مَرْفُوعٌ%' and content like '%جُمْلَةٌ اسْمِيَّةٌ%'
  ) then raise exception 'Lesson 17 منذ/مذ distinction is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1321
      and content like '%رَأَيْتُ%' and content like '%رَأَيْتُنَّ%'
      and content like '%يَرَيْنَ%'
  ) then raise exception 'Lesson 17 رأى/يرى conjugation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1322
      and content like '%تَفْعَلَانِ%' and content like '%تَفْعَلَا%'
      and content like '%تَفْعَلُونَ%' and content like '%تَفْعَلُوا%'
      and content like '%تَفْعَلِينَ%' and content like '%تَفْعَلِي%'
  ) then raise exception 'Lesson 18 five-verbs rafa/nasb tables are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1323
      and content like '%بِالْأَلِفِ الْفَارِقَةِ%' and content like '%أَنْ تَفْعَلُوا%'
      and content like '%فَعَلُوا%' and content like '%اِفْعَلُوا%'
  ) then raise exception 'Lesson 18 separating alif warning is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1324
      and content like '%نُونُ النِّسْوَةِ%' and content like '%مَبْنِيًّا عَلَى السُّكُونِ%'
      and content like '%الطَّالِبَاتُ يَدْرُسْنَ%' and content like '%تَدْرُسْنَ%'
  ) then raise exception 'Lesson 18 feminine plural nun section is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1325
      and content like '%أَلَّا%' and content like '%أَنْ + لَا النَّافِيَةُ%'
      and content like '%أَرْجُو%' and content like '%تَدْخُلَ%'
  ) then raise exception 'Lesson 18 ألا section is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1326
      and content like '%كَافُ التَّشْبِيهِ%'
  ) then raise exception 'Lesson 18 comparison kaf section is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1898
      and content like '%ذَهَبْتُ إِلَى السُّوقِ%' and content like '%أَذْهَبُ إِلَى السُّوقِ%'
      and content like '%اِذْهَبْ إِلَى السُّوقِ%'
  ) then raise exception 'Lesson 19 three verb types are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1328
      and content like '%لَنْ أَذْهَبَ%' and content like '%لَنْ تُسَافِرِي%'
  ) then raise exception 'Lesson 19 لن explanation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1327
      and content like '%مَا ذَهَبْتُ إِلَى السُّوقِ%'
      and content like '%لَا أَذْهَبُ إِلَى السُّوقِ%'
      and content like '%لَنْ أَذْهَبَ إِلَى السُّوقِ%'
  ) then raise exception 'Lesson 19 negation timeline is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1329
      and content like '%الطَّالِبَانِ: فَاعِلٌ مَرْفُوعٌ%'
      and content like '%الطَّالِبَيْنِ: مَفْعُولٌ بِهِ مَنْصُوبٌ%'
      and content like '%الطَّالِبَيْنِ: مَجْرُورٌ%'
  ) then raise exception 'Lesson 20 dual-number parsing is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1330
      and content like '%أَحَدُهُمَا%' and content like '%إِحْدَاهُمَا%'
      and content like '%الْآخَرُ%' and content like '%الْأُخْرَى%'
  ) then raise exception 'Lesson 20 one-of-two forms are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1331
      and content like '%ذُو%' and content like '%ذَا%' and content like '%ذِي%'
      and content like '%ذَاتُ%' and content like '%ذَاتَ%' and content like '%ذَاتِ%'
  ) then raise exception 'Lesson 20 ذو/ذات declension is incomplete'; end if;
end;
$assert$;

commit;
