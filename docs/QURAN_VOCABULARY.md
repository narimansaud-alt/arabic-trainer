# 1000 самых частых слов Корана

Added 2026-09-02 as a separate vocabulary-only course. Its stable database
course_name is «1000 самых частых слов Корана». Do not rename this identifier
without migrating saved selections and daily plans.

## Source and limits

Primary source: [Quranic Arabic Corpus](https://corpus.quran.com/), Kais Dukes.
The [LREC 2010 paper by Dukes and Habash](https://aclanthology.org/L10-1190/)
describes morphological annotation, two-pass manual verification and collaborative
correction. This is an academically documented primary source, not a claim that
every annotation is error-free.

We imported the public [grouped lemma table](https://corpus.quran.com/lemmas.jsp?group=1)
and [verb table](https://corpus.quran.com/verbs.jsp) separately, and merged them by
descending group frequency. Twenty pages from each table provide a margin above
the 1,000-card cutoff. The 1,050-candidate snapshot and concordance counts are
versioned. Each candidate's reported frequency was checked against its QAC
concordance. This verifies internal consistency, **not** independent validation
against a second annotated corpus. At most the first 50 concordance examples are
retained, except the complete 80-occurrence sons/sonny group.

The final set is an editorial lexical study list, not an exact ranking of every
space-separated Quranic token. Group counts include inflected forms, and the QAC
grouped tables omit some affixes and pronouns. Identically spelled study forms
are combined, preserving their meanings and source references. Ties retain the
source table order, with non-verbs first. The final cutoff is 8 occurrences.
The twenty blocks contain exactly 50 cards each, ordered by frequency, not sura.

QAMAR (ABJADNLP 2026) and QuranMorph (Birzeit, 2025) were investigated as newer
research. Their full first-party datasets were not obtained; they were **not**
used to claim independent word-by-word verification.

Russian glosses are editorial study meanings prepared from the Arabic forms and
QAC concordance glosses. They are not a published Russian Quran translation,
tafsir, or an independently reviewed scholarly translation. Polysemy is kept where
needed; plural Arabic headwords receive plural Russian meanings. Further teacher
review can refine these meanings without replacing student progress.

## Source conditions

Quranic Arabic Corpus v0.4 © 2011 Kais Dukes; website © 2009–2017 Kais Dukes.
Source states GNU General Public License, with its
[published terms of use](https://corpus.quran.com/download/). The annotation
builds on the verified Tanzil Quran text. Attribute and link to QAC when using
the annotation. Its original downloadable annotation file must not be modified;
verbatim copies and substantial derivatives must retain the copyright notice.
This project's study cards are a separate derived dataset, clearly marked as
such, not an altered release of the QAC annotation. The original downloaded
HTML pages are cached unchanged under ignored .local/quran-frequency-source/;
the tracked source/context snapshots contain SHA-256 hashes and source URLs.
The application displays attribution and source links.

## Documented grouping corrections

The exact occurrence coordinates are in data/quran-vocabulary.json under
corrections. Stable sourceRank refers to the imported snapshot, not final rank.

- 132: exclude six diminutives «сынок» from the 80-token group; 74 «сыновья».
- 627 → 382: move eleven IV-form أَغْنَى occurrences into the matching IV group.
  Four I-form غَنِيَ occurrences remain below the cutoff.
- 777: exclude هَوَاء in 14:43 from هَوَى «страсть».
- 888: separate six أَغْلَال «оковы» from three غِلّ «злоба»; both below cutoff.
- 1010: separate three هَوِيَ «желать» and one أَهْوَى (IV) from four هَوَى
  «падать; склоняться». Those four combine with the identically spelled noun
  (ten occurrences), yielding a mixed-sense card with frequency 14.
- 21 + 633: combine identically written إِذَا with both meanings.
- 171 + 877: combine adjective صَالِح and the proper name, preserving both.

Ordinary Arabic spelling is used for keyboard input. In particular, remove the
QAC combining recitation sign U+0653 **before** NFC normalization; otherwise
مَاء incorrectly becomes مَآء. Genuine hamza/madda spellings, such as قُرْآن,
are explicitly retained. Weak/doubled verbs and other nonstandard table display
forms are corrected with visible overrides in the Russian editorial file.
Silent-alif exceptions such as هَذَا, ذَلِكَ, إِلَه, لَكِنْ and رَحْمَن are
explicit overrides, not a blanket insertion of full alif for dagger alif.
Standalone past forms VII–X include the initial kasra of hamzat al-wasl.

## Integration

- src/state.js: separate VOLUMES.quran entry. Never pretend it is Medina Tom 5.
- src/quran-vocab.js: source-aware dictionary and input hints.
- words.vocabulary_meta: rank, frequency, source rank, source URLs, input form,
  example coordinate and editorial note. Medina rows are unchanged.
- All ordinary modes use the active course's selected blocks. Fast mode can
  combine Medina lessons and Quran blocks. Daily tasks use the active course and
  the existing balanced quotas, Moscow date boundary and single daily goal.
- Book/rules tabs are hidden only in the vocabulary-only course.
- New dictionary and fetched fast-mode rows sort numerically by frequency rank;
  a text lesson number must not put block 10 before block 2 in the daily pool.
- Existing word-stat/favorite identity remains Arabic text, shared across
  collections when spelling is identical. No reset or migration of student stats.
- Copy/restore retains metadata, including present-form يَذَرُ and imperative
  تَعَالَ exceptions. Other verb prompts ask for one past «он» form.
- Quran MC distractors do not reuse overlapping Russian glosses. Exact matching
  Russian prompts accept either listed Arabic synonym of the same input form.
  This is intentionally scoped to this course.

The Edge Function allowlist, SQL allowlist, daily table constraint, score RPC,
leaderboard periods and personal score chart all include the exact new course.
The touched write RPCs explicitly revoke anon/authenticated execute:
historical REVOKE FROM public left Supabase's direct default grants intact.
Application-level authentication and the server's service_role path remain.

## Rebuild, test and release

1. Frozen evidence: data/quran-frequency-source.json and data/quran-frequency-context.json.
2. Editorial input: data/quran-vocabulary-ru.txt (sourceRank|Russian|Arabic override).
3. Run node scripts/build-quran-vocabulary.mjs, then node scripts/build-quran-seed.mjs.
4. Run node scripts/test-quran-vocabulary.mjs plus the existing training,
   daily-goal, leaderboard, mobile-layout and release checks.
5. Test both migrations with scripts/check-quran-database.sql in one transaction
   ending in **ROLLBACK**. The SQL test creates only an isolated fixture account.
6. Apply 20260902090000_support_quran_learning_course.sql, then
   20260902090100_add_quran_frequency_words.sql. Seed upserts preserve row IDs.
7. Deploy api-v2 with JWT verification still enabled, then commit/push the client
   to main. Legacy api is NOT redeployed in this release: old clients have no
   Quran entry point and retain their existing service-role write path. Never
   expose tokens or change either endpoint's authentication settings.
8. Smoke-test public data count, 20 blocks, dictionary, all training selectors,
   input hints, single-day quotas and all score periods.

Do not blindly rerun the online importer: it assigns snapshot source ranks.
For a future source refresh, preserve/reconcile source URLs and re-review all
editorial overrides. The importer and context checker are separate scripts.

Rollback: first remove/hide the Quran entry points with a client rollback.
Leave the additive metadata column, words, allowlist and already-earned scores
in place. Do not delete student data or re-open anonymous write privileges.
Stop release if the dictionary count differs from 1,000, any block differs from
50, legacy course counts change, protected writes fail, scores disappear from
any period, or mobile controls overflow. No separate staging database is
configured; local browser QA and rollback-only SQL checks precede live rollout.
