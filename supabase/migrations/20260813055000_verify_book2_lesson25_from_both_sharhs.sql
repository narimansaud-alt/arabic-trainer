-- Verify Medina Book 2 lesson 25 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 57-59.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF page 47.

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
    and lesson_number = '25';

  if lesson_rule_count <> 3 then
    raise exception 'Expected 3 Book 2 lesson 25 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '25' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '25' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '25' and sort_order = 3;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id);

  -- 1. Kana and ma zala: government, meanings, forms, predicate types, and all distinct examples.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'كَانَ وَمَا زَالَ (глаголы «был» и «всё ещё»)',
    rule_ar = 'كَانَ وَمَا زَالَ فِعْلَانِ مَاضِيَانِ نَاقِصَانِ يَدْخُلَانِ عَلَى الْجُمْلَةِ الِاسْمِيَّةِ، فَيَرْفَعَانِ الِاسْمَ وَيَنْصِبَانِ الْخَبَرَ، وَلَا يَحْتَاجَانِ إِلَى فَاعِلٍ. تُفِيدُ كَانَ اتِّصَافَ الْمُبْتَدَأِ بِالْخَبَرِ فِي الْمَاضِي، وَتُفِيدُ مَا زَالَ مُلَازَمَةَ الْمُبْتَدَأِ وَالْخَبَرِ. وَيَعْمَلَانِ فِي الْمَاضِي وَالْمُضَارِعِ: كَانَ وَيَكُونُ، وَمَا زَالَ وَلَا يَزَالُ. وَقَدْ يَكُونُ خَبَرُهُمَا اسْمًا مُفْرَدًا، أَوْ جُمْلَةً، أَوْ شِبْهَ جُمْلَةٍ.',
    summary = 'Неполные глаголы «был» и «всё ещё» входят в именное предложение: их имя остаётся в рафъ, а сказуемое переходит в насб. «Был» относит признак к прошлому, а «всё ещё» показывает его продолжение. Сохранены все виды сказуемого, формы прошедшего и настоящего времени и особые замечания обоих шархов.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Как изменяется именное предложение</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-subject">الطَّالِبُ</span> <span class="ar-tone-predicate">مَرِيضٌ</span>.</span><span class="rule-example-ru">Студент болен: обычное именное предложение.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَانَ</span> <span class="ar-tone-raf">الطَّالِبُ</span> <span class="ar-tone-nasb">مَرِيضًا</span> أَمْسِ.</span><span class="rule-example-ru">Студент был болен вчера: <span class="ar-inline ar-tone-raf" dir="rtl" lang="ar">اِسْمُ كَانَ</span> — имя «был» в рафъ; <span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">خَبَرُ كَانَ</span> — сказуемое «был» в насбе.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">مَا زَالَ</span> <span class="ar-tone-raf">الطَّالِبُ</span> <span class="ar-tone-nasb">مَرِيضًا</span>.</span><span class="rule-example-ru">Студент всё ещё болен, то есть болезнь продолжается до настоящего момента.</span></div>
        </div>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-raf" dir="rtl" lang="ar">اِسْمٌ مَرْفُوعٌ</span><span class="rule-term-ru">имя неполного глагола в рафъ.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-nasb" dir="rtl" lang="ar">خَبَرٌ مَنْصُوبٌ</span><span class="rule-term-ru">его сказуемое в насбе.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">فِعْلٌ نَاقِصٌ</span><span class="rule-term-ru">неполный глагол: для завершения смысла ему требуется сказуемое, а не фаиль.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Почему глагол называется неполным</span>Нельзя закончить высказывание словами <span class="ar-inline" dir="rtl" lang="ar">كَانَ الطَّالِبُ</span> — «студент был»: необходимо добавить сказуемое в насбе, завершающее смысл.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Прошедшее и настоящее время</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Глагол и смысл</th><th>Арабский пример</th><th>Русский перевод</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">كَانَ</span><span class="rule-table-ru">был, была</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَانَ</span> الْمَاءُ بَارِدًا.</span></td><td>Вода была холодной.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">كَانَتْ</span><span class="rule-table-ru">была, женский род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَانَتْ</span> زَيْنَبُ طَالِبَةً.</span></td><td>Зайнаб была студенткой.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">يَكُونُ</span><span class="rule-table-ru">бывает, будет</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">يَكُونُ</span> الْجَوُّ بَارِدًا فِي الشِّتَاءِ.</span></td><td>Зимой погода бывает холодной.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">مَا زَالَ</span><span class="rule-table-ru">всё ещё, мужской род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">مَا زَالَ</span> الْمَطَرُ نَازِلًا.</span></td><td>Дождь всё ещё идёт.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">مَا تَزَالُ</span><span class="rule-table-ru">всё ещё, женский род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">مَا تَزَالُ</span> خَدِيجَةُ نَائِمَةً.</span></td><td>Хадиджа всё ещё спит.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">لَا يَزَالُ</span><span class="rule-table-ru">по-прежнему</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">لَا يَزَالُ</span> هِشَامٌ عَزَبًا.</span></td><td>Хишам по-прежнему холост.</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Три вида сказуемого</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Вид сказуемого</th><th>Арабский пример</th><th>Разбор и перевод</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">اِسْمٌ مُفْرَدٌ</span><span class="rule-table-ru">отдельное имя</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">كَانَ <span class="ar-tone-raf">حَامِدٌ</span> <span class="ar-tone-nasb">طَالِبًا</span>.</span></td><td><span class="ar-inline ar-tone-nasb" dir="rtl" lang="ar">طَالِبًا</span> — сказуемое «был» в насбе. Хамид был студентом.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">جُمْلَةٌ فِعْلِيَّةٌ</span><span class="rule-table-ru">глагольное предложение</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">كَانَ حَامِدٌ <span class="ar-tone-verb">يَدْرُسُ</span>.</span></td><td>Предложение <span class="ar-inline" dir="rtl" lang="ar">يَدْرُسُ</span> находится в позиции насба как сказуемое. Хамид учился.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-structure" dir="rtl" lang="ar">شِبْهُ جُمْلَةٍ</span><span class="rule-table-ru">предложно-именная группа</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">كَانَ حَامِدٌ <span class="ar-tone-jarr">فِي الْفَصْلِ</span>.</span></td><td>Группа «в классе» находится в позиции насба как сказуемое. Хамид был в классе.</td></tr>
          </tbody>
        </table></div>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">مُحَمَّدٌ كَانَ <span class="ar-tone-nasb">مَرِيضًا</span>.</span><span class="rule-term-ru">Мухаммад был болен. Имя «был» — скрытое местоимение <span class="ar-inline" dir="rtl" lang="ar">هُوَ</span> в позиции рафъ.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">كَانَ <span class="ar-tone-jarr">لِي</span> <span class="ar-tone-raf">ثَلَاثُ أَخَوَاتٍ</span>.</span><span class="rule-term-ru">У меня было три сестры. Поскольку сказуемое — شِبْهُ جُمْلَةٍ, а имя неопределённое, сказуемое обязательно стоит первым.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Неполный и полный глагол; дополнительные замечания</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">كَانَ</span> مُحَمَّدٌ مَرِيضًا.</span><span class="rule-term-ru">«Мухаммад был болен»: неполному глаголу нужны имя и сказуемое.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar"><span class="ar-tone-verb">ذَهَبْتُ</span> إِلَى السُّوقِ.</span><span class="rule-term-ru">«Я пошёл на рынок»: полному глаголу для завершения смысла нужен только фаиль.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">كَانَ بِلَالٌ مَرِيضًا أَمْسِ، وَلَا يَزَالُ مَرِيضًا.</span><span class="rule-term-ru">Биляль был болен вчера и всё ещё болен.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Неопределённые обстоятельственные слова</span>В <span class="ar-inline" dir="rtl" lang="ar">كَانَ مَرِيضًا مِنْ قَبْلُ</span> слово <span class="ar-inline" dir="rtl" lang="ar">قَبْلُ</span>, а в <span class="ar-inline" dir="rtl" lang="ar">رَأَيْتُ بِلَالًا يَوْمَ الْجُمُعَةِ، وَلَمْ أَرَهُ مِنْ بَعْدُ</span> слово <span class="ar-inline" dir="rtl" lang="ar">بَعْدُ</span> неизменяемо на дамме и находится в позиции джарра. Второе предложение означает: «Я видел Биляля в пятницу и после пятницы его не видел».</div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الدرس الخامس والعشرون
كان وما زال
كان
كان فعل ماض ناقص.
١. اسم كان مرفوع وخبرها منصوب.
٢. فعل ناقص لا يحتاج إلى فاعل.
٣. تدخل كان على الجملة الاسمية.
٤. تفيد اتصاف المبتدأ بالخبر في الماضي.
٥. خبر كان قد يكون اسما مفردا، أو جملة، أو شبه جملة.
نحو:
كان حامد طالبا.
حامد: اسم كان مرفوع، طالبا: خبر كان منصوب (وهو اسم مفرد).
كان حامد يدرس.
يدرس: خبر كان في محل نصب (وهو جملة فعلية).
كان حامد في الفصل.
في الفصل: خبر كان في محل النصب (وهو شبه جملة).
قد يكون اسم كان ضميرا مستترا،
نحو: محمد كان مريضا.
اسم كان ضمير مستتر تقديره "هو" في محل الرفع.
يجب تقديم خبر كان على اسمها إذا كان خبرها شبه جملة واسمها نكرة،
نحو: كان لي ثلاث أخوات.
الفعل الناقص عكسه الفعل التام، والفعل الناقص يحتاج إلى المبتدأ والخبر في إتمام معناه، أما الفعل التام فيحتاج إلى الفاعل فقط في إتمام معناه.
نحو: الفعل الناقص، كان محمد مريضا.
ونحو: الفعل التام، ذهبت إلى السوق.
ما زال
١. ما زال: فعل ماض ناقص.
٢. اسم ما زال مرفوع وخبرها منصوب.
٣. فعل ناقص لا يحتاج إلى فاعل.
٤. تدخل ما زال على الجملة الاسمية.
٥. تفيد ملازمة المبتدأ والخبر.
٦. خبرها يكون اسما مفردا، وجملة، وشبه جملة.
٧. مضارعها لا يزال.
نحو: كان بلال مريضا أمس، ولا يزال مريضا.$$,
      57, 59, 1),
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$فائدة:
جاء في الكتاب عبارة: كان مريضا من قبل (مبني على الضم في محل جر).
ومثله: رأيت بلالا يوم الجمعة، ولم أره من بعد (مبني على الضم في محل جر).
يعني من بعد يوم الجمعة.$$,
      59, 59, 2),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$كان: فعل ماض ناقص، يرفع الاسم، وينصب الخبر.
مازال: فعل ماض ناقص، يرفع الاسم، وينصب الخبر (وهو من أخوات كان).
كان، ومازال: يعملان وهما في حالة الماضي، والمضارع (يكون، ولا يزال).
أمثلة:
الطالب مريض.
كان الطالب مريضا أمس (أي: في الماضي).
مازال الطالب مريضا (أي: ملازما للمرض إلى الآن).
كان الماء باردا. كانت زينب طالبة. يكون الجو باردا في الشتاء.
مازال المطر نازلا. ما تزال خديجة نائمة. لا يزال هشام عزبا.
كان فعل ناقص: أي: يحتاج إلى خبر منصوب؛ ليتم المعنى. فلا يصح قولك: كان الطالب (بدون خبر).$$,
      47, 47, 3);

  -- 2. The five nouns and the complete case examples for ab and akh.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'table',
    title = 'الْأَسْمَاءُ الْخَمْسَةُ وَإِعْرَابُ الْأَبِ وَالْأَخِ (пять имён и склонение слов «отец» и «брат»)',
    rule_ar = 'الْأَسْمَاءُ الْخَمْسَةُ هِيَ: أَبٌ، وَأَخٌ، وَحَمٌ، وَفُو، وَذُو بِمَعْنَى صَاحِبٍ. وَتُرْفَعُ بِالْوَاوِ، وَتُنْصَبُ بِالْأَلِفِ، وَتُجَرُّ بِالْيَاءِ عِنْدَ تَحَقُّقِ شُرُوطِهَا.',
    summary = 'К пяти особым именам относятся «отец», «брат», родственник со стороны брака, «рот» и ذُو в значении «обладатель». При выполнении условий они имеют вау в рафъ, алиф в насбе и йа в джарре. Второй шарх приводит полный набор из 18 примеров для слов «отец» и «брат».',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Пять имён и их русский смысл</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">أَبٌ</span><span class="rule-term-ru">отец.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">أَخٌ</span><span class="rule-term-ru">брат.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">حَمٌ</span><span class="rule-term-ru">родственник со стороны супруга или супруги.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">فُو</span><span class="rule-term-ru">рот.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">ذُو</span><span class="rule-term-ru">обладатель, имеющий; здесь только в значении <span class="ar-inline" dir="rtl" lang="ar">صَاحِبٌ</span> «обладатель».</span></div>
        </div>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th>Показатель</th><th>Форма «отец»</th><th>Форма «брат»</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الْوَاوُ</span><span class="rule-table-ru">вау</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">أَبُو</span></td><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">أَخُو</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">الْأَلِفُ</span><span class="rule-table-ru">алиф</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">أَبَا</span></td><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">أَخَا</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْيَاءُ</span><span class="rule-table-ru">йа</span></td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">أَبِي</span></td><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">أَخِي</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Все примеры слов «отец» и «брат» из второго шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th>Арабский пример</th><th>Русский перевод</th></tr></thead>
          <tbody>
            <tr><td rowspan="6"><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ بِالْوَاوِ</span><span class="rule-table-ru">рафъ посредством вау</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">جَاءَ <span class="ar-tone-raf">أَبُوكَ</span>.</span></td><td>Пришёл твой отец.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">أَبُوكَ</span> تَاجِرٌ كَبِيرٌ.</span></td><td>Твой отец — крупный торговец.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجَ <span class="ar-tone-raf">أَبُوهَا</span> الْآنَ.</span></td><td>Её отец вышел сейчас.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">جَاءَ <span class="ar-tone-raf">أَخُوكَ</span>.</span></td><td>Пришёл твой брат.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">أَخُوكَ</span> تَاجِرٌ كَبِيرٌ.</span></td><td>Твой брат — крупный торговец.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجَ <span class="ar-tone-raf">أَخُوهَا</span> الْآنَ.</span></td><td>Её брат вышел сейчас.</td></tr>
            <tr><td rowspan="6"><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ بِالْأَلِفِ</span><span class="rule-table-ru">насб посредством алифа</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">أَبَاكَ</span>.</span></td><td>Я увидел твоего отца.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">إِنَّ <span class="ar-tone-nasb">أَبَاكَ</span> تَاجِرٌ كَبِيرٌ.</span></td><td>Поистине, твой отец — крупный торговец.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا أَعْرِفُ <span class="ar-tone-nasb">أَبَاهَا</span>.</span></td><td>Я знаю её отца.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">أَخَاكَ</span>.</span></td><td>Я увидел твоего брата.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">إِنَّ <span class="ar-tone-nasb">أَخَاكَ</span> تَاجِرٌ كَبِيرٌ.</span></td><td>Поистине, твой брат — крупный торговец.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا أَعْرِفُ <span class="ar-tone-nasb">أَخَاهَا</span>.</span></td><td>Я знаю её брата.</td></tr>
            <tr><td rowspan="6"><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ بِالْيَاءِ</span><span class="rule-table-ru">джарр посредством йа</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بَحَثْتُ عَنْ <span class="ar-tone-jarr">أَبِيكَ</span>.</span></td><td>Я искал твоего отца.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجْتُ مَعَ <span class="ar-tone-jarr">أَبِيكَ</span>.</span></td><td>Я вышел вместе с твоим отцом.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذِهِ الرِّسَالَةُ <span class="ar-tone-jarr">لِأَبِيهَا</span>.</span></td><td>Это письмо для её отца.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">بَحَثْتُ عَنْ <span class="ar-tone-jarr">أَخِيكَ</span>.</span></td><td>Я искал твоего брата.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">خَرَجْتُ مَعَ <span class="ar-tone-jarr">أَخِيكَ</span>.</span></td><td>Я вышел вместе с твоим братом.</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هَذِهِ الرِّسَالَةُ <span class="ar-tone-jarr">لِأَخِيهَا</span>.</span></td><td>Это письмо для её брата.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$إعراب الأسماء الخمسة
الأسماء الخمسة هي: أبو، وأخو، وحمو، وفو، وذو (بمعنى صاحب)، نحو:
دخل أبوك.
رأيت أباك.
سلمت على أبيك.
قاعدة:
الأسماء الخمسة ترفع بالواو وتنصب بالألف وتجر بالياء بشروط.$$,
      59, 59, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الأب، والأخ: اسمان من الأسماء الخمسة التي ترفع بالواو، وتنصب بالألف، وتجر بالياء.
أمثلة:
١- الرفع: جاء أبوك. أبوك تاجر كبير. خرج أبوها الآن. جاء أخوك. أخوك تاجر كبير. خرج أخوها الآن.
٢- النصب: رأيت أباك. إن أباك تاجر كبير. أنا أعرف أباها. رأيت أخاك. إن أخاك تاجر كبير. أنا أعرف أخاها.
٣- الجر: بحثت عن أبيك. خرجت مع أبيك. هذه الرسالة لأبيها. بحثت عن أخيك. خرجت مع أخيك. هذه الرسالة لأخيها.$$,
      47, 47, 2);

  -- 3. Conditions confirmed by the two sharhs, without adding the unsupported diminutive condition.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'شُرُوطُ إِعْرَابِ الْأَسْمَاءِ الْخَمْسَةِ بِالْحُرُوفِ (условия склонения пяти имён буквами)',
    rule_ar = 'تُعْرَبُ الْأَسْمَاءُ الْخَمْسَةُ بِالْوَاوِ وَالْأَلِفِ وَالْيَاءِ بِشَرْطِ أَنْ تَكُونَ مُفْرَدَةً غَيْرَ مُثَنَّاةٍ وَلَا مَجْمُوعَةٍ، وَأَنْ تَكُونَ مُضَافَةً إِلَى غَيْرِ يَاءِ الْمُتَكَلِّمِ. فَإِنْ أُضِيفَتْ إِلَى يَاءِ الْمُتَكَلِّمِ أُعْرِبَتْ بِالْحَرَكَاتِ الْأَصْلِيَّةِ الْمُقَدَّرَةِ، نَحْوُ أَبِي وَأَخِي. وَتُضَافُ إِلَى الضَّمَائِرِ وَإِلَى الْأَسْمَاءِ الظَّاهِرَةِ.',
    summary = 'Особое склонение буквами действует, когда имя стоит в единственном числе и является первым членом идафы не перед йа говорящего. С йа говорящего используются скрытые исходные огласовки. Идафа возможна как с местоимениями, так и с явными именами.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Два подтверждённых условия</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">مُفْرَدَةٌ غَيْرُ مُثَنَّاةٍ وَلَا مَجْمُوعَةٍ</span><span class="rule-term-ru">имя должно быть в единственном числе, не в двойственном и не во множественном.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar" dir="rtl" lang="ar">مُضَافَةٌ إِلَى غَيْرِ يَاءِ الْمُتَكَلِّمِ</span><span class="rule-term-ru">имя должно быть первым членом идафы не перед йа говорящего.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Если добавлена йа говорящего</span>Формы <span class="ar-inline" dir="rtl" lang="ar">أَبِي</span> «мой отец» и <span class="ar-inline" dir="rtl" lang="ar">أَخِي</span> «мой брат» не склоняются буквами как пять имён; их исходные падежные огласовки предполагаются скрытыми.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Присоединение местоимений</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">هَذَا <span class="ar-tone-raf">أَبُوكَ</span>.</span><span class="rule-example-ru">Это твой отец.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">وَذَاكَ <span class="ar-tone-raf">أَخُوكَ</span>.</span><span class="rule-example-ru">А тот — твой брат.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">وَذَلِكَ <span class="ar-tone-raf">حَمُوكَ</span>.</span><span class="rule-example-ru">А тот — твой родственник со стороны супруга или супруги.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">مُحَمَّدٌ <span class="ar-tone-raf">ذُو</span> عِلْمٍ.</span><span class="rule-example-ru">Мухаммад обладает знанием.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar"><span class="ar-tone-raf">فُوكَ</span> نَظِيفٌ.</span><span class="rule-example-ru">Твой рот чист.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Присоединение явного имени</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Падеж</th><th>Арабский пример</th><th>Русский перевод</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ</span><span class="rule-table-ru">рафъ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">جَاءَ <span class="ar-tone-raf">أَبُو بَكْرٍ</span>.</span></td><td>Пришёл Абу Бакр.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ</span><span class="rule-table-ru">насб</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">رَأَيْتُ <span class="ar-tone-nasb">أَبَا بَكْرٍ</span>.</span></td><td>Я увидел Абу Бакра.</td></tr>
            <tr><td><span class="rule-table-ar ar-tone-jarr" dir="rtl" lang="ar">الْجَرُّ</span><span class="rule-table-ru">джарр</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ذَهَبْتُ إِلَى <span class="ar-tone-jarr">أَبِي بَكْرٍ</span>.</span></td><td>Я пошёл к Абу Бакру.</td></tr>
          </tbody>
        </table></div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$قاعدة:
الأسماء الخمسة ترفع بالواو وتنصب بالألف وتجر بالياء بشروط، هي:
١. أن تكون مضافة إلى غير ياء المتكلم، أما إذا كانت مضافة إلى ياء المتكلم فتعرب بحركة الأصلية المقدرة.
٢. أن تكون مفردة غير مثناة ولا مجموعة.
نحو: هذا أبوك، وذاك أخوك، وذلك حموك، ومحمد ذو علم، وفوك نظيف.$$,
      59, 59, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الأسماء الخمسة، هي: أب، أخ، حم، ذو، فو.
تضاف إلى كل الضمائر ما عدا (ياء المتكلم) فإذا قلت (أبي، أخي) فهي حينئذ ليست من الأسماء الخمسة، وتضاف إلى الأسماء أيضا، تقول: جاء أبو بكر، رأيت أبا بكر، ذهبت إلى أبي بكر.$$,
      47, 47, 2);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '25'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 25 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id)
  ) <> 7 then
    raise exception 'Expected 7 Book 2 lesson 25 source rows';
  end if;

  if exists (
    select 1 from public.rules
    where id in (rule_1_id, rule_2_id, rule_3_id)
      and (content::text like '%←%' or content::text like '%→%')
  ) then
    raise exception 'Book 2 lesson 25 contains an RTL-hostile arrow';
  end if;
end
$migration$;

commit;
