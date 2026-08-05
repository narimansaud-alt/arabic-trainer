# Arabic Trainer agent context

Before changing this project, read `docs/PROJECT_KNOWLEDGE.md`.

Runtime summary: static HTML/CSS/vanilla JavaScript PWA + Supabase database/Edge Function + Cloudflare deployment from GitHub `main`. Verb grammar is a static learning section inside the Medina rules; the client has no standalone conjugation mode.

Project rules:

- Production is deployed from GitHub `main`; Cloudflare starts an automatic deploy after a successful push.
- Never commit service-role keys, access tokens, browser sessions, passwords, `.env` files, `.dev.vars`, or files under `.local/`.
- The Supabase anon key is intentionally public/read-only and its canonical copy is in `src/api.js`; do not duplicate it in tracked documentation.
- Password persistence in `localStorage` is intentionally retained by the owner. Do not change that behavior unless explicitly requested.
- Do not modify rules, dictionary data, or book assets unless the owner explicitly includes those sections in the request.
- Preserve unrelated local files and untracked directories. Stage only files changed for the current task.
- For database changes, add a timestamped migration under `supabase/migrations/`, apply it to Supabase, and keep the migration in Git.
- For releases requested by the owner, verify syntax and `git diff --check`, commit only the intended files, and push `main` without a separate confirmation round.

Machine-local operational notes are stored in `.local/ARABIC_TRAINER_PRIVATE_NOTES.md` and are intentionally ignored by Git.
