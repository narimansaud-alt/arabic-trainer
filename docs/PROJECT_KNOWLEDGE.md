# Arabic Trainer project knowledge

Last updated: 2026-08-04

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
- Current active workflow: verify **Мединский курс (Том 1)** lesson by lesson against the Arabic sharh, starting from lesson 1, reporting briefly after each lesson before moving to the next.

### Medina volume 1

- Canonical course name: `Мединский курс (Том 1)`
- Lessons: 1-23
- Final rule base: 76 rule records across all 23 lessons.
- Source rule archive migration: `supabase/migrations/20260804160000_replace_tom1_rules_archive.sql`
- `مَا/مَنْ` correction migration: `supabase/migrations/20260804180000_fix_ma_man_rule.sql`

### Dictionary

- Verified database state on 2026-08-04: 602 words covering lessons 1-22.
- Lesson 23 has no separate "new words" block in the supplied book, so no speculative lesson 23 vocabulary was added.
- Table pairing includes explicit singular/plural or singular/collective pairs for demonstratives and pronouns.
- Canonical pairing logic is in `src/dict.js`.

### Book

- Source PDF: `books/ar_01_Lessons_in_Arabic_Language.pdf`
- In-app reader: 125 page images under `books/tom1-pages/`
- Page metadata: `src/state.js`
- Users can read page-by-page inside the app or open the original PDF separately.
- Volume 2 has its own reserved book configuration and must remain separate from volume 1.

## Trainer behavior

- Training modes include learn, Arabic typing, review, mix, and fast review.
- Arabic typing has educational and strict checking modes.
- Strict checking preserves distinct hamza forms and checks diacritics.
- Educational checking permits omitted vowel marks but does not collapse different Arabic letters.
- Session progress is tied to the active username and volume.
- Changing volumes clears the active training session to prevent state leakage.
- Attempts and correct answers are tracked separately.
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
