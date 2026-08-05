-- Remove an internal import checklist accidentally appended to the public
-- explanation in volume 1, lesson 23. The grammatical rule itself is kept.
update public.rules
set content = split_part(
  content,
  '<br><br>## Обязательные требования к импорту этой базы',
  1
)
where id = 691
  and course_name = 'Мединский курс (Том 1)'
  and lesson_number = '23'
  and content like '%## Обязательные требования к импорту этой базы%';
