BEGIN;

DO $$
DECLARE
  target_rule_id bigint;
BEGIN
  SELECT id
    INTO target_rule_id
  FROM public.rules
  WHERE course_name = 'Мединский курс (Том 1)'
    AND lesson_number = '1'
    AND (
      title ILIKE '%مَا%'
      OR title ILIKE '%مَنْ%'
      OR title ILIKE '%что%'
      OR title ILIKE '%кто%'
    )
  ORDER BY id
  LIMIT 1;

  IF target_rule_id IS NULL THEN
    RAISE EXCEPTION 'Не найдено правило مَا/مَنْ в уроке 1 тома 1';
  END IF;

  UPDATE public.rules
  SET
    title = 'مَا؟ وَمَنْ؟ (вопросы «что?» и «кто?»)',
    summary = 'مَا используется для всего неразумного, а مَنْ — для разумных существ: людей, джиннов, ангелов и Создателя.',
    content = '<b>مَا</b> используется, когда спрашивают о неразумном: предметах, животных, растениях и явлениях. <b>مَنْ</b> используется, когда спрашивают о разумных существах: людях, джиннах, ангелах и Создателе (Аллахе).<br><br><b>مَا هَذَا؟</b> — Что это? (о неразумном).<br><b>مَنْ هَذَا؟</b> — Кто это? (о разумном существе).<br><br>То же правило действует независимо от того, близкий это предмет или далёкий: выбирается вопросительное слово по разумности того, о ком или о чём спрашивают.'
  WHERE id = target_rule_id;

  DELETE FROM public.rule_sections
  WHERE rule_id = target_rule_id;
END $$;

COMMIT;
