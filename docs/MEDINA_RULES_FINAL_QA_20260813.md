# Medina rules Books 1-3 final QA - 2026-08-13

## Outcome

The final source/data/code/screen audit is complete for Books 1-3. Book 4 was not opened or processed.

| Volume | Lessons | Rule cards | Private source rows | Tables | Qur'anic fragments | Rendered screen states |
|---:|---:|---:|---:|---:|---:|---:|
| 1 | 23 | 70 | 147 | 43 | 0 | 69 |
| 2 | 31 | 148 | 290 | 162 | 5 | 93 |
| 3 | 17 | 89 | 89 | 206 | 50 | 51 |
| **Total** | **71** | **307** | **526** | **411** | **55** | **213** |

All 213 states (desktop 1365 px, tablet 820 px and mobile 390 px for every lesson) passed with zero browser errors and zero detected layout, RTL, clipping, translation, font-size or table-overflow findings.

## Requested quantitative summary

**Проверено томов:** 3
**Проверено уроков:** 71
**Проверено правил:** 307
**Исправлено правил/уникальных карточек:** 42 (19 содержательных карточек и 23 отдельные карточки с QPC-стандартизацией)
**Проверено аятов:** 55
**Исправлено аятов:** 55
**Исправлено RTL-проблем:** 1
**Исправлено ошибок шрифтов:** 1 общий компонент
**Исправлено проблем цветов:** 1 общий компонент
**Исправлено проблем размеров:** 1 общий компонент
**Исправлено проблем дизайна:** 1 общий компонент отображения аятов
**Исправлено проблем Supabase:** 4 защищённые миграции
**Исправлено проблем в коде:** 3 компонента (шрифт/кэш, приоритет стиля аятов, устаревший health-check)
**Осталось элементов для ручной проверки:** 0
## Source and provenance controls

- Book 1 controlling source: `Sharkh_na_1_tom_Med_kursa.pdf`; lessons 1-23; PDF pages 3-36.
- Book 2 controlling sources: `Podrobny_Sharkh_2_tom.pdf` (80 pages) and `Sharkh_na_2_tom_Med_kursa.pdf` (62 pages). Matching material is not duplicated; both verbatim source fragments are retained where both sharhs support a card. Lesson 12 has no corresponding block in the 62-page sharh and therefore correctly has only the 80-page source.
- Book 3 controlling source: `Sharkh_Medinskiy_3.pdf`; lessons 1-17; PDF pages 3-73. The DOC was used only as an extraction aid.
- Every public card has a separate fully vocalized `rule_ar` and at least one private verbatim `rule_sources.source_text` row with real pages. `source_text` was not normalized, corrected or mixed into `rule_ar`.
- No unclear-source placeholders remain in Books 1-3.

## Confirmed final-QA corrections

### Book 1

- Checked lessons: 23; checked cards: 70.
- Confirmed corrections: 10 cards in lessons 7, 9-14, 21 and 22.
- Corrected Russian meanings and labels, an unsupported possession explanation, wording of relative-pronoun examples, a `مَعَ` harakat/grammar formulation, review-card translations and the stated patterns of the diptote rule.
- Migration: `20260814010000_final_qa_book1_confirmed_corrections.sql`.

### Book 2

- Checked lessons: 31; checked cards: 148.
- Confirmed corrections: 8 cards in lessons 1, 11, 16, 23, 28-30.
- Corrected four Qur'anic display fragments already present in this volume, missing Russian table meanings, the `عُمَرُ/عَمْرٌو` labels, weak/doubled/five-verb tables and connected hamzat al-wasl examples.
- Migration: `20260814020000_final_qa_book2_confirmed_corrections.sql`.

### Book 3

- Checked lessons: 17; checked cards: 89.
- Confirmed grammar correction: lesson 13 lamentation particle `وَا`, previously carrying an impossible doubled fatha sequence.
- Migration: `20260814030000_final_qa_book3_confirmed_corrections.sql`.
- All 50 Qur'anic display fragments were standardized to the official QPC Uthmanic Hafs script without changing the sharh's verbatim `source_text`.

## Qur'an standard

- Authoritative text corpus: Quran Foundation/QPC Uthmanic Hafs.
- Exact result: 55 of 55 displayed fragments are literal substrings of the official QPC corpus; zero mismatches remain.
- The phrase `وَمَا ٱللَّهُ بِغَٰفِلٍ عَمَّا تَعۡمَلُونَ` is intentionally not assigned an arbitrary single verse number because the exact phrase occurs in 2:74, 2:85, 2:140, 2:149 and 3:99.
- Font: official local `UthmanicHafs1Ver18.woff2` (`Uthmanic Hafs`), 87,760 bytes; cached by the PWA and independent of a runtime third-party font request.
- Qur'anic blocks are isolated from grammar-role colors, forced black, centered and RTL, with 50 px target sizing on larger screens and 36 px on mobile.
- Migration: `20260814040000_standardize_quran_qpc_hafs.sql`.

## Technical verification

- Live Supabase: 307 cards, 71 lessons and 526 source rows; no missing `rule_ar`, missing sources, invalid source pages, duplicate source order, source/public mixing or unclear placeholders.
- Card audits: no malformed punctuation, doubled Arabic marks, unbalanced supported markup, missing Russian title meanings, missing example translations or live table-row translation gaps.
- Screen audits: all lessons opened and scrolled card-by-card on desktop, tablet and mobile; responsive table wrappers do not widen the page.
- Font checks: ordinary Arabic uses the application Arabic font stack; Qur'an uses `Uthmanic Hafs`; all Qur'an descendants inherit black and the same mushaf font.
- Reproducible health command: `node scripts/verify_rules_health.mjs`.

## Rollback

- Database rollback is performed by restoring the previous `rules.content`/`rule_ar` values recorded as guarded old values in the four final migrations or by restoring the pre-migration database backup.
- Code rollback is a Git revert of the release commit. The QPC text migration and the local QPC font must be rolled back together to avoid a mixed display standard.

## Author's closing formula

`تَمَّ بِحَمْدِ اللَّهِ تَعَالَى، وَالصَّلَاةُ وَالسَّلَامُ عَلَى نَبِيِّنَا مُحَمَّدٍ وَآلِهِ وَصَحْبِهِ أَجْمَعِينَ.`

Russian: `Завершено с хвалой Всевышнему Аллаху. Благословение и мир - нашему Пророку Мухаммаду, его семье и всем его сподвижникам.`

## Stop point

Books 1-3 are complete. Do not begin Book 4 without a new explicit instruction from the owner.
