-- Correct three pedagogical ambiguities found during the post-write semantic
-- audit of Medina Book 2 lesson 9, and normalize two vocalized spellings.

begin;

do $migration$
declare
  sound_rule_id bigint;
  vocative_rule_id bigint;
  interrogative_rule_id bigint;
  object_rule_id bigint;
  relative_rule_id bigint;
  old_fragment text;
  new_fragment text;
begin
  select id into strict sound_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 1;
  select id into strict vocative_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 3;
  select id into strict interrogative_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 4;
  select id into strict object_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 5;
  select id into strict relative_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 7;

  old_fragment := $html$<td><span class="rule-table-ar ar-tone-verb">رَأَى</span></td><td><span class="rule-table-ar ar-tone-verb">فِعْلٌ مَاضٍ</span><span class="rule-table-ru">глагол прошедшего времени</span></td>$html$;
  new_fragment := $html$<td><span class="rule-table-ar"><span class="ar-tone-verb">رَأَيْ</span><span class="ar-tone-subject">تُ</span></span></td><td><span class="rule-table-ar"><span class="ar-tone-verb">فِعْلٌ مَاضٍ</span> مَعَ <span class="ar-tone-subject">فَاعِلِهِ</span></span><span class="rule-table-ru">глагол прошедшего времени вместе со своим исполнителем</span></td>$html$;
  if position(old_fragment in (select content from public.rules where id = sound_rule_id)) = 0 then
    raise exception 'Expected lesson 9 رأيت parsing fragment was not found';
  end if;
  update public.rules set content = replace(content, old_fragment, new_fragment) where id = sound_rule_id;

  update public.rules
  set
    title = 'الْمُنَادَى الْمُفْرَدُ وَالْمُضَافُ (простое обращение и обращение в идафе)',
    rule_ar = 'الْمُنَادَى الْمُفْرَدُ مَبْنِيٌّ عَلَى الضَّمِّ، نَحْوُ: «يَا مُحَمَّدُ» وَ«يَا أُسْتَاذُ». وَالْمُنَادَى الْمُضَافُ مَنْصُوبٌ بِالْفَتْحَةِ، نَحْوُ: «يَا عَبْدَ اللَّهِ» وَ«يَا سَائِقَ السَّيَّارَةِ».',
    summary = 'الْمُنَادَى الْمُفْرَدُ مَبْنِيٌّ عَلَى الضَّمِّ، نَحْوُ: «يَا مُحَمَّدُ» وَ«يَا أُسْتَاذُ». وَالْمُنَادَى الْمُضَافُ مَنْصُوبٌ بِالْفَتْحَةِ، نَحْوُ: «يَا عَبْدَ اللَّهِ» وَ«يَا سَائِقَ السَّيَّارَةِ».'
  where id = vocative_rule_id;

  update public.rules
  set
    rule_ar = replace(rule_ar, 'أَ + الْآنَ', 'أَ + ٱلْآنَ'),
    summary = replace(summary, 'أَ + الْآنَ', 'أَ + ٱلْآنَ'),
    content = replace(content, 'أَ + الْآنَ', 'أَ + ٱلْآنَ')
  where id = interrogative_rule_id;

  old_fragment := $html$<td><span class="rule-table-ar ar-tone-nasb">يَاءُ الْمُتَكَلِّمِ «ـنِي»</span><span class="rule-table-ru">«меня»</span></td>$html$;
  new_fragment := $html$<td><span class="rule-table-ar ar-tone-nasb">يَاءُ الْمُتَكَلِّمِ «ـِي»</span><span class="rule-table-ru">«меня»; после защитной нун в глаголе:</span><span class="rule-table-ar ar-tone-nasb">ـنِي</span></td>$html$;
  if position(old_fragment in (select content from public.rules where id = object_rule_id)) = 0 then
    raise exception 'Expected lesson 9 ya-al-mutakallim label was not found';
  end if;
  update public.rules set content = replace(content, old_fragment, new_fragment) where id = object_rule_id;

  update public.rules
  set
    title = replace(title, 'الِاسْمِ', 'الاِسْمِ'),
    rule_ar = replace(rule_ar, 'الِاسْمُ', 'الاِسْمُ'),
    summary = replace(summary, 'الِاسْمُ', 'الاِسْمُ'),
    content = replace(content, 'الِاسْمُ', 'الاِسْمُ')
  where id = relative_rule_id;

  if position('يَاءُ الْمُتَكَلِّمِ «ـنِي»' in (select content from public.rules where id = object_rule_id)) > 0 then
    raise exception 'Lesson 9 still labels the entire ني ending as ya al-mutakallim';
  end if;

  if position('رَأَى</span></td><td>' in (select content from public.rules where id = sound_rule_id)) > 0 then
    raise exception 'Lesson 9 still substitutes the dictionary form for the رأيت parsing segment';
  end if;
end;
$migration$;

commit;
