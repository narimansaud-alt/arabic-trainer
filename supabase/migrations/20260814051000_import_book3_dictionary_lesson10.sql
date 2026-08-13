-- Book 3 dictionary, lesson 10.
-- Controlling photograph: 1786610370029.jpg (127).

delete from public.words where course_name = 'Мединский курс (Том 3)' and lesson_number = '10';

insert into public.words
  (course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form)
values
  ('Мединский курс (Том 3)', '10', 'سَئِمَ/يَسْأَمُ', 'Чувствовать скуку, устать', 1, 'single'),
  ('Мединский курс (Том 3)', '10', 'طَفِقَ/يَطْفَقُ', 'Приступать', 2, 'single'),
  ('Мединский курс (Том 3)', '10', 'شَرَعَ/يَشْرَعُ', 'Начинать; издать закон', 3, 'single'),
  ('Мединский курс (Том 3)', '10', 'عَبِثَ/يَعْبَثُ', 'Играть, нарушать', 4, 'single'),
  ('Мединский курс (Том 3)', '10', 'فَجْأَةً', 'Неожиданно', 5, 'single'),
  ('Мединский курс (Том 3)', '10', 'فَوْضَى', 'Беспорядок', 6, 'single'),
  ('Мединский курс (Том 3)', '10', 'مُنَاسِبٌ', 'Подходящий', 7, 'single'),
  ('Мединский курс (Том 3)', '10', 'نَاقِصٌ', 'Недостаточный', 8, 'single'),
  ('Мединский курс (Том 3)', '10', 'رَدِيءٌ', 'Скверный', 9, 'singular'),
  ('Мединский курс (Том 3)', '10', 'أَرْدِيَاءُ', 'Скверный', 9, 'plural'),
  ('Мединский курс (Том 3)', '10', 'تَحَرَّكَ/يَتَحَرَّكُ', 'Двигаться', 10, 'single'),
  ('Мединский курс (Том 3)', '10', 'صَرِيحٌ', 'Ясный, явный, очевидный', 11, 'single'),
  ('Мединский курс (Том 3)', '10', 'مُؤَوَّلٌ', 'Толкуемый', 12, 'single'),
  ('Мединский курс (Том 3)', '10', 'تَامٌّ', 'Полный, завершённый', 13, 'single');

do $$
declare actual_records integer; actual_rows integer;
begin
  select count(*), count(distinct dictionary_row) into actual_records, actual_rows
  from public.words where course_name = 'Мединский курс (Том 3)' and lesson_number = '10';
  if actual_records <> 14 or actual_rows <> 13 then
    raise exception 'Book 3 lesson 10 dictionary verification failed: % records, % rows', actual_records, actual_rows;
  end if;
end
$$;
