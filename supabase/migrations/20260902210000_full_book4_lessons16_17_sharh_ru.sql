-- Certify the complete Russian rendering of Medina Book 4, lessons 16-17.
-- Controlling source: Sharkh_Medinskiy_4.pdf, PDF pages 64-71.

begin;

create temp table _book4_full_sharh_batch06 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book4_full_sharh_batch06 values
  (1869, '16', 'Полный шарх: с. 64–65'),
  (2016, '16', 'Полный шарх: с. 65–66'),
  (2017, '16', 'Полный шарх: с. 67'),
  (1870, '16', 'Полный шарх: с. 67–68'),
  (1871, '17', 'Полный шарх: с. 68'),
  (1872, '17', 'Полный шарх: с. 68'),
  (1873, '17', 'Полный шарх: с. 68–69'),
  (1874, '17', 'Полный шарх: с. 69–70'),
  (1875, '17', 'Полный шарх: с. 70');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch06 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 4)' and r.lesson_number = b.lesson_number;
  if v_count <> 9 then raise exception 'Expected 9 guarded Book 4 rules for lessons 16-17, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join _book4_full_sharh_batch06 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_4.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null and rs.source_page_to is not null;
  if v_count <> 9 then raise exception 'Book 4 lessons 16-17 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book4-full-sharh-batch06"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book4_full_sharh_batch06 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 4)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book4-full-sharh-batch06') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch06 b on b.rule_id = r.id
  where strpos(r.content, 'book4-full-sharh-batch06') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 9 then raise exception 'Book 4 lessons 16-17 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book4_full_sharh_batch06 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id and s.source_document = 'Sharkh_Medinskiy_4.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 4 lesson 16-17 card has no complete source row'; end if;

  if not exists (select 1 from public.rules where id = 1869 and content like '%قَرِيبٌ مِنَ الْوَاجِبِ%' and content like '%وَاللَّهِ لَسَوْفَ أَجْتَهِدُ%' and content like '%إِنْ الشَّرْطِيَّةُ%')
    then raise exception 'Lesson 16 emphasis-nun types, all four present-tense states or examples are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2016 and content like '%حَذْفُ نُونِ الرَّفْعِ%' and content like '%أَلِفٍ فَاصِلَةٍ%' and content like '%لَا تَتَّصِلُ بِهِ النُّونُ الْخَفِيفَةُ%')
    then raise exception 'Lesson 16 all six ending transformations, restrictions or weak-letter restoration are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2017 and content like '%النُّونُ الْمَحْذُوفَةُ لِتَوَالِي الْأَمْثَالِ%' and content like '%وَاوُ الْجَمَاعَةِ الْمَحْذُوفَةُ%')
    then raise exception 'Lesson 16 three complete emphasis-nun parsings are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1870 and content like '%إِضْرَابٌ إِبْطَالِيٌّ%' and content like '%إِضْرَابٌ انْتِقَالِيٌّ%' and content like '%لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ%')
    then raise exception 'Lesson 16 both introductory bal meanings, examples or parsing are incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1871 and content like '%لِعِلَّةٍ وَاحِدَةٍ%' and content like '%لِعِلَّتَيْنِ%')
    then raise exception 'Lesson 17 diptote definition or its two primary divisions are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1872 and content like '%مَفَاعِلُ وَمَفَاعِيلُ%' and content like '%بَطَاطِسَ، طَمَاطِمَ، طَبَاشِيرَ، سَرَاوِيلَ%')
    then raise exception 'Lesson 17 all one-cause diptote categories, conditions or examples are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1873 and content like '%يَجُوزُ صَرْفُهُ وَمَنْعُهُ%' and content like '%حَضْرَمَوْتَ، بَعْلَبَكَّ، مَعْدِيكَرِبَ%')
    then raise exception 'Lesson 17 all six proper-name categories and special cases are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1874 and content like '%أَلَّا يَكُونَ مُؤَنَّثُهُ بِالتَّاءِ%' and content like '%مَثْنَى وَثُنَاءَ، وَمَثْلَثَ وَثُلَاثَ%')
    then raise exception 'Lesson 17 all adjective diptote categories, conditions or examples are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1875 and content like '%يُجَرُّ بِالْفَتْحَةِ نِيَابَةً عَنِ الْكَسْرَةِ%' and content like '%التَّنْوِينُ لِلْعِوَضِ%')
    then raise exception 'Lesson 17 diptote rulings, exceptions or all deficient-plural parsings are incomplete'; end if;
end;
$assert$;

commit;
