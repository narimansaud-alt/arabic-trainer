-- Certify the complete Russian rendering of Medina Book 4, lessons 4-6.
-- Controlling source: Sharkh_Medinskiy_4.pdf, PDF pages 13-28.

begin;

create temp table _book4_full_sharh_batch02 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book4_full_sharh_batch02 values
  (1804, '4', 'Полный шарх: с. 13–14'),
  (1805, '4', 'Полный шарх: с. 14'),
  (1806, '4', 'Полный шарх: с. 14'),
  (1807, '4', 'Полный шарх: с. 14–15'),
  (1808, '4', 'Полный шарх: с. 15'),
  (1809, '4', 'Полный шарх: с. 15–16'),
  (1810, '4', 'Полный шарх: с. 16–19'),
  (1811, '4', 'Полный шарх: с. 19–20'),
  (1812, '4', 'Полный шарх: с. 20'),
  (1813, '5', 'Полный шарх: с. 21'),
  (1814, '5', 'Полный шарх: с. 21–22'),
  (1815, '5', 'Полный шарх: с. 22'),
  (1816, '5', 'Полный шарх: с. 22'),
  (1817, '5', 'Полный шарх: с. 22–23'),
  (1818, '5', 'Полный шарх: с. 23'),
  (1819, '6', 'Полный шарх: с. 24'),
  (1820, '6', 'Полный шарх: с. 24–25'),
  (1821, '6', 'Полный шарх: с. 25–26'),
  (1822, '6', 'Полный шарх: с. 26–27'),
  (1823, '6', 'Полный шарх: с. 27'),
  (1824, '6', 'Полный шарх: с. 27–28');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch02 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 4)' and r.lesson_number = b.lesson_number;
  if v_count <> 21 then raise exception 'Expected 21 guarded Book 4 rules for lessons 4-6, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join _book4_full_sharh_batch02 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_4.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null and rs.source_page_to is not null;
  if v_count <> 21 then raise exception 'Book 4 lessons 4-6 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book4-full-sharh-batch02"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book4_full_sharh_batch02 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 4)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book4-full-sharh-batch02') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch02 b on b.rule_id = r.id
  where strpos(r.content, 'book4-full-sharh-batch02') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 21 then raise exception 'Book 4 lessons 4-6 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book4_full_sharh_batch02 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id and s.source_document = 'Sharkh_Medinskiy_4.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 4 lesson 4-6 card has no complete source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1804
      and content like '%إِظْهَارُ مَا لَيْسَ فِي الْبَاطِنِ%'
      and content like '%تَصَافَحَ الرَّجُلَانِ%'
      and content like '%تَعَامٍ (أَصْلُهُ تَعَامُيٌ)%'
      and content like '%وَلَا تَعَاوَنُواْ%'
      and content like '%وَلَا تَنَابَزُواْ%'
  ) then raise exception 'Lesson 4 تفاعل meanings, derivatives or deletion examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1805
      and content like '%بِأَنْ نُصَلِّيَ%'
      and content like '%مِنْ أَنْ أَكُونَ مِنَ الْجَاهِلِينَ%'
      and content like '%شَهِدَ ٱللَّهُ أَنَّهُ%'
  ) then raise exception 'Lesson 4 omitted prepositions before interpreted masdars are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1806
      and content like '%إِيَّاكَ أَنْ تَكْذِبَ%'
      and content like '%إِيَّاكُمْ أَنْ تَنَامُوا فِي الْفَصْلِ%'
  ) then raise exception 'Lesson 4 warning construction without waw is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1807
      and content like '%وَعْدٌ%'
      and content like '%عِدَةٌ%'
      and content like '%عِظَةٌ%'
      and content like '%زِنَةٌ%'
  ) then raise exception 'Lesson 4 initial-waw masdar alternatives are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1808
      and content like '%يَٰلَيۡتَنِي كُنتُ تُرَٰبَۢا%'
      and content like '%لَيْتَ الشَّبَابَ يَعُودُ%'
      and content like '%لَيْتَ لِي مَالًا كَثِيرًا%'
      and content like '%لَيْتَنِي عَالِمٌ%'
  ) then raise exception 'Lesson 4 both meanings of ليت or author examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1809
      and content like '%أَلَّا تَقْتَرِنَ بِحَرْفِ جَرٍّ%'
      and content like '%الشَّبِيهُ بِالْمُضَافِ%'
      and content like '%لَا مُسْلِمَاتِ مُتَبَرِّجَاتٌ%'
      and content like '%لَا إِكْرَاهَ فِي الدِّينِ%'
      and content like '%اسْمُ لَا النَّافِيَةِ لِلْجِنْسِ مَبْنِيٌّ عَلَى الْفَتْحِ%'
  ) then raise exception 'Lesson 4 لا النافية للجنس conditions, types, verses or parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1810
      and content like '%بَدَلُ بَعْضٍ مِنْ كُلٍّ%'
      and content like '%بَدَلُ اشْتِمَالٍ%'
      and content like '%بَدَلُ الْمُبَايِنِ%'
      and content like '%وَلَا يُشْتَرَطُ اتِّفَاقُ الْبَدَلِ وَالْمُبْدَلِ مِنْهُ%'
      and content like '%فِعْلٌ مِنْ فِعْلٍ%'
      and content like '%جُمْلَةٌ مِنِ اسْمٍ مُفْرَدٍ%'
      and content like '%هَدْيِهِ: بَدَلُ اشْتِمَالٍ مَجْرُورٌ%'
  ) then raise exception 'Lesson 4 all بدل kinds, restrictions, replacement forms or parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1811
      and content like '%لَعَلَّ لِلْمُمْكِنِ حُصُولُهُ%'
      and content like '%جُمْلَةٌ فِعْلِيَّةٌ%'
      and content like '%جُمْلَةٌ اسْمِيَّةٌ%'
      and content like '%إِنَّ إِلَيۡنَآ إِيَابَهُمۡ%'
      and content like '%إِنَّ لَدَيۡنَآ أَنكَالٗا%'
      and content like '%لَا تُحْذَفُ إِلَّا نَادِرًا%'
      and content like '%يَقِلُّ دُخُولُهَا%'
  ) then raise exception 'Lesson 4 verb-like particles, predicate positions or protective nun are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1812
      and content like '%أَفْعَلُ الَّذِي مُؤَنَّثُهُ فَعْلَاءُ%'
      and content like '%هَؤُلَاءِ الرِّجَالُ عُرْجٌ%'
      and content like '%هَؤُلَاءِ النِّسَاءُ عُرْجٌ%'
      and content like '%أَبْكَمُ%'
      and content like '%أَعْوَرُ%'
  ) then raise exception 'Lesson 4 أفعل/فعلاء plural rule or all forms are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1813
      and content like '%لَا يَكُونُ إِلَّا لَازِمًا%'
      and content like '%كَسَرْتُ الزُّجَاجَ، فَانْكَسَرَ الزُّجَاجُ%'
      and content like '%مُنْجَلٍ (الْمُنْجَلِي)%'
      and content like '%أَنْفَتَحَ الْبَابُ؟%'
      and content like '%أَنْقَطَعَ الْحَبْلُ؟%'
  ) then raise exception 'Lesson 5 انفعل rule, derivatives, compliance meaning or interrogative hamza are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1814
      and content like '%حَرْفُ امْتِنَاعٍ لِوُجُودٍ%'
      and content like '%الْخَبَرُ مَحْذُوفٌ تَقْدِيرُهُ مَوْجُودٌ%'
      and content like '%لَوْلَا اللَّهُ مَا اهْتَدَيْنَا%'
      and content like '%لَوْلَا أَنَّ الْبَرْدَ شَدِيدٌ%'
      and content like '%لَوْلَا شِدَّةُ الْبَرْدِ%'
  ) then raise exception 'Lesson 5 لولا rule, answers or interpreted masdar example are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1815
      and content like '%لَوْمَا الْعِلْمُ مَا عَرَفْنَا شَيْئًا%'
      and content like '%حَرْفُ امْتِنَاعٍ لِوُجُودٍ مَبْنِيٌّ عَلَى السُّكُونِ%'
      and content like '%اللَّامُ حَرْفُ جَوَابٍ وَرَبْطٍ%'
  ) then raise exception 'Lesson 5 لوما examples or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1816
      and content like '%مَنْ إِبْرَاهِيمُ هَذَا؟%'
      and content like '%أَرِنِي سَاعَتَكَ هَذِهِ%'
      and content like '%فِي مَحَلِّ نَصْبٍ نَعْتٌ%'
  ) then raise exception 'Lesson 5 demonstrative adjective positions or parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1817
      and content like '%أَبْنَائِي وَبَنَاتِي يَدْرُسُونَ%'
      and content like '%النِّسَاءُ وَالرِّجَالُ يُصَلُّونَ%'
      and content like '%الْأَبَوَانِ%'
      and content like '%الْقَمَرَانِ%'
  ) then raise exception 'Lesson 5 predominance rule or author examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1818
      and content like '%مُضَافًا إِلَيْهِ فِي مَحَلِّ جَرٍّ%'
      and content like '%يَوْمَ انْكَسَفَتِ الشَّمْسُ%'
      and content like '%يَوْمَ ظَهَرَتِ النَّتَائِجُ%'
      and content like '%يَوْمَ زَارَ الْوَزِيرُ الْجَامِعَةَ%'
      and content like '%يَوۡمَ نَقُولُ لِجَهَنَّمَ%'
  ) then raise exception 'Lesson 5 adverb annexed to a sentence or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1819
      and content like '%اِجْتَمَعَ ← اِجْتِمَاعٌ%'
      and content like '%رَفَعْتُ الصَّوْتَ، فَارْتَفَعَ الصَّوْتُ%'
      and content like '%مَلَأْتُ الْكُوبَ، فَامْتَلَأَ الْكُوبُ%'
      and content like '%مُنْتَهٍ (الْمُنْتَهِي)%'
      and content like '%مُمْتَحَنٌ%'
  ) then raise exception 'Lesson 6 افتعل meanings, masdars or derivatives are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1820
      and content like '%دَالٌ، ذَالٌ، زَايٌ%'
      and content like '%صَادٌ، ضَادٌ، طَاءٌ، ظَاءٌ%'
      and content like '%وَصَلَ ← اِتَّصَلَ%'
      and content like '%أَخَذَ ← اِتَّخَذَ%'
  ) then raise exception 'Lesson 6 all four substitution cases or author examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1821
      and content like '%حُدُوثُ أَمْرٍ غَيْرِ مُتَوَقَّعٍ%'
      and content like '%خَرَجْتُ فَإِذَا أَسَدٌ بِالْبَابِ%'
      and content like '%فَأَلۡقَىٰهَا فَإِذَا هِيَ حَيَّةٞ تَسۡعَىٰ%'
      and content like '%الْفَاءُ: حَرْفٌ زَائِدٌ لِلتَّوْكِيدِ%'
      and content like '%تَسْعَى: الْجُمْلَةُ الْفِعْلِيَّةُ فِي مَحَلِّ رَفْعٍ نَعْتٌ%'
  ) then raise exception 'Lesson 6 sudden إذا definition, examples or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1822
      and content like '%سَدَّ مَسَدَّ مَفْعُولَيْ ظَنَّ%'
      and content like '%وَلَٰكِن ظَنَنتُمۡ أَنَّ ٱللَّهَ%'
      and content like '%يَظُنُّ مُحَمَّدٌ الِامْتِحَانَ قَرِيبًا%'
      and content like '%مَا ظَنَنْتُ أَنْ يَرْسُبَ الطَّالِبُ%'
      and content like '%الطَّالِبُ: فَاعِلٌ مَرْفُوعٌ%'
  ) then raise exception 'Lesson 6 ظن two objects, interpreted masdar, verses or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1823
      and content like '%فَعَّالٌ%'
      and content like '%فَعِيلٌ%'
      and content like '%فَعُولٌ%'
      and content like '%مِفْعَالٌ%'
      and content like '%مَزِقٌ%'
  ) then raise exception 'Lesson 6 all five intensive participle forms or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1824
      and content like '%دَخَلْتُ الْغُرْفَةَ%'
      and content like '%دَخَلْتُ الْمَسْجِدَ%'
      and content like '%دَخَلْتُ فِي الِامْتِحَانِ%'
      and content like '%وَدَخَلَ جَنَّتَهُ%'
      and content like '%يَدۡخُلُونَ فِي دِينِ ٱللَّهِ أَفۡوَاجٗا%'
  ) then raise exception 'Lesson 6 دخل transitivity distinction or all author examples are incomplete'; end if;
end;
$assert$;

commit;
