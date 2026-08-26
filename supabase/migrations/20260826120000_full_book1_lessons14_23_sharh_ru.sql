-- Complete the public Russian rendering of Book 1 lessons 14-23.
-- Controlling source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 23-36.

begin;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number in ('14', '15', '16', '17', '18', '19', '20', '21', '22', '23')
    and id in (
      1525, 1526, 1530, 1527, 1528,
      1531, 1532, 1533, 1534,
      1535,
      1537, 1538,
      1540, 1884, 1541,
      1543, 1544,
      1545,
      1546,
      1547, 1548
    );

  if v_count <> 21 then
    raise exception 'Expected 21 guarded Book 1 rules for lessons 14-23, found %', v_count;
  end if;
end;
$$;

-- The lesson-by-lesson source audit already preserved every printed explanation,
-- example, contrast and analysis in these semantic cards. Mark every complete
-- source block explicitly, while retaining the existing IDs and lesson split.
update public.rules as r
set content = regexp_replace(
  r.content,
  '<span class="rule-card-kicker">[^<]*</span>',
  '<span class="rule-card-kicker">' || v.source_label || '</span>'
)
from (values
  (1525::bigint, 'Полный текст шарха · страница 23'),
  (1526::bigint, 'Полный текст шарха · страница 23'),
  (1530::bigint, 'Полный текст шарха · страница 24'),
  (1527::bigint, 'Полный текст шарха · страницы 24–25'),
  (1528::bigint, 'Полный текст шарха · страница 25'),
  (1531::bigint, 'Полный текст шарха · страницы 26–27'),
  (1532::bigint, 'Полный текст шарха · страница 26'),
  (1533::bigint, 'Полный текст шарха · страница 27'),
  (1534::bigint, 'Полный текст шарха · страница 27'),
  (1535::bigint, 'Полный текст шарха · страница 28'),
  (1537::bigint, 'Полный текст шарха · страница 29'),
  (1538::bigint, 'Полный текст шарха · страница 29'),
  (1540::bigint, 'Полный текст шарха · страница 30'),
  (1884::bigint, 'Полный текст шарха · страница 30'),
  (1541::bigint, 'Полный текст шарха · страница 31'),
  (1543::bigint, 'Полный текст шарха · страница 32'),
  (1544::bigint, 'Полный текст шарха · страница 32'),
  (1545::bigint, 'Полный текст шарха · страницы 33–34'),
  (1546::bigint, 'Полный текст шарха · страницы 35–36'),
  (1547::bigint, 'Полный текст шарха · страница 36'),
  (1548::bigint, 'Полный текст шарха · страница 36')
) as v(id, source_label)
where r.id = v.id
  and r.course_name = 'Мединский курс (Том 1)'
  and r.content not like '%Полный текст шарха ·%';

-- Use a direct translation of the author's lesson-21 heading.
update public.rules
set content = replace(
  content,
  'Этот урок не вводит новую тему: автор последовательно повторяет пятнадцать ранее изученных положений. Ниже сохранены все пункты и примеры со страниц 33–34.',
  '<strong>Полный перевод:</strong> Этот урок — повторение некоторых предыдущих уроков. Ниже сохранены все пятнадцать пунктов и примеры автора со страниц 33–34.'
)
where id = 1545
  and course_name = 'Мединский курс (Том 1)'
  and lesson_number = '21';

-- Translate the prepositional examples where lesson 23 repeats them.
update public.rules
set content = replace(
  content,
  'Примеры: <span dir="rtl" lang="ar">إِلَى زَيْنَبَ، لِأَحْمَدَ، مِنْ بَاكِسْتَانَ، فِي لَنْدَنَ، فِي مَكَّةَ</span>. Предлог управляет следующим именем.',
  'Примеры: <span dir="rtl" lang="ar">إِلَى زَيْنَبَ، لِأَحْمَدَ، مِنْ بَاكِسْتَانَ، فِي لَنْدَنَ، فِي مَكَّةَ</span>.<br><strong>Полный перевод:</strong> к Зайнаб; для Ахмада; из Пакистана; в Лондоне; в Мекке. Предлог управляет следующим именем.'
)
where id = 1548
  and course_name = 'Мединский курс (Том 1)'
  and lesson_number = '23';

-- Keep every wide source table inside its own horizontal scroll container.
update public.rules
set content = replace(
  replace(content, '<table', '<div class="tbl-wrap"><table'),
  '</table>',
  '</table></div>'
)
where course_name = 'Мединский курс (Том 1)'
  and lesson_number in ('14', '15', '16', '17', '18', '19', '20', '21', '22', '23')
  and id in (
    1525, 1526, 1530, 1527, 1528,
    1531, 1532, 1533, 1534,
    1535,
    1537, 1538,
    1540, 1884, 1541,
    1543, 1544,
    1545,
    1546,
    1547, 1548
  )
  and content like '%<table%'
  and content not like '%<div class="tbl-wrap"><table%';

do $$
begin
  if (
    select count(*)
    from public.rules
    where id in (
      1525, 1526, 1530, 1527, 1528,
      1531, 1532, 1533, 1534,
      1535,
      1537, 1538,
      1540, 1884, 1541,
      1543, 1544,
      1545,
      1546,
      1547, 1548
    )
      and course_name = 'Мединский курс (Том 1)'
      and content like '%Полный текст шарха ·%'
  ) <> 21 then
    raise exception 'Book 1 lessons 14-23 full-sharh markers are incomplete';
  end if;

  if exists (
    select 1
    from public.rules
    where id in (
      1525, 1526, 1530, 1527, 1528,
      1531, 1532, 1533, 1534,
      1535,
      1537, 1538,
      1540, 1884, 1541,
      1543, 1544,
      1545,
      1546,
      1547, 1548
    )
      and content like '%<table%'
      and replace(content, '<div class="tbl-wrap"><table', '') like '%<table%'
  ) then
    raise exception 'Book 1 lessons 14-23 contain an unwrapped table';
  end if;

  if not exists (
    select 1 from public.rules
    where id = 1545
      and content like '%<strong>Полный перевод:</strong> Этот урок — повторение некоторых предыдущих уроков.%'
      and content like '%أَبْوَابُهَا%'
      and content like '%هِيَ مَدْرَسَةٌ كَبِيرَةٌ%'
  ) then
    raise exception 'Book 1 lesson 21 complete review translation is missing';
  end if;

  if not exists (
    select 1 from public.rules
    where id = 1548
      and content like '%<strong>Полный перевод:</strong> к Зайнаб; для Ахмада; из Пакистана; в Лондоне; в Мекке.%'
  ) then
    raise exception 'Book 1 lesson 23 repeated preposition translations are missing';
  end if;
end;
$$;

commit;
