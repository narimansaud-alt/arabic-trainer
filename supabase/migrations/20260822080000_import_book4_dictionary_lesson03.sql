-- Book 4 dictionary, application lesson 3.
-- The three controlling photographs are printed as Book 4, lesson 20,
-- pages 166-168. Book 4 starts with printed lesson 18, so printed lesson 20
-- maps to application lesson 3. Rows follow the photographs from top to bottom.
-- A plural record immediately follows its singular record, shares
-- dictionary_row, and has its own Russian plural translation for list mode.

begin;

do $$
declare
  actual_records integer;
  actual_placeholders integer;
  actual_rows integer;
  actual_single integer;
  actual_singular integer;
  actual_plural integer;
begin
  select
    count(*),
    count(*) filter (where dictionary_row is null and dictionary_form is null),
    count(distinct dictionary_row),
    count(*) filter (where dictionary_form = 'single'),
    count(*) filter (where dictionary_form = 'singular'),
    count(*) filter (where dictionary_form = 'plural')
  into
    actual_records,
    actual_placeholders,
    actual_rows,
    actual_single,
    actual_singular,
    actual_plural
  from public.words
  where course_name = 'Мединский курс (Том 4)'
    and lesson_number = '3';

  if not (
    actual_records = 0
    or (actual_records = 6 and actual_placeholders = 6)
    or (
      actual_records = 45
      and actual_rows = 37
      and actual_single = 29
      and actual_singular = 8
      and actual_plural = 8
    )
  ) then
    raise exception
      'Unexpected Book 4 lesson 3 state before import: % records, % placeholders, % rows, % single, % singular, % plural',
      actual_records,
      actual_placeholders,
      actual_rows,
      actual_single,
      actual_singular,
      actual_plural;
  end if;
end
$$;

delete from public.words
where course_name = 'Мединский курс (Том 4)'
  and lesson_number = '3'
  and dictionary_row is null
  and dictionary_form is null;

insert into public.words
  (course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form)
select *
from (values
  ('Мединский курс (Том 4)', '3', 'مُتَوَضَّأٌ', 'Место омовения', 1, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَلَقَّى/يَتَلَقَّى', 'Встретить; получить', 2, 'single'),
  ('Мединский курс (Том 4)', '3', 'خَلِيفَةٌ', 'Наместник, халиф', 3, 'singular'),
  ('Мединский курс (Том 4)', '3', 'خُلَفَاءُ', 'Наместники, халифы', 3, 'plural'),
  ('Мединский курс (Том 4)', '3', 'رَاشِدٌ', 'Праведный; благоразумный', 4, 'singular'),
  ('Мединский курс (Том 4)', '3', 'رَاشِدُونَ', 'Праведные; благоразумные', 4, 'plural'),
  ('Мединский курс (Том 4)', '3', 'تَزَوَّجَ/يَتَزَوَّجُ', 'Жениться', 5, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَخَلَّفَ/يَتَخَلَّفُ', 'Отстать, пропустить', 6, 'single'),
  ('Мединский курс (Том 4)', '3', 'وَفَاةٌ', 'Смерть', 7, 'singular'),
  ('Мединский курс (Том 4)', '3', 'وَفَيَاتٌ', 'Смерти', 7, 'plural'),
  ('Мединский курс (Том 4)', '3', 'تُوُفِّيَ', 'Умер', 8, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَقَبَّلَ/يَتَقَبَّلُ', 'Принимать', 9, 'single'),
  ('Мединский курс (Том 4)', '3', 'مَعْرَكَةٌ', 'Битва, сражение', 10, 'singular'),
  ('Мединский курс (Том 4)', '3', 'مَعَارِكُ', 'Битвы, сражения', 10, 'plural'),
  ('Мединский курс (Том 4)', '3', 'دَعْوَةٌ', 'Призыв, приглашение', 11, 'singular'),
  ('Мединский курс (Том 4)', '3', 'دَعَوَاتٌ', 'Призывы, приглашения', 11, 'plural'),
  ('Мединский курс (Том 4)', '3', 'مُتَفَوِّقٌ', 'Отличник', 12, 'single'),
  ('Мединский курс (Том 4)', '3', 'مَرَّضَ/يُمَرِّضُ', 'Ухаживать за больным', 13, 'single'),
  ('Мединский курс (Том 4)', '3', 'زَوَّجَ/يُزَوِّجُ', 'Женить, выдать замуж', 14, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَحَدَّثَ/يَتَحَدَّثُ', 'Говорить, рассказывать', 15, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَكَلَّمَ/يَتَكَلَّمُ', 'Разговаривать, говорить', 16, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَذَكَّرَ/يَتَذَكَّرُ', 'Вспомнить', 17, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَغَدَّى/يَتَغَدَّى', 'Обедать', 18, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَعَشَّى/يَتَعَشَّى', 'Ужинать', 19, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَمَنَّى/يَتَمَنَّى', 'Желать', 20, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَأَنَّى/يَتَأَنَّى', 'Медлить', 21, 'single'),
  ('Мединский курс (Том 4)', '3', 'مَوْضُوعٌ', 'Положенный; тема, вопрос; выдуманный', 22, 'singular'),
  ('Мединский курс (Том 4)', '3', 'مَوَاضِيعُ، مَوْضُوعَاتٌ', 'Положенные; темы, вопросы; выдуманные', 22, 'plural'),
  ('Мединский курс (Том 4)', '3', 'تَأَنٍّ', 'Медленность, осмотрительность', 23, 'single'),
  ('Мединский курс (Том 4)', '3', 'نَدَامَةٌ', 'Сожаление', 24, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَسَلُّقٌ', 'Восхождение, подъём', 25, 'single'),
  ('Мединский курс (Том 4)', '3', 'وَارِثٌ', 'Наследник', 26, 'singular'),
  ('Мединский курс (Том 4)', '3', 'وَرَثَةٌ', 'Наследники', 26, 'plural'),
  ('Мединский курс (Том 4)', '3', 'مُتَنَفَّسٌ', 'Отдушина, выход', 27, 'single'),
  ('Мединский курс (Том 4)', '3', 'خِرِّيجٌ', 'Выпускник', 28, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَخَرَّجَ/يَتَخَرَّجُ', 'Закончить учёбу, выпуститься', 29, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَوَكَّلَ/يَتَوَكَّلُ', 'Уповать', 30, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَنَزَّلَ/يَتَنَزَّلُ', 'Уступить; нисходить', 31, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَجَسَّسَ/يَتَجَسَّسُ', 'Шпионить', 32, 'single'),
  ('Мединский курс (Том 4)', '3', 'لَمَّا', 'Когда, после того как; пока не', 33, 'single'),
  ('Мединский курс (Том 4)', '3', 'تَوَجَّهَ/يَتَوَجَّهُ', 'Направиться', 34, 'single'),
  ('Мединский курс (Том 4)', '3', 'أَسْرَعَ/يُسْرِعُ', 'Поспешить', 35, 'single'),
  ('Мединский курс (Том 4)', '3', 'مَعْشَرٌ', 'Собрание, общество', 36, 'singular'),
  ('Мединский курс (Том 4)', '3', 'مَعَاشِرُ', 'Собрания, общества', 36, 'plural'),
  ('Мединский курс (Том 4)', '3', 'بَزَغَ/يَبْزُغُ', 'Восходить (о солнце, луне)', 37, 'single')
) as source(course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form)
where not exists (
  select 1
  from public.words
  where course_name = 'Мединский курс (Том 4)'
    and lesson_number = '3'
);

do $$
declare
  l1_records integer;
  l2_records integer;
  l3_records integer;
  l3_rows integer;
  l3_single integer;
  l3_singular integer;
  l3_plural integer;
  l3_pairs integer;
  l4_records integer;
  l5_records integer;
begin
  select count(*) into l1_records
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '1';

  select count(*) into l2_records
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '2';

  select
    count(*),
    count(distinct dictionary_row),
    count(*) filter (where dictionary_form = 'single'),
    count(*) filter (where dictionary_form = 'singular'),
    count(*) filter (where dictionary_form = 'plural')
  into l3_records, l3_rows, l3_single, l3_singular, l3_plural
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '3';

  select count(*)
  into l3_pairs
  from (
    select dictionary_row
    from public.words
    where course_name = 'Мединский курс (Том 4)' and lesson_number = '3'
    group by dictionary_row
    having count(*) filter (where dictionary_form = 'singular') = 1
       and count(*) filter (where dictionary_form = 'plural') = 1
  ) pairs;

  select count(*) into l4_records
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '4';

  select count(*) into l5_records
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '5';

  if l1_records <> 109
    or l2_records <> 77
    or l3_records <> 45
    or l3_rows <> 37
    or l3_single <> 29
    or l3_singular <> 8
    or l3_plural <> 8
    or l3_pairs <> 8
    or l4_records <> 81
    or l5_records <> 34 then
    raise exception
      'Book 4 lessons 1-5 verification failed: l1 %, l2 %, l3 %/%/%/%/% pairs %, l4 %, l5 %',
      l1_records,
      l2_records,
      l3_records,
      l3_rows,
      l3_single,
      l3_singular,
      l3_plural,
      l3_pairs,
      l4_records,
      l5_records;
  end if;
end
$$;

commit;
