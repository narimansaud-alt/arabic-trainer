# Book 2 two-sharh progress: lesson 3

Completed: 2026-08-12.

## Source boundaries read in full

- `Podrobny_Sharkh_2_tom.pdf`: PDF pages 11-14.
- `Sharkh_na_2_tom_Med_kursa.pdf`: PDF pages 9-11. Page 12 begins lesson 4.

The second PDF's embedded Arabic text layer is logically corrupted. Its `source_text` rows were therefore transcribed manually from the rendered page, as explicitly authorized by the owner, and kept separate from `rule_ar`.

## Pre-edit comparison

Material common to both sharhs:

- `اِسْمُ التَّفْضِيلِ`;
- compound numbers 11-19 and `أَلْفَاظُ الْعُقُودِ`;
- gender agreement of the two parts of 11-19;
- ordinal numbers;
- `بَلَى` and `نَعَمْ` in answers to negative questions;
- `أَيُّهُمَا`.

Material only in the 80-page sharh:

- doubled and `مَقْصُورٌ` forms of `اِسْمُ التَّفْضِيلِ`;
- detailed case government of the decades and the first part of twelve;
- the complete 11-19 gender table.

Material only in the 62-page sharh:

- a separate `لَكِنَّ وَكَأَنَّ` explanation, their government, meanings, examples, and parsing diagram;
- the explicit restriction `نَكِرَةً مُضَافًا إِلَى نَكِرَةٍ`;
- the statement that `اِسْمُ التَّفْضِيلِ` remains masculine singular in the two described patterns and is used for rational and non-rational referents;
- `نَعَمْ` / `لَا` for an ordinary non-negative question;
- explicit use of `أَيُّهُمَا` for rational and non-rational referents.

No direct contradiction between the two sharhs was found in lesson 3.

## Applied changes

- Migration: `supabase/migrations/20260813025500_supplement_book2_lesson3_from_second_sharh.sql`.
- Added public rule ID 1895: `لَكِنَّ وَكَأَنَّ (частицы «но» и «словно, как будто»)`.
- Expanded the existing `اِسْمُ التَّفْضِيلِ`, decades, compound-number, ordinal-number, question-answer, and `أَيُّهُمَا` cards.
- Preserved the existing detailed material from the 80-page sharh.
- Added all unique instructional examples from the 62-page sharh: 57 example cards/contexts. Equivalent examples already represented by the 80-page material were not duplicated.
- Every public Arabic example is vocalized and has a Russian meaning.
- Tables use bilingual Arabic/Russian headings and semantic role colors.

## Verified database state

- 8 public cards in contiguous sort order 1-8.
- 8/8 non-empty, vocalized `rule_ar` values.
- 7 cards supported by the 80-page sharh.
- 8 cards supported by the 62-page sharh.
- 7 private provenance rows for `Podrobny_Sharkh_2_tom.pdf`, pages 11-14.
- 11 private provenance rows for `Sharkh_na_2_tom_Med_kursa.pdf`, pages 9-11.
- Every provenance row has non-empty `source_text` and valid page data.

## Audits

- `node scripts/audit_medina_rule_cards.mjs 2`: no lesson-3 malformed punctuation, duplicate Arabic marks, unbalanced markup, sort gaps, table-translation gaps, untranslated Arabic example cards, or invalid connected hamzat al-wasl.
- `node tmp/audit_medina_lesson_content_harakat.mjs 2 3`: no multi-letter visible Arabic word without a haraka.
- Private Supabase provenance audit confirmed the two sources remain separate.
- The full desktop/mobile screen audit remains intentionally queued until all four volumes are source-complete, per the owner's execution-order override.
