alter table public.words
  add column if not exists dictionary_row integer,
  add column if not exists dictionary_form text;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.words'::regclass
      and conname = 'words_dictionary_form_check'
  ) then
    alter table public.words
      add constraint words_dictionary_form_check
      check (dictionary_form is null or dictionary_form in ('single', 'singular', 'plural'));
  end if;
end
$$;

create index if not exists words_dictionary_source_row_idx
  on public.words (course_name, lesson_number, dictionary_row, id);

comment on column public.words.dictionary_row is
  'Optional source-table row number. Used to reproduce photographed dictionary rows exactly.';

comment on column public.words.dictionary_form is
  'Optional source-table form marker: single, singular, or plural.';
