-- Verify Medina Book 2 lesson 27 against both supplied Arabic sharhs.
-- Sources:
--   Podrobny_Sharkh_2_tom.pdf, PDF pages 63-64.
--   Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 50-53.

begin;

do $migration$
declare
  lesson_rule_count integer;
  rule_1_id bigint;
  rule_2_id bigint;
  rule_3_id bigint;
  rule_4_id bigint;
  rule_5_id bigint;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '27';

  if lesson_rule_count <> 5 then
    raise exception 'Expected 5 Book 2 lesson 27 rules, found %', lesson_rule_count;
  end if;

  select id into strict rule_1_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '27' and sort_order = 1;
  select id into strict rule_2_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '27' and sort_order = 2;
  select id into strict rule_3_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '27' and sort_order = 3;
  select id into strict rule_4_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '27' and sort_order = 4;
  select id into strict rule_5_id from public.rules where course_name = 'Мединский курс (Том 2)' and lesson_number = '27' and sort_order = 5;

  delete from public.rule_sections where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);
  delete from public.rule_sources where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id);

  -- 1. Definition, two kinds, principal forms, and identification of the weak root.
  update public.rules
  set
    sort_order = 1,
    rule_kind = 'rule',
    title = 'الْفِعْلُ الْأَجْوَفُ وَأَصْلُ حَرْفِ الْعِلَّةِ (полый глагол и происхождение слабой буквы)',
    rule_ar = 'الْفِعْلُ الْمُعْتَلُّ الْعَيْنِ هُوَ مَا كَانَ فِي وَسَطِهِ حَرْفُ عِلَّةٍ، وَيُسَمَّى أَجْوَفَ. فَإِنْ كَانَ أَصْلُ الْأَلِفِ وَاوًا فَهُوَ أَجْوَفُ وَاوِيٌّ، وَإِنْ كَانَ أَصْلُهَا يَاءً فَهُوَ أَجْوَفُ يَائِيٌّ. وَيُعْرَفُ أَصْلُ الْأَلِفِ مِنَ الْمُضَارِعِ أَوِ الْمَصْدَرِ.',
    summary = 'У полого глагола слабая буква занимает середину корня. Исходный و или ي определяется по настоящему времени либо масдару; оба шарха дают согласующийся ряд основных форм.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Определение и два вида</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">الْفِعْلُ الْمُعْتَلُّ الْعَيْنِ</span><span class="rule-term-ru">глагол, у которого вторая коренная буква является буквой слабости.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">الْأَجْوَفُ الْوَاوِيُّ</span><span class="rule-term-ru">полый глагол, в корне которого находится و.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-verb" dir="rtl" lang="ar">الْأَجْوَفُ الْيَائِيُّ</span><span class="rule-term-ru">полый глагол, в корне которого находится ي.</span></div>
        </div>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">قَالَ، بَاعَ، خَافَ.</span><span class="rule-example-ru">Сказал; продал; испугался — примеры полых глаголов второго шарха.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Основные формы из подробного шарха</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Вид</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَاضِي</span><span class="rule-table-ru">прошедшее</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمُضَارِعُ</span><span class="rule-table-ru">настоящее</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْأَمْرُ</span><span class="rule-table-ru">повелительное</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمَصْدَرُ</span><span class="rule-table-ru">масдар</span></th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَجْوَفُ وَاوِيٌّ</span><span class="rule-table-ru">исходный و</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَالَ</span><span class="rule-table-ru">сказал</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَقُولُ</span><span class="rule-table-ru">говорит</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُلْ</span><span class="rule-table-ru">скажи</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَوْلٌ</span><span class="rule-table-ru">речь, говорение</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَجْوَفُ وَاوِيٌّ</span><span class="rule-table-ru">исходный و</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَافَ</span><span class="rule-table-ru">испугался</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَخَافُ</span><span class="rule-table-ru">боится</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَفْ</span><span class="rule-table-ru">бойся</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَوْفٌ</span><span class="rule-table-ru">страх</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَجْوَفُ يَائِيٌّ</span><span class="rule-table-ru">исходный ي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بَاعَ</span><span class="rule-table-ru">продал</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَبِيعُ</span><span class="rule-table-ru">продаёт</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بِعْ</span><span class="rule-table-ru">продай</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بَيْعٌ</span><span class="rule-table-ru">продажа</span></td></tr>
            <tr><td><span class="rule-table-ar ar-tone-verb" dir="rtl" lang="ar">أَجْوَفُ يَائِيٌّ</span><span class="rule-table-ru">исходный ي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَارَ</span><span class="rule-table-ru">шёл</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَسِيرُ</span><span class="rule-table-ru">идёт</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سِرْ</span><span class="rule-table-ru">иди</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">سَيْرٌ</span><span class="rule-table-ru">хождение</span></td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Как определить корень</span><span class="ar-inline" dir="rtl" lang="ar">قَالَ، يَقُولُ، قَوْلٌ</span> и <span class="ar-inline" dir="rtl" lang="ar">خَافَ، يَخَافُ، خَوْفٌ</span> указывают на <span class="ar-inline" dir="rtl" lang="ar">و</span>; <span class="ar-inline" dir="rtl" lang="ar">بَاعَ، يَبِيعُ، بَيْعٌ</span> указывает на <span class="ar-inline" dir="rtl" lang="ar">ي</span>.</div>
      </div>
    </div>$$
  where id = rule_1_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_1_id, 'Podrobny_Sharkh_2_tom.pdf', $$الفعل المعتل العين (الأجوف):
الأجوف الواوي:
قال يقول قل قول.
خاف يخاف خف خوف.
الأجوف اليائي:
باع يبيع بع بيع.
سار يسير سر سير.$$,
      63, 63, 1),
    (rule_1_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الفعل معتل العين: هو الذي في وسطه حرف علة؛ نحو: قال، باع، خاف.
حرف العلة إذا كان في وسط الفعل سمي الفعل أجوف.
قال: الألف أصلها الواو، ويعرف ذلك بالمضارع أو المصدر: قال يقول قول.
باع: الألف أصلها الياء: باع يبيع بيع.
خاف: الألف أصلها الواو: خاف يخاف خوف.$$,
      50, 52, 2);

  -- 2. Past-tense assignment, building signs, weak-letter deletion, and short vowel.
  update public.rules
  set
    sort_order = 2,
    rule_kind = 'rule',
    title = 'إِسْنَادُ الْأَجْوَفِ فِي الْمَاضِي (присоединение местоимений к полому глаголу в прошедшем времени)',
    rule_ar = 'الْفِعْلُ الْمَاضِي مَبْنِيٌّ دَائِمًا؛ فَيُبْنَى عَلَى الْفَتْحِ فِي الْأَصْلِ، وَعَلَى الضَّمِّ مَعَ وَاوِ الْجَمَاعَةِ، وَعَلَى السُّكُونِ مَعَ التَّاءِ الْمُتَحَرِّكَةِ وَنُونِ النِّسْوَةِ وَنَا الْفَاعِلِينَ. وَيُحْذَفُ حَرْفُ الْعِلَّةِ مِنَ الْأَجْوَفِ عِنْدَ إِسْنَادِهِ إِلَى الضَّمَائِرِ الْمُتَحَرِّكَةِ لِلتَّخَلُّصِ مِنِ الْتِقَاءِ السَّاكِنَيْنِ، نَحْوُ: قُلْتُ، وَبِعْتُ، وَخِفْتُ. وَإِذَا كَانَتْ فَاءُ الْفِعْلِ فِي الْمُضَارِعِ مَضْمُومَةً ضُمَّتْ فِي الْمَاضِي الْمُسْنَدِ، وَإِنْ كَانَتْ غَيْرَ مَضْمُومَةٍ كُسِرَتْ.',
    summary = 'Прошедший глагол всегда неизменяем. При подвижном окончании слабая средняя буква удаляется; огласовка первой коренной в краткой форме определяется по настоящему времени.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Признаки построения прошедшего времени</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-fatha" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى الْفَتْحِ</span><span class="rule-term-ru">на фатхе: исходная форма и форма с ت женского рода.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-damma" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى الضَّمِّ</span><span class="rule-term-ru">на дамме: при присоединении وَاوُ الْجَمَاعَةِ.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-sukun" dir="rtl" lang="ar">مَبْنِيٌّ عَلَى السُّكُونِ</span><span class="rule-term-ru">на сукуне: с подвижной ت, نُونُ النِّسْوَةِ и نَا الْفَاعِلِينَ.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">ت в قَالَتْ</span><span class="ar-inline" dir="rtl" lang="ar">التَّاءُ حَرْفُ تَأْنِيثٍ</span> — ت является показателем женского рода, а не местоимением.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений и три модели</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th>Формы из шарха</th><th>Исполнитель и построение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span><span class="rule-table-ru">он</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَالَ، بَاعَ، خَافَ</span></td><td>скрытое <span class="ar-inline" dir="rtl" lang="ar">هُوَ</span>; фатха</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span><span class="rule-table-ru">они, мужской род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَالُوا، بَاعُوا، خَافُوا</span></td><td><span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span>; дамма</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span><span class="rule-table-ru">она</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قَالَتْ، بَاعَتْ، خَافَتْ</span></td><td>скрытое <span class="ar-inline" dir="rtl" lang="ar">هِيَ</span>; ت — показатель рода; фатха</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span><span class="rule-table-ru">они, женский род</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُلْنَ، بِعْنَ، خِفْنَ</span></td><td><span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span>; сукун</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُلْتَ، بِعْتَ، خِفْتَ</span></td><td><span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">التَّاءُ الْمُتَحَرِّكَةُ</span>; сукун</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُلْتُمْ، بِعْتُمْ، خِفْتُمْ</span></td><td><span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">التَّاءُ الْمُتَحَرِّكَةُ</span>; сукун</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُلْتِ، بِعْتِ، خِفْتِ</span></td><td><span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">التَّاءُ الْمُتَحَرِّكَةُ</span>; сукун</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُلْتُنَّ، بِعْتُنَّ، خِفْتُنَّ</span></td><td><span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">التَّاءُ الْمُتَحَرِّكَةُ</span>; сукун</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span><span class="rule-table-ru">я</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُلْتُ، بِعْتُ، خِفْتُ</span></td><td><span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">التَّاءُ الْمُتَحَرِّكَةُ</span>; сукун</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span><span class="rule-table-ru">мы</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُلْنَا، بِعْنَا، خِفْنَا</span></td><td><span class="ar-inline ar-tone-subject" dir="rtl" lang="ar">نَا الْفَاعِلِينَ</span>; сукун</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Дамма или касра после удаления слабой буквы</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">زَارَ، يَزُورُ، زُرْتُ.</span><span class="rule-example-ru">Посетил; посещает; я посетил. В <span class="ar-inline" dir="rtl" lang="ar">يَزُورُ</span> первая коренная имеет дамму, поэтому в <span class="ar-inline" dir="rtl" lang="ar">زُرْتُ</span> остаётся дамма.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">خَافَ، يَخَافُ، خِفْتُ.</span><span class="rule-example-ru">Испугался; боится; я испугался. При фатхе в настоящем времени краткая прошедшая форма имеет касру.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">سَارَ، يَسِيرُ، سِرْتُ.</span><span class="rule-example-ru">Шёл; идёт; я шёл. При касре в настоящем времени краткая прошедшая форма имеет касру.</span></div>
        </div>
        <div class="rule-note"><span class="rule-note-label">Причина удаления</span>В формах <span class="ar-inline" dir="rtl" lang="ar">قُلْتُ، بِعْتُ، خِفْتُ</span> слабая средняя буква удалена для устранения встречи двух сукунов: <span class="ar-inline" dir="rtl" lang="ar">الْتِقَاءُ السَّاكِنَيْنِ</span>.</div>
      </div>
    </div>$$
  where id = rule_2_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_2_id, 'Podrobny_Sharkh_2_tom.pdf', $$تكون فاء الفعل في المضارع مفتوحة، أو مضمومة، أو مكسورة.
خاف (أجوف واوي) يخاف (فاء الفعل مفتوحة).
زار (أجوف واوي) يزور (فاء الفعل مضمومة).
سار (أجوف يائي) يسير (فاء الفعل مكسورة).
زرت: فاء الفعل مضمومة لأن فاء الفعل مضمومة في المضارع (يزور).
خفت: فاء الفعل مكسورة لأن فاء الفعل مفتوحة في المضارع (يخاف).
سرت: فاء الفعل مكسورة لأن فاء الفعل مكسورة في المضارع (يسير).
قاعدة: إذا كانت فاء الفعل في المضارع مضمومة تكون في الماضي مضمومة، وإذا كانت غير مضمومة تكون في الماضي مكسورة.$$,
      63, 63, 1),
    (rule_2_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إسناد الفعل الماضي المعتل العين إلى الضمائر:
قال، قالوا، قالت، قلن، قلت، قلتم، قلت، قلتن، قلت، قلنا.
الفعل الماضي مبني دائما.
قالت: التاء حرف، وهو علامة على التأنيث، وليس ضميرا.
قلت، قلتم، قلتن، قلن، قلنا: مبنية على السكون بسبب اتصالها بالضمائر.
قلت: أصلها قالت، حذفت الألف للتخلص من التقاء الساكنين، وهكذا في بعت وخفت.$$,
      50, 50, 2);

  -- 3. Present-tense assignment in raf and nasb.
  update public.rules
  set
    sort_order = 3,
    rule_kind = 'rule',
    title = 'إِسْنَادُ الْأَجْوَفِ فِي الْمُضَارِعِ: الرَّفْعُ وَالنَّصْبُ (полый глагол в настоящем времени: раф‘ и насб)',
    rule_ar = 'الْفِعْلُ الْمُضَارِعُ مُعْرَبٌ؛ فَيُرْفَعُ بِالضَّمَّةِ وَيُنْصَبُ بِالْفَتْحَةِ، وَتَثْبُتُ النُّونُ فِي الْأَفْعَالِ الْخَمْسَةِ فِي الرَّفْعِ وَتُحْذَفُ فِي النَّصْبِ. أَمَّا الْمُضَارِعُ الْمُتَّصِلُ بِنُونِ النِّسْوَةِ فَهُوَ مَبْنِيٌّ عَلَى السُّكُونِ فِي الرَّفْعِ وَفِي مَحَلِّ نَصْبٍ بَعْدَ «لَنْ».',
    summary = 'Настоящий глагол изменяется по синтаксическому состоянию: дамма в раф‘, фатха после لَنْ, сохранение или удаление ن в пяти глаголах. С نُونُ النِّسْوَةِ форма неизменяема на сукуне.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Признаки раф‘ и насба</span>
        <div class="rule-meaning-grid">
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-raf" dir="rtl" lang="ar">الرَّفْعُ بِالضَّمَّةِ</span><span class="rule-term-ru">раф‘ с даммой у обычной формы настоящего времени.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-nasb" dir="rtl" lang="ar">النَّصْبُ بِالْفَتْحَةِ</span><span class="rule-term-ru">насб с фатхой после <span class="ar-inline" dir="rtl" lang="ar">لَنْ</span>.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-raf" dir="rtl" lang="ar">ثُبُوتُ النُّونِ</span><span class="rule-term-ru">сохранение ن — признак раф‘ пяти глаголов.</span></div>
          <div class="rule-meaning-card"><span class="rule-term-ar ar-tone-nasb" dir="rtl" lang="ar">حَذْفُ النُّونِ</span><span class="rule-term-ru">удаление ن — признак насба пяти глаголов.</span></div>
        </div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений: раф‘ и насб</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمُضَارِعُ الْمَرْفُوعُ</span><span class="rule-table-ru">форма в раф‘</span></th><th><span class="rule-table-ar" dir="rtl" lang="ar">الْمُضَارِعُ الْمَنْصُوبُ</span><span class="rule-table-ru">форма после لَنْ</span></th><th>Признак</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَقُولُ؛ يَبِيعُ؛ يَخَافُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَقُولَ؛ لَنْ يَبِيعَ؛ لَنْ يَخَافَ</span></td><td>дамма; фатха</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَقُولُونَ؛ يَبِيعُونَ؛ يَخَافُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَقُولُوا؛ لَنْ يَبِيعُوا؛ لَنْ يَخَافُوا</span></td><td>сохранение; удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَقُولُ؛ تَبِيعُ؛ تَخَافُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَقُولَ؛ لَنْ تَبِيعَ؛ لَنْ تَخَافَ</span></td><td>дамма; фатха</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">يَقُلْنَ؛ يَبِعْنَ؛ يَخَفْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ يَقُلْنَ؛ لَنْ يَبِعْنَ؛ لَنْ يَخَفْنَ</span></td><td>неизменяемость на сукуне</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَقُولُ؛ تَبِيعُ؛ تَخَافُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَقُولَ؛ لَنْ تَبِيعَ؛ لَنْ تَخَافَ</span></td><td>дамма; фатха</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَقُولُونَ؛ تَبِيعُونَ؛ تَخَافُونَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَقُولُوا؛ لَنْ تَبِيعُوا؛ لَنْ تَخَافُوا</span></td><td>сохранение; удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَقُولِينَ؛ تَبِيعِينَ؛ تَخَافِينَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَقُولِي؛ لَنْ تَبِيعِي؛ لَنْ تَخَافِي</span></td><td>сохранение; удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">تَقُلْنَ؛ تَبِعْنَ؛ تَخَفْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ تَقُلْنَ؛ لَنْ تَبِعْنَ؛ لَنْ تَخَفْنَ</span></td><td>неизменяемость на сукуне</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَقُولُ؛ أَبِيعُ؛ أَخَافُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ أَقُولَ؛ لَنْ أَبِيعَ؛ لَنْ أَخَافَ</span></td><td>дамма; фатха</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">نَقُولُ؛ نَبِيعُ؛ نَخَافُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَنْ نَقُولَ؛ لَنْ نَبِيعَ؛ لَنْ نَخَافَ</span></td><td>дамма; фатха</td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">نُونُ النِّسْوَةِ</span><span class="ar-inline" dir="rtl" lang="ar">يَقُلْنَ</span> в раф‘ — глагол, неизменяемый на сукуне; <span class="ar-inline" dir="rtl" lang="ar">لَنْ يَقُلْنَ</span> — та же неизменяемая форма в синтаксической позиции насба.</div>
      </div>
    </div>$$
  where id = rule_3_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_3_id, 'Podrobny_Sharkh_2_tom.pdf', $$المضارع المرفوع والمضارع المجزوم من الأجوف، نحو: يزور، لم يزر؛ يسير، لم يسر.
تنبيه: حذف حرف العلة للتخلص من التقاء الساكنين.$$,
      64, 64, 1),
    (rule_3_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إسناد الفعل المضارع المعتل العين إلى الضمائر:
المضارع المرفوع علامته الضمة، والمنصوب علامته الفتحة، والمجزوم علامته السكون.
في الأفعال الخمسة ثبوت النون في الرفع، وحذف النون في النصب والجزم.
إذا اتصلت به نون النسوة يكون مبنيا على السكون في الرفع والنصب والجزم.
يقول، لن يقول؛ يبيع، لن يبيع؛ يخاف، لن يخاف، مع جميع ضمائر الغائب والمخاطب والمتكلم.$$,
      51, 52, 2);

  -- 4. Jussive and prohibitive forms, deletion, and nun an-niswah parsing.
  update public.rules
  set
    sort_order = 4,
    rule_kind = 'rule',
    title = 'جَزْمُ الْأَجْوَفِ وَ«لَا» النَّاهِيَةُ (джазм полого глагола и запретительная لَا)',
    rule_ar = 'يُجْزَمُ الْمُضَارِعُ الْأَجْوَفُ بِحَذْفِ حَرْفِ الْعِلَّةِ لِلتَّخَلُّصِ مِنِ الْتِقَاءِ السَّاكِنَيْنِ، نَحْوُ: لَمْ يَقُلْ، وَلَمْ يَبِعْ، وَلَمْ يَخَفْ. وَتَكُونُ عَلَامَةُ الْجَزْمِ حَذْفَ النُّونِ فِي الْأَفْعَالِ الْخَمْسَةِ، وَيَكُونُ الْمُضَارِعُ الْمُتَّصِلُ بِنُونِ النِّسْوَةِ مَبْنِيًّا عَلَى السُّكُونِ فِي مَحَلِّ جَزْمٍ. وَالْجَزْمُ بِـ«لَا» النَّاهِيَةِ كَالْجَزْمِ بِـ«لَمْ».',
    summary = 'В джазме у одиночной формы полого глагола слабая буква удаляется, у пяти глаголов удаляется ن, а форма с نُونُ النِّسْوَةِ остаётся неизменяемой на сукуне. Запретительная لَا использует те же признаки.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Почему удаляется слабая буква</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Исходная форма перед устранением двух сукунов</th><th>Форма джазма</th><th>Что удалено</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَقُولْ</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">لَمْ يَقُلْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْوَاوُ</span><span class="rule-table-ru">буква و</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَبِيعْ</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">لَمْ يَبِعْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْيَاءُ</span><span class="rule-table-ru">буква ي</span></td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَخَافْ</span></td><td><span class="rule-table-ar ar-tone-jazm" dir="rtl" lang="ar">لَمْ يَخَفْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">الْأَلِفُ</span><span class="rule-table-ru">буква ا</span></td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Десять местоимений в джазме</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Местоимение</th><th>Формы после لَمْ</th><th>Признак</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُوَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَقُلْ؛ لَمْ يَبِعْ؛ لَمْ يَخَفْ</span></td><td>удаление слабой буквы</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَقُولُوا؛ لَمْ يَبِيعُوا؛ لَمْ يَخَافُوا</span></td><td>удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هِيَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَقُلْ؛ لَمْ تَبِعْ؛ لَمْ تَخَفْ</span></td><td>удаление слабой буквы</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">هُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ يَقُلْنَ؛ لَمْ يَبِعْنَ؛ لَمْ يَخَفْنَ</span></td><td>неизменяемость на сукуне в позиции джазма</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَقُلْ؛ لَمْ تَبِعْ؛ لَمْ تَخَفْ</span></td><td>удаление слабой буквы</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَقُولُوا؛ لَمْ تَبِيعُوا؛ لَمْ تَخَافُوا</span></td><td>удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَقُولِي؛ لَمْ تَبِيعِي؛ لَمْ تَخَافِي</span></td><td>удаление ن</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ تَقُلْنَ؛ لَمْ تَبِعْنَ؛ لَمْ تَخَفْنَ</span></td><td>неизменяемость на сукуне в позиции джазма</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنَا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ أَقُلْ؛ لَمْ أَبِعْ؛ لَمْ أَخَفْ</span></td><td>удаление слабой буквы</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">نَحْنُ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">لَمْ نَقُلْ؛ لَمْ نَبِعْ؛ لَمْ نَخَفْ</span></td><td>удаление слабой буквы</td></tr>
          </tbody>
        </table></div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Запрет с لَا النَّاهِيَةُ</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا تَقُلْ.</span><span class="rule-example-ru">Не говори.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا تَقُولُوا.</span><span class="rule-example-ru">Не говорите, обращение к мужчинам.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَا تَقُلْنَ.</span><span class="rule-example-ru">Не говорите, обращение к женщинам; глагол неизменяем на сукуне и находится в позиции джазма.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_4_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_4_id, 'Podrobny_Sharkh_2_tom.pdf', $$المضارع المرفوع والمضارع المجزوم:
يزور، لم يزر. يسير، لم يسر.
تنبيه: حذف حرف العلة للتخلص من التقاء الساكنين.$$,
      64, 64, 1),
    (rule_4_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$الجزم بـ(لا) الناهية لا يختلف عن الجزم بـ(لم) في علامات الجزم: لا تقل، لا تقولوا، لا تقلن.
الفعل المضارع معرب؛ أي تتغير حركة آخره: الضمة في الرفع، والفتحة في النصب، والسكون في الجزم، إلا إذا اتصلت به نون النسوة يكون مبنيا على السكون.
يقلن: مبني على السكون في محل نصب. لم يقلن، لا تقلن: مبني على السكون في محل جزم.
لم يقل: الأصل (لم يقول)، حذفت الواو للتخلص من التقاء الساكنين.
لم يبع: الأصل (لم يبيع)، حذفت الياء للتخلص من التقاء الساكنين.
لم يخف: الأصل (لم يخاف)، حذفت الألف للتخلص من التقاء الساكنين.$$,
      52, 52, 2);

  -- 5. Imperative derivation and assignment.
  update public.rules
  set
    sort_order = 5,
    rule_kind = 'rule',
    title = 'صِيَاغَةُ أَمْرِ الْأَجْوَفِ وَإِسْنَادُهُ (образование и присоединение форм повелительного полого глагола)',
    rule_ar = 'فِعْلُ الْأَمْرِ مَبْنِيٌّ دَائِمًا، وَيُصَاغُ مِنَ الْمُضَارِعِ بِحَذْفِ حَرْفِ الْمُضَارَعَةِ وَبِنَاءِ آخِرِهِ عَلَى السُّكُونِ، ثُمَّ يُحْذَفُ حَرْفُ الْعِلَّةِ إِذَا الْتَقَى سَاكِنَانِ، نَحْوُ: زُرْ، وَقُلْ، وَبِعْ، وَخَفْ. وَيُبْنَى عَلَى حَذْفِ النُّونِ مَعَ وَاوِ الْجَمَاعَةِ وَيَاءِ الْمُخَاطَبَةِ، وَعَلَى السُّكُونِ مَعَ نُونِ النِّسْوَةِ. وَلَا يُحْذَفُ حَرْفُ الْعِلَّةِ فِي نَحْوِ زُورُوا وَزُورِي لِعَدَمِ الْتِقَاءِ السَّاكِنَيْنِ.',
    summary = 'Повелительное образуется от настоящего: удаляется префикс настоящего времени, конец ставится на сукун, а при встрече двух сукунов удаляется слабая буква. С وَاوُ الْجَمَاعَةِ и يَاءُ الْمُخَاطَبَةِ форма строится на удалении ن.',
    content = $$<div class="rule-study">
      <div class="rule-study-card">
        <span class="rule-card-kicker">Как получить زُرْ из تَزُورُ</span>
        <ol class="rule-step-list">
          <li><span class="rule-step-ar" dir="rtl" lang="ar">تَزُورُ</span><span class="rule-step-ru">Берём форму настоящего времени «ты посещаешь».</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">زُورُ</span><span class="rule-step-ru">Удаляем букву настоящего времени ت.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">زُورْ</span><span class="rule-step-ru">Ставим последнюю букву на сукун.</span></li>
          <li><span class="rule-step-ar" dir="rtl" lang="ar">زُرْ</span><span class="rule-step-ru">Удаляем و из-за встречи двух сукунов.</span></li>
        </ol>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Формы для четырёх обращений</span>
        <div class="tbl-wrap"><table>
          <thead><tr><th>Обращение</th><th>Говорить</th><th>Продавать</th><th>Бояться</th><th>Посещать</th><th>Построение</th></tr></thead>
          <tbody>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتَ</span><span class="rule-table-ru">ты, мужчина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُلْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بِعْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَفْ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">زُرْ</span></td><td>на сукуне; слабая буква удалена</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُمْ</span><span class="rule-table-ru">вы, мужчины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُولُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بِيعُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَافُوا</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">زُورُوا</span></td><td>на удалении ن; слабая буква сохранена</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتِ</span><span class="rule-table-ru">ты, женщина</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُولِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بِيعِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَافِي</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">زُورِي</span></td><td>на удалении ن; слабая буква сохранена</td></tr>
            <tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَنْتُنَّ</span><span class="rule-table-ru">вы, женщины</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">قُلْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">بِعْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">خَفْنَ</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">زُرْنَ</span></td><td>на сукуне с نُونُ النِّسْوَةِ</td></tr>
          </tbody>
        </table></div>
        <div class="rule-note"><span class="rule-note-label">Исходные формы перед удалением</span><span class="ar-inline" dir="rtl" lang="ar">قُلْ</span> происходит из <span class="ar-inline" dir="rtl" lang="ar">قُولْ</span>; <span class="ar-inline" dir="rtl" lang="ar">بِعْ</span> — из <span class="ar-inline" dir="rtl" lang="ar">بِيعْ</span>; <span class="ar-inline" dir="rtl" lang="ar">خَفْ</span> — из <span class="ar-inline" dir="rtl" lang="ar">خَافْ</span>.</div>
      </div>
      <div class="rule-study-card">
        <span class="rule-card-kicker">Обращения из подробного шарха</span>
        <div class="rule-example-list">
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَحْمَدُ، زُرْ.</span><span class="rule-example-ru">Ахмад, посети.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا فَاطِمَةُ، زُورِي.</span><span class="rule-example-ru">Фатима, посети.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا أَوْلَادُ، زُورُوا.</span><span class="rule-example-ru">Мальчики, посетите.</span></div>
          <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَا بَنَاتُ، زُرْنَ.</span><span class="rule-example-ru">Девочки, посетите.</span></div>
        </div>
      </div>
    </div>$$
  where id = rule_5_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (rule_5_id, 'Podrobny_Sharkh_2_tom.pdf', $$كيف يصاغ فعل الأمر من الفعل الأجوف؟
1. نأتي بالفعل المضارع: تزور.
2. نحذف حرف المضارعة: زور.
3. نبني آخر الفعل على السكون: زور.
4. نحذف حرف العلة لالتقاء الساكنين: زر.
نقول في الأمر: يا أحمد زر، يا فاطمة زوري، يا أولاد زوروا، يا بنات زرن.
في زوروا لا نحذف حرف العلة لعدم التقاء الساكنين، وكذلك في زوري.$$,
      64, 64, 1),
    (rule_5_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $$إسناد فعل الأمر معتل العين إلى الضمائر:
قل، قولوا، قولي، قلن.
بع، بيعوا، بيعي، بعن.
خف، خافوا، خافي، خفن.
فعل الأمر مبني دائما.
قل: أصله (قول)، حذفت الواو للتخلص من التقاء الساكنين.
بع: أصله (بيع)، حذفت الياء للتخلص من التقاء الساكنين.
خف: أصله (خاف)، حذفت الألف للتخلص من التقاء الساكنين.
قولي، قولوا: علامة البناء حذف النون؛ لأن الأمر يصاغ من المضارع: تقولين، يقولون؛ حذف حرفا المضارعة وحذفت النون.$$,
      53, 53, 2);

  if exists (
    select 1 from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '27'
      and (nullif(btrim(rule_ar), '') is null or nullif(btrim(content), '') is null)
  ) then
    raise exception 'Book 2 lesson 27 contains an empty rule_ar or content after migration';
  end if;

  if (
    select count(*) from public.rule_sources
    where rule_id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id)
  ) <> 10 then
    raise exception 'Expected 10 Book 2 lesson 27 source rows';
  end if;

  if exists (
    select 1 from public.rules
    where id in (rule_1_id, rule_2_id, rule_3_id, rule_4_id, rule_5_id)
      and (content::text like '%←%' or content::text like '%→%')
  ) then
    raise exception 'Book 2 lesson 27 contains an RTL-hostile arrow';
  end if;
end
$migration$;

commit;
