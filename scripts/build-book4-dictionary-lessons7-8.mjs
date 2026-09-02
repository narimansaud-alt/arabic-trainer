import fs from 'node:fs';
import assert from 'node:assert/strict';
const source = JSON.parse(fs.readFileSync('data/book4-dictionary-lessons7-8.json', 'utf8'));
const quote = s => "'" + String(s).normalize('NFC').replaceAll("'", "''") + "'";
const tuples = source.lessons.flatMap(l => l.rows.flatMap(([page, ar, ru, plural, pluralRu], i) => {
  assert.equal(l.printedLesson - 17, l.lesson);
  return [[l.lesson, ar, ru, i + 1, plural ? 'singular' : 'single'],
    ...(plural ? [[l.lesson, plural, pluralRu, i + 1, 'plural']] : [])]
    .map(([lesson, word, meaning, row, form]) => '  (' + [source.course, String(lesson), word, meaning].map(quote).concat(row, quote(form)).join(', ') + ')');
}));
const sql = `-- Owner photos: printed lessons 24-25, pages 180-184.
-- Application lessons 7-8: printed lesson minus 17.
-- Generated from data/book4-dictionary-lessons7-8.json.
-- Only the twelve explicitly verified corrupt placeholders are replaced.
-- No changes to student progress, other vocabulary, rules or books.
begin;

create temporary table book4_import_source (
  course_name text, lesson_number text, word_ar text, word_ru text,
  dictionary_row integer, dictionary_form text
) on commit drop;

insert into book4_import_source values
${tuples.join(',\n')};

create temporary table book4_import_legacy (
  id bigint, lesson_number text, word_ar text, word_ru text
) on commit drop;
insert into book4_import_legacy values
  (3544, '7', 'ا', 'ِ'), (3545, '7', 'ا', 'ِ'),
  (3546, '7', 'ا', 'ِ'), (3547, '7', 'ا', 'ِ'),
  (3548, '7', 'و', 'َ'), (3549, '7', 'و', 'َ'),
  (3550, '8', 'ا', 'ِ'), (3551, '8', 'ا', 'ِ'),
  (3552, '8', 'ا', 'ِ'), (3553, '8', 'ا', 'ِ'),
  (3554, '8', 'ق', 'َ'), (3555, '8', 'ف', 'َ');

create temporary table book4_import_untouched on commit drop as
select id, to_jsonb(w) payload from public.words w
where not (course_name = 'Мединский курс (Том 4)' and lesson_number in ('7', '8'));

do $guard$
declare l text; n integer; legacy integer;
begin
  foreach l in array array['7', '8'] loop
    select count(*) into n from public.words
    where course_name = 'Мединский курс (Том 4)' and lesson_number = l;
    select count(*) into legacy from public.words w
    join book4_import_legacy p using (id, lesson_number, word_ar, word_ru)
    where w.course_name = 'Мединский курс (Том 4)' and w.lesson_number = l
      and w.dictionary_row is null and w.dictionary_form is null;
    if n = 0 or (n = 6 and legacy = 6) then continue; end if;
    if exists (
      (select course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form
       from public.words where course_name = 'Мединский курс (Том 4)' and lesson_number = l
       except all select * from book4_import_source where lesson_number = l)
      union all
      (select * from book4_import_source where lesson_number = l
       except all select course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form
       from public.words where course_name = 'Мединский курс (Том 4)' and lesson_number = l)
    ) then raise exception 'Unexpected Book 4 lesson % contents; aborting safely', l; end if;
  end loop;
end
$guard$;

delete from public.words w using book4_import_legacy p
where w.id = p.id and w.lesson_number = p.lesson_number
  and w.word_ar = p.word_ar and w.word_ru = p.word_ru
  and w.course_name = 'Мединский курс (Том 4)'
  and w.dictionary_row is null and w.dictionary_form is null;

insert into public.words (course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form)
select s.* from book4_import_source s
where not exists (
  select 1 from public.words w
  where w.course_name = s.course_name and w.lesson_number = s.lesson_number
)
order by lesson_number, dictionary_row, case dictionary_form when 'plural' then 1 else 0 end;

do $verify$
begin
  if exists (
    (select course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form
     from public.words where course_name = 'Мединский курс (Том 4)' and lesson_number in ('7', '8')
     except all select * from book4_import_source)
    union all
    (select * from book4_import_source
     except all select course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form
     from public.words where course_name = 'Мединский курс (Том 4)' and lesson_number in ('7', '8'))
  ) then raise exception 'Book 4 lessons 7-8 failed exact source comparison'; end if;
  if exists (
    (select id, to_jsonb(w) from public.words w
     where not (course_name = 'Мединский курс (Том 4)' and lesson_number in ('7', '8'))
     except all select * from book4_import_untouched)
    union all
    (select * from book4_import_untouched
     except all select id, to_jsonb(w) from public.words w
     where not (course_name = 'Мединский курс (Том 4)' and lesson_number in ('7', '8')))
  ) then raise exception 'Unrelated vocabulary changed; rolling back'; end if;
end
$verify$;
commit;
`;
fs.writeFileSync('supabase/migrations/20260902190000_import_book4_dictionary_lessons07_08.sql', sql.normalize('NFC'));
