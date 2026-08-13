-- Fix a closing span typo in the Book 2 lesson 5 overt-object explanation.

begin;

update public.rules
set content = replace(content, '</span، وَإِمَّا', '</span>، وَإِمَّا')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '5'
  and sort_order = 5;

commit;
