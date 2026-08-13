-- Verify Medina Book 2 lesson 20 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF page 46.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 39.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '20';

  if lesson_rule_count <> 3 then
    raise exception 'Expected 3 Book 2 lesson 20 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '20' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '20' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '20' and sort_order = 3;

  delete from public.rule_sections
  where rule_id in (rule_1_id, rule_2_id, rule_3_id);

  delete from public.rule_sources
  where rule_id in (rule_1_id, rule_2_id, rule_3_id);

  -- 1. The dual: definition, case signs, full analyses, transformations, questions.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'الْمُثَنَّى وَإِعْرَابُهُ (двойственное число и его склонение)',
    rule_ar = 'الْمُثَنَّى اسْمٌ يَدُلُّ عَلَى اثْنَيْنِ أَوِ اثْنَتَيْنِ بِزِيَادَةِ أَلِفٍ وَنُونٍ فِي آخِرِهِ، وَيُرْفَعُ بِالْأَلِفِ، وَيُنْصَبُ وَيُجَرُّ بِالْيَاءِ.',
    summary = 'Двойственное число обозначает два предмета; оно поднимается алифом, а ставится в насб и джарр посредством йа. Сохранены все разборы и примеры двух шархов.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Определение и признаки</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الْمُثَنَّى</span> اسْمٌ يَدُلُّ عَلَى اثْنَيْنِ أَوِ اثْنَتَيْنِ بِزِيَادَةِ أَلِفٍ وَنُونٍ فِي آخِرِهِ.</span>
        <p class="rule-study-text">Двойственное число обозначает два предмета мужского или женского рода и образуется добавлением алифа и нуна в конце.</p>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-raf" dir="rtl" lang="ar">يُرْفَعُ بِالْأَلِفِ</span><span class="rule-term-ru">в состоянии раф‘ показатель — алиф: <span class="ar-inline" dir="rtl" lang="ar">ـَانِ</span></span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-nasb" dir="rtl" lang="ar">يُنْصَبُ بِالْيَاءِ</span><span class="rule-term-ru">в состоянии насб показатель — йа: <span class="ar-inline" dir="rtl" lang="ar">ـَيْنِ</span></span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-jarr" dir="rtl" lang="ar">يُجَرُّ بِالْيَاءِ</span><span class="rule-term-ru">в состоянии джарр показатель — йа: <span class="ar-inline" dir="rtl" lang="ar">ـَيْنِ</span></span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три полных разбора подробного шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Состояние</th><th>Пример</th><th>Полный арабский разбор</th><th>Русский перевод разбора</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">раф‘</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">دَخَلَ <span class="ar-tone-subject">الطَّالِبَانِ</span>.</span><span class="rule-table-ru">Вошли два студента.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَانِ: فَاعِلٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الْأَلِفُ.</span></td><td>«Два студента» — исполнитель в раф‘; показатель — алиф.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">الطَّالِبَيْنِ</span>.</span><span class="rule-table-ru">Я увидел двух студентов.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَيْنِ: مَفْعُولٌ بِهِ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْيَاءُ.</span></td><td>«Двух студентов» — прямое дополнение в насбе; показатель — йа.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">الطَّالِبَيْنِ</span>.</span><span class="rule-table-ru">Я поприветствовал двух студентов.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الطَّالِبَيْنِ: مَجْرُورٌ بِـ«عَلَى»، وَعَلَامَةُ جَرِّهِ الْيَاءُ.</span></td><td>«Двух студентов» — имя в джарре после предлога; показатель — йа.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Переход от единственного числа к двойственному</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Состояние</th><th>Единственное число</th><th>Двойственное число</th><th>Разбор двойственной формы</th></tr></thead>
          <tbody>
            <tr><td>Раф‘</td><td><span class="rule-table-ar" dir="rtl" lang="ar">جَاءَ الْمُدَرِّسُ.</span><span class="rule-table-ru">Пришёл преподаватель.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">جَاءَ <span class="ar-tone-raf">الْمُدَرِّسَانِ</span>.</span><span class="rule-table-ru">Пришли два преподавателя.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فَاعِلٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الْأَلِفُ.</span><span class="rule-table-ru">Исполнитель в раф‘; показатель — алиф.</span></td></tr>
            <tr><td>Насб</td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ الْمُدَرِّسَ.</span><span class="rule-table-ru">Я увидел преподавателя.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">الْمُدَرِّسَيْنِ</span>.</span><span class="rule-table-ru">Я увидел двух преподавателей.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مَفْعُولٌ بِهِ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْيَاءُ.</span><span class="rule-table-ru">Дополнение в насбе; показатель — йа.</span></td></tr>
            <tr><td>Джарр</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ذَهَبْتُ إِلَى الْمُدَرِّسِ.</span><span class="rule-table-ru">Я пошёл к преподавателю.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ذَهَبْتُ إِلَى <span class="ar-tone-jarr">الْمُدَرِّسَيْنِ</span>.</span><span class="rule-table-ru">Я пошёл к двум преподавателям.</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اسْمٌ مَجْرُورٌ، وَعَلَامَةُ جَرِّهِ الْيَاءُ.</span><span class="rule-table-ru">Имя в джарре; показатель — йа.</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все вопросно-ответные примеры второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Вопрос и ответ</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">كَمْ أَخًا لَكَ؟ لِي <span class="ar-tone-raf">أَخَوَانِ</span>.</span></td><td>Сколько у тебя братьев? У меня два брата.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">كَمْ طَالِبًا خَرَجَ مِنَ الْفَصْلِ؟ خَرَجَ <span class="ar-tone-raf">طَالِبَانِ</span>.</span></td><td>Сколько студентов вышло из класса? Вышли два студента.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">كَمْ لُغَةً تَعْرِفُ؟ أَعْرِفُ <span class="ar-tone-nasb">لُغَتَيْنِ</span>.</span></td><td>Сколько языков ты знаешь? Я знаю два языка.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">كَمْ مُشْطًا تُرِيدُ؟ أُرِيدُ <span class="ar-tone-nasb">مُشْطَيْنِ</span>.</span></td><td>Сколько расчёсок ты хочешь? Я хочу две расчёски.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">بِكَمْ رِيَالًا اِشْتَرَيْتَ الْقَلَمَ؟ اِشْتَرَيْتُهُ <span class="ar-tone-jarr">بِرِيَالَيْنِ</span>.</span></td><td>За сколько риялов ты купил ручку? Я купил её за два рияла.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">كَمْ جَامِعَةً فِي بَلَدِكَ؟ فِي بَلَدِي <span class="ar-tone-raf">جَامِعَتَانِ</span>.</span></td><td>Сколько университетов в твоей стране? В моей стране два университета.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس العشرون
إعراب المثنى
المثنى: ما دل على اثنين أو اثنتين.
يرفع المثنى بالألف، وينصب ويجر بالياء، نحو:
دخل الطالبان.
الطالبان: فاعل مرفوع وعلامة رفعه الألف.
رأيت الطالبين.
الطالبين: مفعول به منصوب وعلامة نصبه الياء.
سلمت على الطالبين.
الطالبين: مجرور بـ(على) وعلامة جره الياء.$$,
      46, 46, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الْمُثَنَّى
الْمُثَنَّى: اسْمٌ يَدُلُّ عَلَى اثْنَيْنِ، أَوِ اثْنَتَيْنِ، بِزِيَادَةِ أَلِفٍ وَنُونٍ فِي آخِرِهِ.
إِعْرَابُهُ: يُرْفَعُ بِالْأَلِفِ، وَيُنْصَبُ بِالْيَاءِ، وَيُجَرُّ بِالْيَاءِ.
أَمْثِلَةٌ:
١- الرَّفْعُ: جَاءَ الْمُدَرِّسُ: جَاءَ الْمُدَرِّسَانِ ← فَاعِلٌ مَرْفُوعٌ وَعَلَامَةُ رَفْعِهِ الْأَلِفُ.
٢- النَّصْبُ: رَأَيْتُ الْمُدَرِّسَ: رَأَيْتُ الْمُدَرِّسَيْنِ ← مَفْعُولٌ بِهِ مَنْصُوبٌ وَعَلَامَةُ نَصْبِهِ الْيَاءُ.
٣- الْجَرُّ: ذَهَبْتُ إِلَى الْمُدَرِّسِ: ذَهَبْتُ إِلَى الْمُدَرِّسَيْنِ ← اسْمٌ مَجْرُورٌ وَعَلَامَةُ جَرِّهِ الْيَاءُ.
كَمْ أَخًا لَكَ؟ لِي أَخَوَانِ.
كَمْ طَالِبًا خَرَجَ مِنَ الْفَصْلِ؟ خَرَجَ طَالِبَانِ.
كَمْ لُغَةً تَعْرِفُ؟ أَعْرِفُ لُغَتَيْنِ.
كَمْ مُشْطًا تُرِيدُ؟ أُرِيدُ مُشْطَيْنِ.
بِكَمْ رِيَالًا اِشْتَرَيْتَ الْقَلَمَ؟ اِشْتَرَيْتُهُ بِرِيَالَيْنِ.
كَمْ جَامِعَةً فِي بَلَدِكَ؟ فِي بَلَدِي جَامِعَتَانِ.$$,
      39, 39, 2);

  -- 2. Masculine and feminine ways to distinguish two items.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'أَحَدُهُمَا وَالْآخَرُ ـ إِحْدَاهُمَا وَالْأُخْرَى (один/одна из двух и другой/другая)',
    rule_ar = '«أَحَدُهُمَا وَالْآخَرُ» أُسْلُوبٌ يُسْتَعْمَلُ عِنْدَ إِرَادَةِ التَّفْصِيلِ بَيْنَ شَيْئَيْنِ؛ وَمُؤَنَّثُ «أَحَدٌ» «إِحْدَى»، وَمُؤَنَّثُ «الْآخَرُ» «الْأُخْرَى».',
    summary = 'Конструкция различает два предмета или двух людей: для мужского рода используются أَحَدُهُمَا وَالْآخَرُ, для женского — إِحْدَاهُمَا وَالْأُخْرَى.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Мужские и женские формы</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">أَحَدُهُمَا وَالْآخَرُ</span> أُسْلُوبٌ يُسْتَعْمَلُ عِنْدَ إِرَادَةِ التَّفْصِيلِ بَيْنَ شَيْئَيْنِ.</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Род</th><th>Первый из двух</th><th>Второй</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td>Мужской</td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَحَدٌ ← أَحَدُهُمَا</span></td><td><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">الْآخَرُ</span></td><td>один из них — другой</td></tr>
            <tr><td>Женский</td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">إِحْدَى ← إِحْدَاهُمَا</span></td><td><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">الْأُخْرَى</span></td><td>одна из них — другая</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">جَاءَ الْيَوْمَ مُدَرِّسَانِ جَدِيدَانِ، <span class="ar-tone-subject">أَحَدُهُمَا</span> لِلْفِقْهِ وَ<span class="ar-tone-predicate">الْآخَرُ</span> لِلْحَدِيثِ.</span><span class="rule-example-ru">Сегодня пришли два новых преподавателя: один — по фикху, другой — по хадису.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">جَاءَتِ الْيَوْمَ مُدَرِّسَتَانِ جَدِيدَتَانِ، <span class="ar-tone-subject">إِحْدَاهُمَا</span> لِلسِّيرَةِ وَ<span class="ar-tone-predicate">الْأُخْرَى</span> لِلتَّفْسِيرِ.</span><span class="rule-example-ru">Сегодня пришли две новые преподавательницы: одна — по сире, другая — по тафсиру.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لِي أَخَوَانِ، <span class="ar-tone-subject">أَحَدُهُمَا</span> طَبِيبٌ وَ<span class="ar-tone-predicate">الْآخَرُ</span> مُهَنْدِسٌ.</span><span class="rule-example-ru">У меня два брата: один врач, другой инженер.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لِهَذِهِ الْحَافِلَةِ بَابَانِ، <span class="ar-tone-subject">أَحَدُهُمَا</span> لِلدُّخُولِ وَ<span class="ar-tone-predicate">الْآخَرُ</span> لِلْخُرُوجِ.</span><span class="rule-example-ru">У этого автобуса две двери: одна для входа, другая для выхода.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لِي أُخْتَانِ، <span class="ar-tone-subject">إِحْدَاهُمَا</span> مُدَرِّسَةٌ وَ<span class="ar-tone-predicate">الْأُخْرَى</span> طَبِيبَةٌ.</span><span class="rule-example-ru">У меня две сестры: одна преподавательница, другая врач.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">عِنْدِي سَيَّارَتَانِ، <span class="ar-tone-subject">إِحْدَاهُمَا</span> بَيْضَاءُ وَ<span class="ar-tone-predicate">الْأُخْرَى</span> حَمْرَاءُ.</span><span class="rule-example-ru">У меня две машины: одна белая, другая красная.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$أحدهما والآخر ـ إحداهما والأخرى
جاء اليوم مدرسان جديدان، أحدهما للفقه والآخر للحديث.
جاءت اليوم مدرستان جديدتان، إحداهما للسيرة والأخرى للتفسير.$$,
      46, 46, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$أَحَدُهُمَا، وَالْآخَرُ
أَحَدُهُمَا، وَالْآخَرُ: أُسْلُوبٌ يُسْتَعْمَلُ عِنْدَ إِرَادَةِ التَّفْصِيلِ بَيْنَ شَيْئَيْنِ.
أَحَدٌ: مُذَكَّرٌ، مُؤَنَّثُهُ: إِحْدَى ← أَحَدُهُمَا، وَإِحْدَاهُمَا.
الْآخَرُ: مُذَكَّرٌ، مُؤَنَّثُهُ: الْأُخْرَى.
أَمْثِلَةٌ:
لِي أَخَوَانِ أَحَدُهُمَا طَبِيبٌ وَالْآخَرُ مُهَنْدِسٌ.
لِهَذِهِ الْحَافِلَةِ بَابَانِ أَحَدُهُمَا لِلدُّخُولِ وَالْآخَرُ لِلْخُرُوجِ.
لِي أُخْتَانِ إِحْدَاهُمَا مُدَرِّسَةٌ وَالْأُخْرَى طَبِيبَةٌ.
عِنْدِي سَيَّارَتَانِ إِحْدَاهُمَا بَيْضَاءُ وَالْأُخْرَى حَمْرَاءُ.$$,
      39, 39, 2);

  -- 3. Dhu and dhatu, full declension and all six examples.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'ذُو وَذَاتُ (обладающий и обладающая; имеющий и имеющая)',
    rule_ar = '«ذُو» اسْمٌ مِنَ الْأَسْمَاءِ الْخَمْسَةِ، يُرْفَعُ بِالْوَاوِ، وَيُنْصَبُ بِالْأَلِفِ، وَيُجَرُّ بِالْيَاءِ؛ وَ«ذَاتُ» مُؤَنَّثُهُ، تُرْفَعُ بِالضَّمَّةِ، وَتُنْصَبُ بِالْفَتْحَةِ، وَتُجَرُّ بِالْكَسْرَةِ.',
    summary = 'Мужская форма ذُو относится к пяти именам и изменяется как ذُو/ذَا/ذِي; женская ذَاتُ склоняется посредством даммы, фатхи и касры.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полное склонение</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Род</th><th>Состояние</th><th>Форма</th><th>Показатель</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td>Мужской</td><td>Раф‘</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ذُو</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يُرْفَعُ بِالْوَاوِ</span><span class="rule-table-ru">поднимается посредством вау</span></td><td>обладающий; имеющий</td></tr>
            <tr><td>Мужской</td><td>Насб</td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">ذَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يُنْصَبُ بِالْأَلِفِ</span><span class="rule-table-ru">ставится в насб посредством алифа</span></td><td>обладающего; имеющего</td></tr>
            <tr><td>Мужской</td><td>Джарр</td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">ذِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يُجَرُّ بِالْيَاءِ</span><span class="rule-table-ru">ставится в джарр посредством йа</span></td><td>обладающем; имеющем</td></tr>
            <tr><td>Женский</td><td>Раф‘</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ذَاتُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تُرْفَعُ بِالضَّمَّةِ</span><span class="rule-table-ru">поднимается даммой</span></td><td>обладающая; имеющая</td></tr>
            <tr><td>Женский</td><td>Насб</td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">ذَاتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تُنْصَبُ بِالْفَتْحَةِ</span><span class="rule-table-ru">ставится в насб фатхой</span></td><td>обладающую; имеющую</td></tr>
            <tr><td>Женский</td><td>Джарр</td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">ذَاتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تُجَرُّ بِالْكَسْرَةِ</span><span class="rule-table-ru">ставится в джарр касрой</span></td><td>обладающей; имеющей</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры второго шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الْقَلَمُ <span class="ar-tone-raf">ذُو</span> اللَّوْنَيْنِ مُفِيدٌ.</span><span class="rule-example-ru">Эта двухцветная ручка полезна.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ السَّيَّارَةُ <span class="ar-tone-raf">ذَاتُ</span> اللَّوْنَيْنِ جَمِيلَةٌ.</span><span class="rule-example-ru">Эта двухцветная машина красива.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">غَسَلْتُ الْقَمِيصَ <span class="ar-tone-nasb">ذَا</span> الْجَيْبَيْنِ.</span><span class="rule-example-ru">Я постирал рубашку с двумя карманами.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">نَصَحْتُ الْفَتَاةَ <span class="ar-tone-nasb">ذَاتَ</span> الْوَجْهَيْنِ.</span><span class="rule-example-ru">Я дал совет девушке с двумя лицами.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">صَلَّيْتُ فِي الْمَسْجِدِ <span class="ar-tone-jarr">ذِي</span> الْمَنَارَتَيْنِ.</span><span class="rule-example-ru">Я молился в мечети с двумя минаретами.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">الْمُدِيرُ فِي الْغُرْفَةِ <span class="ar-tone-jarr">ذَاتِ</span> الْبَابَيْنِ.</span><span class="rule-example-ru">Директор находится в комнате с двумя дверями.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$ذُو، وَذَاتُ
ذُو: اسْمٌ مِنَ الْأَسْمَاءِ الْخَمْسَةِ، يُرْفَعُ بِالْوَاوِ، وَيُنْصَبُ بِالْأَلِفِ، وَيُجَرُّ بِالْيَاءِ.
ذَاتُ: مُؤَنَّثُ ذُو، يُرْفَعُ بِالضَّمَّةِ، وَيُنْصَبُ بِالْفَتْحَةِ، وَيُجَرُّ بِالْكَسْرَةِ.
هَذَا الْقَلَمُ ذُو اللَّوْنَيْنِ مُفِيدٌ.
هَذِهِ السَّيَّارَةُ ذَاتُ اللَّوْنَيْنِ جَمِيلَةٌ.
غَسَلْتُ الْقَمِيصَ ذَا الْجَيْبَيْنِ.
نَصَحْتُ الْفَتَاةَ ذَاتَ الْوَجْهَيْنِ.
صَلَّيْتُ فِي الْمَسْجِدِ ذِي الْمَنَارَتَيْنِ.
الْمُدِيرُ فِي الْغُرْفَةِ ذَاتِ الْبَابَيْنِ.$$,
      39, 39, 1);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '20'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 20 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id)
  ) <> 5 then
    raise exception 'Expected 5 Book 2 lesson 20 source rows';
  end if;
end
$migration$;

commit;
