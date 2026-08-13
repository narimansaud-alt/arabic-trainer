# Book 2, lesson 15 - final local audit before Supabase

## Prepared result

- Four non-duplicating cards follow the four teaching blocks actually present in the lesson: prohibitive `لَا`; negative `لَا` and `مَا`; `كَادَ`; review of `فِعْلُ التَّعَجُّبِ`.
- Six separate provenance rows keep literal `source_text` apart from the fully vocalized public `rule_ar`.
- All distinct source examples from both sharhs are retained with Russian meanings.
- The unrelated `أَنَّ`, the malformed hybrid `نَاقِصٌный`, and examples absent from the supplied lesson sources are removed from the prepared result.

## Local validation

- 4 `rule_ar` assignments, 4 content blocks, and 6 source fragments.
- SQL delimiters and every HTML/card/table tag are balanced.
- After the two small UI corrections are simulated, no unvocalized Arabic word remains in the public fields, no Arabic-Russian malformed hybrid remains, and the printed punctuation of `لِمَ لَا تَأْكُلُ فَالطَّعَامُ لَذِيذٌ؟` is preserved.
- No direct contradiction exists between the two sharhs for this lesson.
- The migrations are prepared locally but have not been applied to production Supabase pending the exact destructive-migration confirmation required by the execution gate.
