-- Certify and complete the Russian rendering of Medina Book 2, lessons 26-30.
-- Primary source: Podrobny_Sharkh_2_tom.pdf, PDF pages 60-74.
-- Supplementary source: Sharkh_na_2_tom_Med_kursa.pdf, PDF pages 48-61.
-- The full sharh controls every overlapping explanation. The supplementary
-- sharh supplies additional examples and the two lesson-26 topics absent from
-- the full source.

begin;

create temp table _book2_full_sharh_batch06 (
  rule_id bigint primary key,
  lesson_number text not null,
  source_label text not null
) on commit drop;

insert into _book2_full_sharh_batch06 values
  (1349, '26', 'Полный шарх: с. 60 · Дополнительный шарх: с. 48'),
  (1350, '26', 'Полный шарх: с. 61 · Дополнительный шарх: с. 48'),
  (1351, '26', 'Полный шарх: с. 62 · Дополнительный шарх: с. 48'),
  (1352, '26', 'Полный шарх: с. 62 · Дополнительный шарх: с. 49'),
  (1353, '26', 'Полный шарх: с. 62 · Дополнительный шарх: с. 49'),
  (1901, '26', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 49'),
  (1902, '26', 'Полный шарх: нет отдельного раздела · Дополнительный шарх: с. 49'),
  (1354, '27', 'Полный шарх: с. 63 · Дополнительный шарх: с. 50–52'),
  (1355, '27', 'Полный шарх: с. 63 · Дополнительный шарх: с. 50'),
  (1356, '27', 'Полный шарх: с. 64 · Дополнительный шарх: с. 51–52'),
  (1357, '27', 'Полный шарх: с. 64 · Дополнительный шарх: с. 52'),
  (1358, '27', 'Полный шарх: с. 64 · Дополнительный шарх: с. 53'),
  (1359, '28', 'Полный шарх: с. 65 · Дополнительный шарх: с. 54'),
  (1360, '28', 'Полный шарх: с. 66 · Дополнительный шарх: с. 54–55'),
  (1361, '28', 'Полный шарх: с. 67–68 · Дополнительный шарх: с. 55–57'),
  (1362, '28', 'Полный шарх: с. 68 · Дополнительный шарх: с. 57'),
  (1903, '28', 'Полный шарх: с. 69 · Дополнительный шарх: нет отдельного раздела'),
  (1363, '29', 'Полный шарх: с. 70 · Дополнительный шарх: с. 58'),
  (1364, '29', 'Полный шарх: с. 70 · Дополнительный шарх: с. 58'),
  (1365, '29', 'Полный шарх: с. 71 · Дополнительный шарх: с. 59'),
  (1366, '29', 'Полный шарх: с. 72 · Дополнительный шарх: с. 60'),
  (1367, '29', 'Полный шарх: с. 72 · Дополнительный шарх: с. 60'),
  (1904, '29', 'Полный шарх: с. 72 · Дополнительный шарх: с. 60'),
  (1368, '30', 'Полный шарх: с. 73 · Дополнительный шарх: с. 61'),
  (1369, '30', 'Полный шарх: с. 73 · Дополнительный шарх: с. 61'),
  (1905, '30', 'Полный шарх: с. 74 · Дополнительный шарх: с. 61'),
  (1906, '30', 'Полный шарх: с. 74 · Дополнительный шарх: с. 61');

do $guard$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch06 b on b.rule_id = r.id
  where r.course_name = 'Мединский курс (Том 2)' and r.lesson_number = b.lesson_number;
  if v_count <> 27 then raise exception 'Expected 27 guarded Book 2 rules for lessons 26-30, found %', v_count; end if;

  select count(*) into v_count from public.rules where course_name = 'Мединский курс (Том 2)';
  if v_count <> 148 then raise exception 'Book 2 must retain 148 public rules, found %', v_count; end if;

  select count(*) into v_count
  from public.rule_sources rs join public.rules r on r.id = rs.rule_id
  where r.course_name = 'Мединский курс (Том 2)';
  if v_count <> 291 then raise exception 'Book 2 must retain 291 source rows, found %', v_count; end if;
end;
$guard$;

-- Lesson 26: the complete short-sharh section on يَجِبُ is authoritative here
-- because the full sharh has no separate section for this topic.
update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l26-yajibu-short-source-complete">
  <span class="rule-card-kicker">Все примеры единственного источника темы</span>
  <p class="rule-study-text">В полном шархе отдельного раздела о <span dir="rtl" lang="ar">يَجِبُ</span> нет, поэтому здесь полностью сохранены примеры дополнительного шарха.</p>
  <div class="rule-example-list">
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَجِبُ عَلَيْكِ أَنْ تَحْفَظِي الْقُرْآنَ.</span><span class="rule-example-ru">Тебе необходимо выучить Коран, обращение к женщине.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَجِبُ عَلَيْكُمْ أَنْ تَخْرُجُوا.</span><span class="rule-example-ru">Вам необходимо выйти, обращение к мужчинам.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">يَجِبُ عَلَيْكَ أَنْ تَدْرُسَ جَيِّدًا.</span><span class="rule-example-ru">Тебе необходимо хорошо учиться.</span></div>
  </div>
</div>
</div>$html$)
where id = 1902 and course_name = 'Мединский курс (Том 2)' and lesson_number = '26'
  and strpos(content, 'book2-l26-yajibu-short-source-complete') = 0;

-- Lesson 28: restore the exact three paradigms printed in the full sharh.
-- The existing public tables based on the supplementary examples remain as
-- useful extra practice; they no longer replace the primary-source tables.
update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l28-full-past-paradigms">
  <span class="rule-card-kicker">Полная таблица полного шарха: прошедшее время</span>
  <span class="rule-main-ar" dir="rtl" lang="ar">إِسْنَادُ الْفِعْلِ الْمَاضِي إِلَى الضَّمَائِرِ الْعَشَرَةِ: دَعَا، بَكَى، بَقِيَ</span>
  <p class="rule-study-text">Полный шарх приводит именно три глагола: конечнослабый с исходным <span dir="rtl" lang="ar">و</span>, глагол с алифом от <span dir="rtl" lang="ar">ي</span> и глагол с явной конечной <span dir="rtl" lang="ar">ي</span>. Ни одна из его форм не заменяется примерами второго источника.</p>
  <div class="tbl-wrap"><table><thead><tr><th>Местоимение</th><th dir="rtl" lang="ar">دَعَا</th><th dir="rtl" lang="ar">بَكَى</th><th dir="rtl" lang="ar">بَقِيَ</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">أَنَا</td><td dir="rtl" lang="ar">دَعَوْتُ</td><td dir="rtl" lang="ar">بَكَيْتُ</td><td dir="rtl" lang="ar">بَقِيتُ</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتَ</td><td dir="rtl" lang="ar">دَعَوْتَ</td><td dir="rtl" lang="ar">بَكَيْتَ</td><td dir="rtl" lang="ar">بَقِيتَ</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتِ</td><td dir="rtl" lang="ar">دَعَوْتِ</td><td dir="rtl" lang="ar">بَكَيْتِ</td><td dir="rtl" lang="ar">بَقِيتِ</td></tr>
    <tr><td dir="rtl" lang="ar">هُوَ</td><td dir="rtl" lang="ar">دَعَا</td><td dir="rtl" lang="ar">بَكَى</td><td dir="rtl" lang="ar">بَقِيَ</td></tr>
    <tr><td dir="rtl" lang="ar">هِيَ</td><td dir="rtl" lang="ar">دَعَتْ</td><td dir="rtl" lang="ar">بَكَتْ</td><td dir="rtl" lang="ar">بَقِيَتْ</td></tr>
    <tr><td dir="rtl" lang="ar">نَحْنُ</td><td dir="rtl" lang="ar">دَعَوْنَا</td><td dir="rtl" lang="ar">بَكَيْنَا</td><td dir="rtl" lang="ar">بَقِينَا</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتُمْ</td><td dir="rtl" lang="ar">دَعَوْتُمْ</td><td dir="rtl" lang="ar">بَكَيْتُمْ</td><td dir="rtl" lang="ar">بَقِيتُمْ</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتُنَّ</td><td dir="rtl" lang="ar">دَعَوْتُنَّ</td><td dir="rtl" lang="ar">بَكَيْتُنَّ</td><td dir="rtl" lang="ar">بَقِيتُنَّ</td></tr>
    <tr><td dir="rtl" lang="ar">هُمْ</td><td dir="rtl" lang="ar">دَعَوْا</td><td dir="rtl" lang="ar">بَكَوْا</td><td dir="rtl" lang="ar">بَقُوا</td></tr>
    <tr><td dir="rtl" lang="ar">هُنَّ</td><td dir="rtl" lang="ar">دَعَوْنَ</td><td dir="rtl" lang="ar">بَكَيْنَ</td><td dir="rtl" lang="ar">بَقِينَ</td></tr>
  </tbody></table></div>
  <p class="rule-study-text"><strong>Замечания полного шарха:</strong> при присоединении местоимений раскрывается исходная слабая буква; слабая буква удаляется при встрече двух сукунов, кроме глагола с явной конечной <span dir="rtl" lang="ar">ي</span>, как <span dir="rtl" lang="ar">بَقِيَ</span>. При образовании форм учитываются удаление последней коренной, фатха перед алифом и дамма перед <span dir="rtl" lang="ar">و</span>.</p>
</div>
</div>$html$)
where id = 1360 and course_name = 'Мединский курс (Том 2)' and lesson_number = '28'
  and strpos(content, 'book2-l28-full-past-paradigms') = 0;

update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l28-full-present-paradigms">
  <span class="rule-card-kicker">Полная таблица полного шарха: настоящее время</span>
  <span class="rule-main-ar" dir="rtl" lang="ar">إِسْنَادُ الْفِعْلِ الْمُضَارِعِ إِلَى الضَّمَائِرِ الْعَشَرَةِ: يَدْعُو، يَبْكِي، يَبْقَى</span>
  <div class="tbl-wrap"><table><thead><tr><th>Местоимение</th><th dir="rtl" lang="ar">يَدْعُو</th><th dir="rtl" lang="ar">يَبْكِي</th><th dir="rtl" lang="ar">يَبْقَى</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">أَنَا</td><td dir="rtl" lang="ar">أَدْعُو</td><td dir="rtl" lang="ar">أَبْكِي</td><td dir="rtl" lang="ar">أَبْقَى</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتَ</td><td dir="rtl" lang="ar">تَدْعُو</td><td dir="rtl" lang="ar">تَبْكِي</td><td dir="rtl" lang="ar">تَبْقَى</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتِ</td><td dir="rtl" lang="ar">تَدْعِينَ</td><td dir="rtl" lang="ar">تَبْكِينَ</td><td dir="rtl" lang="ar">تَبْقِينَ</td></tr>
    <tr><td dir="rtl" lang="ar">هُوَ</td><td dir="rtl" lang="ar">يَدْعُو</td><td dir="rtl" lang="ar">يَبْكِي</td><td dir="rtl" lang="ar">يَبْقَى</td></tr>
    <tr><td dir="rtl" lang="ar">هِيَ</td><td dir="rtl" lang="ar">تَدْعُو</td><td dir="rtl" lang="ar">تَبْكِي</td><td dir="rtl" lang="ar">تَبْقَى</td></tr>
    <tr><td dir="rtl" lang="ar">نَحْنُ</td><td dir="rtl" lang="ar">نَدْعُو</td><td dir="rtl" lang="ar">نَبْكِي</td><td dir="rtl" lang="ar">نَبْقَى</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتُمْ</td><td dir="rtl" lang="ar">تَدْعُونَ</td><td dir="rtl" lang="ar">تَبْكُونَ</td><td dir="rtl" lang="ar">تَبْقَوْنَ</td></tr>
    <tr><td dir="rtl" lang="ar">أَنْتُنَّ</td><td dir="rtl" lang="ar">تَدْعُونَ</td><td dir="rtl" lang="ar">تَبْكِينَ</td><td dir="rtl" lang="ar">تَبْقِينَ</td></tr>
    <tr><td dir="rtl" lang="ar">هُمْ</td><td dir="rtl" lang="ar">يَدْعُونَ</td><td dir="rtl" lang="ar">يَبْكُونَ</td><td dir="rtl" lang="ar">يَبْقَوْنَ</td></tr>
    <tr><td dir="rtl" lang="ar">هُنَّ</td><td dir="rtl" lang="ar">يَدْعُونَ</td><td dir="rtl" lang="ar">يَبْكِينَ</td><td dir="rtl" lang="ar">يَبْقِينَ</td></tr>
  </tbody></table></div>
  <p class="rule-study-text">Полный шарх отдельно обращает внимание на внешне совпадающие формы с <span dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span> и <span dir="rtl" lang="ar">نُونُ النِّسْوَةِ</span>, а также на совпадение форм <span dir="rtl" lang="ar">تَبْقِينَ</span> при разных местоимениях.</p>
</div>
<div class="rule-study-card book2-l28-full-irab-table">
  <span class="rule-card-kicker">Три состояния — примеры полного шарха</span>
  <div class="tbl-wrap"><table><thead><tr><th>Раф‘</th><th>Насб</th><th>Джазм</th><th>Показатель</th></tr></thead><tbody>
    <tr><td dir="rtl" lang="ar">يَبْقَى</td><td dir="rtl" lang="ar">لَنْ يَبْقَى</td><td dir="rtl" lang="ar">لَمْ يَبْقَ</td><td>Скрытая дамма; скрытая фатха; удаление слабой буквы.</td></tr>
    <tr><td dir="rtl" lang="ar">يَدْعُو</td><td dir="rtl" lang="ar">لَنْ يَدْعُوَ</td><td dir="rtl" lang="ar">لَمْ يَدْعُ</td><td>Скрытая дамма; явная фатха; удаление слабой буквы.</td></tr>
    <tr><td dir="rtl" lang="ar">يَبْكِي</td><td dir="rtl" lang="ar">لَنْ يَبْكِيَ</td><td dir="rtl" lang="ar">لَمْ يَبْكِ</td><td>Скрытая дамма; явная фатха; удаление слабой буквы.</td></tr>
  </tbody></table></div>
</div>
</div>$html$)
where id = 1361 and course_name = 'Мединский курс (Том 2)' and lesson_number = '28'
  and strpos(content, 'book2-l28-full-present-paradigms') = 0;

-- Lesson 29: the two sources use different analyses for حُجُّوا and حُجِّي.
-- Keep both formulations visible, but make the full sharh primary as required.
update public.rules
set rule_ar = $rule$
يُصَاغُ أَمْرُ الْمُضَعَّفِ مِنَ الْمُضَارِعِ بِحَذْفِ حَرْفِ الْمُضَارَعَةِ. فَيُبْنَى الْمُفْرَدُ الْمُذَكَّرُ عَلَى سُكُونٍ مُقَدَّرٍ فِي صُورَةِ الْإِدْغَامِ، وَيُحَرَّكُ بِالْفَتْحِ لِلتَّخَلُّصِ مِنِ الْتِقَاءِ السَّاكِنَيْنِ، وَيَجُوزُ فِيهِ الْفَكُّ مَعَ سُكُونٍ ظَاهِرٍ. وَيَنْصُّ الشَّرْحُ الْكَامِلُ عَلَى أَنَّ «حُجُّوا» مَبْنِيٌّ عَلَى الضَّمِّ لِاتِّصَالِ وَاوِ الْجَمَاعَةِ، وَأَنَّ «حُجِّي» مَبْنِيٌّ عَلَى الْكَسْرِ لِاتِّصَالِ يَاءِ الْمُخَاطَبَةِ، وَيَجِبُ فَكُّ الْإِدْغَامِ مَعَ نُونِ النِّسْوَةِ. وَيَذْكُرُ الشَّرْحُ الْإِضَافِيُّ فِي تَحْلِيلِ صِيغَتَيِ الْجَمْعِ وَالْمُخَاطَبَةِ حَذْفَ النُّونِ لِأَصْلِهِمَا مِنَ الْأَفْعَالِ الْخَمْسَةِ.
$rule$
where id = 1366 and course_name = 'Мединский курс (Том 2)' and lesson_number = '29';

update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l29-full-source-priority">
  <span class="rule-card-kicker">Различие источников — приоритет полного шарха</span>
  <p class="rule-study-text"><strong>Полный шарх, с. 72:</strong> <span dir="rtl" lang="ar">حُجَّ</span> построен на предполагаемом сукуне и получил фатху для устранения встречи двух сукунов; <span dir="rtl" lang="ar">حُجُّوا</span> назван построенным на дамме из-за присоединения <span dir="rtl" lang="ar">وَاوُ الْجَمَاعَةِ</span>; <span dir="rtl" lang="ar">حُجِّي</span> назван построенным на касре из-за присоединения <span dir="rtl" lang="ar">يَاءُ الْمُخَاطَبَةِ</span>. Эта формулировка является основной в карточке.</p>
  <p class="rule-study-text"><strong>Дополнительный шарх, с. 60:</strong> для соответствующих форм <span dir="rtl" lang="ar">عُدُّوا</span> и <span dir="rtl" lang="ar">عُدِّي</span> указывает построение на удалении нуна, поскольку повелительное образовано от форм пяти глаголов. Формулировка сохранена как отдельное дополнительное пояснение и не заменяет полный шарх.</p>
</div>
</div>$html$)
where id = 1366 and course_name = 'Мединский курс (Том 2)' and lesson_number = '29'
  and strpos(content, 'book2-l29-full-source-priority') = 0;

update public.rules
set content = regexp_replace(content, '</div>[[:space:]]*$', $html$
<div class="rule-study-card book2-l29-qattu-extra-examples">
  <span class="rule-card-kicker">Дополнительные примеры второго шарха</span>
  <div class="rule-example-list">
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَنْ أَتْرُكَ الصَّلَاةَ أَبَدًا.</span><span class="rule-example-ru">Я никогда не оставлю молитву.</span></div>
    <div class="rule-example-card"><span class="rule-example-ar" dir="rtl" lang="ar">لَمْ أَشْرَبِ الْخَمْرَ قَطُّ، وَلَنْ أَشْرَبَهَا أَبَدًا.</span><span class="rule-example-ru">Я никогда не пил вино и никогда не буду его пить.</span></div>
  </div>
</div>
</div>$html$)
where id = 1367 and course_name = 'Мединский курс (Том 2)' and lesson_number = '29'
  and strpos(content, 'book2-l29-qattu-extra-examples') = 0;

-- Mark every audited card only after all source-priority corrections succeed.
update public.rules r
set content = regexp_replace(
  r.content, '</div>[[:space:]]*$',
  '<div class="rule-study-card book2-full-sharh-batch06"><span class="rule-card-kicker">Сверка с шархом завершена</span><p class="rule-study-text"><strong>Источники:</strong> ' || b.source_label || '.</p></div></div>'
)
from _book2_full_sharh_batch06 b
where r.id = b.rule_id and r.course_name = 'Мединский курс (Том 2)'
  and r.lesson_number = b.lesson_number and strpos(r.content, 'book2-full-sharh-batch06') = 0;

do $assert$
declare v_count integer;
begin
  select count(*) into v_count
  from public.rules r join _book2_full_sharh_batch06 b on b.rule_id = r.id
  where strpos(r.content, 'book2-full-sharh-batch06') > 0;
  if v_count <> 27 then raise exception 'Book 2 lessons 26-30 markers incomplete: %', v_count; end if;

  if exists (
    select 1 from _book2_full_sharh_batch06 b
    where not exists (select 1 from public.rule_sources s where s.rule_id = b.rule_id)
  ) then raise exception 'A completed Book 2 lesson 26-30 card has no source row'; end if;

  if not exists (
    select 1 from public.rules where id = 1902
      and content like '%book2-l26-yajibu-short-source-complete%'
      and content like '%يَجِبُ عَلَيْكِ أَنْ تَحْفَظِي الْقُرْآنَ%'
      and content like '%يَجِبُ عَلَيْكُمْ أَنْ تَخْرُجُوا%'
      and content like '%يَجِبُ عَلَيْكَ أَنْ تَدْرُسَ جَيِّدًا%'
  ) then raise exception 'Lesson 26 short-source-only يَجِبُ section is incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1360
      and content like '%book2-l28-full-past-paradigms%'
      and content like '%بَكَوْا%' and content like '%بَقِينَ%'
  ) then raise exception 'Lesson 28 full-sharh past paradigms are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1361
      and content like '%book2-l28-full-present-paradigms%'
      and content like '%book2-l28-full-irab-table%'
      and content like '%لَنْ يَبْكِيَ%' and content like '%لَمْ يَبْكِ%'
  ) then raise exception 'Lesson 28 full-sharh present paradigms or irab table are incomplete'; end if;

  if not exists (
    select 1 from public.rules where id = 1366
      and rule_ar like '%حُجُّوا%مَبْنِيٌّ عَلَى الضَّمِّ%'
      and rule_ar like '%حُجِّي%مَبْنِيٌّ عَلَى الْكَسْرِ%'
      and content like '%book2-l29-full-source-priority%'
  ) then raise exception 'Lesson 29 full-sharh priority wording is missing'; end if;

  if not exists (
    select 1 from public.rules where id = 1367
      and content like '%لَنْ أَتْرُكَ الصَّلَاةَ أَبَدًا%'
  ) then raise exception 'Lesson 29 supplementary قَطُّ/أَبَدًا example is missing'; end if;
end;
$assert$;

commit;
