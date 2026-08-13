-- Reuse the application's established responsive meaning-card layout for the
-- complete lesson 16 i'rab instead of introducing one-off CSS selectors.

begin;

update public.rules
set content = replace(
  replace(
    replace(
      replace(
        content,
        'rule-analysis-list',
        'rule-meaning-grid'
      ),
      'rule-analysis-row',
      'rule-meaning-card'
    ),
    'rule-analysis-ar',
    'rule-term-ar'
  ),
  'rule-analysis-ru',
  'rule-term-ru'
)
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '16'
  and sort_order = 5;

commit;
