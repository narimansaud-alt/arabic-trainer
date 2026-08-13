-- Remove directional ambiguity and Arabic shaping breaks from Book 2 lesson 18.

update public.rules
set content = replace(
  replace(
    replace(
      content,
      'أُتِيَ بِـ<span class="ar-tone-structure">الْأَلِفِ الْفَارِقَةِ</span>',
      'أُتِيَ <span class="ar-tone-structure">بِالْأَلِفِ الْفَارِقَةِ</span>'
    ),
    '<span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">تَفْعَلُونَ</span> ← <span class="ar-tone-nasb">أَنْ تَفْعَلُوا</span></span><span class="rule-term-ru">вы делаете → чтобы вы сделали</span>',
    '<span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">تَفْعَلُونَ</span> فِي الرَّفْعِ؛ <span class="ar-tone-nasb">أَنْ تَفْعَلُوا</span> فِي النَّصْبِ</span><span class="rule-term-ru">раф‘: «вы делаете»; насб: «чтобы вы сделали»</span>'
  ),
  '<span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">يَفْعَلُونَ</span> ← <span class="ar-tone-nasb">أَنْ يَفْعَلُوا</span></span><span class="rule-term-ru">они делают → чтобы они сделали</span>',
  '<span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">يَفْعَلُونَ</span> فِي الرَّفْعِ؛ <span class="ar-tone-nasb">أَنْ يَفْعَلُوا</span> فِي النَّصْبِ</span><span class="rule-term-ru">раф‘: «они делают»; насб: «чтобы они сделали»</span>'
)
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '18'
  and sort_order = 2;

update public.rules
set content = replace(
  replace(
    replace(
      replace(
        replace(
          content,
          '<span class="ar-tone-particle">كَـ</span><span class="ar-tone-jarr">الْمَدْرَسَةِ</span>',
          '<span class="ar-tone-jarr">كَالْمَدْرَسَةِ</span>'
        ),
        '<span class="ar-tone-particle">كَـ</span><span class="ar-tone-jarr">الْمَسْجِدِ</span>',
        '<span class="ar-tone-jarr">كَالْمَسْجِدِ</span>'
      ),
      '<span class="ar-tone-particle">كَـ</span><span class="ar-tone-jarr">الْأَسَدِ</span>',
      '<span class="ar-tone-jarr">كَالْأَسَدِ</span>'
    ),
    '<span class="ar-tone-particle">كَـ</span><span class="ar-tone-jarr">سَاعَتِكَ</span>',
    '<span class="ar-tone-jarr">كَسَاعَتِكَ</span>'
  ),
  '<span class="ar-tone-particle">كَـ</span><span class="ar-tone-jarr">زَمِيلِهِ</span>',
  '<span class="ar-tone-jarr">كَزَمِيلِهِ</span>'
)
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '18'
  and sort_order = 5;

do $verification$
begin
  if exists (
    select 1
    from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '18'
      and (content like '%←%' or content like '%كَـ%' or content like '%بِـ<span%')
  ) then
    raise exception 'Book 2 lesson 18 still contains an RTL arrow or a split Arabic word';
  end if;
end
$verification$;
