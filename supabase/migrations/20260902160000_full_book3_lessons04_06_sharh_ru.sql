-- Certify the complete Russian rendering of Medina Book 3, lessons 4-6.
-- Controlling source: Sharkh_Medinskiy_3.pdf, PDF pages 27-33.

begin;

create temp table _book3_full_sharh_batch02 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book3_full_sharh_batch02 values
  (1937, '4', 'Полный шарх: с. 27–28'),
  (1938, '5', 'Полный шарх: с. 29–30'),
  (1939, '5', 'Полный шарх: с. 30–31'),
  (1940, '6', 'Полный шарх: с. 31–33');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r
  join _book3_full_sharh_batch02 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 3)'
    and r.lesson_number = b.lesson_number;
  if v_count <> 4 then
    raise exception 'Expected 4 guarded Book 3 rules for lessons 4-6, found %', v_count;
  end if;

  select count(*) into v_count from public.rules
  where course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then raise exception 'Book 3 must retain 89 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs
  join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 3)';
  if v_count <> 89 then raise exception 'Book 3 must retain 89 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs
  join _book3_full_sharh_batch02 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_3.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null
    and rs.source_page_to is not null;
  if v_count <> 4 then raise exception 'Book 3 lessons 4-6 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book3-full-sharh-batch02"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book3_full_sharh_batch02 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 3)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book3-full-sharh-batch02') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r
  join _book3_full_sharh_batch02 b on b.rule_id = r.id
  where strpos(r.content, 'book3-full-sharh-batch02') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 4 then raise exception 'Book 3 lessons 4-6 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book3_full_sharh_batch02 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id
        and s.source_document = 'Sharkh_Medinskiy_3.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 3 lesson 4-6 card has no complete source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1937
      and content like '%قَاوِلٌ؛ قُلِبَتِ الْوَاوُ هَمْزَةً%'
      and content like '%دَاعِوٌ؛ قُلِبَتِ الْوَاوُ يَاءً%'
      and content like '%وَاقٍ، الْوَاقِي%'
      and content like '%طَاوٍ، الطَّاوِي%'
      and content like '%مُنَادٍ%'
      and content like '%مُطْمَئِنٌّ%'
  ) then raise exception 'Lesson 4 active-participle table, changes or augmented forms are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1938
      and content like '%مَقْوُولٌ؛ نُقِلَتْ حَرَكَةُ الْوَاوِ%'
      and content like '%مَبْيُوعٌ؛ نُقِلَتْ حَرَكَةُ الْيَاءِ%'
      and content like '%مَدْعُوْوٌ؛ أُدْغِمَتِ الْوَاوُ%'
      and content like '%مَهْدُوْيٌ؛ اجْتَمَعَتِ الْوَاوُ وَالْيَاءُ%'
      and content like '%مُنَادًى%'
      and content like '%مُسْتَغْفَرٌ%'
  ) then raise exception 'Lesson 5 passive-participle table, phonetic causes or augmented forms are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1939
      and content like '%تُسَمَّى مَا الْحِجَازِيَّةَ%'
      and content like '%مَا هَٰذَا بَشَرًا%'
      and content like '%وَمَا ٱللَّهُ بِغَٰفِلٍ عَمَّا تَعۡمَلُونَ%'
      and content like '%مَا أَنَا تَاجِرًا%'
      and content like '%مَا أَنَا بِتَاجِرٍ%'
      and content like '%اشْتِغَالُ الْمَحَلِّ بِحَرَكَةِ حَرْفِ الْجَرِّ الزَّائِدِ%'
  ) then raise exception 'Lesson 5 Hijazi ما rule, Quran examples or full parsing are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1940
      and content like '%مَرْمًى%'
      and content like '%مَطَافٌ%'
      and content like '%مَنْزِلٌ%'
      and content like '%مَوْقِفٌ%'
      and content like '%الْقِيَاسُ مَفْعَلٌ%'
      and content like '%مَحْكَمَةٌ%'
      and content like '%مَهْبِطُ الْوَحْيِ فِي مَكَّةَ الْمُكَرَّمَةِ%'
      and content like '%مُسْتَقَرٌّ%'
      and content like '%مُعَسْكَرٌ%'
  ) then raise exception 'Lesson 6 time/place noun derivation, heard forms or examples are incomplete'; end if;
end;
$assert$;

commit;
