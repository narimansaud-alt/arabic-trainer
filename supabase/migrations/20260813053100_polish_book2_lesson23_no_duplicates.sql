-- Remove one duplicate public example and keep the connected Arabic word بِسِتِّينَ intact.
-- Verbatim rule_sources.source_text remains unchanged.

update public.rules
set content = replace(
  replace(
    content,
    '<tr><td rowspan="3"><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">الْمُدَرِّسِينَ</span>.</span></td><td>Я увидел преподавателей.</td></tr>',
    '<tr><td rowspan="2"><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يُحِبُّ الْمُدَرِّسُ الطُّلَّابَ <span class="ar-tone-nasb">الْمُجْتَهِدِينَ</span>.</span></td><td>Преподаватель любит усердных студентов.</td></tr>'
  ),
  '<tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يُحِبُّ الْمُدَرِّسُ الطُّلَّابَ <span class="ar-tone-nasb">الْمُجْتَهِدِينَ</span>.</span></td><td>Преподаватель любит усердных студентов.</td></tr>',
  ''
)
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '23'
  and sort_order = 1;

update public.rules
set content = replace(
  content,
  'اِشْتَرَيْتُ كُتُبًا بِـ<span class="ar-tone-jarr">سِتِّينَ</span> رِيَالًا.',
  'اِشْتَرَيْتُ كُتُبًا <span class="ar-tone-jarr">بِسِتِّينَ</span> رِيَالًا.'
)
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '23'
  and sort_order = 2;

do $verification$
begin
  if exists (
    select 1
    from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '23'
      and (
        content like '%rowspan="3"%رَأَيْتُ %الْمُدَرِّسِينَ%'
        or content like '%بِـ<span%سِتِّينَ%'
      )
  ) then
    raise exception 'Book 2 lesson 23 still contains a duplicate row or split Arabic word';
  end if;
end
$verification$;
