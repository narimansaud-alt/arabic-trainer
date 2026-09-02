-- Owner photos: printed lessons 24-25, pages 180-184.
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
  ('Мединский курс (Том 4)', '7', 'اِعْوَجَّ/يَعْوَجُّ', 'Искривиться', 1, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِعْوِجَاجٌ', 'Кривизна', 2, 'single'),
  ('Мединский курс (Том 4)', '7', 'تَمَكَّنَ/يَتَمَكَّنُ', 'Укрепиться; овладеть; получить возможность', 3, 'single'),
  ('Мединский курс (Том 4)', '7', 'أَغْضَبَ/يُغْضِبُ', 'Вызвать гнев', 4, 'single'),
  ('Мединский курс (Том 4)', '7', 'سُخْرِيَةٌ', 'Издевательство', 5, 'single'),
  ('Мединский курс (Том 4)', '7', 'زَهَا/يَزْهُو', 'Сиять, блистать; разрастись', 6, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِسْوَدَّ/يَسْوَدُّ', 'Почернеть', 7, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِصْفَرَّ/يَصْفَرُّ', 'Пожелтеть', 8, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِبْيَضَّ/يَبْيَضُّ', 'Побелеть', 9, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِخْضَرَّ/يَخْضَرُّ', 'Позеленеть', 10, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِحْمَرَّ/يَحْمَرُّ', 'Покраснеть', 11, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِحْمِرَارٌ', 'Краснота, покраснение', 12, 'single'),
  ('Мединский курс (Том 4)', '7', 'مُحْمَرٌّ', 'Покрасневший; поджаренный', 13, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِشْتَقَّ/يَشْتَقُّ', 'Произойти', 14, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِنْفَضَّ/يَنْفَضُّ', 'Расходиться', 15, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِحْتَرَقَ/يَحْتَرِقُ', 'Сгореть', 16, 'single'),
  ('Мединский курс (Том 4)', '7', 'فَوْرَ', 'Сразу же...', 17, 'single'),
  ('Мединский курс (Том 4)', '7', 'اِسْتَاكَ/يَسْتَاكُ', 'Использовать мисвак', 18, 'single'),
  ('Мединский курс (Том 4)', '7', 'مِنْجَلٌ', 'Серп', 19, 'singular'),
  ('Мединский курс (Том 4)', '7', 'مَنَاجِلُ', 'Серпы', 19, 'plural'),
  ('Мединский курс (Том 4)', '7', 'عَسَى', 'Возможно (как с надеждой, так и с опаской)', 20, 'single'),
  ('Мединский курс (Том 4)', '7', 'وَجْنَةٌ', 'Щека', 21, 'singular'),
  ('Мединский курс (Том 4)', '7', 'وَجَنَاتٌ', 'Щёки', 21, 'plural'),
  ('Мединский курс (Том 4)', '8', 'أَخَّرَ/يُؤَخِّرُ', 'Перенести, отложить, задержать', 1, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَلْقَى/يَسْتَلْقِي', 'Лечь на спину', 2, 'single'),
  ('Мединский курс (Том 4)', '8', 'قَفًا', 'Затылок', 3, 'singular'),
  ('Мединский курс (Том 4)', '8', 'أَقْفِيَةٌ، أَقْفَاءٌ', 'Затылки', 3, 'plural'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَحَمَّ/يَسْتَحِمُّ', 'Искупаться (в ванне, в бане)', 4, 'single'),
  ('Мединский курс (Том 4)', '8', 'أَفْطَرَ/يُفْطِرُ', 'Завтракать; разговеться', 5, 'single'),
  ('Мединский курс (Том 4)', '8', 'حَرَّمَ/يُحَرِّمُ', 'Запретить', 6, 'single'),
  ('Мединский курс (Том 4)', '8', 'تَظَالَمَ/يَتَظَالَمُ', 'Обижать друг друга', 7, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَهْدَى/يَسْتَهْدِي', 'Попросить верного пути', 8, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَطْعَمَ/يَسْتَطْعِمُ', 'Попросить накормить', 9, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَكْسَى/يَسْتَكْسِي', 'Попросить одеть', 10, 'single'),
  ('Мединский курс (Том 4)', '8', 'أَخْطَأَ/يُخْطِئُ', 'Ошибиться', 11, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَحْيَا/يَسْتَحْيِي', 'Стесняться', 12, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَقْرَضَ/يَسْتَقْرِضُ', 'Попросить в долг', 13, 'single'),
  ('Мединский курс (Том 4)', '8', 'أَسَرَّ/يُسِرُّ', 'Шептать; сказать секрет, радовать', 14, 'single'),
  ('Мединский курс (Том 4)', '8', 'أَقْرَضَ/يُقْرِضُ', 'Дать в долг', 15, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِقْتَرَضَ/يَقْتَرِضُ', 'Брать в долг', 16, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَعَدَّ/يَسْتَعِدُّ', 'Готовиться', 17, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَقَالَ/يَسْتَقِيلُ', 'Уволиться', 18, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَفَادَ/يَسْتَفِيدُ', 'Получить пользу', 19, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتِرَاحَةٌ', 'Отдых, перемена', 20, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَأْجَرَ/يَسْتَأْجِرُ', 'Арендовать, нанять', 21, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَسْلَمَ/يَسْتَسْلِمُ', 'Сдаться', 22, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَحَبَّ/يَسْتَحِبُّ', 'Быть желательным', 23, 'single'),
  ('Мединский курс (Том 4)', '8', 'اِسْتِعَانَةٌ', 'Просьба помощи', 24, 'single'),
  ('Мединский курс (Том 4)', '8', 'زَاهِرٌ', 'Цветущий', 25, 'single'),
  ('Мединский курс (Том 4)', '8', 'كَيْ، لِكَيْ', 'Чтобы...', 26, 'single'),
  ('Мединский курс (Том 4)', '8', 'لِكَيْلَا', 'Чтобы не...', 27, 'single'),
  ('Мединский курс (Том 4)', '8', 'حَاجَةٌ', 'Надобность, желание', 28, 'singular'),
  ('Мединский курс (Том 4)', '8', 'حَوَائِجُ', 'Надобности, желания', 28, 'plural'),
  ('Мединский курс (Том 4)', '8', 'اِسْتَفْسَرَ/يَسْتَفْسِرُ', 'Попросить объяснить', 29, 'single'),
  ('Мединский курс (Том 4)', '8', 'إِذَنْ', 'В таком случае', 30, 'single'),
  ('Мединский курс (Том 4)', '8', 'سِرَاجٌ', 'Светильник', 31, 'singular'),
  ('Мединский курс (Том 4)', '8', 'سُرُجٌ', 'Светильники', 31, 'plural'),
  ('Мединский курс (Том 4)', '8', 'بِسَاطٌ', 'Ковёр', 32, 'singular'),
  ('Мединский курс (Том 4)', '8', 'بُسُطٌ', 'Ковры', 32, 'plural'),
  ('Мединский курс (Том 4)', '8', 'كَسَا/يَكْسُو', 'Одевать', 33, 'single'),
  ('Мединский курс (Том 4)', '8', 'وَالٍ', 'Правитель, губернатор', 34, 'singular'),
  ('Мединский курс (Том 4)', '8', 'وُلَاةٌ', 'Правители, губернаторы', 34, 'plural'),
  ('Мединский курс (Том 4)', '8', 'مَاشٍ', 'Пеший', 35, 'singular'),
  ('Мединский курс (Том 4)', '8', 'مُشَاةٌ', 'Пешие', 35, 'plural'),
  ('Мединский курс (Том 4)', '8', 'رَامٍ', 'Стрелок', 36, 'singular'),
  ('Мединский курс (Том 4)', '8', 'رُمَاةٌ', 'Стрелки', 36, 'plural'),
  ('Мединский курс (Том 4)', '8', 'عَارٍ', 'Голый', 37, 'singular'),
  ('Мединский курс (Том 4)', '8', 'عُرَاةٌ', 'Голые', 37, 'plural'),
  ('Мединский курс (Том 4)', '8', 'غَازٍ', 'Воин', 38, 'singular'),
  ('Мединский курс (Том 4)', '8', 'غُزَاةٌ', 'Воины', 38, 'plural'),
  ('Мединский курс (Том 4)', '8', 'حَافٍ', 'Босой', 39, 'singular'),
  ('Мединский курс (Том 4)', '8', 'حُفَاةٌ', 'Босые', 39, 'plural');

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
