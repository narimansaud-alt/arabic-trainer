-- Fix public labels exposed by the live Book 2 lesson 7 harakat audit.
-- Literal source_text is intentionally untouched.

begin;

update public.rules
set content = replace(content, 'Дополнительные شبه جملة', 'Дополнительные شِبْهُ جُمْلَةٍ')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '7'
  and sort_order = 5;

update public.rules
set
  title = replace(title, 'قَبْلَ «ال»', 'قَبْلَ «الْـ»'),
  content = replace(content, 'Три неподвижные согласные перед «ال»', 'Три неподвижные согласные перед «الْـ»')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '7'
  and sort_order = 7;

commit;
