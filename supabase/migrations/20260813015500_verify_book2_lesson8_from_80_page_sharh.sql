-- Verify Medina Book 2 lesson 8 against the complete 80-page Arabic sharh.
-- Sole source: Podrobny_Sharkh_2_tom.pdf, PDF page 25.

begin;

do $migration$
declare
  lesson_rule_count integer;
  review_rule_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '8';

  if lesson_rule_count not in (1, 4) then
    raise exception 'Expected 1 or 4 Book 2 lesson 8 cards, found %', lesson_rule_count;
  end if;

  select id into strict review_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '8'
    and sort_order = 1;

  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '8'
  );

  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 2)' and lesson_number = '8'
  );

  delete from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '8'
    and id <> review_rule_id;

  update public.rules
  set
    sort_order = 1,
    title = 'مُرَاجَعَةُ الْفِعْلِ الْمَاضِي (повторение глагола прошедшего времени)',
    rule_ar = 'هَذَا الدَّرْسُ مُرَاجَعَةٌ لِلْفِعْلِ الْمَاضِي الَّذِي تَقَدَّمَ شَرْحُهُ فِي الدَّرْسِ الرَّابِعِ.',
    summary = 'هَذَا الدَّرْسُ مُرَاجَعَةٌ لِلْفِعْلِ الْمَاضِي الَّذِي تَقَدَّمَ شَرْحُهُ فِي الدَّرْسِ الرَّابِعِ.',
    rule_kind = 'rule',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">مُرَاجَعَةٌ — повторение</span><span class="rule-main-ar" dir="rtl" lang="ar">مُرَاجَعَةُ <span class="ar-tone-verb">الْفِعْلِ الْمَاضِي</span>: تَقَدَّمَ مَعَنَا فِي <span class="ar-tone-structure">الدَّرْسِ الرَّابِعِ</span>.</span><p class="rule-study-text">Повторение глагола прошедшего времени: его объяснение уже было дано в четвёртом уроке. Нового правила в этом кратком разделе шарх не добавляет.</p></div></div>$$
  where id = review_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (review_rule_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الثامن
مراجعة الفعل الماضي:
تقدم معنا في الدرس الرابع.$$,
      25, 25, 1);
end;
$migration$;

commit;
