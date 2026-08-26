-- Certify the complete Russian rendering of Medina Book 2, lessons 21-25.
-- Primary source: Podrobny_Sharkh_2_tom.pdf, PDF pages 47-59.
-- Supplementary source: Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 40-47.
-- The full sharh controls every overlapping rule; the short sharh only supplies
-- additional examples and sections absent from the full source.

begin;

create temp table _book2_full_sharh_batch05 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book2_full_sharh_batch05 values
  (1332, '21', 'Полный шарх: с. 47–48 · Дополнительный шарх: с. 40'),
  (1333, '21', 'Полный шарх: с. 48–50 · Дополнительный шарх: с. 41'),
  (1334, '21', 'Полный шарх: с. 48–49 · Дополнительный шарх: нет отдельного раздела'),
  (1335, '21', 'Полный шарх: с. 49–50 · Дополнительный шарх: с. 41'),
  (1336, '21', 'Полный шарх: с. 51–52 · Дополнительный шарх: с. 41'),
  (1899, '21', 'Полный шарх: с. 52 · Дополнительный шарх: с. 41'),
  (1900, '21', 'Полный шарх: с. 52 · Дополнительный шарх: нет отдельного раздела'),
  (1337, '22', 'Полный шарх: с. 52 · Дополнительный шарх: с. 42'),
  (1338, '23', 'Полный шарх: с. 53 · Дополнительный шарх: с. 43'),
  (1339, '23', 'Полный шарх: с. 53 · Дополнительный шарх: с. 43'),
  (1340, '23', 'Полный шарх: с. 54 · Дополнительный шарх: с. 43'),
  (1341, '24', 'Полный шарх: с. 55 · Дополнительный шарх: с. 44, 46'),
  (1342, '24', 'Полный шарх: с. 55 · Дополнительный шарх: с. 44, 46'),
  (1343, '24', 'Полный шарх: с. 55–56 · Дополнительный шарх: с. 44, 46'),
  (1344, '24', 'Полный шарх: с. 56 · Дополнительный шарх: с. 45–46'),
  (1345, '24', 'Полный шарх: с. 56–57 · Дополнительный шарх: с. 45–46'),
  (1346, '25', 'Полный шарх: с. 57–59 · Дополнительный шарх: с. 47'),
  (1347, '25', 'Полный шарх: с. 59 · Дополнительный шарх: с. 47'),
  (1348, '25', 'Полный шарх: с. 59 · Дополнительный шарх: с. 47');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch05 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 2)' and r.lesson_number = b.lesson_number;
  if v_count <> 19 then raise exception 'Expected 19 guarded Book 2 rules for lessons 21-25, found %', v_count; end if;

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
  '<div class="rule-study-card book2-full-sharh-batch05"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источники:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book2_full_sharh_batch05 b
where r.id = b.rule_id and r.course_name = 'Мединский курс (Том 2)'
  and r.lesson_number = b.lesson_number and strpos(r.content, 'book2-full-sharh-batch05') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch05 b on b.rule_id = r.id
  where strpos(r.content, 'book2-full-sharh-batch05') > 0;
  if v_count <> 19 then raise exception 'Book 2 lessons 21-25 markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book2_full_sharh_batch05 b
    where not exists (select 1 from public.rule_sources s where s.rule_id = b.rule_id)
  ) then raise exception 'A completed Book 2 lesson 21-25 card has no source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1332
      and content like '%أَنْتُنَّ%' and content like '%نَحْنُ%'
      and content like '%حَذْفُ النُّونِ%' and content like '%مَبْنِيٌّ عَلَى السُّكُونِ%'
      and content like '%أَكَتَبْتَ الْوَاجِبَ%'
  ) then raise exception 'Lesson 21 لم/لما table, distinction or short answer is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1333
      and content like '%اِسْمٌ%' and content like '%فِعْلٌ%' and content like '%حَرْفٌ%'
      and content like '%هَلْ%' and content like '%تُسَافِرُ%' and content like '%مَعِي%'
  ) then raise exception 'Lesson 21 three word classes are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1334
      and content like '%اِسْمُ الْجَمْعِ%' and content like '%اِسْمُ الْجِنْسِ الْجَمْعِيُّ%'
      and content like '%اِسْمُ الْجِنْسِ الْإِفْرَادِيُّ%'
      and rule_ar like '%الْجَرُّ%' and rule_ar like '%التَّنْوِينُ%'
      and rule_ar like '%النِّدَاءُ%' and rule_ar like '%الْإِسْنَادُ إِلَيْهِ%'
  ) then raise exception 'Lesson 21 noun divisions and signs are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1335
      and content like '%تَاءَ الْفَاعِلِ%' and content like '%تَاءَ التَّأْنِيثِ السَّاكِنَةَ%'
      and content like '%نُونَ التَّوْكِيدِ%' and content like '%يَاءَ الْمُخَاطَبَةِ%'
      and content like '%حُرُوفُ مَبَانٍ%' and content like '%حُرُوفُ مَعَانٍ%'
  ) then raise exception 'Lesson 21 verb signs and letter classes are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1336
      and content like '%الطَّالِبُ مُجْتَهِدٌ%' and content like '%خَرَجَ الْمُدَرِّسُ%'
      and content like '%خَبَرٌ جُمْلَةٌ اسْمِيَّةٌ%' and content like '%خَبَرٌ جُمْلَةٌ فِعْلِيَّةٌ%'
      and content like '%شِبْهُ جُمْلَةٍ%'
  ) then raise exception 'Lesson 21 sentence types and predicate forms are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1899
      and content like '%اللَّاتِي%' and content like '%اللَّائِي%'
      and content like '%فِي مَحَلِّ رَفْعٍ%'
  ) then raise exception 'Lesson 21 feminine relative pronouns are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1900
      and content like '%هَارُونُ%' and content like '%ثُلَاثِيٌّ سَاكِنُ الْوَسَطِ%'
      and content like '%نُوحٌ%' and content like '%بَلْخُ%'
  ) then raise exception 'Lesson 21 foreign proper-name warning is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1337
      and content like '%حَامِدٌ%' and content like '%يَشْرَبُ%'
      and content like '%أَنْتُنَّ%' and content like '%تَشْرَبْنَ%'
      and content like '%نَحْنُ%' and content like '%نَشْرَبُ%'
      and content like '%ثُبُوتُ النُّونِ%' and content like '%حَذْفُ النُّونِ%'
  ) then raise exception 'Lesson 22 ten-form state table is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1338
      and content like '%خَبَرٌ مَرْفُوعٌ%' and content like '%مَفْعُولٌ بِهِ مَنْصُوبٌ%'
      and content like '%مَجْرُورٌ بِـ«عَلَى»%'
      and content like '%نُونُ الْمُثَنَّى مَكْسُورَةٌ%'
  ) then raise exception 'Lesson 23 sound masculine plural parsing is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1339
      and content like '%عِشْرُونَ%' and content like '%ثَلَاثُونَ%'
      and content like '%سِتُّونَ%' and content like '%تِسْعُونَ%'
      and content like '%بِسِتِّينَ%' and content like '%رِيَالًا%'
  ) then raise exception 'Lesson 23 decade declension and examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1340
      and content like '%فَلَا صَدَّقَ وَلَا صَلَّىٰ%'
      and content like '%لَا أَكَلْتُ وَلَا شَرِبْتُ%'
      and content like '%فِي الْإِخْبَارِ فَقَطْ%'
  ) then raise exception 'Lesson 23 repeated لا with past tense is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1341
      and content like '%طَالِبٌ%' and content like '%وَاحِدٌ%'
      and content like '%طَالِبَتَانِ%' and content like '%اِثْنَتَانِ%'
      and content like '%سَلَّمْتُ عَلَى%' and content like '%وَاحِدٍ%'
  ) then raise exception 'Lesson 24 numbers one and two are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1342
      and content like '%ثَلَاثَةُ%' and content like '%طُلَّابٍ%'
      and content like '%عَشْرُ%' and content like '%طَالِبَاتٍ%'
      and content like '%سَبْعَةُ%' and content like '%أَيَّامٍ%'
  ) then raise exception 'Lesson 24 numbers three through ten are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1343
      and content like '%أَحَدَ عَشَرَ%' and content like '%تِسْعَ عَشْرَةَ%'
      and content like '%اِثْنَا عَشَرَ%' and content like '%اِثْنَيْ عَشَرَ%'
      and content like '%طَالِبًا%' and content like '%طَالِبَةً%'
  ) then raise exception 'Lesson 24 compound numbers are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1344
      and content like '%سِتَّةٌ%' and content like '%سِتٌّ%'
      and content like '%عِشْرُونَ%' and content like '%عِشْرِينَ%'
      and content like '%ثَلَاثَةٌ%' and content like '%ثَلَاثَةٍ%'
      and content like '%حَصَلْتُ عَلَى%' and content like '%قَلَمًا%'
  ) then raise exception 'Lesson 24 coordinated numbers are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1345
      and content like '%اِثْنَانِ%' and content like '%وَأَرْبَعُونَ وَمِائَةٌ%'
      and content like '%سِتَّةُ آلَافِ%' and content like '%تِسْعَةُ آلَافِ%'
      and content like '%سِتَّةٌ وَخَمْسُونَ%' and content like '%سِتَّةً وَخَمْسِينَ%'
      and content like '%سِتَّةٍ وَخَمْسِينَ%' and content like '%سَلَّمْتُ عَلَى%'
      and content like '%إِعْرَابٌ تَقْدِيرِيٌّ%'
  ) then raise exception 'Lesson 24 hundreds, thousands and full 3456 parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1346
      and content like '%حَامِدٌ%' and content like '%طَالِبًا%'
      and content like '%يَدْرُسُ%' and content like '%فِي الْفَصْلِ%'
      and content like '%скрытое местоимение%' and content like '%هُوَ%'
      and content like '%مِنْ قَبْلُ%'
      and content like '%مِنْ بَعْدُ%'
  ) then raise exception 'Lesson 25 كان/ما زال explanation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1347
      and content like '%أَبُوكَ%' and content like '%أَبَاكَ%' and content like '%أَبِيكَ%'
      and content like '%أَخُوكَ%' and content like '%أَخَاكَ%' and content like '%أَخِيكَ%'
  ) then raise exception 'Lesson 25 five-noun declension examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1348
      and content like '%مُفْرَدَةٌ غَيْرُ مُثَنَّاةٍ وَلَا مَجْمُوعَةٍ%'
      and content like '%مُضَافَةٌ إِلَى غَيْرِ يَاءِ الْمُتَكَلِّمِ%'
      and content like '%جَاءَ%' and content like '%أَبُو بَكْرٍ%'
      and content like '%ذَهَبْتُ إِلَى%' and content like '%أَبِي بَكْرٍ%'
  ) then raise exception 'Lesson 25 five-noun conditions are incomplete'; end if;
end;
$assert$;

commit;
