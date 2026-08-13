-- Verify Medina Book 2 lesson 14 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 33-34.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 27-28.
-- The second PDF has a damaged logical text layer. Its source_text below is a
-- literal manual transcription from the rendered pages, authorized by the owner.

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
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '14';

  if lesson_rule_count <> 3 then
    raise exception 'Expected 3 Book 2 lesson 14 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '14' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '14' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '14' and sort_order = 3;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id);

  -- 1. Meaning, the three verb classes named in the sharh, and all five forms.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'فِعْلُ الْأَمْرِ: مَعْنَاهُ وَصِيَغُهُ (повелительный глагол: значение и формы)',
    rule_ar = 'فِعْلُ الْأَمْرِ مَا دَلَّ عَلَى طَلَبِ وُقُوعِ الْفِعْلِ مِنَ الْمُخَاطَبِ، وَهُوَ مَبْنِيٌّ دَائِمًا، وَلَا يَكُونُ إِلَّا لِلْمُخَاطَبِ الْمُذَكَّرِ وَالْمُؤَنَّثِ مُفْرَدًا أَوْ مُثَنًّى أَوْ جَمْعًا.',
    summary = 'Повелительный глагол выражает требование действия от собеседника, всегда является неизменяемым и имеет пять форм второго лица.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Определение из двух шархов</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">فِعْلُ الْأَمْرِ</span> مَا دَلَّ عَلَى طَلَبِ وُقُوعِ الْفِعْلِ مِنَ <span class="ar-tone-subject">الْمُخَاطَبِ</span>، وَهُوَ <span class="ar-tone-structure">مَبْنِيٌّ دَائِمًا</span>.</span>
        <p class="rule-study-text">Повелительный глагол выражает требование, чтобы собеседник совершил действие. Он всегда является <span class="ar-inline ar-tone-structure" dir="rtl" lang="ar">مَبْنِيٌّ</span> — неизменяемым по окончанию.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три разряда глагола, названные в шархе</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Арабское название и русский перевод</th><th>Пример</th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمَاضِي</span><span class="rule-table-ru">глагол прошедшего времени</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">ذَهَبَ.</span></td><td>Он ушёл.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمُضَارِعُ</span><span class="rule-table-ru">глагол настоящего-будущего времени</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَذْهَبُ.</span></td><td>Он идёт / пойдёт.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلُ الْأَمْرِ</span><span class="rule-table-ru">повелительный глагол</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبْ.</span></td><td>Иди.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Пять форм для собеседника</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Собеседник</th><th>Форма</th><th>Русский перевод</th><th>Исполнитель</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبْ.</span></td><td>Иди (одному мужчине).</td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنْتَ»</span><span class="rule-table-ru">скрытое местоимение «ты»</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبِي.</span></td><td>Иди (одной женщине).</td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span><span class="rule-table-ru">йа обращения к женщине</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمَا</span><span class="rule-table-ru">вы двое</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبَا.</span></td><td>Идите (вы двое).</td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">أَلِفُ الِاثْنَيْنِ</span><span class="rule-table-ru">алиф двойственного числа</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبُوا.</span></td><td>Идите (группе мужчин).</td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span><span class="rule-table-ru">вау группы</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبْنَ.</span></td><td>Идите (группе женщин).</td><td><span class="rule-table-ar ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span><span class="rule-table-ru">нун женского множественного числа</span></td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$فعل الأمر: ما دل على طلب وقوع الفعل من المخاطب سواء أكان مفردا أم مثنى أم جمعا، نحو:
اِذْهَبْ (للمخاطب).
اِذْهَبِي (للمخاطبة).
اِذْهَبَا (للمخاطبين).
اِذْهَبُوا (للمخاطبين).
اِذْهَبْنَ (للمخاطبات).
فعل الأمر مبني دائما.$$, 33, 33, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$فِعْلُ الأَمْرِ
الأفعالُ ثلاثةُ أقسامٍ، هي: ١- الفعلُ الماضي: ذَهَبَ. ٢- الفعلُ المضارعُ: يَذْهَبُ. ٣- فعلُ الأمرِ: اِذْهَبْ.
فعلُ الأمرِ، معناهُ: الطَّلَبُ، وهو مَبْنِيٌّ دائمًا، وكذلكَ الفعلُ الماضي مَبْنِيٌّ دائمًا.
إِسْنَادُ فِعْلِ الأَمْرِ إِلَى الضَّمَائِرِ
الفَاعِلُ | ضَمَائِرُ الفَاعِلِ الجَمْعُ | الفَاعِلُ | ضَمَائِرُ الفَاعِلِ المُفْرَدُ | المُذَكَّرُ وَالمُؤَنَّثُ | رُتَبُ الضَّمَائِرِ
وَاوُ الجَمَاعَةِ | اِذْهَبُوا | ضَمِيرٌ مُسْتَتِرٌ (أَنْتَ) | اِذْهَبْ | المُذَكَّرُ | المُخَاطَبُ
نُونُ النِّسْوَةِ | اِذْهَبْنَ | يَاءُ المُخَاطَبَةِ | اِذْهَبِي | المُؤَنَّثُ | المُخَاطَبُ$$, 27, 27, 2),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$فعلُ الأمرِ لا يكونُ إلا للمخاطبِ المذكرِ والمؤنثِ فقط.$$, 28, 28, 3);

  -- 2. Four construction signs and the complete i'rab printed in the 80-page sharh.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'بِنَاءُ فِعْلِ الْأَمْرِ وَإِعْرَابُهُ (построение повелительного глагола и его разбор)',
    rule_ar = 'فِعْلُ الْأَمْرِ مَبْنِيٌّ عَلَى السُّكُونِ، أَوْ عَلَى حَذْفِ النُّونِ، أَوْ عَلَى حَذْفِ حَرْفِ الْعِلَّةِ، أَوْ عَلَى الْفَتْحِ عِنْدَ اتِّصَالِ نُونِ التَّوْكِيدِ بِهِ.',
    summary = 'Повелительный глагол строится на сукуне, удалении нун, удалении слабой буквы либо на фатхе при присоединении усилительной нун.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Четыре признака построения</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">فِعْلُ الْأَمْرِ</span> مَبْنِيٌّ عَلَى <span class="ar-tone-structure">السُّكُونِ</span>، أَوْ عَلَى <span class="ar-tone-structure">حَذْفِ النُّونِ</span>، أَوْ عَلَى <span class="ar-tone-structure">حَذْفِ حَرْفِ الْعِلَّةِ</span>، أَوْ عَلَى <span class="ar-tone-structure">الْفَتْحِ</span> عِنْدَ اتِّصَالِ نُونِ التَّوْكِيدِ بِهِ.</span>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Признак и все формы из шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Арабский термин и русский перевод</th><th>Формы</th><th>Русское пояснение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">السُّكُونُ</span><span class="rule-table-ru">сукун</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبْ، اِذْهَبْنَ</span></td><td>Сукун: форма без присоединённого окончания и форма с нун женского множественного числа.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-table-ru">удаление нун</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبَا، اِذْهَبِي، اِذْهَبُوا</span></td><td>Удаление нун в двойственной, женской единственной и мужской множественной формах.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">حَذْفُ حَرْفِ الْعِلَّةِ</span><span class="rule-table-ru">удаление слабой буквы</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اُدْعُ، اِرْمِ، اِسْعَ</span></td><td>Призывай; бросай; стремись.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">الْفَتْحُ</span><span class="rule-table-ru">построение на фатхе</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اُكْتُبَنَّ</span></td><td>«Непременно пиши»: фатха при присоединении усилительной нун.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Полный إِعْرَاب (грамматический разбор) пяти форм</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Форма</th><th>Полный арабский разбор</th><th>Русское объяснение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلُ أَمْرٍ مَبْنِيٌّ عَلَى السُّكُونِ، وَالْفَاعِلُ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ «أَنْتَ».</span></td><td>Повелительный глагол построен на сукуне; исполнитель — скрытое местоимение «ты».</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلُ أَمْرٍ مَبْنِيٌّ عَلَى حَذْفِ النُّونِ، وَأَلِفُ الِاثْنَيْنِ فِي مَحَلِّ رَفْعٍ فَاعِلٌ.</span></td><td>Построен на удалении нун; алиф двойственного числа находится в позиции именительного падежа как исполнитель.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلُ أَمْرٍ مَبْنِيٌّ عَلَى حَذْفِ النُّونِ، وَيَاءُ الْمُخَاطَبَةِ فِي مَحَلِّ رَفْعٍ فَاعِلٌ.</span></td><td>Построен на удалении нун; йа обращения к женщине находится в позиции именительного падежа как исполнитель.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلُ أَمْرٍ مَبْنِيٌّ عَلَى حَذْفِ النُّونِ، وَوَاوُ الْجَمَاعَةِ فِي مَحَلِّ رَفْعٍ فَاعِلٌ.</span></td><td>Построен на удалении нун; вау группы находится в позиции именительного падежа как исполнитель.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">فِعْلُ أَمْرٍ مَبْنِيٌّ عَلَى السُّكُونِ، وَنُونُ النِّسْوَةِ فِي مَحَلِّ رَفْعٍ فَاعِلٌ.</span></td><td>Построен на сукуне; нун женского множественного числа находится в позиции именительного падежа как исполнитель.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$فعل الأمر مبني دائما وعلامات بنائه هي:
١. السكون، وذلك إذا لم يتصل به ضمير، نحو: اِذْهَبْ، ونحو: اِذْهَبْنَ (إذا اتصلت به نون النسوة).
٢. حذف النون، نحو: اِذْهَبِي، اِذْهَبَا، اِذْهَبُوا.
٣. حذف حرف العلة، نحو: اُدْعُ، اِرْمِ، اِسْعَ.
٤. الفتح، نحو: اُكْتُبَنَّ (وذلك إذا اتصلت به نون التوكيد).
إعراب فعل الأمر:
اِذْهَبْ: فعل أمر مبني على السكون، والفاعل ضمير مستتر تقديره "أنت".
اِذْهَبَا: فعل أمر مبني على حذف النون، ألف الاثنين في محل رفع فاعل.
اِذْهَبِي: فعل أمر مبني على حذف النون، ياء المخاطبة في محل رفع فاعل.
اِذْهَبُوا: فعل أمر مبني على حذف النون، واو الجماعة في محل رفع فاعل.
اِذْهَبْنَ: فعل أمر مبني على السكون، نون النسوة في محل رفع فاعل.$$, 33, 33, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$اِذْهَبْ: علامةُ بنائِهِ السكونُ.
اِذْهَبُوا: علامةُ بنائِهِ حذفُ النونِ.
اِذْهَبِي: علامةُ بنائِهِ حذفُ النونِ.
اِذْهَبْنَ: مَبْنِيٌّ على السكونِ.$$, 27, 27, 2);

  -- 3. Derivation, present prefixes, hamzat al-wasl, all examples, and connected speech.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'صِيَاغَةُ الْأَمْرِ وَهَمْزَةُ الْوَصْلِ (образование повелительного и соединительная хамза)',
    rule_ar = 'يُصَاغُ أَمْرُ الثُّلَاثِيِّ لِلْمُخَاطَبِ الْمُفْرَدِ مِنَ الْمُضَارِعِ بِحَذْفِ حَرْفِ الْمُضَارَعَةِ وَبِنَاءِ آخِرِهِ عَلَى السُّكُونِ، وَتُجْلَبُ هَمْزَةُ الْوَصْلِ إِذَا كَانَ أَوَّلُهُ سَاكِنًا؛ فَتُضَمُّ إِذَا كَانَتْ عَيْنُ الْمُضَارِعِ مَضْمُومَةً، وَتُكْسَرُ إِذَا كَانَتْ مَفْتُوحَةً أَوْ مَكْسُورَةً.',
    summary = 'Для формы единственного числа удаляется префикс المضارع; при начальном сукуне добавляется простая алиф соединительной хамзы. Её начальная огласовка зависит от огласовки средней коренной буквы в المضارع.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Последовательность образования формы единственного числа</span>
        <div class="rule-flow" dir="rtl" lang="ar"><span class="ar-tone-verb">تَذْهَبُ</span><span>← حَذْفُ حَرْفِ الْمُضَارَعَةِ</span><span class="ar-tone-verb">ذْهَبْ</span><span>← إِضَافَةُ هَمْزَةِ الْوَصْلِ</span><span class="ar-tone-verb">اِذْهَبْ</span></div>
        <p class="rule-study-text">Берётся форма настоящего-будущего времени, удаляется буква المضارع, конец строится на сукуне. Если получившаяся форма начинается с согласного с сукуном, для произнесения добавляется соединительная хамза.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">أَحْرُفُ الْمُضَارَعَةِ (буквы المضارع)</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">أَحْرُفُ الْمُضَارَعَةِ أَرْبَعَةٌ: <span class="ar-tone-structure">هَمْزَةٌ (أ)، وَتَاءٌ (ت)، وَيَاءٌ (ي)، وَنُونٌ (ن)</span>.</span>
        <p class="rule-study-text">В шархе четыре буквы собраны в последовательность <span class="ar-inline" dir="rtl" lang="ar">أَ، تَ، يَ، نَ</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Написание هَمْزَةُ الْوَصْلِ (соединительной хамзы)</span>
        <span class="rule-main-ar" dir="rtl" lang="ar">هَمْزَةُ الْأَمْرِ الثُّلَاثِيِّ <span class="ar-tone-structure">هَمْزَةُ وَصْلٍ</span>؛ فَلَا يُكْتَبُ فَوْقَهَا وَلَا تَحْتَهَا رَأْسُ الْهَمْزَةِ: <span class="ar-tone-verb">اِذْهَبْ، اُكْتُبْ</span>.</span>
        <p class="rule-study-text">В начале правильных форм стоит простая алиф без знака ء над или под ней. Касра или дамма показывают только начальное произношение: <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">اِذْهَبْ</span>, <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">اُكْتُبْ</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Огласовка средней коренной буквы и начальной алиф: все пары</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th><span class="rule-table-ar" dir="rtl" lang="ar">حَرَكَةُ عَيْنِ الْمُضَارِعِ</span><span class="rule-table-ru">огласовка средней коренной буквы المضارع</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمُضَارِعُ</span><span class="rule-table-ru">настоящее-будущее</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْأَمْرُ</span><span class="rule-table-ru">повелительное</span></th><th>Русский смысл</th></tr></thead>
          <tbody>
            <tr><td rowspan="4"><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الضَّمَّةُ ← ضَمُّ هَمْزَةِ الْوَصْلِ</span><span class="rule-table-ru">дамма → начальное اُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَكْتُبُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اُكْتُبْ</span></td><td>пишет — пиши</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَسْجُدُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اُسْجُدْ</span></td><td>совершает земной поклон — соверши земной поклон</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَدْرُسُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اُدْرُسْ</span></td><td>учится — учись</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَدْخُلُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اُدْخُلْ</span></td><td>входит — войди</td></tr>
            <tr><td rowspan="8"><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْفَتْحَةُ أَوِ الْكَسْرَةُ ← كَسْرُ هَمْزَةِ الْوَصْلِ</span><span class="rule-table-ru">фатха или касра → начальное اِ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَذْهَبُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبْ</span></td><td>идёт — иди</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَجْلِسُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِجْلِسْ</span></td><td>сидит — сядь</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَسْمَعُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِسْمَعْ</span></td><td>слышит — слушай</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَغْسِلُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِغْسِلْ</span></td><td>моет — мой</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَضْحَكُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِضْحَكْ</span></td><td>смеётся — смейся</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَضْرِبُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِضْرِبْ</span></td><td>ударяет — ударь</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَلْعَبُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِلْعَبْ</span></td><td>играет — играй</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَنْزِلُ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِنْزِلْ</span></td><td>спускается — спускайся</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Формы с удалением نُونٌ (нун)</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Форма المضارع (настоящего-будущего)</th><th>Форма الأمر (повелительного)</th><th>Что удалено</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَذْهَبُونَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَرْفُ الْمُضَارَعَةِ، ثُمَّ النُّونُ</span><span class="rule-table-ru">буква المضارع, затем нун</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">تَذْهَبِينَ</span></td><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">اِذْهَبِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">حَرْفُ الْمُضَارَعَةِ، ثُمَّ النُّونُ</span><span class="rule-table-ru">буква المضارع, затем нун</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">عَيْنُ الْفِعْلِ (средняя коренная буква)</span>
        <span class="rule-main-ar" dir="rtl" lang="ar"><span class="ar-tone-structure">عَيْنُ الْفِعْلِ</span> هِيَ الْحَرْفُ الثَّانِي فِي الْفِعْلِ الْمَاضِي، نَحْوَ: <span class="ar-tone-verb">ذَهَبَ، رَكِبَ</span>.</span>
        <p class="rule-study-text">Это вторая коренная буква в форме прошедшего времени: в <span class="ar-inline" dir="rtl" lang="ar">ذَهَبَ</span> — буква <span class="ar-inline" dir="rtl" lang="ar">هَ</span>, а в <span class="ar-inline" dir="rtl" lang="ar">رَكِبَ</span> — буква <span class="ar-inline" dir="rtl" lang="ar">كِ</span>.</p>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Произношение перед الـ и после وَ</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِشْرَبِ الْقَهْوَةَ.</span><span class="rule-example-ru">Выпей кофе. Конечный сукун повелительного изменён на касру перед определённым артиклем.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اِفْهَمِ الدَّرْسَ.</span><span class="rule-example-ru">Пойми урок. Конечный сукун изменён на касру перед определённым артиклем.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">اُخْرُجْ وَالْعَبْ.</span><span class="rule-example-ru">Выйди и поиграй. Конечная ج не получает касру, потому что следующая вау имеет огласовку, а не сукун.</span></div>
        </div>
      </div>
      <div class="rule-check-card"><span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">كُلْ، خُذْ</span><br>Если первая буква формы уже имеет огласовку, соединительная хамза не требуется.</div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$كيف نصاغ فعل الأمر؟
١. نأتي بالمضارع، نحو: تذهبُ.
٢. نحذف حرف المضارعة، نحو: ذْهبْ.
٣. نبني الفعل على السكون، نحو: ذْهَبْ.
٤. نأتي بهمزة الوصل ونحركها بالحركة المناسبة، نحو: اِذْهَبْ.
تنبيه:
١. أحرف المضارعة أربعة: أ، ت، ي، ن (أتين).
٢. نأتي بهمزة الوصل إذا كان أول الفعل ساكنا وإلا فلا، نحو: اِذْهَبْ = ا + ذْهَبْ. كُلْ: أول الفعل غير ساكن فلا نأتي بهمزة الوصل.
٣. حركة الهمزة تكون بحسب حركة عين الفعل المضارع.
إذا كانت حركة عين المضارع ضمة فحركة الهمزة تكون الضمة، نحو: يَكْتُبُ: اُكْتُبْ.
وإذا كانت حركة عين المضارع الفتحة أو الكسرة فحركة الهمزة تكون الكسرة، نحو: يَجْلِسُ: اِجْلِسْ. يَسْمَعُ: اِسْمَعْ.$$, 34, 34, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$همزةُ الأمرِ الثلاثيِّ همزةُ وصلٍ (ا) فلا يُكتبُ فوقَها ولا تحتَها علامةُ الهمزةِ (أ، إ): اذهب ✓ إذهب ×.$$, 27, 27, 2),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$حَرَكَةُ عَيْنِ الْفِعْلِ فِي الْأَمْرِ تُوَافِقُ حَرَكَةَ عَيْنِ الْفِعْلِ فِي الْمُضَارِعِ: يَذْهَبُ اِذْهَبْ، يَسْجُدُ اُسْجُدْ، يَغْسِلُ اِغْسِلْ، يَضْحَكُ اِضْحَكْ، يَدْرُسُ اُدْرُسْ، يَضْرِبُ اِضْرِبْ.
حركةُ همزةِ الوصلِ تكونُ مكسورةً إذا كانَ عينُ الفعلِ في المضارعِ مفتوحًا أو مكسورًا: يَذْهَبُ اِذْهَبْ، يَلْعَبُ اِلْعَبْ، يَضْرِبُ اِضْرِبْ، يَنْزِلُ اِنْزِلْ.
وتكونُ مضمومةً إذا كانَ عينُ الفعلِ في المضارعِ مضمومًا: يَسْجُدُ اُسْجُدْ، يَدْخُلُ اُدْخُلْ.
اِذْهَبْ، اُكْتُبْ: الحرفُ الساكنُ يحتاجُ إلى همزةِ وصلٍ لتسهيلِ النطقِ بهِ.
كُلْ، خُذْ: لا يحتاجُ إلى همزةِ وصلٍ؛ لأنَّهُ متحركٌ وليسَ ساكنًا.
إذا وقعتْ (ال) بعدَ فعلِ الأمرِ المبنيِّ على السكونِ تحوَّلَ السكونُ إلى كسرةٍ: اِشْرَبِ القهوةَ. اِفْهَمِ الدرسَ.
اُخْرُجْ وَالْعَبْ؛ لم يُكسرْ حرفُ الجيمِ؛ لأنَّ ما بعدَهُ حرفٌ ليسَ ساكنًا (و).
اِذْهَبُوا، اِذْهَبِي: أصلُهُ في المضارعِ تَذْهَبُونَ، تَذْهَبِينَ، حُذِفَ في الأمرِ حرفُ المضارعةِ (التاءُ) ثمَّ حُذِفَتِ النونُ.
عَيْنُ الْفِعْلِ: هُوَ الْحَرْفُ الثَّانِي فِي الْمَاضِي: ذَهَبَ، رَكِبَ.$$, 28, 28, 3);
end
$migration$;

commit;
