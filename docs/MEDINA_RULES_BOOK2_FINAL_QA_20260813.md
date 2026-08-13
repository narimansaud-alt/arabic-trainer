# Medina Book 2 final QA - 2026-08-13

## Result

**Проверено уроков:** 31
**Проверено правил:** 148
**Исправлено уроков:** 7
**Исправлено правил/карточек:** 8
**Исправлено RTL-проблем:** 1 известная проблема направления, затем повторно проверены все уроки
**Исправлено ошибок арабского текста:** 1 некораническая карточка
**Исправлено харакатов:** 1 карточка
**Проверено аятов:** 5
**Исправлено аятов:** 5
**Исправлено проблем со шрифтами:** 1 общий компонент аятов
**Исправлено проблем с цветами:** 1 общий компонент аятов
**Исправлено проблем с размерами:** 1 общий компонент аятов
**Исправлено локальных проблем дизайна:** 0
**Исправлено локальных технических проблем:** 0
**Оставлено на ручную проверку:** 0

## What was corrected

- Both controlling sources were read and retained: `Podrobny_Sharkh_2_tom.pdf` (80 pages) and `Sharkh_na_2_tom_Med_kursa.pdf` (62 pages). Matching explanations are not duplicated. Lesson 12 correctly has only the detailed 80-page source because the second sharh has no corresponding block.
- Corrected cards are in lessons 1, 11, 16, 23 and 28-30.
- All five Qur'anic fragments now exactly match the official QPC Uthmanic Hafs corpus.
- Russian meanings were restored in the `عُمَرُ/عَمْرٌو`, weak-verb, doubled-verb and five-verb tables.
- Connected hamzat al-wasl examples and the five-verbs note were corrected without changing verbatim `source_text`.
- Live final state: 148 cards, 290 separate private source rows and 162 responsive tables.
- Provenance, table-translation, card and 93 rendered screen-state checks passed with zero findings.
- Applied migration: `20260814020000_final_qa_book2_confirmed_corrections.sql`.

Book 4 was not touched.
