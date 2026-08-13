# Book 2, lesson 14 - final local audit before Supabase

## Source coverage

- `Podrobny_Sharkh_2_tom.pdf`: PDF pages 33-34 were read visually in full; page 35 starts lesson 15.
- `Sharkh_na_2_tom_Med_kursa.pdf`: PDF pages 27-28 were read visually in full; page 29 starts lesson 15.
- The overlap was merged without duplicate rules. Distinct material from either sharh was retained.

## Errors found before correction

- All three production cards had `rule_ar = null`.
- The old derivation through `لَمْ تَكْتُبْ` is absent from both supplied lesson sources.
- The three verb classes, the dual imperative, four construction signs, five complete i'rab analyses, four present prefixes, bare-alif spelling warning, most vowel pairs, the two nūn-deletion derivations, and the connected-speech rule were missing.
- Several Arabic table labels lacked a Russian meaning.
- Some Arabic labels were embedded unvocalized in Russian UI prose.

## Prepared source-only correction

- Three non-duplicating public cards: meaning/forms; construction and complete i'rab; derivation and hamzat al-wasl.
- Eight separate provenance rows preserve `source_text` independently from fully vocalized `rule_ar`.
- Every distinct example from both sharhs is represented, including all twelve present/imperative vowel pairs.
- Correct public imperatives use a bare initial alif: `اِذْهَبْ`, `اُكْتُبْ`; a hamzah head appears only inside the verbatim source's printed wrong-example comparison.
- Tables are inside `tbl-wrap`, Arabic is marked as Arabic and receives role colors, and Arabic terms have adjacent Russian meanings.

## Local validation

- 3 `rule_ar` assignments and 8 source fragments.
- SQL dollar delimiters and all HTML table/card tags are balanced.
- No replacement character or malformed public hamzat-al-wasl spelling was found.
- The migration is prepared locally but has not been applied to production Supabase pending the exact destructive-migration confirmation requested by the execution gate.
