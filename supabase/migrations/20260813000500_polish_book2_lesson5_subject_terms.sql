-- Align the Book 2 lesson 5 subject terminology and private table transcription with PDF page 19.

begin;

update public.rules
set
  rule_ar = replace(rule_ar, 'أَوْ نَا الْمُتَكَلِّمِينَ', 'أَوْ نُونُ الْمُتَكَلِّمِينَ «نَا»'),
  summary = replace(summary, 'أَوْ نَا الْمُتَكَلِّمِينَ', 'أَوْ نُونُ الْمُتَكَلِّمِينَ «نَا»')
where course_name = 'Мединский курс (Том 2)'
  and lesson_number = '5'
  and sort_order = 7;

update public.rule_sources
set source_text = $$تعيين الفاعل في الفعل الماضي (الفعل: ذهب)
ذَهَبَ | ضمير مستتر تقديره "هو"
ذَهَبَتْ | ضمير مستتر تقديره "هي"، والتاء الساكنة: علامة التأنيث
ذَهَبُوا | واو الجماعة (و)، والألف: ألف الفارقة
ذَهَبْنَ | نون النسوة (ن)
ذَهَبْتُ | التاء المتحركة (ت)
ذَهَبْتَ | التاء المتحركة (ت)
ذَهَبْتُمْ | التاء المتحركة (ت)، والميم علامة الجمع للمذكر
ذَهَبْتُنَّ | التاء المتحركة (ت)، والنون علامة الجمع للمؤنث
ذَهَبْتِ | التاء المتحركة (ت)
ذَهَبْنَا | نون المتكلمين (نا)$$
where rule_id = (
  select id from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '5'
    and sort_order = 7
)
  and source_document = 'Podrobny_Sharkh_2_tom.pdf'
  and source_page_from = 19
  and source_page_to = 19;

commit;
