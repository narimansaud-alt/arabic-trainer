# Medina rules — Book 2 final audit (2026-08-13)

## Source and database result

- Lessons 1–31 were read and processed from both supplied Arabic sharhs:
  - `Podrobny_Sharkh_2_tom.pdf` — 80 pages;
  - `Sharkh_na_2_tom_Med_kursa.pdf` — 62 pages.
- Final public state: 148 rule cards across 31 lessons.
- Final provenance state: 140 verbatim source rows from the 80-page sharh and 150 verbatim source rows from the 62-page sharh.
- Every provenance row has non-empty literal `source_text` and a real PDF page.
- The 80-page sharh supports all 31 lessons.
- The 62-page sharh supports lessons 1–11 and 13–31. Its lesson 12 boundary contains no corresponding weekday rule block, so no second-source row was invented.
- Shared rules were merged without duplicate public cards; distinct source-backed examples from either sharh were retained.
- All lesson migrations were applied to the working Supabase and read back.

## Application rendering corrections

- Adjacent Arabic fragments in formulas now render as one isolated RTL expression, including arrows and operators.
- Existing table wrappers are no longer wrapped again; the nested “frame inside a frame” defect is removed.
- Arabic and Russian parts of lesson/card titles render on separate readable lines.
- The outline selector no longer constrains nested Arabic title spans to the number-column width.
- Arabic table headings are larger on narrow screens.

## Complete screen audit

- Desktop: 31/31 lessons clean.
- Mobile: 31/31 lessons clean.
- Audited cards: 148 in each viewport.
- Result: zero detected overflows, nested table wrappers, malformed RTL formula ordering, missing title translations, undersized/weak Arabic text, unscrollable wide tables, or browser-console errors.
- Representative visual inspection included the complete pronoun tables in lesson 8 and the mobile command-form table in lesson 27.

## Next stage

Book 2 is complete. The active source task is now Book 3, processed strictly lesson by lesson from `Sharkh_Medinskiy_3.pdf` / `Sharkh_Medinskiy_3.doc`, with a migration, live read-back, short report, and screen audit for every completed lesson.
