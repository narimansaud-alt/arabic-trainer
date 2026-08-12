-- Keep already-applied lesson migrations immutable while correcting the
-- malformed combination of an Arabic question mark followed by a full stop.
update public.rules
set
  rule_ar = replace(rule_ar, '؟.', '؟'),
  summary = replace(summary, '؟.', '؟'),
  content = replace(content, '؟.', '؟')
where course_name = 'Мединский курс (Том 1)'
  and (
    rule_ar like '%؟.%'
    or summary like '%؟.%'
    or content like '%؟.%'
  );

do $$
begin
  if exists (
    select 1
    from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and concat_ws(E'\n', rule_ar, summary, content) like '%؟.%'
  ) then
    raise exception 'Book 1 still contains malformed Arabic question punctuation';
  end if;
end
$$;
