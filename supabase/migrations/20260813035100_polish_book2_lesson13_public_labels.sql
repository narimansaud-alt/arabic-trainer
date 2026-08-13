-- Correct the unvocalized terminology found by the lessons 12-13 pre-apply audit.
-- Lesson 12 required no correction; this patch touches only lesson 13, rule 2.

begin;

update public.rules
set
  title = 'مُرَاجَعَةُ إِسْنَادِ الْمُضَارِعِ إِلَى الضَّمَائِرِ (повторение спряжения глагола настоящего/будущего времени)',
  summary = 'Автор повторяет: формы с وَاوُ الْجَمَاعَةِ (вау множественного числа) и يَاءُ الْمُخَاطَبَةِ (йа обращения к женщине) стоят в именительном состоянии с сохранением نُونٌ (буквы «нун»), а формы с نُونُ النِّسْوَةِ (нун женского множественного числа) построены на сукуне.',
  content = replace(
    content,
    '<span class="rule-table-ru">сохранение ن</span>',
    '<span class="rule-table-ru">сохранение буквы «нун»</span>'
  )
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '13'
  and sort_order = 2;

commit;
