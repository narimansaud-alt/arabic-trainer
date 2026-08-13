-- Complete Medina Book 2 lesson 7 from the manually checked second Arabic
-- sharh, PDF pages 18-19. Distinct rules are added without replacing the
-- six detailed-sharh cards.

begin;

do $migration$
declare
  kana_rule_id bigint;
  kana_forms_rule_id bigint;
  complete_rule_id bigint;
  predicate_rule_id bigint;
  fronting_rule_id bigint;
  motion_rule_id bigint;
  gender_rule_id bigint;
  dhu_rule_id bigint;
  hamza_rule_id bigint;
  lesson_rule_count integer;
  updated_content text;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '7';

  if lesson_rule_count <> 6 then
    raise exception 'Expected 6 Book 2 lesson 7 rules before supplement, found %', lesson_rule_count;
  end if;

  select id into strict kana_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 1;
  select id into strict kana_forms_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 2;
  select id into strict complete_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 3;
  select id into strict predicate_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 4;
  select id into strict fronting_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 5;
  select id into strict motion_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7' and sort_order = 6;

  -- Shift the six existing cards by one position for the opening source rule.
  update public.rules set sort_order = sort_order + 1
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '7';

  -- 1. Masculine/feminine subject markers at the start of the lesson.
  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values
    ('Мединский курс (Том 2)', '7',
     'تَأْنِيثُ الْفَاعِلِ الْمُفْرَدِ وَالْجَمْعِ (формы исполнителя мужского и женского рода)',
     $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Показатели рода</span><span class="rule-main-ar" dir="rtl" lang="ar">تُفْتَحُ <span class="ar-tone-subject">تَاءُ الْفَاعِلِ</span> لِلْمُخَاطَبِ الْمُذَكَّرِ، وَتُكْسَرُ لِلْمُخَاطَبَةِ الْمُؤَنَّثَةِ. وَفِي الْجَمْعِ يَدُلُّ <span class="ar-tone-subject">الْمِيمُ</span> عَلَى الْمُذَكَّرِ، وَتَدُلُّ <span class="ar-tone-subject">نُونُ النِّسْوَةِ</span> عَلَى الْمُؤَنَّثِ.</span></div><div class="rule-study-card"><span class="rule-card-kicker">Все пары второго шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">мужской род</span></th><th><span class="rule-table-ru">женский род</span></th><th><span class="rule-table-ru">перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">أَشَرِبْتَ الْمَاءَ؟</span></td><td><span class="rule-table-ar">أَشَرِبْتِ الْمَاءَ؟</span></td><td><span class="rule-table-ru">Ты пил / пила воду?</span></td></tr><tr><td><span class="rule-table-ar">مَتَى خَرَجْتُمْ؟</span></td><td><span class="rule-table-ar">مَتَى خَرَجْتُنَّ؟</span></td><td><span class="rule-table-ru">Когда вы вышли? — обращение к мужчинам / женщинам.</span></td></tr><tr><td><span class="rule-table-ar">أَيْنَ ذَهَبْتُمْ؟</span></td><td><span class="rule-table-ar">أَيْنَ ذَهَبْتُنَّ؟</span></td><td><span class="rule-table-ru">Куда вы пошли? — обращение к мужчинам / женщинам.</span></td></tr><tr><td><span class="rule-table-ar">أَشَرِبْتُمُ الْمَاءَ؟</span></td><td><span class="rule-table-ar">أَشَرِبْتُنَّ الْمَاءَ؟</span></td><td><span class="rule-table-ru">Вы пили воду? — мужская / женская группа.</span></td></tr><tr><td><span class="rule-table-ar">أَقَرَأْتُمُ الدَّرْسَ؟</span></td><td><span class="rule-table-ar">أَقَرَأْتُنَّ الدَّرْسَ؟</span></td><td><span class="rule-table-ru">Вы прочитали урок? — мужская / женская группа.</span></td></tr></tbody></table></div></div></div>$html$,
     1, 'rule',
     'Фатха на تَاءِ الْفَاعِلِ указывает на одного собеседника-мужчину, касра — на одну собеседницу. В формах множественного مِيمٌ указывает на мужчин, а نُونُ النِّسْوَةِ — на женщин.',
     'تُفْتَحُ تَاءُ الْفَاعِلِ لِلْمُخَاطَبِ الْمُذَكَّرِ، وَتُكْسَرُ لِلْمُخَاطَبَةِ الْمُؤَنَّثَةِ. وَفِي الْجَمْعِ يَدُلُّ الْمِيمُ عَلَى الْمُذَكَّرِ، وَتَدُلُّ نُونُ النِّسْوَةِ عَلَى الْمُؤَنَّثِ.')
  returning id into gender_rule_id;

  -- 2. Add every distinct basic كان example on page 18.
  select content into strict updated_content from public.rules where id = kana_rule_id;
  if position('book2-second-sharh-l7-kana-examples' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 7 kana rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l7-kana-examples"><span class="rule-card-kicker">Преобразование именного предложения</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">до كَانَ</span></th><th><span class="rule-table-ru">после كَانَ</span></th><th><span class="rule-table-ru">перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">الطَّالِبُ مُجْتَهِدٌ.</span></td><td><span class="rule-table-ar">كَانَ الطَّالِبُ مُجْتَهِدًا.</span></td><td><span class="rule-table-ru">Студент был усердным.</span></td></tr><tr><td><span class="rule-table-ar">الطِّفْلُ مَرِيضٌ.</span></td><td><span class="rule-table-ar">كَانَ الطِّفْلُ مَرِيضًا.</span></td><td><span class="rule-table-ru">Ребёнок был болен.</span></td></tr></tbody></table></div></div>
</div>$html$;
  end if;
  update public.rules set content = updated_content where id = kana_rule_id;

  -- 5 after the shift. Add the complete شبه جملة examples of the second sharh.
  select content into strict updated_content from public.rules where id = predicate_rule_id;
  if position('book2-second-sharh-l7-kana-shibh' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 7 predicate rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l7-kana-shibh"><span class="rule-card-kicker">Дополнительные شِبْهُ جُمْلَةٍ</span><div class="rule-example-list"><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">كَانَ الْوَزِيرُ فِي الْمَدِينَةِ.</span><span class="rule-example-ru">Министр был в городе.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">كَانَ الْمُدَرِّسُ فِي الْفَصْلِ قَبْلَ قَلِيلٍ.</span><span class="rule-example-ru">Преподаватель недавно был в классе.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">كَانَتِ الْمُدِيرَةُ فِي مَكْتَبِهَا قَبْلَ نِصْفِ سَاعَةٍ.</span><span class="rule-example-ru">Директор-женщина была в своём кабинете полчаса назад.</span></div><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">كَانَ الطَّبِيبُ فِي الْمُسْتَشْفَى.</span><span class="rule-example-ru">Врач был в больнице.</span></div></div></div>
</div>$html$;
  end if;
  update public.rules set content = updated_content where id = predicate_rule_id;

  -- 7 after the shift. Extend the existing mīm/wāw card with tā/nūn and all decompositions.
  select content into strict updated_content from public.rules where id = motion_rule_id;
  if position('book2-second-sharh-l7-sukun-series' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 7 motion rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l7-sukun-series"><span class="rule-card-kicker">Три неподвижные согласные перед «الْـ»</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْحَرْفُ السَّاكِنُ</span><span class="rule-table-ru">неподвижная буква</span></th><th><span class="rule-table-ar">حَرَكَتُهُ</span><span class="rule-table-ru">огласовка перед артиклем</span></th><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример и перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">مْ</span><span class="rule-table-ru">мим группы</span></td><td><span class="rule-table-ar ar-tone-raf">مُ</span><span class="rule-table-ru">дамма</span></td><td><span class="rule-table-ar">أَقَرَأْتُمُ الْقُرْآنَ؟</span><span class="rule-table-ru">Вы прочитали Коран?</span></td></tr><tr><td><span class="rule-table-ar">تْ</span><span class="rule-table-ru">та женского рода</span></td><td><span class="rule-table-ar ar-tone-jarr">تِ</span><span class="rule-table-ru">касра</span></td><td><span class="rule-table-ar">خَرَجَتِ الْبِنْتُ.</span><span class="rule-table-ru">Девочка вышла.</span></td></tr><tr><td><span class="rule-table-ar">نْ</span><span class="rule-table-ru">неподвижная нун</span></td><td><span class="rule-table-ar ar-tone-jarr">نِ</span><span class="rule-table-ru">касра</span></td><td><span class="rule-table-ar">مَنِ الْوَلَدُ؟</span><span class="rule-table-ru">Кто этот мальчик?</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Формы с объектным местоимением</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الصِّيغَةُ</span><span class="rule-table-ru">форма</span></th><th><span class="rule-table-ar">تَرْكِيبُهَا</span><span class="rule-table-ru">состав</span></th><th><span class="rule-table-ru">перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">ضَرَبْتُمُوهُ</span></td><td><span class="rule-table-ar">ضَرَبْتُمْ + و + هُ</span><span class="rule-table-ru">глагол с исполнителем + вау удлинения + «его»</span></td><td><span class="rule-table-ru">Вы ударили его.</span></td></tr><tr><td><span class="rule-table-ar">فَهِمْتُمُوهُ</span></td><td><span class="rule-table-ar">فَهِمْتُمْ + و + هُ</span><span class="rule-table-ru">глагол с исполнителем + вау удлинения + «его»</span></td><td><span class="rule-table-ru">Вы поняли его.</span></td></tr><tr><td><span class="rule-table-ar">ضَرَبُوهُ</span></td><td><span class="rule-table-ar">ضَرَبَ + و + هُ</span><span class="rule-table-ru">основа + вау группы + «его»</span></td><td><span class="rule-table-ru">Они ударили его.</span></td></tr><tr><td><span class="rule-table-ar">فَهِمُوهُ</span></td><td><span class="rule-table-ar">فَهِمَ + و + هُ</span><span class="rule-table-ru">основа + вау группы + «его»</span></td><td><span class="rule-table-ru">Они поняли его.</span></td></tr></tbody></table></div><div class="rule-example-list"><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ الْحَيَّةُ؟ أَقَتَلْتُمُوهَا؟</span><span class="rule-example-ru">Где змея? Вы убили её?</span></div><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا دَرْسٌ سَهْلٌ. أَفَهِمْتُمُوهُ؟</span><span class="rule-example-ru">Это лёгкий урок. Вы поняли его?</span></div></div><p class="rule-study-text">Во всех этих примерах конечное слитное местоимение является <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">ضَمِيرُ نَصْبٍ مَفْعُولٌ بِهِ</span>.</p></div>
</div>$html$;
  end if;
  update public.rules
  set
    title = 'حَرَكَةُ السَّاكِنِ قَبْلَ «الْـ» وَوَاوُ الْإِشْبَاعِ (огласовка сукуна перед артиклем и вау удлинения)',
    rule_ar = 'تُضَمُّ مِيمُ الْجَمْعِ السَّاكِنَةُ قَبْلَ لَامِ التَّعْرِيفِ، وَتُكْسَرُ التَّاءُ السَّاكِنَةُ وَالنُّونُ السَّاكِنَةُ قَبْلَهَا؛ تَخَلُّصًا مِنَ الْتِقَاءِ السَّاكِنَيْنِ. وَإِذَا اتَّصَلَ ضَمِيرُ النَّصْبِ بِمِيمِ الْجَمْعِ، زِيدَتْ وَاوٌ لِلْإِشْبَاعِ، نَحْوُ: «أَرَأَيْتُمُوهُ؟».',
    summary = 'تُضَمُّ مِيمُ الْجَمْعِ السَّاكِنَةُ قَبْلَ لَامِ التَّعْرِيفِ، وَتُكْسَرُ التَّاءُ السَّاكِنَةُ وَالنُّونُ السَّاكِنَةُ قَبْلَهَا؛ تَخَلُّصًا مِنَ الْتِقَاءِ السَّاكِنَيْنِ. وَإِذَا اتَّصَلَ ضَمِيرُ النَّصْبِ بِمِيمِ الْجَمْعِ، زِيدَتْ وَاوٌ لِلْإِشْبَاعِ، نَحْوُ: «أَرَأَيْتُمُوهُ؟».',
    content = updated_content
  where id = motion_rule_id;

  -- 8. ذو / ذات, agreement, and the diptote note.
  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values
    ('Мединский курс (Том 2)', '7',
     'ذُو مِنَ الْأَسْمَاءِ الْخَمْسَةِ وَمُؤَنَّثُهَا ذَاتُ (ذُو — одно из пяти имён; женская форма ذَاتُ)',
     $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Значение и построение</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">ذُو</span> مِنَ الْأَسْمَاءِ الْخَمْسَةِ، وَمَعْنَاهَا <span class="ar-tone-structure">صَاحِبٌ</span>، وَمُؤَنَّثُهَا <span class="ar-tone-structure">ذَاتُ</span>. وَهُمَا مُضَافَانِ دَائِمًا، وَمَا بَعْدَهُمَا مُضَافٌ إِلَيْهِ مَجْرُورٌ.</span><p class="rule-study-text">Когда <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">ذُو / ذَاتُ</span> являются определением, вся конструкция согласуется с определяемым словом в определённости или неопределённости.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Неопределённая и определённая конструкция</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">неопределённость</span></th><th><span class="rule-table-ru">определённость</span></th><th><span class="rule-table-ru">перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">عِنْدِي كِتَابٌ ذُو غِلَافٍ أَحْمَرَ.</span></td><td><span class="rule-table-ar">أَيْنَ الْكِتَابُ ذُو الْغِلَافِ الْأَحْمَرِ؟</span></td><td><span class="rule-table-ru">У меня книга с красной обложкой. Где книга с красной обложкой?</span></td></tr><tr><td><span class="rule-table-ar">هَذَا رَجُلٌ ذُو مَالٍ كَثِيرٍ.</span></td><td><span class="rule-table-ar">هَذَا الرَّجُلُ ذُو الْمَالِ الْكَثِيرِ مِنَ السُّودَانِ.</span></td><td><span class="rule-table-ru">Это богатый мужчина. Этот богатый мужчина из Судана.</span></td></tr><tr><td><span class="rule-table-ar">جَاءَ طَالِبٌ ذُو شَعْرٍ طَوِيلٍ.</span></td><td><span class="rule-table-ar">جَاءَ الطَّالِبُ ذُو الشَّعْرِ الطَّوِيلِ.</span></td><td><span class="rule-table-ru">Пришёл длинноволосый студент. Пришёл тот длинноволосый студент.</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Женская форма ذَاتُ</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ امْرَأَةٌ ذَاتُ مَالٍ كَثِيرٍ.</span><span class="rule-example-ru">Это богатая женщина.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هَذِهِ مَجَلَّةٌ ذَاتُ صُوَرٍ مُلَوَّنَةٍ.</span><span class="rule-example-ru">Это журнал с цветными фотографиями.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">الْمَجَلَّةُ ذَاتُ الصُّوَرِ الْمُلَوَّنَةِ.</span><span class="rule-example-ru">Журнал с цветными фотографиями.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ السَّيَّارَةُ ذَاتُ اللَّوْنِ الْأَبْيَضِ؟</span><span class="rule-example-ru">Где автомобиль белого цвета?</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">عِنْدِي سَيَّارَةٌ ذَاتُ لَوْنٍ أَبْيَضَ.</span><span class="rule-example-ru">У меня автомобиль белого цвета.</span></div></div></div><div class="rule-check-card"><b>Окончание أَحْمَرَ.</b> В <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">ذُو غِلَافٍ أَحْمَرَ</span> слово <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">أَحْمَرُ</span> запрещено от полного склонения и в джарре получает фатху вместо касры. С артиклем оно получает касру: <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">الْغِلَافِ الْأَحْمَرِ</span>.</div></div>$html$,
     8, 'rule',
     'ذُو — одно из пяти имён со значением «обладатель»; женская форма — ذَاتُ. Они всегда являются первым членом идафы, а последующее имя стоит в джарре. Как определение конструкция согласуется с определяемым словом в определённости.',
     '«ذُو» مِنَ الْأَسْمَاءِ الْخَمْسَةِ، وَمَعْنَاهَا «صَاحِبٌ»، وَمُؤَنَّثُهَا «ذَاتُ». وَهُمَا مُضَافَانِ دَائِمًا، وَمَا بَعْدَهُمَا مُضَافٌ إِلَيْهِ مَجْرُورٌ. وَإِذَا وَقَعَتْ إِحْدَاهُمَا نَعْتًا وَافَقَتِ الْمَنْعُوتَ فِي التَّعْرِيفِ وَالتَّنْكِيرِ.')
  returning id into dhu_rule_id;

  -- 9. Interrogative hamza with أم between two alternatives.
  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values
    ('Мединский курс (Том 2)', '7',
     'الِاسْتِفْهَامُ بِالْهَمْزَةِ وَ«أَمْ» (вопрос с хамзой и выбором «или»)',
     $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило выбора</span><span class="rule-main-ar" dir="rtl" lang="ar">تَدْخُلُ <span class="ar-tone-particle">هَمْزَةُ الِاسْتِفْهَامِ</span> عَلَى الْمَسْؤُولِ عَنْهُ، وَيُذْكَرُ الْبَدِيلُ بَعْدَ <span class="ar-tone-particle">«أَمْ»</span>.</span></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры второго шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَمُحَمَّدًا رَأَيْتَ أَمْ حَامِدًا؟</span><span class="rule-example-ru">Ты видел Мухаммада или Хамида?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَكِتَابَ الْفِقْهِ قَرَأْتَ أَمْ كِتَابَ التَّوْحِيدِ؟</span><span class="rule-example-ru">Ты читал книгу по фикху или книгу по единобожию?</span></div></div></div></div>$html$,
     9, 'rule',
     'В вопросе с выбором вопросительная хамза ставится перед первым вариантом, а второй вариант вводится частицей أَمْ — «или».',
     'تَدْخُلُ هَمْزَةُ الِاسْتِفْهَامِ عَلَى الْمَسْؤُولِ عَنْهُ، وَيُذْكَرُ الْبَدِيلُ بَعْدَ «أَمْ».')
  returning id into hamza_rule_id;

  delete from public.rule_sources
  where rule_id in (kana_rule_id, predicate_rule_id, motion_rule_id)
    and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf';

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (gender_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الدَّرْسُ السَّابِعُ
تَأْنِيثُ الْفَاعِلِ
المذكّرُ | المؤنثُ
تأنيثُ الفاعلِ المفردِ: أشربتَ الماءَ؟ | أشربتِ الماءَ؟
تأنيثُ الفاعلِ الجمعِ: متى خرجتم؟ | متى خرجتنَّ؟
أين ذهبتم؟ | أين ذهبتنَّ؟
أشربتمُ الماءَ؟ | أشربتنَّ الماءَ؟
أقرأتمُ الدرسَ؟ | أقرأتنَّ الدرسَ؟$source$, 18, 18, 1),
    (kana_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$كَانَ
كَانَ: فعلٌ ماضٍ يرفعُ المبتدأَ وينصبُ الخبرَ.
الطالبُ مجتهدٌ ← كانَ الطالبُ مجتهداً. الطفلُ مريضٌ ← كانَ الطفلُ مريضاً.$source$, 18, 18, 2),
    (predicate_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$وقد يكونُ الخبرُ شبهَ جملةٍ (جارٌّ ومجرورٌ)، نحوُ: كانَ الوزيرُ في المدينةِ.
المدرسُ في الفصلِ ← كانَ المدرسُ في الفصلِ قبلَ قليلٍ.
المديرةُ في مكتبِها ← كانتِ المديرةُ في مكتبِها قبلَ نصفِ ساعةٍ.
كانَ الطبيبُ في المستشفى.$source$, 18, 18, 2),
    (motion_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الميمُ الساكنةُ إذا جاءَ بعدها حرفُ التعريفِ (ال) فإنها تكونُ مضمومةً، نحوُ: أقرأتمُ القرآنَ؟ وأصلُها هكذا: أقرأتمْ القرآنَ؟
أمّا التاءُ الساكنةُ، والنونُ الساكنةُ إذا جاءَ بعدهما حرفُ التعريفِ (ال) فإنهما تكونانِ مكسورتينِ، نحوُ: خرجتِ البنتُ. مَنِ الولدُ؟ وأصلُها هكذا: خرجتْ البنتُ.$source$, 18, 18, 2),
    (motion_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الْفَاعِلُ الْمُفْرَدُ، وَالْجَمْعُ
ضربتموهُ: الفاعلُ التاءُ. فهمتموهُ: الفاعلُ التاءُ.
ضربتموهُ: أصلُهُ ضربتمْ + و + ه. فهمتموهُ: أصلُهُ فهمتمْ + و + ه.
ضربوهُ: أصلُهُ ضربَ + و + ه. فهموهُ: أصلُهُ فهمَ + و + ه.
أينَ الحيةُ؟ أقتلتموها؟ هذا درسٌ سهلٌ. أفهمتموهُ؟
الضميرُ المتصلُ (الهاءُ) في كلِّ الأمثلةِ السابقةِ ضميرُ نصبٍ مفعولٌ به.
رأيتموهُ: حرفُ (الواو) زائدٌ، فائدتُهُ الإشباعُ، أي: يعطي الحرفَ الذي قبلَهُ المدَّ المناسبَ لهُ.$source$, 19, 19, 3),
    (dhu_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$ال، وَذُو
ال: حرفُ تعريفٍ.
ذُو: اسمٌ من الأسماءِ الخمسةِ، وما بعدهُ مضافٌ إليهِ مجرورٌ دائماً.
إذا وقعتْ (ذو) نعتاً فإنَّ ما بعدها يوافقُ ما قبلها في التعريفِ، والتنكيرِ.
مثالٌ: عندي كتابٌ ذو غلافٍ أحمرَ. أينَ الكتابُ ذو الغلافِ الأحمرِ؟
هذا رجلٌ ذو مالٍ كثيرٍ. هذا الرجلُ ذو المالِ الكثيرِ من السودانِ.
جاءَ طالبٌ ذو شعرٍ طويلٍ. جاءَ الطالبُ ذو الشعرِ الطويلِ.
ذاتُ: مؤنثُ ذو. هذه امرأةٌ ذاتُ مالٍ كثيرٍ. هذه مجلةٌ ذاتُ صورٍ ملونةٍ.
المجلةُ ذاتُ الصورِ الملونةِ. أينَ السيارةُ ذاتُ اللونِ الأبيضِ؟ عندي سيارةٌ ذاتُ لونٍ أبيضَ.
ذو غلافٍ أحمرَ: أحمرُ ممنوعٌ من الصرفِ يُجرُّ بالفتحةِ نيابةً عن الكسرةِ، وإذا قلتَ (الأحمرِ) جُرَّ بالكسرةِ؛ وذلك بسببِ دخولِ (ال).$source$, 19, 19, 1),
    (hamza_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الاستفهامُ بالهمزةِ
سبقَ أن درسناهُ في الدرسِ الأولِ ص٥، فارجعْ إليهِ رعاكَ اللهُ.
مثالٌ: أمحمداً رأيتَ أم حامداً؟ أكتابَ الفقهِ قرأتَ أم كتابَ التوحيدِ؟$source$, 19, 19, 1);

  if (select count(*) from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '7') <> 9 then
    raise exception 'Expected 9 Book 2 lesson 7 rules after supplement';
  end if;

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '7'
      and coalesce(rule_ar, '') = ''
  ) then
    raise exception 'Book 2 lesson 7 contains an empty rule_ar';
  end if;

  if exists (
    select 1 from public.rules r
    where r.course_name = 'Мединский курс (Том 2)'
      and r.lesson_number = '7'
      and not exists (select 1 from public.rule_sources s where s.rule_id = r.id)
  ) then
    raise exception 'Book 2 lesson 7 contains a rule without provenance';
  end if;
end;
$migration$;

commit;
