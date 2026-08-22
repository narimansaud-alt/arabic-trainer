-- Correct the Book 4 dictionary lesson offset and import application lesson 5.
-- Book 4 starts with printed lesson 18, so the canonical mapping is:
-- printed 18 -> app 1, 19 -> 2, 20 -> 3, 21 -> 4, 22 -> 5.
--
-- The 81 records currently in app lesson 3 came from the five photographs of
-- printed lesson 21, pages 169-173. Move those records to app lesson 4 while
-- preserving their IDs. Printed lesson 20 has not been supplied, so app lesson
-- 3 is deliberately left empty rather than populated speculatively.
--
-- App lesson 5 is transcribed from the three photographs of printed lesson 22,
-- pages 174-176. Rows follow the photographs from top to bottom. The plural of
-- جِسْرٌ has its own Russian plural translation for list and training modes.

begin;

do $$
declare
  l3_records integer;
  l3_rows integer;
  l3_single integer;
  l3_singular integer;
  l3_plural integer;
  l4_records integer;
  l4_placeholders integer;
  l4_rows integer;
  l4_single integer;
  l4_singular integer;
  l4_plural integer;
  l5_records integer;
  l5_placeholders integer;
  l5_rows integer;
  l5_single integer;
  l5_singular integer;
  l5_plural integer;
begin
  select
    count(*),
    count(distinct dictionary_row),
    count(*) filter (where dictionary_form = 'single'),
    count(*) filter (where dictionary_form = 'singular'),
    count(*) filter (where dictionary_form = 'plural')
  into l3_records, l3_rows, l3_single, l3_singular, l3_plural
  from public.words
  where course_name = 'Мединский курс (Том 4)'
    and lesson_number = '3';

  if not (
    l3_records = 0
    or (
      l3_records = 81
      and l3_rows = 65
      and l3_single = 49
      and l3_singular = 16
      and l3_plural = 16
    )
  ) then
    raise exception
      'Unexpected Book 4 lesson 3 state before renumbering: % records, % rows, % single, % singular, % plural',
      l3_records, l3_rows, l3_single, l3_singular, l3_plural;
  end if;

  select
    count(*),
    count(*) filter (where dictionary_row is null and dictionary_form is null),
    count(distinct dictionary_row),
    count(*) filter (where dictionary_form = 'single'),
    count(*) filter (where dictionary_form = 'singular'),
    count(*) filter (where dictionary_form = 'plural')
  into l4_records, l4_placeholders, l4_rows, l4_single, l4_singular, l4_plural
  from public.words
  where course_name = 'Мединский курс (Том 4)'
    and lesson_number = '4';

  if not (
    l4_records = 0
    or (l4_records = 6 and l4_placeholders = 6)
    or (
      l4_records = 81
      and l4_rows = 65
      and l4_single = 49
      and l4_singular = 16
      and l4_plural = 16
    )
  ) then
    raise exception
      'Unexpected Book 4 lesson 4 state before renumbering: % records, % placeholders, % rows, % single, % singular, % plural',
      l4_records, l4_placeholders, l4_rows, l4_single, l4_singular, l4_plural;
  end if;

  if l3_records = 81 and l4_records = 81 then
    raise exception 'Book 4 printed lesson 21 exists in both app lessons 3 and 4';
  end if;

  select
    count(*),
    count(*) filter (where dictionary_row is null and dictionary_form is null),
    count(distinct dictionary_row),
    count(*) filter (where dictionary_form = 'single'),
    count(*) filter (where dictionary_form = 'singular'),
    count(*) filter (where dictionary_form = 'plural')
  into l5_records, l5_placeholders, l5_rows, l5_single, l5_singular, l5_plural
  from public.words
  where course_name = 'Мединский курс (Том 4)'
    and lesson_number = '5';

  if not (
    l5_records = 0
    or (l5_records = 6 and l5_placeholders = 6)
    or (
      l5_records = 34
      and l5_rows = 33
      and l5_single = 32
      and l5_singular = 1
      and l5_plural = 1
    )
  ) then
    raise exception
      'Unexpected Book 4 lesson 5 state before import: % records, % placeholders, % rows, % single, % singular, % plural',
      l5_records, l5_placeholders, l5_rows, l5_single, l5_singular, l5_plural;
  end if;
end
$$;

delete from public.words
where course_name = 'Мединский курс (Том 4)'
  and lesson_number = '4'
  and dictionary_row is null
  and dictionary_form is null;

update public.words
set lesson_number = '4'
where course_name = 'Мединский курс (Том 4)'
  and lesson_number = '3';

delete from public.words
where course_name = 'Мединский курс (Том 4)'
  and lesson_number = '5'
  and dictionary_row is null
  and dictionary_form is null;

insert into public.words
  (course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form)
select *
from (values
  ('Мединский курс (Том 4)', '5', 'اِنْكَسَرَ/يَنْكَسِرُ', 'Сломаться, разбиться', 1, 'single'),
  ('Мединский курс (Том 4)', '5', 'قَبِلَ/يَقْبَلُ', 'Принять, согласиться', 2, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْقَطَعَ/يَنْقَطِعُ', 'Быть отрезанным, прерваться', 3, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْقِطَاعٌ', 'Прекращение, перерыв', 4, 'single'),
  ('Мединский курс (Том 4)', '5', 'كَهْرَبَاءُ', 'Электричество', 5, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِسْتَمَرَّ/يَسْتَمِرُّ', 'Продолжаться, продолжать', 6, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْقِلَابٌ', 'Перемена; переворот', 7, 'single'),
  ('Мединский курс (Том 4)', '5', 'تَوَقَّفَ/يَتَوَقَّفُ', 'Остановиться', 8, 'single'),
  ('Мединский курс (Том 4)', '5', 'مُرُورٌ', 'Движение, течение', 9, 'single'),
  ('Мединский курс (Том 4)', '5', 'مُنْعَطَفٌ', 'Переулок; поворот', 10, 'single'),
  ('Мединский курс (Том 4)', '5', 'جِسْرٌ', 'Мост', 11, 'singular'),
  ('Мединский курс (Том 4)', '5', 'جُسُورٌ', 'Мосты', 11, 'plural'),
  ('Мединский курс (Том 4)', '5', 'عَنِيفٌ', 'Жестокий', 12, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْخَلَعَ/يَنْخَلِعُ', 'Отделиться', 13, 'single'),
  ('Мединский курс (Том 4)', '5', 'تَكَسَّرَ/يَتَكَسَّرُ', 'Разбиться', 14, 'single'),
  ('Мединский курс (Том 4)', '5', 'زُجَاجٌ', 'Стекло', 15, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْكَسَفَ/يَنْكَسِفُ', 'Затмеваться', 16, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْجَلَى/يَنْجَلِي', 'Проясниться', 17, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْصَرَفَ/يَنْصَرِفُ', 'Удалиться; склоняться (грам.)', 18, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْفَتَحَ/يَنْفَتِحُ', 'Быть открытым', 19, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْشَقَّ/يَنْشَقُّ', 'Расколоться', 20, 'single'),
  ('Мединский курс (Том 4)', '5', 'هَزَمَ/يَهْزِمُ', 'Разбить, победить', 21, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْهَزَمَ/يَنْهَزِمُ', 'Проиграть', 22, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْطَفَأَ/يَنْطَفِئُ', 'Погаснуть', 23, 'single'),
  ('Мединский курс (Том 4)', '5', 'اِنْفِجَارٌ', 'Взрыв; извержение', 24, 'single'),
  ('Мединский курс (Том 4)', '5', 'مُنْصَرِمٌ', 'Истёкший', 25, 'single'),
  ('Мединский курс (Том 4)', '5', 'بِضْعَةٌ', 'Несколько (от 3 до 9 или 10)', 26, 'single'),
  ('Мединский курс (Том 4)', '5', 'ظَهَرَ/يَظْهَرُ', 'Появиться', 27, 'single'),
  ('Мединский курс (Том 4)', '5', 'نَفَعَ/يَنْفَعُ', 'Принести пользу, быть полезным', 28, 'single'),
  ('Мединский курс (Том 4)', '5', 'لَوْلَا .... لَـ....', 'Если бы не..., то бы...', 29, 'single'),
  ('Мединский курс (Том 4)', '5', 'هَلَكَ/يَهْلِكُ', 'Погибнуть', 30, 'single'),
  ('Мединский курс (Том 4)', '5', 'حَيَاءٌ', 'Стыд, стеснительность', 31, 'single'),
  ('Мединский курс (Том 4)', '5', 'مُسْتَعْجِلٌ', 'Спешащий; срочный', 32, 'single'),
  ('Мединский курс (Том 4)', '5', 'تَوَلَّى/يَتَوَلَّى', 'Уйти; стать правителем', 33, 'single')
) as source(course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form)
where not exists (
  select 1
  from public.words
  where course_name = 'Мединский курс (Том 4)'
    and lesson_number = '5'
);

do $$
declare
  l1_records integer;
  l1_rows integer;
  l2_records integer;
  l2_rows integer;
  l3_records integer;
  l4_records integer;
  l4_rows integer;
  l4_single integer;
  l4_singular integer;
  l4_plural integer;
  l5_records integer;
  l5_rows integer;
  l5_single integer;
  l5_singular integer;
  l5_plural integer;
  l5_pairs integer;
begin
  select count(*), count(distinct dictionary_row)
  into l1_records, l1_rows
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '1';

  select count(*), count(distinct dictionary_row)
  into l2_records, l2_rows
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '2';

  select count(*)
  into l3_records
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '3';

  select
    count(*),
    count(distinct dictionary_row),
    count(*) filter (where dictionary_form = 'single'),
    count(*) filter (where dictionary_form = 'singular'),
    count(*) filter (where dictionary_form = 'plural')
  into l4_records, l4_rows, l4_single, l4_singular, l4_plural
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '4';

  select
    count(*),
    count(distinct dictionary_row),
    count(*) filter (where dictionary_form = 'single'),
    count(*) filter (where dictionary_form = 'singular'),
    count(*) filter (where dictionary_form = 'plural')
  into l5_records, l5_rows, l5_single, l5_singular, l5_plural
  from public.words
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '5';

  select count(*)
  into l5_pairs
  from (
    select dictionary_row
    from public.words
    where course_name = 'Мединский курс (Том 4)' and lesson_number = '5'
    group by dictionary_row
    having count(*) filter (where dictionary_form = 'singular') = 1
       and count(*) filter (where dictionary_form = 'plural') = 1
  ) pairs;

  if l1_records <> 109 or l1_rows <> 90
    or l2_records <> 77 or l2_rows <> 64
    or l3_records <> 0
    or l4_records <> 81 or l4_rows <> 65
    or l4_single <> 49 or l4_singular <> 16 or l4_plural <> 16
    or l5_records <> 34 or l5_rows <> 33
    or l5_single <> 32 or l5_singular <> 1 or l5_plural <> 1
    or l5_pairs <> 1 then
    raise exception
      'Book 4 lessons 1-5 verification failed: l1 %/%, l2 %/%, l3 %, l4 %/%/%/%/%, l5 %/%/%/%/% pairs %',
      l1_records, l1_rows,
      l2_records, l2_rows,
      l3_records,
      l4_records, l4_rows, l4_single, l4_singular, l4_plural,
      l5_records, l5_rows, l5_single, l5_singular, l5_plural, l5_pairs;
  end if;
end
$$;

commit;
