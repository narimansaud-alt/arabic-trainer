-- Rebuild Medina Book 3 lesson 4 strictly from the supplied Arabic sharh.
-- The sharh combines lessons 4 and 5 under one heading; the اسم الفاعل block belongs to lesson 4.
-- Canonical page references: Sharkh_Medinskiy_3.pdf, PDF pages 27-28.

begin;
do $migration$
declare old_rule_count integer; new_rule_count integer; source_count integer;
begin
  select count(*) into old_rule_count from public.rules where course_name = 'Мединский курс (Том 3)' and lesson_number = '4';
  if old_rule_count <> 1 then raise exception 'Expected 1 generated Book 3 lesson 4 rule, found %', old_rule_count; end if;
  delete from public.rule_sections where rule_id in (select id from public.rules where course_name = 'Мединский курс (Том 3)' and lesson_number = '4');
  delete from public.rule_sources where rule_id in (select id from public.rules where course_name = 'Мединский курс (Том 3)' and lesson_number = '4');
  delete from public.rules where course_name = 'Мединский курс (Том 3)' and lesson_number = '4';
  insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values ('Мединский курс (Том 3)', '4', 'اسْمُ الْفَاعِلِ (действительное причастие, имя действующего лица)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">اسْمُ الْفَاعِلِ</span> يُصَاغُ مِنَ الْفِعْلِ الْمَبْنِيِّ لِلْمَعْلُومِ لِلدَّلَالَةِ عَلَى مَنْ قَامَ بِالْفِعْلِ.</span><p class="rule-study-text">Это производное имя обозначает того, кто совершил или совершает действие.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Образование от простого трёхбуквенного глагола</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْفِعْلُ</span><span class="rule-table-ru">глагол</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">نَوْعُهُ</span><span class="rule-table-ru">тип глагола</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">اسْمُ الْفَاعِلِ</span><span class="rule-table-ru">действительное причастие</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">أَصْلُهُ وَتَغْيِيرُهُ</span><span class="rule-table-ru">исходная форма и изменение</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">عَلِمَ</span><span class="rule-table-ru">он знал</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">صَحِيحٌ سَالِمٌ</span><span class="rule-table-ru">правильный без хамзы и удвоения</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">عَالِمٌ</span><span class="rule-table-ru">знающий; учёный</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">—</span><span class="rule-table-ru">—</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَكَلَ</span><span class="rule-table-ru">он ел</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">صَحِيحٌ مَهْمُوزٌ</span><span class="rule-table-ru">правильный с хамзой</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">آكِلٌ</span><span class="rule-table-ru">едящий</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">—</span><span class="rule-table-ru">—</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">سَأَلَ</span><span class="rule-table-ru">он спрашивал</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">صَحِيحٌ مَهْمُوزٌ</span><span class="rule-table-ru">правильный с хамзой</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">سَائِلٌ</span><span class="rule-table-ru">спрашивающий</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">—</span><span class="rule-table-ru">—</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">قَرَأَ</span><span class="rule-table-ru">он читал</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">صَحِيحٌ مَهْمُوزٌ</span><span class="rule-table-ru">правильный с хамзой</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">قَارِئٌ</span><span class="rule-table-ru">читающий</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">—</span><span class="rule-table-ru">—</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">سَرَّ</span><span class="rule-table-ru">он обрадовал</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">صَحِيحٌ مُضَعَّفٌ</span><span class="rule-table-ru">правильный удвоенный</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">سَارٌّ</span><span class="rule-table-ru">радующий</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">سَارِرٌ؛ أُدْغِمَتِ الرَّاءُ فِي الْأُخْرَى.</span><span class="rule-table-ru">Исходная форма — سَارِرٌ; первая ра слита со второй.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">قَالَ</span><span class="rule-table-ru">он сказал</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُعْتَلٌّ أَجْوَفُ وَاوِيٌّ</span><span class="rule-table-ru">слабый средний с вау</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">قَائِلٌ</span><span class="rule-table-ru">говорящий</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">قَاوِلٌ؛ قُلِبَتِ الْوَاوُ هَمْزَةً لِأَنَّهَا وَقَعَتْ عَيْنَ اسْمِ الْفَاعِلِ، وَالْفِعْلُ مُعْتَلُّ الْعَيْنِ.</span><span class="rule-table-ru">Исходная форма — قَاوِلٌ; вау превратилась в хамзу, потому что заняла среднюю позицию причастия от слабого среднего глагола.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">بَاعَ</span><span class="rule-table-ru">он продал</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُعْتَلٌّ أَجْوَفُ يَائِيٌّ</span><span class="rule-table-ru">слабый средний с йа</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">بَائِعٌ</span><span class="rule-table-ru">продающий; продавец</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">بَايِعٌ؛ قُلِبَتِ الْيَاءُ هَمْزَةً لِأَنَّهَا وَقَعَتْ عَيْنَ اسْمِ الْفَاعِلِ، وَالْفِعْلُ مُعْتَلُّ الْعَيْنِ.</span><span class="rule-table-ru">Исходная форма — بَايِعٌ; йа превратилась в хамзу, потому что заняла среднюю позицию причастия от слабого среднего глагола.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَقَفَ</span><span class="rule-table-ru">он остановился</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُعْتَلٌّ مِثَالٌ</span><span class="rule-table-ru">слабый первый</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاقِفٌ</span><span class="rule-table-ru">стоящий</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">—</span><span class="rule-table-ru">—</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">دَعَا</span><span class="rule-table-ru">он призвал</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">نَاقِصٌ وَاوِيٌّ</span><span class="rule-table-ru">конечно-слабый с вау</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">دَاعٍ، الدَّاعِي</span><span class="rule-table-ru">призывающий; определённая форма «призывающий»</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">دَاعِوٌ؛ قُلِبَتِ الْوَاوُ يَاءً لِأَنَّهَا مُتَطَرِّفَةٌ وَقَبْلَهَا كَسْرَةٌ.</span><span class="rule-table-ru">Исходная форма — دَاعِوٌ; конечная вау после касры превратилась в йа.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">هَدَى</span><span class="rule-table-ru">он наставил</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">نَاقِصٌ يَائِيٌّ</span><span class="rule-table-ru">конечно-слабый с йа</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">هَادٍ، الْهَادِي</span><span class="rule-table-ru">наставляющий; определённая форма «наставляющий»</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">—</span><span class="rule-table-ru">—</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">وَقَى</span><span class="rule-table-ru">он защитил</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُعْتَلٌّ لَفِيفٌ مَفْرُوقٌ</span><span class="rule-table-ru">двойной слабый разделённый</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاقٍ، الْوَاقِي</span><span class="rule-table-ru">защищающий; определённая форма «защищающий»</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">—</span><span class="rule-table-ru">—</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">طَوَى</span><span class="rule-table-ru">он сложил</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُعْتَلٌّ لَفِيفٌ مَقْرُونٌ</span><span class="rule-table-ru">двойной слабый смежный</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">طَاوٍ، الطَّاوِي</span><span class="rule-table-ru">складывающий; определённая форма «складывающий»</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">—</span><span class="rule-table-ru">—</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">يُصَاغُ اسْمُ الْفَاعِلِ مِنَ الثُّلَاثِيِّ الْمَزِيدِ وَغَيْرِ الثُّلَاثِيِّ عَلَى لَفْظِ الْمُضَارِعِ، مَعَ قَلْبِ حَرْفِ الْمُضَارَعَةِ مِيمًا مَضْمُومَةً وَكَسْرِ مَا قَبْلَ الْآخِرِ.</span><p class="rule-study-text">Берётся форма настояще-будущего глагола: его начальная буква заменяется мимом с даммой, а предпоследняя буква получает касру.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все примеры от трёхбуквенных с добавочными буквами и от нетрёхбуквенных глаголов</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْمَاضِي</span><span class="rule-table-ru">прошедший глагол</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْمُضَارِعُ</span><span class="rule-table-ru">настояще-будущий глагол</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">اسْمُ الْفَاعِلِ</span><span class="rule-table-ru">действительное причастие</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">عَلَّمَ</span><span class="rule-table-ru">он обучил</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يُعَلِّمُ</span><span class="rule-table-ru">он обучает</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُعَلِّمٌ</span><span class="rule-table-ru">обучающий; учитель</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَادَى</span><span class="rule-table-ru">он позвал</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يُنَادِي</span><span class="rule-table-ru">он зовёт</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُنَادٍ</span><span class="rule-table-ru">зовущий</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِسْتَغْفَرَ</span><span class="rule-table-ru">он попросил прощения</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَسْتَغْفِرُ</span><span class="rule-table-ru">он просит прощения</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُسْتَغْفِرٌ</span><span class="rule-table-ru">просящий прощения</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">بَعْثَرَ</span><span class="rule-table-ru">он разбросал</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يُبَعْثِرُ</span><span class="rule-table-ru">он разбрасывает</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُبَعْثِرٌ</span><span class="rule-table-ru">разбрасывающий</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِطْمَأَنَّ</span><span class="rule-table-ru">он успокоился</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَطْمَئِنُّ</span><span class="rule-table-ru">он спокоен</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُطْمَئِنٌّ</span><span class="rule-table-ru">спокойный</span></td></tr></tbody></table></div></div></div>', 1, 'rule', 'Действительное причастие указывает на совершающего действие; шарх отдельно показывает образование от простого трёхбуквенного и от остальных глаголов.', 'اسْمُ الْفَاعِلِ اسْمٌ يُصَاغُ مِنَ الْفِعْلِ الْمَبْنِيِّ لِلْمَعْلُومِ لِلدَّلَالَةِ عَلَى مَنْ قَامَ بِالْفِعْلِ. يُصَاغُ مِنَ الثُّلَاثِيِّ الْمُجَرَّدِ عَلَى وَزْنِ فَاعِلٍ، وَمِنَ الثُّلَاثِيِّ الْمَزِيدِ وَغَيْرِ الثُّلَاثِيِّ عَلَى لَفْظِ الْمُضَارِعِ مَعَ قَلْبِ حَرْفِ الْمُضَارَعَةِ مِيمًا مَضْمُومَةً وَكَسْرِ مَا قَبْلَ الْآخِرِ.');
  insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  select id, 'Sharkh_Medinskiy_3.pdf', 'اسْمُ الْفَاعِلِ
اسمُ الفاعلِ ، هو : اسمٌ يُصَاغُ من الفعل المبنيَّ للمعلوم لِلدَّلاَلة على مَنْ قامَ بالفِعْل .
صِيَاغَتُهُ : اسم الفاعل مُشْتَقٌّ من الفعل ، ويُصَاغ على وَزْنِ ( فَاعِل ) من الفعلِ
الثُّلاَثِيَّ الْمُجَرَّدِ ، نحو : كَاتِب ، آخِذ ، آتٍ ، سَالِم ، رَاءٍ .
* جدولٌ يُبَيِّنُ صِيَاغَةَ اسمِ الفاعلِ من الأفعالِ الثُّلاَثِيَّةِ الْمُجَرَّدَةِ :
الفعل
نوعه
اسم الفاعل
أصله
عَلِمَ
صَحِيحٌ سَالِمٌ
عَالِمٌ
---------
أَكَلَ
صحيحٌ مَهْمُوزٌ
آكِلٌ
---------
سَأَلَ
صحيح مهموز
سَائِلٌ
---------
قَرَأَ
صحيح مهموز
قَارِئٌ
---------
سَرَّ
صحيح مُضَعَّفٌ
سَارٌّ
سَارِرٌ ، أُدْغِمَت الرَّاء في الأخرى .
قَالَ
معتلّ أَجْوَف وَاوِيّ
قَائِلٌ
قَاوِلٌ . قُلِبَت الواو همزة ؛ لأنها وَقَعَتْ عينَ اسم الفاعل والفعل معتلّ العين .
باع
معتلّ أجوف يائِيّ
بَائِعٌ
بَايِع . قُلبت الياء همزة ؛ لأنها وقعتْ عينَ اسم الفاعل والفعل معتل العين .
وَقَفَ
معتلّ مِثال
وَاقِفٌ
---------
دَعَا
نَاقِصٌ وَاوِيّ
دَاعٍ . الدَّاعِي
دَاعِوٌ. قُلبت الواو ياءً ؛ لأنها مُتَطَرَّفَة وقبلها كسرة .
هَدَى
نَاقِصٌ يائِي
هَادٍ . الْهَادِي
---------
وَقَى
معتلّ لَفِيف مَفْرُوق
وَاقٍ . الوَاقِي
---------
طَوَى
معتل لَفِيف مَقْرُون
طَاوٍ. الطَّاوِي
---------
* إذا كانَ الفعلُ ثلاثياً مزيداً ، أو غيرَ ثلاثيٍّ صِيغَ اسمُ الفاعلِ منه كما يلي :
يُصَاغُ على لفظ المضارع مع قلب حرف المضارع ميماً مضمومة ، وكسر ما قبل الآخر،
نحو : عَلَّمَ       يُعَلَّمُ : مُعَلَّمٌ .                      نَادَى        يُنَادِي : مُنَادٍ .
اسْتَغْفَرَ      يَسْتَغْفِرُ : مُسْتَغْفِرٌ.                 بَعْثَرَ         يُبَعْثِرُ : مُبَعْثِرٌ .
اِطْمَأَنَّ    	 يَطْمَئِنُّ : مُطْمَئِنٌّ .', 27, 28, 1 from public.rules
  where course_name = 'Мединский курс (Том 3)' and lesson_number = '4' and sort_order = 1;
  select count(*) into new_rule_count from public.rules where course_name = 'Мединский курс (Том 3)' and lesson_number = '4';
  select count(*) into source_count from public.rule_sources rs join public.rules r on r.id = rs.rule_id where r.course_name = 'Мединский курс (Том 3)' and r.lesson_number = '4';
  if new_rule_count <> 1 or source_count <> 1 then raise exception 'Book 3 lesson 4 verification failed: rules %, sources %', new_rule_count, source_count; end if;
end
$migration$;
commit;
