# Arabic Trainer project knowledge

Last updated: 2026-08-14 (dictionary QA, stable PWA identity, and network resilience)

## Production and repositories

- Application stack: static HTML/CSS/vanilla JavaScript PWA, Supabase database and Edge Functions, Cloudflare hosting.
- The main application has no bundler requirement; browser scripts are loaded directly from `index.html`.
- The client has no standalone conjugation mode. Static verb lessons live inside the Medina rules section; the historical Qutrub worker source under `services/qutrub-worker/` is not loaded by the PWA.
- Workspace: `C:\Users\user\Desktop\arabic-trainer`
- GitHub: `https://github.com/narimansaud-alt/arabic-trainer.git`
- Production branch: `main`
- Hosting: Cloudflare, automatic deployment from `main`
- Cloudflare Worker/assets configuration: `wrangler.jsonc`
- Build step: `build.sh` replaces `__BUILD_HASH__` in `sw.js` with the Cloudflare commit hash so the PWA cache updates after deployment.

Stable PWA identity:

- Keep `manifest.json` `id` equal to `./`.
- Keep the full manifest name unchanged at the value enforced by the release check; changing it makes Android show an installed-app rename prompt.
- Keep short_name unchanged; it is the compact launcher label.
- `scripts/release-check.mjs` enforces these values before release.

Current release history:

- `29e74f1` - trainer logic and mobile controls
- `13f3a51` - in-app page reader and complete lesson rule previews
- `e249942` - dictionary singular/plural pairing
- `a740a75` - finalized Medina volume 1 rule import

## Supabase

- Project name: `arabic-quiz`
- Project ref: `vkdfthrvsafjmcmfcdic`
- URL: `https://vkdfthrvsafjmcmfcdic.supabase.co`
- Dashboard: `https://supabase.com/dashboard/project/vkdfthrvsafjmcmfcdic`
- Edge Function: `api` at `/functions/v1/api`
- Public client configuration: `src/api.js`
- Public anon key: stored only in `src/api.js`; it is restricted by RLS to public/read-only data.
- Service-role key: server-side only. Keep it in Supabase Edge Function secrets or approved local environment storage. Never place it in Git, tracked docs, browser logs, or chat output.

Network model:

- The public Supabase client reads reference data such as words, rules, announcements, and leaderboard data.
- Sensitive writes use `Api.call()` and the server-side `api` Edge Function.
- The Edge Function verifies username/password ownership and performs privileged database operations with the server-side service-role key.
- Error logging scrubs password, token, API key, and authorization fields before recording diagnostic data.

Authentication decision:

- Password persistence under the local key `arabic_auth` is intentionally retained at the owner's request.
- The password is sent only over HTTPS to the project's Edge Function for authentication and protected writes.
- This is a conscious security/usability trade-off. Do not silently change it.

## Application content

### Medina rules verification workflow

- Owner-requested Medina rules workflow is stored in `docs/MEDINA_RULES_KNOWLEDGE_BASE.md`.
- Before changing Medina rule content, read that file in addition to this project knowledge file.
- Current workflow status: Books 1, 2 and 3 are complete: 307 cards, 71 lessons and 526 private verbatim source rows. The final source/data/code audit and all 213 desktop/tablet/mobile lesson-screen states passed. All 55 displayed Qur'anic fragments exactly match the official QPC Uthmanic Hafs corpus and use the local Madinah-mushaf font. Do not begin Book 4 without a new explicit permission from the owner.
- Combined final report: `docs/MEDINA_RULES_FINAL_QA_20260813.md`.

### Medina volume 3

- Canonical course name: `Мединский курс (Том 3)`.
- Controlling source: `Sharkh_Medinskiy_3.pdf`, PDF pages 3–73 for lesson content.
- Lessons: 1–17.
- Final rule base: 89 cards, 89 private verbatim source rows, 206 responsive tables and 50 Qur'anic display blocks.
- Final audit report: `docs/MEDINA_RULES_BOOK3_FINAL_AUDIT_20260813.md`.
- All local data/provenance and desktop/tablet/mobile lesson-screen audits passed with zero findings. All 50 Book 3 Qur'anic fragments are exact QPC Uthmanic Hafs substrings and render in the local `Uthmanic Hafs` font.

### Medina volume 1

- Canonical course name: `Мединский курс (Том 1)`
- Lessons: 1-23
- Final rule base: 70 rule records across all 23 lessons (confirmed from live Supabase on 2026-08-13).
- Source rule archive migration: `supabase/migrations/20260804160000_replace_tom1_rules_archive.sql`
- `مَا/مَنْ` correction migration: `supabase/migrations/20260804180000_fix_ma_man_rule.sql`

### Dictionary

- Verified database state on 2026-08-04: 602 words covering lessons 1-22.
- Lesson 23 has no separate "new words" block in the supplied book, so no speculative lesson 23 vocabulary was added.
- Canonical pairing logic is in `src/dict.js`. Books 1-2 use Arabic form checks plus exact, source-verified irregular exceptions; the former broad Russian-similarity fallback was removed because it joined unrelated adjacent entries.
- On 2026-08-14, all 199 Book 3 plural metadata rows received Russian meanings agreeing with the displayed Arabic number in list mode. Eight residual Book 1-2 plural labels were refined in migration `supabase/migrations/20260814060000_fix_dictionary_russian_plural_meanings.sql`.
- The pairing correction removed exactly 13 false table pairs while retaining every previously displayed valid pair: 1 in Book 1 and 12 in Book 2.
- Pre-release screen QA covered all 69 dictionary lessons in Books 1-3, both list/table modes, and desktop/mobile widths (276 rendered states). No RTL, clipping, overflow, small-Arabic, blank-translation, browser-error, or known-false-pair findings remained.
- Recoverable pre-change export: `.local/backups/dictionaries-before-russian-plurals-20260813.json` (machine-local and intentionally ignored by Git).
- Active volume 3 dictionary import protocol: `docs/MEDINA_BOOK3_DICTIONARY_TASK.md`. Its controlling source is the lesson photographs in `C:\Users\user\Desktop\Мединский курс\Третий том\Фото словарь`; `C:\Users\user\Downloads\Облако Mail.zip` is a byte-identical control copy. Work must proceed lesson by lesson, with source-only extraction, a complete correction log, Supabase verification and screen verification of both dictionary modes before advancing.
- The volume 3 dictionary task is additive project context. It does not supersede or delete any previously stored Medina rules tasks or audit records.
- Volume 4 dictionary lesson 1 is sourced from the seven owner-supplied photographs of printed pages 154–160. Although the photographed heading says lesson 18, the owner explicitly mapped that complete block to application lesson 1. The verified result is 90 source rows and 109 displayed forms, including 19 singular/plural pairs with separate Russian plural meanings. Progress and the correction log are in `docs/MEDINA_BOOK4_DICTIONARY_PROGRESS.md`; migration: `supabase/migrations/20260814080000_import_book4_dictionary_lesson01.sql`.

### Book

- Source PDF: `books/ar_01_Lessons_in_Arabic_Language.pdf`
- In-app reader: 125 page images under `books/tom1-pages/`
- Page metadata: `src/state.js`
- Users can read page-by-page inside the app or open the original PDF separately.
- Volume 2 has its own reserved book configuration and must remain separate from volume 1.

## Trainer behavior

- Training modes include learn, Arabic typing, review, mix, and fast review.
- Review is always available for words in the selected lessons: due and weak words remain prioritized, while already completed words fill the queue when nothing is due.
- Arabic typing has educational and strict checking modes.
- Strict checking preserves distinct hamza forms and checks diacritics.
- Educational checking permits omitted vowel marks but does not collapse different Arabic letters.
- Slash-separated verb pairs and Arabic present forms in parentheses require both forms; the writing screen shows the required `past / present-future` input format.
- Arabic comma variants and non-verb Arabic parenthetical forms accept either variant. Tatweel used as an attachment marker is never required in typed answers.
- Session progress is tied to the active username and volume.
- Changing volumes clears the active training session to prevent state leakage.
- Attempts and correct answers are tracked separately.
- Every wrong answer automatically marks the word as difficult; the star button remains the explicit add/remove control, and later correct answers do not silently clear the mark.
- A word's review interval can increase at most once in a single training session; an error schedules a short retry interval.

## Database change procedure

1. Export or confirm a recoverable database backup before a mass data replacement.
2. Create a timestamped SQL migration under `supabase/migrations/`.
3. Scope updates by canonical `course_name` and textual `lesson_number` values.
4. Apply the migration through the authenticated Supabase SQL Editor or approved CLI credentials.
5. Confirm the result before deployment.
6. Commit the migration with the application changes and push `main`.

Recent schema/data migrations include:

- `20260803000000_increment_user_total_score.sql`
- `20260803001000_app_error_log.sql`
- `20260804000000_rules_display_metadata.sql`
- `20260804010000_rule_sections.sql`
- `20260804160000_replace_tom1_rules_archive.sql`
- `20260804180000_fix_ma_man_rule.sql`

## Deployment procedure

1. Verify modified JavaScript with `node --check`.
2. Run `git diff --check`.
3. Confirm that rules, dictionary, and book files are absent from the diff unless explicitly requested.
4. Stage only intended files.
5. Commit on `main` with a clear message.
6. Push `origin main`; Cloudflare starts the production deployment automatically.

## Secret handling

- Tracked documentation contains project identifiers and public endpoints, not privileged credentials.
- `.env*`, `.dev.vars*`, `.local/`, Supabase temporary files, backups, and Wrangler local state are ignored by Git.
- The machine-local reference file is `.local/ARABIC_TRAINER_PRIVATE_NOTES.md`.
- If a service-role key is rotated, update the Supabase Edge Function secret and the approved local secret manager. Do not update tracked source files.
