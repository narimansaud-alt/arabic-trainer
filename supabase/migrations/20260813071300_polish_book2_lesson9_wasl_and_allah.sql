-- Finish the Book 2 lesson 9 post-write orthographic audit: the first
-- color-split composition needs an explicit alif-wasla glyph, and the public
-- vocative example needs the fully vocalized divine name.

begin;

update public.rules
set content = replace(content, '>الْآنَ</span>', '>ٱلْآنَ</span>')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '9'
  and sort_order = 4;

update public.rules
set content = replace(content, 'يَا عَبْدَ اللهِ', 'يَا عَبْدَ اللَّهِ')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '9'
  and sort_order = 3;

do $migration$
begin
  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '9'
      and sort_order = 4
      and position('>الْآنَ</span>' in content) > 0
  ) then
    raise exception 'Lesson 9 still contains the unmarked wasl composition';
  end if;

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '9'
      and sort_order = 3
      and position('يَا عَبْدَ اللهِ' in content) > 0
  ) then
    raise exception 'Lesson 9 still contains a partially vocalized public divine name';
  end if;
end;
$migration$;

commit;
