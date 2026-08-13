-- Remove unvocalized Arabic labels embedded in Russian UI prose for Book 2 lesson 14.
-- The fully vocalized Arabic terms remain in their dedicated Arabic spans.

begin;

do $migration$
declare
  target_rule_id bigint;
  target_content text;
begin
  select id, content into strict target_rule_id, target_content
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '14'
    and sort_order = 3;

  if position('Форма المضارع (настоящего-будущего)' in target_content) = 0
     or position('Форма الأمر (повелительного)' in target_content) = 0
     or position('буква المضارع, затем нун' in target_content) = 0
     or position('Произношение перед الـ и после وَ' in target_content) = 0
     or position('Конечная ج не получает касру' in target_content) = 0 then
    raise exception 'Expected Book 2 lesson 14 labels were not found';
  end if;

  update public.rules
  set content = replace(
    replace(
      replace(
        replace(
          replace(content,
            'Форма المضارع (настоящего-будущего)',
            'Форма настоящего-будущего времени'),
          'Форма الأمر (повелительного)',
          'Повелительная форма'),
        'буква المضارع, затем нун',
        'буква настоящего-будущего времени, затем нун'),
      'Произношение перед الـ и после وَ',
      'Произношение перед определённым артиклем и после союза «и»'),
    'Конечная ج не получает касру',
    'Конечная буква джим не получает касру')
  where id = target_rule_id;
end
$migration$;

commit;
