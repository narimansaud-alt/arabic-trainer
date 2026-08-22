-- Book 4 dictionary, application lesson 6.
-- The three controlling photographs are printed as Book 4, lesson 23,
-- pages 177-179. Book 4 starts with printed lesson 18, so printed lesson 23
-- maps to application lesson 6. Rows follow the photographs from top to bottom.
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
    and lesson_number = '6';

  if not (
    actual_records = 0
    or (actual_records = 6 and actual_placeholders = 6)
    or (
      actual_records = 46
      and actual_rows = 43
      and actual_single = 40
      and actual_singular = 3
      and actual_plural = 3
    )
  ) then
    raise exception
      'Unexpected Book 4 lesson 6 state before import: % records, % placeholders, % rows, % single, % singular, % plural',
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
  and lesson_number = '6'
  and dictionary_row is null
  and dictionary_form is null;

insert into public.words
  (course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form)
select *
from (values
  ('Мединский курс (Том 4)', '6', 'اِقْتِرَاحٌ', 'Предложение, идея', 1, 'single'),
  ('Мединский курс (Том 4)', '6', 'تَعْمِيمٌ', 'Обобщение; распространение', 2, 'single'),
  ('Мединский курс (Том 4)', '6', 'مُكْتَظٌّ', 'Переполненный', 3, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِنْتَقَلَ/يَنْتَقِلُ', 'Переехать, перейти', 4, 'single'),
  ('Мединский курс (Том 4)', '6', 'طَابِقٌ', 'Этаж', 5, 'singular'),
  ('Мединский курс (Том 4)', '6', 'طَوَابِقُ', 'Этажи', 5, 'plural'),
  ('Мединский курс (Том 4)', '6', 'سَدِيدٌ', 'Правильный, верный', 6, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِجْتَنَبَ/يَجْتَنِبُ', 'Сторониться', 7, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِغْتَابَ/يَغْتَابُ', 'Сплетничать', 8, 'single'),
  ('Мединский курс (Том 4)', '6', 'غِيبَةٌ', 'Сплетня', 9, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِكْتَفَى/يَكْتَفِي', 'Ограничиться', 10, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِقْتَرَبَ/يَقْتَرِبُ', 'Приблизиться', 11, 'single'),
  ('Мединский курс (Том 4)', '6', 'فَإِذَا', 'И вдруг...', 12, 'single'),
  ('Мединский курс (Том 4)', '6', 'حَقَّ/يَحِقُّ', 'Надлежать, иметь право', 13, 'single'),
  ('Мединский курс (Том 4)', '6', 'مُضْطَرٌّ', 'Вынужденный', 14, 'single'),
  ('Мединский курс (Том 4)', '6', 'مُفْتَرَقٌ', 'Место расхождения, перекрёсток', 15, 'single'),
  ('Мединский курс (Том 4)', '6', 'شَبَّهَ/يُشَبِّهُ', 'Уподобить', 16, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِمْتَحَنَ/يَمْتَحِنُ', 'Испытывать, брать экзамен', 17, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِجْتَمَعَ/يَجْتَمِعُ', 'Собраться, встречаться', 18, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِخْتَارَ/يَخْتَارُ', 'Выбрать', 19, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِخْتِيَارٌ', 'Выбор', 20, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِنْتَصَرَ/يَنْتَصِرُ', 'Победить', 21, 'single'),
  ('Мединский курс (Том 4)', '6', 'وَحَّدَ/يُوَحِّدُ', 'Быть единым', 22, 'single'),
  ('Мединский курс (Том 4)', '6', 'وَفَقَ/يَفِقُ', 'Соответствовать', 23, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِنْتَشَرَ/يَنْتَشِرُ', 'Распространиться', 24, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِرْتَفَعَ/يَرْتَفِعُ', 'Подняться', 25, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِمْتَلَأَ/يَمْتَلِئُ', 'Стать полным', 26, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِصْطَبَرَ/يَصْطَبِرُ', 'Терпеть', 27, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِبْتَسَمَ/يَبْتَسِمُ', 'Улыбаться', 28, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِسْتَمَعَ/يَسْتَمِعُ', 'Слушать, прислушиваться', 29, 'single'),
  ('Мединский курс (Том 4)', '6', 'الْمُلْتَزَمُ', 'Место между Черным Камнем и дверью Каабы', 30, 'single'),
  ('Мединский курс (Том 4)', '6', 'عَابِسٌ', 'Хмурый', 31, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِتَّصَلَ/يَتَّصِلُ', 'Соединиться', 32, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِتَّجَهَ/يَتَّجِهُ', 'Направиться', 33, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِدَّعَى/يَدَّعِي', 'Притязать, претендовать', 34, 'single'),
  ('Мединский курс (Том 4)', '6', 'عَضَّ/يَعَضُّ', 'Кусать', 35, 'single'),
  ('Мединский курс (Том 4)', '6', 'خَلِيلٌ', 'Друг', 36, 'singular'),
  ('Мединский курс (Том 4)', '6', 'أَخِلَّاءُ', 'Друзья', 36, 'plural'),
  ('Мединский курс (Том 4)', '6', 'اِصْطَفَى/يَصْطَفِي', 'Избрать', 37, 'single'),
  ('Мединский курс (Том 4)', '6', 'اِتَّخَذَ/يَتَّخِذُ', 'Брать, предпринять, назначать', 38, 'single'),
  ('Мединский курс (Том 4)', '6', 'ثُعْبَانٌ', 'Змея', 39, 'singular'),
  ('Мединский курс (Том 4)', '6', 'ثَعَابِينُ', 'Змеи', 39, 'plural'),
  ('Мединский курс (Том 4)', '6', 'مُبِينٌ', 'Ясный', 40, 'single'),
  ('Мединский курс (Том 4)', '6', 'حَذِرٌ', 'Осторожный', 41, 'single'),
  ('Мединский курс (Том 4)', '6', 'رَزَقَ/يَرْزُقُ', 'Наделить', 42, 'single'),
  ('Мединский курс (Том 4)', '6', 'عَبَسَ/يَعْبِسُ', 'Хмуриться', 43, 'single')
) as source(course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form)
where not exists (
  select 1
  from public.words
  where course_name = 'Мединский курс (Том 4)'
    and lesson_number = '6'
);

do $$
declare
  l1_records integer;
  l2_records integer;
  l3_records integer;
  l4_records integer;
  l5_records integer;
  l6_records integer;
  l6_rows integer;
  l6_single integer;
  l6_singular integer;
  l6_plural integer;
  l6_pairs integer;
begin
  select count(*) into l1_records from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '1';

  select count(*) into l2_records from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '2';

  select count(*) into l3_records from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '3';

  select count(*) into l4_records from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '4';

  select count(*) into l5_records from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '5';

  select
    count(*),
    count(distinct dictionary_row),
    count(*) filter (where dictionary_form = 'single'),
    count(*) filter (where dictionary_form = 'singular'),
    count(*) filter (where dictionary_form = 'plural')
  into l6_records, l6_rows, l6_single, l6_singular, l6_plural
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '6';

  select count(*)
  into l6_pairs
  from (
    select dictionary_row
    from public.words
    where course_name = 'Мединский курс (Том 4)' and lesson_number = '6'
    group by dictionary_row
    having count(*) filter (where dictionary_form = 'singular') = 1
       and count(*) filter (where dictionary_form = 'plural') = 1
  ) pairs;

  if l1_records <> 109
    or l2_records <> 77
    or l3_records <> 45
    or l4_records <> 81
    or l5_records <> 34
    or l6_records <> 46
    or l6_rows <> 43
    or l6_single <> 40
    or l6_singular <> 3
    or l6_plural <> 3
    or l6_pairs <> 3 then
    raise exception
      'Book 4 lessons 1-6 verification failed: l1 %, l2 %, l3 %, l4 %, l5 %, l6 %/%/%/%/% pairs %',
      l1_records,
      l2_records,
      l3_records,
      l4_records,
      l5_records,
      l6_records,
      l6_rows,
      l6_single,
      l6_singular,
      l6_plural,
      l6_pairs;
  end if;
end
$$;

commit;
