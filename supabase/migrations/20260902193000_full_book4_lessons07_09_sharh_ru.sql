-- Certify the complete Russian rendering of Medina Book 4, lessons 7-9.
-- Controlling source: Sharkh_Medinskiy_4.pdf, PDF pages 28-41.

begin;

create temp table _book4_full_sharh_batch03 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book4_full_sharh_batch03 values
  (1825, '7', 'Полный шарх: с. 28–29'),
  (1826, '7', 'Полный шарх: с. 29'),
  (1827, '7', 'Полный шарх: с. 29'),
  (1828, '7', 'Полный шарх: с. 29–30'),
  (1829, '7', 'Полный шарх: с. 30–31'),
  (1830, '8', 'Полный шарх: с. 31–32'),
  (1831, '8', 'Полный шарх: с. 32'),
  (1832, '8', 'Полный шарх: с. 32'),
  (1833, '8', 'Полный шарх: с. 32–35'),
  (1834, '8', 'Полный шарх: с. 35'),
  (1835, '8', 'Полный шарх: с. 35'),
  (1836, '9', 'Полный шарх: с. 36–37'),
  (1837, '9', 'Полный шарх: с. 37'),
  (1838, '9', 'Полный шарх: с. 37–38'),
  (1839, '9', 'Полный шарх: с. 38'),
  (1840, '9', 'Полный шарх: с. 38–39'),
  (1841, '9', 'Полный шарх: с. 39'),
  (1842, '9', 'Полный шарх: с. 39–40'),
  (1843, '9', 'Полный шарх: с. 40'),
  (1844, '9', 'Полный шарх: с. 40–41'),
  (1845, '9', 'Полный шарх: с. 41'),
  (2003, '9', 'Полный шарх: с. 41');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch03 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 4)' and r.lesson_number = b.lesson_number;
  if v_count <> 22 then raise exception 'Expected 22 guarded Book 4 rules for lessons 7-9, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 4)';
  if v_count <> 106 then raise exception 'Book 4 must retain 106 source rows, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join _book4_full_sharh_batch03 b on b.rule_id = rs.rule_id
  where rs.source_document = 'Sharkh_Medinskiy_4.pdf'
    and nullif(btrim(rs.source_text), '') is not null
    and rs.source_page_from is not null and rs.source_page_to is not null;
  if v_count <> 22 then raise exception 'Book 4 lessons 7-9 complete PDF sources missing: %', v_count; end if;
end;
$guard$;

update public.rules r
set content = regexp_replace(
  r.content,
  '</div>[[:space:]]*$',
  '<div class="rule-study-card book4-full-sharh-batch03"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источник:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book4_full_sharh_batch03 b
where r.id = b.rule_id
  and r.course_name = 'Мединский курс (Том 4)'
  and r.lesson_number = b.lesson_number
  and strpos(r.content, 'book4-full-sharh-batch03') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book4_full_sharh_batch03 b on b.rule_id = r.id
  where strpos(r.content, 'book4-full-sharh-batch03') > 0
    and nullif(btrim(r.title), '') is not null
    and nullif(btrim(r.summary), '') is not null
    and nullif(btrim(r.rule_ar), '') is not null
    and nullif(btrim(r.content), '') is not null;
  if v_count <> 22 then raise exception 'Book 4 lessons 7-9 cards or markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book4_full_sharh_batch03 b
    where not exists (
      select 1 from public.rule_sources s
      where s.rule_id = b.rule_id and s.source_document = 'Sharkh_Medinskiy_4.pdf'
        and nullif(btrim(s.source_text), '') is not null
    )
  ) then raise exception 'A completed Book 4 lesson 7-9 card has no complete source row'; end if;

  if not exists (select 1 from public.rules where id = 1825 and content like '%مُعْوَجِجٌ%' and content like '%اِحْمَرَّ ← اِحْمِرَارٌ%')
    then raise exception 'Lesson 7 افعلّ meanings, masdar or derivatives are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1826 and content like '%اِدْهَامَّ%' and content like '%مُبْيَاضِضٌ%')
    then raise exception 'Lesson 7 افعالّ examples, restriction or derivatives are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1827 and content like '%رَأَيْتُ الْعِلْمَ نُورًا%' and content like '%رَأَى مُحَمَّدٌ الْحَقَّ وَاضِحًا%')
    then raise exception 'Lesson 7 both meanings and objects of رأى are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1828 and content like '%بَعْدَ انْتِهَاءِ الصَّلَاةِ%' and content like '%بِكَوْنِكُمْ كَافِرِينَ%' and content like '%أَحْرُفُ الْمَصْدَرِ%')
    then raise exception 'Lesson 7 masdar ما examples, verse or source particles are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1829 and content like '%عَسَى الْمَرِيضُ أَنْ يَمُوتَ%' and content like '%الطَّالِبُ عَسَى أَنْ يَنْجَحَ%' and content like '%الْمَصْدَرُ الْمُؤَوَّلُ فِي مَحَلِّ رَفْعٍ فَاعِلٌ%')
    then raise exception 'Lesson 7 عسى meanings, three cases or parsing are incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1830 and content like '%اِسْتَرْجَلَتِ الْمَرْأَةُ%' and content like '%مُسْتَعِيذٌ%' and content like '%مُسْتَهْدًى%')
    then raise exception 'Lesson 8 استفعل meanings, masdars or derivatives are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1831 and content like '%لَا أَكَلْتُ وَلَا شَرِبْتُ%' and content like '%فَلَا صَدَّقَ وَلَا صَلَّىٰ%')
    then raise exception 'Lesson 8 repeated لا for past negation is incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1832 and content like '%قَدْ رَكَعَ الْإِمَامُ%' and content like '%فِي مَحَلِّ نَصْبٍ%')
    then raise exception 'Lesson 8 قد in the circumstantial clause is incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1833 and content like '%لِكَيْلَا أَرْسُبَ%' and content like '%أَلَّا يَفْصِلَ بَيْنَهَا%' and content like '%إِذَنْ وَاللَّهِ أَنْتَظِرَكَ%' and content like '%جُمْلَةٌ اعْتِرَاضِيَّةٌ%')
    then raise exception 'Lesson 8 all four subjunctive particles, conditions or full parsing are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1834 and content like '%أَجَعَلْتَنِي مُدِيرًا%' and content like '%جَعَلَ اللَّهُ الْهَوَاءَ%' and content like '%وَجَعَلَ ٱلظُّلُمَٰتِ وَٱلنُّورَ%')
    then raise exception 'Lesson 8 all four meanings and government of جعل are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1835 and content like '%عَصَايَ%' and content like '%عَيْنَيَّ%' and content like '%يَدَيَّ%')
    then raise exception 'Lesson 8 فتح ياء المتكلم cases or examples are incomplete'; end if;

  if not exists (select 1 from public.rules where id = 1836 and content like '%وَسْوَسَةٌ وَوِسْوَاسٌ%' and content like '%مُبَعْثَرٌ%' and content like '%مَزِيدٌ بِحَرْفَيْنِ%')
    then raise exception 'Lesson 9 quadriliteral base and derived forms are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1837 and content like '%دَحْرَجْتُ الْكُرَةَ%' and content like '%مُتَزَلْزِلٌ%')
    then raise exception 'Lesson 9 تفعلل compliance meaning or derivatives are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1838 and content like '%حَرْجَمْتُ الْإِبِلَ%' and content like '%مُفْرَنْقِعٌ%' and content like '%اِقْعَنْسَسَ%')
    then raise exception 'Lesson 9 افعنلل examples, compliance meaning or derivatives are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1839 and content like '%اِشْمَأَزَّ%' and content like '%مُقْشَعِرٌّ%' and content like '%لَا يَكُونُ إِلَّا لَازِمًا%')
    then raise exception 'Lesson 9 افعلل meanings, restriction or derivatives are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1840 and content like '%أُولَئِكَ هُنَّ الْمُؤْمِنَاتُ%' and content like '%خَبَرٌ لَا غَيْرُ%' and content like '%الْحَصْرُ%')
    then raise exception 'Lesson 9 separating pronoun conditions, benefits or clarification are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1841 and content like '%أَدَاةُ الشَّرْطِ: إِنْ أَوْ إِذَا%' and content like '%إِذَا هُمۡ يَقۡنَطُونَ%')
    then raise exception 'Lesson 9 sudden إذا replacing فاء conditions or verses are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1842 and content like '%أَوَلَمۡ تُؤۡمِن%' and content like '%وَكَيْفَ حَصَلَ ذَلِكَ%')
    then raise exception 'Lesson 9 interrogative hamza order and author examples are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1843 and content like '%مُدَّةَ عَدَمِ إِتْيَانِ صَاحِبِهِ%' and content like '%مَا دُمْتُ حَيًّا%' and content like '%مَفْعُولٌ فِيهِ%')
    then raise exception 'Lesson 9 temporal masdar ما examples or full parsing are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1844 and content like '%لَمْ يَشْدُدْ%' and content like '%وَٱغۡضُضۡ مِن صَوۡتِكَ%')
    then raise exception 'Lesson 9 optional separation of doubled roots or verses are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 1845 and content like '%بَعْضَ الَّذِي رَزَقْنَاهُمْ%' and content like '%أَنْتَ مِنْ أَحْسَنِ%')
    then raise exception 'Lesson 9 partitive من meaning or author examples are incomplete'; end if;
  if not exists (select 1 from public.rules where id = 2003 and content like '%يَا رَبَّاهْ%' and content like '%يَا قَوْمَاهْ%' and content like '%يَا رَبَّ، وَيَا قَوْمَ%')
    then raise exception 'Lesson 9 all five forms of the vocative with possessive ya are incomplete'; end if;
end;
$assert$;

commit;
