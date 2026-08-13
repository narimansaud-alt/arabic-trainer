-- Preserve the printed punctuation of the final negative-la example on source page 29.

begin;

do $migration$
declare
  target_rule_id bigint;
  target_content text;
begin
  select id, content into strict target_rule_id, target_content
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '15'
    and sort_order = 2;

  if position('لِمَ لَا تَأْكُلُ؟ فَالطَّعَامُ لَذِيذٌ.' in target_content) = 0 then
    raise exception 'Expected Book 2 lesson 15 example was not found';
  end if;

  update public.rules
  set content = replace(
    replace(content,
      'لِمَ لَا تَأْكُلُ؟ فَالطَّعَامُ لَذِيذٌ.',
      'لِمَ لَا تَأْكُلُ فَالطَّعَامُ لَذِيذٌ؟'),
    'Почему ты не ешь? Ведь еда вкусная.',
    'Почему ты не ешь, ведь еда вкусная?')
  where id = target_rule_id;
end
$migration$;

commit;
