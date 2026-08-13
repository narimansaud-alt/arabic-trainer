-- Final QA corrections for confirmed Book 2 discrepancies.
-- Verbatim public.rule_sources.source_text records are intentionally untouched.

DO $migration$
BEGIN
  UPDATE public.rules
  SET content = $new_1251$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَمْ</span> لِتَعْيِينِ أَحَدِ الْأَمْرَيْنِ، وَ<span class="ar-tone-particle">أَوْ</span> تُسْتَعْمَلُ فِي الِاسْتِفْهَامِ وَغَيْرِهِ.</span><p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَمْ</span> связывает два варианта в вопросе с выбором. Перед первым вариантом ставится вопросительная хамза выбора; слово, о котором спрашивают, должно идти сразу после неё. <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَوْ</span> — союз «или», употребляемый и в вопросе, и вне вопроса.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Сравнение</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">أَ … أَمْ …؟</span><span class="rule-term-ru">вопрос с обязательным выбором одного из двух вариантов</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">أَوْ</span><span class="rule-term-ru">«или» в вопросительном и невопросительном высказывании</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَالَ تَعَالَى: ﴿أَرَاغِبٌ أَنتَ عَنۡ ءَالِهَتِي يَٰٓإِبۡرَٰهِيمُۖ﴾</span><span class="rule-example-ru">Всевышний сказал: «Неужели ты отвергаешь моих богов, о Ибрахим?»</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَ</span>مِنَ الْهِنْدِ أَنْتَ <span class="ar-tone-particle">أَمْ</span> مِنْ بَاكِسْتَانَ؟</span><span class="rule-example-ru">Ты из Индии или из Пакистана?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَلْ يَجُوزُ <span class="ar-tone-particle">أَوْ</span> لَا يَجُوزُ؟</span><span class="rule-example-ru">Разрешается или не разрешается?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">اِجْلِسْ هُنَا <span class="ar-tone-particle">أَوْ</span> هُنَاكَ.</span><span class="rule-example-ru">Сядь здесь или там.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Положение слова после хамзы</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">Форма</span></th><th><span class="rule-table-ru">Пример</span></th><th><span class="rule-table-ru">Почему</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar rule-table-valid">صَحِيحٌ</span><span class="rule-table-ru">правильно</span></td><td><span class="rule-table-ar rule-table-valid">أَطَالِبٌ أَنْتَ أَمْ أُسْتَاذٌ؟</span><span class="rule-table-ru">Ты студент или преподаватель?</span></td><td><span class="rule-table-ru">Спрашиваемое <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">طَالِبٌ</span> стоит сразу после хамзы.</span></td></tr><tr><td><span class="rule-table-ar rule-table-invalid">غَيْرُ صَحِيحٍ</span><span class="rule-table-ru">не по правилу шарха</span></td><td><span class="rule-table-ar rule-table-invalid">أَأَنْتَ طَالِبٌ أَمْ أُسْتَاذٌ؟</span><span class="rule-table-ru">порядок не соответствует приведённому правилу</span></td><td><span class="rule-table-ru">После хамзы поставлено <span class="ar-inline" dir="rtl" lang="ar">أَنْتَ</span>, а не выбираемая характеристика.</span></td></tr></tbody></table></div></div></div>$new_1251$
  WHERE id = 1251
    AND course_name = $course_1251$Мединский курс (Том 2)$course_1251$
    AND content = $old_1251$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَمْ</span> لِتَعْيِينِ أَحَدِ الْأَمْرَيْنِ، وَ<span class="ar-tone-particle">أَوْ</span> تُسْتَعْمَلُ فِي الِاسْتِفْهَامِ وَغَيْرِهِ.</span><p class="rule-study-text"><span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَمْ</span> связывает два варианта в вопросе с выбором. Перед первым вариантом ставится вопросительная хамза выбора; слово, о котором спрашивают, должно идти сразу после неё. <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">أَوْ</span> — союз «или», употребляемый и в вопросе, и вне вопроса.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Сравнение</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">أَ … أَمْ …؟</span><span class="rule-term-ru">вопрос с обязательным выбором одного из двух вариантов</span></div><div class="rule-meaning-card rule-term-particle"><span class="rule-term-ar" dir="rtl" lang="ar">أَوْ</span><span class="rule-term-ru">«или» в вопросительном и невопросительном высказывании</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Примеры</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">أَ</span>مِنَ الْهِنْدِ أَنْتَ <span class="ar-tone-particle">أَمْ</span> مِنْ بَاكِسْتَانَ؟</span><span class="rule-example-ru">Ты из Индии или из Пакистана?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">هَلْ يَجُوزُ <span class="ar-tone-particle">أَوْ</span> لَا يَجُوزُ؟</span><span class="rule-example-ru">Разрешается или не разрешается?</span></div><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">اِجْلِسْ هُنَا <span class="ar-tone-particle">أَوْ</span> هُنَاكَ.</span><span class="rule-example-ru">Сядь здесь или там.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Положение слова после хамзы</span><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ru">Форма</span></th><th><span class="rule-table-ru">Пример</span></th><th><span class="rule-table-ru">Почему</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar rule-table-valid">صَحِيحٌ</span><span class="rule-table-ru">правильно</span></td><td><span class="rule-table-ar rule-table-valid">أَطَالِبٌ أَنْتَ أَمْ أُسْتَاذٌ؟</span><span class="rule-table-ru">Ты студент или преподаватель?</span></td><td><span class="rule-table-ru">Спрашиваемое <span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">طَالِبٌ</span> стоит сразу после хамзы.</span></td></tr><tr><td><span class="rule-table-ar rule-table-invalid">غَيْرُ صَحِيحٍ</span><span class="rule-table-ru">не по правилу шарха</span></td><td><span class="rule-table-ar rule-table-invalid">أَأَنْتَ طَالِبٌ أَمْ أُسْتَاذٌ؟</span><span class="rule-table-ru">порядок не соответствует приведённому правилу</span></td><td><span class="rule-table-ru">После хамзы поставлено <span class="ar-inline" dir="rtl" lang="ar">أَنْتَ</span>, а не выбираемая характеристика.</span></td></tr></tbody></table></div></div></div>$old_1251$;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 2 QA: expected original content for rule 1251 was not found';
  END IF;

  UPDATE public.rules
  SET content = $new_1297$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Правило из двух шархов</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">«أَمَّا»</span> حَرْفُ تَفْصِيلٍ وَشَرْطٍ يَدُلُّ عَلَى التَّفْصِيلِ بَيْنَ شَيْئَيْنِ أَوْ أَكْثَرَ، وَيَقْتَرِنُ جَوَابُهُ وُجُوبًا بِ<span class="ar-tone-structure">الْفَاءِ</span>.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">أَمَّا</span> разделяет два или несколько предметов разговора. Ответ на неё обязательно присоединяется с помощью <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">فَـ</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры из обоих шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">﴿فَأَمَّا ٱلۡيَتِيمَ فَلَا تَقۡهَرۡ﴾ ﴿وَأَمَّا ٱلسَّآئِلَ فَلَا تَنۡهَرۡ﴾ ﴿وَأَمَّا بِنِعۡمَةِ رَبِّكَ فَحَدِّثۡ﴾</span><span class="rule-example-ru">Что касается сироты, то не притесняй его; что касается просящего, то не прогоняй его; а о милости твоего Господа возвещай.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ تَسْكُنُ؟ أَمَّا أَنَا فَأَسْكُنُ فِي الْمَهْجَعِ الثَّامِنِ، وَأَمَّا عَلِيٌّ فَيَسْكُنُ فِي الْمَهْجَعِ الْأَوَّلِ.</span><span class="rule-example-ru">Где ты живёшь? Что касается меня, я живу в восьмом общежитии, а Али живёт в первом общежитии.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">بِكَمِ الْكِتَابُ وَالْمَجَلَّةُ؟ أَمَّا الْكِتَابُ فَهُوَ بِعَشَرَةِ رِيَالَاتٍ، وَأَمَّا الْمَجَلَّةُ فَهِيَ بِثَلَاثَةِ رِيَالَاتٍ.</span><span class="rule-example-ru">Сколько стоят книга и журнал? Книга стоит десять риялов, а журнал - три рияла.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ يَدْرُسُ حَامِدٌ وَخَالِدٌ وَخَدِيجَةُ؟ أَمَّا حَامِدٌ فَيَدْرُسُ فِي الثَّانَوِيَّةِ، وَأَمَّا خَالِدٌ فَيَدْرُسُ فِي كُلِّيَّةِ الْحَدِيثِ، وَأَمَّا خَدِيجَةُ فَتَدْرُسُ فِي كُلِّيَّةِ الشَّرِيعَةِ.</span><span class="rule-example-ru">Где учатся Хамид, Халид и Хадиджа? Хамид учится в средней школе, Халид - на факультете хадиса, а Хадиджа - на факультете шариата.</span></div>
        </div>
      </div>
    </div>$new_1297$
  WHERE id = 1297
    AND course_name = $course_1297$Мединский курс (Том 2)$course_1297$
    AND content = $old_1297$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Правило из двух шархов</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">«أَمَّا»</span> حَرْفُ تَفْصِيلٍ وَشَرْطٍ يَدُلُّ عَلَى التَّفْصِيلِ بَيْنَ شَيْئَيْنِ أَوْ أَكْثَرَ، وَيَقْتَرِنُ جَوَابُهُ وُجُوبًا بِ<span class="ar-tone-structure">الْفَاءِ</span>.</span>
        <p class="rule-study-text"><span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">أَمَّا</span> разделяет два или несколько предметов разговора. Ответ на неё обязательно присоединяется с помощью <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">فَـ</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры из обоих шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">فَأَمَّا الْيَتِيمَ فَلَا تَقْهَرْ، وَأَمَّا السَّائِلَ فَلَا تَنْهَرْ، وَأَمَّا بِنِعْمَةِ رَبِّكَ فَحَدِّثْ.</span><span class="rule-example-ru">Что касается сироты, то не притесняй его; что касается просящего, то не прогоняй его; а о милости твоего Господа возвещай.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ تَسْكُنُ؟ أَمَّا أَنَا فَأَسْكُنُ فِي الْمَهْجَعِ الثَّامِنِ، وَأَمَّا عَلِيٌّ فَيَسْكُنُ فِي الْمَهْجَعِ الْأَوَّلِ.</span><span class="rule-example-ru">Где ты живёшь? Что касается меня, я живу в восьмом общежитии, а Али живёт в первом общежитии.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">بِكَمِ الْكِتَابُ وَالْمَجَلَّةُ؟ أَمَّا الْكِتَابُ فَهُوَ بِعَشَرَةِ رِيَالَاتٍ، وَأَمَّا الْمَجَلَّةُ فَهِيَ بِثَلَاثَةِ رِيَالَاتٍ.</span><span class="rule-example-ru">Сколько стоят книга и журнал? Книга стоит десять риялов, а журнал - три рияла.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ يَدْرُسُ حَامِدٌ وَخَالِدٌ وَخَدِيجَةُ؟ أَمَّا حَامِدٌ فَيَدْرُسُ فِي الثَّانَوِيَّةِ، وَأَمَّا خَالِدٌ فَيَدْرُسُ فِي كُلِّيَّةِ الْحَدِيثِ، وَأَمَّا خَدِيجَةُ فَتَدْرُسُ فِي كُلِّيَّةِ الشَّرِيعَةِ.</span><span class="rule-example-ru">Где учатся Хамид, Халид и Хадиджа? Хамид учится в средней школе, Халид - на факультете хадиса, а Хадиджа - на факультете шариата.</span></div>
        </div>
      </div>
    </div>$old_1297$;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 2 QA: expected original content for rule 1297 was not found';
  END IF;

  UPDATE public.rules
  SET content = $new_1314$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Правило</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الْعَلَمُ الْمَعْدُولُ عَلَى وَزْنِ فُعَلَ</span> مَمْنُوعٌ مِنَ الصَّرْفِ، فَيُرْفَعُ <span class="ar-tone-raf">بِالضَّمَّةِ</span>، وَيُنْصَبُ وَيُجَرُّ <span class="ar-tone-nasb">بِالْفَتْحَةِ</span>.</span>
        <p class="rule-study-text">Изменённое собственное имя по модели <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">فُعَلُ</span> не принимает танвин: именительный падеж обозначается даммой, а винительный и родительный — фатхой.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Примеры изменённых имён</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Имя</th><th>Что обозначает</th><th>Предполагаемая исходная форма</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">عُمَرُ</span></td><td>имя человека</td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَامِرٌ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">زُفَرُ</span></td><td>имя человека</td><td><span class="rule-table-ar" dir="rtl" lang="ar">زَافِرٌ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُبَلُ</span></td><td>название идола</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَابِلٌ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">زُحَلُ</span></td><td>планета Сатурн</td><td><span class="rule-table-ar" dir="rtl" lang="ar">زَاحِلٌ</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-check-card"><span class="ar-inline" dir="rtl" lang="ar">قِيلَ إِنَّ أُصُولَهَا هَذِهِ الْأَلْفَاظُ.</span> Второй шарх передаёт эти исходные формы с оговоркой «было сказано», а не как бесспорное утверждение.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре различия между عُمَرُ и عَمْرٌو</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Признак</th><th><span class="rule-table-ar" dir="rtl" lang="ar">عُمَرُ</span><span class="rule-table-ru">Умар</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">عَمْرٌو</span><span class="rule-table-ru">Амр</span></th></tr></thead>
          <tbody>
            <tr><td>Танвин</td><td>не принимает танвин</td><td>принимает танвин</td></tr>
            <tr><td>Написание</td><td>без добавочной буквы</td><td>добавочная <span class="ar-inline" dir="rtl" lang="ar">وَاوٌ</span> отличает имя на письме</td></tr>
            <tr><td>Падежные показатели</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ضَمَّةٌ، فَتْحَةٌ، فَتْحَةٌ</span><span class="rule-table-ru">дамма, фатха, фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ضَمَّةٌ، فَتْحَةٌ، كَسْرَةٌ</span><span class="rule-table-ru">дамма, фатха, касра</span></td></tr>
            <tr><td>Добавочная буква</td><td>—</td><td><span class="ar-inline" dir="rtl" lang="ar">وَاوٌ</span> остаётся в именительном и родительном; в винительном заменяется на <span class="ar-inline" dir="rtl" lang="ar">أَلِفٌ</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Падежные формы</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th><span class="rule-table-ar" dir="rtl" lang="ar">عَمْرٌو</span><span class="rule-table-ru">Амр</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">عُمَرُ</span><span class="rule-table-ru">Умар</span></th></tr></thead>
          <tbody>
            <tr><td>Именительный</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">عَمْرٌو</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">عُمَرُ</span></td></tr>
            <tr><td>Винительный</td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">عَمْرًا</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">عُمَرَ</span></td></tr>
            <tr><td>Родительный</td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">عَمْرٍو</span></td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">عُمَرَ</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِسْمِي <span class="ar-tone-raf">عُمَرُ</span>.</span><span class="rule-example-ru">Меня зовут Умар.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عُمَرَ</span>.</span><span class="rule-example-ru">Я видел Умара.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">عُمَرَ</span>.</span><span class="rule-example-ru">Я поприветствовал Умара.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِسْمِي <span class="ar-tone-raf">عَمْرٌو</span>.</span><span class="rule-example-ru">Меня зовут Амр.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عَمْرًا</span>.</span><span class="rule-example-ru">Я видел Амра.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">عَمْرٍو</span>.</span><span class="rule-example-ru">Я поприветствовал Амра.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ <span class="ar-tone-raf">عَمْرٌو</span> وَأَيْنَ <span class="ar-tone-raf">عُمَرُ</span>؟</span><span class="rule-example-ru">Где Амр и где Умар?</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عَمْرًا</span> وَ<span class="ar-tone-nasb">عُمَرَ</span>.</span><span class="rule-example-ru">Я видел Амра и Умара.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبْتُ إِلَى <span class="ar-tone-jarr">عَمْرٍو</span> وَ<span class="ar-tone-jarr">عُمَرَ</span>.</span><span class="rule-example-ru">Я пошёл к Амру и Умару.</span></div>
        </div>
      </div>
    </div>$new_1314$
  WHERE id = 1314
    AND course_name = $course_1314$Мединский курс (Том 2)$course_1314$
    AND content = $old_1314$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Правило</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">الْعَلَمُ الْمَعْدُولُ عَلَى وَزْنِ فُعَلَ</span> مَمْنُوعٌ مِنَ الصَّرْفِ، فَيُرْفَعُ <span class="ar-tone-raf">بِالضَّمَّةِ</span>، وَيُنْصَبُ وَيُجَرُّ <span class="ar-tone-nasb">بِالْفَتْحَةِ</span>.</span>
        <p class="rule-study-text">Изменённое собственное имя по модели <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">فُعَلُ</span> не принимает танвин: именительный падеж обозначается даммой, а винительный и родительный — фатхой.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Примеры изменённых имён</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Имя</th><th>Что обозначает</th><th>Предполагаемая исходная форма</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">عُمَرُ</span></td><td>имя человека</td><td><span class="rule-table-ar" dir="rtl" lang="ar">عَامِرٌ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">زُفَرُ</span></td><td>имя человека</td><td><span class="rule-table-ar" dir="rtl" lang="ar">زَافِرٌ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُبَلُ</span></td><td>название идола</td><td><span class="rule-table-ar" dir="rtl" lang="ar">هَابِلٌ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">زُحَلُ</span></td><td>планета Сатурн</td><td><span class="rule-table-ar" dir="rtl" lang="ar">زَاحِلٌ</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-check-card"><span class="ar-inline" dir="rtl" lang="ar">قِيلَ إِنَّ أُصُولَهَا هَذِهِ الْأَلْفَاظُ.</span> Второй шарх передаёт эти исходные формы с оговоркой «было сказано», а не как бесспорное утверждение.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре различия между عُمَرُ и عَمْرٌو</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Признак</th><th><span class="rule-table-ar" dir="rtl" lang="ar">عُمَرُ</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">عَمْرٌو</span></th></tr></thead>
          <tbody>
            <tr><td>Танвин</td><td>не принимает танвин</td><td>принимает танвин</td></tr>
            <tr><td>Написание</td><td>без добавочной буквы</td><td>добавочная <span class="ar-inline" dir="rtl" lang="ar">وَاوٌ</span> отличает имя на письме</td></tr>
            <tr><td>Падежные показатели</td><td><span class="rule-table-ar" dir="rtl" lang="ar">ضَمَّةٌ، فَتْحَةٌ، فَتْحَةٌ</span><span class="rule-table-ru">дамма, фатха, фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ضَمَّةٌ، فَتْحَةٌ، كَسْرَةٌ</span><span class="rule-table-ru">дамма, фатха, касра</span></td></tr>
            <tr><td>Добавочная буква</td><td>—</td><td><span class="ar-inline" dir="rtl" lang="ar">وَاوٌ</span> остаётся в именительном и родительном; в винительном заменяется на <span class="ar-inline" dir="rtl" lang="ar">أَلِفٌ</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Падежные формы</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th>عَمْرٌو</th><th>عُمَرُ</th></tr></thead>
          <tbody>
            <tr><td>Именительный</td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">عَمْرٌو</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">عُمَرُ</span></td></tr>
            <tr><td>Винительный</td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">عَمْرًا</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">عُمَرَ</span></td></tr>
            <tr><td>Родительный</td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">عَمْرٍو</span></td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">عُمَرَ</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры двух шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِسْمِي <span class="ar-tone-raf">عُمَرُ</span>.</span><span class="rule-example-ru">Меня зовут Умар.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عُمَرَ</span>.</span><span class="rule-example-ru">Я видел Умара.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">عُمَرَ</span>.</span><span class="rule-example-ru">Я поприветствовал Умара.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِسْمِي <span class="ar-tone-raf">عَمْرٌو</span>.</span><span class="rule-example-ru">Меня зовут Амр.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عَمْرًا</span>.</span><span class="rule-example-ru">Я видел Амра.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَلَّمْتُ عَلَى <span class="ar-tone-jarr">عَمْرٍو</span>.</span><span class="rule-example-ru">Я поприветствовал Амра.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">أَيْنَ <span class="ar-tone-raf">عَمْرٌو</span> وَأَيْنَ <span class="ar-tone-raf">عُمَرُ</span>؟</span><span class="rule-example-ru">Где Амр и где Умар?</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">عَمْرًا</span> وَ<span class="ar-tone-nasb">عُمَرَ</span>.</span><span class="rule-example-ru">Я видел Амра и Умара.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">ذَهَبْتُ إِلَى <span class="ar-tone-jarr">عَمْرٍو</span> وَ<span class="ar-tone-jarr">عُمَرَ</span>.</span><span class="rule-example-ru">Я пошёл к Амру и Умару.</span></div>
        </div>
      </div>
    </div>$old_1314$;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 2 QA: expected original content for rule 1314 was not found';
  END IF;

  UPDATE public.rules
  SET content = $new_1340$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Основное и допустимое построение</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَا</span> أَكَلْتُ.</span><span class="rule-term-ru">«Я не ел»: обычно прошедший глагол отрицается частицей <span class="ar-inline" dir="rtl" lang="ar">مَا</span>.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَا</span> آكُلُ.</span><span class="rule-term-ru">«Я не ем»: обычно настоящий глагол отрицается частицей <span class="ar-inline" dir="rtl" lang="ar">لَا</span>.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَا</span> أَكَلْتُ وَ<span class="ar-tone-particle">لَا</span> شَرِبْتُ.</span><span class="rule-term-ru">«Я не ел и не пил»: перед прошедшими глаголами <span class="ar-inline" dir="rtl" lang="ar">لَا</span> должна повторяться.</span></div>
        </div>
        <span class="rule-main-ar" dir="rtl" lang="ar">يَكُونُ ذَلِكَ فِي الْإِخْبَارِ فَقَطْ، لَا فِي الِاسْتِفْهَامِ.</span>
        <p class="rule-study-text">Такое отрицание прошедшего употребляется только в сообщении, но не в вопросительном предложении.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры обоих шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَالَ تَعَالَى: ﴿فَلَا صَدَّقَ وَلَا صَلَّىٰ﴾.</span><span class="rule-example-ru">Всевышний сказал: «Он не уверовал и не совершал молитву».</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا أَكَلْتُ وَلَا شَرِبْتُ.</span><span class="rule-example-ru">Я не ел и не пил.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا قَرَأْتُ وَلَا كَتَبْتُ.</span><span class="rule-example-ru">Я не читал и не писал.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ الطَّالِبُ لَا حَفِظَ الدَّرْسَ وَلَا كَتَبَ الْوَاجِبَ.</span><span class="rule-example-ru">Тот студент не выучил урок и не написал домашнее задание.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا ضَرَبَنِي وَلَا ضَرَبْتُهُ.</span><span class="rule-example-ru">Он не ударил меня, и я не ударил его.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا رَآنِي وَلَا رَأَيْتُهُ.</span><span class="rule-example-ru">Он не увидел меня, и я не увидел его.</span></div>
        </div>
      </div>
    </div>$new_1340$
  WHERE id = 1340
    AND course_name = $course_1340$Мединский курс (Том 2)$course_1340$
    AND content = $old_1340$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Основное и допустимое построение</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">مَا</span> أَكَلْتُ.</span><span class="rule-term-ru">«Я не ел»: обычно прошедший глагол отрицается частицей <span class="ar-inline" dir="rtl" lang="ar">مَا</span>.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَا</span> آكُلُ.</span><span class="rule-term-ru">«Я не ем»: обычно настоящий глагол отрицается частицей <span class="ar-inline" dir="rtl" lang="ar">لَا</span>.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-particle">لَا</span> أَكَلْتُ وَ<span class="ar-tone-particle">لَا</span> شَرِبْتُ.</span><span class="rule-term-ru">«Я не ел и не пил»: перед прошедшими глаголами <span class="ar-inline" dir="rtl" lang="ar">لَا</span> должна повторяться.</span></div>
        </div>
        <span class="rule-main-ar" dir="rtl" lang="ar">يَكُونُ ذَلِكَ فِي الْإِخْبَارِ فَقَطْ، لَا فِي الِاسْتِفْهَامِ.</span>
        <p class="rule-study-text">Такое отрицание прошедшего употребляется только в сообщении, но не в вопросительном предложении.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры обоих шархов</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَالَ تَعَالَى: ﴿فَلَا صَدَّقَ وَلَا صَلَّى﴾.</span><span class="rule-example-ru">Всевышний сказал: «Он не уверовал и не совершал молитву».</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا أَكَلْتُ وَلَا شَرِبْتُ.</span><span class="rule-example-ru">Я не ел и не пил.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا قَرَأْتُ وَلَا كَتَبْتُ.</span><span class="rule-example-ru">Я не читал и не писал.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">ذَلِكَ الطَّالِبُ لَا حَفِظَ الدَّرْسَ وَلَا كَتَبَ الْوَاجِبَ.</span><span class="rule-example-ru">Тот студент не выучил урок и не написал домашнее задание.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا ضَرَبَنِي وَلَا ضَرَبْتُهُ.</span><span class="rule-example-ru">Он не ударил меня, и я не ударил его.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا رَآنِي وَلَا رَأَيْتُهُ.</span><span class="rule-example-ru">Он не увидел меня, и я не увидел его.</span></div>
        </div>
      </div>
    </div>$old_1340$;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 2 QA: expected original content for rule 1340 was not found';
  END IF;

  UPDATE public.rules
  SET content = $new_1361$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Раф‘, насб и джазм</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Конечная буква</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">раф‘</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْجَزْمُ</span><span class="rule-table-ru">джазм</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْأَلِفُ</span><span class="rule-table-ru">алиф</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَبْقَى</span><span class="rule-table-ru">скрытая дамма из-за невозможности проявления</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَبْقَى</span><span class="rule-table-ru">скрытая фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَبْقَ</span><span class="rule-table-ru">удаление слабой буквы</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْوَاوُ</span><span class="rule-table-ru">вау</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُو</span><span class="rule-table-ru">скрытая дамма из-за тяжести</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَدْعُوَ</span><span class="rule-table-ru">явная фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَدْعُ</span><span class="rule-table-ru">удаление слабой буквы</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْيَاءُ</span><span class="rule-table-ru">йа</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِي</span><span class="rule-table-ru">скрытая дамма из-за тяжести</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَمْشِيَ</span><span class="rule-table-ru">явная фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَمْشِ</span><span class="rule-table-ru">удаление слабой буквы</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений: формы в раф‘</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِي</span><span class="rule-table-ru">идти</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَى</span><span class="rule-table-ru">забывать</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُو</span><span class="rule-table-ru">звать</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِي</span><span class="rule-table-ru">он идёт</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَى</span><span class="rule-table-ru">он забывает</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُو</span><span class="rule-table-ru">он зовёт</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشُونَ</span><span class="rule-table-ru">они идут</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَوْنَ</span><span class="rule-table-ru">они забывают</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُونَ</span><span class="rule-table-ru">они зовут</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِي</span><span class="rule-table-ru">она идёт</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَى</span><span class="rule-table-ru">она забывает</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُو</span><span class="rule-table-ru">она зовёт</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span><span class="rule-table-ru">они, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِينَ</span><span class="rule-table-ru">они идут</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَيْنَ</span><span class="rule-table-ru">они забывают</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُونَ</span><span class="rule-table-ru">они зовут</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِي</span><span class="rule-table-ru">ты идёшь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَى</span><span class="rule-table-ru">ты забываешь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُو</span><span class="rule-table-ru">ты зовёшь</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشُونَ</span><span class="rule-table-ru">вы идёте</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَوْنَ</span><span class="rule-table-ru">вы забываете</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُونَ</span><span class="rule-table-ru">вы зовёте</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِينَ</span><span class="rule-table-ru">ты идёшь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَيْنَ</span><span class="rule-table-ru">ты забываешь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعِينَ</span><span class="rule-table-ru">ты зовёшь</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِينَ</span><span class="rule-table-ru">вы идёте</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَيْنَ</span><span class="rule-table-ru">вы забываете</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُونَ</span><span class="rule-table-ru">вы зовёте</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَمْشِي</span><span class="rule-table-ru">я иду</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْسَى</span><span class="rule-table-ru">я забываю</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَدْعُو</span><span class="rule-table-ru">я зову</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَمْشِي</span><span class="rule-table-ru">мы идём</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَنْسَى</span><span class="rule-table-ru">мы забываем</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَدْعُو</span><span class="rule-table-ru">мы зовём</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Две одинаковые записи يَدْعُونَ</span>В <span class="ar-inline" dir="rtl" lang="ar">الطُّلَّابُ يَدْعُونَ</span> конечный <span class="ar-inline" dir="rtl" lang="ar">و</span> — وَاوُ الْجَمَاعَةِ, исполнитель, а коренная слабая буква удалена. В <span class="ar-inline" dir="rtl" lang="ar">الطَّالِبَاتُ يَدْعُونَ</span> конечная <span class="ar-inline" dir="rtl" lang="ar">ن</span> — نُونُ النِّسْوَةِ, исполнитель, а коренная <span class="ar-inline" dir="rtl" lang="ar">و</span> сохранена.</div>
      </div>
    </div>$new_1361$
  WHERE id = 1361
    AND course_name = $course_1361$Мединский курс (Том 2)$course_1361$
    AND content = $old_1361$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Раф‘, насб и джазм</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Конечная буква</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">раф‘</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْجَزْمُ</span><span class="rule-table-ru">джазм</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْأَلِفُ</span><span class="rule-table-ru">алиф</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَبْقَى</span><span class="rule-table-ru">скрытая дамма из-за невозможности проявления</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَبْقَى</span><span class="rule-table-ru">скрытая фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَبْقَ</span><span class="rule-table-ru">удаление слабой буквы</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْوَاوُ</span><span class="rule-table-ru">вау</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُو</span><span class="rule-table-ru">скрытая дамма из-за тяжести</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَدْعُوَ</span><span class="rule-table-ru">явная фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَدْعُ</span><span class="rule-table-ru">удаление слабой буквы</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْيَاءُ</span><span class="rule-table-ru">йа</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِي</span><span class="rule-table-ru">скрытая дамма из-за тяжести</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَمْشِيَ</span><span class="rule-table-ru">явная фатха</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَمْشِ</span><span class="rule-table-ru">удаление слабой буквы</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений: формы в раф‘</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِي</span><span class="rule-table-ru">идти</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَى</span><span class="rule-table-ru">забывать</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُو</span><span class="rule-table-ru">звать</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُو</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَوْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُونَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُو</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَمْشِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَنْسَيْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْعُونَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُو</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَوْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُونَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَيْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعِينَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَمْشِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَنْسَيْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْعُونَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَدْعُو</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَمْشِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَنْسَى</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَدْعُو</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Две одинаковые записи يَدْعُونَ</span>В <span class="ar-inline" dir="rtl" lang="ar">الطُّلَّابُ يَدْعُونَ</span> конечный <span class="ar-inline" dir="rtl" lang="ar">و</span> — وَاوُ الْجَمَاعَةِ, исполнитель, а коренная слабая буква удалена. В <span class="ar-inline" dir="rtl" lang="ar">الطَّالِبَاتُ يَدْعُونَ</span> конечная <span class="ar-inline" dir="rtl" lang="ar">ن</span> — نُونُ النِّسْوَةِ, исполнитель, а коренная <span class="ar-inline" dir="rtl" lang="ar">و</span> сохранена.</div>
      </div>
    </div>$old_1361$;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 2 QA: expected original content for rule 1361 was not found';
  END IF;

  UPDATE public.rules
  SET content = $new_1365$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Две допустимые формы джазма</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَمْ يَحُجَّ.</span><span class="rule-example-ru">Он не совершил хадж: слитая форма, сукун предполагается, а последняя буква получила фатху для устранения встречи двух сукунов.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَمْ يَحْجُجْ.</span><span class="rule-example-ru">Он не совершил хадж: раскрытая форма с явным сукуном.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений в трёх состояниях</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَرْفُوعُ</span><span class="rule-table-ru">раф‘</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَنْصُوبُ</span><span class="rule-table-ru">насб</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَجْزُومُ</span><span class="rule-table-ru">джазм</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَحُجُّ؛ يَعُدُّ؛ يَشُمُّ</span><span class="rule-table-ru">он совершает хадж; он считает; он нюхает</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَحُجَّ؛ لَنْ يَعُدَّ؛ لَنْ يَشُمَّ</span><span class="rule-table-ru">он не совершит хадж; он не посчитает; он не понюхает</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَحُجَّ أَوْ يَحْجُجْ؛ لَمْ يَعُدَّ أَوْ يَعْدُدْ؛ لَمْ يَشُمَّ أَوْ يَشْمُمْ</span><span class="rule-table-ru">он не совершил хадж; он не посчитал; он не понюхал</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَحُجُّونَ؛ يَعُدُّونَ؛ يَشُمُّونَ</span><span class="rule-table-ru">они совершают хадж; считают; нюхают</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَحُجُّوا؛ لَنْ يَعُدُّوا؛ لَنْ يَشُمُّوا</span><span class="rule-table-ru">они не совершат хадж; не посчитают; не понюхают</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَحُجُّوا؛ لَمْ يَعُدُّوا؛ لَمْ يَشُمُّوا</span><span class="rule-table-ru">они не совершили хадж; не посчитали; не понюхали</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجُّ؛ تَعُدُّ؛ تَشُمُّ</span><span class="rule-table-ru">она совершает хадж; считает; нюхает</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجَّ؛ لَنْ تَعُدَّ؛ لَنْ تَشُمَّ</span><span class="rule-table-ru">она не совершит хадж; не посчитает; не понюхает</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجَّ أَوْ تَحْجُجْ؛ لَمْ تَعُدَّ أَوْ تَعْدُدْ؛ لَمْ تَشُمَّ أَوْ تَشْمُمْ</span><span class="rule-table-ru">она не совершила хадж; не посчитала; не понюхала</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span><span class="rule-table-ru">они, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَحْجُجْنَ؛ يَعْدُدْنَ؛ يَشْمُمْنَ</span><span class="rule-table-ru">они совершают хадж; считают; нюхают</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَحْجُجْنَ؛ لَنْ يَعْدُدْنَ؛ لَنْ يَشْمُمْنَ</span><span class="rule-table-ru">они не совершат хадж; не посчитают; не понюхают</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَحْجُجْنَ؛ لَمْ يَعْدُدْنَ؛ لَمْ يَشْمُمْنَ</span><span class="rule-table-ru">они не совершили хадж; не посчитали; не понюхали</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجُّ؛ تَعُدُّ؛ تَشُمُّ</span><span class="rule-table-ru">ты совершаешь хадж; считаешь; нюхаешь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجَّ؛ لَنْ تَعُدَّ؛ لَنْ تَشُمَّ</span><span class="rule-table-ru">ты не совершишь хадж; не посчитаешь; не понюхаешь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجَّ أَوْ تَحْجُجْ؛ لَمْ تَعُدَّ أَوْ تَعْدُدْ؛ لَمْ تَشُمَّ أَوْ تَشْمُمْ</span><span class="rule-table-ru">ты не совершил хадж; не посчитал; не понюхал</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجُّونَ؛ تَعُدُّونَ؛ تَشُمُّونَ</span><span class="rule-table-ru">вы совершаете хадж; считаете; нюхаете</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجُّوا؛ لَنْ تَعُدُّوا؛ لَنْ تَشُمُّوا</span><span class="rule-table-ru">вы не совершите хадж; не посчитаете; не понюхаете</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجُّوا؛ لَمْ تَعُدُّوا؛ لَمْ تَشُمُّوا</span><span class="rule-table-ru">вы не совершили хадж; не посчитали; не понюхали</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجِّينَ؛ تَعُدِّينَ؛ تَشُمِّينَ</span><span class="rule-table-ru">ты совершаешь хадж; считаешь; нюхаешь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجِّي؛ لَنْ تَعُدِّي؛ لَنْ تَشُمِّي</span><span class="rule-table-ru">ты не совершишь хадж; не посчитаешь; не понюхаешь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجِّي؛ لَمْ تَعُدِّي؛ لَمْ تَشُمِّي</span><span class="rule-table-ru">ты не совершила хадж; не посчитала; не понюхала</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحْجُجْنَ؛ تَعْدُدْنَ؛ تَشْمُمْنَ</span><span class="rule-table-ru">вы совершаете хадж; считаете; нюхаете</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحْجُجْنَ؛ لَنْ تَعْدُدْنَ؛ لَنْ تَشْمُمْنَ</span><span class="rule-table-ru">вы не совершите хадж; не посчитаете; не понюхаете</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحْجُجْنَ؛ لَمْ تَعْدُدْنَ؛ لَمْ تَشْمُمْنَ</span><span class="rule-table-ru">вы не совершили хадж; не посчитали; не понюхали</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَحُجُّ؛ أَعُدُّ؛ أَشُمُّ</span><span class="rule-table-ru">я совершаю хадж; считаю; нюхаю</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ أَحُجَّ؛ لَنْ أَعُدَّ؛ لَنْ أَشُمَّ</span><span class="rule-table-ru">я не совершу хадж; не посчитаю; не понюхаю</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ أَحُجَّ أَوْ أَحْجُجْ؛ لَمْ أَعُدَّ أَوْ أَعْدُدْ؛ لَمْ أَشُمَّ أَوْ أَشْمُمْ</span><span class="rule-table-ru">я не совершил(а) хадж; не посчитал(а); не понюхал(а)</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحُجُّ؛ نَعُدُّ؛ نَشُمُّ</span><span class="rule-table-ru">мы совершаем хадж; считаем; нюхаем</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ نَحُجَّ؛ لَنْ نَعُدَّ؛ لَنْ نَشُمَّ</span><span class="rule-table-ru">мы не совершим хадж; не посчитаем; не понюхаем</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ نَحُجَّ أَوْ نَحْجُجْ؛ لَمْ نَعُدَّ أَوْ نَعْدُدْ؛ لَمْ نَشُمَّ أَوْ نَشْمُمْ</span><span class="rule-table-ru">мы не совершили хадж; не посчитали; не понюхали</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">نُونُ النِّسْوَةِ</span>В формах <span class="ar-inline" dir="rtl" lang="ar">يَحْجُجْنَ، يَعْدُدْنَ، يَشْمُمْنَ</span> раскрытие обязательно; глагол неизменяем на сукуне в раф‘ и находится в позиции насба или джазма после соответствующей частицы.</div>
      </div>
    </div>$new_1365$
  WHERE id = 1365
    AND course_name = $course_1365$Мединский курс (Том 2)$course_1365$
    AND content = $old_1365$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Две допустимые формы джазма</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَمْ يَحُجَّ.</span><span class="rule-example-ru">Он не совершил хадж: слитая форма, сукун предполагается, а последняя буква получила фатху для устранения встречи двух сукунов.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَمْ يَحْجُجْ.</span><span class="rule-example-ru">Он не совершил хадж: раскрытая форма с явным сукуном.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений в трёх состояниях</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَرْفُوعُ</span><span class="rule-table-ru">раф‘</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَنْصُوبُ</span><span class="rule-table-ru">насб</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَجْزُومُ</span><span class="rule-table-ru">джазм</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَحُجُّ؛ يَعُدُّ؛ يَشُمُّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَحُجَّ؛ لَنْ يَعُدَّ؛ لَنْ يَشُمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَحُجَّ أَوْ يَحْجُجْ؛ لَمْ يَعُدَّ أَوْ يَعْدُدْ؛ لَمْ يَشُمَّ أَوْ يَشْمُمْ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَحُجُّونَ؛ يَعُدُّونَ؛ يَشُمُّونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَحُجُّوا؛ لَنْ يَعُدُّوا؛ لَنْ يَشُمُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَحُجُّوا؛ لَمْ يَعُدُّوا؛ لَمْ يَشُمُّوا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجُّ؛ تَعُدُّ؛ تَشُمُّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجَّ؛ لَنْ تَعُدَّ؛ لَنْ تَشُمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجَّ أَوْ تَحْجُجْ؛ لَمْ تَعُدَّ أَوْ تَعْدُدْ؛ لَمْ تَشُمَّ أَوْ تَشْمُمْ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَحْجُجْنَ؛ يَعْدُدْنَ؛ يَشْمُمْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَحْجُجْنَ؛ لَنْ يَعْدُدْنَ؛ لَنْ يَشْمُمْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَحْجُجْنَ؛ لَمْ يَعْدُدْنَ؛ لَمْ يَشْمُمْنَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجُّ؛ تَعُدُّ؛ تَشُمُّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجَّ؛ لَنْ تَعُدَّ؛ لَنْ تَشُمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجَّ أَوْ تَحْجُجْ؛ لَمْ تَعُدَّ أَوْ تَعْدُدْ؛ لَمْ تَشُمَّ أَوْ تَشْمُمْ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجُّونَ؛ تَعُدُّونَ؛ تَشُمُّونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجُّوا؛ لَنْ تَعُدُّوا؛ لَنْ تَشُمُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجُّوا؛ لَمْ تَعُدُّوا؛ لَمْ تَشُمُّوا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحُجِّينَ؛ تَعُدِّينَ؛ تَشُمِّينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحُجِّي؛ لَنْ تَعُدِّي؛ لَنْ تَشُمِّي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحُجِّي؛ لَمْ تَعُدِّي؛ لَمْ تَشُمِّي</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَحْجُجْنَ؛ تَعْدُدْنَ؛ تَشْمُمْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَحْجُجْنَ؛ لَنْ تَعْدُدْنَ؛ لَنْ تَشْمُمْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَحْجُجْنَ؛ لَمْ تَعْدُدْنَ؛ لَمْ تَشْمُمْنَ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَحُجُّ؛ أَعُدُّ؛ أَشُمُّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ أَحُجَّ؛ لَنْ أَعُدَّ؛ لَنْ أَشُمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ أَحُجَّ أَوْ أَحْجُجْ؛ لَمْ أَعُدَّ أَوْ أَعْدُدْ؛ لَمْ أَشُمَّ أَوْ أَشْمُمْ</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحُجُّ؛ نَعُدُّ؛ نَشُمُّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ نَحُجَّ؛ لَنْ نَعُدَّ؛ لَنْ نَشُمَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ نَحُجَّ أَوْ نَحْجُجْ؛ لَمْ نَعُدَّ أَوْ نَعْدُدْ؛ لَمْ نَشُمَّ أَوْ نَشْمُمْ</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">نُونُ النِّسْوَةِ</span>В формах <span class="ar-inline" dir="rtl" lang="ar">يَحْجُجْنَ، يَعْدُدْنَ، يَشْمُمْنَ</span> раскрытие обязательно; глагол неизменяем на сукуне в раф‘ и находится в позиции насба или джазма после соответствующей частицы.</div>
      </div>
    </div>$old_1365$;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 2 QA: expected original content for rule 1365 was not found';
  END IF;

  UPDATE public.rules
  SET content = $new_1366$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Образование формы</span>
        <ol class="rule-step-list">
          <li><span class="rule-step-ar" dir="rtl" lang="ar">تَحُجُّ</span><span class="rule-step-ru">Берём настоящее время «ты совершаешь хадж».</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">حُجَّ</span><span class="rule-step-ru">Удаляем ت настоящего времени; слитая форма получает фатху для устранения двух сукунов.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">اُحْجُجْ</span><span class="rule-step-ru">Допустимая раскрытая форма с хамзатуль-васл и явным сукуном.</span></li>
        </ol>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре формы трёх глаголов</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Обращение</th><th>Совершить хадж</th><th>Посчитать</th><th>Понюхать</th><th>Построение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حُجَّ أَوِ احْجُجْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عُدَّ أَوِ اعْدُدْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شُمَّ أَوِ اشْمُمْ</span></td><td>сукун скрытый или явный</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حُجُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عُدُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شُمُّوا</span></td><td>удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حُجِّي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عُدِّي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شُمِّي</span></td><td>удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُحْجُجْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُعْدُدْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُشْمُمْنَ</span></td><td>обязательное раскрытие; сукун</td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Точный признак</span><span class="ar-inline" dir="rtl" lang="ar">حُجُّوا</span> и <span class="ar-inline" dir="rtl" lang="ar">حُجِّي</span> — формы повелительного наклонения. Соответствующие формы настоящего времени <span class="ar-inline" dir="rtl" lang="ar">تَحُجُّونَ</span> и <span class="ar-inline" dir="rtl" lang="ar">تَحُجِّينَ</span> относятся к <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">الْأَفْعَالُ الْخَمْسَةُ</span>. Повелительные формы строятся на <span class="ar-inline ar-tone-jazm" dir="rtl" lang="ar">حَذْفِ النُّونِ</span> — удалении нуна.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Обращения</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَحْمَدُ، حُجَّ.</span><span class="rule-example-ru">Ахмад, соверши хадж.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا فَاطِمَةُ، حُجِّي.</span><span class="rule-example-ru">Фатима, соверши хадж.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَوْلَادُ، حُجُّوا.</span><span class="rule-example-ru">Мальчики, совершите хадж.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا بَنَاتُ، اُحْجُجْنَ.</span><span class="rule-example-ru">Девочки, совершите хадж.</span></div>
        </div>
      </div>
    </div>$new_1366$
  WHERE id = 1366
    AND course_name = $course_1366$Мединский курс (Том 2)$course_1366$
    AND content = $old_1366$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Образование формы</span>
        <ol class="rule-step-list">
          <li><span class="rule-step-ar" dir="rtl" lang="ar">تَحُجُّ</span><span class="rule-step-ru">Берём настоящее время «ты совершаешь хадж».</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">حُجَّ</span><span class="rule-step-ru">Удаляем ت настоящего времени; слитая форма получает фатху для устранения двух сукунов.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">اُحْجُجْ</span><span class="rule-step-ru">Допустимая раскрытая форма с хамзатуль-васл и явным сукуном.</span></li>
        </ol>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре формы трёх глаголов</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Обращение</th><th>Совершить хадж</th><th>Посчитать</th><th>Понюхать</th><th>Построение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حُجَّ أَوِ اُحْجُجْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عُدَّ أَوِ اُعْدُدْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شُمَّ أَوِ اُشْمُمْ</span></td><td>сукун скрытый или явный</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حُجُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عُدُّوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شُمُّوا</span></td><td>удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حُجِّي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">عُدِّي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">شُمِّي</span></td><td>удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُحْجُجْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُعْدُدْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">اُشْمُمْنَ</span></td><td>обязательное раскрытие; сукун</td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Точный признак</span><span class="ar-inline" dir="rtl" lang="ar">حُجُّوا</span> и <span class="ar-inline" dir="rtl" lang="ar">حُجِّي</span> являются формами пяти глаголов и строятся на <span class="ar-inline ar-tone-jazm" dir="rtl" lang="ar">حَذْفِ النُّونِ</span> — удалении нуна.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Обращения</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَحْمَدُ، حُجَّ.</span><span class="rule-example-ru">Ахмад, соверши хадж.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا فَاطِمَةُ، حُجِّي.</span><span class="rule-example-ru">Фатима, соверши хадж.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَوْلَادُ، حُجُّوا.</span><span class="rule-example-ru">Мальчики, совершите хадж.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا بَنَاتُ، اُحْجُجْنَ.</span><span class="rule-example-ru">Девочки, совершите хадж.</span></div>
        </div>
      </div>
    </div>$old_1366$;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 2 QA: expected original content for rule 1366 was not found';
  END IF;

  UPDATE public.rules
  SET content = $new_1906$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Какие формы входят в пятёрку</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Лицо</th><th>Модель</th><th>Пример</th><th>Русское значение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْغَائِبُ الْجَمْعُ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">يَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْرُسُونَ</span></td><td>они учатся</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُخَاطَبُ الْجَمْعُ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">تَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْرُسُونَ</span></td><td>вы учитесь</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُخَاطَبَةُ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">تَفْعَلِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْرُسِينَ</span></td><td>ты учишься</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْغَائِبُ الْمُثَنَّى</span><span class="rule-table-ru">они двое</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">يَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْرُسَانِ</span></td><td>они двое учатся</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُخَاطَبُ الْمُثَنَّى</span><span class="rule-table-ru">вы двое</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">تَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْرُسَانِ</span></td><td>вы двое учитесь</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Раф‘, насб и джазм всех пяти форм</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Модель</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">сохранение ن</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">удаление ن</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْجَزْمُ</span><span class="rule-table-ru">удаление ن</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَفْعَلَانِ</span><span class="rule-table-ru">они двое делают</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَذْهَبَانِ</span><span class="rule-table-ru">они двое идут</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَذْهَبَا</span><span class="rule-table-ru">они двое не пойдут</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَذْهَبَا</span><span class="rule-table-ru">они двое не пошли</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">تَفْعَلَانِ</span><span class="rule-table-ru">вы двое делаете</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَذْهَبَانِ</span><span class="rule-table-ru">вы двое идёте</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَذْهَبَا</span><span class="rule-table-ru">вы двое не пойдёте</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَذْهَبَا</span><span class="rule-table-ru">вы двое не пошли</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَفْعَلُونَ</span><span class="rule-table-ru">они, мужчины, делают</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَذْهَبُونَ</span><span class="rule-table-ru">они идут</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَذْهَبُوا</span><span class="rule-table-ru">они не пойдут</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَذْهَبُوا</span><span class="rule-table-ru">они не пошли</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">تَفْعَلُونَ</span><span class="rule-table-ru">вы, мужчины, делаете</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَذْهَبُونَ</span><span class="rule-table-ru">вы идёте</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَذْهَبُوا</span><span class="rule-table-ru">вы не пойдёте</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَذْهَبُوا</span><span class="rule-table-ru">вы не пошли</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">تَفْعَلِينَ</span><span class="rule-table-ru">ты, женщина, делаешь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَذْهَبِينَ</span><span class="rule-table-ru">ты идёшь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَذْهَبِي</span><span class="rule-table-ru">ты не пойдёшь</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَذْهَبِي</span><span class="rule-table-ru">ты не пошла</span></td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$new_1906$
  WHERE id = 1906
    AND course_name = $course_1906$Мединский курс (Том 2)$course_1906$
    AND content = $old_1906$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Какие формы входят в пятёрку</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Лицо</th><th>Модель</th><th>Пример</th><th>Русское значение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْغَائِبُ الْجَمْعُ</span><span class="rule-table-ru">они, мужчины</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">يَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْرُسُونَ</span></td><td>они учатся</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُخَاطَبُ الْجَمْعُ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">تَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْرُسُونَ</span></td><td>вы учитесь</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُخَاطَبَةُ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">تَفْعَلِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْرُسِينَ</span></td><td>ты учишься</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْغَائِبُ الْمُثَنَّى</span><span class="rule-table-ru">они двое</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">يَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَدْرُسَانِ</span></td><td>они двое учатся</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">الْمُخَاطَبُ الْمُثَنَّى</span><span class="rule-table-ru">вы двое</span></td><td><span class="rule-table-ar ar-tone-pattern" dir="rtl" lang="ar">تَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَدْرُسَانِ</span></td><td>вы двое учитесь</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Раф‘, насб и джазм всех пяти форм</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Модель</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">сохранение ن</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">удаление ن</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْجَزْمُ</span><span class="rule-table-ru">удаление ن</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَذْهَبَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَذْهَبَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَذْهَبَا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">تَفْعَلَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَذْهَبَانِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَذْهَبَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَذْهَبَا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">يَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَذْهَبُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَذْهَبُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَذْهَبُوا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">تَفْعَلُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَذْهَبُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَذْهَبُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَذْهَبُوا</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">تَفْعَلِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَذْهَبِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَذْهَبِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَذْهَبِي</span></td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$old_1906$;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Book 2 QA: expected original content for rule 1906 was not found';
  END IF;

END
$migration$;
