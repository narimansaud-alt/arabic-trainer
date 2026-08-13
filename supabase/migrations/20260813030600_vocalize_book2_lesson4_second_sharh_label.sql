-- Correct one unvocalized Arabic label exposed by the live Book 2 lesson 4 audit.

begin;

update public.rules
set content = replace(
  content,
  '<span class="rule-table-ru">واو мужского множественного</span>',
  '<span class="rule-table-ru">буква وَاو для мужского множественного</span>'
)
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '4'
  and sort_order = 1;

commit;
