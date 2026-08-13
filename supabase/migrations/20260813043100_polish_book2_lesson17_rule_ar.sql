-- Make the distributive syntax of the Book 2 lesson 17 yumkinu rule explicit.

update public.rules
set rule_ar = '«يُمْكِنُ» فِعْلٌ مُضَارِعٌ مَرْفُوعٌ يَحْتَاجُ إِلَى فَاعِلٍ وَمَفْعُولٍ بِهِ؛ وَيَكُونُ الْفَاعِلُ اسْمًا ظَاهِرًا أَوْ مَصْدَرًا مُؤَوَّلًا، وَتَكُونُ كُلٌّ مِنْ يَاءِ الْمُتَكَلِّمِ وَكَافِ الْمُخَاطَبِ مَفْعُولًا بِهِ، وَ«لَا» فِي «لَا يُمْكِنُ» حَرْفُ نَفْيٍ لَا يَعْمَلُ.'
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '17'
  and sort_order = 3
  and title = 'يُمْكِنُ وَلَا يُمْكِنُ (можно и невозможно)';

do $verification$
begin
  if not exists (
    select 1
    from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '17'
      and sort_order = 3
      and rule_ar like '%كُلٌّ مِنْ يَاءِ الْمُتَكَلِّمِ%'
  ) then
    raise exception 'Book 2 lesson 17 yumkinu rule_ar polish was not applied';
  end if;
end
$verification$;
