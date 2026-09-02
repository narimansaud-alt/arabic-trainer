-- Certify the complete Russian rendering of Medina Book 3, lessons 16-17.
-- Controlling source: Sharkh_Medinskiy_3.pdf, PDF pages 65-73.

begin;

create temp table _book3_full_sharh_batch06 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book3_full_sharh_batch06 values
  (1987, '16', 'Полный шарх: с. 65–66'),
  (1988, '16', 'Полный шарх: с. 66'),
  (1989, '16', 'Полный шарх: с. 66–67'),
  (1990, '16', 'Полный шарх: с. 67'),
  (1991, '16', 'Полный шарх: с. 68'),
  (1992, '16', 'Полный шарх: с. 68'),
  (1993, '17', 'Полный шарх: с. 68–69'),
  (1994, '17', 'Полный шарх: с. 69'),
  (1995, '17', 'Полный шарх: с. 69'),
  (1996, '17', 'Полный шарх: с. 70'),
  (1997, '17', 'Полный шарх: с. 70'),
  (1998, '17', 'Полный шарх: с. 70–71'),
  (1999, '17', 'Полный шарх: с. 71'),
  (2000, '17', 'Полный шарх: с. 71–72'),
  (2001, '17', 'Полный шарх: с. 72–73');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book3_full_sharh_batch06 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 3)' and r.lesson_number = b.lesson_number;
  if v_count <> 15 then raise exception 'Expected 15 guarded Book 3 rules for lessons 16-17, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then raise exception 'Book 3 must retain 89 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then raise exception 'Book 3 must retain 89 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join _book3_full_sharh_batch06 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_3.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null and rs.source_page_to is not null;
  if v_count <> 15 then raise exception 'Book 3 lessons 16-17 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book3-full-sharh-batch06"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book3_full_sharh_batch06 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 3)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book3-full-sharh-batch06') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book3_full_sharh_batch06 b on b.rule_id = r.id
  where strpos(r.content, 'book3-full-sharh-batch06') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 15 then raise exception 'Book 3 lessons 16-17 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book3_full_sharh_batch06 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id and s.source_document = 'Sharkh_Medinskiy_3.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 3 lesson 16-17 card has no complete source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1987
      and content like '%مَا كَانَتْ جَمِيعُ أَحْرُفِهِ أَصْلِيَّةً%'
      and content like '%وَسْوَسَ%'
      and content like '%بَعْثَرَ%'
      and content like '%ثُلَاثِيٌّ مَزِيدٌ%'
      and content like '%سَتَدْرُسُهُ فِي الْجُزْءِ الرَّابِعِ%'
  ) then raise exception 'Lesson 16 simple/derived verb definitions, types, examples or author note are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1988
      and content like '%دَخَلَ: يَدْخُلُ%'
      and content like '%جَلَسَ: يَجْلِسُ%'
      and content like '%ذَهَبَ: يَذْهَبُ%'
      and content like '%شَرِبَ: يَشْرَبُ%'
      and content like '%وَرِثَ: يَرِثُ%'
      and content like '%كَثُرَ: يَكْثُرُ%'
  ) then raise exception 'Lesson 16 six simple triliteral models or author examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1989
      and content like '%مَزِيدٌ بِحَرْفٍ وَاحِدٍ%'
      and content like '%مَزِيدٌ بِحَرْفَيْنِ%'
      and content like '%مَزِيدٌ بِثَلَاثَةِ أَحْرُفٍ%'
      and content like '%بَابُ فَعَّلَ%'
      and content like '%بَابُ أَفْعَلَ%'
      and content like '%بَابُ فَاعَلَ%'
      and content like '%فِي الْجُزْءِ الرَّابِعِ%'
  ) then raise exception 'Lesson 16 derived triliteral divisions, three models or author notes are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1990
      and content like '%تَضْعِيفُ الْعَيْنِ%'
      and content like '%تَحْيِيَةٌ%'
      and content like '%تَحْيِيَةٌ%'
      and content like '%تَوْطِئَةٌ%'
      and content like '%تَجْزِئَةٌ%'
      and content like '%مُسَجَّلٌ%'
      and content like '%مَصْدَرُهُ غَيْرُ مُسْتَعْمَلٍ%'
      and content like '%وَتَصۡلِيَةُ جَحِيمٍ%'
  ) then raise exception 'Lesson 16 فَعَّلَ model, masdars, derivatives or صلاة distinction are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1991
      and content like '%مِيمٌ مَضْمُومَةٌ%'
      and content like '%مَفْتُوحٌ%'
      and content like '%مَكْسُورٌ%'
      and content like '%الْقَرِينَةُ اللَّفْظِيَّةُ أَوِ الْمَعْنَوِيَّةُ%'
      and content like '%هَذَا مُصَلَّى النِّسَاءِ%'
      and content like '%الْقُرْآنُ مُسَجَّلٌ فِي هَذَا الشَّرِيطِ%'
      and content like '%هُنَا مُسَجَّلُ الطُّلَّابِ%'
  ) then raise exception 'Lesson 16 non-triliteral derived names, context rule or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1992
      and content like '%أَحْرُفُ الْمُضَارَعَةِ%'
      and content like '%الْفِعْلِ الرُّبَاعِيِّ%'
      and content like '%تَكُونُ%'
      and content like '%مَضْمُومَةً%'
      and content like '%دَرَّسَ%'
      and content like '%نُكْرِمُ%'
      and content like '%تُزَلْزِلُ%'
  ) then raise exception 'Lesson 16 quadriliteral present-prefix rule or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1993
      and content like '%أَسْلَمَ، أَجَابَ، أَتَمَّ، آمَنَ%'
      and content like '%أَصْلُهُ إِئْمَانٌ%'
      and content like '%إِوْجَادٌ%'
      and content like '%إِجْوَابٌ%'
      and content like '%إِلْقَايٌ%'
      and content like '%قُلِبَتِ الْيَاءُ هَمْزَةً%'
  ) then raise exception 'Lesson 17 أَفْعَلَ masdar, weak-root changes or reasons are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1994
      and content like '%أَكْرَمَ%'
      and content like '%أَقَامَ%'
      and content like '%أَبْكَى%'
      and content like '%أَوْقَفَ%'
      and content like '%أُأَكْرِمُ%'
      and content like '%كَرَاهَةُ اجْتِمَاعِ هَمْزَتَيْنِ%'
      and content like '%حُمِلَ ذَلِكَ عَلَى بَقِيَّةِ التَّصَارِيفِ%'
  ) then raise exception 'Lesson 17 أَفْعَلَ derivatives or present hamza deletion are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1995
      and content like '%مَفْعُولَيْنِ%'
      and content like '%لَيْسَ أَصْلُهُمَا الْمُبْتَدَأَ وَالْخَبَرَ%'
      and content like '%أَعْطَيْتُ حَامِدًا كِتَابًا%'
      and content like '%أَعْطَانِيهِ الْمُدِيرُ%'
      and content like '%مَفْعُولٌ بِهِ أَوَّلٌ%'
      and content like '%مَفْعُولٌ بِهِ ثَانٍ%'
  ) then raise exception 'Lesson 17 أَعْطَى rule, examples or two-object parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1996
      and content like '%أَدْرَكَهُ الصَّبَاحُ وَهُوَ مَرِيضٌ%'
      and content like '%وَأَصۡبَحَ فُؤَادُ أُمِّ مُوسَىٰ فَٰرِغًا%'
      and content like '%قَدْ تَأْتِي%'
      and content like '%بِمَعْنَى%'
      and content like '%صَارَ%'
      and content like '%فَأَصۡبَحۡتُم بِنِعۡمَتِهِۦٓ إِخۡوَٰنٗا%'
      and content like '%صِرْتُمْ إِخْوَانًا%'
  ) then raise exception 'Lesson 17 أصبح meanings, author explanation or Quran examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1997
      and content like '%مِنْ أَفْعَالِ الْمُقَارَبَةِ%'
      and content like '%خَبَرُ أَوْشَكَ لَا يَكُونُ إِلَّا%'
      and content like '%جُمْلَةً فِعْلِيَّةً%'
      and content like '%يُوشِكُ الطُّلَّابُ أَنْ يَتَخَرَّجُوا%'
      and content like '%حَرْفُ نَصْبٍ وَمَصْدَرٍ%'
      and content like '%الْمَصْدَرُ الْمُؤَوَّلُ فِي مَحَلِّ نَصْبٍ خَبَرُ أَوْشَكَ%'
  ) then raise exception 'Lesson 17 أوشك rules, examples or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1998
      and content like '%وَٱللَّهُ مُتِمُّ نُورِهِۦ وَلَوۡ كَرِهَ ٱلۡكَٰفِرُونَ%'
      and content like '%وَاوُ الْحَالِ%'
      and content like '%جَوَابُ الشَّرْطِ%'
      and content like '%جُمْلَةُ الشَّرْطِ فِي مَحَلِّ نَصْبٍ حَالًا%'
      and content like '%صَلِّ وَلَوْ كُنْتَ مَرِيضًا%'
      and content like '%لَنْ أَشْرَبَ الْخَمْرَ وَلَوْ عَذَّبْتَنِي%'
  ) then raise exception 'Lesson 17 ولو verse, full parsing or author examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1999
      and content like '%وَفَائِدَتُهُ%'
      and content like '%التَّوْكِيدُ%'
      and content like '%وَلَأَجۡرُ ٱلۡأٓخِرَةِ أَكۡبَرُ%'
      and content like '%وَلَذِكۡرُ ٱللَّهِ أَكۡبَرُ%'
      and content like '%لَهَذَا طَالِبٌ مُجْتَهِدٌ%'
      and content like '%حَرْفُ ابْتِدَاءٍ مَبْنِيٌّ عَلَى الْفَتْحِ%'
  ) then raise exception 'Lesson 17 initial lam function, examples or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 2000
      and content like '%اِسْمٌ مَبْنِيٌّ عَلَى السُّكُونِ يَقَعُ%'
      and content like '%نَعْتًا لِمَا قَبْلَهُ%'
      and content like '%حَدَثَ شَيْءٌ مَا%'
      and content like '%أَعْطِنِي كِتَابًا مَا%'
      and content like '%رَأَيْتُهُ فِي مَكَانٍ مَا%'
      and content like '%فِي مَحَلِّ جَرٍّ%'
  ) then raise exception 'Lesson 17 indefinite ما definition, examples or three syntactic places are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 2001
      and content like '%صِفَةً بَيْنَ عَلَمَيْنِ%'
      and content like '%فِي سَطْرٍ وَاحِدٍ%'
      and content like '%سَلَّمْتُ عَلَى خَالِدِ بْنِ عَلِيٍّ%'
      and content like '%الْكَلِمَاتُ الثَّلَاثُ%'
      and content like '%حَامِدٌ ٱبْنُ الشَّيْخِ إِبْرَاهِيمَ%'
      and content like '%حُذِفَ تَنْوِينُهُ تَخْفِيفًا%'
      and content like '%صِفَةٌ مَرْفُوعَةٌ%'
  ) then raise exception 'Lesson 17 ابن hamza deletion, exceptions, examples or full parsing are incomplete'; end if;
end;
$assert$;

commit;
