-- The controlling Book 3 dictionary photographs end with lesson 16 on page 145.
-- Remove legacy placeholder data assigned to a nonexistent lesson 17 dictionary section.

delete from public.words
where course_name = 'Мединский курс (Том 3)'
  and lesson_number = '17';

do $$
declare actual_records integer;
begin
  select count(*) into actual_records
  from public.words
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '17';
  if actual_records <> 0 then
    raise exception 'Book 3 lesson 17 dictionary cleanup failed: % records remain', actual_records;
  end if;
end
$$;
