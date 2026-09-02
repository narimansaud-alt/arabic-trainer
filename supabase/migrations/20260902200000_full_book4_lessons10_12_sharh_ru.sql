-- Certify the complete Russian rendering of Medina Book 4, lessons 10-12.
-- Controlling source: Sharkh_Medinskiy_4.pdf, PDF pages 42-53.

begin;

create temp table _book4_full_sharh_batch04 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book4_full_sharh_batch04 values
  (1846, '10', 'Полный шарх: с. 42'),
  (2004, '10', 'Полный шарх: с. 42–43'),
  (2005, '10', 'Полный шарх: с. 43–44'),
  (1847, '10', 'Полный шарх: с. 44'),
  (2006, '10', 'Полный шарх: с. 44'),
  (2007, '10', 'Полный шарх: с. 44'),
  (1848, '11', 'Полный шарх: с. 45'),
  (1849, '11', 'Полный шарх: с. 46'),
  (1850, '11', 'Полный шарх: с. 46–47'),
  (1851, '11', 'Полный шарх: с. 47–48'),
  (2008, '11', 'Полный шарх: с. 48'),
  (2009, '11', 'Полный шарх: с. 48–49'),
  (2010, '11', 'Полный шарх: с. 49–50'),
  (1852, '12', 'Полный шарх: с. 51'),
  (1853, '12', 'Полный шарх: с. 51–52'),
  (2011, '12', 'Полный шарх: с. 52–53');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch04 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 4)' and r.lesson_number = b.lesson_number;
  if v_count <> 16 then raise exception 'Expected 16 guarded Book 4 rules for lessons 10-12, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join _book4_full_sharh_batch04 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_4.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null and rs.source_page_to is not null;
  if v_count <> 16 then raise exception 'Book 4 lessons 10-12 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book4-full-sharh-batch04"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book4_full_sharh_batch04 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 4)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book4-full-sharh-batch04') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch04 b on b.rule_id = r.id
  where strpos(r.content, 'book4-full-sharh-batch04') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 16 then raise exception 'Book 4 lessons 10-12 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book4_full_sharh_batch04 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id and s.source_document = 'Sharkh_Medinskiy_4.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 4 lesson 10-12 card has no complete source row'; end if;

  if not exists (select 1 from public.rules where id = 1846 and content like '%الِاخْتِصَارُ%' and content like '%ضَمَائِرُ بَارِزَةٌ%' and content like '%ضَمَائِرُ مُسْتَتِرَةٌ%')
    then raise exception 'Lesson 10 pronoun definition, benefit or primary classes are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2004 and content like '%ذَهَبْنَ، يَذْهَبْنَ، اِذْهَبْنَ%' and content like '%سَأَلَنَا، يَسْأَلُنَا، اِسْأَلْنَا%' and content like '%كِتَابُنَا، لَنَا%')
    then raise exception 'Lesson 10 attached pronoun definition or all three syntactic classes are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2005 and content like '%إِيَّاهُ، إِيَّاهَا، إِيَّاهُمَا، إِيَّاهُمْ، إِيَّاهُنَّ%' and content like '%ضَمَائِرُ الْجَرِّ لَا تَأْتِي إِلَّا مُتَّصِلَةً%')
    then raise exception 'Lesson 10 detached pronoun lists or genitive restriction are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1847 and content like '%الْمُتَكَلِّمُ%' and content like '%الْمُخَاطَبُ%' and content like '%الْغَائِبُ%')
    then raise exception 'Lesson 10 three pronoun ranks are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2006 and content like '%زِيَارَةُ الْمُدِيرِ إِيَّانَا%' and content like '%يَزُورُنَا الْمُدِيرُ%' and content like '%أَعْطَيْتُهُ إِيَّاهُ%')
    then raise exception 'Lesson 10 all five required detached-object positions or explanation are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2007 and content like '%وُجُوبُ الْفَصْلِ%' and content like '%أَعْطَيْتُكَ إِيَّاهُ%' and content like '%أَعْطَيْتُكَهُ%')
    then raise exception 'Lesson 10 connection and separation of two object pronouns are incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1848 and content like '%سُبْحَانَ اللَّهِ%' and content like '%سَمْعًا وَطَاعَةً%' and content like '%صِفَةٌ أَوْ مُضَافٌ إِلَيْهِ%')
    then raise exception 'Lesson 11 all four absolute-object types, examples or type condition are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1849 and content like '%قُدُومًا مُبَارَكًا%' and content like '%كَمْ سَجْدَةً%' and content like '%لَا يَجُوزُ حَذْفُ%')
    then raise exception 'Lesson 11 deletion of the absolute-object governor is incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1850 and content like '%كُلَّ الْفَهْمِ%' and content like '%اِغْتَسَلْتُ غُسْلًا%' and content like '%قُمْتُ وُقُوفًا%' and content like '%ثَلَاثَ زِيَارَاتٍ%')
    then raise exception 'Lesson 11 all eight substitutes for the masdar are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1851 and content like '%كَبَّرَ ← تَكْبِيرٌ ← تَكْبِيرَةٌ%' and content like '%تَرْجَمَةً وَاحِدَةً%' and content like '%إِقَامَةً وَاحِدَةً%')
    then raise exception 'Lesson 11 masdar of one occurrence formation or exceptions are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2008 and content like '%إِكْلَةٌ، مِشْيَةٌ، جِلْسَةٌ، قِتْلَةٌ%' and content like '%لَا يُصَاغُ مِنْ غَيْرِ الثُّلَاثِيِّ الْمُجَرَّدِ%')
    then raise exception 'Lesson 11 manner masdar formation, forms or restriction are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2009 and content like '%مَوْقِفُكَ مَعِي كَانَ عَظِيمًا%' and content like '%مُسْتَقَى الزَّرْعِ يُحْيِيهِ%' and content like '%مِيمٌ مَضْمُومَةٌ وَفَتْحُ مَا قَبْلَ الْآخِرِ%')
    then raise exception 'Lesson 11 all mim-masdar patterns, conditions or examples are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2010 and content like '%عِشْرِينَ: مَفْعُولٌ مُطْلَقٌ%' and content like '%هَذِهِ: اسْمُ إِشَارَةٍ%' and content like '%الْمُعَامَلَةَ: بَدَلٌ مَنْصُوبٌ%')
    then raise exception 'Lesson 11 full parsing of the absolute object and substitutes is incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1852 and content like '%ضَرَبْتُ ابْنِي لِلتَّأْدِيبِ%' and content like '%مَرْضَاةِ: مُضَافٌ إِلَيْهِ%' and content like '%قَلِيلُ الِاسْتِعْمَالِ%')
    then raise exception 'Lesson 12 purpose-object states, usage note or parsing are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1853 and content like '%اِسْأَلِ الْمُدَرِّسَ لَا الطَّالِبَ%' and content like '%عَلِيٌّ: مَعْطُوفٌ مَرْفُوعٌ%' and content like '%بَعْدَ الْإِيجَابِ أَوِ الْأَمْرِ%')
    then raise exception 'Lesson 12 conjunctive لا conditions, examples or parsing are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2011 and content like '%هَلَّا تَجْتَهِدُونَ%' and content like '%لَوْلَا صُمْتَ%' and content like '%حَرْفُ تَنْدِيمٍ%' and content like '%جَعْلُ الْمُخَاطَبِ يَنْدَمُ%')
    then raise exception 'Lesson 12 urging and reproach particles, meanings, examples or parsing are incomplete'; end if;
end;
$assert$;

commit;
