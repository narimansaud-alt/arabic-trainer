-- Replace the only unvocalized Arabic term embedded in Russian UI prose.

begin;

do $migration$
declare
  target_rule_id bigint;
  target_summary text;
  target_content text;
begin
  select id, summary, content into strict target_rule_id, target_summary, target_content
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '15'
    and sort_order = 3;

  if position('с المضارع.' in target_summary) = 0
     or position('Глагол المضارع в именительном' in target_content) = 0 then
    raise exception 'Expected Book 2 lesson 15 Russian UI labels were not found';
  end if;

  update public.rules
  set
    summary = replace(summary, 'с المضارع.', 'с глаголом настоящего-будущего времени.'),
    content = replace(content, 'Глагол المضارع в именительном', 'Глагол настоящего-будущего времени в именительном')
  where id = target_rule_id;
end
$migration$;

commit;
