-- Complete same-cell Russian glosses for the last four structural tables in Book 1.
-- The adjacent translation columns are retained; no source or rule wording is changed.

begin;

create temporary table book1_structural_glosses (
  lesson_number text not null,
  sort_order integer not null,
  label text not null,
  old_text text not null,
  new_text text not null
) on commit drop;

insert into book1_structural_glosses values
('12', 3, 'male subject example',
$old$<td><span dir="rtl" lang="ar">خَرَجَ مُحَمَّدٌ</span></td>$old$,
$new$<td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">خَرَجَ مُحَمَّدٌ</span><span class="rule-table-ru">Мухаммад вышел.</span></td>$new$),
('12', 3, 'female subject example',
$old$<td><span dir="rtl" lang="ar">خَرَجَتْ آمِنَةُ</span></td>$old$,
$new$<td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">خَرَجَتْ آمِنَةُ</span><span class="rule-table-ru">Амина вышла.</span></td>$new$),
('12', 4, 'relative pronoun masculine',
$old$<td><span dir="rtl" lang="ar">الَّذِي</span></td>$old$,
$new$<td><span class="rule-table-ar" dir="rtl" lang="ar">الَّذِي</span><span class="rule-table-ru">который</span></td>$new$),
('12', 4, 'relative pronoun feminine',
$old$<td><span dir="rtl" lang="ar">الَّتِي</span></td>$old$,
$new$<td><span class="rule-table-ar" dir="rtl" lang="ar">الَّتِي</span><span class="rule-table-ru">которая</span></td>$new$),
('14', 2, 'we pronoun',
$old$<td><span dir="rtl" lang="ar">نَحْنُ</span></td>$old$,
$new$<td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span><span class="rule-table-ru">мы</span></td>$new$),
('14', 2, 'you masculine plural pronoun',
$old$<td><span dir="rtl" lang="ar">أَنْتُمْ</span></td>$old$,
$new$<td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы — группа мужчин</span></td>$new$),
('14', 2, 'you feminine plural pronoun',
$old$<td><span dir="rtl" lang="ar">أَنْتُنَّ</span></td>$old$,
$new$<td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы — группа женщин</span></td>$new$),
('15', 2, 'kaaf masculine singular',
$old$<td><span dir="rtl" lang="ar">ـكَ</span></td>$old$,
$new$<td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">ـكَ</span><span class="rule-table-ru">твой / обращение к одному мужчине</span></td>$new$),
('15', 2, 'kaaf feminine singular',
$old$<td><span dir="rtl" lang="ar">ـكِ</span></td>$old$,
$new$<td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">ـكِ</span><span class="rule-table-ru">твой / обращение к одной женщине</span></td>$new$),
('15', 2, 'kaaf masculine plural',
$old$<td><span dir="rtl" lang="ar">ـكُمْ</span></td>$old$,
$new$<td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">ـكُمْ</span><span class="rule-table-ru">ваш / обращение к группе мужчин</span></td>$new$),
('15', 2, 'kaaf feminine plural',
$old$<td><span dir="rtl" lang="ar">ـكُنَّ</span></td>$old$,
$new$<td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">ـكُنَّ</span><span class="rule-table-ru">ваш / обращение к группе женщин</span></td>$new$);

do $migration$
declare
  replacement record;
  changed_rows integer;
begin
  for replacement in
    select * from book1_structural_glosses order by lesson_number::integer, sort_order, label
  loop
    update public.rules
    set content = replace(content, replacement.old_text, replacement.new_text)
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = replacement.lesson_number
      and sort_order = replacement.sort_order
      and strpos(content, replacement.old_text) > 0;

    get diagnostics changed_rows = row_count;
    if changed_rows <> 1 then
      raise exception 'Book 1 structural gloss failed: lesson %, rule %, % (matched % rows)',
        replacement.lesson_number, replacement.sort_order, replacement.label, changed_rows;
    end if;
  end loop;
end;
$migration$;

commit;
