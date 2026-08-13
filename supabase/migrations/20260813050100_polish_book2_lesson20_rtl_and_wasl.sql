-- Polish public Book 2 lesson 20 text without touching verbatim source_text.

update public.rules
set
  rule_ar = replace(rule_ar, 'اسْمٌ', 'اِسْمٌ'),
  content = replace(content, 'اسْمٌ', 'اِسْمٌ')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '20';

update public.rules
set content = replace(
  replace(
    content,
    '<span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَحَدٌ ← أَحَدُهُمَا</span>',
    '<span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَحَدٌ؛ وَمَعَ ضَمِيرِ التَّثْنِيَةِ: أَحَدُهُمَا</span>'
  ),
  '<span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">إِحْدَى ← إِحْدَاهُمَا</span>',
  '<span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">إِحْدَى؛ وَمَعَ ضَمِيرِ التَّثْنِيَةِ: إِحْدَاهُمَا</span>'
)
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '20'
  and sort_order = 2;

do $verification$
begin
  if exists (
    select 1
    from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '20'
      and (rule_ar like '% اسْمٌ%' or content like '% اسْمٌ%' or content like '%←%')
  ) then
    raise exception 'Book 2 lesson 20 still contains an unpolished initial ism or RTL arrow';
  end if;
end
$verification$;
