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
