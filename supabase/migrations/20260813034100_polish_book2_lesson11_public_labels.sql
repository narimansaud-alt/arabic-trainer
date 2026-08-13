-- Correct the unvocalized Arabic letter/state names found by the lesson 11
-- pre-apply audit. Arabic labels remain separate RTL elements with Russian meanings.

begin;

update public.rules
set content = replace(
  replace(
    replace(
      content,
      '<span class="rule-table-ru">ياء обращения к женщине</span>',
      '<span class="rule-table-ru">буква <span class="ar-inline" dir="rtl" lang="ar">يَاءٌ</span> — «йа» обращения к женщине</span>'
    ),
    '<span class="rule-table-ru">واو множественного числа</span>',
    '<span class="rule-table-ru">буква <span class="ar-inline" dir="rtl" lang="ar">وَاوٌ</span> — «вау» множественного числа</span>'
  ),
  '<span class="rule-table-ru">نون женского множественного</span>',
  '<span class="rule-table-ru">буква <span class="ar-inline" dir="rtl" lang="ar">نُونٌ</span> — «нун» женского множественного числа</span>'
)
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '11'
  and sort_order in (1, 2);

update public.rules
set
  title = 'عَلَامَاتُ رَفْعِ الْمُضَارِعِ وَبِنَاؤُهُ (признаки именительного состояния и неизменяемость глагола настоящего/будущего времени)',
  summary = 'Формы без присоединённых окончаний стоят в именительном состоянии с явной даммой; формы с وَاوُ الْجَمَاعَةِ и يَاءُ الْمُخَاطَبَةِ — в именительном состоянии с сохранением نُونٌ; формы с نُونُ النِّسْوَةِ построены на сукуне.',
  content = replace(
    replace(
      replace(
        content,
        'Формы без присоединённых окончаний имеют رفع с явной даммой. Формы с <span class="ar-inline" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span> и <span class="ar-inline" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span> имеют رفع посредством сохранения ن. Формы с <span class="ar-inline" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span> построены на сукуне.',
        'Формы без присоединённых окончаний стоят в именительном состоянии с явной даммой. Формы с <span class="ar-inline" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span> и <span class="ar-inline" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span> стоят в именительном состоянии, признак которого — сохранение буквы <span class="ar-inline" dir="rtl" lang="ar">نُونٌ</span> («нун»). Формы с <span class="ar-inline" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span> построены на сукуне.'
      ),
      '<span class="rule-table-ru">رفع с явной даммой</span>',
      '<span class="rule-table-ru">именительное состояние с явной даммой</span>'
    ),
    '<span class="rule-table-ru">رفع посредством сохранения ن</span>',
    '<span class="rule-table-ru">именительное состояние с сохранением <span class="ar-inline" dir="rtl" lang="ar">نُونٌ</span> — «нун»</span>'
  )
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '11'
  and sort_order = 2;

commit;
