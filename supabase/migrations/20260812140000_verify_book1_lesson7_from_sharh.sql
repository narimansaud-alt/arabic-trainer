-- Verify Medina Book 1 lesson 7 against the complete Arabic sharh lesson.
-- Source: Sharkh_na_1_tom_Med_kursa.pdf, PDF page 11.

begin;

do $migration$
declare
  target_rule_id bigint;
begin
  delete from public.rule_sections
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '7'
  );

  delete from public.rule_sources
  where rule_id in (
    select id from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and lesson_number = '7'
  );

  select id into strict target_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and lesson_number = '7'
    and sort_order = 1;

  update public.rules
  set
    title = 'تِلْكَ وَأَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ وَالْبَعِيدِ (та и указательные имена)',
    rule_ar = 'تِلْكَ اِسْمُ إِشَارَةٍ لِلْمُفْرَدَةِ الْمُؤَنَّثَةِ الْبَعِيدَةِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    summary = 'تِلْكَ اِسْمُ إِشَارَةٍ لِلْمُفْرَدَةِ الْمُؤَنَّثَةِ الْبَعِيدَةِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.',
    rule_kind = 'table',
    content = $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Правило</span><span class="rule-main-ar" dir="rtl" lang="ar">تِلْكَ اِسْمُ إِشَارَةٍ لِلْمُفْرَدَةِ الْمُؤَنَّثَةِ الْبَعِيدَةِ، لِلْعَاقِلِ وَغَيْرِ الْعَاقِلِ.</span><p class="rule-study-text"><span dir="rtl" lang="ar">تِلْكَ</span> — указательное имя «та». Оно указывает на одно далёкое лицо или один далёкий предмет женского рода.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Разумное и неразумное</span><div class="rule-example-list"><div class="rule-example-card rule-term-subject"><span class="rule-example-ar" dir="rtl" lang="ar">تِلْكَ سُمَيَّةُ. تِلْكَ طَبِيبَةٌ. تِلْكَ طَوِيلَةٌ.</span><span class="rule-example-ru">Та — Сумайя. Та — врач. Та — высокая.</span></div><div class="rule-example-card rule-term-default"><span class="rule-example-ar" dir="rtl" lang="ar">تِلْكَ بَطَّةٌ. تِلْكَ بَيْضَةٌ. تِلْكَ نَاقَةٌ.</span><span class="rule-example-ru">То — утка. То — яйцо. То — верблюдица.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Таблица указательных имён</span><table><thead><tr><th>Род</th><th>Близко</th><th>Далеко</th></tr></thead><tbody><tr><th>Мужской</th><td><span dir="rtl" lang="ar">هٰذَا حُسَيْنٌ. هٰذَا قَمِيصٌ.</span><br>Это Хусейн. Это рубашка.</td><td><span dir="rtl" lang="ar">ذٰلِكَ مُؤَذِّنٌ. ذٰلِكَ حَجَرٌ.</span><br>То — муэдзин. То — камень.</td></tr><tr><th>Женский</th><td><span dir="rtl" lang="ar">هٰذِهِ رُقَيَّةُ. هٰذِهِ حَدِيقَةٌ.</span><br>Это Рукайя. Это сад.</td><td><span dir="rtl" lang="ar">تِلْكَ مُمَرِّضَةٌ. تِلْكَ دَجَاجَةٌ.</span><br>Та — медсестра. То — курица.</td></tr></tbody></table></div></div>$$
  where id = target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$تِلْكَ : اِسْمُ إِشَارَةٍ لِلْمُفْرَدِ الْمُؤَنَّثِ الْبَعِيدِ الْعَاقِلِ، وَغَيْرِ الْعَاقِلِ .

الْعَاقِلُ
تِلْكَ سُمَيَّةُ
تِلْكَ طَبِيبَةٌ
تِلْكَ طَوِيلَةٌ

غَيْرُ الْعَاقِلِ
تِلْكَ بَطَّةٌ
تِلْكَ بَيْضَةٌ
تِلْكَ نَاقَةٌ$$,
      11,
      11,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$أَسْمَاءُ الْإِشَارَةِ لِلْقَرِيبِ | أَسْمَاءُ الْإِشَارَةِ لِلْبَعِيدِ
الْمُذَكَّرُ : هَذَا حُسَيْنٌ . هَذَا قَمِيصٌ | ذَلِكَ مُؤَذِّنٌ . ذَلِكَ حَجَرٌ
الْمُؤَنَّثُ : هَذِهِ رُقَيَّةُ . هَذِهِ حَدِيقَةٌ | تِلْكَ مُمَرِّضَةٌ . تِلْكَ دَجَاجَةٌ$$,
      11,
      11,
      2
    );

  insert into public.rules
    (course_name, lesson_number, title, content, sort_order, rule_kind, summary, rule_ar)
  values (
    'Мединский курс (Том 1)',
    '7',
    'مُرَاجَعَةُ هَمْزَةِ الِاسْتِفْهَامِ (повторение вопросительной хамзы)',
    $$<div class="rule-study"><div class="rule-study-card"><span class="rule-card-kicker">Напоминание из шарха</span><span class="rule-main-ar" dir="rtl" lang="ar">هَمْزَةُ الِاسْتِفْهَامِ أَ جَوَابُهَا نَعَمْ أَوْ لَا.</span><p class="rule-study-text">На общий вопрос с <span dir="rtl" lang="ar">أَ</span> отвечают <span dir="rtl" lang="ar">نَعَمْ</span> или <span dir="rtl" lang="ar">لَا</span>.</p></div><div class="rule-study-card"><span class="rule-card-kicker">Пример из шарха</span><div class="rule-example-list"><div class="rule-example-card rule-term-particle"><span class="rule-example-ar" dir="rtl" lang="ar">أَسَاعَةُ عَبَّاسٍ هٰذِهِ؟ لَا. هٰذِهِ سَاعَةُ حَامِدٍ، تِلْكَ سَاعَةُ عَبَّاسٍ.</span><span class="rule-example-ru">Это часы Аббаса? Нет. Это часы Хамида, а те — часы Аббаса.</span></div></div></div><div class="rule-study-card"><span class="rule-card-kicker">Связи слов</span><div class="rule-meaning-grid"><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">هٰذِهِ</span><span class="rule-term-ru">указательное имя для близкого неразумного женского рода: سَاعَةٌ</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">حَامِدٍ</span><span class="rule-term-ru">مُضَافٌ إِلَيْهِ — второй член идафы</span></div><div class="rule-meaning-card rule-term-default"><span class="rule-term-ar" dir="rtl" lang="ar">تِلْكَ</span><span class="rule-term-ru">указательное имя для далёкого неразумного женского рода: سَاعَةٌ</span></div><div class="rule-meaning-card rule-term-structure"><span class="rule-term-ar" dir="rtl" lang="ar">عَبَّاسٍ</span><span class="rule-term-ru">مُضَافٌ إِلَيْهِ — второй член идафы</span></div></div></div></div>$$,
    2,
    'note',
    'هَمْزَةُ الِاسْتِفْهَامِ أَ جَوَابُهَا نَعَمْ أَوْ لَا.',
    'هَمْزَةُ الِاسْتِفْهَامِ أَ جَوَابُهَا نَعَمْ أَوْ لَا.'
  )
  returning id into target_rule_id;

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$أَسَاعَةُ عَبَّاسٍ هَذِهِ؟ لَا . هَذِهِ سَاعَةُ حَامِدٍ، تِلْكَ سَاعَةُ عَبَّاسٍ .

فِي هَذَا الْمِثَالِ : هَمْزَةُ الِاسْتِفْهَامِ ( أَ ) الْجَوَابُ بِـ : نَعَمْ، أَوْ لَا .$$,
      11,
      11,
      1
    ),
    (
      target_rule_id,
      'Sharkh_na_1_tom_Med_kursa.pdf',
      $$هَذِهِ : اِسْمُ إِشَارَةٍ لِلْمُؤَنَّثِ الْقَرِيبِ غَيْرِ الْعَاقِلِ ( سَاعَةٌ ) . حَامِدٍ : مُضَافٌ إِلَيْهِ .
تِلْكَ : اِسْمُ إِشَارَةٍ لِلْمُؤَنَّثِ الْبَعِيدِ غَيْرِ الْعَاقِلِ ( سَاعَةٌ ) . عَبَّاسٍ : مُضَافٌ إِلَيْهِ .$$,
      11,
      11,
      2
    );
end;
$migration$;

commit;
