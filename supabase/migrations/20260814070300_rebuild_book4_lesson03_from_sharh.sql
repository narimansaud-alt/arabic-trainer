-- Rebuild Medina Book 4 lesson 3 strictly from the supplied Arabic sharh.
-- Canonical PDF pages: 10-13. DOC text was used only for extraction and checked against the PDF.
begin;

do $migration$
declare
  existing_count integer;
begin
  select count(*) into existing_count
  from public.rules
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '3';
  if existing_count <> 3 then
    raise exception 'Expected 3 Book 4 lesson 3 rules, found %', existing_count;
  end if;
end $migration$;

with incoming(sort_order, title, content, summary, rule_ar) as (
  values
    (1, 'بَابُ تَفَعَّلَ (порода تَفَعَّلَ)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-verb" dir="rtl" lang="ar">بَابُ تَفَعَّلَ مَزِيدٌ بِالتَّاءِ وَالتَّضْعِيفِ، وَمَصْدَرُهُ عَلَى وَزْنِ تَفَعُّلٍ. وَمِنْ مَعَانِيهِ الْمُطَاوَعَةُ؛ فَيَصِيرُ الْمَفْعُولُ فَاعِلًا، وَيَصِيرُ الْمُتَعَدِّي إِلَى مَفْعُولٍ وَاحِدٍ لَازِمًا، وَالْمُتَعَدِّي إِلَى مَفْعُولَيْنِ مُتَعَدِّيًا إِلَى مَفْعُولٍ وَاحِدٍ. وَيَجُوزُ حَذْفُ إِحْدَى التَّاءَيْنِ مِنْ مُضَارِعِهِ الْمَبْدُوءِ بِالتَّاءِ.</span><p class="rule-study-text">В породе تَفَعَّلَ добавлены ت и удвоение второй коренной. Одно из её значений — принятие результата действия: объект исходного глагола становится исполнителем производного. В форме настоящего-будущего, начинающейся с ت, одну из двух ت разрешается опустить.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Термины и русский смысл</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-verb"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">حَرْفَا الزِّيَادَةِ: التَّاءُ وَالتَّضْعِيفُ</span><span class="rule-term-ru">два средства увеличения — ت и удвоение второй коренной</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">الْمَصْدَرُ: تَفَعُّلٌ</span><span class="rule-term-ru">масдар по модели تَفَعُّلٌ</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">الْمُطَاوَعَةُ</span><span class="rule-term-ru">принятие объектом результата действия</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Как меняется переходность</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">كَسَّرْتُ الزُّجَاجَ، فَتَكَسَّرَ الزُّجَاجُ.</span><span class="rule-example-ru">Я разбил стекло, и стекло разбилось: переходный глагол с одним объектом стал непереходным.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">عَلَّمْتُ الطَّالِبَ الْقُرْآنَ، فَتَعَلَّمَ الطَّالِبُ الْقُرْآنَ.</span><span class="rule-example-ru">Я обучил студента Корану, и студент выучил Коран: глагол с двумя объектами стал переходным к одному объекту.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Производные формы шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْمَاضِي</span><span class="rule-table-ru">прошедшее</span></th><th><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْمُضَارِعُ</span><span class="rule-table-ru">настояще-будущее</span></th><th><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْأَمْرُ</span><span class="rule-table-ru">повелительное</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْمَصْدَرُ</span><span class="rule-table-ru">масдар</span></th><th><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">اسْمُ الْفَاعِلِ</span><span class="rule-table-ru">действующее причастие</span></th><th><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">اسْمُ الْمَفْعُولِ</span><span class="rule-table-ru">страдательное причастие</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَوَكَّلَ</span><span class="rule-table-ru">уповал</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَتَوَكَّلُ</span><span class="rule-table-ru">уповает</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَوَكَّلْ</span><span class="rule-table-ru">уповай</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">تَوَكُّلٌ</span><span class="rule-table-ru">упование</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُتَوَكِّلٌ</span><span class="rule-table-ru">уповающий</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">لَازِمٌ</span><span class="rule-table-ru">непереходный; страдательное причастие не приводится</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَمَنَّى</span><span class="rule-table-ru">пожелал</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَتَمَنَّى</span><span class="rule-table-ru">желает</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَمَنَّ</span><span class="rule-table-ru">пожелай</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">تَمَنٍّ (أَصْلُهُ تَمَنُّيٌ)</span><span class="rule-table-ru">желание; исходная форма تَمَنُّيٌ</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُتَمَنٍّ (الْمُتَمَنِّي)</span><span class="rule-table-ru">желающий</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">مُتَمَنًّى</span><span class="rule-table-ru">желаемое</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَحَدَّثَ</span><span class="rule-table-ru">беседовал</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَتَحَدَّثُ</span><span class="rule-table-ru">беседует</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَحَدَّثْ</span><span class="rule-table-ru">беседуй</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">تَحَدُّثٌ</span><span class="rule-table-ru">беседа</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُتَحَدِّثٌ</span><span class="rule-table-ru">говорящий, собеседник</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">لَازِمٌ</span><span class="rule-table-ru">непереходный; страдательное причастие не приводится</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَدَبَّرَ</span><span class="rule-table-ru">обдумал</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَتَدَبَّرُ</span><span class="rule-table-ru">обдумывает</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَدَبَّرْ</span><span class="rule-table-ru">обдумай</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">تَدَبُّرٌ</span><span class="rule-table-ru">обдумывание</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُتَدَبِّرٌ</span><span class="rule-table-ru">обдумывающий</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">مُتَدَبَّرٌ</span><span class="rule-table-ru">обдумываемое</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Допустимое удаление одной ت</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿تَنَزَّلُ ٱلۡمَلَٰٓئِكَةُ﴾</span><span class="rule-example-ru">Нисходят ангелы. Исходная форма глагола: تَتَنَزَّلُ.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿وَلَا تَجَسَّسُواْ﴾</span><span class="rule-example-ru">И не выслеживайте друг друга. Исходная форма глагола: تَتَجَسَّسُوا.</span></div></div></div></div>', 'В породе تَفَعَّلَ добавлены ت и удвоение второй коренной. Одно из её значений — принятие результата действия: объект исходного глагола становится исполнителем производного. В форме настоящего-будущего, начинающейся с ت, одну из двух ت разрешается опустить.', 'بَابُ تَفَعَّلَ مَزِيدٌ بِالتَّاءِ وَالتَّضْعِيفِ، وَمَصْدَرُهُ عَلَى وَزْنِ تَفَعُّلٍ. وَمِنْ مَعَانِيهِ الْمُطَاوَعَةُ؛ فَيَصِيرُ الْمَفْعُولُ فَاعِلًا، وَيَصِيرُ الْمُتَعَدِّي إِلَى مَفْعُولٍ وَاحِدٍ لَازِمًا، وَالْمُتَعَدِّي إِلَى مَفْعُولَيْنِ مُتَعَدِّيًا إِلَى مَفْعُولٍ وَاحِدٍ. وَيَجُوزُ حَذْفُ إِحْدَى التَّاءَيْنِ مِنْ مُضَارِعِهِ الْمَبْدُوءِ بِالتَّاءِ.'),
    (2, 'لَمَّا الْحِينِيَّةُ (временная لَمَّا — «когда, как только»)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-particle" dir="rtl" lang="ar">لَمَّا الْحِينِيَّةُ ظَرْفُ زَمَانٍ مَبْنِيٌّ عَلَى السُّكُونِ فِي مَحَلِّ نَصْبٍ، تَتَضَمَّنُ مَعْنَى الشَّرْطِ، وَتَخْتَصُّ بِالزَّمَانِ الْمَاضِي؛ فَفِعْلُ شَرْطِهَا وَجَوَابُهَا مَاضِيَانِ، وَهِيَ غَيْرُ جَازِمَةٍ.</span><p class="rule-study-text">Временная لَمَّا является обстоятельством времени в винительном месте и содержит условный смысл. Она относится к прошлому: действие условия и ответ стоят в прошедшем времени; глаголы она не усекает.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Термины и русский смысл</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">ظَرْفُ زَمَانٍ</span><span class="rule-term-ru">обстоятельство времени</span></div><div class="rule-meaning-card rule-term-verb"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلُ الشَّرْطِ</span><span class="rule-term-ru">действие условия</span></div><div class="rule-meaning-card rule-term-predicate"><span class="rule-term-ar ar-tone-predicate" dir="rtl" lang="ar">جَوَابُ الشَّرْطِ</span><span class="rule-term-ru">ответ условия</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">غَيْرُ جَازِمَةٍ</span><span class="rule-term-ru">не ставит глагол в усечённое наклонение</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿فَلَمَّا رَءَاهُ مُسۡتَقِرًّا عِندَهُۥ قَالَ هَٰذَا مِن فَضۡلِ رَبِّي﴾</span><span class="rule-example-ru">Когда он увидел его установленным перед собой, он сказал: «Это — из милости моего Господа».</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar ar-tone-structure" dir="rtl" lang="ar">لَمَّا وَصَلْتُ الْمَدِينَةَ صَلَّيْتُ رَكْعَتَيْنِ فِي الْمَسْجِدِ النَّبَوِيِّ الشَّرِيفِ.</span><span class="rule-example-ru">Когда я прибыл в Медину, я совершил два ракята в Благородной мечети Пророка.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar ar-tone-structure" dir="rtl" lang="ar">لَمَّا سَمِعَ الطَّالِبُ الْأَذَانَ تَوَضَّأَ.</span><span class="rule-example-ru">Когда студент услышал азан, он совершил омовение.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полный разбор لَمَّا جَاءَ الْمُدَرِّسُ دَخَلَ الطُّلَّابُ</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">لَمَّا: ظَرْفُ زَمَانٍ مَبْنِيٌّ عَلَى السُّكُونِ فِي مَحَلِّ نَصْبٍ.</span><span class="rule-example-ru">لَمَّا — обстоятельство времени, неизменяемое на сукуне, занимает винительное место.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">جَاءَ: فِعْلُ الشَّرْطِ، فِعْلٌ مَاضٍ مَبْنِيٌّ عَلَى الْفَتْحِ.</span><span class="rule-example-ru">جَاءَ — действие условия; глагол прошедшего времени, неизменяемый на фатхе.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar ar-tone-subject" dir="rtl" lang="ar">الْمُدَرِّسُ: فَاعِلٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ، وَجُمْلَةُ الشَّرْطِ «جَاءَ الْمُدَرِّسُ» فِي مَحَلِّ جَرٍّ بِالْإِضَافَةِ.</span><span class="rule-example-ru">الْمُدَرِّسُ — исполнитель действия в именительном статусе с явной даммой; всё предложение условия занимает родительное место как добавление к لَمَّا.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">دَخَلَ: جَوَابُ الشَّرْطِ، فِعْلٌ مَاضٍ مَبْنِيٌّ عَلَى الْفَتْحِ.</span><span class="rule-example-ru">دَخَلَ — ответ условия; глагол прошедшего времени, неизменяемый на фатхе.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar ar-tone-subject" dir="rtl" lang="ar">الطُّلَّابُ: فَاعِلٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ، وَجُمْلَةُ الْجَوَابِ «دَخَلَ الطُّلَّابُ» لَا مَحَلَّ لَهَا مِنَ الْإِعْرَابِ؛ لِأَنَّ لَمَّا غَيْرُ جَازِمَةٍ.</span><span class="rule-example-ru">الطُّلَّابُ — исполнитель действия в именительном статусе с явной даммой; предложение ответа не имеет синтаксического места, поскольку لَمَّا не является усекающей частицей.</span></div></div></div></div>', 'Временная لَمَّا является обстоятельством времени в винительном месте и содержит условный смысл. Она относится к прошлому: действие условия и ответ стоят в прошедшем времени; глаголы она не усекает.', 'لَمَّا الْحِينِيَّةُ ظَرْفُ زَمَانٍ مَبْنِيٌّ عَلَى السُّكُونِ فِي مَحَلِّ نَصْبٍ، تَتَضَمَّنُ مَعْنَى الشَّرْطِ، وَتَخْتَصُّ بِالزَّمَانِ الْمَاضِي؛ فَفِعْلُ شَرْطِهَا وَجَوَابُهَا مَاضِيَانِ، وَهِيَ غَيْرُ جَازِمَةٍ.'),
    (3, 'الِاسْمُ الْمَنْصُوبُ عَلَى الِاخْتِصَاصِ (имя в винительном статусе для уточняющего выделения)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-nasb" dir="rtl" lang="ar">يُؤْتَى بِالِاسْمِ الْمَنْصُوبِ عَلَى الِاخْتِصَاصِ لِبَيَانِ الْمَقْصُودِ بِالضَّمِيرِ السَّابِقِ، وَيُنْصَبُ مَفْعُولًا بِهِ لِفِعْلٍ مَحْذُوفٍ وُجُوبًا تَقْدِيرُهُ أَخُصُّ. وَيَكُونُ مُعَرَّفًا بِأَلْ أَوْ بِالْإِضَافَةِ.</span><p class="rule-study-text">После местоимения ставится уточняющее имя, показывающее, кого именно оно обозначает. Это имя считается объектом обязательно опущенного глагола со значением «особо выделяю» и бывает определённым с помощью артикля или идафы.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Два вида</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">النَّوْعُ</span><span class="rule-table-ru">вид</span></th><th><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">الْمِثَالُ</span><span class="rule-table-ru">пример и перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُعَرَّفٌ بِأَلْ</span><span class="rule-table-ru">определено артиклем</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">نَحْنُ الطُّلَّابَ نُحِبُّ الْعِلْمَ.</span><span class="rule-table-ru">Мы, студенты, любим знание.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُعَرَّفٌ بِأَلْ</span><span class="rule-table-ru">определено артиклем</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">نَحْنُ الْمُسْلِمِينَ لَا نُشْرِكُ بِاللَّهِ شَيْئًا.</span><span class="rule-table-ru">Мы, мусульмане, никого и ничего не приобщаем к Аллаху.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُعَرَّفٌ بِالْإِضَافَةِ</span><span class="rule-table-ru">определено через идафу</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">نَحْنُ طُلَّابَ الْعِلْمِ نَجْتَهِدُ فِي دُرُوسِنَا.</span><span class="rule-table-ru">Мы, искатели знания, усердствуем в наших уроках.</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Пример шарха из хадиса</span><div class="rule-example-list"><div class="rule-example-card rule-term-nasb"><span class="rule-example-ar ar-tone-nasb" dir="rtl" lang="ar">إِنَّا مَعْشَرَ الْأَنْبِيَاءِ لَا نُورَثُ.</span><span class="rule-example-ru">Поистине, мы, сонм пророков, не оставляем наследства.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полный разбор نَحْنُ الطُّلَّابَ نُحِبُّ الْعِلْمَ</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar ar-tone-subject" dir="rtl" lang="ar">نَحْنُ: ضَمِيرُ رَفْعٍ مُنْفَصِلٌ مَبْنِيٌّ عَلَى الضَّمِّ فِي مَحَلِّ رَفْعٍ مُبْتَدَأٌ.</span><span class="rule-example-ru">نَحْنُ — отдельное местоимение именительного разряда, неизменяемое на дамме; занимает место подлежащего.</span></div><div class="rule-example-card rule-term-nasb"><span class="rule-example-ar ar-tone-nasb" dir="rtl" lang="ar">الطُّلَّابَ: مَفْعُولٌ بِهِ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ، لِفِعْلٍ مَحْذُوفٍ وُجُوبًا تَقْدِيرُهُ أَخُصُّ.</span><span class="rule-example-ru">الطُّلَّابَ — объект в винительном статусе с явной фатхой при обязательно опущенном глаголе со значением «особо выделяю».</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar ar-tone-predicate" dir="rtl" lang="ar">جُمْلَةُ «نُحِبُّ الْعِلْمَ» فِي مَحَلِّ رَفْعٍ خَبَرُ نَحْنُ.</span><span class="rule-example-ru">Предложение «любим знание» занимает именительное место сказуемого при نَحْنُ.</span></div></div></div></div>', 'После местоимения ставится уточняющее имя, показывающее, кого именно оно обозначает. Это имя считается объектом обязательно опущенного глагола со значением «особо выделяю» и бывает определённым с помощью артикля или идафы.', 'يُؤْتَى بِالِاسْمِ الْمَنْصُوبِ عَلَى الِاخْتِصَاصِ لِبَيَانِ الْمَقْصُودِ بِالضَّمِيرِ السَّابِقِ، وَيُنْصَبُ مَفْعُولًا بِهِ لِفِعْلٍ مَحْذُوفٍ وُجُوبًا تَقْدِيرُهُ أَخُصُّ. وَيَكُونُ مُعَرَّفًا بِأَلْ أَوْ بِالْإِضَافَةِ.')
)
update public.rules as r
set title = incoming.title,
    content = incoming.content,
    rule_kind = 'rule',
    summary = incoming.summary,
    rule_ar = incoming.rule_ar
from incoming
where r.course_name = 'Мединский курс (Том 4)'
  and r.lesson_number = '3'
  and r.sort_order = incoming.sort_order;

delete from public.rule_sources
where rule_id in (
  select id from public.rules
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '3'
);

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'الدَّرْسُ الثَّالِثُ
بَـابُ تَفَعَّلَ
من أمثلته : تَعَلَّمَ , تَحَدَّثَ ، تَغَدَّى .
حرفا الزِّيادة : التَّاء ، والتَّضعيف .
مصدره : تفَعُّلٌ (كُلُّ فعلٍ بُدِئَ بالتَّاء الزَّائدة ضُمَّ ما قبل آخره ) .
نحو : تحَدَّثَ : تحَدُّثٌ ، تَسَلَّمَ : تَسَلُّمٌ .
من معانيه :
- الْمُطَاوَعَةُ : وهي قَبُولُ أَثَرِ الفعلِ , فيصير المفعول فاعلا ، أي : أنَّ المطاوعةَ تَجْعَلُ الفعلَ المتعدَّي إلى مفعول واحد لازماً ، نحو : كسَّرتُ الزُّجَاجَ , فتَكَسَّرَ الزُّجَاجُ .
وتجعل المتعدي إلى مفعولين متعديًّا إلى مفعول واحد ، نحو :                                علَّمْتُ الطالبَ القرآنَ ، فتعلَّمَ الطالبُ القرآنَ .
المشتقات :
اسم المفعول
| اسم الفاعل
| المصدر
| الأمر
| المضارع
| الماضي
|
| ( لازم )
| مُتَوَكِّلٌ
| تَوَكُّلٌ
| تَوَكَّلْ
| يَتَوَكَّلُ
| تَوَكَّلَ
|
| مُتَمَنًّى
| مُتَمَنٍّ (الْمُتَمَنَّي)
| تَمَنٍّ (أصله تَمَنُّيٌ)
| تَمَنَّ
| يَتَمَنَّى
| تَمَنَّى
|
| ( لازم )
| مُتَحَدِّثٌ
| تَحَدُّثٌ
| تَحَدَّثْ
| يَتَحَدَّثُ
| تَحَدَّثَ
|
| مُتَدَبَّرٌ
| مُتَدَبِّرٌ
| تَدَبُّرٌ
| تَدَبَّرْ
| يَتَدَبَّرُ
| تَدَبَّرَ
|
|
يجوز حذف إحدى التَّاءين في باب تَفَعَّلَ إذا كان مضارعاً مبدوءاً بالتاء ، نحو قوله تعالى :
﴿ تَنَزَّلُ الْمَلَائِكَةُ ﴾ والأصل: تَتَنَزَّلُ الملائكةُ  ، وقوله تعالى : ﴿ وَلَا تَجَسَّسُوا ﴾ والأصل:  ولا تَتَجَسَّسُوا .', 10, 11, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '3' and sort_order = 1;

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'لَمَّا الحِينِيَّةُ
ظرفُ زمانٍ مبنيٌّ على السكون في محل نصب . تتضمن معنى الشرط ، فهي تحتاج إلى فعل
شرط وإلى جواب . تختص بالزمان الماضي ، فشرطها وجوابها ماضيان .
الأمثلة : قال تعالى : ﴿ فَلَمَّا رَآهُ مُسْتَقِرًّا عِنْدَهُ قَالَ هَذَا مِنْ فَضْلِ رَبِّي ﴾ .
ونحو قولك : لَمَّا وصلتُ المدينة صليتُ ركعتين في المسجد النبوي الشريف .
ونحو : لَمَّا سَمِعَ الطَّالبُ الأذانَ تَوَضَّأَ .
الإعراب : لماَّ جاءَ المدرسُ دخلَ الطلابُ .
لماَّ : ظرف زمان مبني على السكون في محل نصب .
جاء : فعلُ الشرطِ فعلٌ ماضٍ مبني على الفتح .
المدرسُ : فاعل مرفوع وعلامة رفعه الضمة الظاهرة ، وجملة الشرط ( جاءَ المدرسُ ) في
محل جر مضاف إليه .
دخلَ : جواب الشرط فعلٌ ماضٍ مبني على الفتح .
الطُّلابُ : فاعل مرفوع وعلامة رفعه الضمه الظاهرة ، وجملة الجواب ( دخلَ الطُّلابُ )
لا محلَّ لها من الإعراب . ( لأن لَمَّا غير جازمة ) .', 11, 12, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '3' and sort_order = 2;

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'الاسمُ المنصوبُ على الاخْتِصَاصِ
يُؤْتَى به لبيان المقصود بالضمير الذي قبله ، ويُنْصَبُ على أنه مفعول به لفعل محذوف وجوبا تقديره ( أَخُصُّ ) .
أنواعـه :
أ- معَرَّفٌ بأَلْ ، نحو : نحن الطلابَ نُحِبُّ العلمَ . نحن المسلمين لا نشركُ باللهِ شيئاً .
ب- معَرَّفٌ بالإضافةِ ، نحو : نحن طلابَ العلمِ نجتهدُ في دروسنا .
ومنه قوله صلى الله عليه وسلم : " إنَّا مَعْشَرَ الأنبياءِ لا نُوْرَثُ "
الإعراب : نحنُ الطُّلاَّبَ نحبُّ العلمَ .                                                       نحنُ : ضمير رفع منفصل مبني على الضم في محل رفع مبتدأ.
الطُّلابَ : مفعول به منصوب وعلامة نصبه الفتحة الظاهرة لفعل محذوف وجوبا، تقديره
( أَخُصُّ ) ، وجملة ( نحبُّ العلمَ ) في محلِّ رفع خبر نحن .', 12, 13, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '3' and sort_order = 3;

do $migration$
declare
  updated_count integer;
  source_count integer;
begin
  select count(*) into updated_count
  from public.rules
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '3' and rule_ar is not null and btrim(rule_ar) <> '';
  select count(*) into source_count
  from public.rule_sources rs
  join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 4)' and r.lesson_number = '3';
  if updated_count <> 3 or source_count <> 3 then
    raise exception 'Book 4 lesson 3 QA failed: rules %, sources %', updated_count, source_count;
  end if;
end $migration$;

commit;
