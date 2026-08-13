-- Complete Medina Book 2 lesson 9 from the manually checked second Arabic
-- sharh, PDF pages 21-22. Shared material is merged into the seven existing
-- detailed-sharh cards; one distinct attached-object-pronoun card is added.

begin;

do $migration$
declare
  sound_feminine_rule_id bigint;
  exclamation_rule_id bigint;
  vocative_rule_id bigint;
  interrogative_rule_id bigint;
  object_pronoun_rule_id bigint;
  deletion_rule_id bigint;
  relative_rule_id bigint;
  protection_rule_id bigint;
  updated_content text;
  lesson_rule_count integer;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '9';

  if lesson_rule_count <> 7 then
    raise exception 'Expected 7 Book 2 lesson 9 rules before supplement, found %', lesson_rule_count;
  end if;

  select id into strict sound_feminine_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 1;
  select id into strict exclamation_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 2;
  select id into strict vocative_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 3;
  select id into strict interrogative_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 4;
  select id into strict deletion_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 5;
  select id into strict relative_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 6;
  select id into strict protection_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9' and sort_order = 7;

  -- 1. The second sharh gives the complete nominative/accusative/genitive rule.
  select content into strict updated_content from public.rules where id = sound_feminine_rule_id;
  if position('book2-second-sharh-l9-sound-feminine' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 9 sound feminine plural rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l9-sound-feminine"><span class="rule-card-kicker">Полное склонение из второго шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">حَالَةُ الْإِعْرَابِ</span><span class="rule-table-ru">состояние</span></th><th><span class="rule-table-ar">الْعَلَامَةُ</span><span class="rule-table-ru">показатель</span></th><th><span class="rule-table-ar">الْأَمْثِلَةُ</span><span class="rule-table-ru">примеры</span></th><th><span class="rule-table-ru">русский перевод</span></th></tr></thead><tbody>
<tr><td><span class="rule-table-ar ar-tone-raf">الرَّفْعُ</span><span class="rule-table-ru">именительное состояние</span></td><td><span class="rule-table-ar ar-tone-raf">الضَّمَّةُ</span><span class="rule-table-ru">дамма</span></td><td><span class="rule-table-ar">جَاءَتِ الطَّالِبَاتُ.<br>ذَهَبَتِ الطَّبِيبَاتُ.<br>هَذِهِ مَجَلَّاتٌ.<br>تِلْكَ صَفَحَاتٌ.</span></td><td><span class="rule-table-ru">Пришли студентки.<br>Ушли женщины-врачи.<br>Это журналы.<br>То — страницы.</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-nasb">النَّصْبُ</span><span class="rule-table-ru">винительное состояние</span></td><td><span class="rule-table-ar ar-tone-nasb">الْكَسْرَةُ</span><span class="rule-table-ru">касра</span></td><td><span class="rule-table-ar">رَأَيْتُ الطَّالِبَاتِ.<br>سَأَلْتُ الطَّبِيبَاتِ.<br>قَرَأْتُ الْمَجَلَّاتِ.<br>قَطَعْتُ صَفَحَاتٍ مِنَ الْكِتَابِ.</span></td><td><span class="rule-table-ru">Я увидел студенток.<br>Я спросил женщин-врачей.<br>Я прочитал журналы.<br>Я вырвал страницы из книги.</span></td></tr>
<tr><td><span class="rule-table-ar ar-tone-jarr">الْجَرُّ</span><span class="rule-table-ru">родительное состояние</span></td><td><span class="rule-table-ar ar-tone-jarr">الْكَسْرَةُ</span><span class="rule-table-ru">касра</span></td><td><span class="rule-table-ar">مَرَرْتُ بِالطَّالِبَاتِ.<br>سَأَلْتُ عَنِ الطَّبِيبَاتِ.<br>بَحَثْتُ فِي الْمَجَلَّاتِ وَالصَّفَحَاتِ.</span></td><td><span class="rule-table-ru">Я прошёл мимо студенток.<br>Я спросил о женщинах-врачах.<br>Я искал в журналах и на страницах.</span></td></tr>
</tbody></table></div></div>
<div class="rule-study-card"><span class="rule-card-kicker">Разбор схемы второго шарха</span><div class="rule-example-card rule-term-role"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">رَأَيْتُ</span> <span class="ar-tone-nasb">الطَّالِبَاتِ</span>.</span><span class="rule-example-ru">Я увидел студенток.</span></div><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْجُزْءُ</span><span class="rule-table-ru">часть</span></th><th><span class="rule-table-ar">إِعْرَابُهُ</span><span class="rule-table-ru">разбор</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-verb">رَأَى</span></td><td><span class="rule-table-ar ar-tone-verb">فِعْلٌ مَاضٍ</span><span class="rule-table-ru">глагол прошедшего времени</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">تَاءُ الْفَاعِلِ «تُ»</span></td><td><span class="rule-table-ar ar-tone-subject">فَاعِلٌ</span><span class="rule-table-ru">исполнитель действия</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">الطَّالِبَاتِ</span></td><td><span class="rule-table-ar ar-tone-nasb">مَفْعُولٌ بِهِ مَنْصُوبٌ بِالْكَسْرَةِ</span><span class="rule-table-ru">прямое дополнение в винительном состоянии с касрой</span></td></tr></tbody></table></div></div>
</div>$html$;
  end if;
  update public.rules
  set
    title = 'إِعْرَابُ جَمْعِ الْمُؤَنَّثِ السَّالِمِ (склонение правильного женского множественного)',
    rule_ar = 'يُرْفَعُ جَمْعُ الْمُؤَنَّثِ السَّالِمِ بِالضَّمَّةِ، وَيُنْصَبُ بِالْكَسْرَةِ نِيَابَةً عَنِ الْفَتْحَةِ، وَيُجَرُّ بِالْكَسْرَةِ.',
    summary = 'يُرْفَعُ جَمْعُ الْمُؤَنَّثِ السَّالِمِ بِالضَّمَّةِ، وَيُنْصَبُ بِالْكَسْرَةِ نِيَابَةً عَنِ الْفَتْحَةِ، وَيُجَرُّ بِالْكَسْرَةِ.',
    content = updated_content
  where id = sound_feminine_rule_id;

  -- 2. Definition and all six distinct exclamation examples.
  select content into strict updated_content from public.rules where id = exclamation_rule_id;
  if position('book2-second-sharh-l9-exclamation' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 9 exclamation rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l9-exclamation"><span class="rule-card-kicker">Определение второго шарха</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">التَّعَجُّبُ</span> هُوَ الشُّعُورُ وَالْإِحْسَاسُ بِجَمَالِ الشَّيْءِ أَوْ قُبْحِهِ، وَيَأْتِي عَلَى وَزْنِ <span class="ar-tone-verb">«مَا أَفْعَلَهُ!»</span>.</span><p class="rule-study-text">Восклицание выражает ощущение красоты или безобразия предмета и строится здесь по модели «как…!».</p><div class="rule-example-list"><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">مَا أَجْمَلَ الْوَرْدَةَ!</span><span class="rule-example-ru">Как прекрасна роза!</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">مَا أَوْسَخَ الْغُرْفَةَ!</span><span class="rule-example-ru">Как грязна комната!</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">مَا أَحْسَنَ اللَّبَنَ!</span><span class="rule-example-ru">Как прекрасно молоко!</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">مَا أَقْبَحَ الْجَهْلَ!</span><span class="rule-example-ru">Как отвратительно невежество!</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">مَا أَسْهَلَ اللُّغَةَ الْعَرَبِيَّةَ!</span><span class="rule-example-ru">Как лёгок арабский язык!</span></div><div class="rule-example-card rule-term-verb"><span class="rule-example-ar" dir="rtl" lang="ar">مَا أَجْهَلَ هَذَا الرَّجُلَ!</span><span class="rule-example-ru">Как невежественен этот мужчина!</span></div></div></div>
</div>$html$;
  end if;
  update public.rules set content = updated_content where id = exclamation_rule_id;

  -- 3. All additional examples and the source parsing of يا سائق السيارة.
  select content into strict updated_content from public.rules where id = vocative_rule_id;
  if position('book2-second-sharh-l9-vocative' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 9 vocative rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l9-vocative"><span class="rule-card-kicker">Дополнительные обращения второго шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْمُنَادَى الْمُفْرَدُ</span><span class="rule-table-ru">одиночное обращение</span></th><th><span class="rule-table-ar">الْمُنَادَى الْمُضَافُ</span><span class="rule-table-ru">обращение в идафе</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">يَا حُسَيْنُ!</span><span class="rule-table-ru">О Хусейн!</span></td><td><span class="rule-table-ar">يَا عَبْدَ الرَّحْمَنِ!</span><span class="rule-table-ru">О Абдуррахман!</span></td></tr><tr><td><span class="rule-table-ar">يَا أُسْتَاذُ!</span><span class="rule-table-ru">О преподаватель!</span></td><td><span class="rule-table-ar">يَا أُخْتَ حَامِدٍ!</span><span class="rule-table-ru">О сестра Хамида!</span></td></tr><tr><td><span class="rule-table-ar">يَا رَجُلُ!</span><span class="rule-table-ru">О мужчина!</span></td><td><span class="rule-table-ar">يَا سَائِقَ السَّيَّارَةِ!</span><span class="rule-table-ru">О водитель автомобиля!</span></td></tr></tbody></table></div><div class="rule-check-card"><span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">سَائِقَ</span> — <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">مُنَادًى مَنْصُوبٌ</span>, обращение в винительном состоянии; <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">السَّيَّارَةِ</span> — <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">مُضَافٌ إِلَيْهِ مَجْرُورٌ</span>, второй член идафы в родительном состоянии.</div></div>
</div>$html$;
  end if;
  update public.rules set content = updated_content where id = vocative_rule_id;

  -- 4. Complete interrogative-hamza examples and the no-article contrast.
  select content into strict updated_content from public.rules where id = interrogative_rule_id;
  if position('book2-second-sharh-l9-interrogative' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 9 interrogative rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l9-interrogative"><span class="rule-card-kicker">Все дополнительные примеры</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">التَّرْكِيبُ</span><span class="rule-table-ru">исходное сложение</span></th><th><span class="rule-table-ar">بَعْدَ الْمَدِّ</span><span class="rule-table-ru">после слияния с маддом</span></th><th><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">أَ + ٱلْبِحَارُ</span></td><td><span class="rule-table-ar ar-tone-particle">آلْبِحَارُ؟</span></td><td><span class="rule-table-ru">Моря?</span></td></tr><tr><td><span class="rule-table-ar">أَ + ٱلْآنَ</span></td><td><span class="rule-table-ar ar-tone-particle">آلْآنَ؟</span></td><td><span class="rule-table-ru">Теперь?</span></td></tr><tr><td><span class="rule-table-ar">أَ + ٱلْيَوْمَ رَجَعْتَ</span></td><td><span class="rule-table-ar ar-tone-particle">آلْيَوْمَ رَجَعْتَ؟</span></td><td><span class="rule-table-ru">Ты сегодня вернулся?</span></td></tr><tr><td><span class="rule-table-ar">أَ + ٱلْمُدِيرُ قَالَ هَكَذَا</span></td><td><span class="rule-table-ar ar-tone-particle">آلْمُدِيرُ قَالَ هَكَذَا؟</span></td><td><span class="rule-table-ru">Это директор так сказал?</span></td></tr></tbody></table></div><div class="rule-check-card"><b>Без артикля мадда нет:</b> <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">آهَذَا صَحِيحٌ؟</span> — неверно; <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَهَذَا صَحِيحٌ؟</span> — верно, потому что после вопросительной хамзы стоит не <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">«الْـ»</span>.</div></div>
</div>$html$;
  end if;
  update public.rules set content = updated_content where id = interrogative_rule_id;

  -- Make room for the distinct attached-object-pronoun rule at source position 5.
  update public.rules
  set sort_order = sort_order + 100
  where id in (deletion_rule_id, relative_rule_id, protection_rule_id);

  -- 5. Attached accusative/object pronouns and every printed example.
  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values
    ('Мединский курс (Том 2)', '9',
     'ضَمَائِرُ النَّصْبِ الْمُتَّصِلَةُ (слитные объектные местоимения)',
     $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Три местоимения второго шарха</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-nasb">يَاءُ الْمُتَكَلِّمِ</span>، وَ<span class="ar-tone-nasb">كَافُ الْمُخَاطَبِ</span>، وَ<span class="ar-tone-nasb">هَاءُ الْغَائِبِ</span> ضَمَائِرُ نَصْبٍ مُتَّصِلَةٌ، وَقَعَتْ <span class="ar-tone-nasb">مَفْعُولًا بِهِ</span> فِي الْأَمْثِلَةِ.</span><p class="rule-study-text">Эти местоимения присоединяются к глаголу и во всех приведённых предложениях являются прямым дополнением.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все девять примеров</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الضَّمِيرُ</span><span class="rule-table-ru">местоимение и смысл</span></th><th><span class="rule-table-ar">الْأَمْثِلَةُ</span><span class="rule-table-ru">примеры</span></th><th><span class="rule-table-ru">русский перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-nasb">يَاءُ الْمُتَكَلِّمِ «ـنِي»</span><span class="rule-table-ru">«меня»</span></td><td><span class="rule-table-ar">خَلَقَنِي اللَّهُ.<br>ضَرَبَنِي أَبِي.<br>رَآنِي الْمُرَاقِبُ.</span></td><td><span class="rule-table-ru">Аллах создал меня.<br>Мой отец ударил меня.<br>Наблюдатель увидел меня.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">كَافُ الْمُخَاطَبِ «ـكَ»</span><span class="rule-table-ru">«тебя», обращение к мужчине</span></td><td><span class="rule-table-ar">خَلَقَكَ اللَّهُ.<br>ضَرَبَكَ أَبُوكَ.<br>رَآكَ الْمُرَاقِبُ.</span></td><td><span class="rule-table-ru">Аллах создал тебя.<br>Твой отец ударил тебя.<br>Наблюдатель увидел тебя.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">هَاءُ الْغَائِبِ «ـهُ»</span><span class="rule-table-ru">«его»</span></td><td><span class="rule-table-ar">خَلَقَهُ اللَّهُ.<br>ضَرَبَهُ أَبُوهُ.<br>رَآهُ الْمُرَاقِبُ.</span></td><td><span class="rule-table-ru">Аллах создал его.<br>Его отец ударил его.<br>Наблюдатель увидел его.</span></td></tr></tbody></table></div></div></div>$html$,
     5, 'rule',
     'يَاءُ الْمُتَكَلِّمِ، وَكَافُ الْمُخَاطَبِ، وَهَاءُ الْغَائِبِ ضَمَائِرُ نَصْبٍ مُتَّصِلَةٌ، وَقَعَتْ مَفْعُولًا بِهِ فِي جَمِيعِ الْأَمْثِلَةِ الْمَذْكُورَةِ.',
     'يَاءُ الْمُتَكَلِّمِ، وَكَافُ الْمُخَاطَبِ، وَهَاءُ الْغَائِبِ ضَمَائِرُ نَصْبٍ مُتَّصِلَةٌ، وَقَعَتْ مَفْعُولًا بِهِ فِي جَمِيعِ الْأَمْثِلَةِ الْمَذْكُورَةِ.')
  returning id into object_pronoun_rule_id;

  -- 6. Every question printed with the four interrogative contractions.
  select content into strict updated_content from public.rules where id = deletion_rule_id;
  if position('book2-second-sharh-l9-deletion' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 9 interrogative ma rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l9-deletion"><span class="rule-card-kicker">Вопросы второго шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">مِمَّ خُلِقَ الْإِنْسَانُ؟</span><span class="rule-example-ru">Из чего создан человек?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">عَمَّ يَتَسَاءَلُونَ؟</span><span class="rule-example-ru">О чём они спрашивают друг друга?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">بِمَ قَتَلْتَ الْحَيَّةَ؟</span><span class="rule-example-ru">Чем ты убил змею?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَ خَرَجْتَ؟</span><span class="rule-example-ru">Почему ты вышел?</span></div></div></div>
</div>$html$;
  end if;
  update public.rules set sort_order = 6, content = updated_content where id = deletion_rule_id;

  -- 7. The second sharh adds both dual forms and uses اللاتي for feminine plural.
  select content into strict updated_content from public.rules where id = relative_rule_id;
  if position('book2-second-sharh-l9-relative' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 9 relative pronoun rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l9-relative"><span class="rule-card-kicker">Дополнение второго шарха</span><p class="rule-study-text">Для женского множественного 80-страничный шарх приводит <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">اللَّائِي</span>, а второй шарх — <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">اللَّاتِي</span>. В карточке сохранены обе исходные формы.</p><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْعَدَدُ وَالْجِنْسُ</span><span class="rule-table-ru">число и род</span></th><th><span class="rule-table-ar">الِاسْمُ الْمَوْصُولُ</span><span class="rule-table-ru">относительное местоимение</span></th><th><span class="rule-table-ar">أَمْثِلَةُ الشَّرْحِ الثَّانِي</span><span class="rule-table-ru">примеры второго шарха</span></th><th><span class="rule-table-ru">русский перевод</span></th></tr></thead><tbody>
<tr><td><span class="rule-table-ar">مُفْرَدٌ مُذَكَّرٌ</span><span class="rule-table-ru">ед. ч., мужской род</span></td><td><span class="rule-table-ar ar-tone-structure">الَّذِي</span><span class="rule-table-ru">который</span></td><td><span class="rule-table-ar">مَنِ الْفَتَى الَّذِي دَخَلَ الْآنَ؟<br>الْفَتَى الَّذِي دَخَلَ الْآنَ مِنَ الْهِنْدِ.</span></td><td><span class="rule-table-ru">Кто юноша, который сейчас вошёл?<br>Юноша, который сейчас вошёл, из Индии.</span></td></tr>
<tr><td><span class="rule-table-ar">مُفْرَدَةٌ مُؤَنَّثَةٌ</span><span class="rule-table-ru">ед. ч., женский род</span></td><td><span class="rule-table-ar ar-tone-structure">الَّتِي</span><span class="rule-table-ru">которая</span></td><td><span class="rule-table-ar">مَنِ الْفَتَاةُ الَّتِي دَخَلَتِ الْآنَ؟<br>الْفَتَاةُ الَّتِي دَخَلَتِ الْآنَ أُخْتُ الْمُدِيرَةِ.</span></td><td><span class="rule-table-ru">Кто девушка, которая сейчас вошла?<br>Девушка, которая сейчас вошла, — сестра директрисы.</span></td></tr>
<tr><td><span class="rule-table-ar">جَمْعٌ مُذَكَّرٌ</span><span class="rule-table-ru">мн. ч., мужской род</span></td><td><span class="rule-table-ar ar-tone-structure">الَّذِينَ</span><span class="rule-table-ru">которые, мужчины</span></td><td><span class="rule-table-ar">مَنِ الْفِتْيَةُ الَّذِينَ دَخَلُوا الْآنَ؟<br>الْفِتْيَةُ الَّذِينَ دَخَلُوا الْآنَ طُلَّابٌ جُدُدٌ.</span></td><td><span class="rule-table-ru">Кто юноши, которые сейчас вошли?<br>Юноши, которые сейчас вошли, — новые студенты.</span></td></tr>
<tr><td><span class="rule-table-ar">جَمْعٌ مُؤَنَّثٌ</span><span class="rule-table-ru">мн. ч., женский род</span></td><td><span class="rule-table-ar ar-tone-structure">اللَّاتِي</span><span class="rule-table-ru">которые, женщины</span></td><td><span class="rule-table-ar">مَنِ الْفَتَيَاتُ اللَّاتِي دَخَلْنَ الْآنَ؟<br>الْفَتَيَاتُ اللَّاتِي دَخَلْنَ الْآنَ طَالِبَاتٌ جُدُدٌ.</span></td><td><span class="rule-table-ru">Кто девушки, которые сейчас вошли?<br>Девушки, которые сейчас вошли, — новые студентки.</span></td></tr>
<tr><td><span class="rule-table-ar">مُثَنًّى مُذَكَّرٌ</span><span class="rule-table-ru">двойственное, мужской род</span></td><td><span class="rule-table-ar ar-tone-structure">اللَّذَانِ</span><span class="rule-table-ru">которые двое</span></td><td><span class="rule-table-ar">هَذَانِ الطَّالِبَانِ اللَّذَانِ دَخَلَا الْفَصْلَ مِنَ الصِّينِ.</span></td><td><span class="rule-table-ru">Эти два студента, которые вошли в класс, — из Китая.</span></td></tr>
<tr><td><span class="rule-table-ar">مُثَنًّى مُؤَنَّثٌ</span><span class="rule-table-ru">двойственное, женский род</span></td><td><span class="rule-table-ar ar-tone-structure">اللَّتَانِ</span><span class="rule-table-ru">которые две</span></td><td><span class="rule-table-ar">هَاتَانِ الطَّالِبَتَانِ اللَّتَانِ دَخَلَتَا الْفَصْلَ مِنْ كُورِيَا.</span></td><td><span class="rule-table-ru">Эти две студентки, которые вошли в класс, — из Кореи.</span></td></tr>
</tbody></table></div></div>
</div>$html$;
  end if;
  update public.rules
  set
    sort_order = 7,
    title = 'صِيَغُ الِاسْمِ الْمَوْصُولِ الْمَذْكُورَةُ (приведённые формы относительного местоимения)',
    rule_ar = 'الِاسْمُ الْمَوْصُولُ لِلْمُفْرَدِ الْمُذَكَّرِ «الَّذِي»، وَلِلْمُفْرَدَةِ الْمُؤَنَّثَةِ «الَّتِي»، وَلِجَمْعِ الْمُذَكَّرِ «الَّذِينَ»، وَلِجَمْعِ الْمُؤَنَّثِ «اللَّائِي» أَوْ «اللَّاتِي»، وَلِلْمُثَنَّى الْمُذَكَّرِ «اللَّذَانِ»، وَلِلْمُثَنَّى الْمُؤَنَّثِ «اللَّتَانِ».',
    summary = 'الِاسْمُ الْمَوْصُولُ لِلْمُفْرَدِ الْمُذَكَّرِ «الَّذِي»، وَلِلْمُفْرَدَةِ الْمُؤَنَّثَةِ «الَّتِي»، وَلِجَمْعِ الْمُذَكَّرِ «الَّذِينَ»، وَلِجَمْعِ الْمُؤَنَّثِ «اللَّائِي» أَوْ «اللَّاتِي»، وَلِلْمُثَنَّى الْمُذَكَّرِ «اللَّذَانِ»، وَلِلْمُثَنَّى الْمُؤَنَّثِ «اللَّتَانِ».',
    content = updated_content
  where id = relative_rule_id;

  update public.rules set sort_order = 8 where id = protection_rule_id;

  delete from public.rule_sources
  where rule_id in (sound_feminine_rule_id, exclamation_rule_id, vocative_rule_id, interrogative_rule_id, deletion_rule_id, relative_rule_id, protection_rule_id)
    and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf';

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (exclamation_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الدَّرْسُ التَّاسِعُ
فِعْلُ التَّعَجُّبِ (مَا أَفْعَلَهُ!)
التَّعَجُّبُ: هو الشُّعورُ والإحساسُ بجَمَالِ الشَّيْءِ، أو قُبْحِهِ. ويأتي على وَزْنِ (مَا أَفْعَلَهُ).
تقول: مَا أَجْمَلَ الْوَرْدَةَ! مَا أَوْسَخَ الْغُرْفَةَ!
مَا أَحْسَنَ اللَّبَنَ! مَا أَقْبَحَ الْجَهْلَ!
مَا أَسْهَلَ اللُّغَةَ الْعَرَبِيَّةَ! مَا أَجْهَلَ هَذَا الرَّجُلَ!$source$, 21, 21, 2),
    (vocative_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الْمُنَادَى الْمُفْرَدُ، وَالْمُضَافُ
المنادى المفردُ: مَبْنِيٌّ على الضَّمَّةِ، نحو: يا محمدُ. يا حسينُ. يا أستاذُ. يا رجلُ.
المنادى المضافُ منصوبٌ بالفتحةِ، نحو: يا عبدَ اللهِ. يا عبدَ الرحمنِ. يا أختَ حامدٍ. يا سائقَ السيارةِ.
يا سائقَ السيارةِ
منادى منصوب | مضاف إليه مجرور$source$, 21, 21, 2),
    (sound_feminine_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$جَمْعُ الْمُؤَنَّثِ السَّالِمِ
جمعُ المؤنثِ السالمِ: يُرْفَعُ بالضَّمَّةِ، ويُنْصَبُ بالْكَسْرَةِ، ويُجَرُّ بالكسرةِ.
الرَّفْعُ: جاءتِ الطَّالباتُ. ذهبتِ الطَّبيباتُ. هذه مَجَلَّاتٌ. تلك صَفَحَاتٌ.
النَّصْبُ: رأيتُ الطَّالباتِ. سألتُ الطَّبيباتِ. قرأتُ المجلاتِ. قطعتُ صفحاتٍ من الكتابِ.
الْجَرُّ: مررتُ بالطَّالباتِ. سألتُ عن الطَّبيباتِ. بحثتُ في المجلاتِ والصَّفحاتِ.
رَأَيْتُ الطَّالِبَاتِ
فعل ماض | فاعل | مفعول به منصوب بالكسرة$source$, 21, 21, 2),
    (interrogative_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$دُخُولُ هَمْزَةِ الاستفهام عَلَى الْمُحَلَّى بِال
أالبحارُ؟ (أ + ال) تَتَحَوَّلُ إلى مَدٍّ (آ) آلبحارُ؟
أالآنَ؟ آلآنَ؟ اليومَ رجعتَ؟ آليومَ رجعتَ؟ المديرُ قال هكذا؟ آلمديرُ قال هكذا؟
آهذا صحيحٌ؟ ✕ أهذا صحيحٌ؟ ✓ لأنَّ ما بَعْدَ همزةِ الاستفهام ليسَ (ال).$source$, 21, 21, 2),
    (object_pronoun_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$ضَمَائِرُ النَّصْبِ الْمُتَّصِلَةُ
ضمائرُ النصبِ المتصلةُ، هي:
١- ياءُ المتكلمِ، نحو: خلقني اللهُ. ضربني أبي. رآني المراقبُ.
٢- كافُ المخاطبِ، نحو: خلقك اللهُ. ضربك أبوكَ. رآكَ المراقبُ.
٣- هاءُ الغائبِ، نحو: خلقه اللهُ. ضربه أبوهُ. رآهُ المراقبُ.
وهذه الضمائرُ وقعت مفعولاً به في جميعِ الأمثلةِ السابقةِ.$source$, 22, 22, 1),
    (deletion_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$حَذْفُ أَلِفِ مَا الاستفهامية
تُحْذَفُ ألفُ ما الاستفهامية إذا دَخَلَ عليها حرفُ جَرٍّ، نحو:
مِنْ + ما = مِمَّ؟ مِمَّ خُلِقَ الإنسانُ؟
عَنْ + ما = عَمَّ؟ عَمَّ يتساءلونَ؟
بِ + ما = بِمَ؟ بِمَ قتلتَ الحيَّةَ؟
لِ + ما = لِمَ؟ لِمَ خرجتَ؟$source$, 22, 22, 2),
    (relative_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الأَسْمَاءُ الْمَوْصُولَةُ
الاسمُ الموصولُ ينقسمُ إلى:
١- مفرد مذكر (الذي) مَنِ الفتى الذي دخلَ الآنَ؟ الفتى الذي دخل الآنَ من الهندِ.
٢- مفرد مؤنث (التي) مَنِ الفتاةُ التي دخلتِ الآنَ؟ الفتاةُ التي دخلت الآنَ أختُ المديرةِ.
٣- جمع مذكر (الذين) مَنِ الفتيةُ الذين دخلوا الآنَ؟ الفتيةُ الذين دخلوا الآنَ طلابٌ جددٌ.
٤- جمع مؤنث (اللاتي) مَنِ الفتياتُ اللاتي دخلنَ الآنَ؟ الفتياتُ اللاتي دخلنَ الآنَ طالباتٌ جددٌ.
وينقسمُ الاسمُ الموصولُ أيضاً إلى:
١- مثنى مذكر (اللذان) هذان الطالبانِ اللذانِ دخلا الفصلَ من الصينِ.
٢- مثنى مؤنث (اللتان) هاتان الطالبتانِ اللتانِ دخلتا الفصلَ من كوريا.$source$, 22, 22, 2);

  if (select count(*) from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '9') <> 8 then
    raise exception 'Expected 8 Book 2 lesson 9 rules after supplement';
  end if;

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '9'
      and coalesce(rule_ar, '') = ''
  ) then
    raise exception 'Book 2 lesson 9 contains an empty rule_ar';
  end if;

  if exists (
    select 1 from public.rules r
    where r.course_name = 'Мединский курс (Том 2)'
      and r.lesson_number = '9'
      and not exists (select 1 from public.rule_sources s where s.rule_id = r.id)
  ) then
    raise exception 'Book 2 lesson 9 contains a rule without provenance';
  end if;
end;
$migration$;

commit;
