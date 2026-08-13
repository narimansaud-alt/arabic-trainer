-- Standardize all displayed Qur'anic fragments in Medina Books 1-3 to the
-- official QPC Uthmanic Hafs text used by the local Madinah-mushaf font.
-- Only public rules.content is changed. Verbatim rule_sources.source_text,
-- formulated rule_ar, translations, and non-Qur'anic examples remain untouched.

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '2'
    and sort_order = 6
    and title = 'مِنْ الزَّائِدَةُ (добавочный предлог مِنْ)';

  -- QPC Hafs reference: 5:19
  if position($old1$﴿ مَا جَاءَنَا مِنْ بَشِيرٍ ﴾$old1$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old1$﴿ مَا جَاءَنَا مِنْ بَشِيرٍ ﴾$old1$, $new1$﴿ مَا جَآءَنَا مِنۢ بَشِيرٖ ﴾$new1$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '2'
    and sort_order = 7
    and title = 'لَدَى (обстоятельственное имя места «у, при»)';

  -- QPC Hafs reference: 23:62
  if position($old2$﴿ وَلَدَيْنَا كِتَابٌ يَنْطِقُ بِالْحَقِّ ﴾$old2$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old2$﴿ وَلَدَيْنَا كِتَابٌ يَنْطِقُ بِالْحَقِّ ﴾$old2$, $new2$﴿ وَلَدَيۡنَا كِتَٰبٞ يَنطِقُ بِٱلۡحَقِّ ﴾$new2$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '5'
    and sort_order = 2
    and title = 'مَا الْعَامِلَةُ عَمَلَ لَيْسَ (частица مَا, работающая как لَيْسَ)';

  -- QPC Hafs reference: 12:31
  if position($old3$﴿ مَا هَذَا بَشَرًا ﴾$old3$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old3$﴿ مَا هَذَا بَشَرًا ﴾$old3$, $new3$﴿ مَا هَٰذَا بَشَرًا ﴾$new3$)
  where id = v_rule_id;

  -- QPC Hafs reference: 2:74, 2:85, 2:140, 2:149, 3:99
  if position($old4$﴿ وَمَا اللَّهُ بِغَافِلٍ عَمَّا تَعْمَلُونَ ﴾$old4$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old4$﴿ وَمَا اللَّهُ بِغَافِلٍ عَمَّا تَعْمَلُونَ ﴾$old4$, $new4$﴿ وَمَا ٱللَّهُ بِغَٰفِلٍ عَمَّا تَعۡمَلُونَ ﴾$new4$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '9'
    and sort_order = 7
    and title = 'صَوْغُ الْأَمْرِ مِنَ الْفِعْلِ أَتَى (образование повелительной формы от глагола «приходить»)';

  -- QPC Hafs reference: 2:258
  if position($old5$﴿ فَأْتِ بِهَا مِنَ الْمَغْرِبِ ﴾$old5$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old5$﴿ فَأْتِ بِهَا مِنَ الْمَغْرِبِ ﴾$old5$, $new5$﴿ فَأۡتِ بِهَا مِنَ ٱلۡمَغۡرِبِ ﴾$new5$)
  where id = v_rule_id;

  -- QPC Hafs reference: 2:189
  if position($old6$﴿ وَأْتُوا الْبُيُوتَ مِنْ أَبْوَابِهَا ﴾$old6$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old6$﴿ وَأْتُوا الْبُيُوتَ مِنْ أَبْوَابِهَا ﴾$old6$, $new6$﴿ وَأۡتُواْ ٱلۡبُيُوتَ مِنۡ أَبۡوَٰبِهَاۚ ﴾$new6$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '10'
    and sort_order = 1
    and title = 'الْجُمْلَةُ الِاسْمِيَّةُ (именное предложение)';

  -- QPC Hafs reference: 2:184
  if position($old7$﴿ وَأَنْ تَصُومُوا خَيْرٌ لَكُمْ ﴾$old7$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old7$﴿ وَأَنْ تَصُومُوا خَيْرٌ لَكُمْ ﴾$old7$, $new7$﴿ وَأَن تَصُومُواْ خَيۡرٞ لَّكُمۡ ﴾$new7$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '11'
    and sort_order = 1
    and title = 'الْمُبْتَدَأُ وَالْخَبَرُ وَأَنْوَاعُ الْمُبْتَدَأِ (мубтада, хабар и виды мубтада)';

  -- QPC Hafs reference: 2:237
  if position($old8$﴿ وَأَنْ تَعْفُوا أَقْرَبُ لِلتَّقْوَى ﴾$old8$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old8$﴿ وَأَنْ تَعْفُوا أَقْرَبُ لِلتَّقْوَى ﴾$old8$, $new8$﴿ وَأَن تَعۡفُوٓاْ أَقۡرَبُ لِلتَّقۡوَىٰۚ ﴾$new8$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '11'
    and sort_order = 3
    and title = 'التَّرْتِيبُ بَيْنَ الْمُبْتَدَأِ وَالْخَبَرِ (порядок мубтада и хабар)';

  -- QPC Hafs reference: 50:35
  if position($old9$﴿ وَلَدَيْنَا مَزِيدٌ ﴾$old9$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old9$﴿ وَلَدَيْنَا مَزِيدٌ ﴾$old9$, $new9$﴿ وَلَدَيۡنَا مَزِيدٞ ﴾$new9$)
  where id = v_rule_id;

  -- QPC Hafs reference: 2:7
  if position($old10$﴿ وَعَلَى أَبْصَارِهِمْ غِشَاوَةٌ ﴾$old10$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old10$﴿ وَعَلَى أَبْصَارِهِمْ غِشَاوَةٌ ﴾$old10$, $new10$﴿ وَعَلَىٰٓ أَبۡصَٰرِهِمۡ غِشَٰوَةٞۖ ﴾$new10$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '12'
    and sort_order = 1
    and title = 'الْمَفْعُولُ فِيهِ (обстоятельство времени или места)';

  -- QPC Hafs reference: 12:16
  if position($old11$﴿ وَجَاءُوا أَبَاهُمْ عِشَاءً يَبْكُونَ ﴾$old11$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old11$﴿ وَجَاءُوا أَبَاهُمْ عِشَاءً يَبْكُونَ ﴾$old11$, $new11$﴿ وَجَآءُوٓ أَبَاهُمۡ عِشَآءٗ يَبۡكُونَ ﴾$new11$)
  where id = v_rule_id;

  -- QPC Hafs reference: 78:12
  if position($old12$﴿ وَبَنَيْنَا فَوْقَكُمْ سَبْعًا شِدَادًا ﴾$old12$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old12$﴿ وَبَنَيْنَا فَوْقَكُمْ سَبْعًا شِدَادًا ﴾$old12$, $new12$﴿ وَبَنَيۡنَا فَوۡقَكُمۡ سَبۡعٗا شِدَادٗا ﴾$new12$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '12'
    and sort_order = 4
    and title = 'قَبْلُ وَبَعْدُ (слова «до» и «после»)';

  -- QPC Hafs reference: 30:4
  if position($old13$﴿ لِلَّهِ الْأَمْرُ مِنْ قَبْلُ وَمِنْ بَعْدُ ﴾$old13$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old13$﴿ لِلَّهِ الْأَمْرُ مِنْ قَبْلُ وَمِنْ بَعْدُ ﴾$old13$, $new13$﴿ لِلَّهِ ٱلۡأَمۡرُ مِن قَبۡلُ وَمِنۢ بَعۡدُۚ ﴾$new13$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '12'
    and sort_order = 5
    and title = 'لَوْ (условная частица «если бы»)';

  -- QPC Hafs reference: 56:65
  if position($old14$﴿ لَوْ نَشَاءُ لَجَعَلْنَاهُ حُطَامًا ﴾$old14$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old14$﴿ لَوْ نَشَاءُ لَجَعَلْنَاهُ حُطَامًا ﴾$old14$, $new14$﴿ لَوۡ نَشَآءُ لَجَعَلۡنَٰهُ حُطَٰمٗا ﴾$new14$)
  where id = v_rule_id;

  -- QPC Hafs reference: 56:70
  if position($old15$﴿ لَوْ نَشَاءُ جَعَلْنَاهُ أُجَاجًا ﴾$old15$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old15$﴿ لَوْ نَشَاءُ جَعَلْنَاهُ أُجَاجًا ﴾$old15$, $new15$﴿ لَوۡ نَشَآءُ جَعَلۡنَٰهُ أُجَاجٗا ﴾$new15$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '13'
    and sort_order = 1
    and title = 'جَوَازِمُ الْمُضَارِعِ: الْجَازِمُ فِعْلًا وَاحِدًا (частицы, ставящие один глагол в джазм)';

  -- QPC Hafs reference: 112:3
  if position($old16$﴿ لَمْ يَلِدْ وَلَمْ يُولَدْ ﴾$old16$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old16$﴿ لَمْ يَلِدْ وَلَمْ يُولَدْ ﴾$old16$, $new16$﴿ لَمۡ يَلِدۡ وَلَمۡ يُولَدۡ ﴾$new16$)
  where id = v_rule_id;

  -- QPC Hafs reference: 49:14
  if position($old17$﴿ وَلَمَّا يَدْخُلِ الْإِيمَانُ فِي قُلُوبِكُمْ ﴾$old17$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old17$﴿ وَلَمَّا يَدْخُلِ الْإِيمَانُ فِي قُلُوبِكُمْ ﴾$old17$, $new17$﴿ وَلَمَّا يَدۡخُلِ ٱلۡإِيمَٰنُ فِي قُلُوبِكُمۡۖ ﴾$new17$)
  where id = v_rule_id;

  -- QPC Hafs reference: 9:40
  if position($old18$﴿ لَا تَحْزَنْ إِنَّ اللَّهَ مَعَنَا ﴾$old18$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old18$﴿ لَا تَحْزَنْ إِنَّ اللَّهَ مَعَنَا ﴾$old18$, $new18$﴿ لَا تَحۡزَنۡ إِنَّ ٱللَّهَ مَعَنَاۖ ﴾$new18$)
  where id = v_rule_id;

  -- QPC Hafs reference: 49:11
  if position($old19$﴿ لَا يَسْخَرْ قَوْمٌ مِنْ قَوْمٍ ﴾$old19$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old19$﴿ لَا يَسْخَرْ قَوْمٌ مِنْ قَوْمٍ ﴾$old19$, $new19$﴿ لَا يَسۡخَرۡ قَوۡمٞ مِّن قَوۡمٍ ﴾$new19$)
  where id = v_rule_id;

  -- QPC Hafs reference: 65:7
  if position($old20$﴿ لِيُنْفِقْ ذُو سَعَةٍ مِنْ سَعَتِهِ ﴾$old20$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old20$﴿ لِيُنْفِقْ ذُو سَعَةٍ مِنْ سَعَتِهِ ﴾$old20$, $new20$﴿ لِيُنفِقۡ ذُو سَعَةٖ مِّن سَعَتِهِۦۖ ﴾$new20$)
  where id = v_rule_id;

  -- QPC Hafs reference: 29:12
  if position($old21$﴿ وَلْنَحْمِلْ خَطَايَاكُمْ ﴾$old21$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old21$﴿ وَلْنَحْمِلْ خَطَايَاكُمْ ﴾$old21$, $new21$﴿ وَلۡنَحۡمِلۡ خَطَٰيَٰكُمۡ ﴾$new21$)
  where id = v_rule_id;

  -- QPC Hafs reference: 2:186
  if position($old22$﴿ فَلْيَسْتَجِيبُوا لِي وَلْيُؤْمِنُوا بِي ﴾$old22$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old22$﴿ فَلْيَسْتَجِيبُوا لِي وَلْيُؤْمِنُوا بِي ﴾$old22$, $new22$﴿ فَلۡيَسۡتَجِيبُواْ لِي وَلۡيُؤۡمِنُواْ بِي ﴾$new22$)
  where id = v_rule_id;

  -- QPC Hafs reference: 22:29
  if position($old23$﴿ ثُمَّ لْيَقْضُوا تَفَثَهُمْ ﴾$old23$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old23$﴿ ثُمَّ لْيَقْضُوا تَفَثَهُمْ ﴾$old23$, $new23$﴿ ثُمَّ لۡيَقۡضُواْ تَفَثَهُمۡ ﴾$new23$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '13'
    and sort_order = 2
    and title = 'الْجَزْمُ بِالطَّلَبِ (джазм в ответе на побуждение)';

  -- QPC Hafs reference: 40:60
  if position($old24$﴿ اُدْعُونِي أَسْتَجِبْ لَكُمْ ﴾$old24$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old24$﴿ اُدْعُونِي أَسْتَجِبْ لَكُمْ ﴾$old24$, $new24$﴿ ٱدۡعُونِيٓ أَسۡتَجِبۡ لَكُمۡۚ ﴾$new24$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '14'
    and sort_order = 2
    and title = 'وُجُوبُ اقْتِرَانِ جَوَابِ الشَّرْطِ بِالْفَاءِ (обязательная фа в ответе условия)';

  -- QPC Hafs reference: 2:186
  if position($old25$﴿ وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ﴾$old25$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old25$﴿ وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ﴾$old25$, $new25$﴿ وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌۖ ﴾$new25$)
  where id = v_rule_id;

  -- QPC Hafs reference: 6:17
  if position($old26$﴿ وَإِنْ يَمْسَسْكَ بِخَيْرٍ فَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ ﴾$old26$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old26$﴿ وَإِنْ يَمْسَسْكَ بِخَيْرٍ فَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ ﴾$old26$, $new26$﴿ وَإِن يَمۡسَسۡكَ بِخَيۡرٖ فَهُوَ عَلَىٰ كُلِّ شَيۡءٖ قَدِيرٞ ﴾$new26$)
  where id = v_rule_id;

  -- QPC Hafs reference: 3:31
  if position($old27$﴿ إِنْ كُنْتُمْ تُحِبُّونَ اللَّهَ فَاتَّبِعُونِي ﴾$old27$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old27$﴿ إِنْ كُنْتُمْ تُحِبُّونَ اللَّهَ فَاتَّبِعُونِي ﴾$old27$, $new27$﴿ إِن كُنتُمۡ تُحِبُّونَ ٱللَّهَ فَٱتَّبِعُونِي ﴾$new27$)
  where id = v_rule_id;

  -- QPC Hafs reference: 8:61
  if position($old28$﴿ وَإِنْ جَنَحُوا لِلسَّلْمِ فَاجْنَحْ لَهَا وَتَوَكَّلْ عَلَى اللَّهِ ﴾$old28$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old28$﴿ وَإِنْ جَنَحُوا لِلسَّلْمِ فَاجْنَحْ لَهَا وَتَوَكَّلْ عَلَى اللَّهِ ﴾$old28$, $new28$﴿ وَإِن جَنَحُواْ لِلسَّلۡمِ فَٱجۡنَحۡ لَهَا وَتَوَكَّلۡ عَلَى ٱللَّهِۚ ﴾$new28$)
  where id = v_rule_id;

  -- QPC Hafs reference: 12:77
  if position($old29$﴿ إِنْ يَسْرِقْ فَقَدْ سَرَقَ أَخٌ لَهُ مِنْ قَبْلُ ﴾$old29$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old29$﴿ إِنْ يَسْرِقْ فَقَدْ سَرَقَ أَخٌ لَهُ مِنْ قَبْلُ ﴾$old29$, $new29$﴿ إِن يَسۡرِقۡ فَقَدۡ سَرَقَ أَخٞ لَّهُۥ مِن قَبۡلُۚ ﴾$new29$)
  where id = v_rule_id;

  -- QPC Hafs reference: 5:67
  if position($old30$﴿ وَإِنْ لَمْ تَفْعَلْ فَمَا بَلَّغْتَ رِسَالَتَهُ ﴾$old30$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old30$﴿ وَإِنْ لَمْ تَفْعَلْ فَمَا بَلَّغْتَ رِسَالَتَهُ ﴾$old30$, $new30$﴿ وَإِن لَّمۡ تَفۡعَلۡ فَمَا بَلَّغۡتَ رِسَالَتَهُۥۚ ﴾$new30$)
  where id = v_rule_id;

  -- QPC Hafs reference: 65:6
  if position($old31$﴿ وَإِنْ تَعَاسَرْتُمْ فَسَتُرْضِعُ لَهُ أُخْرَى ﴾$old31$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old31$﴿ وَإِنْ تَعَاسَرْتُمْ فَسَتُرْضِعُ لَهُ أُخْرَى ﴾$old31$, $new31$﴿ وَإِن تَعَاسَرۡتُمۡ فَسَتُرۡضِعُ لَهُۥٓ أُخۡرَىٰ ﴾$new31$)
  where id = v_rule_id;

  -- QPC Hafs reference: 5:32
  if position($old32$﴿ وَمَنْ أَحْيَاهَا فَكَأَنَّمَا أَحْيَا النَّاسَ جَمِيعًا ﴾$old32$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old32$﴿ وَمَنْ أَحْيَاهَا فَكَأَنَّمَا أَحْيَا النَّاسَ جَمِيعًا ﴾$old32$, $new32$﴿ وَمَنۡ أَحۡيَاهَا فَكَأَنَّمَآ أَحۡيَا ٱلنَّاسَ جَمِيعٗاۚ ﴾$new32$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '15'
    and sort_order = 1
    and title = 'جَوَازِمُ الْمُضَارِعِ: الْجَازِمُ فِعْلَيْنِ (условные средства, управляющие двумя глаголами)';

  -- QPC Hafs reference: 8:19
  if position($old33$﴿ وَإِنْ تَعُودُوا نَعُدْ ﴾$old33$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old33$﴿ وَإِنْ تَعُودُوا نَعُدْ ﴾$old33$, $new33$﴿ وَإِن تَعُودُواْ نَعُدۡ ﴾$new33$)
  where id = v_rule_id;

  -- QPC Hafs reference: 65:2
  if position($old34$﴿ وَمَنْ يَتَّقِ اللَّهَ يَجْعَلْ لَهُ مَخْرَجًا ﴾$old34$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old34$﴿ وَمَنْ يَتَّقِ اللَّهَ يَجْعَلْ لَهُ مَخْرَجًا ﴾$old34$, $new34$﴿ وَمَن يَتَّقِ ٱللَّهَ يَجۡعَل لَّهُۥ مَخۡرَجٗا ﴾$new34$)
  where id = v_rule_id;

  -- QPC Hafs reference: 2:197
  if position($old35$﴿ وَمَا تَفْعَلُوا مِنْ خَيْرٍ يَعْلَمْهُ اللَّهُ ﴾$old35$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old35$﴿ وَمَا تَفْعَلُوا مِنْ خَيْرٍ يَعْلَمْهُ اللَّهُ ﴾$old35$, $new35$﴿ وَمَا تَفۡعَلُواْ مِنۡ خَيۡرٖ يَعۡلَمۡهُ ٱللَّهُۗ ﴾$new35$)
  where id = v_rule_id;

  -- QPC Hafs reference: 4:78
  if position($old36$﴿ أَيْنَمَا تَكُونُوا يُدْرِكْكُمُ الْمَوْتُ ﴾$old36$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old36$﴿ أَيْنَمَا تَكُونُوا يُدْرِكْكُمُ الْمَوْتُ ﴾$old36$, $new36$﴿ أَيۡنَمَا تَكُونُواْ يُدۡرِككُّمُ ٱلۡمَوۡتُ ﴾$new36$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '15'
    and sort_order = 2
    and title = 'أَنْوَاعُ فِعْلِ الشَّرْطِ وَجَوَابِهِ (виды глагола условия и его ответа)';

  -- QPC Hafs reference: 8:19
  if position($old37$﴿ وَإِنْ تَعُودُوا نَعُدْ ﴾$old37$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old37$﴿ وَإِنْ تَعُودُوا نَعُدْ ﴾$old37$, $new37$﴿ وَإِن تَعُودُواْ نَعُدۡ ﴾$new37$)
  where id = v_rule_id;

  -- QPC Hafs reference: 17:7
  if position($old38$﴿ إِنْ أَحْسَنْتُمْ أَحْسَنْتُمْ لِأَنْفُسِكُمْ ﴾$old38$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old38$﴿ إِنْ أَحْسَنْتُمْ أَحْسَنْتُمْ لِأَنْفُسِكُمْ ﴾$old38$, $new38$﴿ إِنۡ أَحۡسَنتُمۡ أَحۡسَنتُمۡ لِأَنفُسِكُمۡۖ ﴾$new38$)
  where id = v_rule_id;

  -- QPC Hafs reference: 42:20
  if position($old39$﴿ مَنْ كَانَ يُرِيدُ حَرْثَ الْآخِرَةِ نَزِدْ لَهُ فِي حَرْثِهِ ﴾$old39$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old39$﴿ مَنْ كَانَ يُرِيدُ حَرْثَ الْآخِرَةِ نَزِدْ لَهُ فِي حَرْثِهِ ﴾$old39$, $new39$﴿ مَن كَانَ يُرِيدُ حَرۡثَ ٱلۡأٓخِرَةِ نَزِدۡ لَهُۥ فِي حَرۡثِهِۦۖ ﴾$new39$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '15'
    and sort_order = 3
    and title = 'كَمِ الِاسْتِفْهَامِيَّةُ وَكَمِ الْخَبَرِيَّةُ (вопросительная и повествовательная كَمْ)';

  -- QPC Hafs reference: 7:4
  if position($old40$﴿ وَكَمْ مِنْ قَرْيَةٍ أَهْلَكْنَاهَا فَجَاءَهَا بَأْسُنَا بَيَاتًا أَوْ هُمْ قَائِلُونَ ﴾$old40$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old40$﴿ وَكَمْ مِنْ قَرْيَةٍ أَهْلَكْنَاهَا فَجَاءَهَا بَأْسُنَا بَيَاتًا أَوْ هُمْ قَائِلُونَ ﴾$old40$, $new40$﴿ وَكَم مِّن قَرۡيَةٍ أَهۡلَكۡنَٰهَا فَجَآءَهَا بَأۡسُنَا بَيَٰتًا أَوۡ هُمۡ قَآئِلُونَ ﴾$new40$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '15'
    and sort_order = 4
    and title = 'حَتَّى: انْتِهَاءُ الْغَايَةِ وَالتَّعْلِيلُ (предел и цель с حَتَّى)';

  -- QPC Hafs reference: 63:7
  if position($old41$﴿ هُمُ الَّذِينَ يَقُولُونَ لَا تُنْفِقُوا عَلَى مَنْ عِنْدَ رَسُولِ اللَّهِ حَتَّى يَنْفَضُّوا ﴾$old41$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old41$﴿ هُمُ الَّذِينَ يَقُولُونَ لَا تُنْفِقُوا عَلَى مَنْ عِنْدَ رَسُولِ اللَّهِ حَتَّى يَنْفَضُّوا ﴾$old41$, $new41$﴿ هُمُ ٱلَّذِينَ يَقُولُونَ لَا تُنفِقُواْ عَلَىٰ مَنۡ عِندَ رَسُولِ ٱللَّهِ حَتَّىٰ يَنفَضُّواْۗ ﴾$new41$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '15'
    and sort_order = 5
    and title = 'اِسْمُ الْفِعْلِ هَا (имя действия повеления هَا — «возьми»)';

  -- QPC Hafs reference: 69:19
  if position($old42$﴿ هَاؤُمُ ٱقْرَءُوا كِتَابِيَهْ ﴾$old42$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old42$﴿ هَاؤُمُ ٱقْرَءُوا كِتَابِيَهْ ﴾$old42$, $new42$﴿ هَآؤُمُ ٱقۡرَءُواْ كِتَٰبِيَهۡ ﴾$new42$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '15'
    and sort_order = 6
    and title = 'حَذْفُ نُونِ يَكُنْ (удаление нуна в يَكُنْ)';

  -- QPC Hafs reference: 19:20
  if position($old43$﴿ وَلَمْ أَكُ بَغِيًّا ﴾$old43$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old43$﴿ وَلَمْ أَكُ بَغِيًّا ﴾$old43$, $new43$﴿ وَلَمۡ أَكُ بَغِيّٗا ﴾$new43$)
  where id = v_rule_id;

  -- QPC Hafs reference: 98:1
  if position($old44$﴿ لَمْ يَكُنِ الَّذِينَ كَفَرُوا ... ﴾$old44$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old44$﴿ لَمْ يَكُنِ الَّذِينَ كَفَرُوا ... ﴾$old44$, $new44$﴿ لَمۡ يَكُنِ ٱلَّذِينَ كَفَرُواْ ﴾…$new44$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '16'
    and sort_order = 4
    and title = 'بَابُ فَعَّلَ وَمَصْدَرُهُ وَمُشْتَقَّاتُهُ (модель فَعَّلَ, её масдар и производные)';

  -- QPC Hafs reference: 56:94
  if position($old45$﴿ وَتَصْلِيَةُ جَحِيمٍ ﴾$old45$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old45$﴿ وَتَصْلِيَةُ جَحِيمٍ ﴾$old45$, $new45$﴿ وَتَصۡلِيَةُ جَحِيمٍ ﴾$new45$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '17'
    and sort_order = 4
    and title = 'أَصْبَحَ: مِنْ أَخَوَاتِ كَانَ وَبِمَعْنَى صَارَ (أَصْبَحَ как сестра كَانَ и в значении «стал»)';

  -- QPC Hafs reference: 28:10
  if position($old46$﴿ وَأَصْبَحَ فُؤَادُ أُمِّ مُوسَى فَارِغًا ﴾$old46$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old46$﴿ وَأَصْبَحَ فُؤَادُ أُمِّ مُوسَى فَارِغًا ﴾$old46$, $new46$﴿ وَأَصۡبَحَ فُؤَادُ أُمِّ مُوسَىٰ فَٰرِغًاۖ ﴾$new46$)
  where id = v_rule_id;

  -- QPC Hafs reference: 3:103
  if position($old47$﴿ فَأَصْبَحْتُمْ بِنِعْمَتِهِ إِخْوَانًا ﴾$old47$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old47$﴿ فَأَصْبَحْتُمْ بِنِعْمَتِهِ إِخْوَانًا ﴾$old47$, $new47$﴿ فَأَصۡبَحۡتُم بِنِعۡمَتِهِۦٓ إِخۡوَٰنٗا ﴾$new47$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '17'
    and sort_order = 6
    and title = 'وَلَوْ وَالْجُمْلَةُ الْحَالِيَّةُ (وَلَوْ и обстоятельственное предложение)';

  -- QPC Hafs reference: 61:8
  if position($old48$﴿ وَاللَّهُ مُتِمُّ نُورِهِ وَلَوْ كَرِهَ الْكَافِرُونَ ﴾$old48$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old48$﴿ وَاللَّهُ مُتِمُّ نُورِهِ وَلَوْ كَرِهَ الْكَافِرُونَ ﴾$old48$, $new48$﴿ وَٱللَّهُ مُتِمُّ نُورِهِۦ وَلَوۡ كَرِهَ ٱلۡكَٰفِرُونَ ﴾$new48$)
  where id = v_rule_id;
end
$migration$;

do $migration$
declare
  v_rule_id bigint;
begin
  select id into strict v_rule_id
  from public.rules
  where course_name = 'Мединский курс (Том 3)'
    and lesson_number = '17'
    and sort_order = 7
    and title = 'لَامُ الِابْتِدَاءِ (лям начала для усиления)';

  -- QPC Hafs reference: 16:41
  if position($old49$﴿ وَلَأَجْرُ الْآخِرَةِ أَكْبَرُ ﴾$old49$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old49$﴿ وَلَأَجْرُ الْآخِرَةِ أَكْبَرُ ﴾$old49$, $new49$﴿ وَلَأَجۡرُ ٱلۡأٓخِرَةِ أَكۡبَرُۚ ﴾$new49$)
  where id = v_rule_id;

  -- QPC Hafs reference: 29:45
  if position($old50$﴿ وَلَذِكْرُ اللَّهِ أَكْبَرُ ﴾$old50$ in (select content from public.rules where id = v_rule_id)) = 0 then
    raise exception 'Expected Qur''anic fragment not found for rule %', v_rule_id;
  end if;

  update public.rules
  set content = replace(content, $old50$﴿ وَلَذِكْرُ اللَّهِ أَكْبَرُ ﴾$old50$, $new50$﴿ وَلَذِكۡرُ ٱللَّهِ أَكۡبَرُۗ ﴾$new50$)
  where id = v_rule_id;
end
$migration$;
