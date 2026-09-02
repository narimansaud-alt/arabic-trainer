-- Certify the complete Russian rendering of Medina Book 3, lessons 1-3.
-- Primary and controlling source: Sharkh_Medinskiy_3.pdf, PDF pages 3-26.
-- Every public card was compared with its complete private source row and with
-- the visually rendered PDF pages. No explanation or author example may be removed.

begin;

create temp table _book3_full_sharh_batch01 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book3_full_sharh_batch01 values
  (1913, '1', 'Полный шарх: с. 3'),
  (1914, '1', 'Полный шарх: с. 4–6'),
  (1915, '1', 'Полный шарх: с. 7–8'),
  (1916, '1', 'Полный шарх: с. 8–9'),
  (1917, '1', 'Полный шарх: с. 9–11'),
  (1918, '1', 'Полный шарх: с. 11'),
  (1919, '1', 'Полный шарх: с. 11–12'),
  (1920, '1', 'Полный шарх: с. 12–13'),
  (1921, '1', 'Полный шарх: с. 13–15'),
  (1922, '1', 'Полный шарх: с. 15–16'),
  (1923, '1', 'Полный шарх: с. 17'),
  (1924, '2', 'Полный шарх: с. 18'),
  (1925, '2', 'Полный шарх: с. 18'),
  (1926, '2', 'Полный шарх: с. 19'),
  (1927, '2', 'Полный шарх: с. 19'),
  (1928, '2', 'Полный шарх: с. 19'),
  (1929, '2', 'Полный шарх: с. 19–20'),
  (1930, '2', 'Полный шарх: с. 20'),
  (1931, '2', 'Полный шарх: с. 21'),
  (1932, '3', 'Полный шарх: с. 22–24'),
  (1933, '3', 'Полный шарх: с. 24'),
  (1934, '3', 'Полный шарх: с. 24–25'),
  (1935, '3', 'Полный шарх: с. 25–26'),
  (1936, '3', 'Полный шарх: с. 26');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r
  join _book3_full_sharh_batch01 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 3)'
    and r.lesson_number = b.lesson_number;
  if v_count <> 24 then
    raise exception 'Expected 24 guarded Book 3 rules for lessons 1-3, found %', v_count;
  end if;

  select count(*) into v_count
  from public.rules
  where course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then
    raise exception 'Book 3 must retain 89 public rules, found %', v_count;
  end if;

  select count(*) into v_count
  from public.rule_sources rs
  join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then
    raise exception 'Book 3 must retain 89 complete source rows, found %', v_count;
  end if;

  select count(*) into v_count
  from public.rule_sources rs
  join _book3_full_sharh_batch01 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_3.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null
    and rs.source_page_to is not null;
  if v_count <> 24 then
    raise exception 'Book 3 lessons 1-3 must retain 24 complete PDF source rows, found %', v_count;
  end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book3-full-sharh-batch01"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book3_full_sharh_batch01 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 3)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book3-full-sharh-batch01') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r
  join _book3_full_sharh_batch01 b on b.rule_id = r.id
  where strpos(r.content, 'book3-full-sharh-batch01') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 24 then
    raise exception 'Book 3 lessons 1-3 full-sharh cards or markers are incomplete: %', v_count;
  end if;

  if exists (
    select 1
    from _book3_full_sharh_batch01 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id
        and s.source_document = 'Sharkh_Medinskiy_3.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then
    raise exception 'A completed Book 3 lesson 1-3 card has no complete source row';
  end if;

  if not exists (
    select 1 from public.rules where id = 1913
      and content like '%جَاءَ الْمُدَرِّسُ%'
      and content like '%سَلَّمْتُ عَلَى هَؤُلَاءِ%'
      and content like '%فِي مَحَلِّ رَفْعٍ، فِي مَحَلِّ نَصْبٍ، فِي مَحَلِّ جَرٍّ%'
  ) then raise exception 'Lesson 1 mutable and built noun explanation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1914
      and content like '%هَذَانِ، هَاتَانِ%'
      and content like '%اللَّذَانِ، اللَّتَانِ%'
      and content like '%اثْنَا عَشَرَ%'
      and content like '%هَيْهَاتَ، شَتَّانَ%'
      and content like '%آمِينَ، صَهْ%'
  ) then raise exception 'Lesson 1 eight built-noun groups or exceptions are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1915
      and content like '%الْكَسْرَةُ عَلَامَةُ نَصْبٍ%'
      and content like '%الْفَتْحَةُ عَلَامَةُ جَرٍّ%'
      and content like '%أَنْ تَكُونَ مُضَافَةً إِلَى غَيْرِ يَاءِ الْمُتَكَلِّمِ%'
      and content like '%هَذَا أُبَيٌّ وَأُخَيٌّ%'
  ) then raise exception 'Lesson 1 noun irab signs or five-noun conditions are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1916
      and content like '%الْإِعْرَابُ الظَّاهِرُ%'
      and content like '%الْإِعْرَابُ الْمَحَلِّيُّ%'
      and content like '%وَأَنْ تَصُومُوا خَيْرٌ لَكُمْ%'
      and content like '%الطَّالِبُ فِي الْفَصْلِ%'
  ) then raise exception 'Lesson 1 visible, local and estimated irab explanation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1917
      and content like '%الاِسْمُ الْمَقْصُورُ%'
      and content like '%الاِسْمُ الْمَنْقُوصُ%'
      and content like '%اشْتِغَالُ الْمَحَلِّ بِحَرَكَةِ الْمُنَاسَبَةِ%'
      and content like '%الْقَاضِي، قَاضِي مَكَّةَ، رَأَيْتُ قَاضِيًا%'
  ) then raise exception 'Lesson 1 estimated noun irab reasons and exceptions are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1918
      and content like '%اسْمُ كَادَ وَأَخَوَاتِهَا%'
      and content like '%خَبَرُ لَا النَّافِيَةِ لِلْجِنْسِ%'
      and content like '%نَائِبُ الْفَاعِلِ%'
  ) then raise exception 'Lesson 1 marfu noun positions are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1919
      and content like '%الْمُضَافُ إِلَيْهِ%'
      and content like '%الْبَدَلُ مِنَ الْمَجْرُورِ%'
      and content like '%تَوْكِيدُ الْمَجْرُورِ%'
  ) then raise exception 'Lesson 1 majrur noun positions are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1920
      and content like '%الْمَفْعُولُ لِأَجْلِهِ%'
      and content like '%الْمَفْعُولُ مَعَهُ%'
      and content like '%الْمَفْعُولُ الْمُطْلَقُ%'
      and content like '%الْمُسْتَثْنَى%'
      and content like '%الْمُنَادَى%'
  ) then raise exception 'Lesson 1 mansub noun positions are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1921
      and content like '%نَعْتٌ سَبَبِيٌّ%'
      and content like '%تَوْكِيدٌ لَفْظِيٌّ%'
      and content like '%عَطْفُ الْبَيَانِ%'
      and content like '%بَدَلُ بَعْضٍ مِنْ كُلٍّ%'
      and content like '%بَدَلُ اشْتِمَالٍ%'
      and content like '%بَدَلُ غَلَطٍ%'
  ) then raise exception 'Lesson 1 four تابع categories and their divisions are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1922
      and content like '%نُونِ التَّوْكِيدِ%'
      and content like '%نُونِ النِّسْوَةِ%'
      and content like '%ثُبُوتُ النُّونِ%'
      and content like '%حَذْفُ النُّونِ%'
      and content like '%حَذْفُ حَرْفِ الْعِلَّةِ%'
  ) then raise exception 'Lesson 1 verb building and irab sign tables are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1923
      and content like '%يَمْشِي، يَدْعُو، يَنْسَى%'
      and content like '%لَنْ أَدْعُوَ. لَنْ أَمْشِيَ%'
      and content like '%لَمْ أَحُجَّ؛ وَالْأَصْلُ: لَمْ أَحْجُجْ%'
  ) then raise exception 'Lesson 1 estimated verb irab explanation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1924
      and content like '%جَاءَ الْمُدَرِّسُ وَهُوَ يَضْحَكُ%'
      and content like '%دَخَلْتُ الْمَسْجِدَ%'
      and content like '%يُصَلُّونَ%'
      and content like '%وَصَلْتُ مَكَّةَ وَقَدْ غَرَبَتِ الشَّمْسُ%'
  ) then raise exception 'Lesson 2 waw al-hal definition or author examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1925
      and content like '%التَّرَجِّي%'
      and content like '%الْإِشْفَاقُ%'
      and content like '%لَعَلِّي لَا أَحُجُّ بَعْدَ عَامِي هَذَا%'
  ) then raise exception 'Lesson 2 لعل meanings or author quotation are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1926
      and content like '%يَنُوبُ عَنْ خُذُوا%'
      and content like '%إِلَيْكُمْ أَمْثِلَةً أُخْرَى%'
      and content like '%مَفْعُولٌ بِهِ مَنْصُوبٌ%'
  ) then raise exception 'Lesson 2 إليكم meaning, governance or parsing is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1927
      and content like '%أَلِفُ التَّأْنِيثِ الْمَمْدُودَةُ%'
      and content like '%أَشْيِئَاءُ%'
      and content like '%حُذِفَتِ الْهَمْزَةُ تَخْفِيفًا%'
      and content like '%أَفْعِلَاءُ%'
  ) then raise exception 'Lesson 2 أشياء derivation is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1928
      and content like '%مَاضٍ لَفْظًا، وَلَكِنَّهُ مُسْتَقْبَلٌ مَعْنًى%'
      and content like '%شَفَاهُ اللَّهُ%'
      and content like '%لَا شَفَاهُ اللَّهُ%'
  ) then raise exception 'Lesson 2 past verb used for supplication is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1929
      and content like '%مِنْ الزَّائِدَةُ تُفِيدُ النَّصَّ عَلَى الْعُمُومِ%'
      and content like '%مَا جَآءَنَا مِنۢ بَشِيرٖ%'
      and content like '%لَا تَظْلِمْ أَحَدًا%'
      and content like '%هَلْ سُؤَالٌ عِنْدَكُمْ%'
  ) then raise exception 'Lesson 2 زائد من conditions, meaning or roles are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1930
      and content like '%وَجَدْتُ الْقَلَمَ لَدَى زَيْدٍ%'
      and content like '%تُقْلَبُ الْأَلِفُ يَاءً%'
      and content like '%وَلَدَيۡنَا كِتَٰبٞ يَنطِقُ بِٱلۡحَقِّ%'
      and content like '%شِبْهُ الْجُمْلَةِ لَدَيَّ%'
  ) then raise exception 'Lesson 2 لدى rule, Quran example or full parsing is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1931
      and content like '%مَفَاعِلُ%'
      and content like '%فَوَاعِلُ%'
      and content like '%فَيَاعِلُ%'
      and content like '%فَعَائِلُ%'
      and content like '%مَفَاعِيلُ%'
      and content like '%عِشْتُ لَيَالِيَ سَعِيدَةً%'
  ) then raise exception 'Lesson 2 ultimate-plural patterns or manqus examples are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1932
      and content like '%فَهِمَ الطَّالِبُ الدَّرْسَ%'
      and content like '%اُسْتُقْبِلَ%'
      and content like '%يُوعَدُ%'
      and content like '%ذُهِبَ إِلَيْهِ%'
      and content like '%سُئِلْتُنَّ%'
      and content like '%ظُنَّ الْمُدَرِّسُ غَائِبًا%'
  ) then raise exception 'Lesson 3 passive formation, forms or نائب فاعل cases are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1933
      and content like '%نَبَوِيٌّ%'
      and content like '%أَخَوِيٌّ%'
      and content like '%أَبَوِيٌّ%'
      and content like '%تُحْذَفُ الْيَاءُ%'
  ) then raise exception 'Lesson 3 nisba formation and exceptions are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1934
      and content like '%التَّفْصِيلُ%'
      and content like '%الشَّكُّ%'
      and content like '%التَّخْيِيرُ%'
      and content like '%الْإِبَاحَةُ%'
      and content like '%الْإِبْهَامُ%'
      and content like '%حَرْفُ تَفْصِيلٍ%'
  ) then raise exception 'Lesson 3 five meanings and parsing of إما are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1935
      and content like '%ثَلَاثُمِائَةٌ%'
      and content like '%تِسْعُمِائَةٌ%'
      and content like '%مَجْرُورَةٌ دَائِمًا بِالْإِضَافَةِ%'
      and content like '%أُرِيدُ أَرْبَعَمِائَةِ رِيَالٍ%'
  ) then raise exception 'Lesson 3 hundreds rule or full parsing is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1936
      and content like '%رُومٌ%'
      and content like '%عَرَبِيٌّ%'
      and content like '%سَمَكَةٌ%'
      and content like '%بَقَرَةٌ%'
      and content like '%حَبَّةٌ%'
  ) then raise exception 'Lesson 3 collective generic nouns and both singular markers are incomplete'; end if;
end;
$assert$;

commit;
