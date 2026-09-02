-- Certify the complete Russian rendering of Medina Book 3, lessons 10-12.
-- Controlling source: Sharkh_Medinskiy_3.pdf, PDF pages 41-52.

begin;

create temp table _book3_full_sharh_batch04 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book3_full_sharh_batch04 values
  (1957, '10', 'Полный шарх: с. 41–42'),
  (1958, '10', 'Полный шарх: с. 42'),
  (1959, '10', 'Полный шарх: с. 42–43'),
  (1960, '10', 'Полный шарх: с. 43'),
  (1961, '11', 'Полный шарх: с. 43–44'),
  (1962, '11', 'Полный шарх: с. 44'),
  (1963, '11', 'Полный шарх: с. 44–45'),
  (1964, '11', 'Полный шарх: с. 46'),
  (1965, '11', 'Полный шарх: с. 46'),
  (1966, '11', 'Полный шарх: с. 46–48'),
  (1967, '11', 'Полный шарх: с. 48'),
  (1968, '12', 'Полный шарх: с. 48–49'),
  (1969, '12', 'Полный шарх: с. 49'),
  (1970, '12', 'Полный шарх: с. 49–50'),
  (1971, '12', 'Полный шарх: с. 51'),
  (1972, '12', 'Полный шарх: с. 51–52');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book3_full_sharh_batch04 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 3)' and r.lesson_number = b.lesson_number;
  if v_count <> 16 then raise exception 'Expected 16 guarded Book 3 rules for lessons 10-12, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then raise exception 'Book 3 must retain 89 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then raise exception 'Book 3 must retain 89 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join _book3_full_sharh_batch04 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_3.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null and rs.source_page_to is not null;
  if v_count <> 16 then raise exception 'Book 3 lessons 10-12 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book3-full-sharh-batch04"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book3_full_sharh_batch04 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 3)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book3-full-sharh-batch04') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book3_full_sharh_batch04 b on b.rule_id = r.id
  where strpos(r.content, 'book3-full-sharh-batch04') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 16 then raise exception 'Book 3 lessons 10-12 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book3_full_sharh_batch04 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id and s.source_document = 'Sharkh_Medinskiy_3.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 3 lesson 10-12 card has no complete source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1957
      and content like '%صِيَامُكُمْ خَيْرٌ لَكُمْ%'
      and content like '%بَقَاؤُكَ أَحْسَنُ لَكَ%'
      and content like '%إِنَّ وَأَخَوَاتُهَا%'
      and content like '%كَأَنَّ الْكِتَابَ مُدَرِّسٌ%'
  ) then raise exception 'Lesson 10 nominal-sentence categories or interpreted-masdar examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1958
      and content like '%يَكْتَفِي بِفَاعِلِهِ وَيَتِمُّ بِهِ الْمَعْنَى%'
      and content like '%لَا يَكْتَفِي بِمَرْفُوعِهِ وَيَحْتَاجُ إِلَى مَنْصُوبٍ%'
      and content like '%طَلَعَتِ الشَّمْسُ%'
      and content like '%كَادَ الطِّفْلُ يَسْقُطُ%'
  ) then raise exception 'Lesson 10 complete/defective verb definitions or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1959
      and content like '%أَنْشَأَ%'
      and content like '%لَا يَقْتَرِنُ بِأَنْ الْمَصْدَرِيَّةِ مُطْلَقًا%'
      and content like '%جَعَلَ الْمُدَرِّسُ يَشْرَحُ الدَّرْسَ%'
      and content like '%شَرَعَتِ الْأُمُّ تُعِدُّ الطَّعَامَ%'
      and content like '%الْجُمْلَةُ الْفِعْلِيَّةُ مِنَ الْفِعْلِ وَالْفَاعِلِ فِي مَحَلِّ نَصْبٍ خَبَرُ أَخَذَ%'
  ) then raise exception 'Lesson 10 inception verbs, restriction, examples or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1960
      and content like '%عَسَى الطَّالِبُ أَنْ يَنْجَحَ%'
      and content like '%اِخْلَوْلَقَتِ السَّمَاءُ أَنْ تُمْطِرَ%'
      and content like '%يَكْثُرُ اقْتِرَانُ خَبَرِ أَوْشَكَ وَعَسَى وَاخْلَوْلَقَ%'
      and content like '%سَنَدْرُسُ الْفِعْلَ أَوْشَكَ فِي الدَّرْسِ السَّابِعَ عَشَرَ%'
  ) then raise exception 'Lesson 10 approach/hope verbs or author lesson-17 note are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1961
      and content like '%نَتَحَدَّثُ عَنِ الْكِتَابِ%'
      and content like '%اللَّهُ رَبُّنَا%'
      and content like '%كِتَابَتُكَ الدَّرْسَ أَفْضَلُ مِنَ اللَّعِبِ%'
      and content like '%وَأَن تَعۡفُوٓاْ أَقۡرَبُ لِلتَّقۡوَىٰ%'
  ) then raise exception 'Lesson 11 mubtada/khabar definitions, benefit or masdar examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1962
      and content like '%مِفْتَاحُ الْجَنَّةِ الصَّلَاةُ%'
      and content like '%فَوْقَ الشَّجَرَةِ عُصْفُورٌ%'
      and content like '%كَمْ طَالِبًا فِي الْفَصْلِ%'
      and content like '%مَا وَمَنْ وَكَمْ فِي مَحَلِّ رَفْعٍ مُبْتَدَأٌ%'
  ) then raise exception 'Lesson 11 definite/indefinite mubtada conditions or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1963
      and content like '%لِأَسْمَاءِ الِاسْتِفْهَامِ حَقُّ الصَّدَارَةِ%'
      and content like '%وَلَدَيۡنَا مَزِيدٞ%'
      and content like '%وَعَلَىٰٓ أَبۡصَٰرِهِمۡ غِشَٰوَةٞ%'
      and content like '%لِأَنَّهُ نَكِرَةٌ وَمَا بَعْدَهُ مَعْرِفَةٌ%'
      and content like '%أَمُسَافِرٌ أَخُوكَ%'
  ) then raise exception 'Lesson 11 mubtada/khabar order rules, reasons or Quran examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1964
      and content like '%أَنَا بِخَيْرٍ%'
      and content like '%اسْمِي حَامِدٌ%'
      and content like '%عِنْدِي كِتَابَانِ%'
      and content like '%أَنَا فَاهِمٌ%'
      and content like '%نَعَمْ، أَنَا طَالِبٌ%'
  ) then raise exception 'Lesson 11 omitted mubtada/khabar cases are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1965
      and content like '%الْمَقْصُودُ بِالْخَبَرِ الْمُفْرَدِ مَا لَيْسَ جُمْلَةً وَلَا شِبْهَ جُمْلَةٍ%'
      and content like '%النِّيَّةُ مَحَلُّهَا الْقَلْبُ%'
      and content like '%يُشْتَرَطُ فِي الْخَبَرِ الْجُمْلَةِ أَنْ يَشْتَمِلَ عَلَى ضَمِيرٍ يَعُودُ إِلَى الْمُبْتَدَأِ%'
      and content like '%الْجَنَّةُ تَحْتَ ظِلَالِ السُّيُوفِ%'
  ) then raise exception 'Lesson 11 three khabar types, pronoun condition or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1966
      and content like '%الطَّالِبُ مُجْتَهِدٌ%'
      and content like '%الْمُدِيرُ مَا اسْمُهُ%'
      and content like '%الْجُمْلَةُ الْفِعْلِيَّةُ فِي مَحَلِّ رَفْعٍ خَبَرُ الْمُبْتَدَأِ%'
      and content like '%اللَّامُ حَرْفُ جَرٍّ مَبْنِيٌّ عَلَى الْكَسْرِ%'
      and content like '%الظَّرْفُ مَعَ مَجْرُورِهِ فِي مَحَلِّ رَفْعٍ خَبَرُ الْمُبْتَدَأِ%'
  ) then raise exception 'Lesson 11 five full mubtada/khabar parsing examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1967
      and content like '%الطَّالِبَانِ جَالِسَانِ%'
      and content like '%الطَّالِبَاتُ مُتَحَجِّبَاتٌ%'
      and content like '%حَامِدٌ مُهَنْدِسٌ%'
      and content like '%فَاطِمَةُ طَبِيبَةٌ%'
  ) then raise exception 'Lesson 11 khabar agreement in number or gender is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1968
      and content like '%وَجَآءُوٓ أَبَاهُمۡ عِشَآءٗ يَبۡكُونَ%'
      and content like '%وَبَنَيۡنَا فَوۡقَكُمۡ سَبۡعٗا شِدَادٗا%'
      and content like '%مَشَيْتُ مِيلًا%'
      and content like '%إِذَا لَمْ تُقَدَّرْ%'
      and content like '%لَا يُعْرَبُ الِاسْمُ ظَرْفًا%'
      and content like '%سَافَرْتُ فِي اللَّيْلِ%'
  ) then raise exception 'Lesson 12 maf-ul-fihi definitions, examples or exclusion are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1969
      and content like '%مَتَى%'
      and content like '%أَمْسِ%'
      and content like '%أَيَّانَ%'
      and content like '%بَيْنَمَا%'
      and content like '%أَيْنَ%'
      and content like '%هُنَاكَ%'
      and content like '%ثَمَّ%'
  ) then raise exception 'Lesson 12 inflected/built ظرف lists are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1970
      and content like '%سَافَرْنَا كُلَّ النَّهَارِ%'
      and content like '%جَلَسْتُ طَوِيلًا مِنَ الْوَقْتِ%'
      and content like '%سَافَرْتُ ذَلِكَ الْيَوْمَ%'
      and content like '%سِرْتُ ثَلَاثَةَ أَمْيَالٍ%'
      and content like '%ٱسْمُ إِشَارَةٍ مَبْنِيٌّ عَلَى الْفَتْحِ فِي مَحَلِّ نَصْبٍ مَفْعُولٌ فِيهِ%'
  ) then raise exception 'Lesson 12 نائب عن الظرف categories, examples or parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1971
      and content like '%جِئْتُ مِنْ قَبْلِ الْعِيدِ وَمِنْ بَعْدِهِ%'
      and content like '%لِلَّهِ ٱلۡأَمۡرُ مِن قَبۡلُ وَمِنۢ بَعۡدُ%'
      and content like '%حُذِفَ الْمُضَافُ إِلَيْهِ، وَهُوَ %'
      and content like '%الْغَلَبَةُ%'
      and content like '%جِئْتُ قَبْلُ وَبَعْدُ%'
  ) then raise exception 'Lesson 12 قبل/بعد declension, verse or omitted word explanation are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1972
      and content like '%تَقْيِيدُ الشَّرْطِيَّةِ بِالزَّمَنِ الْمَاضِي%'
      and content like '%امْتِنَاعُ الْجَوَابِ لِامْتِنَاعِ الشَّرْطِ%'
      and content like '%لَوۡ نَشَآءُ لَجَعَلۡنَٰهُ حُطَٰمٗا%'
      and content like '%لَوۡ نَشَآءُ جَعَلۡنَٰهُ أُجَاجٗا%'
      and content like '%حَرْفُ جَوَابٍ وَرَبْطٍ مَبْنِيٌّ عَلَى الْفَتْحِ%'
  ) then raise exception 'Lesson 12 لو meanings, جواب forms, verses or parsing are incomplete'; end if;
end;
$assert$;

commit;
