-- Supplement Medina Book 2 lesson 2 from the second Arabic sharh.
-- The wording difference يَجُوزُ / يَجِبُ remains traceable in separate source rows.

begin;

do $migration$
declare
  laysa_rule_id bigint;
  baa_rule_id bigint;
  fronting_rule_id bigint;
  ibn_rule_id bigint;
  lesson_rule_count integer;
  updated_content text;
begin
  select count(*) into lesson_rule_count
  from public.rules
  where course_name = 'Мединский курс (Том 2)'
    and lesson_number = '2';

  if lesson_rule_count <> 4 then
    raise exception 'Expected 4 Book 2 lesson 2 rules before the two-sharh supplement, found %', lesson_rule_count;
  end if;

  select id into strict laysa_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '2' and sort_order = 1;

  select id into strict baa_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '2' and sort_order = 2;

  select id into strict fronting_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '2' and sort_order = 3;

  select id into strict ibn_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 2)' and lesson_number = '2' and sort_order = 4;

  -- Add the second sharh's explicit negation meaning and feminine-plural nasb sign.
  select content into strict updated_content from public.rules where id = laysa_rule_id;
  if position('book2-second-sharh-laysa-kasra' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 2 rule %', laysa_rule_id;
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-study-card book2-second-sharh-laysa-kasra"><span class="rule-card-kicker">Значение и особый признак نَصْبٍ</span><span class="rule-main-ar" dir="rtl" lang="ar">مَعْنَى <span class="ar-tone-verb">لَيْسَ</span> <span class="ar-tone-particle">النَّفْيُ</span>، أَيْ: نَفْيُ الْخَبَرِ.</span><p class="rule-study-text"><span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">لَيْسَ</span> отрицает содержание сказуемого.</p><div class="rule-example-list"><div class="rule-example-card rule-term-predicate"><span class="rule-example-ar" dir="rtl" lang="ar">الْفَتَيَاتُ <span class="ar-tone-verb">لَسْنَ</span> <span class="ar-tone-nasb">مُتَزَوِّجَاتٍ</span>.</span><span class="rule-example-ru">Девушки не замужем.</span></div></div><div class="tbl-wrap"><table><thead><tr><th><span class="rule-table-ar">الْكَلِمَةُ</span><span class="rule-table-ru">слово</span></th><th><span class="rule-table-ar">إِعْرَابُهَا</span><span class="rule-table-ru">грамматический разбор</span></th></tr></thead><tbody><tr><td><span class="rule-table-ar ar-tone-nasb">مُتَزَوِّجَاتٍ</span><span class="rule-table-ru">замужние</span></td><td><span class="rule-table-ar ar-tone-nasb">خَبَرُ «لَيْسَ» مَنْصُوبٌ، وَعَلَامَةُ نَصْبِهِ الْكَسْرَةُ؛ لِأَنَّهُ جَمْعُ مُؤَنَّثٍ سَالِمٌ.</span><span class="rule-table-ru">Сказуемое <span class="ar-inline ar-tone-verb" dir="rtl" lang="ar">لَيْسَ</span> в винительном состоянии; показатель — касра, потому что это правильное женское множественное число.</span></td></tr></tbody></table></div></div>
</div>$html$;
  end if;

  update public.rules
  set
    rule_ar = 'لَيْسَ فِعْلٌ مَاضٍ نَاقِصٌ جَامِدٌ؛ يَلْزَمُ صُورَةَ الْمَاضِي وَلَيْسَ لَهُ مُضَارِعٌ وَلَا مُشْتَقٌّ آخَرُ. يَرْفَعُ الْمُبْتَدَأَ وَيَنْصِبُ الْخَبَرَ، فَيَجْعَلُ الْمُبْتَدَأَ اسْمًا لَهُ وَالْخَبَرَ خَبَرًا لَهُ، وَعَمَلُهُ عَكْسُ عَمَلِ إِنَّ وَأَخَوَاتِهَا. وَمَعْنَاهُ النَّفْيُ، أَيْ: نَفْيُ الْخَبَرِ. وَإِذَا كَانَ خَبَرُهُ جَمْعَ مُؤَنَّثٍ سَالِمًا كَانَتْ عَلَامَةُ نَصْبِهِ الْكَسْرَةَ نِيَابَةً عَنِ الْفَتْحَةِ.',
    summary = 'لَيْسَ فِعْلٌ مَاضٍ نَاقِصٌ جَامِدٌ؛ يَلْزَمُ صُورَةَ الْمَاضِي وَلَيْسَ لَهُ مُضَارِعٌ وَلَا مُشْتَقٌّ آخَرُ. يَرْفَعُ الْمُبْتَدَأَ وَيَنْصِبُ الْخَبَرَ، فَيَجْعَلُ الْمُبْتَدَأَ اسْمًا لَهُ وَالْخَبَرَ خَبَرًا لَهُ، وَعَمَلُهُ عَكْسُ عَمَلِ إِنَّ وَأَخَوَاتِهَا. وَمَعْنَاهُ النَّفْيُ، أَيْ: نَفْيُ الْخَبَرِ. وَإِذَا كَانَ خَبَرُهُ جَمْعَ مُؤَنَّثٍ سَالِمًا كَانَتْ عَلَامَةُ نَصْبِهِ الْكَسْرَةَ نِيَابَةً عَنِ الْفَتْحَةِ.',
    content = updated_content
  where id = laysa_rule_id;

  -- Record that the second sharh names the extra باء as emphatic.
  select content into strict updated_content from public.rules where id = baa_rule_id;
  if position('book2-second-sharh-baa-emphasis' in updated_content) = 0 then
    updated_content := rtrim(updated_content);
    if right(updated_content, 6) <> '</div>' then
      raise exception 'Unexpected outer markup for Book 2 lesson 2 rule %', baa_rule_id;
    end if;
    updated_content := left(updated_content, length(updated_content) - 6) || $html$
<div class="rule-check-card book2-second-sharh-baa-emphasis"><b>Смысл добавочной بِـ.</b> Во втором шархе она названа <span class="ar-inline ar-tone-particle" dir="rtl" lang="ar">لِلتَّوْكِيدِ</span>: она усиливает отрицание и не меняет синтаксическое место сказуемого.</div>
</div>$html$;
  end if;

  update public.rules
  set
    rule_ar = 'قَدْ تَدْخُلُ الْبَاءُ الزَّائِدَةُ عَلَى خَبَرِ لَيْسَ الْمُفْرَدِ لِلتَّوْكِيدِ، فَيُجَرُّ لَفْظًا وَيَبْقَى مَنْصُوبًا مَحَلًّا. وَلَا تَدْخُلُ عَلَى خَبَرِ لَيْسَ إِذَا كَانَ جُمْلَةً أَوْ شِبْهَ جُمْلَةٍ. وَشِبْهُ الْجُمْلَةِ إِمَّا جَارٌّ وَمَجْرُورٌ، وَإِمَّا ظَرْفُ زَمَانٍ أَوْ مَكَانٍ.',
    summary = 'قَدْ تَدْخُلُ الْبَاءُ الزَّائِدَةُ عَلَى خَبَرِ لَيْسَ الْمُفْرَدِ لِلتَّوْكِيدِ، فَيُجَرُّ لَفْظًا وَيَبْقَى مَنْصُوبًا مَحَلًّا. وَلَا تَدْخُلُ عَلَى خَبَرِ لَيْسَ إِذَا كَانَ جُمْلَةً أَوْ شِبْهَ جُمْلَةٍ. وَشِبْهُ الْجُمْلَةِ إِمَّا جَارٌّ وَمَجْرُورٌ، وَإِمَّا ظَرْفُ زَمَانٍ أَوْ مَكَانٍ.',
    content = updated_content
  where id = baa_rule_id;

  delete from public.rule_sources
  where rule_id in (laysa_rule_id, baa_rule_id, fronting_rule_id, ibn_rule_id)
    and source_document = 'Sharkh_na_2_tom_Med_kursa.pdf';

  insert into public.rule_sources
    (rule_id, source_document, source_text, source_page_from, source_page_to, sort_order)
  values
    (laysa_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الدَّرْسُ الثَّانِي

لَيْسَ
لَيْسَ: فِعْلٌ مَاضٍ نَاقِصٌ، يَرْفَعُ الِاسْمَ، وَيَنْصِبُ الْخَبَرَ.

الْبَابُ مُغْلَقٌ: لَيْسَ الْبَابُ مُغْلَقًا.
لَيْسَ الْمَاءُ بَارِدًا. لَيْسَ هِشَامٌ مَرِيضًا. لَيْسَ الْمَسْجِدُ بَعِيدًا. لَيْسَ الطِّفْلُ نَائِمًا.

يَجُوزُ أَنْ يَدْخُلَ حَرْفُ الْجَرِّ (الْبَاءُ) عَلَى خَبَرِ لَيْسَ، وَيَجُوزُ أَنْ يَكُونَ اسْمُ لَيْسَ ضَمِيرًا:
حَامِدٌ لَيْسَ طَالِبًا، وَيَجُوزُ: حَامِدٌ لَيْسَ بِطَالِبٍ. (اسْمُ لَيْسَ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ: هُوَ).
آمِنَةُ لَيْسَتْ طَبِيبَةً، وَيَجُوزُ: آمِنَةُ لَيْسَتْ بِطَبِيبَةٍ. (اسْمُ لَيْسَ ضَمِيرٌ مُسْتَتِرٌ تَقْدِيرُهُ: هِيَ).
الطُّلَّابُ لَيْسُوا صِغَارًا، وَيَجُوزُ: الطُّلَّابُ لَيْسُوا بِصِغَارٍ. (اسْمُ لَيْسَ وَاوُ الْجَمَاعَةِ).
الْفَتَيَاتُ لَسْنَ مُتَزَوِّجَاتٍ، وَيَجُوزُ: الْفَتَيَاتُ لَسْنَ بِمُتَزَوِّجَاتٍ. (اسْمُ لَيْسَ نُونُ النِّسْوَةِ).
أَنَا لَسْتُ مُدَرِّسًا، وَيَجُوزُ: أَنَا لَسْتُ بِمُدَرِّسٍ. (اسْمُ لَيْسَ ضَمِيرُ الْمُتَكَلِّمِ التَّاءُ).
نَحْنُ لَسْنَا جُدُدًا، وَيَجُوزُ: نَحْنُ لَسْنَا بِجُدُدٍ. (اسْمُ لَيْسَ ضَمِيرُ الْمُتَكَلِّمِينَ نَا).
أَنْتَ لَسْتَ كَبِيرًا، وَيَجُوزُ: أَنْتَ لَسْتَ بِكَبِيرٍ. (اسْمُ لَيْسَ ضَمِيرُ الْمُخَاطَبِ التَّاءُ).
أَنْتِ لَسْتِ فَقِيرَةً، وَيَجُوزُ: أَنْتِ لَسْتِ بِفَقِيرَةٍ. (اسْمُ لَيْسَ ضَمِيرُ الْمُخَاطَبَةِ التَّاءُ).
أَنْتُمْ لَسْتُمْ عَرَبًا، وَيَجُوزُ: أَنْتُمْ لَسْتُمْ بِعَرَبٍ. (اسْمُ لَيْسَ ضَمِيرُ الْمُخَاطَبِينَ تُـمْ).
أَنْتُنَّ لَسْتُنَّ مُجْتَهِدَاتٍ، وَيَجُوزُ: أَنْتُنَّ لَسْتُنَّ بِمُجْتَهِدَاتٍ. (اسْمُ لَيْسَ ضَمِيرُ الْمُخَاطَبَاتِ تُـنَّ).$source$, 7, 7, 3),

    (laysa_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$لَيْسَ: مِنْ أَخَوَاتِ كَانَ الَّتِي تَرْفَعُ الِاسْمَ، وَتَنْصِبُ الْخَبَرَ.
مَعْنَاهَا: النَّفْيُ، أَيْ: تَنْفِي الْخَبَرَ.
اسْمُهَا مَرْفُوعٌ وَعَلَامَةُ رَفْعِهِ الضَّمَّةُ، وَخَبَرُهَا مَنْصُوبٌ وَعَلَامَةُ نَصْبِهِ الْفَتْحَةُ، كَمَا فِي الْأَمْثِلَةِ السَّابِقَةِ.
الْفَتَيَاتُ لَسْنَ مُتَزَوِّجَاتٍ. الْخَبَرُ هُنَا مَنْصُوبٌ وَعَلَامَةُ نَصْبِهِ الْكَسْرَةُ؛ لِأَنَّهُ جَمْعُ مُؤَنَّثٍ سَالِمٌ.
لَسْتُمْ، لَسْتُنَّ: الضَّمِيرُ فِي الْمِثَالَيْنِ هُوَ (التَّاءُ)، وَالْمِيمُ: عَلَامَةُ الْجَمْعِ الْمُذَكَّرِ، وَالنُّونُ الْمُشَدَّدَةُ عَلَامَةُ الْجَمْعِ الْمُؤَنَّثِ.$source$, 8, 8, 4),

    (baa_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$يَجُوزُ أَنْ يَدْخُلَ حَرْفُ الْجَرِّ (الْبَاءُ) عَلَى خَبَرِ لَيْسَ.
حَامِدٌ لَيْسَ طَالِبًا، وَيَجُوزُ: حَامِدٌ لَيْسَ بِطَالِبٍ.
آمِنَةُ لَيْسَتْ طَبِيبَةً، وَيَجُوزُ: آمِنَةُ لَيْسَتْ بِطَبِيبَةٍ.
الطُّلَّابُ لَيْسُوا صِغَارًا، وَيَجُوزُ: الطُّلَّابُ لَيْسُوا بِصِغَارٍ.
الْفَتَيَاتُ لَسْنَ مُتَزَوِّجَاتٍ، وَيَجُوزُ: الْفَتَيَاتُ لَسْنَ بِمُتَزَوِّجَاتٍ.$source$, 7, 7, 3),

    (baa_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$الْمَاءُ لَيْسَ بِبَارِدٍ: فَائِدَةُ حَرْفِ الْجَرِّ (الْبَاءُ) التَّوْكِيدُ. بَارِدٍ: مَجْرُورٌ لَفْظًا مَنْصُوبٌ مَحَلًّا؛ لِأَنَّهُ خَبَرُ لَيْسَ.$source$, 8, 8, 4),

    (fronting_rule_id, 'Sharkh_na_2_tom_Med_kursa.pdf', $source$تَقْدِيمُ خَبَرِ إِنَّ عَلَى اسْمِهَا

يَجُوزُ تَقْدِيمُ خَبَرِ إِنَّ عَلَى اسْمِهَا إِذَا كَانَ الْخَبَرُ جَارًّا وَمَجْرُورًا.

لِي ثَلَاثُ أَخَوَاتٍ ← إِنَّ لِي ثَلَاثَ أَخَوَاتٍ.
فِي الْفَصْلِ خَمْسَةُ طُلَّابٍ جُدُدٌ ← إِنَّ فِي الْفَصْلِ خَمْسَةَ طُلَّابٍ جُدُدًا.
لَنَا مُدَرِّسٌ جَيِّدٌ ← إِنَّ لَنَا مُدَرِّسًا جَيِّدًا.
فِي الْهِنْدِ أَنْهَارٌ كَثِيرَةٌ ← إِنَّ فِي الْهِنْدِ أَنْهَارًا كَثِيرَةً.
فِي جَيْبِي مِائَةُ رِيَالٍ ← إِنَّ فِي جَيْبِي مِائَةَ رِيَالٍ.$source$, 8, 8, 2);

  if exists (
    select 1
    from public.rules
    where course_name = 'Мединский курс (Том 2)'
      and lesson_number = '2'
      and coalesce(rule_ar, '') = ''
  ) then
    raise exception 'Book 2 lesson 2 contains an empty rule_ar after the two-sharh supplement';
  end if;

  if exists (
    select 1
    from public.rules r
    where r.course_name = 'Мединский курс (Том 2)'
      and r.lesson_number = '2'
      and not exists (select 1 from public.rule_sources s where s.rule_id = r.id)
  ) then
    raise exception 'Book 2 lesson 2 contains a rule without provenance after the two-sharh supplement';
  end if;
end;
$migration$;

commit;
