-- Vocalize the remaining Arabic terminology found in lesson 11 summaries and
-- keep the Russian meaning beside each term.

begin;

update public.rules
set summary = 'Форма الْفِعْلِ الْمُضَارِعِ (глагола настоящего/будущего времени) связывается с местоимениями отсутствующего, собеседника и говорящего; её исполнитель может быть явным именем, скрытым или присоединённым местоимением.'
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '11'
  and sort_order = 1;

update public.rules
set summary = 'Частица مَا обычно отрицает прошедший глагол, а لَا — глагол настоящего/будущего времени; 80-страничный шарх отдельно показывает مَا с الْفِعْلِ الْمُضَارِعِ (глаголом настоящего/будущего времени) для отрицания действия сейчас.'
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '11'
  and sort_order = 3;

update public.rules
set summary = 'Частица سَـ присоединяется к الْفِعْلِ الْمُضَارِعِ (глаголу настоящего/будущего времени) и в шархе обозначает близкое будущее; سَوْفَ пишется отдельно и приводится для далёкого будущего.'
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '11'
  and sort_order = 4;

update public.rules
set summary = 'Прямое присоединение يَاءُ الْمُتَكَلِّمِ (буквы «йа» говорящего) делает имя определённым; для неопределённого значения между именем и значением принадлежности ставится لِـ.'
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '11'
  and sort_order = 7;

commit;
