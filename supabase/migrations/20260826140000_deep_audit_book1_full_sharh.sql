-- Deep source-to-public audit corrections for the complete Book 1 sharh.
-- Controlling source: Sharkh_na_1_tom_Med_kursa.pdf, PDF pages 3-36.
-- The audit covered all 70 public rule cards and all 147 archived source fragments.

begin;

do $audit$
declare
  v_count integer;
  v_changed integer;
begin
  select count(*) into v_count
  from public.rules
  where course_name = 'Мединский курс (Том 1)'
    and id in (1495, 1518, 1544);

  if v_count <> 3 then
    raise exception 'Expected 3 guarded Book 1 deep-audit rules, found %', v_count;
  end if;

  select count(*) into v_count
  from public.rule_sources
  where id in (38, 122)
    and source_document = 'Sharkh_na_1_tom_Med_kursa.pdf';

  if v_count <> 2 then
    raise exception 'Expected 2 guarded Book 1 source rows, found %', v_count;
  end if;

  -- Lesson 8, page 12: preserve the author's explicit classification.
  update public.rules
  set content = regexp_replace(
    content,
    '</div>[[:space:]]*$',
    $html$
  <div class="rule-study-card">
    <span class="rule-card-kicker">Разъяснение автора</span>
    <span class="rule-main-ar" dir="rtl" lang="ar">أَمَامَ، خَلْفَ: ظَرْفُ مَكَانٍ.</span>
    <p class="rule-study-text"><strong>Полный перевод:</strong> <span dir="rtl" lang="ar">أَمَامَ</span> и <span dir="rtl" lang="ar">خَلْفَ</span> — обстоятельства места.</p>
  </div>
</div>$html$
  )
  where id = 1495
    and course_name = 'Мединский курс (Том 1)'
    and lesson_number = '8'
    and strpos(content, 'أَمَامَ، خَلْفَ: ظَرْفُ مَكَانٍ.') = 0;

  get diagnostics v_changed = row_count;
  if v_changed <> 1 then
    raise exception 'Book 1 lesson 8 place-adverb explanation updated % rows', v_changed;
  end if;

  -- Lesson 13, pages 19-20: translate every row of the author's four iḍāfa analyses.
  update public.rules
  set content = replace(
    content,
    $old$<tr><td dir="rtl" lang="ar">أَبْنَاءُ مُحَمَّدٍ</td><td dir="rtl" lang="ar">أَبْنَاءُ: مُضَافٌ</td><td dir="rtl" lang="ar">مُحَمَّدٍ: مُضَافٌ إِلَيْهِ</td></tr>$old$,
    $new$<tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَبْنَاءُ مُحَمَّدٍ</span><span class="rule-table-ru">сыновья Мухаммада</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَبْنَاءُ: مُضَافٌ</span><span class="rule-table-ru">«сыновья» — первый член идафы, мудаф</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">مُحَمَّدٍ: مُضَافٌ إِلَيْهِ</span><span class="rule-table-ru">«Мухаммада» — второй член идафы, мудаф иляйхи</span></td></tr>$new$
  )
  where id = 1518
    and course_name = 'Мединский курс (Том 1)'
    and lesson_number = '13'
    and strpos(content, $old$<tr><td dir="rtl" lang="ar">أَبْنَاءُ مُحَمَّدٍ</td><td dir="rtl" lang="ar">أَبْنَاءُ: مُضَافٌ</td><td dir="rtl" lang="ar">مُحَمَّدٍ: مُضَافٌ إِلَيْهِ</td></tr>$old$) > 0;

  get diagnostics v_changed = row_count;
  if v_changed <> 1 then
    raise exception 'Book 1 lesson 13 first iḍāfa analysis updated % rows', v_changed;
  end if;

  update public.rules
  set content = replace(
    content,
    $old$<tr><td dir="rtl" lang="ar">أَبْنَاؤُهُ</td><td dir="rtl" lang="ar">أَبْنَاؤُ: مُضَافٌ</td><td dir="rtl" lang="ar">ـهُ: مُضَافٌ إِلَيْهِ</td></tr>$old$,
    $new$<tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَبْنَاؤُهُ</span><span class="rule-table-ru">его сыновья</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَبْنَاؤُ: مُضَافٌ</span><span class="rule-table-ru">«сыновья» — первый член идафы, мудаф</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ـهُ: مُضَافٌ إِلَيْهِ</span><span class="rule-table-ru">суффикс «его» — второй член идафы, мудаф иляйхи</span></td></tr>$new$
  )
  where id = 1518
    and course_name = 'Мединский курс (Том 1)'
    and lesson_number = '13'
    and strpos(content, $old$<tr><td dir="rtl" lang="ar">أَبْنَاؤُهُ</td><td dir="rtl" lang="ar">أَبْنَاؤُ: مُضَافٌ</td><td dir="rtl" lang="ar">ـهُ: مُضَافٌ إِلَيْهِ</td></tr>$old$) > 0;

  get diagnostics v_changed = row_count;
  if v_changed <> 1 then
    raise exception 'Book 1 lesson 13 second iḍāfa analysis updated % rows', v_changed;
  end if;

  update public.rules
  set content = replace(
    content,
    $old$<tr><td dir="rtl" lang="ar">أَبْنَاؤُكَ</td><td dir="rtl" lang="ar">أَبْنَاؤُ: مُضَافٌ</td><td dir="rtl" lang="ar">ـكَ: مُضَافٌ إِلَيْهِ</td></tr>$old$,
    $new$<tr><td><span class="rule-table-ar" dir="rtl" lang="ar">أَبْنَاؤُكَ</span><span class="rule-table-ru">твои сыновья</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">أَبْنَاؤُ: مُضَافٌ</span><span class="rule-table-ru">«сыновья» — первый член идафы, мудаф</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ـكَ: مُضَافٌ إِلَيْهِ</span><span class="rule-table-ru">суффикс «твой / твои» — второй член идафы, мудаф иляйхи</span></td></tr>$new$
  )
  where id = 1518
    and course_name = 'Мединский курс (Том 1)'
    and lesson_number = '13'
    and strpos(content, $old$<tr><td dir="rtl" lang="ar">أَبْنَاؤُكَ</td><td dir="rtl" lang="ar">أَبْنَاؤُ: مُضَافٌ</td><td dir="rtl" lang="ar">ـكَ: مُضَافٌ إِلَيْهِ</td></tr>$old$) > 0;

  get diagnostics v_changed = row_count;
  if v_changed <> 1 then
    raise exception 'Book 1 lesson 13 third iḍāfa analysis updated % rows', v_changed;
  end if;

  update public.rules
  set content = replace(
    content,
    $old$<tr><td dir="rtl" lang="ar">كِتَابِي</td><td dir="rtl" lang="ar">كِتَابُ: مُضَافٌ</td><td dir="rtl" lang="ar">ـِي: مُضَافٌ إِلَيْهِ</td></tr>$old$,
    $new$<tr><td><span class="rule-table-ar" dir="rtl" lang="ar">كِتَابِي</span><span class="rule-table-ru">моя книга</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">كِتَابُ: مُضَافٌ</span><span class="rule-table-ru">«книга» — первый член идафы, мудаф</span></td><td><span class="rule-table-ar" dir="rtl" lang="ar">ـِي: مُضَافٌ إِلَيْهِ</span><span class="rule-table-ru">суффикс «мой / моя» — второй член идафы, мудаф иляйхи</span></td></tr>$new$
  )
  where id = 1518
    and course_name = 'Мединский курс (Том 1)'
    and lesson_number = '13'
    and strpos(content, $old$<tr><td dir="rtl" lang="ar">كِتَابِي</td><td dir="rtl" lang="ar">كِتَابُ: مُضَافٌ</td><td dir="rtl" lang="ar">ـِي: مُضَافٌ إِلَيْهِ</td></tr>$old$) > 0;

  get diagnostics v_changed = row_count;
  if v_changed <> 1 then
    raise exception 'Book 1 lesson 13 fourth iḍāfa analysis updated % rows', v_changed;
  end if;

  -- Lesson 20, page 32: restore the author's repeated rule without shortening it.
  update public.rules
  set content = replace(
    content,
    $old$<span class="rule-main-ar" dir="rtl" lang="ar">إِذَا كَانَ الْمَعْدُودُ مُؤَنَّثًا جَاءَ الْعَدَدُ مُذَكَّرًا.</span><p class="rule-study-text">Если единственное число считаемого слова женского рода, число от трёх до десяти имеет форму без <span dir="rtl" lang="ar">تَاءٍ مَرْبُوطَةٍ</span>: <span dir="rtl" lang="ar">ثَلَاثُ، أَرْبَعُ، خَمْسُ، سِتُّ، سَبْعُ، ثَمَانِي، تِسْعُ، عَشْرُ</span>. Считаемое слово остаётся множественным и родительным.</p>$old$,
    $new$<span class="rule-main-ar" dir="rtl" lang="ar">الْعَدَدُ مِنْ (٣ إِلَى ١٠) يُخَالِفُ الْمَعْدُودَ فِي التَّذْكِيرِ وَالتَّأْنِيثِ: إِذَا كَانَ الْمَعْدُودُ مُذَكَّرًا فَإِنَّ الْعَدَدَ يَكُونُ مُؤَنَّثًا، وَإِذَا كَانَ الْمَعْدُودُ مُؤَنَّثًا فَإِنَّ الْعَدَدَ يَكُونُ مُذَكَّرًا.</span><span class="rule-main-ar" dir="rtl" lang="ar">وَالْمَعْدُودُ يَكُونُ جَمْعًا مَجْرُورًا بِالْإِضَافَةِ، أَيْ يَكُونُ مُضَافًا إِلَيْهِ.</span><p class="rule-study-text"><strong>Полный перевод:</strong> Числа от трёх до десяти противоположны считаемому слову по роду: если считаемое слово мужского рода, числительное имеет форму женского рода; если считаемое слово женского рода, числительное имеет форму мужского рода. Считаемое слово ставится во множественном числе в родительном падеже в идафе, то есть является <span dir="rtl" lang="ar">مُضَافًا إِلَيْهِ</span>.<br><strong>Применение к примерам этого урока:</strong> если единственное число считаемого слова женского рода, число от трёх до десяти имеет форму без <span dir="rtl" lang="ar">تَاءٍ مَرْبُوطَةٍ</span>: <span dir="rtl" lang="ar">ثَلَاثُ، أَرْبَعُ، خَمْسُ، سِتُّ، سَبْعُ، ثَمَانِي، تِسْعُ، عَشْرُ</span>.</p>$new$
  )
  where id = 1544
    and course_name = 'Мединский курс (Том 1)'
    and lesson_number = '20'
    and strpos(content, 'الْعَدَدُ مِنْ (٣ إِلَى ١٠) يُخَالِفُ') = 0;

  get diagnostics v_changed = row_count;
  if v_changed <> 1 then
    raise exception 'Book 1 lesson 20 full repeated numeral rule updated % rows', v_changed;
  end if;

  -- Page 12 source archive: the PDF says هَذَا الرَّجُلُ تَاجِرٌ.
  update public.rule_sources
  set source_text = replace(
    source_text,
    'هَذَا التَّاجِرُ تَاجِرٌ',
    'هَذَا الرَّجُلُ تَاجِرٌ'
  )
  where id = 38
    and rule_id = 1493
    and source_document = 'Sharkh_na_1_tom_Med_kursa.pdf'
    and source_page_from = 12
    and source_page_to = 12
    and sort_order = 1
    and strpos(source_text, 'هَذَا التَّاجِرُ تَاجِرٌ') > 0;

  get diagnostics v_changed = row_count;
  if v_changed <> 1 then
    raise exception 'Book 1 page 12 source correction updated % rows', v_changed;
  end if;

  -- Page 26 source archive: the arrow introduces three attached examples;
  -- it does not show a separated, incorrect بَيْتُ كَ form.
  update public.rule_sources
  set source_text = replace(
    source_text,
    'أَيْنَ بَيْتُكَ ؟ ← أَيْنَ بَيْتُ كَ ؟ أَيْنَ بَيْتُكُمْ ؟ أَيْنَ بَيْتُكُنَّ ؟',
    'أَيْنَ بَيْتُكَ ؟ أَيْنَ بَيْتُكُمْ ؟ أَيْنَ بَيْتُكُنَّ ؟'
  )
  where id = 122
    and rule_id = 1532
    and source_document = 'Sharkh_na_1_tom_Med_kursa.pdf'
    and source_page_from = 26
    and source_page_to = 26
    and sort_order = 2
    and strpos(source_text, 'أَيْنَ بَيْتُ كَ ؟') > 0;

  get diagnostics v_changed = row_count;
  if v_changed <> 1 then
    raise exception 'Book 1 page 26 source correction updated % rows', v_changed;
  end if;

  if (
    select count(*)
    from public.rules
    where course_name = 'Мединский курс (Том 1)'
      and content like '%Полный текст шарха ·%'
  ) <> 70 then
    raise exception 'Book 1 must retain 70 complete full-sharh markers';
  end if;

  if (
    select count(*)
    from public.rule_sources rs
    join public.rules r on r.id = rs.rule_id
    where r.course_name = 'Мединский курс (Том 1)'
      and rs.source_document = 'Sharkh_na_1_tom_Med_kursa.pdf'
  ) <> 147 then
    raise exception 'Book 1 must retain all 147 source fragments';
  end if;

  if not exists (
    select 1 from public.rules
    where id = 1495
      and content like '%أَمَامَ، خَلْفَ: ظَرْفُ مَكَانٍ.%'
      and content like '%обстоятельства места%'
  ) then
    raise exception 'Book 1 lesson 8 place-adverb explanation is incomplete';
  end if;

  if not exists (
    select 1 from public.rules
    where id = 1518
      and content like '%«сыновья» — первый член идафы, мудаф%'
      and content like '%суффикс «мой / моя» — второй член идафы%'
  ) then
    raise exception 'Book 1 lesson 13 Russian iḍāfa analyses are incomplete';
  end if;

  if not exists (
    select 1 from public.rules
    where id = 1544
      and content like '%если считаемое слово мужского рода, числительное имеет форму женского рода%'
      and content like '%то есть является <span dir="rtl" lang="ar">مُضَافًا إِلَيْهِ</span>%'
  ) then
    raise exception 'Book 1 lesson 20 complete repeated numeral explanation is missing';
  end if;

  if exists (
    select 1 from public.rule_sources
    where id = 38
      and source_text like '%هَذَا التَّاجِرُ تَاجِرٌ%'
  ) or not exists (
    select 1 from public.rule_sources
    where id = 38
      and source_text like '%هَذَا الرَّجُلُ تَاجِرٌ%'
  ) then
    raise exception 'Book 1 page 12 source archive still differs from the PDF';
  end if;

  if exists (
    select 1 from public.rule_sources
    where id = 122
      and source_text like '%بَيْتُ كَ%'
  ) or not exists (
    select 1 from public.rule_sources
    where id = 122
      and source_text like '%أَيْنَ بَيْتُكَ ؟ أَيْنَ بَيْتُكُمْ ؟ أَيْنَ بَيْتُكُنَّ ؟%'
  ) then
    raise exception 'Book 1 page 26 source archive still differs from the PDF';
  end if;
end;
$audit$;

commit;
