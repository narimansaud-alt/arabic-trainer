import fs from 'node:fs';
import assert from 'node:assert/strict';
const source = JSON.parse(fs.readFileSync('data/book4-dictionary-lessons9-17.json', 'utf8'));
const quote = s => "'" + String(s).normalize('NFC').replaceAll("'", "''") + "'";
const tuples = source.lessons.flatMap(l => l.rows.flatMap(([page, ar, ru, plural, pluralRu], i) => {
  assert.equal(l.printedLesson - 17, l.lesson);
  return [[l.lesson, ar, ru, i + 1, plural ? 'singular' : 'single'],
    ...(plural ? [[l.lesson, plural, pluralRu, i + 1, 'plural']] : [])]
    .map(([lesson, word, meaning, row, form]) => '  (' + [source.course, String(lesson), word, meaning].map(quote).concat(row, quote(form)).join(', ') + ')');
}));
const sql = `-- Owner photos: printed lessons 26-34, pages 185-211.
-- Application lessons 9-17: printed lesson minus 17.
-- Generated from data/book4-dictionary-lessons9-17.json.
-- Only the 54 explicitly verified corrupt placeholders are replaced.
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
  (3556, '9', 'ر', 'ُ'),
  (3557, '9', 'د', 'َ'),
  (3558, '9', 'و', 'َ'),
  (3559, '9', 'ز', 'َ'),
  (3560, '9', 'ك', 'ُ'),
  (3561, '9', 'أ', 'َ'),
  (3562, '10', 'إ', 'ِ'),
  (3563, '10', 'إ', 'ِ'),
  (3564, '10', 'ض', 'َ'),
  (3565, '10', 'ر', 'َ'),
  (3566, '10', 'أ', 'َ'),
  (3567, '10', 'س', 'ُ'),
  (3568, '11', 'م', 'َ'),
  (3569, '11', 'ش', 'ُ'),
  (3570, '11', 'ض', 'َ'),
  (3571, '11', 'ج', 'ُ'),
  (3572, '11', 'ع', 'َ'),
  (3573, '11', 'ن', 'َ'),
  (3574, '12', 'م', 'َ'),
  (3575, '12', 'ر', 'َ'),
  (3576, '12', 'ا', 'ِ'),
  (3577, '12', 'ط', 'َ'),
  (3578, '12', 'ع', 'ِ'),
  (3579, '12', 'أ', 'َ'),
  (3580, '13', 'ت', 'َ'),
  (3581, '13', 'ع', 'ِ'),
  (3582, '13', 'ل', 'ِ'),
  (3583, '13', 'م', 'َ'),
  (3584, '13', 'أ', 'َ'),
  (3585, '13', 'ع', 'ِ'),
  (3586, '14', 'ح', 'َ'),
  (3587, '14', 'م', 'ُ'),
  (3588, '14', 'ب', 'َ'),
  (3589, '14', 'م', 'ُ'),
  (3590, '14', 'م', 'ُ'),
  (3591, '14', 'ر', 'َ'),
  (3592, '15', 'ا', 'ِ'),
  (3593, '15', 'إ', 'ِ'),
  (3594, '15', 'خ', 'َ'),
  (3595, '15', 'أ', 'َ'),
  (3596, '15', 'ك', 'ُ'),
  (3597, '15', 'ق', 'َ'),
  (3598, '16', 'ن', 'ُ'),
  (3599, '16', 'ل', 'َ'),
  (3600, '16', 'ل', 'َ'),
  (3601, '16', 'ك', 'َ'),
  (3602, '16', 'ت', 'َ'),
  (3603, '16', 'ق', 'َ'),
  (3604, '17', 'م', 'َ'),
  (3605, '17', 'م', 'َ'),
  (3606, '17', 'ك', 'َ'),
  (3607, '17', 'أ', 'َ'),
  (3608, '17', 'ك', 'َ'),
  (3609, '17', 'ت', 'َ');

create temporary table book4_import_untouched on commit drop as
select id, to_jsonb(w) payload from public.words w
where not (course_name = 'Мединский курс (Том 4)' and lesson_number in ('9', '10', '11', '12', '13', '14', '15', '16', '17'));

do $guard$
declare l text; n integer; legacy integer;
begin
  foreach l in array array['9', '10', '11', '12', '13', '14', '15', '16', '17'] loop
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
     from public.words where course_name = 'Мединский курс (Том 4)' and lesson_number in ('9', '10', '11', '12', '13', '14', '15', '16', '17')
     except all select * from book4_import_source)
    union all
    (select * from book4_import_source
     except all select course_name, lesson_number, word_ar, word_ru, dictionary_row, dictionary_form
     from public.words where course_name = 'Мединский курс (Том 4)' and lesson_number in ('9', '10', '11', '12', '13', '14', '15', '16', '17'))
  ) then raise exception 'Book 4 lessons 9-17 failed exact source comparison'; end if;
  if exists (
    (select id, to_jsonb(w) from public.words w
     where not (course_name = 'Мединский курс (Том 4)' and lesson_number in ('9', '10', '11', '12', '13', '14', '15', '16', '17'))
     except all select * from book4_import_untouched)
    union all
    (select * from book4_import_untouched
     except all select id, to_jsonb(w) from public.words w
     where not (course_name = 'Мединский курс (Том 4)' and lesson_number in ('9', '10', '11', '12', '13', '14', '15', '16', '17')))
  ) then raise exception 'Unrelated vocabulary changed; rolling back'; end if;
end
$verify$;
commit;
`;
fs.writeFileSync('supabase/migrations/20260902220000_import_book4_dictionary_lessons09_17.sql', sql.normalize('NFC'));
