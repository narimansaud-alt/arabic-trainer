-- Rebuild Medina Book 4 lesson 2 strictly from the supplied Arabic sharh.
-- Canonical PDF pages: 7-10. DOC text was used only for extraction and checked against the PDF.
begin;

do $migration$
declare
  existing_count integer;
begin
  select count(*) into existing_count
  from public.rules
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '2';
  if existing_count not in (6, 7) then
    raise exception 'Expected 6 legacy or 7 rebuilt Book 4 lesson 2 rules, found %', existing_count;
  end if;
end $migration$;

-- The legacy lesson merged two independent sharh topics into one card. Preserve all
-- existing IDs, make room at sort order 5, and create exactly one new rule row.
update public.rules
set sort_order = 7
where id = 1800
  and course_name = 'Мединский курс (Том 4)'
  and lesson_number = '2';

update public.rules
set sort_order = 6
where id = 1799
  and course_name = 'Мединский курс (Том 4)'
  and lesson_number = '2';

insert into public.rules (
  course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar
)
select
  'Мединский курс (Том 4)', '2', '__book4_lesson2_kaf_al_khitab__', '', 5, 'rule', '', null
where not exists (
  select 1
  from public.rules
  where course_name = 'Мединский курс (Том 4)'
    and lesson_number = '2'
    and sort_order = 5
);

with incoming(sort_order, title, content, summary, rule_ar) as (
  values
    (1, 'بَابُ فَاعَلَ (порода فَاعَلَ)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-verb" dir="rtl" lang="ar">بَابُ فَاعَلَ مَزِيدٌ بِالْأَلِفِ بَعْدَ الْفَاءِ، وَلِمَصْدَرِهِ وَزْنَانِ: مُفَاعَلَةٌ وَفِعَالٌ. وَمِنْ مَعَانِيهِ الْمُشَارَكَةُ، وَقَدْ يَأْتِي بِمَعْنَى فَعَلَ.</span><p class="rule-study-text">В породе فَاعَلَ добавлена алиф после первой коренной. Шарх приводит две модели масдара и два значения: взаимное участие либо значение простого глагола فَعَلَ.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Термины и русский смысл</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-verb"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">حَرْفُ الزِّيَادَةِ: الْأَلِفُ</span><span class="rule-term-ru">добавочная буква — алиф</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">مُفَاعَلَةٌ وَفِعَالٌ</span><span class="rule-term-ru">две модели масдара</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">الْمُشَارَكَةُ</span><span class="rule-term-ru">взаимное участие в действии</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Значения на примерах шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">صَافَحَ الرَّجُلُ أَخَاهُ.</span><span class="rule-example-ru">Мужчина пожал руку своему брату.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">قَاتَلَ الْمُسْلِمُونَ الْمُشْرِكِينَ.</span><span class="rule-example-ru">Мусульмане сражались с многобожниками.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">سَافَرَ، هَاجَرَ، جَاوَزَ.</span><span class="rule-example-ru">путешествовал; переселился; миновал — здесь порода употреблена в значении простого глагола.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Производные формы шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْمَاضِي</span><span class="rule-table-ru">прошедшее</span></th><th><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْمُضَارِعُ</span><span class="rule-table-ru">настояще-будущее</span></th><th><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْأَمْرُ</span><span class="rule-table-ru">повелительное</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْمَصْدَرُ</span><span class="rule-table-ru">масдар</span></th><th><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">اسْمُ الْفَاعِلِ</span><span class="rule-table-ru">действующее причастие</span></th><th><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">اسْمُ الْمَفْعُولِ</span><span class="rule-table-ru">страдательное причастие</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">صَافَحَ</span><span class="rule-table-ru">пожал руку</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يُصَافِحُ</span><span class="rule-table-ru">пожимает руку</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">صَافِحْ</span><span class="rule-table-ru">пожми руку</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُصَافَحَةٌ</span><span class="rule-table-ru">рукопожатие</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُصَافِحٌ</span><span class="rule-table-ru">пожимающий руку</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">مُصَافَحٌ</span><span class="rule-table-ru">тот, кому пожимают руку</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">سَافَرَ</span><span class="rule-table-ru">путешествовал</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يُسَافِرُ</span><span class="rule-table-ru">путешествует</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">سَافِرْ</span><span class="rule-table-ru">путешествуй</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">سَفَرٌ وَمُسَافَرَةٌ</span><span class="rule-table-ru">путешествие</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُسَافِرٌ</span><span class="rule-table-ru">путешественник</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">لَازِمٌ</span><span class="rule-table-ru">форма страдательного причастия не приводится: глагол непереходный</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَادَى</span><span class="rule-table-ru">позвал</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يُنَادِي</span><span class="rule-table-ru">зовёт</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">نَادِ</span><span class="rule-table-ru">позови</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُنَادَاةٌ وَنِدَاءٌ</span><span class="rule-table-ru">зов, обращение</span></td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">مُنَادٍ (الْمُنَادِي)</span><span class="rule-table-ru">зовущий</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">مُنَادًى (الْمُنَادَى)</span><span class="rule-table-ru">тот, к кому обращаются</span></td></tr></tbody></table></div></div></div>', 'В породе فَاعَلَ добавлена алиф после первой коренной. Шарх приводит две модели масдара и два значения: взаимное участие либо значение простого глагола فَعَلَ.', 'بَابُ فَاعَلَ مَزِيدٌ بِالْأَلِفِ بَعْدَ الْفَاءِ، وَلِمَصْدَرِهِ وَزْنَانِ: مُفَاعَلَةٌ وَفِعَالٌ. وَمِنْ مَعَانِيهِ الْمُشَارَكَةُ، وَقَدْ يَأْتِي بِمَعْنَى فَعَلَ.'),
    (2, 'مَعَانِي قَدْ (значения частицы قَدْ)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-particle" dir="rtl" lang="ar">تَدْخُلُ قَدْ عَلَى الْفِعْلِ الْمَاضِي فَتُفِيدُ التَّوْكِيدَ وَالتَّحْقِيقَ، وَتَدْخُلُ عَلَى الْمُضَارِعِ فَتُفِيدُ الِاحْتِمَالَ وَالشَّكَّ، أَوِ التَّقْلِيلَ، أَوِ التَّحْقِيقَ.</span><p class="rule-study-text">С прошедшим временем قَدْ выражает подтверждение и осуществлённость. С настоящим-будущим она по контексту выражает вероятность/сомнение, редкость действия либо его достоверность.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Значение по форме глагола</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ</span><span class="rule-table-ru">форма глагола</span></th><th><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">مَعْنَى قَدْ</span><span class="rule-table-ru">значение قَدْ</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْمِثَالُ</span><span class="rule-table-ru">пример и перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْمَاضِي</span><span class="rule-table-ru">прошедшее время</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">التَّوْكِيدُ وَالتَّحْقِيقُ</span><span class="rule-table-ru">подтверждение, осуществлённость</span></td><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">قَدْ نَجَحْتَ.</span><span class="rule-table-ru">Ты действительно преуспел.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْمُضَارِعُ</span><span class="rule-table-ru">настояще-будущее время</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الِاحْتِمَالُ وَالشَّكُّ</span><span class="rule-table-ru">вероятность и сомнение</span></td><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">قَدْ يَأْتِي الْمُدِيرُ.</span><span class="rule-table-ru">Возможно, директор придёт.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْمُضَارِعُ</span><span class="rule-table-ru">настояще-будущее время</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">التَّقْلِيلُ</span><span class="rule-table-ru">редкость действия</span></td><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">قَدْ يَرْسُبُ الْمُجْتَهِدُ، وَقَدْ يَصْدُقُ الْكَذُوبُ.</span><span class="rule-table-ru">Иногда прилежный терпит неудачу, а отъявленный лжец говорит правду.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْمُضَارِعُ</span><span class="rule-table-ru">настояще-будущее время</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">التَّحْقِيقُ</span><span class="rule-table-ru">достоверность</span></td><td><span class="rule-table-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿قَدۡ يَعۡلَمُ ٱللَّهُ ٱلۡمُعَوِّقِينَ مِنكُمۡ﴾</span><span class="rule-table-ru">Аллах, несомненно, знает тех из вас, кто препятствует.</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Коранические примеры шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿قَدۡ أَفۡلَحَ ٱلۡمُؤۡمِنُونَ﴾</span><span class="rule-example-ru">Верующие уже преуспели.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿قَدۡ نَعۡلَمُ إِنَّهُۥ لَيَحۡزُنُكَ ٱلَّذِي يَقُولُونَ﴾</span><span class="rule-example-ru">Мы, несомненно, знаем, что тебя печалит то, что они говорят.</span></div></div></div></div>', 'С прошедшим временем قَدْ выражает подтверждение и осуществлённость. С настоящим-будущим она по контексту выражает вероятность/сомнение, редкость действия либо его достоверность.', 'تَدْخُلُ قَدْ عَلَى الْفِعْلِ الْمَاضِي فَتُفِيدُ التَّوْكِيدَ وَالتَّحْقِيقَ، وَتَدْخُلُ عَلَى الْمُضَارِعِ فَتُفِيدُ الِاحْتِمَالَ وَالشَّكَّ، أَوِ التَّقْلِيلَ، أَوِ التَّحْقِيقَ.'),
    (3, 'تَخْفِيفُ لَكِنَّ: لَكِنْ (облегчение لَكِنَّ до لَكِنْ)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-particle" dir="rtl" lang="ar">إِذَا خُفِّفَتْ لَكِنَّ فَصَارَتْ لَكِنْ بَطَلَ عَمَلُهَا، وَدَخَلَتْ عَلَى الْجُمْلَةِ الِاسْمِيَّةِ وَالْفِعْلِيَّةِ، وَأَفَادَتِ الِاسْتِدْرَاكَ.</span><p class="rule-study-text">После снятия удвоения لَكِنْ перестаёт управлять именем и сказуемым, может вводить именное и глагольное предложение и выражает поправку или противопоставление.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿لَٰكِنِ ٱلظَّٰلِمُونَ ٱلۡيَوۡمَ فِي ضَلَٰلٖ مُّبِينٖ﴾</span><span class="rule-example-ru">Но несправедливые сегодня находятся в явном заблуждении.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">جَاءَ عَلِيٌّ لَكِنْ أَخُوهُ غَائِبٌ.</span><span class="rule-example-ru">Али пришёл, однако его брат отсутствует.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿وَلَٰكِن لَّا تَشۡعُرُونَ﴾</span><span class="rule-example-ru">Однако вы не ощущаете.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">جَاءَ عَلِيٌّ لَكِنْ غَابَ خَالِدٌ.</span><span class="rule-example-ru">Али пришёл, однако Халид отсутствовал.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">جَاءَ عَلِيٌّ وَلَكِنْ غَابَ خَالِدٌ.</span><span class="rule-example-ru">Али пришёл, но Халид отсутствовал.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полный разбор جَاءَ الْمُدَرِّسُ لَكِنِ الطُّلَّابُ غَابُوا</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">جَاءَ: فِعْلٌ مَاضٍ مَبْنِيٌّ عَلَى الْفَتْحِ.</span><span class="rule-example-ru">جَاءَ — глагол прошедшего времени, неизменяемый на фатхе.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar ar-tone-subject" dir="rtl" lang="ar">الْمُدَرِّسُ: فَاعِلٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ.</span><span class="rule-example-ru">الْمُدَرِّسُ — исполнитель действия в именительном статусе; признак — явная дамма.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">لَكِنْ: حَرْفُ ابْتِدَاءٍ وَاسْتِدْرَاكٍ مَبْنِيٌّ عَلَى السُّكُونِ لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ.</span><span class="rule-example-ru">لَكِنْ — неизменяемая на сукуне частица начала и поправки; синтаксического места не имеет.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar ar-tone-subject" dir="rtl" lang="ar">الطُّلَّابُ: مُبْتَدَأٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ.</span><span class="rule-example-ru">الطُّلَّابُ — подлежащее именного предложения в именительном статусе; признак — явная дамма.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar ar-tone-predicate" dir="rtl" lang="ar">غَابُوا: فِعْلٌ وَفَاعِلٌ، وَالْجُمْلَةُ الْفِعْلِيَّةُ فِي مَحَلِّ رَفْعٍ خَبَرُ الْمُبْتَدَإِ، وَجُمْلَةُ «الطُّلَّابُ غَابُوا» ابْتِدَائِيَّةٌ لَا مَحَلَّ لَهَا مِنَ الْإِعْرَابِ.</span><span class="rule-example-ru">غَابُوا — глагол с исполнителем; глагольное предложение занимает место сказуемого в именительном статусе. Всё предложение «студенты отсутствовали» является начальным и синтаксического места не имеет.</span></div></div></div></div>', 'После снятия удвоения لَكِنْ перестаёт управлять именем и сказуемым, может вводить именное и глагольное предложение и выражает поправку или противопоставление.', 'إِذَا خُفِّفَتْ لَكِنَّ فَصَارَتْ لَكِنْ بَطَلَ عَمَلُهَا، وَدَخَلَتْ عَلَى الْجُمْلَةِ الِاسْمِيَّةِ وَالْفِعْلِيَّةِ، وَأَفَادَتِ الِاسْتِدْرَاكَ.'),
    (4, 'ذَوُو وَأُولُو (ذَوُو и أُولُو со значением «обладатели»)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-structure" dir="rtl" lang="ar">ذَوُو وَأُولُو مُلْحَقَتَانِ بِجَمْعِ الْمُذَكَّرِ السَّالِمِ، فَتُرْفَعَانِ بِالْوَاوِ، وَتُنْصَبَانِ وَتُجَرَّانِ بِالْيَاءِ، وَهُمَا بِمَعْنَى أَصْحَابٍ.</span><p class="rule-study-text">Оба слова означают «обладатели» и получают окончания как правильное мужское множественное: و в именительном, ي в винительном и родительном статусе.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Три состояния</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْحَالَةُ</span><span class="rule-table-ru">состояние</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الصِّيغَةُ</span><span class="rule-table-ru">форма</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْمِثَالُ</span><span class="rule-table-ru">пример и перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">именительный статус</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">ذَوُو، أُولُو</span><span class="rule-table-ru">окончание و</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">نَحْنُ ذَوُو عِلْمٍ وَأُولُو فَضْلٍ.</span><span class="rule-table-ru">Мы — обладатели знания и достоинства.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">винительный статус</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">ذَوِي، أُولِي</span><span class="rule-table-ru">окончание ي</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">رَأَيْتُ ذَوِي عِلْمٍ وَأُولِي فَضْلٍ.</span><span class="rule-table-ru">Я увидел обладателей знания и достоинства.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">родительный статус</span></td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">ذَوِي، أُولِي</span><span class="rule-table-ru">окончание ي</span></td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">ذَهَبْتُ إِلَى ذَوِي عِلْمٍ وَأُولِي فَضْلٍ.</span><span class="rule-table-ru">Я пошёл к обладателям знания и достоинства.</span></td></tr></tbody></table></div></div></div>', 'Оба слова означают «обладатели» и получают окончания как правильное мужское множественное: و в именительном, ي в винительном и родительном статусе.', 'ذَوُو وَأُولُو مُلْحَقَتَانِ بِجَمْعِ الْمُذَكَّرِ السَّالِمِ، فَتُرْفَعَانِ بِالْوَاوِ، وَتُنْصَبَانِ وَتُجَرَّانِ بِالْيَاءِ، وَهُمَا بِمَعْنَى أَصْحَابٍ.'),
    (5, 'تَصَرُّفُ كَافِ الْخِطَابِ فِي اسْمَيِ الْإِشَارَةِ (изменение كَافُ الْخِطَابِ в указательных именах)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-structure" dir="rtl" lang="ar">تَتَصَرَّفُ كَافُ الْخِطَابِ فِي اسْمَيِ الْإِشَارَةِ ذَلِكَ وَتِلْكَ بِحَسَبِ الْمُخَاطَبِ إِفْرَادًا وَتَثْنِيَةً وَجَمْعًا، وَتَذْكِيرًا وَتَأْنِيثًا.</span><p class="rule-study-text">Окончание كَافُ الْخِطَابِ в ذَلِكَ и تِلْكَ согласуется не с указываемым предметом, а с тем, к кому обращаются: по числу и роду.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Термины и русский смысл</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">كَافُ الْخِطَابِ</span><span class="rule-term-ru">каф обращения, указывающая на адресата</span></div><div class="rule-meaning-card rule-term-subject"><span class="rule-term-ar ar-tone-subject" dir="rtl" lang="ar">الْمُخَاطَبُ</span><span class="rule-term-ru">тот, к кому обращаются</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">مُفْرَدٌ، مُثَنًّى، جَمْعٌ؛ مُذَكَّرٌ، مُؤَنَّثٌ</span><span class="rule-term-ru">единственное, двойственное, множественное; мужской и женский род</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿أَلَمۡ أَنۡهَكُمَا عَن تِلۡكُمَا ٱلشَّجَرَةِ﴾</span><span class="rule-example-ru">Разве Я не запрещал вам обоим приближаться к тому дереву?</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿فَذَٰلِكُنَّ ٱلَّذِي لُمۡتُنَّنِي فِيهِ﴾</span><span class="rule-example-ru">Вот тот, из-за которого вы, женщины, порицали меня.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿كَذَٰلِكَ قَالَ رَبُّكَ﴾</span><span class="rule-example-ru">Так сказал твой Господь.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar ar-tone-structure" dir="rtl" lang="ar">أَذَلِكُمُ الْقَلَمُ لَكُمْ يَا إِخْوَانُ؟</span><span class="rule-example-ru">Та ручка принадлежит вам, братья?</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar ar-tone-structure" dir="rtl" lang="ar">أَتِلْكِ الْمَجَلَّةُ لَكِ يَا فَاطِمَةُ؟</span><span class="rule-example-ru">Тот журнал принадлежит тебе, Фатима?</span></div></div></div></div>', 'Окончание كَافُ الْخِطَابِ в ذَلِكَ и تِلْكَ согласуется не с указываемым предметом, а с тем, к кому обращаются: по числу и роду.', 'تَتَصَرَّفُ كَافُ الْخِطَابِ فِي اسْمَيِ الْإِشَارَةِ ذَلِكَ وَتِلْكَ بِحَسَبِ الْمُخَاطَبِ إِفْرَادًا وَتَثْنِيَةً وَجَمْعًا، وَتَذْكِيرًا وَتَأْنِيثًا.'),
    (6, 'اللَّامُ الْمُزَحْلَقَةُ (сдвинутая لَامُ الِابْتِدَاءِ)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-particle" dir="rtl" lang="ar">اللَّامُ الْمُزَحْلَقَةُ هِيَ لَامُ الِابْتِدَاءِ انْتَقَلَتْ إِلَى الْخَبَرِ بِسَبَبِ دُخُولِ إِنَّ، وَتُفِيدُ التَّوْكِيدَ. وَقَدْ تَدْخُلُ عَلَى اسْمِ إِنَّ إِذَا تَأَخَّرَ.</span><p class="rule-study-text">Начальная لَـ после появления إِنَّ переносится к сказуемому, чтобы два усилителя не стояли вместе в начале. Если имя إِنَّ отложено, لَـ может входить на него.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿وَإِنَّكَ لَعَلَىٰ خُلُقٍ عَظِيمٖ﴾</span><span class="rule-example-ru">Поистине, ты — великого нрава.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿قَدۡ نَعۡلَمُ إِنَّهُۥ لَيَحۡزُنُكَ ٱلَّذِي يَقُولُونَ﴾</span><span class="rule-example-ru">Мы, несомненно, знаем, что тебя печалит то, что они говорят.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">إِنَّ هَذَا لَطَالِبٌ. إِنَّ الدَّرْسَ لَمُفِيدٌ.</span><span class="rule-example-ru">Поистине, этот — студент. Поистине, урок полезен.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar ar-tone-default rule-quran-ar" dir="rtl" lang="ar">﴿إِنَّ فِي ذَٰلِكَ لَعِبۡرَةٗ﴾</span><span class="rule-example-ru">Поистине, в этом — назидание.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полный разбор إِنَّ الدَّرْسَ لَمُفِيدٌ</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">إِنَّ: حَرْفُ نَصْبٍ وَتَوْكِيدٍ مَبْنِيٌّ عَلَى الْفَتْحِ.</span><span class="rule-example-ru">إِنَّ — неизменяемая на фатхе частица винительного управления и усиления.</span></div><div class="rule-example-card rule-term-nasb"><span class="rule-example-ar ar-tone-nasb" dir="rtl" lang="ar">الدَّرْسَ: اسْمُ إِنَّ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ.</span><span class="rule-example-ru">الدَّرْسَ — имя إِنَّ в винительном статусе; признак — явная фатха.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">اللَّامُ الْمُزَحْلَقَةُ: حَرْفٌ مَبْنِيٌّ عَلَى الْفَتْحِ لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ.</span><span class="rule-example-ru">Сдвинутая لَـ — неизменяемая на фатхе частица без синтаксического места.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar ar-tone-predicate" dir="rtl" lang="ar">مُفِيدٌ: خَبَرُ إِنَّ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ.</span><span class="rule-example-ru">مُفِيدٌ — сказуемое إِنَّ в именительном статусе; признак — явная дамма.</span></div></div></div></div>', 'Начальная لَـ после появления إِنَّ переносится к сказуемому, чтобы два усилителя не стояли вместе в начале. Если имя إِنَّ отложено, لَـ может входить на него.', 'اللَّامُ الْمُزَحْلَقَةُ هِيَ لَامُ الِابْتِدَاءِ انْتَقَلَتْ إِلَى الْخَبَرِ بِسَبَبِ دُخُولِ إِنَّ، وَتُفِيدُ التَّوْكِيدَ. وَقَدْ تَدْخُلُ عَلَى اسْمِ إِنَّ إِذَا تَأَخَّرَ.'),
    (7, 'جَمْعُ بَرْنَامَجٍ عَلَى بَرَامِجَ (образование множественного بَرْنَامَجٌ → بَرَامِجُ)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-structure" dir="rtl" lang="ar">إِذَا جُمِعَ الِاسْمُ الَّذِي حُرُوفُهُ خَمْسَةٌ أَوْ أَكْثَرُ عَلَى صِيغَةِ مُنْتَهَى الْجُمُوعِ حُذِفَ مَا زَادَ عَلَى الْأَرْبَعَةِ، وَيُرْجَعُ فِي ذَلِكَ إِلَى الْمَعَاجِمِ.</span><p class="rule-study-text">При образовании крайней модели ломаного множественного у имени из пяти и более букв отбрасывается то, что превышает четыре буквы; конкретная форма проверяется по словарю.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْمُفْرَدُ</span><span class="rule-table-ru">единственное число</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْجَمْعُ</span><span class="rule-table-ru">множественное число</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-default" dir="rtl" lang="ar">بَرْنَامَجٌ</span><span class="rule-table-ru">программа</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">بَرَامِجُ</span><span class="rule-table-ru">программы</span></td></tr><tr><td><span class="rule-table-ar ar-tone-default" dir="rtl" lang="ar">سَفَرْجَلٌ</span><span class="rule-table-ru">айва</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">سَفَارِجُ</span><span class="rule-table-ru">плоды айвы</span></td></tr><tr><td><span class="rule-table-ar ar-tone-default" dir="rtl" lang="ar">عَنْدَلِيبٌ</span><span class="rule-table-ru">соловей</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">عَنَادِلُ</span><span class="rule-table-ru">соловьи</span></td></tr><tr><td><span class="rule-table-ar ar-tone-default" dir="rtl" lang="ar">عَنْكَبُوتٌ</span><span class="rule-table-ru">паук</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">عَنَاكِبُ</span><span class="rule-table-ru">пауки</span></td></tr><tr><td><span class="rule-table-ar ar-tone-default" dir="rtl" lang="ar">مُسْتَشْفًى</span><span class="rule-table-ru">больница</span></td><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مَشَافٍ</span><span class="rule-table-ru">больницы</span></td></tr></tbody></table></div></div></div>', 'При образовании крайней модели ломаного множественного у имени из пяти и более букв отбрасывается то, что превышает четыре буквы; конкретная форма проверяется по словарю.', 'إِذَا جُمِعَ الِاسْمُ الَّذِي حُرُوفُهُ خَمْسَةٌ أَوْ أَكْثَرُ عَلَى صِيغَةِ مُنْتَهَى الْجُمُوعِ حُذِفَ مَا زَادَ عَلَى الْأَرْبَعَةِ، وَيُرْجَعُ فِي ذَلِكَ إِلَى الْمَعَاجِمِ.')
)
update public.rules as r
set title = incoming.title,
    content = incoming.content,
    rule_kind = 'rule',
    summary = incoming.summary,
    rule_ar = incoming.rule_ar
from incoming
where r.course_name = 'Мединский курс (Том 4)'
  and r.lesson_number = '2'
  and r.sort_order = incoming.sort_order;

delete from public.rule_sources
where rule_id in (
  select id from public.rules
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '2'
);

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'الدَّرْسُ الثَّانِي
بَـابُ فَاعَلَ
من أمثلتِه : صَافَحَ , نَادَى , قَاتَلَ , سَافَرَ .
حرفُ الزِّيادةِ : الألف .
مَصدرُه : له وزنان , هما :
1- مُفَاعَلَةٌ , نحو : قَاتَلَ : مُقَاتَلَةٌ , شَارَكَ : مُشَارَكَةٌ .
2- فِعَالٌ , نحو : قَاتَلَ : قِتَالٌ , نَادَى : نِدَاءٌ .
من معانِيهِ :
1- الْمُشَارَكَةُ , نحو : صافحَ الرَّجلُ أخاه , قاتلَ المسلمون المشركين .
2- بمعنى فَعَلَ , نحو : سَافَرَ ,  هَاجَرَ ,  جَاوَزَ .
مُشْتَقَّاتُهُ :
اسم المفعول
| اسم الفاعل
| المصدر
| الأمر
| المضارع
| الماضي
|
| مُصَافَحٌ
| مُصَافِحٌ
| مُصَافَحَةٌ
| صَافِحْ
| يُصَافِحُ
| صَافَحَ
|
| ( لازم )
| مُسَافِرٌ
| سَفَرٌ ومُسَافَرَةٌ
| سَافِرْ
| يُسَافِرُ
| سَافَرَ
|
| مُنَادًى(الْمُنَادَى)
| مُنَادٍ (الْمُنَادِي)
| مُنَادَاةٌ ونِدَاءٌ
| نَادِ
| يُنَادِي
| نَادَى
|', 7, 7, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '2' and sort_order = 1;

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', '| معاني قَدْ
قَدْ : تأتي بمعنى التَّوكيدِ مع الفعل  الماضي ، وتأتي بمعنى الاحتمالِ والشَّكِّ ، والتَّقليلِ، والتَّحقيقِ مع المضارع ، وإليك البيان :
1- إذا دخلت قد على الفعل الماضي أفادت التَّوكيد ( التَّحقيق ) كما في قوله تعالى :
﴿قَدۡ أَفۡلَحَ ٱلۡمُؤۡمِنُونَ﴾  وكما في قولك : قد نجحت .
2- إذا دخلت على المضارع أفادت أحدَ أمورٍ ثلاثةٍ :
( أ ) الاحتمال والشَّك ، نحو : قد يأتي المديرُ .
(ب) التَّقليل ، نحو : قد يرسب المجتهدُ ، وقد يصدق الكَذُوبُ .
(ج) التَّحقيق ، نحو قوله تعالى : ﴿قَدۡ نَعۡلَمُ إِنَّهُۥ لَيَحۡزُنُكَ ٱلَّذِي يَقُولُونَ﴾ وقوله تعالى :
﴿قَدۡ يَعۡلَمُ ٱللَّهُ ٱلۡمُعَوِّقِينَ مِنكُمۡ﴾  .', 8, 8, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '2' and sort_order = 2;

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'تَخْفِيفُ لَكِنَّ  ( لَكِنْ )
إذا خُفَّفَتْ لكنَّ : بطل عملها ، ودخلت على الجملة الفعلية .
فمثال إبطال عملها ، قوله تعالى : ﴿لَٰكِنِ ٱلظَّٰلِمُونَ ٱلۡيَوۡمَ فِي ضَلَٰلٖ مُّبِينٖ﴾ .
وكقولك : جاء عليٌ لكنْ أخوه غائبٌ .
ومثال دخولها على الجملة الفعلية ، قوله تعالى : ﴿وَلَٰكِن لَّا تَشۡعُرُونَ﴾ .
وكقولك : جاء عليٌ لكنْ غابَ خالدٌ .
ويجوز أن تسبقها واو العطف ؛ فتقول : جاء عليٌّ ولكنْ غابَ خالدٌ .
فائدتها : الاسْتِدْرَاك .
الإعراب : جاء المدرسُ لكنِ الطُّلاَّبُ غابوا .
جاءَ : فعلٌ ماضٍ مبنيٌّ على الفتح .
المدرسُ : فاعل مرفوع وعلامة رفعه الضمة الظاهرة .
لكنْ : حرف ابتداء واستدراك مبني على السكون لا محل له من الإعراب.
الطُّلابُ : مبتدأ مرفوع وعلامة رفعه الضمة الظاهرة .
غابوا : فعل وفاعل، والجملة الفعلية في محل رفع خبر المبتدأ، وجملة ( الطلاب غابوا ) ابتدائية لا محل لها من الإعراب .', 8, 9, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '2' and sort_order = 3;

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'ذَوُو – أُوْلُو
مُلْحَقَتَانِ  بجمعِ المذكَّرِ السَّالمِ ، وتعربان إعرابه , رفعاً بالواو , ونصباً وجَرًّا بالياء .
وهما بمعنى ( أصحاب ) .
مثالُ الرَّفْعِ: نحن ذَوُو عِلْمٍ، وأُوْلُو فَضْلٍ . مثالُ النَّصْبِ : رأيت ذَوِي علمٍ، وأُولِي فضلٍ.
مثالُ الْجَرِّ : ذهبت إلى ذَوِي علمٍ ، وَأُولِي فضلٍ .', 9, 9, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '2' and sort_order = 4;

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'تَصَرُّفُ كَافِ الْخِطَابِ في اسمي الإشارة ( ذَلِكَ ، وتِلْكَ )
معنى تَصَرُّفِ كافِ الخطابِ : مُرَاعَاةُ الْمُخَاطَبِ ، فالكاف يُرَاعَى في لفظها المخاطَب مُفرداً ، أو مُثنىًّ ، أو جَمعاً ؛ مُذكَّراً ، أو مُؤنَّثاً .
الأمثلة :
قال تعالى: ﴿أَلَمۡ أَنۡهَكُمَا عَن تِلۡكُمَا ٱلشَّجَرَةِ﴾ وقال تعالى: ﴿فَذَٰلِكُنَّ ٱلَّذِي لُمۡتُنَّنِي فِيهِ﴾
وقال تعالى : ﴿كَذَٰلِكَ قَالَ رَبُّكَ﴾ .
وكقولك : أذلكمُ القلمُ لكم يا إخوانُ ؟   أتلكِ المجلةُ لكِ يا فاطمةُ ؟', 9, 9, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '2' and sort_order = 5;

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'اللاَّمُ الْمُزَحْلَقَةُ
هي لام الابتداء انتقلت إلى الخبر بسبب دخول إنَّ ( مكسورة الهمزة ) عليها .
فائدتها : التوكيد ؛ ولذلك انتقلت إلى الخبر بعد دخول إنّ عليها ؛ كراهة اجتماع مُؤَكِّدَيْنِ في أوَّل الكلام .
الأمثلة :
قال تعالى : ﴿وَإِنَّكَ لَعَلَىٰ خُلُقٍ عَظِيمٖ﴾ وقال تعالى : ﴿قَدۡ نَعۡلَمُ إِنَّهُۥ لَيَحۡزُنُكَ ٱلَّذِي يَقُولُونَ﴾
وكقولك : إنّ هذا لَطَالِبٌ . إنّ الدرسَ لَمُفيدٌ .
قد تدخل على اسم إنّ ، وذلك إذا تأخر الاسم ،كما في قوله تعالى :
﴿إِنَّ فِي ذَٰلِكَ لَعِبۡرَةٗ﴾ .
الإعراب : إنّ الدرسَ لمفيدٌ .
إنَّ : حرف نصب وتوكيد مبني على الفتح .
الدرسَ : اسم إن منصوب وعلامة نصبه الفتحة الظاهرة .
لمفيدٌ : اللام المزحلقة : حرف مبني على الفتح لا محل له من الإعراب .
مفيد : خبر إن مرفوع وعلامة رفعه الضمة الظاهرة .', 9, 10, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '2' and sort_order = 6;

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'جَمْعُ بَرْنَامَجٍ على بَرَامِجَ
إذا جُمِعَ الاسم الذي حروفه خمسة، أو أكثر على صيغة منتهى الجموع حُذِفَ ما زاد
على الأربعة ( وذلك بالرجوع إلى أصول الكلمات في المعاجم ) نحو :
سَفَرْجَل : سَفَارِج . عَنْدَلِيب : عَنَادِل . عَنْكَبُوت : عَنَاكِب . مُسْتَشْفَى : مَشَافٍ .', 10, 10, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '2' and sort_order = 7;

do $migration$
declare
  updated_count integer;
  source_count integer;
begin
  select count(*) into updated_count
  from public.rules
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '2' and rule_ar is not null and btrim(rule_ar) <> '';
  select count(*) into source_count
  from public.rule_sources rs
  join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 4)' and r.lesson_number = '2';
  if updated_count <> 7 or source_count <> 7 then
    raise exception 'Book 4 lesson 2 QA failed: rules %, sources %', updated_count, source_count;
  end if;
end $migration$;

commit;
