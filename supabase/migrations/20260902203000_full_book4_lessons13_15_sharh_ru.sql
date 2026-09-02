-- Certify the complete Russian rendering of Medina Book 4, lessons 13-15.
-- Controlling source: Sharkh_Medinskiy_4.pdf, PDF pages 53-64.

begin;

create temp table _book4_full_sharh_batch05 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book4_full_sharh_batch05 values
  (1854, '13', 'Полный шарх: с. 53'),
  (2012, '13', 'Полный шарх: с. 53–54'),
  (2013, '13', 'Полный шарх: с. 54'),
  (2014, '13', 'Полный шарх: с. 55'),
  (1855, '13', 'Полный шарх: с. 55–56'),
  (1856, '14', 'Полный шарх: с. 56–57'),
  (1857, '14', 'Полный шарх: с. 57–58'),
  (1858, '14', 'Полный шарх: с. 58–59'),
  (1859, '14', 'Полный шарх: с. 59'),
  (2015, '14', 'Полный шарх: с. 59–60'),
  (1860, '15', 'Полный шарх: с. 60–61'),
  (1861, '15', 'Полный шарх: с. 61–62'),
  (1862, '15', 'Полный шарх: с. 62'),
  (1863, '15', 'Полный шарх: с. 62'),
  (1864, '15', 'Полный шарх: с. 62–63'),
  (1865, '15', 'Полный шарх: с. 63'),
  (1866, '15', 'Полный шарх: с. 63'),
  (1867, '15', 'Полный шарх: с. 63–64'),
  (1868, '15', 'Полный шарх: с. 64');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch05 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 4)' and r.lesson_number = b.lesson_number;
  if v_count <> 19 then raise exception 'Expected 19 guarded Book 4 rules for lessons 13-15, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join _book4_full_sharh_batch05 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_4.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null and rs.source_page_to is not null;
  if v_count <> 19 then raise exception 'Book 4 lessons 13-15 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book4-full-sharh-batch05"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book4_full_sharh_batch05 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 4)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book4-full-sharh-batch05') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch05 b on b.rule_id = r.id
  where strpos(r.content, 'book4-full-sharh-batch05') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 19 then raise exception 'Book 4 lessons 13-15 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book4_full_sharh_batch05 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id and s.source_document = 'Sharkh_Medinskiy_4.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 4 lesson 13-15 card has no complete source row'; end if;

  if not exists (select 1 from public.rules where id = 1854 and content like '%تَمْيِيزُ الذَّاتِ%' and content like '%تَمْيِيزُ النِّسْبَةِ%')
    then raise exception 'Lesson 13 distinction definition or its two types are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2012 and content like '%الْقَفِيزُ مِكْيَالٌ قَدِيمٌ%' and content like '%الْجَرُّ بِالْإِضَافَةِ%')
    then raise exception 'Lesson 13 subject distinction measures, examples or three cases are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2013 and content like '%قَدْرُ رَاحَةٍ%' and content like '%لَا يَجُوزُ الْجَرُّ بِالْإِضَافَةِ%')
    then raise exception 'Lesson 13 quasi-measures, restrictions or examples are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2014 and content like '%أَصْلُ التَّمْيِيزِ%' and content like '%بَابِ اِفْتَعَلَ%')
    then raise exception 'Lesson 13 relation distinction origins or five common positions are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1855 and content like '%مَا أَجْمَلَ الْوَرْدَةَ%' and content like '%الْفَتْحَةُ الْمُقَدَّرَةُ%')
    then raise exception 'Lesson 13 both exclamation formulas or their complete parsing are incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1856 and content like '%الصِّفَةُ الْمُشَبَّهَةُ%' and content like '%فُعَالٌ%')
    then raise exception 'Lesson 14 state definition, derived descriptions or adjective patterns are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1857 and content like '%فَاعِلٌ وَمَفْعُولٌ بِهِ مَعًا%' and content like '%نَكِرَةً بِلَا مُسَوِّغٍ%')
    then raise exception 'Lesson 14 all state-owner roles or indefinite-owner conditions are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1858 and content like '%جَمْعُ الْمُؤَنَّثِ السَّالِمُ%' and content like '%شِبْهُ الْجُمْلَةِ%')
    then raise exception 'Lesson 14 all state forms, cases, clauses or quasi-clauses are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1859 and content like '%وَاوُ الْحَالِ وَحْدَهَا%' and content like '%نُونُ النِّسْوَةِ%')
    then raise exception 'Lesson 14 all three state-clause links and examples are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2015 and content like '%قِيَامٌ%' and content like '%قُعُودٌ%' and content like '%جُلُوسٌ%')
    then raise exception 'Lesson 14 plural patterns, gender rule or author examples are incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1860 and content like '%الْمُسْتَثْنَى مِنْهُ%' and content like '%مُتَّصِلٌ%' and content like '%مُنْقَطِعٌ%')
    then raise exception 'Lesson 15 exception definition, elements, tools or divisions are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1861 and content like '%وُجُوبُ النَّصْبِ%' and content like '%بَدَلُ بَعْضٍ مِنْ كُلٍّ%')
    then raise exception 'Lesson 15 connected-exception rulings or full examples are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1862 and content like '%فِي جَمِيعِ أَحْوَالِهِ%')
    then raise exception 'Lesson 15 disconnected-exception mandatory accusative is incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1863 and content like '%إِلَّا مُلْغَاةٌ مِنَ النَّاحِيَةِ الْإِعْرَابِيَّةِ%')
    then raise exception 'Lesson 15 emptied-exception government or examples are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1864 and content like '%مَجْرُورٌ بِالْإِضَافَةِ دَائِمًا%' and content like '%مَا مَرَرْتُ بِغَيْرِ عَلِيٍّ%')
    then raise exception 'Lesson 15 exception with ghayr and siwa is incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1865 and content like '%ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ هُوَ%' and content like '%كَلِمَةِ «بَعْضٍ»%')
    then raise exception 'Lesson 15 exception with ma khala and ma ada is incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1866 and content like '%أَخْشَى أَنْ أَكُونَهُ%' and content like '%أَخْشَى أَنْ أَكُونَ إِيَّاهُ%')
    then raise exception 'Lesson 15 connected and detached kana predicate pronouns are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1867 and content like '%مَبْنِيٌّ عَلَى السُّكُونِ%' and content like '%لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ%')
    then raise exception 'Lesson 15 opening-particle meaning, examples or parsing are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1868 and content like '%دَنَانِيرُ%' and content like '%دَيَانِيرُ%' and content like '%دَمَامِيسُ%' and content like '%دَيَامِيسُ%')
    then raise exception 'Lesson 15 irregular plural rows or their expected analogical forms are incomplete'; end if;
end;
$assert$;

commit;
