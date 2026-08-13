-- Fully vocalize the isolated definite-article label in the public Book 2 lesson 1 card.
-- Private source_text remains verbatim and is not changed.

begin;

update public.rules
set
  rule_ar = replace(rule_ar, 'حَذْفِ «ال»', 'حَذْفِ «اَلْ»'),
  summary = replace(summary, 'حَذْفِ «ال»', 'حَذْفِ «اَلْ»'),
  content = replace(
    replace(content, 'Формы без ال', 'Формы без اَلْ'),
    '>ال</span>',
    '>اَلْ</span>'
  )
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '1'
  and title like 'الِاسْمُ الْمَنْقُوصُ وَغَالٍ%';

commit;
