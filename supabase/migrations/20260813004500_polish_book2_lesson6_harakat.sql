-- Polish Book 2 lesson 6 public harakat and remove non-source paraphrase forms.
-- Private source_text remains untouched.

begin;

update public.rules
set
  rule_ar = replace(replace(replace(rule_ar,
    'الِاتِّصَالِ', 'الاِتِّصَالِ'),
    'الِانْفِصَالِ', 'الاِنْفِصَالِ'),
    'الِاسْتِتَارِ', 'الاِسْتِتَارِ'),
  summary = replace(replace(replace(summary,
    'الِاتِّصَالِ', 'الاِتِّصَالِ'),
    'الِانْفِصَالِ', 'الاِنْفِصَالِ'),
    'الِاسْتِتَارِ', 'الاِسْتِتَارِ'),
  content = replace(replace(replace(replace(replace(replace(replace(replace(replace(content,
    'الِاتِّصَالُ', 'الاِتِّصَالُ'),
    'الِانْفِصَالُ', 'الاِنْفِصَالُ'),
    'الِاسْتِتَارُ', 'الاِسْتِتَارُ'),
    'عَلَّمَنِي: ي', 'عَلَّمَنِي: يَاءُ الْمُتَكَلِّمِ'),
    'كِتَابِي: ي', 'كِتَابِي: يَاءُ الْمُتَكَلِّمِ'),
    'ذَهَبْتُمْ: ت', 'ذَهَبْتُمْ: تُ'),
    'ذَهَبْتُنَّ: ت', 'ذَهَبْتُنَّ: تُ'),
    'ذَهَبُوا: و', 'ذَهَبُوا: وَاوُ الْجَمَاعَةِ'),
    'ذَهَبْنَ: ن', 'ذَهَبْنَ: نُونُ النِّسْوَةِ')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '6'
  and sort_order = 1;

update public.rules
set content = replace(replace(replace(replace(content,
  '<span class="rule-table-ar">أَعْطِنِي الْكِتَابَ.</span><span class="rule-table-ru">Дай мне книгу, Мухаммад.</span>',
  '<span class="rule-table-ru">Дай мне книгу, Мухаммад.</span>'),
  '<span class="rule-table-ar">أَعْطِينِي الْكِتَابَ.</span><span class="rule-table-ru">Дай мне книгу, Амина.</span>',
  '<span class="rule-table-ru">Дай мне книгу, Амина.</span>'),
  '<span class="rule-table-ar">أَعْطُونِي الْكِتَابَ.</span><span class="rule-table-ru">Дайте мне книгу, мальчики.</span>',
  '<span class="rule-table-ru">Дайте мне книгу, мальчики.</span>'),
  '<span class="rule-table-ar">أَعْطِينَنِي الْكِتَابَ.</span><span class="rule-table-ru">Дайте мне книгу, девочки.</span>',
  '<span class="rule-table-ru">Дайте мне книгу, девочки.</span>')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '6'
  and sort_order = 6;

commit;
