-- Certify the complete Russian rendering of Medina Book 4, lessons 1-3.
-- Controlling source: Sharkh_Medinskiy_4.pdf, PDF pages 2-13.

begin;

create temp table _book4_full_sharh_batch01 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book4_full_sharh_batch01 values
  (1786, '1', 'Полный шарх: с. 2–3'),
  (1787, '1', 'Полный шарх: с. 3–4'),
  (1788, '1', 'Полный шарх: с. 4'),
  (1789, '1', 'Полный шарх: с. 4'),
  (1790, '1', 'Полный шарх: с. 4–5'),
  (1791, '1', 'Полный шарх: с. 5'),
  (1792, '1', 'Полный шарх: с. 5–6'),
  (1793, '1', 'Полный шарх: с. 6'),
  (1794, '1', 'Полный шарх: с. 6'),
  (1795, '2', 'Полный шарх: с. 7'),
  (1796, '2', 'Полный шарх: с. 8'),
  (1797, '2', 'Полный шарх: с. 8–9'),
  (1798, '2', 'Полный шарх: с. 9'),
  (2002, '2', 'Полный шарх: с. 9'),
  (1799, '2', 'Полный шарх: с. 9–10'),
  (1800, '2', 'Полный шарх: с. 10'),
  (1801, '3', 'Полный шарх: с. 10–11'),
  (1802, '3', 'Полный шарх: с. 11–12'),
  (1803, '3', 'Полный шарх: с. 12–13');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch01 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 4)' and r.lesson_number = b.lesson_number;
  if v_count <> 19 then raise exception 'Expected 19 guarded Book 4 rules for lessons 1-3, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join _book4_full_sharh_batch01 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_4.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null and rs.source_page_to is not null;
  if v_count <> 19 then raise exception 'Book 4 lessons 1-3 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book4-full-sharh-batch01"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book4_full_sharh_batch01 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 4)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book4-full-sharh-batch01') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch01 b on b.rule_id = r.id
  where strpos(r.content, 'book4-full-sharh-batch01') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 19 then raise exception 'Book 4 lessons 1-3 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book4_full_sharh_batch01 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id and s.source_document = 'Sharkh_Medinskiy_4.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 4 lesson 1-3 card has no complete source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1786
      and content like '%فَهِمْتُ الدَّرْسَ وَقَرَأْتُ الْكِتَابَ%'
      and content like '%ضَرَبْتُ الْحَيَّةَ وَقَتَلْتُهَا%'
      and content like '%بَكَى الطِّفْلُ وَنَامَ%'
      and content like '%مَذْهُوبٌ إِلَيْهِ%'
      and content like '%مَسِيرٌ وَرَاءَهُ%'
  ) then raise exception 'Lesson 1 transitive/intransitive definitions, signs or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1787
      and content like '%أَبْكَى الرَّجُلُ الطِّفْلَ%'
      and content like '%بَكَّى الرَّجُلُ الطِّفْلَ%'
      and content like '%غَضِبَ اللَّهُ عَلَى الْيَهُودِ%'
      and content like '%مَفْعُولٌ بِهِ غَيْرُ صَرِيحٍ%'
      and content like '%اِطَّلَعَ الْمُدِيرُ عَلَى الْكِتَابِ%'
  ) then raise exception 'Lesson 1 three methods of transitivising, parsing or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1788
      and content like '%التَّعْدِيَةُ%'
      and content like '%التَّكْثِيرُ%'
      and content like '%الْمُبَالَغَةُ%'
      and content like '%كَسَّرْتُ الْأَقْلَامَ%'
      and content like '%كَسَّرْتُ الْقَلَمَ%'
  ) then raise exception 'Lesson 1 three فَعَّلَ meanings or contrasting examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1789
      and content like '%أَرْأَى%'
      and content like '%حُذِفَتِ الْهَمْزَةُ تَخْفِيفًا%'
      and content like '%رَ، رَهْ%'
      and content like '%يُرِي%'
      and content like '%أَرِنِي كِتَابَكَ%'
  ) then raise exception 'Lesson 1 رَأَى/أَرَى origin, forms, control or example are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1790
      and content like '%سَمَاعِيٌّ%'
      and content like '%لَا يُقَاسُ عَلَيْهِ%'
      and content like '%إِنَاءٌ%'
      and content like '%أَسَاوِرُ%'
      and content like '%أَيَادٍ%'
      and content like '%طُرُقَاتٌ%'
      and content like '%أَمَاكِنُ%'
  ) then raise exception 'Lesson 1 plural-of-plural rule or all author examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1791
      and content like '%مَا الزَّائِدَةُ الْكَافَّةُ%'
      and content like '%الْحَصْرُ%'
      and content like '%إِنَّمَا ٱلۡمُؤۡمِنُونَ إِخۡوَةٞ%'
      and content like '%إِنَّمَا يَخۡشَى ٱللَّهَ%'
      and content like '%حَرْفُ نَصْبٍ مُهْمَلٌ%'
      and content like '%مُبْتَدَأٌ مَرْفُوعٌ%'
  ) then raise exception 'Lesson 1 إنما effects, restriction meaning, verses or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1792
      and content like '%تَنْبِيهُ الْمُخَاطَبِ%'
      and content like '%إِيَّاكُمَا وَالْغِيبَةَ%'
      and content like '%إِيَّاكُنَّ وَالتَّبَرُّجَ%'
      and content like '%تَقْدِيرُهُ: أُحَذِّرُ%'
      and content like '%تَقْدِيرُهُ: اِحْذَرْ%'
      and content like '%مَعْطُوفَةٌ عَلَى جُمْلَةِ%'
  ) then raise exception 'Lesson 1 warning construction, forms or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1793
      and content like '%جَوَابُ الْقَسَمِ%'
      and content like '%تَٱللَّهِ لَقَدۡ ءَاثَرَكَ ٱللَّهُ عَلَيۡنَا%'
      and content like '%لَقَدۡ خَلَقۡنَا ٱلۡإِنسَٰنَ%'
      and content like '%وَاللَّهِ لَقَدْ فَرِحْتُ بِنَجَاحِكَ%'
      and content like '%وَاللَّهِ لَقَدْ فَهِمْتُ الدَّرْسَ%'
  ) then raise exception 'Lesson 1 oath-response rule, Quran passages or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1794
      and content like '%فِعْلٌ نَاسِخٌ مِنْ أَخَوَاتِ كَانَ%'
      and content like '%أَمْسَى الْجَوُّ بَارِدًا%'
      and content like '%أَمْسَتِ الْأُمُّ مَرِيضَةً%'
      and content like '%خَبَرُ أَمْسَى%'
  ) then raise exception 'Lesson 1 أمسى rule, control or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1795
      and content like '%مُفَاعَلَةٌ وَفِعَالٌ%'
      and content like '%الْمُشَارَكَةُ%'
      and content like '%سَافَرَ، هَاجَرَ، جَاوَزَ%'
      and content like '%مُصَافَحَةٌ%'
      and content like '%مُنَادًى%'
  ) then raise exception 'Lesson 2 فَاعَلَ additions, masdars, meanings or derivatives are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1796
      and content like '%الِاحْتِمَالُ وَالشَّكُّ%'
      and content like '%التَّقْلِيلُ%'
      and content like '%قَدۡ أَفۡلَحَ ٱلۡمُؤۡمِنُونَ%'
      and content like '%قَدۡ نَعۡلَمُ إِنَّهُۥ لَيَحۡزُنُكَ%'
      and content like '%قَدۡ يَعۡلَمُ ٱللَّهُ ٱلۡمُعَوِّقِينَ%'
  ) then raise exception 'Lesson 2 قد meanings, prose examples or Quran examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1797
      and content like '%بَطَلَ عَمَلُهَا%'
      and content like '%الِاسْتِدْرَاكَ%'
      and content like '%لَٰكِنِ ٱلظَّٰلِمُونَ%'
      and content like '%وَلَٰكِن لَّا تَشۡعُرُونَ%'
      and content like '%حَرْفُ ابْتِدَاءٍ وَاسْتِدْرَاكٍ%'
      and content like '%ابْتِدَائِيَّةٌ لَا مَحَلَّ لَهَا%'
  ) then raise exception 'Lesson 2 lightened لكن rule, examples or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1798
      and content like '%مُلْحَقَتَانِ بِجَمْعِ الْمُذَكَّرِ السَّالِمِ%'
      and content like '%ذَوُو، أُولُو%'
      and content like '%ذَوِي، أُولِي%'
      and content like '%نَحْنُ ذَوُو عِلْمٍ وَأُولُو فَضْلٍ%'
      and content like '%ذَهَبْتُ إِلَى ذَوِي عِلْمٍ%'
  ) then raise exception 'Lesson 2 ذوو/أولو meaning, declension or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 2002
      and content like '%إِفْرَادًا وَتَثْنِيَةً وَجَمْعًا%'
      and content like '%أَلَمۡ أَنۡهَكُمَا عَن تِلۡكُمَا ٱلشَّجَرَةِ%'
      and content like '%فَذَٰلِكُنَّ ٱلَّذِي لُمۡتُنَّنِي فِيهِ%'
      and content like '%أَذَلِكُمُ الْقَلَمُ لَكُمْ يَا إِخْوَانُ%'
      and content like '%أَتِلْكِ الْمَجَلَّةُ لَكِ يَا فَاطِمَةُ%'
  ) then raise exception 'Lesson 2 demonstrative address kaf agreement or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1799
      and content like '%чтобы два усилителя не стояли вместе в начале%'
      and content like '%وَإِنَّكَ لَعَلَىٰ خُلُقٍ عَظِيمٖ%'
      and content like '%إِنَّ فِي ذَٰلِكَ لَعِبۡرَةٗ%'
      and content like '%اللَّامُ الْمُزَحْلَقَةُ%'
      and content like '%خَبَرُ إِنَّ مَرْفُوعٌ%'
  ) then raise exception 'Lesson 2 shifted lam cause, positions, examples or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1800
      and content like '%صِيغَةِ مُنْتَهَى الْجُمُوعِ%'
      and content like '%يُرْجَعُ فِي ذَلِكَ إِلَى الْمَعَاجِمِ%'
      and content like '%بَرْنَامَجٌ%'
      and content like '%سَفَارِجُ%'
      and content like '%عَنَاكِبُ%'
      and content like '%مَشَافٍ%'
  ) then raise exception 'Lesson 2 five-letter plural rule, dictionary note or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1801
      and content like '%حَرْفَا الزِّيَادَةِ%'
      and content like '%الْمُطَاوَعَةُ%'
      and content like '%كَسَّرْتُ الزُّجَاجَ، فَتَكَسَّرَ الزُّجَاجُ%'
      and content like '%عَلَّمْتُ الطَّالِبَ الْقُرْآنَ%'
      and content like '%تَمَنٍّ%'
      and content like '%تَنَزَّلُ ٱلۡمَلَٰٓئِكَةُ%'
      and content like '%وَلَا تَجَسَّسُواْ%'
  ) then raise exception 'Lesson 3 تَفَعَّلَ additions, compliance meaning, derivatives or deletion examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1802
      and content like '%تَتَضَمَّنُ مَعْنَى الشَّرْطِ%'
      and content like '%غَيْرُ جَازِمَةٍ%'
      and content like '%فَلَمَّا رَءَاهُ مُسۡتَقِرًّا%'
      and content like '%لَمَّا وَصَلْتُ الْمَدِينَةَ%'
      and content like '%فِي مَحَلِّ جَرٍّ بِالْإِضَافَةِ%'
      and content like '%لَا مَحَلَّ لَهَا مِنَ الْإِعْرَابِ%'
  ) then raise exception 'Lesson 3 temporal لما rule, examples or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1803
      and content like '%لِفِعْلٍ مَحْذُوفٍ وُجُوبًا%'
      and content like '%مُعَرَّفٌ بِأَلْ%'
      and content like '%مُعَرَّفٌ بِالْإِضَافَةِ%'
      and content like '%نَحْنُ الْمُسْلِمِينَ%'
      and content like '%إِنَّا مَعْشَرَ الْأَنْبِيَاءِ لَا نُورَثُ%'
      and content like '%جُمْلَةُ «نُحِبُّ الْعِلْمَ» فِي مَحَلِّ رَفْعٍ%'
  ) then raise exception 'Lesson 3 specification noun definition, types, hadith or full parsing are incomplete'; end if;
end;
$assert$;

commit;
