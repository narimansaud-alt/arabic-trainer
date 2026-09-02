# Частые слова Корана — подборка Understand Quran

Current content: 2026-09-03, revision `uqa-85-2020-ru-v1`.

## Active source and editorial rules

- Primary selection: [85% of Qur’anic Words](https://download.understandquran.com/fileadmin/user_upload/ebooks/english/85_of_Quranic_words.pdf),
  Dr. Abdulazeez Abdulraheem, Understand Al-Qur’an Academy. Official
  [e-books catalogue](https://understandquran.com/e-books/).
- This is the corrected/updated edition of the older “80%” selection. The complete
  51-page PDF was visually read: printed vocabulary pages 7–43; contextual verb
  combinations on page 44; pages 45–48 are model conjugation appendices.
- Local source: .local/source-images/quran-academy/85-of-quranic-words.pdf.
  SHA-256: 3747d947c7a548b1f15ce12c4bc6d2d6dcc2f707103b8b5f2b6f40d21265f526.
- Independent Russian study meanings, checked against Arabic form and context.
  They are NOT an official Academy translation, a published Russian Quran
  translation, tafsir, or an independently certified scholarly review.
- Arabic lexical facts are adapted into the application's own cards. Do not
  reproduce the PDF's preface, explanatory chapters, illustrations or layout.
  The source PDF's copyright notice does not mean permission to republish it.
  Keep the PDF private and retain the public source attribution/link.
- Do not import an unverified Anki deck as the controlling source.

There are **759 cards, 16 blocks**: blocks 1–15 contain 50; block 16 contains 9.
These are study blocks in the source's topic/form order, NOT descending frequency.
Do not pad the selection to 1,000 or claim that memorizing these cards guarantees
85% comprehension. “85%” is the source book's title/coverage methodology.

The source ledger covers 491 word/form/phrase entries and 272 verb rows.
Four identical Arabic headings are combined (ما, إله, ك, كاد), preserving their
meanings/references. Plurals and feminine forms explicitly given by the source
are represented separately where appropriate. Alternative spellings/case forms
remain one card: one comma-separated alternative is sufficient for an answer.

The six verb-table columns are grammatical reference forms, not six separately
counted frequent Quranic words. Each lexical verb row yields one past “he” card.
The exception يَذَرُ is taught in the present, with an explicit input hint; its
rare dictionary past وَذَرَ is retained only as source evidence. The 18 contextual
combinations from page 44 have their own verb-plus-preposition/word input hints.
Full paradigms on pages 45–48 are not additional vocabulary cards.

## Translation checks and corrections

Examples of deliberately avoiding misleading literal English transfer:

- تَوَّاب: accepting repentance; frequently repenting, according to referent.
  [QAC توب](https://corpus.quran.com/qurandictionary.jsp?q=twb), notably 2:160, 2:222.
- كَفَّرَ (II): expiate/remove sins, not “falsify”.
  [QAC كفر](https://corpus.quran.com/qurandictionary.jsp?q=kfr), 2:271, 4:31, 47:2.
- أَدْرَى (IV): make known, not merely know.
  [QAC دري](https://corpus.quran.com/qurandictionary.jsp?q=dry), 10:16, 33:63.
- حَيَّ (I): live; do not confuse its displayed present يَحْيَى with the
  greeting verb of another form. [QAC حيي](https://corpus.quran.com/qurandictionary.jsp?q=Hyy).
- الإنْجِيل: Инджиль (Евангелие), not a blanket label for the entire Bible.
- دَابَّة: singular “живое существо; животное”, despite the English plural gloss.
- Plural Arabic entries have plural Russian meanings where Russian allows them
  naturally; collective/mass meanings such as cattle, darkness, eyesight and
  wealth are not mechanically turned into unnatural Russian plurals.
- Russian prompts do not contain the Arabic solution. Construction punctuation,
  elongation and optional alternatives must not create false typing errors.
- Ordinary keyboard spelling is used; genuine hamza/madda retained. Initial
  hamzat-al-wasl kasra is supplied for standalone VII–X past forms. Source
  reference paradigms are simplified lexical notation, not a verbatim PDF OCR.

Primary editable ledgers: data/quran-academy-study-source.json and
data/quran-academy-verb-source.json. Built output:
data/quran-academy-vocabulary.json. Published DB metadata includes only dataset
revision, source pages/URL, sequence rank, grammatical kind and answer form.
“rank” is now a stable source-order position, not a frequency measurement.

## Identity, progress and UI

- Public title: «Частые слова Корана».
- Immutable internal course_name remains «1000 самых частых слов Корана».
  This is an identifier shared by score history, daily-goal constraints and
  cached selections, NOT a public claim about the current card count.
  Never rename it without an explicit cross-table migration.
- Existing student word-stat/favorite identity remains Arabic text, shared
  across collections when spelling is identical. No student table is changed.
  Exact shared headings retain their dictionary IDs too. A newly grouped or
  differently spelled card is a new identity; old stats remain stored.
- Cached daily plans containing the old dataset are rebuilt from the new words.
  Already completed category counts are reapplied from the server; the completed
  day and streak are not reset.
- Old unfinished local sessions that contain replaced Quran cards are not
  restored. The user is told to start a new session; previously saved scores and
  word levels remain. This check also covers a mixed-volume fast session.
- The one-time selection migration clears only legacy Quran block selections;
  Medina selections and quantities remain. New blocks are selected inside modes.
- All regular modes, fast cross-volume mode, difficult words and daily tasks
  continue to use the same vocabulary mechanisms. Writing hints specify
  past/present, plural/dual, attached pronoun, or a two-part construction.
- Daily goals keep 4 tasks/minute and balanced categories; 10 minutes = 13 new,
  14 review, 13 typing. A day still advances only once per Moscow calendar day.
- Compact dictionary cards show Arabic and Russian. Attribution is under the
  collapsed “Источник” disclosure; per-card frequency/source dumps are removed.
- Long alternatives wrap in both list/table modes at mobile widths.

## Rebuild and release

1. Edit the two source ledgers; read the relevant original pages completely.
2. Run node scripts/build-quran-academy.mjs.
3. Run node scripts/build-quran-academy-seed.mjs.
4. Run node scripts/test-quran-vocabulary.mjs, existing training/leaderboard
   regressions, node syntax checks, scripts/release-check.mjs and git diff --check.
5. Run node scripts/qa-quran-vocabulary.mjs against a local HTTP server (port 8767
   default). It tests all cards in list/table at 320/390/768/1280, input, the last
   partial fast-mode block, and isolated mocked protected writes.
6. Back up current words before applying the migration. Current backup:
   .local/backups/quran-before-academy-20260903.json (3,868 total reference rows,
   including the former 1,000 Quran entries). No credentials are included.
7. Migration: supabase/migrations/20260903003000_replace_quran_vocabulary_with_academy.sql.
   Run rollback-only and repeated-run ID tests before applying it. The migration
   touches public.words for this exact course only, and reverse-checks all other
   dictionary rows. There are no incoming FK references to public.words in the
   inspected production schema.
8. Verify exact live Arabic/Russian/block/revision values and unchanged Medina
   counts 602 / 581 / 768 / 917. Run browser QA with --live to read public
   reference data while all student writes stay mocked.
9. Commit intended files and push main; verify Cloudflare and CI. This source
   replacement does NOT require an Edge Function redeployment: backend course
   allowlists and score RPCs retain the same immutable ID.

Private reports/screenshots: .local/qa/quran/academy-*.
Production reverse comparison on 2026-09-03: 759 Quran cards; all 2,868 Medina
rows unchanged. The replacement retained 499 exact shared Arabic IDs, removed
501 obsolete Quran-only rows, and added 260 new headings. The old selection is
recoverable from the private backup above; no student records were deleted.

Stop release for a count/source mismatch, changed unrelated rows, changed shared
IDs, lost completed-day counts, failing input alternatives or mobile overflow.

Rollback: restore only this course's reference rows from the private backup,
with a scoped reviewed migration, and roll back the corresponding client.
Never delete student progress, scores, daily goals or favorites. Do not blindly
rerun the old rank-based seed: it can assign a different word to a current ID.

## Previous QAC collection — archived, no longer active

The earlier 1,000-card selection remains in data/quran-vocabulary.json and its
quran-frequency-source/context and quran-vocabulary-ru inputs as historical
evidence/recovery material. Its original builders and 20260902090100 seed are
archived workflows, NOT the active import path. Do not rerun them against this
collection. The source evidence is QAC (Kais Dukes) with its
[GPL terms](https://corpus.quran.com/download/); preserve that attribution for any
future reuse. The 20260902090000 support migration still provides course, daily
goal and leaderboard support. Historical details remain in Git history.
