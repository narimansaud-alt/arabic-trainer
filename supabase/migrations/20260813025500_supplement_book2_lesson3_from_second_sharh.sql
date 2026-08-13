-- Supplement Medina Book 2 lesson 3 from the second Arabic sharh.
-- Public cards merge compatible material; source rows remain separate by PDF.
-- The 62-page PDF has a broken logical text layer, so its source_text is a
-- manually checked visual transcription explicitly authorized by the owner.

begin;

do $migration$
declare
  preference_rule_id bigint;
  decades_rule_id bigint;
  compound_rule_id bigint;
  gender_rule_id bigint;
  ordinal_rule_id bigint;
  answer_rule_id bigint;
  ayyuhuma_rule_id bigint;
  lakinna_rule_id bigint;
  lesson_rule_count integer;
  updated_content text;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '3';

  if lesson_rule_count <> 7 then
    raise exception 'Expected 7 Book 2 lesson 3 rules before supplement, found %', lesson_rule_count;
  end if;

  select id into strict preference_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 1;
  select id into strict decades_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 2;
  select id into strict compound_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 3;
  select id into strict gender_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 4;
  select id into strict ordinal_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 5;
  select id into strict answer_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 6;
  select id into strict ayyuhuma_rule_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and sort_order = 7;

  -- Reserve sort order 2 for لَكِنَّ وَكَأَنَّ.
  update public.rules set sort_order = sort_order + 100
  where id in (decades_rule_id, compound_rule_id, gender_rule_id, ordinal_rule_id, answer_rule_id, ayyuhuma_rule_id);
  update public.rules set sort_order = 3 where id = decades_rule_id;
  update public.rules set sort_order = 4 where id = compound_rule_id;
  update public.rules set sort_order = 5 where id = gender_rule_id;
  update public.rules set sort_order = 6 where id = ordinal_rule_id;
  update public.rules set sort_order = 7 where id = answer_rule_id;
  update public.rules set sort_order = 8 where id = ayyuhuma_rule_id;

  -- 1. Add the second sharh's precise two patterns, invariant form, and all unique examples.
  select content into strict updated_content from public.rules where id = preference_rule_id;
  updated_content := rtrim(updated_content);
  if right(updated_content, 6) <> '</div>' then
    raise exception 'Unexpected outer markup for the Book 2 lesson 3 preference rule';
  end if;
  updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-preference-invariance"><span class="rule-card-kicker">Форма в двух моделях</span><span class="rule-main-ar" dir="rtl" lang="ar">فِي هَاتَيْنِ الصُّورَتَيْنِ يَكُونُ <span class="ar-tone-structure">اِسْمُ التَّفْضِيلِ</span> <span class="ar-tone-nasb">مُفْرَدًا مُذَكَّرًا دَائِمًا</span>، وَيُسْتَعْمَلُ لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span><p class="rule-study-text">После <span class="ar-inline ar-tone-jarr" dir="rtl" lang="ar">مِنْ</span> и в идафе с неопределённым словом форма остаётся в единственном числе мужского рода — также при женском или неодушевлённом предмете сравнения.</p></div>
<div class="rule-study-card"><span class="rule-card-kicker">С частицей مِنْ — «чем»</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">مُحَمَّدٌ <span class="ar-tone-structure">أَفْضَلُ</span> مِنْ خَالِدٍ.</span><span class="rule-example-ru">Мухаммад лучше Халида.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">فَاطِمَةُ <span class="ar-tone-structure">أَكْبَرُ</span> مِنْ عَائِشَةَ.</span><span class="rule-example-ru">Фатима старше Аиши.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">سَيَّارَتِي <span class="ar-tone-structure">أَجْمَلُ</span> مِنْ سَيَّارَتِكَ.</span><span class="rule-example-ru">Моя машина красивее твоей.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الشَّارِعُ <span class="ar-tone-structure">أَنْظَفُ</span> مِنْ ذَلِكَ.</span><span class="rule-example-ru">Эта улица чище той.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">خَطُّكَ <span class="ar-tone-structure">أَحْسَنُ</span> مِنْ خَطِّي.</span><span class="rule-example-ru">Твой почерк лучше моего.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتَ <span class="ar-tone-structure">أَكْبَرُ</span> مِنِّي.</span><span class="rule-example-ru">Ты старше меня.</span></div></div></div>
<div class="rule-study-card"><span class="rule-card-kicker">Идафа с неопределённым словом</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">مُحَمَّدٌ <span class="ar-tone-structure">أَحْسَنُ</span> طَالِبٍ فِي الْمَعْهَدِ.</span><span class="rule-example-ru">Мухаммад — лучший студент в институте.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">فَاطِمَةُ <span class="ar-tone-structure">أَكْبَرُ</span> طَالِبَةٍ فِي الْمَدْرَسَةِ.</span><span class="rule-example-ru">Фатима — самая старшая ученица в школе.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">سَيَّارَتِي <span class="ar-tone-structure">أَجْمَلُ</span> سَيَّارَةٍ فِي الْجَامِعَةِ.</span><span class="rule-example-ru">Моя машина — самая красивая машина в университете.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الشَّارِعُ <span class="ar-tone-structure">أَنْظَفُ</span> شَارِعٍ فِي الْمَدِينَةِ.</span><span class="rule-example-ru">Эта улица — самая чистая улица в городе.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">خَطُّكَ <span class="ar-tone-structure">أَحْسَنُ</span> خَطٍّ فِي الْفَصْلِ.</span><span class="rule-example-ru">Твой почерк — лучший в классе.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتِ <span class="ar-tone-structure">أَكْبَرُ</span> مُدَرِّسَةٍ فِي الْمَدْرَسَةِ.</span><span class="rule-example-ru">Ты — самая старшая учительница в школе.</span></div></div></div>
<div class="rule-study-card"><span class="rule-card-kicker">Дополнительные примеры второго шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">يَاسِرٌ رَجُلٌ فَقِيرٌ ← يَاسِرٌ <span class="ar-tone-structure">أَفْقَرُ</span> رَجُلٍ فِي الْقَرْيَةِ.</span><span class="rule-example-ru">Ясир — бедный человек → Ясир — самый бедный человек в деревне.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا كَبِيرٌ، هُوَ كَبِيرٌ ← أَنَا <span class="ar-tone-structure">أَكْبَرُ</span> مِنْهُ.</span><span class="rule-example-ru">Я взрослый, он взрослый → Я старше него.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا دَرْسٌ سَهْلٌ ← هَذَا <span class="ar-tone-structure">أَسْهَلُ</span> دَرْسٍ فِي الْكِتَابِ.</span><span class="rule-example-ru">Это лёгкий урок → Это самый лёгкий урок в книге.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">الْمَوْزُ رَخِيصٌ، الْعِنَبُ رَخِيصٌ ← الْمَوْزُ <span class="ar-tone-structure">أَرْخَصُ</span> مِنَ الْعِنَبِ.</span><span class="rule-example-ru">Бананы дешёвые, виноград дешёвый → Бананы дешевле винограда.</span></div></div></div>
</div>$html$;

  update public.rules
  set
    rule_ar = 'اِسْمُ التَّفْضِيلِ وَصْفٌ عَلَى وَزْنِ «أَفْعَلَ»، وَهُوَ مَمْنُوعٌ مِنَ الصَّرْفِ. وَإِذَا كَانَ مُضَعَّفًا أُدْغِمَ الْحَرْفَانِ الْمِثْلَانِ، وَإِذَا كَانَ مَقْصُورًا لَا تَظْهَرُ عَلَيْهِ عَلَامَةُ الْإِعْرَابِ. وَيَأْتِي نَكِرَةً بَعْدَهُ «مِنْ»، أَوْ نَكِرَةً مُضَافًا إِلَى نَكِرَةٍ؛ وَفِي هَاتَيْنِ الصُّورَتَيْنِ يَكُونُ مُفْرَدًا مُذَكَّرًا دَائِمًا، وَيُسْتَعْمَلُ لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    summary = 'اِسْمُ التَّفْضِيلِ وَصْفٌ عَلَى وَزْنِ «أَفْعَلَ»، وَهُوَ مَمْنُوعٌ مِنَ الصَّرْفِ. وَإِذَا كَانَ مُضَعَّفًا أُدْغِمَ الْحَرْفَانِ الْمِثْلَانِ، وَإِذَا كَانَ مَقْصُورًا لَا تَظْهَرُ عَلَيْهِ عَلَامَةُ الْإِعْرَابِ. وَيَأْتِي نَكِرَةً بَعْدَهُ «مِنْ»، أَوْ نَكِرَةً مُضَافًا إِلَى نَكِرَةٍ؛ وَفِي هَاتَيْنِ الصُّورَتَيْنِ يَكُونُ مُفْرَدًا مُذَكَّرًا دَائِمًا، وَيُسْتَعْمَلُ لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    content = updated_content
  where id = preference_rule_id;

  -- 2. This lesson's لَكِنَّ وَكَأَنَّ explanation exists only in the second sharh.
  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values (
    'Мединский курс (Том 2)',
    '3',
    'لَكِنَّ وَكَأَنَّ (частицы «но» и «словно, как будто»)',
    $html$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Действие двух частиц</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَكِنَّ وَكَأَنَّ</span> حَرْفَانِ مِنْ أَخَوَاتِ <span class="ar-tone-particle">إِنَّ</span>؛ يَنْصِبَانِ <span class="ar-tone-nasb">الِاسْمَ</span> وَيَرْفَعَانِ <span class="ar-tone-raf">الْخَبَرَ</span>.</span><p class="rule-study-text">Обе частицы относятся к сёстрам <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">إِنَّ</span>: их имя ставится в винительное состояние, а сказуемое — в именительное.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Значение каждой частицы</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْحَرْفُ</span><span class="rule-table-ru">частица</span></th><th><span class="rule-table-ar">الْمَعْنَى</span><span class="rule-table-ru">значение</span></th><th><span class="rule-table-ar">الْعَمَلُ</span><span class="rule-table-ru">грамматическое действие</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-particle">لَكِنَّ</span><span class="rule-table-ru">но, однако</span></td><td><span class="rule-table-ar ar-tone-structure">الِاسْتِدْرَاكُ</span><span class="rule-table-ru">устранение возможного ошибочного вывода</span></td><td><span class="rule-table-ar"><span class="ar-tone-nasb">تَنْصِبُ الِاسْمَ</span> وَ<span class="ar-tone-raf">تَرْفَعُ الْخَبَرَ</span></span><span class="rule-table-ru">имя — в винительном, сказуемое — в именительном состоянии</span></td></tr><tr><td><span class="rule-table-ar ar-tone-particle">كَأَنَّ</span><span class="rule-table-ru">словно, как будто</span></td><td><span class="rule-table-ar ar-tone-structure">التَّشْبِيهُ</span><span class="rule-table-ru">уподобление, сравнение</span></td><td><span class="rule-table-ar"><span class="ar-tone-nasb">تَنْصِبُ الِاسْمَ</span> وَ<span class="ar-tone-raf">تَرْفَعُ الْخَبَرَ</span></span><span class="rule-table-ru">имя — в винительном, сказуемое — в именительном состоянии</span></td></tr></tbody></table></div></div><div class="rule-study-card"><span class="rule-card-kicker">Все примеры второго шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">الطُّلَّابُ كَثِيرٌ، الْفَصْلُ صَغِيرٌ ← الطُّلَّابُ كَثِيرٌ، <span class="ar-tone-particle">لَكِنَّ</span> <span class="ar-tone-nasb">الْفَصْلَ</span> <span class="ar-tone-raf">صَغِيرٌ</span>.</span><span class="rule-example-ru">Студентов много, аудитория маленькая → Студентов много, но аудитория маленькая.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">آمِنَةُ مُجْتَهِدَةٌ، أُخْتُهَا كَسْلَى ← آمِنَةُ مُجْتَهِدَةٌ، <span class="ar-tone-particle">لَكِنَّ</span> <span class="ar-tone-nasb">أُخْتَهَا</span> <span class="ar-tone-raf">كَسْلَى</span>.</span><span class="rule-example-ru">Амина прилежна, её сестра ленива → Амина прилежна, но её сестра ленива.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هُوَ زَمِيلُكَ ← <span class="ar-tone-particle">كَأَنَّهُ</span> <span class="ar-tone-raf">زَمِيلُكَ</span>.</span><span class="rule-example-ru">Он твой товарищ → Словно он твой товарищ.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">الطِّفْلَةُ مَرِيضَةٌ ← <span class="ar-tone-particle">كَأَنَّ</span> <span class="ar-tone-nasb">الطِّفْلَةَ</span> <span class="ar-tone-raf">مَرِيضَةٌ</span>.</span><span class="rule-example-ru">Девочка больна → Как будто девочка больна.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">الْمُدَرِّسُ جَدِيدٌ ← <span class="ar-tone-particle">كَأَنَّ</span> <span class="ar-tone-nasb">الْمُدَرِّسَ</span> <span class="ar-tone-raf">جَدِيدٌ</span>.</span><span class="rule-example-ru">Учитель новый → Как будто учитель новый.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">بَيْتُكَ جَمِيلٌ، <span class="ar-tone-particle">لَكِنَّهُ</span> <span class="ar-tone-raf">صَغِيرٌ</span>.</span><span class="rule-example-ru">Твой дом красивый, но он маленький.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">كَأَنَّ</span> <span class="ar-tone-nasb">بَيْتَكَ</span> <span class="ar-tone-raf">مَسْجِدٌ</span>.</span><span class="rule-example-ru">Твой дом словно мечеть.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">كَأَنَّ</span> <span class="ar-tone-nasb">السَّيَّارَةَ</span> <span class="ar-tone-raf">قَدِيمَةٌ</span>.</span><span class="rule-example-ru">Машина словно старая.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">سَيَّارَتِي قَدِيمَةٌ، <span class="ar-tone-particle">لَكِنَّهَا</span> <span class="ar-tone-raf">قَوِيَّةٌ</span>.</span><span class="rule-example-ru">Моя машина старая, но она мощная.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Краткий إِعْرَابٌ — грамматический разбор</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْمِثَالُ</span><span class="rule-table-ru">пример</span></th><th><span class="rule-table-ar">اسْمُ الْحَرْفِ</span><span class="rule-table-ru">имя частицы</span></th><th><span class="rule-table-ar">خَبَرُ الْحَرْفِ</span><span class="rule-table-ru">сказуемое частицы</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar">لَكِنَّ الْفَصْلَ صَغِيرٌ</span><span class="rule-table-ru">но аудитория маленькая</span></td><td><span class="rule-table-ar ar-tone-nasb">الْفَصْلَ: اسْمُ لَكِنَّ مَنْصُوبٌ</span><span class="rule-table-ru">«аудитория» — имя لَكِنَّ в винительном состоянии</span></td><td><span class="rule-table-ar ar-tone-raf">صَغِيرٌ: خَبَرُ لَكِنَّ مَرْفُوعٌ</span><span class="rule-table-ru">«маленькая» — сказуемое لَكِنَّ в именительном состоянии</span></td></tr><tr><td><span class="rule-table-ar">كَأَنَّ الطِّفْلَةَ مَرِيضَةٌ</span><span class="rule-table-ru">как будто девочка больна</span></td><td><span class="rule-table-ar ar-tone-nasb">الطِّفْلَةَ: اسْمُ كَأَنَّ مَنْصُوبٌ</span><span class="rule-table-ru">«девочка» — имя كَأَنَّ в винительном состоянии</span></td><td><span class="rule-table-ar ar-tone-raf">مَرِيضَةٌ: خَبَرُ كَأَنَّ مَرْفُوعٌ</span><span class="rule-table-ru">«больна» — сказуемое كَأَنَّ в именительном состоянии</span></td></tr><tr><td><span class="rule-table-ar">كَأَنَّهُ زَمِيلُكَ</span><span class="rule-table-ru">словно он твой товарищ</span></td><td><span class="rule-table-ar ar-tone-nasb">الْهَاءُ: اسْمُ كَأَنَّ</span><span class="rule-table-ru">هُ — местоимение, имя كَأَنَّ</span></td><td><span class="rule-table-ar ar-tone-raf">زَمِيلُكَ: خَبَرُ كَأَنَّ مَرْفُوعٌ</span><span class="rule-table-ru">«твой товарищ» — сказуемое كَأَنَّ в именительном состоянии</span></td></tr></tbody></table></div></div></div>$html$,
    2,
    'rule',
    'لَكِنَّ وَكَأَنَّ حَرْفَانِ مِنْ أَخَوَاتِ إِنَّ؛ يَنْصِبَانِ الِاسْمَ وَيَرْفَعَانِ الْخَبَرَ. فَلَكِنَّ تُفِيدُ الِاسْتِدْرَاكَ، وَكَأَنَّ تُفِيدُ التَّشْبِيهَ.',
    'لَكِنَّ وَكَأَنَّ حَرْفَانِ مِنْ أَخَوَاتِ إِنَّ؛ يَنْصِبَانِ الِاسْمَ وَيَرْفَعَانِ الْخَبَرَ. فَلَكِنَّ تُفِيدُ الِاسْتِدْرَاكَ، وَكَأَنَّ تُفِيدُ التَّشْبِيهَ.'
  ) returning id into lakinna_rule_id;

  -- 3-5. Add every unique contextual number example from the second sharh.
  select content into strict updated_content from public.rules where id = compound_rule_id;
  updated_content := rtrim(updated_content);
  if right(updated_content, 6) <> '</div>' then raise exception 'Unexpected compound-number markup'; end if;
  updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-compound-examples"><span class="rule-card-kicker">Примеры 11–19 из второго шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">جَاءَ أَحَدَ عَشَرَ طَالِبًا.</span><span class="rule-example-ru">Пришли одиннадцать студентов.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">عِنْدِي اثْنَا عَشَرَ كِتَابًا.</span><span class="rule-example-ru">У меня двенадцать книг.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">فِي الْمَدِينَةِ ثَلَاثَةَ عَشَرَ فُنْدُقًا.</span><span class="rule-example-ru">В городе тринадцать гостиниц.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">خَرَجَ أَرْبَعَةَ عَشَرَ طَالِبًا.</span><span class="rule-example-ru">Вышли четырнадцать студентов.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">فِي الْمَعْهَدِ خَمْسَةَ عَشَرَ فَصْلًا.</span><span class="rule-example-ru">В институте пятнадцать аудиторий.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">ثَمَنُ الْقَلَمِ سِتَّةَ عَشَرَ رِيَالًا.</span><span class="rule-example-ru">Цена ручки — шестнадцать риалов.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">سَافَرَ سَبْعَةَ عَشَرَ طَالِبًا.</span><span class="rule-example-ru">Уехали семнадцать студентов.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">جَاءَ ثَمَانِيَةَ عَشَرَ طَالِبًا.</span><span class="rule-example-ru">Пришли восемнадцать студентов.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">جَاءَ تِسْعَةَ عَشَرَ طَالِبًا.</span><span class="rule-example-ru">Пришли девятнадцать студентов.</span></div></div></div>
</div>$html$;
  update public.rules set content = updated_content where id = compound_rule_id;

  select content into strict updated_content from public.rules where id = decades_rule_id;
  updated_content := rtrim(updated_content);
  if right(updated_content, 6) <> '</div>' then raise exception 'Unexpected decades markup'; end if;
  updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-decades-examples"><span class="rule-card-kicker">Дополнительные примеры десятков</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">جَاءَ عِشْرُونَ طَالِبًا.</span><span class="rule-example-ru">Пришли двадцать студентов.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">جَاءَ ثَلَاثُونَ طَالِبَةً.</span><span class="rule-example-ru">Пришли тридцать студенток.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">فِي الْفَصْلِ أَرْبَعُونَ مَقْعَدًا.</span><span class="rule-example-ru">В аудитории сорок сидений.</span></div></div></div>
</div>$html$;
  update public.rules set content = updated_content where id = decades_rule_id;

  -- 6. Preserve every unique sentence illustrating ordinal agreement.
  select content into strict updated_content from public.rules where id = ordinal_rule_id;
  updated_content := rtrim(updated_content);
  if right(updated_content, 6) <> '</div>' then raise exception 'Unexpected ordinal markup'; end if;
  updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-ordinal-examples"><span class="rule-card-kicker">Примеры второго шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا الدَّرْسُ الْأَوَّلُ، وَهَذَا الدَّرْسُ الثَّانِي.</span><span class="rule-example-ru">Это первый урок, а это второй урок.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَنَا أَدْرُسُ فِي السَّنَةِ الْأُولَى.</span><span class="rule-example-ru">Я учусь на первом курсе.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَخِي يَدْرُسُ فِي السَّنَةِ الثَّانِيَةِ.</span><span class="rule-example-ru">Мой брат учится на втором курсе.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَسْكُنُ فِي الْمَهْجَعِ الثَّالِثِ، وَزَمِيلِي فِي الْمَهْجَعِ الرَّابِعِ.</span><span class="rule-example-ru">Я живу в третьем общежитии, а мой товарищ — в четвёртом.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">قَرَأْتُ الصَّفْحَةَ الْخَامِسَةَ.</span><span class="rule-example-ru">Я прочитал пятую страницу.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">حَفِظْتُ الْجُزْءَ السَّادِسَ.</span><span class="rule-example-ru">Я выучил шестую часть.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">وَصَلْتُ فِي السَّاعَةِ السَّابِعَةِ.</span><span class="rule-example-ru">Я прибыл в семь часов.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">فَهِمْتُ الدَّرْسَيْنِ الثَّامِنَ وَالتَّاسِعَ.</span><span class="rule-example-ru">Я понял восьмой и девятый уроки.</span></div><div class="rule-example-card rule-term-structure"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ الْغُرْفَةُ الْعَاشِرَةُ؟</span><span class="rule-example-ru">Где десятая комната?</span></div></div></div>
</div>$html$;
  update public.rules set content = updated_content where id = ordinal_rule_id;

  -- 7. Add ordinary-question answers and all unique negative-question examples.
  select content into strict updated_content from public.rules where id = answer_rule_id;
  updated_content := rtrim(updated_content);
  if right(updated_content, 6) <> '</div>' then raise exception 'Unexpected answer-rule markup'; end if;
  updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-answer-examples"><span class="rule-card-kicker">Дополнительные отрицательные вопросы</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتَ مِنَ الْهِنْدِ. أَلَيْسَ كَذَلِكَ؟ <span class="ar-tone-particle">بَلَى</span>، أَنَا مِنَ الْهِنْدِ.</span><span class="rule-example-ru">Ты из Индии. Разве не так? — Да, я из Индии.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَنْتَ مِنَ الْهِنْدِ. أَلَيْسَ كَذَلِكَ؟ <span class="ar-tone-particle">نَعَمْ</span>، أَنَا لَسْتُ مِنَ الْهِنْدِ.</span><span class="rule-example-ru">Ты из Индии. Разве не так? — Нет, утверждение неверно: я не из Индии.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَبُوكَ طَبِيبٌ. أَلَيْسَ كَذَلِكَ؟ <span class="ar-tone-particle">بَلَى</span>، أَبِي طَبِيبٌ.</span><span class="rule-example-ru">Твой отец — врач. Разве не так? — Да, мой отец врач.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَبُوكَ طَبِيبٌ. أَلَيْسَ كَذَلِكَ؟ <span class="ar-tone-particle">نَعَمْ</span>، أَبِي لَيْسَ بِطَبِيبٍ.</span><span class="rule-example-ru">Твой отец — врач. Разве не так? — Нет, мой отец не врач.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَمَا ذَهَبْتَ؟ <span class="ar-tone-particle">بَلَى</span>، ذَهَبْتُ.</span><span class="rule-example-ru">Разве ты не ходил? — Напротив, ходил.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَمَا ذَهَبْتَ؟ <span class="ar-tone-particle">نَعَمْ</span>، مَا ذَهَبْتُ.</span><span class="rule-example-ru">Разве ты не ходил? — Да, не ходил.</span></div></div></div>
<div class="rule-study-card book2-second-sharh-ordinary-question"><span class="rule-card-kicker">Вопрос без отрицания</span><span class="rule-main-ar" dir="rtl" lang="ar">إِذَا لَمْ يَكُنِ الِاسْتِفْهَامُ مَنْفِيًّا، فَالْجَوَابُ فِي الْإِثْبَاتِ <span class="ar-tone-particle">نَعَمْ</span>، وَفِي النَّفْيِ <span class="ar-tone-particle">لَا</span>.</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَذَهَبْتَ إِلَى الْمَعْهَدِ؟ <span class="ar-tone-particle">نَعَمْ</span>، ذَهَبْتُ.</span><span class="rule-example-ru">Ты ходил в институт? — Да, ходил.</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَذَهَبْتَ إِلَى الْمَعْهَدِ؟ <span class="ar-tone-particle">لَا</span>، مَا ذَهَبْتُ.</span><span class="rule-example-ru">Ты ходил в институт? — Нет, не ходил.</span></div></div></div>
</div>$html$;
  update public.rules
  set
    title = 'جَوَابُ الِاسْتِفْهَامِ الْمَنْفِيِّ وَغَيْرِ الْمَنْفِيِّ (ответ на отрицательный и обычный вопрос)',
    rule_ar = 'إِذَا كَانَ الِاسْتِفْهَامُ مَنْفِيًّا، كَانَ جَوَابُهُ فِي الْإِثْبَاتِ «بَلَى»، وَفِي النَّفْيِ «نَعَمْ». وَإِذَا لَمْ يَكُنْ مَنْفِيًّا، فَالْجَوَابُ فِي الْإِثْبَاتِ «نَعَمْ»، وَفِي النَّفْيِ «لَا».',
    summary = 'إِذَا كَانَ الِاسْتِفْهَامُ مَنْفِيًّا، كَانَ جَوَابُهُ فِي الْإِثْبَاتِ «بَلَى»، وَفِي النَّفْيِ «نَعَمْ». وَإِذَا لَمْ يَكُنْ مَنْفِيًّا، فَالْجَوَابُ فِي الْإِثْبَاتِ «نَعَمْ»، وَفِي النَّفْيِ «لَا».',
    content = updated_content
  where id = answer_rule_id;

  -- 8. Add the stated human/non-human range and every source example.
  select content into strict updated_content from public.rules where id = ayyuhuma_rule_id;
  updated_content := rtrim(updated_content);
  if right(updated_content, 6) <> '</div>' then raise exception 'Unexpected ayyuhuma markup'; end if;
  updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-ayyuhuma-range"><span class="rule-card-kicker">С лицами и предметами</span><span class="rule-main-ar" dir="rtl" lang="ar">يُسْتَعْمَلُ <span class="ar-tone-particle">أَيُّهُمَا</span> لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَانِ طَالِبَانِ. <span class="ar-tone-particle">أَيُّهُمَا</span> أَطْوَلُ؟</span><span class="rule-example-ru">Это два студента. Который из них выше?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَانِ كِتَابَانِ. <span class="ar-tone-particle">أَيُّهُمَا</span> أَحْسَنُ؟</span><span class="rule-example-ru">Это две книги. Которая из них лучше?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَاتَانِ سَيَّارَتَانِ. <span class="ar-tone-particle">أَيُّهُمَا</span> أَجْمَلُ؟ السَّيَّارَةُ الْبَيْضَاءُ أَجْمَلُ.</span><span class="rule-example-ru">Это две машины. Которая из них красивее? Белая машина красивее.</span></div></div></div>
</div>$html$;
  update public.rules
  set
    rule_ar = 'أَيٌّ اسْمُ اسْتِفْهَامٍ مُعْرَبٌ، وَهُوَ مُلَازِمٌ لِلْإِضَافَةِ، وَهُمَا ضَمِيرُ الْمُثَنَّى. وَالِاسْتِفْهَامُ بِأَيُّهُمَا يُرَادُ بِهِ التَّعْيِينُ، وَيُسْتَعْمَلُ لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    summary = 'أَيٌّ اسْمُ اسْتِفْهَامٍ مُعْرَبٌ، وَهُوَ مُلَازِمٌ لِلْإِضَافَةِ، وَهُمَا ضَمِيرُ الْمُثَنَّى. وَالِاسْتِفْهَامُ بِأَيُّهُمَا يُرَادُ بِهِ التَّعْيِينُ، وَيُسْتَعْمَلُ لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    content = updated_content
  where id = ayyuhuma_rule_id;

  -- Store the second PDF's evidence separately from the 80-page evidence.
  delete from public.rule_sources
  where rule_id in (preference_rule_id, decades_rule_id, compound_rule_id, gender_rule_id, ordinal_rule_id, answer_rule_id, ayyuhuma_rule_id, lakinna_rule_id)
    and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf';

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (preference_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$اِسْمُ التَّفْضِيلِ: اسمٌ يُصاغُ على وزنِ أَفْعَلَ، وله عِدَّةُ صُوَرٍ، منها:
١- أَنْ يكونَ نكرةً، وبعدهُ حرفُ الجرِّ مِنْ، ويُستعملُ للعاقلِ، وغيرِ العاقلِ.
وفي هذه الصُّورةِ يكونُ اسمُ التفضيلِ مفردًا مذكّرًا دائمًا.
٢- أَنْ يكونَ نكرةً مضافًا إلى نكرةٍ، ويُستعملُ للعاقلِ، وغيرِ العاقلِ.
وفي هذه الصُّورةِ يكونُ اسمُ التفضيلِ أيضًا مفردًا مذكّرًا دائمًا.$source$, 9, 9, 2),
    (preference_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$تقولُ: محمدٌ أَفْضَلُ من خالدٍ. فاطمةُ أَكْبَرُ من عائشةَ. سيارتي أَجْمَلُ من سيارتِكَ.
هذا الشارعُ أَنْظَفُ من ذلكَ. خطُّكَ أَحْسَنُ من خطِّي. أنتَ أَكْبَرُ مِنِّي.
تقولُ: محمدٌ أَحْسَنُ طالبٍ في المعهدِ. فاطمةُ أَكْبَرُ طالبةٍ في المدرسةِ.
سيارتي أَجْمَلُ سيارةٍ في الجامعةِ. هذا الشارعُ أَنْظَفُ شارعٍ في المدينةِ.
خطُّكَ أَحْسَنُ خطٍّ في الفصلِ. أنتِ أَكْبَرُ مدرِّسةٍ في المدرسةِ.$source$, 9, 9, 3),
    (preference_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$اِسْمُ التَّفْضِيلِ: اسمٌ ممنوعٌ من الصَّرْفِ (لا يُنَوَّنُ).$source$, 10, 10, 4),
    (lakinna_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$لَكِنَّ، وَكَأَنَّ: حرفانِ من أخواتِ إِنَّ التي تنصبُ الاسمَ، وترفعُ الخبرَ.
الطُّلَّابُ كثيرٌ، الفصلُ صغيرٌ: الطُّلَّابُ كثيرٌ لَكِنَّ الفصلَ صغيرٌ.
آمنةُ مجتهدةٌ، أختُها كَسْلَى: آمنةُ مجتهدةٌ لَكِنَّ أختَها كَسْلَى. هو زميلُكَ: كَأَنَّهُ زميلُكَ.
الطفلةُ مريضةٌ: كَأَنَّ الطفلةَ مريضةٌ. المدرسُ جديدٌ: كَأَنَّ المدرسَ جديدٌ.
بيتُكَ جميلٌ لَكِنَّهُ صغيرٌ. كَأَنَّ بيتَكَ مسجدٌ. كَأَنَّ السيارةَ قديمةٌ. سيارتي قديمةٌ لَكِنَّهَا قويَّةٌ.$source$, 9, 9, 1),
    (lakinna_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$لَكِنَّ: تُفيدُ الاسْتِدْرَاكَ، أي: نفيُ ما يُظَنُّ إثباتُهُ.
كَأَنَّ: تُفيدُ التَّشبيهَ.$source$, 10, 10, 2),
    (compound_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الْأَعْدَادُ الْمُرَكَّبَةُ: هي الأعدادُ من ١١ إلى ١٩.
أمثلةٌ: جاءَ أحدَ عشرَ طالبًا. عندي اثنا عشرَ كتابًا. في المدينةِ ثلاثةَ عشرَ فندقًا.
خرجَ أربعةَ عشرَ طالبًا. في المعهدِ خمسةَ عشرَ فصلًا. ثمنُ القلمِ ستةَ عشرَ ريالًا.
سافرَ سبعةَ عشرَ طالبًا. جاءَ ثمانيةَ عشرَ طالبًا. جاءَ تسعةَ عشرَ طالبًا.$source$, 10, 10, 2),
    (gender_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$العددانِ (١١ و١٢) يوافقانِ المعدودَ، والأعدادُ من (١٣ إلى ١٩) الجزءُ الأوَّلُ يخالفُ المعدودَ، والجزءُ الثاني يوافقُ المعدودَ.$source$, 10, 10, 2),
    (decades_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$أَلْفَاظُ الْعُقُودِ: هي الأعدادُ (٢٠، ٣٠، ٤٠، ٥٠ إلى ٩٠) وهي لا تتغيَّرُ معَ المعدودِ.
جاءَ عشرونَ طالبًا. جاءَ ثلاثونَ طالبةً. في الفصلِ أربعونَ مقعدًا.
المعدودُ في الأعدادِ من ١١ إلى ١٩، وفي ألفاظِ العقودِ منصوبٌ دائمًا.$source$, 10, 10, 2),
    (ordinal_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الْعَدَدُ التَّرْتِيبِيُّ: وصفٌ لترتيبِ الأشياءِ. الأوَّلُ والثاني والثالثُ ...، وهو يوافقُ المعدودَ.
تقولُ: هذا الدرسُ الأوَّلُ، وهذا الدرسُ الثاني. أنا أدرسُ في السنةِ الأولى.
أخي يدرسُ في السنةِ الثانيةِ. أسكنُ في المهجعِ الثالثِ، وزميلي في المهجعِ الرابعِ.
قرأتُ الصفحةَ الخامسةَ. حفظتُ الجزءَ السادسَ. وصلتُ في الساعةِ السابعةِ.
فهمتُ الدرسينِ الثامنَ والتاسعَ. أينَ الغرفةُ العاشرةُ؟$source$, 11, 11, 2),
    (answer_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الاسْتِفْهَامُ الْمَنْفِيُّ: همزةُ الاستفهامِ + نفيٌ = أَلَيْسَ؟ جوابُهُ في الإثباتِ: بَلَى. وفي النفيِ: نَعَمْ.
أنتَ من الهندِ. أليسَ كذلكَ؟ بلى أنا من الهندِ. أو: نعم. أنا لستُ من الهندِ.
أبوكَ طبيبٌ. أليسَ كذلكَ؟ بلى. أبي طبيبٌ. أو: نعم. أبي ليسَ بطبيبٍ.
ومنهُ أيضًا النفيُ بـ (مَا النَّافِيَةِ): أَمَا ذهبتَ؟ بلى. ذهبتُ. أو: نعم. ما ذهبتُ.
إذا كانَ الاستفهامُ ليسَ منفيًّا فالجوابُ يكونُ (نعم) في الإثباتِ، و(لا) في النفيِ.
تقولُ: أذهبتَ إلى المعهدِ؟ نعم. ذهبتُ. أو: لا. ما ذهبتُ.$source$, 11, 11, 2),
    (ayyuhuma_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$أَيُّهُمَا: أَيٌّ، اسمُ استفهامٍ + هُمَا (ضميرُ الغائبِ للمثنَّى) يُستعملُ للعاقلِ، وغيرِهِ.
هذانِ طالبانِ. أَيُّهُمَا أطولُ؟ هذانِ كتابانِ. أَيُّهُمَا أحسنُ؟
هاتانِ سيارتانِ. أَيُّهُمَا أجملُ؟ السيارةُ البيضاءُ أجملُ.$source$, 11, 11, 2);

  if (select count(*) from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '3') <> 8 then
    raise exception 'Expected 8 Book 2 lesson 3 rules after supplement';
  end if;
  if exists (select 1 from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '3' and coalesce(rule_ar, '') = '') then
    raise exception 'Book 2 lesson 3 contains an empty rule_ar';
  end if;
  if exists (
    select 1 from public.rules r
    where r.course_name = 'Мединский курс (Том 2)' and r.lesson_number = '3'
      and not exists (select 1 from public.rule_sources s where s.rule_id = r.id)
  ) then
    raise exception 'Book 2 lesson 3 contains a rule without provenance';
  end if;
end;
$migration$;

commit;
