do $migration$
begin
  if not exists (
    select 1
    from public.words
    where id = 2122
      and course_name = 'Мединский курс (Том 1)'
      and lesson_number = '14'
      and word_ar in (
        'وَعَلَيْكُمُ السَّلَامُ وَرَحْمَةُ اللهِ وَبَرَكَاتُهُ',
        'وَعَلَيْكُمُ السَّلَامُ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ'
      )
  ) then
    raise exception 'Unexpected source value for words.id 2122';
  end if;

  if not exists (
    select 1
    from public.words
    where id = 2124
      and course_name = 'Мединский курс (Том 1)'
      and lesson_number = '14'
      and word_ar in ('شَفَاهُ اللهُ', 'شَفَاهُ اللَّهُ')
  ) then
    raise exception 'Unexpected source value for words.id 2124';
  end if;

  if not exists (
    select 1
    from public.words
    where id = 2138
      and course_name = 'Мединский курс (Том 1)'
      and lesson_number = '14'
      and word_ar in ('يَهْدِيَهُمَا اللهُ', 'يَهْدِيهِمَا اللَّهُ')
  ) then
    raise exception 'Unexpected source value for words.id 2138';
  end if;

  update public.words
  set word_ar = 'وَعَلَيْكُمُ السَّلَامُ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ'
  where id = 2122
    and course_name = 'Мединский курс (Том 1)'
    and lesson_number = '14'
    and word_ar = 'وَعَلَيْكُمُ السَّلَامُ وَرَحْمَةُ اللهِ وَبَرَكَاتُهُ';

  update public.words
  set word_ar = 'شَفَاهُ اللَّهُ'
  where id = 2124
    and course_name = 'Мединский курс (Том 1)'
    and lesson_number = '14'
    and word_ar = 'شَفَاهُ اللهُ';

  update public.words
  set word_ar = 'يَهْدِيهِمَا اللَّهُ'
  where id = 2138
    and course_name = 'Мединский курс (Том 1)'
    and lesson_number = '14'
    and word_ar = 'يَهْدِيَهُمَا اللهُ';

  if (select word_ar from public.words where id = 2122) <> 'وَعَلَيْكُمُ السَّلَامُ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ'
    or (select word_ar from public.words where id = 2124) <> 'شَفَاهُ اللَّهُ'
    or (select word_ar from public.words where id = 2138) <> 'يَهْدِيهِمَا اللَّهُ'
  then
    raise exception 'Book 1 lesson 14 harakat correction verification failed';
  end if;
end
$migration$;
