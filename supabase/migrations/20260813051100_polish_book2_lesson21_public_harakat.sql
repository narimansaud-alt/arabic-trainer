-- Polish public Book 2 lesson 21 text after the source-verified rebuild.
-- Verbatim rule_sources.source_text is intentionally untouched.

update public.rules
set
  summary = replace(summary, 'إعراب', 'إِعْرَابٍ'),
  content = replace(content, 'إعراب', 'إِعْرَابٍ')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '21'
  and sort_order = 4;

update public.rules
set
  rule_ar = replace(
    replace(rule_ar, 'الْمُبْتَدَإِ', 'الْمُبْتَدَأِ'),
    'وَقَدْ يَتَقَدَّمُ',
    'وَيَتَقَدَّمُ'
  ),
  summary = 'Именное предложение начинается именем и состоит из مُبْتَدَأٍ — подлежащего и خَبَرٍ — сказуемого; глагольное начинается глаголом и состоит из глагола и исполнителя. Сохранены разборы, виды сказуемого и случаи его постановки перед подлежащим.',
  content = replace(content, 'شبه جملة', 'شِبْهُ جُمْلَةٍ')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '21'
  and sort_order = 5;

do $verification$
begin
  if exists (
    select 1
    from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '21'
      and (
        summary like '%إعراب%'
        or content like '%إعراب%'
        or summary like '% مبتدأ %'
        or summary like '% خبر%'
        or content like '%شبه جملة%'
        or rule_ar like '%الْمُبْتَدَإِ%'
        or rule_ar like '%وَقَدْ يَتَقَدَّمُ%'
      )
  ) then
    raise exception 'Book 2 lesson 21 still contains an unpolished public Arabic fragment';
  end if;
end
$verification$;
