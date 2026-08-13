-- Correct the one unvocalized Arabic letter name found by the lesson 16
-- pre-apply public-text audit. Keep Arabic and Russian labels visually separate.

begin;

update public.rules
set content = replace(
  content,
  '<span class="rule-table-ru">буква واو</span>',
  '<span class="rule-table-ru">буква <span class="ar-inline" dir="rtl" lang="ar">وَاوٌ</span> — «вау»</span>'
)
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '16'
  and sort_order = 5;

commit;
