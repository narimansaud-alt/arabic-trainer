-- Final source-backed QA corrections for Medina Book 3.
-- Keep rule_sources.source_text verbatim and unchanged.

do $$
declare
  v_rule_id bigint;
  v_old text := 'النُّدْبَةُ نِدَاءُ الْمُتَفَجَّعِ عَلَيْهِ أَوِ الْمُتَوَجَّعِ مِنْهُ، وَحَرْفُ النُّدْبَةِ وََا.';
  v_new text := 'النُّدْبَةُ نِدَاءُ الْمُتَفَجَّعِ عَلَيْهِ أَوِ الْمُتَوَجَّعِ مِنْهُ، وَحَرْفُ النُّدْبَةِ وَا.';
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '13'
    and sort_order = 3
    and title = 'النُّدْبَةُ (зов скорби или боли)';

  if (select rule_ar from public.rules where id = v_rule_id) is distinct from v_old then
    raise exception 'Unexpected old rule_ar for Book 3 lesson 13 rule %', v_rule_id;
  end if;

  update public.rules
  set rule_ar = v_new
  where id = v_rule_id;
end
$$;