-- Rebuild Medina Book 4 lesson 12 strictly from the supplied Arabic sharh.
-- Canonical PDF pages: 51-53. DOC text was used only for extraction and checked against the PDF.
begin;

do $migration$
declare
  existing_count integer;
begin
  select count(*) into existing_count
  from public.rules
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '12';
  if existing_count = 2 then
    insert into public.rules (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
    values ('Мединский курс (Том 4)', '12', '__book4_lesson12_tahdid__', '', 3, 'rule', '', null);
  elsif existing_count <> 3 then
    raise exception 'Expected 2 legacy or 3 rebuilt Book 4 lesson 12 rules, found %', existing_count;
  end if;
end $migration$;

with incoming(sort_order, title, content, summary, rule_ar) as (
  values
    (1, 'الْمَفْعُولُ لَهُ أَوْ لِأَجْلِهِ (дополнение причины или цели)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-object" dir="rtl" lang="ar">الْمَفْعُولُ لَهُ، أَوِ الْمَفْعُولُ لِأَجْلِهِ، مَصْدَرٌ يُذْكَرُ لِبَيَانِ سَبَبِ الْفِعْلِ. وَيَأْتِي مُجَرَّدًا مِنْ أَلْ وَالْإِضَافَةِ، أَوْ مُضَافًا، أَوْ مُحَلًّى بِأَلْ. وَالْمُحَلَّى بِأَلْ قَلِيلُ الِاسْتِعْمَالِ مَنْصُوبًا، وَجَرُّهُ بِاللَّامِ كَثِيرٌ.</span><p class="rule-study-text">Дополнение причины или цели — масдар, объясняющий, почему совершено действие. Оно бывает неопределённым без أَلْ и идафы, первым членом идафы либо определённым с أَلْ; последняя форма в винительном падеже редка, чаще употребляется с предлогом لِـ.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Три состояния</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْحَالُ</span><span class="rule-table-ru">форма</span></th><th><span class="rule-table-ar ar-tone-object" dir="rtl" lang="ar">الْمِثَالُ</span><span class="rule-table-ru">пример</span></th><th><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">الْمَعْنَى وَالْحُكْمُ</span><span class="rule-table-ru">перевод и правило</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُجَرَّدٌ مِنْ أَلْ وَالْإِضَافَةِ</span><span class="rule-table-ru">без أَلْ и без идафы</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">جِئْتُ رَغْبَةً فِي الْعِلْمِ.</span><span class="rule-table-ru">Я пришёл из стремления к знанию.</span></td><td><span class="rule-table-ar ar-tone-object" dir="rtl" lang="ar">رَغْبَةً</span><span class="rule-table-ru">масдар причины стоит в винительном падеже</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُضَافٌ</span><span class="rule-table-ru">первый член идафы</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَصَدَّقْتُ ابْتِغَاءَ مَرْضَاةِ اللَّهِ.</span><span class="rule-table-ru">Я дал милостыню, стремясь к довольству Аллаха.</span></td><td><span class="rule-table-ar ar-tone-object" dir="rtl" lang="ar">ابْتِغَاءَ</span><span class="rule-table-ru">дополнение цели одновременно является مُضَافٌ</span></td></tr><tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">مُحَلًّى بِأَلْ</span><span class="rule-table-ru">определённое с أَلْ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">ضَرَبْتُ ابْنِي التَّأْدِيبَ.</span><span class="rule-table-ru">Я наказал сына ради воспитания.</span></td><td><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">قَلِيلُ الِاسْتِعْمَالِ</span><span class="rule-table-ru">винительная форма употребляется редко</span></td></tr><tr><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">مَجْرُورٌ بِاللَّامِ</span><span class="rule-table-ru">с предлогом لِـ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">ضَرَبْتُ ابْنِي لِلتَّأْدِيبِ.</span><span class="rule-table-ru">Я наказал сына для воспитания.</span></td><td><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">جَرُّهُ كَثِيرٌ</span><span class="rule-table-ru">употребление в родительном падеже распространено</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полный إِعْرَاب из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-object"><span class="rule-example-ar ar-tone-object" dir="rtl" lang="ar">رَغْبَةً: مَفْعُولٌ لَهُ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ.</span><span class="rule-example-ru">رَغْبَةً — дополнение причины в винительном падеже; показатель — явно выраженная фатха.</span></div><div class="rule-example-card rule-term-object"><span class="rule-example-ar ar-tone-object" dir="rtl" lang="ar">ابْتِغَاءَ: مَفْعُولٌ لَهُ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ، وَهُوَ مُضَافٌ.</span><span class="rule-example-ru">ابْتِغَاءَ — дополнение цели в винительном падеже; показатель — фатха; слово является مُضَافٌ.</span></div><div class="rule-example-card rule-term-object"><span class="rule-example-ar ar-tone-object" dir="rtl" lang="ar">مَرْضَاةِ: مُضَافٌ إِلَيْهِ مَجْرُورٌ، وَعَلَامَةُ جَرِّهِ الْكَسْرَةُ.</span><span class="rule-example-ru">مَرْضَاةِ — مُضَافٌ إِلَيْهِ в родительном падеже; показатель — касра.</span></div><div class="rule-example-card rule-term-object"><span class="rule-example-ar ar-tone-object" dir="rtl" lang="ar">التَّأْدِيبَ: مَفْعُولٌ لَهُ مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ الظَّاهِرَةُ.</span><span class="rule-example-ru">التَّأْدِيبَ — дополнение цели в винительном падеже; показатель — явно выраженная фатха.</span></div></div></div></div>', 'Дополнение причины или цели — масдар, объясняющий, почему совершено действие. Оно бывает неопределённым без أَلْ и идафы, первым членом идафы либо определённым с أَلْ; последняя форма в винительном падеже редка, чаще употребляется с предлогом لِـ.', 'الْمَفْعُولُ لَهُ، أَوِ الْمَفْعُولُ لِأَجْلِهِ، مَصْدَرٌ يُذْكَرُ لِبَيَانِ سَبَبِ الْفِعْلِ. وَيَأْتِي مُجَرَّدًا مِنْ أَلْ وَالْإِضَافَةِ، أَوْ مُضَافًا، أَوْ مُحَلًّى بِأَلْ. وَالْمُحَلَّى بِأَلْ قَلِيلُ الِاسْتِعْمَالِ مَنْصُوبًا، وَجَرُّهُ بِاللَّامِ كَثِيرٌ.'),
    (2, 'لَا الْعَاطِفَةُ (لَا как союз противопоставления)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-particle" dir="rtl" lang="ar">لَا الْعَاطِفَةُ تُخْرِجُ مَا بَعْدَهَا مِنْ حُكْمِ مَا قَبْلَهَا. وَيُشْتَرَطُ أَنْ يَكُونَ الْمَعْطُوفُ مُفْرَدًا، أَيْ لَيْسَ جُمْلَةً، وَأَنْ تَقَعَ لَا بَعْدَ الْإِيجَابِ أَوِ الْأَمْرِ.</span><p class="rule-study-text">Союз لَا исключает следующий элемент из утверждения, относящегося к предыдущему. После него должно стоять не предложение, а отдельный член; сам союз употребляется после утвердительного высказывания или повеления.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Два условия</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar ar-tone-structure" dir="rtl" lang="ar">أَنْ يَكُونَ الْمَعْطُوفُ مُفْرَدًا</span><span class="rule-term-ru">присоединённый член должен быть отдельным словом или сочетанием, а не предложением</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar ar-tone-particle" dir="rtl" lang="ar">أَنْ تَقَعَ بَعْدَ الْإِيجَابِ أَوِ الْأَمْرِ</span><span class="rule-term-ru">لَا должна следовать после утверждения либо приказа</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">После утверждения</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar ar-tone-subject" dir="rtl" lang="ar">جَاءَ مُحَمَّدٌ لَا عَلِيٌّ.</span><span class="rule-example-ru">Пришёл Мухаммад, а не Али.</span></div><div class="rule-example-card rule-term-object"><span class="rule-example-ar ar-tone-object" dir="rtl" lang="ar">قَرَأْتُ الْكِتَابَ لَا الْقِصَّةَ.</span><span class="rule-example-ru">Я прочитал книгу, а не рассказ.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">После приказа</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">اِسْأَلِ الْمُدَرِّسَ لَا الطَّالِبَ.</span><span class="rule-example-ru">Спроси преподавателя, а не студента.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">كُلِ الْمَوْزَ لَا التُّفَّاحَ.</span><span class="rule-example-ru">Ешь бананы, а не яблоки.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">إِعْرَابُ جَاءَ مُحَمَّدٌ لَا عَلِيٌّ</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">جَاءَ: فِعْلٌ مَاضٍ مَبْنِيٌّ عَلَى الْفَتْحِ.</span><span class="rule-example-ru">جَاءَ — глагол прошедшего времени, неизменяемый с фатхой.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar ar-tone-subject" dir="rtl" lang="ar">مُحَمَّدٌ: فَاعِلٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ.</span><span class="rule-example-ru">مُحَمَّدٌ — субъект в именительном падеже; показатель — явно выраженная дамма.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">لَا: حَرْفُ عَطْفٍ مَبْنِيٌّ عَلَى السُّكُونِ، لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ.</span><span class="rule-example-ru">لَا — неизменяемый сочинительный союз с сукуном, не имеющий синтаксической позиции.</span></div><div class="rule-example-card rule-term-subject"><span class="rule-example-ar ar-tone-subject" dir="rtl" lang="ar">عَلِيٌّ: مَعْطُوفٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ.</span><span class="rule-example-ru">عَلِيٌّ — присоединённый союзом член в именительном падеже; показатель — явно выраженная дамма.</span></div></div></div></div>', 'Союз لَا исключает следующий элемент из утверждения, относящегося к предыдущему. После него должно стоять не предложение, а отдельный член; сам союз употребляется после утвердительного высказывания или повеления.', 'لَا الْعَاطِفَةُ تُخْرِجُ مَا بَعْدَهَا مِنْ حُكْمِ مَا قَبْلَهَا. وَيُشْتَرَطُ أَنْ يَكُونَ الْمَعْطُوفُ مُفْرَدًا، أَيْ لَيْسَ جُمْلَةً، وَأَنْ تَقَعَ لَا بَعْدَ الْإِيجَابِ أَوِ الْأَمْرِ.'),
    (3, 'أَحْرُفُ التَّحْضِيضِ وَالتَّنْدِيمِ (частицы побуждения и упрёка)', '<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar ar-tone-particle" dir="rtl" lang="ar">أَحْرُفُ التَّحْضِيضِ وَالتَّنْدِيمِ هِيَ: هَلَّا، وَأَلَّا، وَأَلَا، وَلَوْلَا، وَلَوْمَا. فَإِذَا وَقَعَ بَعْدَهَا فِعْلٌ مُضَارِعٌ دَلَّتْ عَلَى التَّحْضِيضِ، أَيْ عَلَى الْحَثِّ وَالتَّرْغِيبِ؛ وَإِذَا وَقَعَ بَعْدَهَا فِعْلٌ مَاضٍ دَلَّتْ عَلَى التَّنْدِيمِ، أَيْ جَعْلِ الْمُخَاطَبِ يَنْدَمُ عَلَى أَمْرٍ مَضَى.</span><p class="rule-study-text">Частицы هَلَّا, أَلَّا, أَلَا, لَوْلَا и لَوْمَا перед настоящим глаголом побуждают к действию, а перед прошедшим выражают упрёк и заставляют сожалеть о несовершённом или прошедшем.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Значение определяется временем глагола</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">مَا بَعْدَ الْحَرْفِ</span><span class="rule-table-ru">какой глагол следует</span></th><th><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">الدَّلَالَةُ</span><span class="rule-table-ru">значение</span></th><th><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">التَّفْسِيرُ</span><span class="rule-table-ru">пояснение</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلٌ مُضَارِعٌ</span><span class="rule-table-ru">глагол настоящего времени</span></td><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">التَّحْضِيضُ</span><span class="rule-table-ru">побуждение</span></td><td><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">الْحَثُّ وَالتَّرْغِيبُ</span><span class="rule-table-ru">призыв и поощрение к действию</span></td></tr><tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلٌ مَاضٍ</span><span class="rule-table-ru">глагол прошедшего времени</span></td><td><span class="rule-table-ar ar-tone-particle" dir="rtl" lang="ar">التَّنْدِيمُ</span><span class="rule-table-ru">упрёк с сожалением</span></td><td><span class="rule-table-ar ar-tone-predicate" dir="rtl" lang="ar">جَعْلُ الْمُخَاطَبِ يَنْدَمُ عَلَى أَمْرٍ مَضَى</span><span class="rule-table-ru">побуждение собеседника сожалеть о прошедшем</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры побуждения</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">هَلَّا تَجْتَهِدُونَ؟</span><span class="rule-example-ru">Почему бы вам не стараться?</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">لَوْمَا تَصُومُونَ؟</span><span class="rule-example-ru">Почему бы вам не поститься?</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">أَلَا تَتُوبُ مِنْ ذَنْبِكَ؟</span><span class="rule-example-ru">Не покаешься ли ты в своём грехе?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры упрёка</span><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">هَلَّا اجْتَهَدْتَ؟</span><span class="rule-example-ru">Почему же ты не постарался?</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">لَوْلَا صُمْتَ؟</span><span class="rule-example-ru">Почему же ты не постился?</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">أَلَا تُبْتَ؟</span><span class="rule-example-ru">Почему же ты не покаялся?</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полный إِعْرَاب из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">هَلَّا: حَرْفُ تَحْضِيضٍ مَبْنِيٌّ عَلَى السُّكُونِ، لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ.</span><span class="rule-example-ru">В هَلَّا تَجْتَهِدُ частица هَلَّا — неизменяемая частица побуждения с сукуном, без синтаксической позиции.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">تَجْتَهِدُ: فِعْلٌ مُضَارِعٌ مَرْفُوعٌ، وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ الظَّاهِرَةُ.</span><span class="rule-example-ru">تَجْتَهِدُ — глагол настоящего времени в именительном наклонении; показатель — явно выраженная дамма.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar ar-tone-particle" dir="rtl" lang="ar">هَلَّا: حَرْفُ تَنْدِيمٍ مَبْنِيٌّ عَلَى السُّكُونِ، لَا مَحَلَّ لَهُ مِنَ الْإِعْرَابِ.</span><span class="rule-example-ru">В هَلَّا اجْتَهَدْتَ частица هَلَّا — неизменяемая частица упрёка с сукуном, без синтаксической позиции.</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar ar-tone-verb" dir="rtl" lang="ar">اِجْتَهَدْتَ: فِعْلٌ مَاضٍ مَبْنِيٌّ عَلَى السُّكُونِ لِاتِّصَالِهِ بِالتَّاءِ، وَالتَّاءُ ضَمِيرُ رَفْعٍ مُتَّصِلٌ مَبْنِيٌّ عَلَى الْفَتْحِ فِي مَحَلِّ رَفْعٍ فَاعِلٌ.</span><span class="rule-example-ru">اِجْتَهَدْتَ — прошедший глагол, неизменяемый с сукуном из-за присоединения تَاءٌ; تَاءٌ — слитное местоимение именительного разряда, неизменяемое с фатхой, в позиции субъекта.</span></div></div></div></div>', 'Частицы هَلَّا, أَلَّا, أَلَا, لَوْلَا и لَوْمَا перед настоящим глаголом побуждают к действию, а перед прошедшим выражают упрёк и заставляют сожалеть о несовершённом или прошедшем.', 'أَحْرُفُ التَّحْضِيضِ وَالتَّنْدِيمِ هِيَ: هَلَّا، وَأَلَّا، وَأَلَا، وَلَوْلَا، وَلَوْمَا. فَإِذَا وَقَعَ بَعْدَهَا فِعْلٌ مُضَارِعٌ دَلَّتْ عَلَى التَّحْضِيضِ، أَيْ عَلَى الْحَثِّ وَالتَّرْغِيبِ؛ وَإِذَا وَقَعَ بَعْدَهَا فِعْلٌ مَاضٍ دَلَّتْ عَلَى التَّنْدِيمِ، أَيْ جَعْلِ الْمُخَاطَبِ يَنْدَمُ عَلَى أَمْرٍ مَضَى.')
)
update public.rules as r
set title = incoming.title,
    content = incoming.content,
    rule_kind = 'rule',
    summary = incoming.summary,
    rule_ar = incoming.rule_ar
from incoming
where r.course_name = 'Мединский курс (Том 4)'
  and r.lesson_number = '12'
  and r.sort_order = incoming.sort_order;

delete from public.rule_sources
where rule_id in (
  select id from public.rules
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '12'
);

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'الدَّرْسُ الثَّانِي عَشَرَ
الْمَفْعُولُ لَهُ ، أو لأَجْلِهِ
المفعول له : مصدرٌ يُذكرُ لبيانِ سببِ الفعلِ .
أحواله :
1- مُجَرَّدٌ من ( أل ) والإضافة ، نحو : جئت رغبةً في العلم .
2- مضاف , نحو : تصدقتُ ابتغاءَ مرضاةِ الله .
3- مُحَلًّى بـ ( أل ) نحو : ضربتُ ابني التأديبَ . وهذا النوع قليل الاستعمال ، وجرُّه كثير ؛ تقول : ضربت ابني للتَّأديبِ .
الإعراب :
رغبةً : مفعول له منصوب وعلامة نصبه الفتحة الظاهرة .
ابتغاءَ : مفعول له منصوب وعلامة نصبه الفتحة الظاهرة ، وهو مضاف ،
مرضاةِ : مضاف إليه مجرور وعلامة جره الكسرة .
التأديبَ : مفعول له منصوب وعلامة نصبه الفتحة الظاهرة .', 51, 51, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '12' and sort_order = 1;

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'لا الْعَاطِفَةُ
معناها : إخراج ما بعدها من حكم ما قبلها .
شروطها :
1- أن يكون المعطوف مفردا ، والمراد بالمفرد : ما ليس بجملة .
2- أن تقع بعد الإيجاب ، أو الأمر .
• مثال وقوعها بعد الإيجاب : جاء محمدٌ لا عليٌّ . قرأتُ الكتابَ لا القِصَّةَ .
• مثال وقوعها بعد الأمر : اسألِ المدرسَ لا الطَّالبَ . كُلِ الْمَوْزَ لا التُّفَّاحَ .
الإعراب : جاء محمدٌ لا عليٌّ .
جاءَ : فعل ماضٍ مبني على الفتح .
محمدٌ : فاعل مرفوع وعلامة رفعه الضمة الظاهرة .
لا : حرف عطف مبني على السكون لا محل له من الإعراب .
عليٌّ : معطوف مرفوع وعلامة رفعه الضمة الظاهرة .', 51, 52, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '12' and sort_order = 2;

insert into public.rule_sources (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
select id, 'Sharkh_Medinskiy_4.pdf', 'أحرفُ التَّحْضِيضِ ، والتَّنْدِيمِ
التَّحْضِيضُ ، هو : الحثُّ ، والتَّرْغِيبُ .
التَّنْدِيمُ ، هو : جَعْلُ الْمُخَاطَب يَنْدَمُ على أَمْرٍ قَدْ مَضَى .
وهذه الأحرف هي : هَلاَّ , أَلاَّ ، أَلاَ , لَوْلاَ , لَوْمَا .
• إذا وقع بعدها فعل مضارع فهي للتحضيض .
نحو : هلاَّ تجتهدون . لَوْمَا تصومون . أَلاَ تَتُوبُ من ذَنْبِكَ .
• إذا وقع بعدها فعل ماض فهي للتنديم .
نحو : هَلاَّ اجتهدْتَ .         لولا صُمْتَ .         أَلاَ تُبْتَ .
الإعراب :
هلاَّ تجتهدُ .
هلاَّ : حرف تحضيض مبني على السكون لا محل من الإعراب .
تجتهدُ : فعل مضارع مرفوع وعلامة رفعه الضمة الظاهرة .
هلاَّ اجتهدْتَ .
هلاَّ : حرف تنديم مبني على السكون لا محل له من الإعراب .
اجتهدْتَ : فعل ماضٍ مبني على السكون لاتصاله بالتاء ، والتاء : ضمير رفع متصل مبني على الفتح في محل رفع فاعل .', 52, 53, 1
from public.rules
where course_name = 'Мединский курс (Том 4)' and lesson_number = '12' and sort_order = 3;

do $migration$
declare
  updated_count integer;
  source_count integer;
begin
  select count(*) into updated_count
  from public.rules
  where course_name = 'Мединский курс (Том 4)' and lesson_number = '12' and rule_ar is not null and btrim(rule_ar) <> '';
  select count(*) into source_count
  from public.rule_sources rs
  join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 4)' and r.lesson_number = '12';
  if updated_count <> 3 or source_count <> 3 then
    raise exception 'Book 4 lesson 12 QA failed: rules %, sources %', updated_count, source_count;
  end if;
end $migration$;

commit;
