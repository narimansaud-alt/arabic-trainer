-- Certify the complete Russian rendering of Medina Book 3, lessons 7-9.
-- Controlling source: Sharkh_Medinskiy_3.pdf, PDF pages 34-41.

begin;

create temp table _book3_full_sharh_batch03 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book3_full_sharh_batch03 values
  (1941, '7', 'Полный шарх: с. 34–35'),
  (1942, '8', 'Полный шарх: с. 36'),
  (1943, '8', 'Полный шарх: с. 36'),
  (1944, '8', 'Полный шарх: с. 36'),
  (1945, '8', 'Полный шарх: с. 36–37'),
  (1946, '8', 'Полный шарх: с. 37'),
  (1947, '8', 'Полный шарх: с. 37'),
  (1948, '8', 'Полный шарх: с. 37'),
  (1949, '8', 'Полный шарх: с. 38'),
  (1950, '9', 'Полный шарх: с. 39'),
  (1951, '9', 'Полный шарх: с. 39'),
  (1952, '9', 'Полный шарх: с. 39–40'),
  (1953, '9', 'Полный шарх: с. 39–40'),
  (1954, '9', 'Полный шарх: с. 40'),
  (1955, '9', 'Полный шарх: с. 40–41'),
  (1956, '9', 'Полный шарх: с. 41');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book3_full_sharh_batch03 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 3)' and r.lesson_number = b.lesson_number;
  if v_count <> 16 then raise exception 'Expected 16 guarded Book 3 rules for lessons 7-9, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then raise exception 'Book 3 must retain 89 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then raise exception 'Book 3 must retain 89 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join _book3_full_sharh_batch03 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_3.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null and rs.source_page_to is not null;
  if v_count <> 16 then raise exception 'Book 3 lessons 7-9 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book3-full-sharh-batch03"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book3_full_sharh_batch03 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 3)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book3-full-sharh-batch03') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book3_full_sharh_batch03 b on b.rule_id = r.id
  where strpos(r.content, 'book3-full-sharh-batch03') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 16 then raise exception 'Book 3 lessons 7-9 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book3_full_sharh_batch03 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id and s.source_document = 'Sharkh_Medinskiy_3.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 3 lesson 7-9 card has no complete source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1941
      and content like '%مِفْتَاحٌ%'
      and content like '%مِيزَانٌ%'
      and content like '%مِقَصٌّ%'
      and content like '%مِمْحَاةٌ%'
      and content like '%سَاقِيَةٌ%'
      and content like '%ثَلَّاجَةٌ%'
      and content like '%اسْمٌ جَامِدٌ غَيْرُ مُشْتَقٍّ%'
      and content like '%الْبَصْرِيُّونَ يَرَوْنَ أَنَّ أَصْلَ الْمُشْتَقَّاتِ هُوَ الْمَصْدَرُ%'
  ) then raise exception 'Lesson 7 instrument-noun patterns, heard forms or author note are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1942
      and content like '%أَنْتَ، مُحَمَّدٌ، هَذَا، الَّذِي%'
      and content like '%رَجُلٌ، كِتَابٌ، جَامِعَةٌ%'
      and content like '%٧%'
      and content like '%النَّكِرَةُ الْمَقْصُودَةُ بِالنِّدَاءِ%'
  ) then raise exception 'Lesson 8 definite/indefinite definitions or seven categories are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1943
      and content like '%أَنْتَ، أَنْتِ، أَنْتُمَا، أَنْتُمْ، أَنْتُنَّ%'
      and content like '%تَقْدِيرُهُ: هِيَ%'
      and content like '%تَقْدِيرُهُ: أَنَا%'
      and content like '%الضَّمَائِرُ كُلُّهَا مَبْنِيَّةٌ%'
  ) then raise exception 'Lesson 8 pronoun divisions, visible/hidden forms or ruling are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1944
      and content like '%مُحَمَّدٌ%'
      and content like '%عَبْدُ الرَّحْمَنِ%'
      and content like '%مَكَّةُ%'
      and content like '%أَبُو حَامِدٍ%'
  ) then raise exception 'Lesson 8 proper-name examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1945
      and content like '%هَذَانِ%'
      and content like '%هَاتَانِ%'
      and content like '%ذَانِكَ%'
      and content like '%تَانِكَ%'
      and content like '%هُنَالِكَ%'
      and content like '%ثَمَّ%'
      and content like '%مَا عَدَا الْمُثَنَّى%'
  ) then raise exception 'Lesson 8 demonstratives, place forms or dual exception are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1946
      and content like '%اللَّائِي%'
      and content like '%كَافَأْتُ الطُّلَّابَ الَّذِينَ نَجَحُوا%'
      and content like '%جَاءَ مَنْ أَكْرَمْتُهُ%'
      and content like '%يُسَمَّى عَائِدًا%'
      and content like '%مَا عَدَا الْمُثَنَّى%'
  ) then raise exception 'Lesson 8 relative nouns,صلة, عائد or dual exception are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1947
      and content like '%قَلَمٌ%'
      and content like '%الْقَلَمُ%'
      and content like '%رَجُلٌ%'
      and content like '%الْبَيْتُ%'
  ) then raise exception 'Lesson 8 definition with أل examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1948
      and content like '%كِتَابُكَ%'
      and content like '%كِتَابُ مُحَمَّدٍ%'
      and content like '%كِتَابُ الَّذِي زَارَنَا%'
      and content like '%يَبْقَى نَكِرَةً%'
      and content like '%نَكِرَةٌ مُخَصَّصَةٌ%'
  ) then raise exception 'Lesson 8 idafa to definite and indefinite nouns is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1949
      and content like '%قُصِدَ تَعْيِينُهُ بِالنِّدَاءِ%'
      and content like '%يَا رَجُلُ%'
      and content like '%يَا رَجُلًا سَاعِدْنِي%'
      and content like '%نَكِرَةٌ غَيْرُ مَقْصُودَةٍ%'
      and content like '%يَا مُحَمَّدُ%'
      and content like '%مَعْرِفَةٌ قَبْلَ النِّدَاءِ%'
  ) then raise exception 'Lesson 8 intended vocative indefinite and contrasts are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1950
      and content like '%هَذَانِ الطَّالِبَانِ مُجْتَهِدَانِ%'
      and content like '%هَذَيْنِ الطَّالِبَيْنِ%'
      and content like '%اثْنَانِ وَاثْنَتَانِ%'
      and content like '%كِلَاهُمَا، كِلْتَاهُمَا%'
  ) then raise exception 'Lesson 9 dual definition, signs or attached forms are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1951
      and content like '%هَاتَانِ بِنْتَا حَامِدٍ%'
      and content like '%جَاءَ أَلْفَا حَاجٍّ%'
      and content like '%اِشْتَرَيْتُ مِائَتَيْ سَاعَةٍ%'
      and content like '%مَاتَ أَبَوَاهُ%'
      and content like '%غَسَلْتُ رِجْلَيَّ%'
  ) then raise exception 'Lesson 9 dual nun deletion and all author examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1952
      and content like '%مُرَاعَاةُ اللَّفْظِ%'
      and content like '%مُرَاعَاةُ الْمَعْنَى%'
      and content like '%كِلَيْهِمَا، كِلْتَيْهِمَا%'
      and content like '%إِضَافَتُهُمَا إِلَى الضَّمِيرِ%'
  ) then raise exception 'Lesson 9 كلا/كلتا agreement and pronoun condition are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1953
      and content like '%ذَانِكَ قَلَمَانِ%'
      and content like '%تَانِكَ سَيَّارَتَانِ%'
      and content like '%ذَيْنِكَ الطَّالِبَيْنِ%'
      and content like '%تَيْنِكَ الطَّالِبَتَيْنِ%'
  ) then raise exception 'Lesson 9 dual demonstrative declension is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1954
      and content like '%أَخَوَايَ%'
      and content like '%عَمَّايَ%'
      and content like '%يَدَايَ%'
      and content like '%أَخَوَيَّ%'
      and content like '%يَدَيَّ%'
  ) then raise exception 'Lesson 9 dual forms before first-person ya are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1955
      and content like '%الْمُدَرِّسُونَ مُخْلِصُونَ%'
      and content like '%مُسْلِمِي الْهِنْدِ%'
      and content like '%مُدَرِّسُو النَّحْوِ أَقْوِيَاءُ%'
      and content like '%حُذِفَ التَّنْوِينُ عِنْدَ الْإِضَافَةِ%'
      and content like '%سَيَّارَةُ خَالِدٍ جَدِيدَةٌ%'
  ) then raise exception 'Lesson 9 sound masculine plural or idafa changes are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1956
      and content like '%اِئْتِ%'
      and content like '%اِيتِ%'
      and content like '%أُبْدِلَتِ الْهَمْزَةُ الثَّانِيَةُ يَاءً%'
      and content like '%فَأۡتِ بِهَا مِنَ ٱلۡمَغۡرِبِ%'
      and content like '%وَأۡتُواْ ٱلۡبُيُوتَ مِنۡ أَبۡوَٰبِهَا%'
  ) then raise exception 'Lesson 9 command from أتى and both Quran examples are incomplete'; end if;
end;
$assert$;

commit;
