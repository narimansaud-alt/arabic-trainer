-- Complete Medina Book 2 lesson 6 with every distinct rule and example from
-- the manually checked second Arabic sharh, PDF pages 14-17.

begin;

do $migration$
declare
  pronouns_rule_id bigint;
  naa_rule_id bigint;
  azunnu_rule_id bigint;
  adjective_rule_id bigint;
  limah_rule_id bigint;
  hati_rule_id bigint;
  numerals_rule_id bigint;
  irab_rule_id bigint;
  lesson_rule_count integer;
  updated_content text;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '6';

  if lesson_rule_count <> 6 then
    raise exception 'Expected 6 Book 2 lesson 6 rules before supplement, found %', lesson_rule_count;
  end if;

  select id into strict pronouns_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 1;
  select id into strict naa_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 2;
  select id into strict azunnu_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 3;
  select id into strict adjective_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 4;
  select id into strict limah_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 5;
  select id into strict hati_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6' and sort_order = 6;

  -- 1. Add the second-sharh address-ta distinctions and full third-person object series.
  select content into strict updated_content from public.rules where id = pronouns_rule_id;
  if position('book2-second-sharh-l6-address-ta' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 6 pronoun rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l6-address-ta"><span class="rule-card-kicker">Огласовка تَاءِ الْفَاعِلِ</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الضَّمِيرُ</span><span class="rule-table-ru">кто совершил действие</span></th><th><span class="rule-table-ar">حَرَكَةُ التَّاءِ</span><span class="rule-table-ru">огласовка ت</span></th><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример и перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar ar-tone-subject">ـتَ</span><span class="rule-table-ru">фатха</span></td><td><span class="rule-table-ar ar-tone-verb">أَذَهَبْتَ يَا مُحَمَّدُ؟</span><span class="rule-table-ru">Ты ходил, Мухаммад?</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-subject">ـتِ</span><span class="rule-table-ru">касра</span></td><td><span class="rule-table-ar ar-tone-verb">أَذَهَبْتِ يَا فَاطِمَةُ؟</span><span class="rule-table-ru">Ты ходила, Фатима?</span></td></tr><tr><td><span class="rule-table-ar ar-tone-subject">أَنَا</span><span class="rule-table-ru">я, мужчина или женщина</span></td><td><span class="rule-table-ar ar-tone-subject">ـتُ</span><span class="rule-table-ru">дамма</span></td><td><span class="rule-table-ar ar-tone-verb">أَنَا ذَهَبْتُ.</span><span class="rule-table-ru">Я ходил / ходила.</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Утвердительные и отрицательные ответы</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">вопрос</span></th><th><span class="rule-table-ru">ответ</span></th><th><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">أَفَهِمْتَ الدَّرْسَ يَا عَلِيُّ؟</span></td><td><span class="rule-table-ar">نَعَمْ، فَهِمْتُهُ.</span></td><td><span class="rule-table-ru">Ты понял урок, Али? — Да, я понял его.</span></td></tr><tr><td><span class="rule-table-ar">أَفَهِمْتَ الدَّرْسَ يَا عَلِيُّ؟</span></td><td><span class="rule-table-ar">لَا، مَا فَهِمْتُهُ.</span></td><td><span class="rule-table-ru">Ты понял урок, Али? — Нет, я не понял его.</span></td></tr><tr><td><span class="rule-table-ar">أَفَهِمْتِ الدَّرْسَ يَا مَرْيَمُ؟</span></td><td><span class="rule-table-ar">نَعَمْ، فَهِمْتُهُ.</span></td><td><span class="rule-table-ru">Ты поняла урок, Марьям? — Да, я поняла его.</span></td></tr><tr><td><span class="rule-table-ar">أَفَهِمْتِ الدَّرْسَ يَا مَرْيَمُ؟</span></td><td><span class="rule-table-ar">لَا، مَا فَهِمْتُهُ.</span></td><td><span class="rule-table-ru">Ты поняла урок, Марьям? — Нет, я не поняла его.</span></td></tr><tr><td><span class="rule-table-ar">أَمَا فَهِمْتَ الدَّرْسَ يَا عَلِيُّ؟</span></td><td><span class="rule-table-ar">بَلَى، فَهِمْتُهُ.</span></td><td><span class="rule-table-ru">Разве ты не понял урок, Али? — Напротив, понял.</span></td></tr><tr><td><span class="rule-table-ar">أَمَا فَهِمْتَ الدَّرْسَ يَا عَلِيُّ؟</span></td><td><span class="rule-table-ar">نَعَمْ، مَا فَهِمْتُهُ.</span></td><td><span class="rule-table-ru">Разве ты не понял урок, Али? — Да, не понял.</span></td></tr><tr><td><span class="rule-table-ar">أَمَا فَهِمْتِ الدَّرْسَ يَا مَرْيَمُ؟</span></td><td><span class="rule-table-ar">بَلَى، فَهِمْتُهُ.</span></td><td><span class="rule-table-ru">Разве ты не поняла урок, Марьям? — Напротив, поняла.</span></td></tr><tr><td><span class="rule-table-ar">أَمَا فَهِمْتِ الدَّرْسَ يَا مَرْيَمُ؟</span></td><td><span class="rule-table-ar">نَعَمْ، مَا فَهِمْتُهُ.</span></td><td><span class="rule-table-ru">Разве ты не поняла урок, Марьям? — Да, не поняла.</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Полный ряд ضَمَائِرُ الْغَائِبِ в роли дополнения</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الضَّمِيرُ</span><span class="rule-table-ru">форма</span></th><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример</span></th><th><span class="rule-table-ru">русский смысл</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-nasb">ـهُ</span><span class="rule-table-ru">один мужчина</span></td><td><span class="rule-table-ar">رَأَيْتُهُ.</span></td><td><span class="rule-table-ru">Я увидел его.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">ـهَا</span><span class="rule-table-ru">одна женщина</span></td><td><span class="rule-table-ar">رَأَيْتُهَا.</span></td><td><span class="rule-table-ru">Я увидел её.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">ـهُمَا</span><span class="rule-table-ru">двое мужчин или две женщины</span></td><td><span class="rule-table-ar">رَأَيْتُهُمَا.</span></td><td><span class="rule-table-ru">Я увидел их двоих.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">ـهُمْ</span><span class="rule-table-ru">группа мужчин</span></td><td><span class="rule-table-ar">رَأَيْتُهُمْ.</span></td><td><span class="rule-table-ru">Я увидел их, мужчин.</span></td></tr><tr><td><span class="rule-table-ar ar-tone-nasb">ـهُنَّ</span><span class="rule-table-ru">группа женщин</span></td><td><span class="rule-table-ar">رَأَيْتُهُنَّ.</span></td><td><span class="rule-table-ru">Я увидел их, женщин.</span></td></tr></tbody></table></div><p class="rule-study-text">Когда глагол присоединён к одному из этих местоимений отсутствующего, местоимение является <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">مَفْعُولًا بِهِ</span> — прямым дополнением.</p></div>
</div>$html$;
  end if;
  update public.rules set content = updated_content where id = pronouns_rule_id;

  -- 3. Expand أظن with the complete second-sharh series and its placement note.
  select content into strict updated_content from public.rules where id = azunnu_rule_id;
  if position('book2-second-sharh-l6-anna-series' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 6 azunnu rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l6-anna-series"><span class="rule-card-kicker">Положение أَنَّ</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَنَّ</span> لَا تَقَعُ فِي أَوَّلِ الْكَلَامِ؛ وَتَأْتِي هُنَا بَعْدَ <span class="ar-tone-verb">أَظُنُّ</span>.</span><p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَنَّ</span> ставит своё имя в винительный падеж и поднимает сказуемое в именительный; в этих примерах она следует после «я думаю».</p></div><div class="rule-study-card"><span class="rule-card-kicker">Все дополнительные примеры</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْأَصْلُ</span><span class="rule-table-ru">исходное сообщение</span></th><th><span class="rule-table-ar">بَعْدَ أَظُنُّ</span><span class="rule-table-ru">после «я думаю»</span></th><th><span class="rule-table-ru">перевод</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">يَاسِرٌ مَرِيضٌ.</span></td><td><span class="rule-table-ar">أَظُنُّ أَنَّ يَاسِرًا مَرِيضٌ.</span></td><td><span class="rule-table-ru">Я думаю, что Ясир болен.</span></td></tr><tr><td><span class="rule-table-ar">الْمُدَرِّسُ مَا جَاءَ.</span></td><td><span class="rule-table-ar">أَظُنُّ أَنَّ الْمُدَرِّسَ مَا جَاءَ.</span></td><td><span class="rule-table-ru">Я думаю, что преподаватель не пришёл.</span></td></tr><tr><td><span class="rule-table-ar">هُوَ مَرِيضٌ.</span></td><td><span class="rule-table-ar">أَظُنُّ أَنَّهُ مَرِيضٌ.</span></td><td><span class="rule-table-ru">Я думаю, что он болен.</span></td></tr><tr><td><span class="rule-table-ar">هِيَ مُعَلِّمَةٌ.</span></td><td><span class="rule-table-ar">أَظُنُّ أَنَّهَا مُعَلِّمَةٌ.</span></td><td><span class="rule-table-ru">Я думаю, что она учительница.</span></td></tr><tr><td><span class="rule-table-ar">هُمْ طُلَّابٌ.</span></td><td><span class="rule-table-ar">أَظُنُّ أَنَّهُمْ طُلَّابٌ.</span></td><td><span class="rule-table-ru">Я думаю, что они студенты.</span></td></tr><tr><td><span class="rule-table-ar">هُنَّ مُعَلِّمَاتٌ.</span></td><td><span class="rule-table-ar">أَظُنُّ أَنَّهُنَّ مُعَلِّمَاتٌ.</span></td><td><span class="rule-table-ru">Я думаю, что они учительницы.</span></td></tr><tr><td><span class="rule-table-ar">أَنْتَ طَبِيبٌ.</span></td><td><span class="rule-table-ar">أَظُنُّ أَنَّكَ طَبِيبٌ.</span></td><td><span class="rule-table-ru">Я думаю, что ты врач.</span></td></tr><tr><td><span class="rule-table-ar">أَنْتِ طَبِيبَةٌ.</span></td><td><span class="rule-table-ar">أَظُنُّ أَنَّكِ طَبِيبَةٌ.</span></td><td><span class="rule-table-ru">Я думаю, что ты женщина-врач.</span></td></tr><tr><td><span class="rule-table-ar">أَنْتُمْ مُعَلِّمُونَ.</span></td><td><span class="rule-table-ar">أَظُنُّ أَنَّكُمْ مُعَلِّمُونَ.</span></td><td><span class="rule-table-ru">Я думаю, что вы учителя.</span></td></tr><tr><td><span class="rule-table-ar">الْمَكْتَبَةُ مَفْتُوحَةٌ.</span></td><td><span class="rule-table-ar">أَظُنُّ أَنَّ الْمَكْتَبَةَ مَفْتُوحَةٌ.</span></td><td><span class="rule-table-ru">Я думаю, что библиотека открыта.</span></td></tr></tbody></table></div></div>
</div>$html$;
  end if;
  update public.rules
  set
    rule_ar = '«أَظُنُّ» فِعْلٌ يَنْصِبُ مَفْعُولَيْنِ، نَحْوُ: أَظُنُّ الطَّالِبَ غَائِبًا. وَقَدْ يَدْخُلُ عَلَى «أَنَّ» وَاسْمِهَا وَخَبَرِهَا، نَحْوُ: أَظُنُّ أَنَّ الْمُدَرِّسَ جَدِيدٌ. وَلَا تَقَعُ «أَنَّ» فِي أَوَّلِ الْكَلَامِ.',
    summary = '«أَظُنُّ» فِعْلٌ يَنْصِبُ مَفْعُولَيْنِ، نَحْوُ: أَظُنُّ الطَّالِبَ غَائِبًا. وَقَدْ يَدْخُلُ عَلَى «أَنَّ» وَاسْمِهَا وَخَبَرِهَا، نَحْوُ: أَظُنُّ أَنَّ الْمُدَرِّسَ جَدِيدٌ. وَلَا تَقَعُ «أَنَّ» فِي أَوَّلِ الْكَلَامِ.',
    content = updated_content
  where id = azunnu_rule_id;

  -- Reorder the existing final rules to make room for the two missing topics.
  update public.rules set sort_order = 5 where id = adjective_rule_id;
  update public.rules set sort_order = 6 where id = limah_rule_id;
  update public.rules set sort_order = 8 where id = hati_rule_id;

  -- 4. The full review of 11-19 and the decade numerals.
  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values
    ('Мединский курс (Том 2)', '6',
     'الْأَعْدَادُ الْمُرَكَّبَةُ وَأَلْفَاظُ الْعُقُودِ (составные числительные и названия десятков)',
     $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Три части правила</span><span class="rule-main-ar" dir="rtl" lang="ar">الْعَدَدَانِ <span class="ar-tone-structure">أَحَدَ عَشَرَ وَاثْنَا عَشَرَ</span> يُوَافِقَانِ الْمَعْدُودَ فِي الْجُزْأَيْنِ. وَفِي الْأَعْدَادِ مِنْ <span class="ar-tone-structure">ثَلَاثَةَ عَشَرَ إِلَى تِسْعَةَ عَشَرَ</span> يُخَالِفُ الْجُزْءُ الْأَوَّلُ الْمَعْدُودَ وَيُوَافِقُهُ الْجُزْءُ الثَّانِي. وَ<span class="ar-tone-structure">أَلْفَاظُ الْعُقُودِ</span> لَا تَخْتَلِفُ مَعَ الْمَعْدُودِ.</span><p class="rule-study-text">После этих числительных исчисляемое слово стоит в единственном числе и в винительном падеже как <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">تَمْيِيزٌ</span> — поясняющее слово.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Числа 11 и 12</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">мужской род</span></th><th><span class="rule-table-ru">женский род</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">جَاءَ أَحَدَ عَشَرَ طَالِبًا.</span><span class="rule-table-ru">Пришли одиннадцать студентов.</span></td><td><span class="rule-table-ar">جَاءَتْ إِحْدَى عَشْرَةَ طَالِبَةً.</span><span class="rule-table-ru">Пришли одиннадцать студенток.</span></td></tr><tr><td><span class="rule-table-ar">عِنْدِي اثْنَا عَشَرَ كِتَابًا.</span><span class="rule-table-ru">У меня двенадцать книг.</span></td><td><span class="rule-table-ar">عِنْدِي اثْنَتَا عَشْرَةَ حَقِيبَةً.</span><span class="rule-table-ru">У меня двенадцать сумок.</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Числа 13–19</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْعَدَدُ</span><span class="rule-table-ru">число</span></th><th><span class="rule-table-ru">с существительным мужского рода</span></th><th><span class="rule-table-ru">с существительным женского рода</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">١٣</span></td><td><span class="rule-table-ar">فِي الْمَدِينَةِ ثَلَاثَةَ عَشَرَ فُنْدُقًا.</span><span class="rule-table-ru">В городе тринадцать гостиниц.</span></td><td><span class="rule-table-ar">فِي الْمَدِينَةِ ثَلَاثَ عَشْرَةَ حَدِيقَةً.</span><span class="rule-table-ru">В городе тринадцать садов.</span></td></tr><tr><td><span class="rule-table-ar">١٤</span></td><td><span class="rule-table-ar">خَرَجَ أَرْبَعَةَ عَشَرَ طَالِبًا.</span><span class="rule-table-ru">Вышли четырнадцать студентов.</span></td><td><span class="rule-table-ar">خَرَجَتْ أَرْبَعَ عَشْرَةَ طَالِبَةً.</span><span class="rule-table-ru">Вышли четырнадцать студенток.</span></td></tr><tr><td><span class="rule-table-ar">١٥</span></td><td><span class="rule-table-ar">فِي الْمَعْهَدِ خَمْسَةَ عَشَرَ فَصْلًا.</span><span class="rule-table-ru">В институте пятнадцать классов.</span></td><td><span class="rule-table-ar">فِي الْمَعْهَدِ خَمْسَ عَشْرَةَ سَيَّارَةً.</span><span class="rule-table-ru">В институте пятнадцать автомобилей.</span></td></tr><tr><td><span class="rule-table-ar">١٦</span></td><td><span class="rule-table-ar">ثَمَنُ الْقَلَمِ سِتَّةَ عَشَرَ رِيَالًا.</span><span class="rule-table-ru">Цена ручки — шестнадцать риалов.</span></td><td><span class="rule-table-ar">ثَمَنُ الْقَلَمِ سِتَّ عَشْرَةَ رُوبِيَّةً.</span><span class="rule-table-ru">Цена ручки — шестнадцать рупий.</span></td></tr><tr><td><span class="rule-table-ar">١٧</span></td><td><span class="rule-table-ar">سَافَرَ سَبْعَةَ عَشَرَ طَالِبًا.</span><span class="rule-table-ru">Уехали семнадцать студентов.</span></td><td><span class="rule-table-ar">سَافَرَتْ سَبْعَ عَشْرَةَ طَالِبَةً.</span><span class="rule-table-ru">Уехали семнадцать студенток.</span></td></tr><tr><td><span class="rule-table-ar">١٨</span></td><td><span class="rule-table-ar">جَاءَ ثَمَانِيَةَ عَشَرَ طَالِبًا.</span><span class="rule-table-ru">Пришли восемнадцать студентов.</span></td><td><span class="rule-table-ar">جَاءَتْ ثَمَانِيَ عَشْرَةَ طَالِبَةً.</span><span class="rule-table-ru">Пришли восемнадцать студенток.</span></td></tr><tr><td><span class="rule-table-ar">١٩</span></td><td><span class="rule-table-ar">جَاءَ تِسْعَةَ عَشَرَ طَالِبًا.</span><span class="rule-table-ru">Пришли девятнадцать студентов.</span></td><td><span class="rule-table-ar">جَاءَتْ تِسْعَ عَشْرَةَ طَالِبَةً.</span><span class="rule-table-ru">Пришли девятнадцать студенток.</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Названия десятков</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">с существительным мужского рода</span></th><th><span class="rule-table-ru">с существительным женского рода</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">جَاءَ عِشْرُونَ طَالِبًا.</span><span class="rule-table-ru">Пришли двадцать студентов.</span></td><td><span class="rule-table-ar">جَاءَتْ عِشْرُونَ طَالِبَةً.</span><span class="rule-table-ru">Пришли двадцать студенток.</span></td></tr><tr><td><span class="rule-table-ar">عِنْدِي ثَلَاثُونَ رِيَالًا.</span><span class="rule-table-ru">У меня тридцать риалов.</span></td><td><span class="rule-table-ar">عِنْدِي ثَلَاثُونَ رُوبِيَّةً.</span><span class="rule-table-ru">У меня тридцать рупий.</span></td></tr><tr><td><span class="rule-table-ar">فِي الْفَصْلِ أَرْبَعُونَ مَقْعَدًا.</span><span class="rule-table-ru">В классе сорок мест.</span></td><td><span class="rule-table-ar">فِي الْفَصْلِ أَرْبَعُونَ طَالِبَةً.</span><span class="rule-table-ru">В классе сорок студенток.</span></td></tr></tbody></table></div></div></div>$html$,
     4, 'rule',
     'Числа 11 и 12 согласуются с исчисляемым в обеих частях; в числах 13–19 первая часть противоположна роду исчисляемого, а вторая согласуется. Десятки не меняются по роду. Исчисляемое — تَمْيِيزٌ в единственном числе и винительном падеже.',
     'الْعَدَدَانِ «أَحَدَ عَشَرَ» وَ«اثْنَا عَشَرَ» يُوَافِقَانِ الْمَعْدُودَ فِي الْجُزْأَيْنِ. وَفِي الْأَعْدَادِ مِنْ «ثَلَاثَةَ عَشَرَ» إِلَى «تِسْعَةَ عَشَرَ» يُخَالِفُ الْجُزْءُ الْأَوَّلُ الْمَعْدُودَ وَيُوَافِقُهُ الْجُزْءُ الثَّانِي. وَأَلْفَاظُ الْعُقُودِ مِنْ «عِشْرِينَ» إِلَى «تِسْعِينَ» لَا تَخْتَلِفُ مَعَ الْمَعْدُودِ. وَالْمَعْدُودُ بَعْدَهَا تَمْيِيزٌ مُفْرَدٌ مَنْصُوبٌ.')
  returning id into numerals_rule_id;

  -- 5. Preserve the explicitly different plural descriptions of the two sharhs.
  select content into strict updated_content from public.rules where id = adjective_rule_id;
  if position('book2-second-sharh-l6-adjective-position' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 6 adjective rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l6-adjective-position"><span class="rule-card-kicker">Формулировки двух шархов</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">فِعَالٌ</span><span class="rule-term-ru">Подробный шарх даёт эту основную модель и отдельно называет <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">كُسَالَى</span> исключением.</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">فِعَالٌ وَفُعَالَى</span><span class="rule-term-ru">Второй шарх прямо называет обе модели множественного и приводит <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">سُكَارَى</span>.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Все предложения второго шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">мужской род</span></th><th><span class="rule-table-ru">женский род</span></th><th><span class="rule-table-ru">множественное обоих родов</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">حَامِدٌ غَضْبَانُ.</span><span class="rule-table-ru">Хамид сердит.</span></td><td><span class="rule-table-ar">فَاطِمَةُ غَضْبَى.</span><span class="rule-table-ru">Фатима сердита.</span></td><td><span class="rule-table-ar">الطُّلَّابُ غِضَابٌ، وَالطَّالِبَاتُ غِضَابٌ.</span><span class="rule-table-ru">Студенты и студентки сердиты.</span></td></tr><tr><td><span class="rule-table-ar">يُوسُفُ شَبْعَانُ.</span><span class="rule-table-ru">Юсуф сыт.</span></td><td><span class="rule-table-ar">مَرْيَمُ شَبْعَى.</span><span class="rule-table-ru">Марьям сыта.</span></td><td><span class="rule-table-ar">الرِّجَالُ شِبَاعٌ، وَالنِّسَاءُ شِبَاعٌ.</span><span class="rule-table-ru">Мужчины и женщины сыты.</span></td></tr><tr><td><span class="rule-table-ar">الطَّالِبُ كَسْلَانُ.</span><span class="rule-table-ru">Студент ленив.</span></td><td><span class="rule-table-ar">الطَّالِبَةُ كَسْلَى.</span><span class="rule-table-ru">Студентка ленива.</span></td><td><span class="rule-table-ar">الطُّلَّابُ كُسَالَى، وَالطَّالِبَاتُ كُسَالَى.</span><span class="rule-table-ru">Студенты и студентки ленивы.</span></td></tr><tr><td><span class="rule-table-ar">هُوَ سَكْرَانُ.</span><span class="rule-table-ru">Он пьян.</span></td><td><span class="rule-table-ar">هِيَ سَكْرَى.</span><span class="rule-table-ru">Она пьяна.</span></td><td><span class="rule-table-ar">هُمْ سُكَارَى، وَهُنَّ سُكَارَى.</span><span class="rule-table-ru">Они, мужчины и женщины, пьяны.</span></td></tr></tbody></table></div></div>
</div>$html$;
  end if;
  update public.rules
  set
    title = 'جَمْعُ فَعْلَانَ وَفَعْلَى (множественное прилагательных моделей «фа‘лян/фа‘ля»)',
    rule_ar = 'تَأْتِي صِفَةُ الْمُذَكَّرِ عَلَى «فَعْلَانَ» وَصِفَةُ الْمُؤَنَّثِ عَلَى «فَعْلَى». وَيَرِدُ جَمْعُهُمَا عَلَى «فِعَالٍ»، وَوَرَدَ فِي الشَّرْحِ الثَّانِي أَيْضًا جَمْعُ «فُعَالَى»، نَحْوُ: «كُسَالَى» وَ«سُكَارَى»؛ وَعَدَّ الشَّرْحُ الْمُفَصَّلُ «كُسَالَى» خِلَافَ الْقَاعِدَةِ.',
    summary = 'تَأْتِي صِفَةُ الْمُذَكَّرِ عَلَى «فَعْلَانَ» وَصِفَةُ الْمُؤَنَّثِ عَلَى «فَعْلَى». وَيَرِدُ جَمْعُهُمَا عَلَى «فِعَالٍ»، وَوَرَدَ فِي الشَّرْحِ الثَّانِي أَيْضًا جَمْعُ «فُعَالَى»، نَحْوُ: «كُسَالَى» وَ«سُكَارَى»؛ وَعَدَّ الشَّرْحُ الْمُفَصَّلُ «كُسَالَى» خِلَافَ الْقَاعِدَةِ.',
    content = updated_content
  where id = adjective_rule_id;

  -- 6. Add all remaining pause-hā examples.
  select content into strict updated_content from public.rules where id = limah_rule_id;
  if position('book2-second-sharh-l6-limah-dialogues' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 6 limah rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l6-limah-dialogues"><span class="rule-card-kicker">В вопросе и при остановке</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">لِمَ؟</span><span class="rule-term-ru">«почему?» — вопрос о причине.</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">لِمَهْ؟</span><span class="rule-term-ru">та же форма с неподвижной <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">هَاءُ السَّكْتِ</span> при остановке.</span></div></div><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَ خَرَجْتَ؟</span><span class="rule-example-ru">Почему ты вышел?</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَ ضَرَبْتَهُ؟</span><span class="rule-example-ru">Почему ты ударил его?</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">لِمَ ذَهَبْتَ إِلَى الْمُدِيرِ؟</span><span class="rule-example-ru">Почему ты пошёл к директору?</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَخَرَجْتَ؟ نَعَمْ. لِمَهْ؟</span><span class="rule-example-ru">Ты вышел? — Да. — Почему?</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَضَرَبْتَهُ؟ نَعَمْ. لِمَهْ؟</span><span class="rule-example-ru">Ты ударил его? — Да. — Почему?</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَكَتَبْتَ الْوَاجِبَ؟ لَا. لِمَهْ؟</span><span class="rule-example-ru">Ты написал домашнее задание? — Нет. — Почему?</span></div></div></div>
</div>$html$;
  end if;
  update public.rules set content = updated_content where id = limah_rule_id;

  -- 7. The missing three nominal i'rab types and their original signs.
  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values
    ('Мединский курс (Том 2)', '6',
     'أَنْوَاعُ الْإِعْرَابِ فِي الْأَسْمَاءِ (виды и‘раба имён)',
     $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">أَنْوَاعُ الْإِعْرَابِ فِي الْأَسْمَاءِ ثَلَاثَةٌ: <span class="ar-tone-raf">الرَّفْعُ</span>، وَ<span class="ar-tone-nasb">النَّصْبُ</span>، وَ<span class="ar-tone-jarr">الْجَرُّ</span>. وَعَلَامَاتُهَا الْأَصْلِيَّةُ: <span class="ar-tone-raf">الضَّمَّةُ</span> لِلرَّفْعِ، وَ<span class="ar-tone-nasb">الْفَتْحَةُ</span> لِلنَّصْبِ، وَ<span class="ar-tone-jarr">الْكَسْرَةُ</span> لِلْجَرِّ.</span></div><div class="rule-study-card"><span class="rule-card-kicker">Полная таблица второго шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar ar-tone-raf">الِاسْمُ الْمَرْفُوعُ</span><span class="rule-table-ru">имя в раф‘</span></th><th><span class="rule-table-ar ar-tone-nasb">الِاسْمُ الْمَنْصُوبُ</span><span class="rule-table-ru">имя в насбе</span></th><th><span class="rule-table-ar ar-tone-jarr">الِاسْمُ الْمَجْرُورُ</span><span class="rule-table-ru">имя в джарре</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">هَذَا كِتَابٌ.</span><span class="rule-table-ru">Это книга.</span></td><td><span class="rule-table-ar">قَرَأْتُ كِتَابًا.</span><span class="rule-table-ru">Я прочитал книгу.</span></td><td><span class="rule-table-ar">اِطَّلَعْتُ عَلَى كِتَابٍ.</span><span class="rule-table-ru">Я ознакомился с книгой.</span></td></tr><tr><td><span class="rule-table-ar">هَذَا حَامِدٌ.</span><span class="rule-table-ru">Это Хамид.</span></td><td><span class="rule-table-ar">رَأَيْتُ حَامِدًا.</span><span class="rule-table-ru">Я увидел Хамида.</span></td><td><span class="rule-table-ar">مَرَرْتُ بِحَامِدٍ.</span><span class="rule-table-ru">Я прошёл мимо Хамида.</span></td></tr><tr><td><span class="rule-table-ar">هَذَا بَيْتٌ.</span><span class="rule-table-ru">Это дом.</span></td><td><span class="rule-table-ar">اِشْتَرَيْتُ بَيْتًا.</span><span class="rule-table-ru">Я купил дом.</span></td><td><span class="rule-table-ar">سَكَنْتُ فِي بَيْتٍ.</span><span class="rule-table-ru">Я поселился в доме.</span></td></tr></tbody></table></div></div></div>$html$,
     7, 'rule',
     'У имён три вида и‘раба: رَفْعٌ, نَصْبٌ и جَرٌّ. Их исходные показатели — соответственно ضَمَّةٌ, فَتْحَةٌ и كَسْرَةٌ.',
     'أَنْوَاعُ الْإِعْرَابِ فِي الْأَسْمَاءِ ثَلَاثَةٌ: الرَّفْعُ، وَالنَّصْبُ، وَالْجَرُّ. وَعَلَامَاتُهَا الْأَصْلِيَّةُ: الضَّمَّةُ لِلرَّفْعِ، وَالْفَتْحَةُ لِلنَّصْبِ، وَالْكَسْرَةُ لِلْجَرِّ.')
  returning id into irab_rule_id;

  -- 8. Add every distinct هات example from page 17.
  select content into strict updated_content from public.rules where id = hati_rule_id;
  if position('book2-second-sharh-l6-hati-examples' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 6 hati rule';
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-l6-hati-examples"><span class="rule-card-kicker">Дополнительные обращения второго шарха</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الصِّيغَةُ</span><span class="rule-table-ru">форма</span></th><th><span class="rule-table-ru">с обращением</span></th><th><span class="rule-table-ru">с дополнением</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">هَاتِ</span><span class="rule-table-ru">одному мужчине</span></td><td><span class="rule-table-ar">هَاتِ يَا أَحْمَدُ.</span><span class="rule-table-ru">Дай, Ахмад.</span></td><td><span class="rule-table-ar">هَاتِ الْوَاجِبَ يَا صَالِحُ.</span><span class="rule-table-ru">Дай домашнее задание, Салих.</span></td></tr><tr><td><span class="rule-table-ar">هَاتِي</span><span class="rule-table-ru">одной женщине</span></td><td><span class="rule-table-ar">هَاتِي يَا مَرْيَمُ.</span><span class="rule-table-ru">Дай, Марьям.</span></td><td><span class="rule-table-ar">هَاتِي الدَّفَاتِرَ يَا سُعَادُ.</span><span class="rule-table-ru">Дай тетради, Суад.</span></td></tr><tr><td><span class="rule-table-ar">هَاتُوا</span><span class="rule-table-ru">группе мужчин</span></td><td><span class="rule-table-ar">هَاتُوا يَا إِخْوَانُ.</span><span class="rule-table-ru">Дайте, братья.</span></td><td><span class="rule-table-ar">هَاتُوا الْكُتُبَ يَا إِخْوَانُ.</span><span class="rule-table-ru">Дайте книги, братья.</span></td></tr><tr><td><span class="rule-table-ar">هَاتِينَ</span><span class="rule-table-ru">группе женщин</span></td><td><span class="rule-table-ar">هَاتِينَ يَا أَخَوَاتُ.</span><span class="rule-table-ru">Дайте, сёстры.</span></td><td><span class="rule-table-ar">هَاتِينَ الدَّفَاتِرَ يَا أَخَوَاتُ.</span><span class="rule-table-ru">Дайте тетради, сёстры.</span></td></tr></tbody></table></div></div>
</div>$html$;
  end if;
  update public.rules set content = updated_content where id = hati_rule_id;

  delete from public.rule_sources
  where rule_id in (pronouns_rule_id, azunnu_rule_id, adjective_rule_id, limah_rule_id, hati_rule_id)
    and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf';

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (pronouns_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الدَّرْسُ السَّادِسُ
تَأْنِيثُ الْفَاعِلِ
إذا كان الفاعلُ مؤنثاً فإنَّ الفعلَ الذي قبله يتصلُ به تاءُ التأنيثِ.
إذا كان الفاعلُ ضميرَ المخاطبِ (التاء) فإنَّ التاءَ تُفتحُ إذا كان الفاعلُ مذكراً، تقول: أذهبتَ يا محمدُ؟ وتُكسرُ التاءُ إذا كان الفاعلُ مؤنثاً، تقول: أذهبتِ يا فاطمةُ؟
وإذا كان الفاعلُ ضميرَ المتكلمِ (التاء) تُضمُّ التاءُ في الفاعلِ المذكّرِ والمؤنثِ، تقول: أنا ذهبتُ (للمذكّرِ، والمؤنثِ).
أفهمتَ الدرسَ يا عليٌّ؟ نعم، فهمتُهُ. أفهمتَ الدرسَ يا عليٌّ؟ لا، ما فهمتُهُ.
أفهمتِ الدرسَ يا مريمُ؟ نعم، فهمتُهُ. أفهمتِ الدرسَ يا مريمُ؟ لا، ما فهمتُهُ.
أما فهمتَ الدرسَ يا عليٌّ؟ بلى، فهمتُهُ. أما فهمتَ الدرسَ يا عليٌّ؟ نعم، ما فهمتُهُ.
أما فهمتِ الدرسَ يا مريمُ؟ بلى، فهمتُهُ. أما فهمتِ الدرسَ يا مريمُ؟ نعم، ما فهمتُهُ.$source$, 14, 14, 2),
    (pronouns_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$ضَمَائِرُ الْغَائِبِ
الضميرُ (ه) للمفردِ المذكّرِ: رأيتُهُ. الضميرُ (ها) للمفردِ المؤنثِ: رأيتُهَا.
الضميرُ (هما) للمثنّى المذكّرِ والمؤنثِ: رأيتُهُمَا.
الضميرُ (هُم) لجمعِ المذكّرِ: رأيتُهُمْ. الضميرُ (هُنَّ) لجمعِ المؤنثِ: رأيتُهُنَّ.
إذا أُسندَ الفعلُ إلى ضميرِ الغائبِ فإنَّ ضميرَ الغائبِ يكونُ مفعولاً به.$source$, 14, 14, 3),
    (azunnu_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$أَنَّ
أَنَّ: حرفُ نصبٍ من أخواتِ إنَّ التي تنصبُ الاسمَ، وترفعُ الخبرَ.
أَنَّ: لا تُنطقُ، ولا تُكتبُ في أوَّلِ الكلامِ.
أمثلةٌ: ياسرٌ مريضٌ: أظنُّ أنَّ ياسراً مريضٌ. المدرسُ ما جاءَ: أظنُّ أنَّ المدرسَ ما جاءَ.
هو مريضٌ: أظنُّ أنَّهُ مريضٌ. هي معلّمةٌ: أظنُّ أنَّها معلّمةٌ.
هم طلابٌ: أظنُّ أنَّهم طلابٌ. هنَّ معلّماتٌ: أظنُّ أنَّهنَّ معلّماتٌ.
أنتَ طبيبٌ: أظنُّ أنَّكَ طبيبٌ. أنتِ طبيبةٌ: أظنُّ أنَّكِ طبيبةٌ.
أنتم معلّمونَ: أظنُّ أنَّكم معلّمونَ. المكتبةُ مفتوحةٌ: أظنُّ أنَّ المكتبةَ مفتوحةٌ.$source$, 15, 15, 2),
    (numerals_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الْأَعْدَادُ الْمُرَكَّبَةُ، وَأَلْفَاظُ الْعُقُودِ
سبقتْ دراستُها في الدرسِ الثالثِ، ذكرنا فيه أنَّ العددينِ ١١ و١٢ يوافقانِ المعدودَ، تقولُ:
جاءَ أحدَ عشرَ طالباً. جاءتْ إحدى عشرةَ طالبةً.
عندي اثنا عشرَ كتاباً. عندي اثنتا عشرةَ حقيبةً.
وذكرنا أيضاً أنَّ الأعدادَ من ١٣ إلى ١٩ الجزءُ الأولُ يخالفُ المعدودَ، والجزءُ الثاني يوافقُ المعدودَ، تقولُ:
في المدينةِ ثلاثةَ عشرَ فندقاً. في المدينةِ ثلاثَ عشرةَ حديقةً.
خرجَ أربعةَ عشرَ طالباً. خرجتْ أربعَ عشرةَ طالبةً.
في المعهدِ خمسةَ عشرَ فصلاً. في المعهدِ خمسَ عشرةَ سيارةً.
ثمنُ القلمِ ستةَ عشرَ ريالاً. ثمنُ القلمِ ستَّ عشرةَ روبيةً.
سافرَ سبعةَ عشرَ طالباً. سافرتْ سبعَ عشرةَ طالبةً.
جاءَ ثمانيةَ عشرَ طالباً. جاءتْ ثمانيَ عشرةَ طالبةً.
جاءَ تسعةَ عشرَ طالباً. جاءتْ تسعَ عشرةَ طالبةً.
وذكرنا كذلك أنَّ الأعدادَ من ٢٠ إلى ٩٠ لا تختلفُ مع المعدودِ، أي: لا تتغيرُ، تقولُ:
جاءَ عشرونَ طالباً. جاءتْ عشرونَ طالبةً.
عندي ثلاثونَ ريالاً. عندي ثلاثونَ روبيةً.
في الفصلِ أربعونَ مقعداً. في الفصلِ أربعونَ طالبةً.
المعدودُ يُسمَّى في الإعرابِ: تمييزاً.$source$, 15, 16, 1),
    (adjective_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$مُؤَنَّثُ فَعْلَانَ، وَجَمْعُهُ
المذكّرُ: فَعْلَانُ. مؤنثُهُ: فَعْلَى. جمعُهُ للمذكّرِ والمؤنثِ: فِعَالٌ، وفُعَالَى.
تقولُ: حامدٌ غضبانُ. فاطمةُ غضبى. الطلابُ غضابٌ، والطالباتُ غضابٌ.
يوسفُ شبعانُ. مريمُ شبعى. الرجالُ شباعٌ، والنساءُ شباعٌ.
الطالبُ كسلانُ. الطالبةُ كسلى. الطلابُ كسالى، والطالباتُ كسالى.
هو سكرانُ. هي سكرى. هم سكارى، وهنَّ سكارى.$source$, 16, 16, 2),
    (limah_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$لِمَ؟
لِمَ: سؤالٌ عن السببِ، مثلُ: لماذا؟ في المعنى.
يجوزُ أن تتصلَ بها (هاءُ) السكتِ، ويؤتى بها في الوقفِ (لِمَ ← لِمَهْ؟).
لِمَ خرجتَ؟ لِمَ ضربتَهُ؟ لِمَ ذهبتَ إلى المديرِ؟
أخرجتَ؟ نعم. لِمَهْ؟ أضربتَهُ؟ نعم. لِمَهْ؟ أكتبتَ الواجبَ؟ لا. لِمَهْ؟$source$, 17, 17, 2),
    (irab_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$أَنْوَاعُ الإِعْرَابِ
أنواعُ الإعرابِ في الأسماءِ ثلاثةٌ، هي: الرفعُ، والنصبُ، والجرُّ.
وعلاماتُهُ الأصليةُ ثلاثةٌ، هي: الضمةُ للرفعِ، والفتحةُ للنصبِ، والكسرةُ للجرِّ.
الاسمُ المرفوعُ | الاسمُ المنصوبُ | الاسمُ المجرورُ
هذا كتابٌ | قرأتُ كتاباً | اطّلعتُ على كتابٍ
هذا حامدٌ | رأيتُ حامداً | مررتُ بحامدٍ
هذا بيتٌ | اشتريتُ بيتاً | سكنتُ في بيتٍ$source$, 17, 17, 1),
    (hati_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$هَاتِ
هاتِ: فعلُ أمرٍ، تاؤُهُ مكسورةٌ دائماً إلا إذا اتصلتْ به واوُ الجماعةِ فتكونُ التاءُ مضمومةً.
تقولُ: هاتِ يا أحمدُ. هاتي يا مريمُ. هاتوا يا إخوانُ. هاتينَ يا أخواتُ.
معناهُ: أعطني، تقولُ: هاتِ الواجبَ يا صالحُ. هاتي الدفاترَ يا سعادُ. هاتوا الكتبَ يا إخوانُ. هاتينَ الدفاترَ يا أخواتُ.$source$, 17, 17, 2);

  if (select count(*) from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '6') <> 8 then
    raise exception 'Expected 8 Book 2 lesson 6 rules after supplement';
  end if;

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '6'
      and coalesce(rule_ar, '') = ''
  ) then
    raise exception 'Book 2 lesson 6 contains an empty rule_ar';
  end if;

  if exists (
    select 1 from public.rules r
    where r.course_name = 'Мединский курс (Том 2)'
      and r.lesson_number = '6'
      and not exists (select 1 from public.rule_sources s where s.rule_id = r.id)
  ) then
    raise exception 'Book 2 lesson 6 contains a rule without provenance';
  end if;
end;
$migration$;

commit;
