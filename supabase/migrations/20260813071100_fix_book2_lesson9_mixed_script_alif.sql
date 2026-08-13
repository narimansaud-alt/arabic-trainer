-- Replace four mixed-script Russian labels (Cyrillic "ал" + Arabic "يف")
-- in the Book 2 lesson 9 interrogative-ma table.

begin;

update public.rules
set content = replace(content, 'алيف', 'алиф')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '9'
  and position('алيف' in content) > 0;

do $migration$
begin
  if exists (
    select 1
    from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '9'
      and position('алيف' in content) > 0
  ) then
    raise exception 'Book 2 lesson 9 still contains mixed-script alif labels';
  end if;
end;
$migration$;

commit;
