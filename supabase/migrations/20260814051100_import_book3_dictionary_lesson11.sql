-- Book 3 dictionary, lesson 11.
-- Controlling photograph: 1786610370022.jpg (128).

delete from public.words where course_name = 'Мединский курс (Том 3)' and lesson_number = '11';

insert into public.words
  (course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form)
values
  ('Мединский курс (Том 3)', '11', 'مَغَصٌ', 'Боль в животе, колики', 1, 'single'),
  ('Мединский курс (Том 3)', '11', 'رِيَاضِيٌّ', 'Спортивный', 2, 'single'),
  ('Мединский курс (Том 3)', '11', 'بِالضَّبْطِ', 'Точно', 3, 'single'),
  ('Мединский курс (Том 3)', '11', 'مُشْرِكٌ', 'Многобожник', 4, 'single'),
  ('Мединский курс (Том 3)', '11', 'ظِلٌّ', 'Тень', 5, 'singular'),
  ('Мединский курс (Том 3)', '11', 'ظِلَالٌ', 'Тень', 5, 'plural'),
  ('Мединский курс (Том 3)', '11', 'سَيْفٌ', 'Меч, сабля', 6, 'singular'),
  ('Мединский курс (Том 3)', '11', 'سُيُوفٌ', 'Меч, сабля', 6, 'plural'),
  ('Мединский курс (Том 3)', '11', 'عَجِيبٌ', 'Удивительный', 7, 'single'),
  ('Мединский курс (Том 3)', '11', 'شَكٌّ', 'Сомнение', 8, 'singular'),
  ('Мединский курс (Том 3)', '11', 'شُكُوكٌ', 'Сомнение', 8, 'plural'),
  ('Мединский курс (Том 3)', '11', 'يُسْرٌ', 'Лёгкость', 9, 'single'),
  ('Мединский курс (Том 3)', '11', 'نِيَّةٌ', 'Намерение', 10, 'singular'),
  ('Мединский курс (Том 3)', '11', 'نِيَّاتٌ', 'Намерение', 10, 'plural'),
  ('Мединский курс (Том 3)', '11', 'وَجَبَ/يَجِبُ', 'Стать обязательным', 11, 'single'),
  ('Мединский курс (Том 3)', '11', 'اِسْتَعَانَ/يَسْتَعِينُ', 'Просить о помощи', 12, 'single'),
  ('Мединский курс (Том 3)', '11', 'مُتَحَجِّبَةٌ', 'В хиджабе, покрытая', 13, 'singular'),
  ('Мединский курс (Том 3)', '11', 'مُتَحَجِّبَاتٌ', 'В хиджабе, покрытая', 13, 'plural'),
  ('Мединский курс (Том 3)', '11', 'مُطَابَقَةٌ', 'Соответствие', 14, 'single'),
  ('Мединский курс (Том 3)', '11', 'مَبْنًى', 'Здание', 15, 'singular'),
  ('Мединский курс (Том 3)', '11', 'مَبَانٍ', 'Здание', 15, 'plural');

do $$
declare actual_records integer; actual_rows integer;
begin
  select count(*), count(distinct dictionary_row) into actual_records, actual_rows
  from public.words where course_name = 'Мединский курс (Том 3)' and lesson_number = '11';
  if actual_records <> 21 or actual_rows <> 15 then
    raise exception 'Book 3 lesson 11 dictionary verification failed: % records, % rows', actual_records, actual_rows;
  end if;
end
$$;
