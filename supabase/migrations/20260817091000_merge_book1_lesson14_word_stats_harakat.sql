do $migration$
declare
  mapping record;
  expected_users integer;
  actual_users integer;
begin
  for mapping in
    select *
    from (
      values
        (
          'وَعَلَيْكُمُ السَّلَامُ وَرَحْمَةُ اللهِ وَبَرَكَاتُهُ'::text,
          'وَعَلَيْكُمُ السَّلَامُ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ'::text
        ),
        ('شَفَاهُ اللهُ'::text, 'شَفَاهُ اللَّهُ'::text),
        ('يَهْدِيَهُمَا اللهُ'::text, 'يَهْدِيهِمَا اللَّهُ'::text)
    ) as mappings(old_word, new_word)
  loop
    select count(distinct username)::integer
    into expected_users
    from public.word_stats
    where word_ar in (mapping.old_word, mapping.new_word);

    insert into public.word_stats as current_stat
      (username, word_ar, seen_count, is_favorite, level, next_review)
    select
      username,
      mapping.new_word,
      seen_count,
      is_favorite,
      level,
      next_review
    from public.word_stats
    where word_ar = mapping.old_word
    on conflict (username, word_ar) do update
    set
      seen_count = coalesce(current_stat.seen_count, 0) + coalesce(excluded.seen_count, 0),
      is_favorite = coalesce(current_stat.is_favorite, false) or coalesce(excluded.is_favorite, false),
      level = greatest(coalesce(current_stat.level, 1), coalesce(excluded.level, 1)),
      next_review = case
        when current_stat.next_review is null then excluded.next_review
        when excluded.next_review is null then current_stat.next_review
        else greatest(current_stat.next_review, excluded.next_review)
      end;

    delete from public.word_stats
    where word_ar = mapping.old_word;

    select count(*)::integer
    into actual_users
    from public.word_stats
    where word_ar = mapping.new_word;

    if actual_users <> expected_users then
      raise exception 'Progress merge failed for %: expected %, found %', mapping.new_word, expected_users, actual_users;
    end if;
  end loop;

  if exists (
    select 1
    from public.word_stats
    where word_ar in (
      'وَعَلَيْكُمُ السَّلَامُ وَرَحْمَةُ اللهِ وَبَرَكَاتُهُ',
      'شَفَاهُ اللهُ',
      'يَهْدِيَهُمَا اللهُ'
    )
  ) then
    raise exception 'Old word_stats keys remain after Book 1 lesson 14 harakat merge';
  end if;
end
$migration$;
