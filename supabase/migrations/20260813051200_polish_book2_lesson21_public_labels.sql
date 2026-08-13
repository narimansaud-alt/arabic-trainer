-- Final public-label polish for Book 2 lesson 21.
-- Verbatim rule_sources.source_text remains unchanged.

update public.rules
set title = 'أَقْسَامُ الْكَلِمَةِ (три разряда слова: имя, глагол и частица)'
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '21'
  and sort_order = 2;

update public.rules
set content = replace(content, 'الْمُبْتَدَإِ', 'الْمُبْتَدَأِ')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '21'
  and sort_order = 5;

update public.rules
set rule_ar = replace(rule_ar, '«اللَّائِي» اسْمَانِ', '«اللَّائِي» اِسْمَانِ')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '21'
  and sort_order = 6;

update public.rules
set title = 'الْعَلَمُ الْأَعْجَمِيُّ وَالْمَمْنُوعُ مِنَ الصَّرْفِ (иностранное собственное имя и имя с неполным склонением)'
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '21'
  and sort_order = 7;

do $verification$
begin
  if exists (
    select 1
    from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '21'
      and (content like '%الْمُبْتَدَإِ%' or rule_ar like '%«اللَّائِي» اسْمَانِ%')
  ) then
    raise exception 'Book 2 lesson 21 still contains an obsolete public spelling';
  end if;
end
$verification$;
