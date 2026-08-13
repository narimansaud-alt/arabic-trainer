# Book 2, lesson 9 — two-sharh review and first-stage database correction

## Pages read completely

- `Podrobny_Sharkh_2_tom.pdf`: lower part of PDF page 25 through PDF page 26.
- `Sharkh_na_2_tom_Med_kursa.pdf`: PDF pages 21–22.
- PDF page 23 visibly starts `الدَّرْسُ الْعَاشِرُ`.

## Shared material

- `عَلَامَةُ النَّصْبِ فِي جَمْعِ الْمُؤَنَّثِ السَّالِمِ`.
- `فِعْلُ التَّعَجُّبِ` on the pattern `مَا أَفْعَلَهُ`.
- Singular/proper and annexed vocative.
- Interrogative hamza before the definite article.
- Attached object pronouns and `نُونُ الْوِقَايَةِ` context.
- Deletion of the alif in interrogative `مَا` after a preposition.
- Relative pronouns by gender and number.

## Material only or more explicit in the 80-page sharh

- Exact comparison between the singular object `الْمَجَلَّةَ` and sound-feminine-plural `الْمَجَلَّاتِ`.
- Explicit definition of `نُونُ الْوِقَايَةِ` and its iʿrāb status.

## Material only or expanded in the 62-page sharh

- Six exclamation examples.
- Broader vocative examples for both source categories.
- Full رفع/نصب/جر paradigms and examples for the sound feminine plural.
- Additional interrogative-hamza examples: `آلْبِحَارُ؟، آلْآنَ؟، آلْيَوْمَ؟، آلْمُدِيرُ؟`, plus the contrast `أَهَذَا صَحِيحٌ؟`.
- Explicit object-pronoun categories `يَاءُ الْمُتَكَلِّمِ، كَافُ الْمُخَاطَبِ، هَاءُ الْغَائِبِ` with examples.
- All four interrogative contractions `مِمَّ، عَمَّ، بِمَ، لِمَ`.
- Relative pronouns `الَّذِي، الَّتِي، الَّذِينَ، اللَّاتِي، اللَّذَانِ، اللَّتَانِ` with complete examples.

No contradiction was found.

## First-stage database correction

Migration: `supabase/migrations/20260813023000_verify_book2_lesson9_from_80_page_sharh.sql`.

- Replaced seven generic unverified cards with seven source-grounded cards.
- Added fully vocalized `rule_ar` to all seven.
- Preserved the exact lesson order and added complete tables, translations, and iʿrāb from the 80-page source.
- Structural audit after application: clean markup, no sort gaps, no missing table translations, no Arabic examples lacking Russian meaning.
- The second-sharh supplement described below is now complete and applied.
## Second-sharh supplement applied

Migrations:

- `supabase/migrations/20260813071000_supplement_book2_lesson9_from_second_sharh.sql`
- `supabase/migrations/20260813071100_fix_book2_lesson9_mixed_script_alif.sql`
- `supabase/migrations/20260813071200_polish_book2_lesson9_semantics.sql`
- `supabase/migrations/20260813071300_polish_book2_lesson9_wasl_and_allah.sql`

Applied result:

- Expanded the seven shared cards without duplicating common rules.
- Added all six exclamation examples, six additional vocatives, the complete sound-feminine-plural رفع/نصب/جر paradigm and examples, all interrogative-hamza examples, all four interrogative-`مَا` questions, and all relative-pronoun examples.
- Added the distinct `ضَمَائِرُ النَّصْبِ الْمُتَّصِلَةُ` card with all nine examples.
- Preserved both source forms `اللَّائِي` (80-page sharh) and `اللَّاتِي` (second sharh), and added `اللَّذَانِ / اللَّتَانِ`.
- Corrected the mixed-script Russian word `алиф`, the parsing display of `رَأَيْتُ`, the boundary between `نُونُ الْوِقَايَةِ` and `يَاءُ الْمُتَكَلِّمِ`, the vocative scope, explicit `ٱلْـ`, and the public vocalization `اللَّهِ`.

Final live state:

- 8 public cards with continuous sort order 1-8.
- 7 source rows from `Podrobny_Sharkh_2_tom.pdf`, pages 25-26.
- 7 source rows from `Sharkh_na_2_tom_Med_kursa.pdf`, pages 21-22.
- Rules without provenance: 0; empty sources: 0; invalid page ranges: 0.
- Missing `rule_ar`: 0; missing title translations: 0; unvocalized public Arabic words: 0; malformed markup: 0; unwrapped tables: 0.