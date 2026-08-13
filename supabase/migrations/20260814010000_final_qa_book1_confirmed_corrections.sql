-- Final QA corrections for confirmed Book 1 discrepancies.
-- The verbatim rule_sources.source_text records are intentionally untouched.

DO $migration$
BEGIN
  UPDATE public.rules
  SET title = 'تِلْكَ وَأَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ وَالْبَعِيدِ («та» и указательные имена для близкого и далёкого)'
  WHERE id = 1492
    AND course_name = 'Мединский курс (Том 1)'
    AND title = 'تِلْكَ وَأَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ وَالْبَعِيدِ (та и указательные имена)';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 1 QA: expected title for rule 1492 was not found';
  END IF;

  UPDATE public.rules
  SET content = replace(
    content,
    $old1499$Оно употребляется с одним словом мужского рода — как обозначающим разумное лицо, так и неразумный предмет.$old1499$,
    $new1499$Оно употребляется с существительным мужского рода в единственном числе — как обозначающим разумное лицо, так и неразумный предмет.$new1499$
  )
  WHERE id = 1499
    AND course_name = 'Мединский курс (Том 1)'
    AND content LIKE '%Оно употребляется с одним словом мужского рода%';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 1 QA: expected wording for rule 1499 was not found';
  END IF;

  UPDATE public.rules
  SET content = replace(
    content,
    $old1504$Тот же задуманный смысл; для временного обладания здесь неверно выбрано <span dir="rtl" lang="ar">لِـ</span>.$old1504$,
    $new1504$Тот же задуманный смысл; в схеме автора для <span dir="rtl" lang="ar">كِتَابٌ</span> верен вопрос <span dir="rtl" lang="ar">أَعِنْدَكَ كِتَابٌ؟</span>, а не <span dir="rtl" lang="ar">أَلَكَ كِتَابٌ؟</span>.$new1504$
  )
  WHERE id = 1504
    AND course_name = 'Мединский курс (Том 1)'
    AND content LIKE '%для временного обладания%';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 1 QA: expected unsupported wording for rule 1504 was not found';
  END IF;

  UPDATE public.rules
  SET rule_ar = '«مَعَ» ظَرْفُ مَكَانٍ، وَهُوَ مُضَافٌ، وَالِاسْمُ الَّذِي بَعْدَهُ مُضَافٌ إِلَيْهِ مَجْرُورٌ بِالْكَسْرَةِ.',
      content = replace(
        content,
        $old1507$«مَعَ» ظَرْفُ مَكَانٍ، وَهِيَ مُضَافٌ، وَالِاسْمُ الَّذِي بَعْدَهَا مُضَافٌ إِلَيْهِ مَجْرُورٌ بِالْكَسْرَةِ.$old1507$,
        $new1507$«مَعَ» ظَرْفُ مَكَانٍ، وَهُوَ مُضَافٌ، وَالِاسْمُ الَّذِي بَعْدَهُ مُضَافٌ إِلَيْهِ مَجْرُورٌ بِالْكَسْرَةِ.$new1507$
      )
  WHERE id = 1507
    AND course_name = 'Мединский курс (Том 1)'
    AND rule_ar = '«مَعَ» ظَرْفُ مَكَانٍ، وَهِيَ مُضَافٌ، وَالِاسْمُ الَّذِي بَعْدَهَا مُضَافٌ إِلَيْهِ مَجْرُورٌ بِالْكَسْرَةِ.'
    AND content LIKE '%وَهِيَ مُضَافٌ%';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 1 QA: expected Arabic wording for rule 1507 was not found';
  END IF;

  UPDATE public.rules
  SET title = 'يَاءُ الْمُتَكَلِّمِ (йа говорящего: «мой/моя»)'
  WHERE id = 1510
    AND course_name = 'Мединский курс (Том 1)'
    AND title = 'يَاءُ الْمُتَكَلِّمِ (ياء говорящего: «мой/моя»)';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 1 QA: expected title for rule 1510 was not found';
  END IF;

  UPDATE public.rules
  SET content = replace(
    replace(
      content,
      'Кто мужчина, который сидел в саду?',
      'Кто тот мужчина, который сидел в саду?'
    ),
    'Кто преподавательница, которая сидела в саду?',
    'Кто та преподавательница, которая сидела в саду?'
  )
  WHERE id = 1515
    AND course_name = 'Мединский курс (Том 1)'
    AND content LIKE '%Кто мужчина, который сидел в саду?%'
    AND content LIKE '%Кто преподавательница, которая сидела в саду?%';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 1 QA: expected Russian questions for rule 1515 were not found';
  END IF;

  UPDATE public.rules
  SET content = replace(
    content,
    'Где твои подруги? Они в общежитии.',
    'Где твои сокурсницы? Они в общежитии.'
  )
  WHERE id = 1523
    AND course_name = 'Мединский курс (Том 1)'
    AND content LIKE '%Где твои подруги? Они в общежитии.%';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 1 QA: expected translation for rule 1523 was not found';
  END IF;

  UPDATE public.rules
  SET content = replace(
    content,
    'Суффикс <span dir="rtl" lang="ar">ـكُمْ</span> означает «ваш» при обращении к группе, а <span dir="rtl" lang="ar">ـنَا</span> — «наш».',
    'Суффикс <span dir="rtl" lang="ar">ـكُمْ</span> означает «ваш» при обращении к группе мужчин, а <span dir="rtl" lang="ar">ـنَا</span> — «наш».'
  )
  WHERE id = 1525
    AND course_name = 'Мединский курс (Том 1)'
    AND content LIKE '%означает «ваш» при обращении к группе,%';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 1 QA: expected plural addressee wording for rule 1525 was not found';
  END IF;

  UPDATE public.rules
  SET content = replace(
    content,
    $old1545_01$1. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ الْمُذَكَّرِ</span> — указательные имена близкого мужского рода.$old1545_01$,
    $new1545_01$1. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ الْمُذَكَّرِ</span> — указательные имена близкого мужского рода.<br>Перевод: Это наш класс. Это стол преподавателя. Это Мухаммад. Это наш преподаватель.$new1545_01$
  )
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)'
    AND content LIKE '%1. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ الْمُذَكَّرِ</span> — указательные имена близкого мужского рода.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 1 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_02$2. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ الْمُؤَنَّثِ</span> — указательные имена близкого женского рода.$old1545_02$,
    $new1545_02$2. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ الْمُؤَنَّثِ</span> — указательные имена близкого женского рода.<br>Перевод: Это моя школа. Это библиотека школы. Это Марьям. Это наша преподавательница.$new1545_02$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%2. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ الْمُؤَنَّثِ</span> — указательные имена близкого женского рода.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 2 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_03$3. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ الْمُذَكَّرِ</span> — указательные имена далёкого мужского рода.$old1545_03$,
    $new1545_03$3. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ الْمُذَكَّرِ</span> — указательные имена далёкого мужского рода.<br>Перевод: Вон там его стул. Вон там стол преподавателя. Вон Мухаммад, а вон Али.$new1545_03$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%3. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ الْمُذَكَّرِ</span> — указательные имена далёкого мужского рода.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 3 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_04$4. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ الْمُؤَنَّثِ</span> — указательные имена далёкого женского рода.$old1545_04$,
    $new1545_04$4. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ الْمُؤَنَّثِ</span> — указательные имена далёкого женского рода.<br>Перевод: Вон столы студентов. Вон Фатима. Те книги принадлежат преподавателям.$new1545_04$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%4. <span dir="rtl" lang="ar">أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ الْمُؤَنَّثِ</span> — указательные имена далёкого женского рода.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 4 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_05$5. <span dir="rtl" lang="ar">يَاءُ الْمُتَكَلِّمِ</span> — йа говорящего: «мой / моя / мои».$old1545_05$,
    $new1545_05$5. <span dir="rtl" lang="ar">يَاءُ الْمُتَكَلِّمِ</span> — йа говорящего: «мой / моя / мои».<br>Перевод: Это моя школа. Вон та сумка — моя. Это мои друзья.$new1545_05$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%5. <span dir="rtl" lang="ar">يَاءُ الْمُتَكَلِّمِ</span> — йа говорящего%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 5 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_06$6. <span dir="rtl" lang="ar">ضَمِيرُ الْجَمْعِ لِلْمُتَكَلِّمِ</span> — местоимение множественного числа говорящих.$old1545_06$,
    $new1545_06$6. <span dir="rtl" lang="ar">ضَمِيرُ الْجَمْعِ لِلْمُتَكَلِّمِ</span> — местоимение множественного числа говорящих.<br>Перевод: Это наш класс. В нашем классе десять студентов. Это наш преподаватель. Мы его любим.$new1545_06$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%6. <span dir="rtl" lang="ar">ضَمِيرُ الْجَمْعِ لِلْمُتَكَلِّمِ</span> — местоимение множественного числа говорящих.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 6 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_07$7. <span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ لِلْمُفْرَدِ الْمُذَكَّرِ</span> — «он» и связанные с ним формы.$old1545_07$,
    $new1545_07$7. <span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ لِلْمُفْرَدِ الْمُذَكَّرِ</span> — «он» и связанные с ним формы.<br>Перевод: Это просторный класс. В нём два окна. В нём есть столы. В нём есть доска. Он из Японии.$new1545_07$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%7. <span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ لِلْمُفْرَدِ الْمُذَكَّرِ</span> — «он» и связанные с ним формы.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 7 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_08$8. <span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ لِلْمُفْرَدِ الْمُؤَنَّثِ</span> — «она» и связанные с ней формы.$old1545_08$,
    $new1545_08$8. <span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ لِلْمُفْرَدِ الْمُؤَنَّثِ</span> — «она» и связанные с ней формы.<br>Перевод: Она находится близко. Это большая школа. У неё три двери. Её двери открыты.$new1545_08$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%8. <span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ لِلْمُفْرَدِ الْمُؤَنَّثِ</span> — «она» и связанные с ней формы.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 8 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_09$9. <span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ لِلْجَمْعِ الْمُذَكَّرِ</span> — «они» и суффикс «их» для мужской группы.$old1545_09$,
    $new1545_09$9. <span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ لِلْجَمْعِ الْمُذَكَّرِ</span> — «они» и суффикс «их» для мужской группы.<br>Перевод: Их стулья. Они из разных стран. Их языки различаются. Их цвета различаются. Их религия едина.$new1545_09$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%9. <span dir="rtl" lang="ar">ضَمِيرُ الْغَائِبِ لِلْجَمْعِ الْمُذَكَّرِ</span> — «они» и суффикс «их» для мужской группы.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 9 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_10$10. <span dir="rtl" lang="ar">مَنْعُوتٌ وَنَعْتٌ</span> — определяемое слово и согласованное определение.$old1545_10$,
    $new1545_10$10. <span dir="rtl" lang="ar">مَنْعُوتٌ وَنَعْتٌ</span> — определяемое слово и согласованное определение.<br>Перевод: Большая школа. Большие аудитории. Просторный класс. Два больших окна. Они из разных стран. Праведный мужчина.$new1545_10$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%10. <span dir="rtl" lang="ar">مَنْعُوتٌ وَنَعْتٌ</span> — определяемое слово и согласованное определение.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 10 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_11$11. <span dir="rtl" lang="ar">مُضَافٌ وَمُضَافٌ إِلَيْهِ</span> — первый и второй члены идафы.$old1545_11$,
    $new1545_11$11. <span dir="rtl" lang="ar">مُضَافٌ وَمُضَافٌ إِلَيْهِ</span> — первый и второй члены идафы.<br>Перевод: Три двери. Стол преподавателя. Столы студентов. Её двери. Наш класс. Их языки.$new1545_11$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%11. <span dir="rtl" lang="ar">مُضَافٌ وَمُضَافٌ إِلَيْهِ</span> — первый и второй члены идафы.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 11 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_12$12. <span dir="rtl" lang="ar">مُبْتَدَأٌ وَخَبَرٌ</span> — мубтада и хабар.$old1545_12$,
    $new1545_12$12. <span dir="rtl" lang="ar">مُبْتَدَأٌ وَخَبَرٌ</span> — мубтада и хабар.<br>Перевод: Это моя школа. Она находится близко. Её двери открыты. Вон там его стул. Стол преподавателя большой. Это наш преподаватель.$new1545_12$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%12. <span dir="rtl" lang="ar">مُبْتَدَأٌ وَخَبَرٌ</span> — мубтада и хабар.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 12 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_13$13. <span dir="rtl" lang="ar">الْمُثَنَّى</span> — двойственное число.$old1545_13$,
    $new1545_13$13. <span dir="rtl" lang="ar">الْمُثَنَّى</span> — двойственное число.<br>Перевод: В нём два больших окна. Эти два студента усердны.$new1545_13$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%13. <span dir="rtl" lang="ar">الْمُثَنَّى</span> — двойственное число.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 13 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_14$14. <span dir="rtl" lang="ar">الْعَدَدُ</span> — числительное и считаемое слово.$old1545_14$,
    $new1545_14$14. <span dir="rtl" lang="ar">الْعَدَدُ</span> — числительное и считаемое слово.<br>Перевод: Три двери. Десять студентов.$new1545_14$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%14. <span dir="rtl" lang="ar">الْعَدَدُ</span> — числительное и считаемое слово.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 14 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules SET content = replace(content,
    $old1545_15$15. <span dir="rtl" lang="ar">حُرُوفُ الْجَرِّ</span> — предлоги и управляемые ими имена.$old1545_15$,
    $new1545_15$15. <span dir="rtl" lang="ar">حُرُوفُ الْجَرِّ</span> — предлоги и управляемые ими имена.<br>Перевод: В школе есть классы. В нашем классе десять студентов. Они из разных стран.$new1545_15$)
  WHERE id = 1545 AND course_name = 'Мединский курс (Том 1)' AND content LIKE '%15. <span dir="rtl" lang="ar">حُرُوفُ الْجَرِّ</span> — предлоги и управляемые ими имена.%';
  IF NOT FOUND THEN RAISE EXCEPTION 'Book 1 QA: topic 15 translation for rule 1545 was not found'; END IF;

  UPDATE public.rules
  SET rule_ar = replace(
    rule_ar,
    'وَالِاسْمُ الْمَخْتُومُ بِأَلِفٍ مَمْدُودَةٍ،',
    'وَالِاسْمُ الْمَخْتُومُ بِأَلِفٍ مَمْدُودَةٍ عَلَى وَزْنِ أَفْعِلَاءَ أَوْ فُعَلَاءَ،'
  )
  WHERE id = 1546
    AND course_name = 'Мединский курс (Том 1)'
    AND rule_ar LIKE '%وَالِاسْمُ الْمَخْتُومُ بِأَلِفٍ مَمْدُودَةٍ،%';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 1 QA: expected diptote wording for rule 1546 was not found';
  END IF;
END
$migration$;
