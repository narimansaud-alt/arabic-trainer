-- Certify the complete Russian rendering of Medina Book 3, lessons 13-15.
-- Controlling source: Sharkh_Medinskiy_3.pdf, PDF pages 52-65.

begin;

create temp table _book3_full_sharh_batch05 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book3_full_sharh_batch05 values
  (1973, '13', 'Полный шарх: с. 52–53'),
  (1974, '13', 'Полный шарх: с. 53'),
  (1975, '13', 'Полный шарх: с. 54'),
  (1976, '13', 'Полный шарх: с. 54'),
  (1977, '14', 'Полный шарх: с. 55–56'),
  (1978, '14', 'Полный шарх: с. 56–59'),
  (1979, '14', 'Полный шарх: с. 59'),
  (1980, '15', 'Полный шарх: с. 60'),
  (1981, '15', 'Полный шарх: с. 61'),
  (1982, '15', 'Полный шарх: с. 61–62'),
  (1983, '15', 'Полный шарх: с. 62–63'),
  (1984, '15', 'Полный шарх: с. 63'),
  (1985, '15', 'Полный шарх: с. 63–64'),
  (1986, '15', 'Полный шарх: с. 64–65');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book3_full_sharh_batch05 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 3)' and r.lesson_number = b.lesson_number;
  if v_count <> 14 then raise exception 'Expected 14 guarded Book 3 rules for lessons 13-15, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then raise exception 'Book 3 must retain 89 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then raise exception 'Book 3 must retain 89 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join _book3_full_sharh_batch05 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_3.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null and rs.source_page_to is not null;
  if v_count <> 14 then raise exception 'Book 3 lessons 13-15 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book3-full-sharh-batch05"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book3_full_sharh_batch05 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 3)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book3-full-sharh-batch05') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book3_full_sharh_batch05 b on b.rule_id = r.id
  where strpos(r.content, 'book3-full-sharh-batch05') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 14 then raise exception 'Book 3 lessons 13-15 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book3_full_sharh_batch05 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id and s.source_document = 'Sharkh_Medinskiy_3.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 3 lesson 13-15 card has no complete source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1973
      and content like '%لَمۡ يَلِدۡ وَلَمۡ يُولَدۡ%'
      and content like '%وَلَمَّا يَدۡخُلِ ٱلۡإِيمَٰنُ فِي قُلُوبِكُمۡ%'
      and content like '%لَا يَرْفَعْ أَحَدٌ صَوْتَهُ%'
      and content like '%لَا تَدْخُلُ عَلَى الْمُتَكَلِّمِ%'
      and content like '%ثُمَّ لْيَكْتُبْهُ%'
  ) then raise exception 'Lesson 13 four one-verb jussive particles, restrictions or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1974
      and content like '%اِجْتَهِدْ تَنْجَحْ%'
      and content like '%لَا تُشْرِكْ بِاللَّهِ تَدْخُلِ الْجَنَّةَ%'
      and content like '%ٱدۡعُونِيٓ أَسۡتَجِبۡ لَكُمۡ%'
      and content like '%فِعْلٌ مُضَارِعٌ مَجْزُومٌ بِالطَّلَبِ%'
      and content like '%الْفَاعِلُ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ أَنْتَ%'
  ) then raise exception 'Lesson 13 jussive response to request, examples or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1975
      and content like '%وَامُعْتَصِمَاهْ%'
      and content like '%وَابَطْنَاهْ%'
      and content like '%حَرْفُ سَكْتٍ مَبْنِيٌّ عَلَى السُّكُونِ%'
      and content like '%الْأَصْلُ: رَأْسِي%'
      and content like '%حُذِفَتْ يَاءُ الْمُتَكَلِّمِ%'
  ) then raise exception 'Lesson 13 nudba meanings, examples, origin or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1976
      and content like '%بِمَعْنَى %'
      and content like '%أَتَوَجَّعُ%'
      and content like '%مِنْ مَرَضٍ مُعَيَّنٍ%'
      and content like '%مِنْ كُلِّ شَيْءٍ%'
      and content like '%تَنْوِينَ تَنْكِيرٍ%'
  ) then raise exception 'Lesson 13 آه forms, meanings or tanwin name are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1977
      and content like '%إِذَا جَاءَ رَمَضَانُ فُتِحَتْ أَبْوَابُ الْجَنَّةِ%'
      and content like '%تُحَوِّلُ مَعْنَاهُ إِلَى الْمُسْتَقْبَلِ%'
      and content like '%وَالنَّفْسُ رَاغِبَةٌ إِذَا رَغَّبْتَهَا%'
      and content like '%تُرَدُّ: مُضَارِعٌ مَرْفُوعٌ%'
      and content like '%تَقْنَعُ: مُضَارِعٌ مَرْفُوعٌ%'
  ) then raise exception 'Lesson 14 conditional إذا properties, prose or poetic examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1978
      and content like '%فِي ثَمَانِيَةِ مَوَاضِعَ%'
      and content like '%لَيْسَ، عَسَى، نِعْمَ، بِئْسَ%'
      and content like '%مَسْبُوقٌ بِكَأَنَّمَا%'
      and content like '%لَا يُجْزَمُ جَوَابُ الشَّرْطِ إِذَا اقْتَرَنَ بِالْفَاءِ%'
      and content like '%جُمْلَةُ جَوَابِ الشَّرْطِ لَا مَحَلَّ لَهَا مِنَ الْإِعْرَابِ%'
      and content like '%جَوَابُ الشَّرْطِ مِنَ الْمُبْتَدَأِ وَالْخَبَرِ فِي مَحَلِّ جَزْمٍ%'
      and content like '%حَرْفُ وِقَايَةٍ مَبْنِيٌّ عَلَى الْكَسْرِ%'
      and content like '%جُمْلَةُ جَوَابِ الشَّرْطِ فِي مَحَلِّ جَزْمٍ%'
  ) then raise exception 'Lesson 14 eight fa cases, distinction or three complete parsing blocks are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1979
      and content like '%مَكَّةُ%'
      and content like '%مَكِّيٌّ%'
      and content like '%مَدْرَسَةٌ%'
      and content like '%مَدْرَسِيٌّ%'
      and content like '%وَرْدِيٌّ%'
  ) then raise exception 'Lesson 14 nisba after feminine ta rule or examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1980
      and content like '%إِذْمَا تَقُمْ أَقُمْ%'
      and content like '%مَهْمَا تَقْرَأْ أَقْرَأْ%'
      and content like '%تَتَّصِلُ بِهَا كَثِيرًا مَا الزَّائِدَةُ لِلتَّوْكِيدِ%'
      and content like '%لَا تَجْزِمُ إِلَّا إِذَا اتَّصَلَتْ بِهَا مَا الزَّائِدَةُ%'
      and content like '%أَسْمَاءُ الشَّرْطِ كُلُّهَا %'
      and content like '%مَبْنِيَّةٌ%'
      and content like '%مَا عَدَا %'
      and content like '%أَيًّا%'
  ) then raise exception 'Lesson 15 conditional tools table, notes or declinable أي are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1981
      and content like '%مَتَى تَأْتِ نَأْتِ%'
      and content like '%مَنِ ٱجْتَهَدَ نَجَحَ%'
      and content like '%مَنْ قَالَ الْحَقَّ يَنْجُ%'
      and content like '%مَنْ يَقُمْ لَيْلَةَ الْقَدْرِ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ%'
  ) then raise exception 'Lesson 15 four condition/answer tense combinations are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1982
      and content like '%يُسْتَفْهَمُ بِهَا عَنْ عَدَدٍ مُبْهَمٍ يُرَادُ تَعْيِينُهُ%'
      and content like '%تُخْبِرُ عَنْ عَدَدٍ كَثِيرٍ مُبْهَمٍ%'
      and content like '%كِلْتَاهُمَا لَهُ الصَّدَارَةُ%'
      and content like '%تَمْيِيزُهَا مُفْرَدٌ وَجَمْعٌ، وَالْإِفْرَادُ أَكْثَرُ%'
      and content like '%اِسْمٌ مَجْرُورٌ بِمِنْ مُقَدَّرَةٍ، وَقِيلَ مَجْرُورٌ بِالْإِضَافَةِ%'
  ) then raise exception 'Lesson 15 interrogative/reporting كم definitions, agreement or differences are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1983
      and content like '%انْتِهَاءُ الْغَايَةِ%'
      and content like '%التَّعْلِيلُ%'
      and content like '%لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ%'
      and content like '%أَنْ مُضْمَرَةٌ وُجُوبًا%'
      and content like '%الْمَصْدَرُ الْمُؤَوَّلُ%'
  ) then raise exception 'Lesson 15 حتى meanings, hadith, hidden أن or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1984
      and content like '%هَاؤُمَا%'
      and content like '%هَاؤُنَّ%'
      and content like '%الْمِيمُ فِي الْآيَةِ حُرِّكَتْ بِالضَّمِّ%'
      and content like '%هَاءَ الْكِتَابَ%'
      and content like '%هَاؤُمْ إِعْلَانًا%'
  ) then raise exception 'Lesson 15 ها forms, Quran note or both complete parsing examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1985
      and content like '%وَلَمۡ أَكُ بَغِيّٗا%'
      and content like '%يَمْتَنِعُ حَذْفُ النُّونِ فِي حَالَتَيْنِ%'
      and content like '%لَمْ يَكُنِ الرَّجُلُ قَائِمًا%'
      and content like '%إِنْ يَكُنْهُ فَلَنْ تُسَلَّطَ عَلَيْهِ%'
      and content like '%السُّكُونُ عَلَى النُّونِ الْمَحْذُوفَةِ%'
  ) then raise exception 'Lesson 15 يكن nun deletion, prohibitions, examples or parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1986
      and content like '%فُعَيْلٌ%'
      and content like '%فُعَيْعِلٌ%'
      and content like '%فُعَيْعِيلٌ%'
      and content like '%مِفْتَاحٌ: مُفَيْتِيحٌ%'
      and content like '%زِيَادَةِ يَاءٍ سَاكِنَةٍ بَعْدَ الْحَرْفِ الثَّانِي الْمَفْتُوحِ%'
      and content like '%يَاءَ التَّصْغِيرِ%'
  ) then raise exception 'Lesson 15 diminutive weights, all examples or construction rule are incomplete'; end if;
end;
$assert$;

commit;
