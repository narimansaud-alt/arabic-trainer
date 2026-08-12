# Medina rules knowledge base

This file preserves the owner’s working instructions for Medina-course rule work so context is not lost during conversation compaction.

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
- Production and local UI QA covered lessons 1, 14, 18, 21, 22, and 23. Cards and tables have no unhandled horizontal overflow; main Arabic rules render at 42 px on desktop / 29 px on mobile, examples at 36 px / 25 px, table Arabic at 24 px / 20 px, and Arabic in compact card labels at 18 px.
