# Medina rules knowledge base

This file preserves the owner’s working instructions for Medina-course rule work so context is not lost during conversation compaction.

## Current multi-volume continuation protocol — 2026-08-12

### Owner correction: Book 2 uses both supplied Arabic sharhs

- This correction supersedes the older “sole 80-page source” wording below.
- For every Book 2 lesson, read and compare both `Podrobny_Sharkh_2_tom.pdf` (80 pages) and `Sharkh_na_2_tom_Med_kursa.pdf` (62 pages).
- Preserve every distinct source-backed rule and example from either sharh. Merge matching material without duplicate public cards and report meaningful differences between the two sharhs for each lesson.
- Every completed and fully audited lesson is authorized for immediate upload to the working Supabase. Incomplete lessons must not be uploaded.
- Process one volume at a time and never mix source context: **Book 2 → Book 3 → Book 4**.
- Before a Book 2 edit, establish all real lesson boundaries from that 80-page PDF. Then process lessons strictly in order **1 → 31**, reading every source page of each lesson before extracting rules.
- For every public rule keep a separate, fully vocalized `rule_ar` and one or more private verbatim `rule_sources.source_text` fragments with real PDF page numbers. Never normalize, correct, vocalize, or mix `source_text` with `rule_ar`.
- Compare each lesson with the current application, report the discrepancies found, then apply only source-confirmed changes and continue without waiting for separate permission.
- When a volume is complete, perform both automated and visual audits of **every lesson**, locally and in production, on desktop and mobile viewports.
- During each volume audit verify that all cards and tables use the application palette; Arabic is large, bold, readable, and semantically colored by grammatical role; every Arabic heading/term has a Russian meaning where required; and wide tables scroll inside their card on mobile without widening the page.
- Only after Book 2 passes its complete source/data/screen audit may work begin on Book 3. Book 3 is now complete; Book 4 must not begin without a new explicit permission from the owner.

### Final Books 1-3 QA checkpoint - 2026-08-13

- The full final QA is complete for Books 1-3: **307 cards, 71 lessons, 526 private verbatim source rows, 411 responsive tables and 55 Qur'anic display fragments**.
- All **213 rendered lesson states** (every lesson at desktop, tablet and mobile widths) passed with zero findings and zero browser errors.
- All **55/55 Qur'anic fragments** are literal substrings of the official QPC Uthmanic Hafs corpus. They use the locally stored official `Uthmanic Hafs` font, render black, centered and RTL, and do not inherit grammar-role colors.
- Final guarded migrations: `20260814010000_final_qa_book1_confirmed_corrections.sql`, `20260814020000_final_qa_book2_confirmed_corrections.sql`, `20260814030000_final_qa_book3_confirmed_corrections.sql`, and `20260814040000_standardize_quran_qpc_hafs.sql`.
- Reproducible live health command: `node scripts/verify_rules_health.mjs`.
- Combined retained report: `docs/MEDINA_RULES_FINAL_QA_20260813.md`.
- **Book 4 remains untouched and must not be started without a new explicit instruction from the owner.**
### Current execution checkpoint — 2026-08-13

- Book 1 is complete.
- Book 2 is complete: 148 cards across 31 lessons; 140 source rows from the 80-page sharh and 150 source rows from the 62-page sharh.
- Book 2 complete screen audit passed on desktop and mobile for all 31 lessons with zero findings.
- Lesson 12 has no corresponding rule block in the 62-page sharh; its source support is correctly retained only from the 80-page sharh.
- Book 3 is complete: 89 source-backed cards across 17 lessons and 89 separate private verbatim source rows from `Sharkh_Medinskiy_3.pdf`.
- The complete Book 3 data/provenance and desktop/tablet/mobile screen audits passed with zero findings.
- Book 4 has not been started and must not be started without a new explicit permission from the owner.

### Book 4 explicit authorization and controlling protocol - 2026-08-14

- The owner explicitly authorized starting and completing Book 4. The former stop instruction is superseded only for Book 4.
- Scope is strictly volume 4. Do not edit or re-audit another volume while processing Book 4.
- Controlling sources are the paired files Sharkh_Medinskiy_4.doc and Sharkh_Medinskiy_4.pdf in the Desktop Medina-course Book-4 folder. Use DOC for accurate extraction and PDF as final authority for original wording, structure, page boundaries and disagreements.
- Source fingerprints: DOC SHA-256 3CA85F3800F5AA22D2A068CF95FA1CBD9573C0CA15FBD3DEBBA51A0CB2E80852; PDF SHA-256 C068781A1AABE95CAEC16AA2E8B220B2366558DC21ABBADAD9B2BC619672AE73.
- The PDF has 71 pages and 17 lessons. Verified starts are L1 2; L2 7; L3 10; L4 13; L5 21; L6 24; L7 28; L8 31; L9 36; L10 42; L11 45; L12 51; L13 53; L14 56; L15 60; L16 64; L17 68. Lesson ranges can overlap at a boundary page when the preceding explanation ends above the next lesson heading; confirm each end while reading the complete lesson.
- Process lessons strictly 1 through 17. Read the complete lesson before extracting rules, including continuations onto later pages.
- Every public rule must be directly supported by this sharh, stored with volume 4 and the correct lesson, and linked to a separate private verbatim source_text with real PDF page numbers. Never mix or normalize source_text into rule_ar.
- rule_ar must be concise, faithful and fully vocalized only after a separate grammar/harakat review. Do not add model knowledge, external books or internet content.
- Compare with existing volume-4 data before changing it; preserve IDs and links where safe, do not auto-move disputed records, and use idempotent lesson-scoped migrations.
- Reuse the current shared Medina rule UI and visual standard from Books 1-3. Do not introduce a Book-4-only component or redesign.
- After every lesson, perform source/data/harakat/provenance and screen checks, record the lesson report, then continue without a separate permission request.
- After lesson 17, run complete local and production audits of every Book-4 lesson at desktop, tablet and mobile widths before declaring completion.
### Book 4 sequential audit progress — 2026-08-14

- Lesson **1** is complete against PDF pages **2–6**: **9 public cards, 9 fully vocalized `rule_ar` values, 9 private verbatim source rows and 6 wrapped tables**. Existing IDs 1786–1794 were preserved. Data/provenance checks and production desktop/tablet/mobile screen audits passed with zero findings.
- Lesson **2** is complete against PDF pages **7–10**: **7 public cards, 7 fully vocalized `rule_ar` values, 7 private verbatim source rows, 11 Qur'anic fragments and 4 wrapped tables**. The legacy card that mixed `ذَوُو وَأُولُو` with `كَافُ الْخِطَابِ` was split; existing IDs were preserved and one new ID was created only for the missing independent rule. Data/provenance checks and production desktop/tablet/mobile screen audits passed with zero findings.
- Lesson **3** is complete against PDF pages **10–13**: **3 public cards, 3 fully vocalized `rule_ar` values, 3 private verbatim source rows, 3 Qur'anic fragments and 2 wrapped tables**. The true continuation on page 13 was restored, and the DOC extraction errors `مُتَحَدَّثٌ` / `مُتَدَبَّرٌ` were corrected to the PDF forms `مُتَحَدِّثٌ` / `مُتَدَبِّرٌ` only in the reconstructed source. Existing IDs 1801–1803 were preserved. Data/provenance checks and production desktop/tablet/mobile screen audits passed with zero findings.

### Book 3 sequential audit progress — 2026-08-13

- Lesson **1** is complete against `Sharkh_Medinskiy_3.pdf` pages **3–17**. The old 10 generated cards had no `rule_ar`, no private source rows, mixed public source text, generic non-source instructions, and placeholders. They were replaced with **11 source-backed cards** and **11 private verbatim source rows**. The content/data audits and desktop/mobile screen audits passed with zero findings; the lesson contains 18 wrapped tables.
- Lesson **2** is complete against PDF pages **18–21**. Its eight real blocks are `وَاوُ الْحَالِ`, `لَعَلَّ`, `إِلَيْكُمْ`, `أَشْيَاءُ`, the past verb used for supplication, `مِنْ الزَّائِدَةُ`, `لَدَى`, and `صِيغَةُ مُنْتَهَى الْجُمُوعِ`.
- Lesson 2 replaced eight generated cards that had null `rule_ar`, crossed topic boundaries, public verbatim source blocks, generic instructions, placeholder translations, and a bleed into lesson 3. The two visible Qur'anic strings hidden by DOC control characters were transcribed literally from PDF pages 19 and 20: `﴿ مَا جَاءَنَا مِنْ بَشِيرٍ ﴾` and `﴿ وَلَدَيْنَا كِتَابٌ يَنْطِقُ بِالْحَقِّ ﴾`.
- Lesson 2 final state: **8 public cards, 8 private verbatim source rows, 12 wrapped tables**, no unclear placeholders, and no lesson-3 bleed. Harakat/content/data checks and desktop/mobile screen audits passed with zero findings.
- Lesson **3** is complete against PDF pages **22–26**: **5 public cards, 5 private source rows, 15 wrapped tables**. The passive-voice paradigms, nisba, `إِمَّا`, hundreds and collective nouns were rebuilt from the sharh; all data and desktop/mobile audits passed.
- Lesson **4** is complete against PDF pages **27–28**: **1 public card, 1 private source row, 2 wrapped tables** for `اسْمُ الْفَاعِلِ`; all audits passed.
- Lesson **5** is complete against PDF pages **29–31**: **2 public cards, 2 private source rows, 4 wrapped tables** for `اسْمُ الْمَفْعُولِ` and `مَا الْعَامِلَةُ عَمَلَ لَيْسَ`; both visible Qur'anic examples were restored from the PDF and all audits passed.
- Lesson **6** is complete against PDF pages **31–33**: **1 public card, 1 private source row, 7 wrapped tables** for the nouns of time and place; all audits passed.
- Lesson **7** is complete against PDF pages **34–35**: **1 public card, 1 private source row, 3 wrapped tables** for `اسْمُ الْآلَةِ`, including all source patterns, examples, جامد names and the Basran note; all audits passed.
- Lesson **8** is complete against PDF pages **36–38**: **8 public cards, 8 private source rows, 14 wrapped tables**. Seven generated cards with null `rule_ar`, shifted topic fragments and unrelated templates were replaced by the definition pair `الْمَعْرِفَةُ وَالنَّكِرَةُ` plus the seven source-defined kinds of definite noun. The final harakat, data, provenance and desktop/mobile screen audits passed with zero findings.
- Lesson **9** is complete against PDF pages **39–41**: **7 public cards, 7 private source rows, 14 wrapped tables**. The lesson now includes the dual, `كِلَا/كِلْتَا`, dual demonstratives, the first-person possessive suffix, sound masculine plural and its iḍāfa form, and the imperative of `أَتَى`. Two visible Qur'anic examples were restored. The private source preserves the printed `افتح يداك`, while the public grammatical example is correctly shown as `اِفْتَحْ يَدَيْكَ`. All audits passed.
- Lesson **10** is complete against PDF pages **41–43**: **4 public cards, 4 private source rows, 8 wrapped tables**. It covers nominal and verbal sentences, complete/incomplete verbs, verbs of beginning, and verbs of approximation/hope, with the complete i'rāb of `أَخَذَ الطَّالِبُ يَكْتُبُ` and the visible Qur'anic example restored. All audits passed.
- Lesson **11** is complete against PDF pages **43–48**: **7 public cards, 7 private source rows, 21 wrapped tables**. Five old generated/template cards were replaced by source-backed coverage of `الْمُبْتَدَأُ وَالْخَبَرُ`, definiteness, ordering, deletion, types of predicate, five complete i'rāb examples, and predicate agreement. Three visible Qur'anic examples were restored. Data, harakat, provenance, desktop and mobile audits passed with zero findings.
- Lesson **12** is complete against PDF pages **48–52**: **5 public cards, 5 private source rows, 16 wrapped tables**. The lesson covers `الْمَفْعُولُ فِيهِ`, built and declinable adverbials, substitutes for the adverbial, `قَبْلُ وَبَعْدُ`, and `لَوْ`; five visible Qur'anic citations and six complete i'rāb analyses were restored. All data and desktop/mobile audits passed.
- Lesson **13** is complete against PDF pages **52–54**: **4 public cards, 4 private source rows, 9 wrapped tables**. It covers the four particles that govern one imperfect verb, jussive by request, lamentation, and `آهِ`; nine visible Qur'anic citations and both complete i'rāb blocks were restored. All data and screen audits passed.
- Lesson **14** is complete against PDF pages **55–59**: **3 cards, 3 source rows, 12 wrapped tables and 8 Qur'anic citations**. It covers conditional `إِذَا`, all eight source cases requiring fā' in the answer, three full i'rāb analyses and nisba from tā' marbūṭa.
- Lesson **15** is complete against PDF pages **60–65**: **7 cards, 7 source rows, 18 wrapped tables and 12 Qur'anic citations**. It covers two-verb conditional operators, all four condition/answer combinations, both kinds of `كَمْ`, `حَتَّى`, imperative-name `هَا`, deletion in `يَكُنْ` and the diminutive.
- The source combines lessons **16 and 17** under one heading on PDF page 65. Lesson 16 contains the shared introduction through the line before `ثَانِيًا: بَابُ أَفْعَلَ`; lesson 17 begins at that printed subheading.
- Lesson **16** is complete against PDF pages **65–68**: **6 cards, 6 source rows, 14 wrapped tables and 1 Qur'anic citation**. It covers bare/augmented verbs, the six triliteral patterns, classes of augmented triliteral, `فَعَّلَ` and derivatives, non-triliteral derivatives and quadriliteral imperfect prefixes.
- Lesson **17** is complete against PDF pages **68–73**: **9 cards, 9 source rows, 19 wrapped tables and 5 Qur'anic citations**. It covers `أَفْعَلَ` and derivatives, `أَعْطَى`, `أَصْبَحَ`, `أَوْشَكَ`, `وَلَوْ`, initial lām, indefinite `مَا`, deletion of hamza in `ٱبْنٌ`, and the final i'rāb. The author's closing prayer was preserved as closing source material and was not turned into a grammar rule.
- Final Book 3 state: **89 cards, 89 private source rows, 206 wrapped tables and 50 Qur'anic display blocks**. There are no missing harakat, translations, sources, invalid pages, duplicate order values, malformed tables, mojibake, source/public mixing or unclear placeholders.
- All **51 complete lesson screen states** (17 desktop, 17 tablet and 17 mobile) passed with zero findings. All 50 Qur'anic blocks display in the official local QPC Uthmanic Hafs font, black, centered, RTL and without clipping.
- Full retained report: `docs/MEDINA_RULES_BOOK3_FINAL_AUDIT_20260813.md`.
- Current stop point: Book 3 is complete. Do not open or process Book 4 without the owner's new explicit permission.

### Book 2 sequential audit progress

- Lesson **1** is complete against PDF pages **2–7** of `Podrobny_Sharkh_2_tom.pdf` only.
- The five existing public IDs were preserved. The unrelated `الِاسْمُ الْمَنْقُوصُ` card was replaced in place with the source-backed `مَوَاضِعُ كَسْرِ هَمْزَةِ إِنَّ` rule.
- The remaining cards now cover the full source explanations of `إِنَّ وَأَخَوَاتُهَا`, `ذُو` (forms, five-name condition, and `نَعْتٌ`/`خَبَرٌ` distinction), `أَمْ` versus `أَوْ`, and `مِائَةٌ وَأَلْفٌ`, including the source's writing/reading note.
- Lesson 1 final state: **5 public cards, 5 non-empty fully vocalized `rule_ar` values, and 10 private verbatim source rows**. All source rows identify only `Podrobny_Sharkh_2_tom.pdf` with PDF pages 2–7.
- The Book 2 public audit after lesson 1 found no malformed punctuation, duplicated Arabic marks, unbalanced markup, table translation gaps, Arabic examples without Russian translations, or missing `rule_ar` within lesson 1.
- Lesson **2** is complete against PDF pages **8–10**. Its three original IDs were preserved and one source-backed card was added for `حَذْفُ هَمْزَةِ ابْنٍ بَيْنَ عَلَمَيْنِ`.
- Lesson 2 final state: **4 public cards, 4 fully vocalized `rule_ar` values, and 6 private source rows**. The corrected cards cover the type and government of `لَيْسَ`, all ten source forms, added `بِـ` with its restriction, obligatory fronting with `إِنَّ` and `لَيْسَ`, and the `ابْنٌ → بْنُ` note.

## Обязательный протокол сверки 1-го тома

Этот раздел имеет приоритет над прежними краткими описаниями процесса, если между ними обнаружится расхождение.

- Работать только с `Sharkh_na_1_tom_Med_kursa.pdf` как главным и единственным доказательным источником содержания правил для 1-го тома.
- Обрабатывать уроки строго последовательно: **1 → 23**.
- Для каждого урока сначала полностью определить его границы в шархе и прочитать весь материал урока, включая продолжение объяснения на следующей странице.
- Извлекать все действительно объясняемые автором учебные положения: نحو, صرف, частицы, местоимения, формы слов, исключения и существенные замечания.
- Не ориентироваться только на наличие слова `قاعدة`: правило может быть сформулировано в обычном объяснительном тексте.
- Не добавлять правила из собственных знаний модели. Каждое созданное правило должно иметь конкретный подтверждающий фрагмент из этого урока шарха.
- Для каждого правила сохранять раздельно:
  - `rule_ar` — краткую и точную арабскую формулировку правила с полной корректной огласовкой;
  - `source_text` — дословный оригинальный фрагмент шарха без исправлений, нормализации и добавления харакатов;
  - страницу или диапазон страниц источника.
- `rule_ar` и `source_text` нельзя смешивать ни при хранении, ни при отображении, ни при подготовке миграций.
- Если несколько фрагментов شرح относятся к одному правилу, не создавать искусственно несколько дубликатов: объединять их в одно правило, сохраняя все соответствующие исходные фрагменты и страницы.
- После извлечения отдельно проверять грамматику и харакаты `rule_ar`, не изменяя `source_text`.
- Затем сравнивать результат с текущими данными приложения и для каждого элемента определять один из статусов:
  - совпадает;
  - частично совпадает;
  - отсутствует;
  - лишнее;
  - находится в неправильном уроке;
  - содержит ошибку в арабском тексте;
  - содержит ошибку в харакатах;
  - содержит смысловую ошибку.
- Перед любыми изменениями изучить существующую схему Supabase и код, который использует эти данные. Не создавать миграцию только потому, что не найдено поле с ожидаемым названием: сначала проверить существующие таблицы, колонки, связи и API.
- Все изменения в Supabase делать только после сверки соответствующего материала с шархом.
- Не удалять спорные существующие данные без подтверждения источником.
- После каждого урока составлять краткий отчёт: какие страницы прочитаны, какие правила найдены, что уже было в приложении, что добавлено, исправлено или перенесено и какие элементы оставлены без изменений.
- После краткого отчёта продолжать следующий урок самостоятельно, не запрашивая отдельного разрешения, если нет объективной блокировки или спорного решения, которое невозможно подтвердить источником.

## Book 1 controlling workflow — completed 2026-08-12

The completed **Мединский курс (Том 1)** verification followed this strict lesson-by-lesson workflow against the **Arabic sharh**.

Required order:

1. Take the Arabic sharh for Book 1 as the controlling source.
2. Verify lesson 1 completely.
3. If there are discrepancies, fix only lesson 1.
4. Report briefly to the owner:
   - what the sharh contains;
   - what the app currently contains;
   - what matched;
   - what was missing, extra, or wrong;
   - what was corrected.
5. Then move to lesson 2 and repeat the same process.
6. Continue sequentially through all Book 1 lessons. Do not jump ahead.

The owner explicitly asked for short per-lesson reports and for the work to continue through lesson 23 without a separate permission request after each report.

## Book 1 source priority

The sole controlling and evidentiary source for extracting and validating Book 1 rules is:

`C:\Users\user\Desktop\Мединский курс\Первый том\Sharkh_na_1_tom_Med_kursa.pdf`

The supplied Russian translation and the additional teacher explanations remain archived project references, but they must not establish, replace, or prove a Book 1 rule during this verification pass. A rule may be added or changed only when the Arabic sharh itself contains the supporting fragment.

## Quality rules for Medina rule cards

- Preserve the lesson structure from the sharh.
- Do not add unrelated rules into a lesson.
- Remove only content that is unrelated to the lesson’s rules.
- For each lesson, read the **whole sharh lesson**, not only lines explicitly marked `قاعدة`.
- Extract all educational rules: نحو, صرف, word/particle usage, forms, exceptions, and important author notes.
- A rule may be explained in ordinary text; do not skip it just because it is not labelled as a rule.
- Store the formulated rule in Arabic separately as `rule_ar`.
- `rule_ar` must be short, clear, faithful to the source meaning, and fully vocalized with harakat.
- Store the original source fragment separately as `source_text`, without corrections or rewriting.
- Never mix `source_text` and `rule_ar`. This is a hard requirement.
- Arabic terms and examples must have readable harakat where the rule requires them.
- Arabic text must remain visually clear and larger than ordinary inline Russian text.
- Every Arabic rule title should include a Russian meaning in parentheses.
- Separate Arabic examples and Russian explanations clearly; avoid cramped mixed lines.
- Use cards, tables, and compact schemes when they help the student understand the rule.
- Do not invent unreadable source text. If a source place is objectively unreadable, mark it rather than guessing.
- After each lesson fix, run the Medina rules audit before committing/deploying.

## Resolved Book 1 lesson 14 issue

During a preliminary check, lesson 14 of Book 1 showed discrepancies against the Arabic sharh. They were resolved when the sequential workflow reached lesson 14; the details below are retained as an audit record.

Findings to remember:

- The sharh lesson 14 contains:
  - `إِضَافَةُ الْأَسْمَاءِ إِلَى ضَمِيرَيِ الْمُخَاطَبِينَ وَالْمُتَكَلِّمِينَ: ـكُمْ، ـنَا`
  - `نَحْنُ` and `أَنْتُمْ`
  - `أَيٌّ`
  - `ضَمِيرُ الْمُخَاطَبِ الْمُتَّصِلُ بِالْفِعْلِ الْمَاضِي`: `ذَهَبْتَ، ذَهَبْتِ، ذَهَبْتُمْ، ذَهَبْتُنَّ`
  - `الْعَلَمُ الْأَعْجَمِيُّ`
- The current app lesson 14 had an unrelated `نَعْتُ الْمُضَافِ الْمَعْرِفَةِ` card.
- The current app had `ذَهَبْتُمْ وَذَهَبْنَا`, but the sharh lesson is about second-person past forms, not `ذَهَبْنَا`.
- Some “Как применять” helper text in that lesson was copied from unrelated rule templates and must be corrected when lesson 14 is reached.

## Book 1 sequential audit progress — 2026-08-12

- Lessons **1–23 are complete**. Every lesson was read from its first line through its final continuation, corrected through tracked migrations, applied to Supabase, and read back for verification.
- Verified PDF page boundaries: L1 3–4; L2 5; L3 6–7; L4 8; L5 9; L6 10; L7 11; L8 12; L9 13; L10 14–15; L11 16; L12 17–18; L13 19–22; L14 23–25; L15 26–27; L16 28; L17 29; L18 30–31; L19 32; L20 32; L21 33–34; L22 35–36; L23 36.
- The preliminary lesson 14 issue above is resolved: PDF pages 23–25 now produce exactly five source-backed cards; the unrelated `نَعْتُ الْمُضَافِ الْمَعْرِفَةِ` card was removed.
- Lesson 15 boundaries are PDF pages 26–27. Its verified blocks are detached pronouns, the four forms of `كَافُ الْمُخَاطَبِ`, subject endings attached to the past verb, and `قَبْلَ وَبَعْدَ`.
- The sharh combines lessons **16 and 17** under one heading on PDF pages 28–29. Page 28 contains `الْمُبْتَدَأُ وَالْخَبَرُ` and is stored under lesson 16; page 29 contains indication to non-rational plurals plus the complete plural-word list and is stored under lesson 17.
- Lessons **16–17** have been corrected, applied to Supabase, and read back with their private source rows. Two duplicated or non-source-backed generated cards were removed.
- The sharh combines lessons **19 and 20** on PDF page 32 and lessons **22 and 23** on PDF pages 35–36; the rules are stored under the lesson matching the actual subsection content.
- Final Book 1 state: **70 public rule cards across 23 lessons** and **147 private provenance rows**. Every card has a non-empty, fully vocalized `rule_ar` and at least one separate verbatim `source_text` row. Public roles cannot read `rule_sources`.
- Final automated checks found no missing `rule_ar`, missing sources, invalid page ranges, duplicate source ordering, malformed punctuation, duplicate Arabic marks, mojibake, unbalanced markup, lesson sort gaps, or titles missing Russian meanings.
- Production and local UI QA ultimately covered all 23 lessons on desktop and mobile. Cards and tables have no unhandled horizontal overflow; main Arabic rules render at 42 px on desktop / 29 px on mobile, examples at 36 px / 25 px, table Arabic at 24 px / 20 px, and Arabic in compact card labels at 18 px.

- Lesson **4** is complete against PDF pages **13–20**: **9 public cards, 9 fully vocalized `rule_ar` values, 9 private verbatim source rows, 21 Qur'anic display blocks and 13 wrapped tables**. All 25 source placeholders were resolved from the PDF/QPC corpus; the complete `الْبَدَلُ`, `لَا النَّافِيَةُ لِلْجِنْسِ` and sisters-of-`إِنَّ` structures, examples and i'rāb were restored. Existing IDs 1804–1812 were preserved. Data/provenance/harakat/translation checks and production desktop/tablet/mobile screen audits passed with zero findings.
- Lesson **5** is complete against PDF pages **21–23**: **6 public cards, 6 fully vocalized `rule_ar` values, 6 private verbatim source rows, 1 Qur'anic display block and 6 wrapped tables**. The unsupported exhortation meanings were removed from the legacy `لَوْلَا`/`لَوْمَا` titles, the exact `امْتِنَاعٌ لِوُجُودٍ` treatment was restored, and the hamzat-al-waṣl question examples were checked character by character. Existing IDs 1813–1818 were preserved. Data/provenance/harakat/translation checks and production desktop/tablet/mobile screen audits passed with zero findings.
- Lesson **6** is complete against PDF pages **24–28**; only the upper continuation on page 28 belongs to lesson 6, while lesson 7 begins below it. The lesson now has **6 public cards, 6 fully vocalized rule_ar values, 6 private verbatim source rows, 5 Qur'anic display blocks and 4 responsive tables**. Six meaningful OCR placeholders were restored from the PDF (إِذَا الْفُجَائِيَّةُ, both ظَنَّ verses and both دَخَلَ verses); the seventh trailing placeholder was confirmed to be a decorative separator and removed rather than invented. The DOC extraction error فََعِلٌ was corrected to the PDF-confirmed source form فَعِلٌ. Existing IDs 1819–1824 were preserved. Data/provenance/harakat/translation checks and production desktop/tablet/mobile screen audits passed with zero findings.

- Lesson **7** is complete against PDF pages **28–31**; lesson 8 begins only after the final عَسَى analysis on page 31. The lesson has **5 public cards, 5 fully vocalized rule_ar values, 5 private verbatim source rows, 1 Qur'anic display block and 8 responsive tables**. The مَا الْمَصْدَرِيَّةُ verse was restored from the PDF/QPC corpus. PDF-confirmed DOC extraction artifacts were corrected only in source transcription (اِصْفاَرَّ → اِصْفَارَّ, duplicated ḍamma on يَحْمَارُّ, a stray table pipe before رَأَى, and ناِقصَةٌ → نَاقِصَةٌ). Existing IDs 1825–1829 were preserved. Data/provenance/harakat/translation checks and production desktop/tablet/mobile screen audits passed with zero findings.

- Lesson **8** is complete against PDF pages **31–35**; page 36 is lesson 9. The lesson has **6 public cards, 6 fully vocalized rule_ar values, 6 private verbatim source rows, 6 Quranic display blocks and 7 responsive tables**. All six meaningful verse placeholders were restored. The stray table pipe before نَفْيُ الْمَاضِي and the trailing decorative separator after فَتْحُ يَاءِ الْمُتَكَلِّمِ were removed as non-text artifacts. PDF-confirmed alif-vocalization errors in the DOC extraction of عَصَايَ, فَتَايَ and دُنْيَايَ were corrected in source transcription. Existing IDs 1830–1835 were preserved. The complete four-particle نَوَاصِبُ الْفِعْلِ الْمُضَارِعِ treatment, all three إِذَنْ conditions and both full grammatical-analysis blocks were retained. Data/provenance/harakat/translation checks and production desktop/tablet/mobile screen audits passed with zero findings.
- Lesson **9** is complete against PDF pages **36–41**; page 42 starts lesson 10. The sharh contains **11 independent topics**, because the legacy card at sort order 10 had incorrectly merged مِنْ التَّبْعِيضِيَّةُ with الْمُنَادَى الْمُضَافُ إِلَى يَاءِ الْمُتَكَلِّمِ. The rebuilt lesson therefore has **11 public cards, 11 fully vocalized rule_ar values, 11 private verbatim source rows, 9 Qur'anic display blocks and 10 responsive tables**. Existing IDs 1836–1845 were preserved and exactly one new row (ID 2003) was created for the separated vocative rule. Static data/provenance/harakat/translation checks and production desktop/tablet/mobile screen audits passed with zero findings.
- Lesson **10** is complete against PDF pages **42–44**; page 45 starts lesson 11. The two legacy cards were decomposed according to six independent sharh headings: pronoun definition/divisions, attached pronouns, detached pronouns, pronoun ranks, five mandatory positions of a detached accusative pronoun, and joining/separating two accusative pronouns. The lesson now has **6 public cards, 6 fully vocalized rule_ar values, 6 private source rows, 1 Qur'anic display block and 9 responsive tables**. IDs 1846 and 1847 remain attached to the general-pronoun and ranks entities; four new rows (IDs 2004–2007) cover the independently headed omitted material. The PDF-confirmed DOC artifacts in يَسْأَلُنِي and واحدة and the missing Q1:5 fragment were corrected only in source transcription. Data/provenance/harakat/translation checks and production desktop/tablet/mobile audits passed with zero findings; the mobile top and final wide table were also inspected manually.
- Lesson **11** is complete against PDF pages **45–50**; page 51 starts lesson 12. The lesson now has **7 public cards, 7 fully vocalized rule_ar values, 7 private source rows, 10 displayed Qur'anic blocks representing 9 distinct source excerpts, and 7 responsive tables**. The four legacy IDs 1848–1851 were preserved; three new rows (IDs 2008–2010) separately cover مَصْدَرُ الْهَيْئَةِ, الْمَصْدَرُ الْمِيمِيُّ and the complete إِعْرَاب. All eight substitutes for the masdar, all one-time/manner/mīmī formation conditions, examples and every i'rāb line were retained. Nine source placeholders were restored from the PDF/QPC corpus; only PDF-confirmed DOC transcription artifacts were corrected. Static data/provenance/harakat/translation checks plus production desktop/tablet/mobile and manual mobile screenshot review passed with zero findings.
- Lesson **12** is complete against PDF pages **51–53**. Its final i'rāb continuation occupies the top of page 53 before lesson 13 begins, so the source boundary was corrected from the earlier page-52 assumption. The lesson has **3 public cards, 3 fully vocalized rule_ar values, 3 private source rows and 2 responsive tables**: الْمَفْعُولُ لَهُ with all three forms and i'rāb, لَا الْعَاطِفَةُ with conditions/examples/i'rāb, and the independently headed أَحْرُفُ التَّحْضِيضِ وَالتَّنْدِيمِ with both meanings and complete analysis. IDs 1852–1853 were preserved and one new row (ID 2011) was added. Static and live data QA plus desktop/tablet/mobile screen audits passed with zero findings.

- Lesson **13** is complete against PDF pages **53–56**; lesson 13 starts below the final lesson-12 analysis on page 53, and lesson 14 starts below the final surprise-form analysis on page 56. The two legacy blocks were separated into **5 source-backed cards**: التَّمْيِيزُ وَنَوْعَاهُ, تَمْيِيزُ الذَّاتِ, مَا يُلْحَقُ بِتَمْيِيزِ الذَّاتِ, تَمْيِيزُ النِّسْبَةِ and صِيغَتَا التَّعَجُّبِ. The lesson has **5 fully vocalized rule_ar values, 5 private source rows, 4 Qur'anic display blocks and 8 responsive tables**. IDs 1854 and 1855 were preserved for their original semantic entities; IDs 2012–2014 were added for the independently explained middle topics. Four verse placeholders and the PDF-confirmed DOC transcription artifacts in يُوَضِّحُ, الْمَكِيلَاتُ and الصِّدْقُ were resolved against the PDF/QPC text. Static/source/harakat/translation/live checks and production desktop/tablet/mobile audits passed with zero findings; the mobile top and final i'rāb cards were also inspected manually.
- Lesson **14** is complete against PDF pages **56–60**; it begins below the final lesson-13 analysis on page 56 and ends above the lesson-15 heading on page 60. The legacy fourth block had merged الرَّابِطُ فِي جُمْلَةِ الْحَالِ with the independently headed الْجَمْعُ عَلَى فِعَالٍ وَفُعُولٍ, so the rebuilt lesson has **5 source-backed cards, 5 fully vocalized rule_ar values, 5 private source rows, 6 exact QPC Qur'anic display blocks and 10 responsive tables**. IDs 1856–1859 were preserved and ID 2015 was added only for the separated plural-pattern topic. Six unreadable verse placeholders were restored; The compound ordinal heading الدَّرْسُ الرَّابِعَ عَشَرَ was preserved with its required fatḥa. PDF-confirmed DOC artifacts in مُتَأَخِّرًا, the malformed مسرورينَِ token and two ﷺ glyph positions were corrected only in source transcription. Static/source/harakat/translation/live checks and production desktop/tablet/mobile audits passed with zero findings; the mobile lesson list and final four-column table/Qur'an area were manually inspected.
- Lesson **15** is complete against PDF pages **60–64**; it starts below the lesson-14 ending on page 60 and ends above the lesson-16 heading in the lower part of page 64. All **9 legacy semantic topics** match independent sharh headings and retain IDs 1860–1868. The rebuilt lesson has **9 public cards, 9 fully vocalized rule_ar values, 9 private source rows, 6 exact QPC Qur'anic display blocks and 11 responsive tables**. Four exception verses and two أَلَا verses were restored; the trailing unreadable marker after دِيمَاسٌ was confirmed as a decorative separator and removed. PDF-confirmed DOC artifacts in مَا عَدَا / مَا خَلَا, غَيْرُ and الْوَاقِعُ were corrected only in source transcription. Static/source/harakat/translation/live checks and production desktop/tablet/mobile audits passed with zero findings; the mobile lesson list and final irregular-plural table were manually inspected.
- Lesson **16** is complete against PDF pages **64–68**; it starts below the lesson-15 ending on page 64 and ends above the lesson-17 heading on page 68. The two legacy blocks were separated into **4 source-backed cards**: تَوْكِيدُ الْأَفْعَالِ بِنُونِ التَّوْكِيدِ, أَحْكَامُ آخِرِ الْفِعْلِ الْمُؤَكَّدِ بِنُونِ التَّوْكِيدِ, إِعْرَابُ الْفِعْلِ الْمُؤَكَّدِ بِنُونِ التَّوْكِيدِ and بَلِ الِابْتِدَائِيَّةُ. Existing IDs 1869 and 1870 were preserved for their original semantic entities; IDs 2016 and 2017 were added for the independently explained ending and i‘rāb topics. The rebuilt lesson has **4 fully vocalized rule_ar values, 4 private source rows, 6 exact QPC Qur'anic display blocks and 7 responsive tables**. Six verse placeholders were restored. PDF-confirmed DOC artifacts in the lesson heading, لَا تُهْمِلَنَّ, أُدَخِّنُ, لِلدَّلَالَةِ, لِاتِّصَالِهِ and لَاهِيَةٌ were corrected only in source transcription. Russian labels were separated from Arabic, the connected title reading بَلِ الِابْتِدَائِيَّةُ and the final subject i‘rāb order were corrected in public instructional text. Static/source/harakat/translation/live checks and production desktop/tablet/mobile audits passed with zero findings; mobile top and final-card screenshots were manually inspected.
- Lesson **17** is complete against PDF pages **68–70**; page 71 contains only the author's closing praise and prayer and is not an instructional rule. All **5 legacy semantic blocks** match the sharh and retain IDs 1871–1875: the definition/division of الْمَمْنُوعُ مِنَ الصَّرْفِ, its three one-cause types, six proper-name types with all stated exceptions, three adjective types with their exception, and the complete inflection rules including all three مَعَانٍ analyses. The rebuilt lesson has **5 fully vocalized rule_ar values, 5 private source rows, no Qur'anic blocks and 8 responsive tables**. PDF-confirmed DOC extraction artifacts were corrected only in source transcription: ثلاثيًّا, زَافِر, هَابِل, الصِّفات / الصِّفَة, أَرْمَلٌ, فَعْلَانَ and ثُلَاثَ. Static/source/harakat/translation/live checks and production desktop/tablet/mobile audits passed with zero findings. The mobile lesson list, wide-table containment, horizontal in-card scrolling and the final nominative/accusative/genitive table were also inspected manually.

### Book 4 final audit checkpoint — 2026-08-14

- Book 4 is complete: **106 source-backed cards across 17 lessons, 106 separate private verbatim source rows, 122 responsive tables and 94 Qur'anic display blocks**.
- Every public card has a fully vocalized rule_ar, a Russian title meaning, source-backed examples/explanations and at least one private source_text with real PDF pages.
- Final static and live audits found zero missing translations, missing sources, invalid pages, duplicate sort values, malformed HTML, mojibake, unresolved placeholders or source/public mixing.
- All **94 Qur'anic blocks / 101 split fragments** exactly match the official local QPC Uthmanic Hafs corpus after whitespace-only normalization.
- All **51 production lesson states** (17 desktop, 17 tablet and 17 mobile), **318 card renders** and **366 table renders** passed with zero findings and zero browser errors. Upper and lower screenshots of every lesson on every viewport were also reviewed manually.
- The final pass corrected presentation-only omissions in lessons 1–3 by attaching each Russian meaning directly to its Arabic example/form and replacing unvocalized Arabic shorthand inside Russian prose. IDs, pages and private source_text were not changed.
- Permanent report: docs/MEDINA_RULES_BOOK4_FINAL_AUDIT_20260814.md.
