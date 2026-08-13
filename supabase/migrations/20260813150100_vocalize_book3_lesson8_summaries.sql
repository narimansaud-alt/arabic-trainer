-- Vocalize the two Arabic terms found by the post-apply Book 3 lesson 8 audit.

begin;

update public.rules
set summary = 'Относительное имя раскрывается следующей за ним связующей частью; внутри неё находится возвращающееся местоимение — عَائِدٌ.'
where course_name = 'Мединский курс (Том 3)'
  and lesson_number = '8'
  and sort_order = 5;

update public.rules
set summary = 'Неопределённое имя становится определённым после присоединения артикля أَلْ.'
where course_name = 'Мединский курс (Том 3)'
  and lesson_number = '8'
  and sort_order = 6;

do $migration$
declare corrected_count integer;
begin
  select count(*) into corrected_count
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '8'
    and ((sort_order = 5 and summary like '%عَائِدٌ%') or (sort_order = 6 and summary like '%أَلْ%'));
  if corrected_count <> 2 then
    raise exception 'Book 3 lesson 8 summary correction failed: corrected %', corrected_count;
  end if;
end
$migration$;

commit;
