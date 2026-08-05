-- Standalone data model for the "Arabic Dictionary" module.
-- It intentionally does not reuse the Medina course `words` table.

create table if not exists public.arabic_dictionary_roots (
  id uuid primary key default gen_random_uuid(),
  root_ar text not null,
  root_clean text not null,
  root_type text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint arabic_dictionary_roots_root_clean_key unique (root_clean),
  constraint arabic_dictionary_roots_root_ar_not_blank check (btrim(root_ar) <> ''),
  constraint arabic_dictionary_roots_root_clean_not_blank check (btrim(root_clean) <> '')
);

create table if not exists public.arabic_dictionary_words (
  id uuid primary key default gen_random_uuid(),
  root_id uuid references public.arabic_dictionary_roots(id) on delete set null,
  lemma_ar text not null,
  lemma_clean text not null,
  part_of_speech text not null default 'verb',
  form_id smallint,
  root_class text,
  bab text,
  transitivity text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint arabic_dictionary_words_lemma_ar_not_blank check (btrim(lemma_ar) <> ''),
  constraint arabic_dictionary_words_lemma_clean_not_blank check (btrim(lemma_clean) <> ''),
  constraint arabic_dictionary_words_part_of_speech_check check (part_of_speech in ('verb', 'noun', 'particle', 'adjective', 'adverb', 'phrase')),
  constraint arabic_dictionary_words_form_id_check check (form_id is null or form_id between 1 and 10),
  constraint arabic_dictionary_words_transitivity_check check (transitivity is null or transitivity in ('transitive', 'intransitive', 'both'))
);

create table if not exists public.arabic_dictionary_translations (
  id uuid primary key default gen_random_uuid(),
  word_id uuid not null references public.arabic_dictionary_words(id) on delete cascade,
  language_code text not null default 'ru',
  meaning text not null,
  sense_order smallint not null default 1,
  example_ar text,
  example_translation text,
  created_at timestamptz not null default now(),
  constraint arabic_dictionary_translations_meaning_not_blank check (btrim(meaning) <> ''),
  constraint arabic_dictionary_translations_language_code_check check (language_code ~ '^[a-z]{2,5}$'),
  constraint arabic_dictionary_translations_word_sense_key unique (word_id, language_code, sense_order)
);

create table if not exists public.arabic_dictionary_derivatives (
  id uuid primary key default gen_random_uuid(),
  word_id uuid not null references public.arabic_dictionary_words(id) on delete cascade,
  derivative_type text not null,
  value_ar text not null,
  value_clean text not null,
  source text not null default 'dictionary',
  created_at timestamptz not null default now(),
  constraint arabic_dictionary_derivatives_type_check check (derivative_type in ('masdar', 'active_participle', 'passive_participle', 'place_time', 'instrument', 'plural', 'other')),
  constraint arabic_dictionary_derivatives_source_check check (source in ('dictionary', 'algorithm')),
  constraint arabic_dictionary_derivatives_value_not_blank check (btrim(value_ar) <> '' and btrim(value_clean) <> '')
);

create table if not exists public.arabic_dictionary_preposition_meanings (
  id uuid primary key default gen_random_uuid(),
  word_id uuid not null references public.arabic_dictionary_words(id) on delete cascade,
  preposition_ar text not null,
  preposition_clean text not null,
  meaning_ru text not null,
  example_ar text,
  example_translation text,
  created_at timestamptz not null default now(),
  constraint arabic_dictionary_preposition_meanings_not_blank check (btrim(preposition_ar) <> '' and btrim(meaning_ru) <> '')
);

create table if not exists public.arabic_dictionary_bookmarks (
  username text not null,
  word_id uuid not null references public.arabic_dictionary_words(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (username, word_id),
  constraint arabic_dictionary_bookmarks_username_not_blank check (btrim(username) <> '')
);

create table if not exists public.arabic_dictionary_review_state (
  username text not null,
  word_id uuid not null references public.arabic_dictionary_words(id) on delete cascade,
  repetitions integer not null default 0,
  interval_days integer not null default 0,
  ease_factor numeric(4,2) not null default 2.50,
  due_at timestamptz not null default now(),
  last_reviewed_at timestamptz,
  updated_at timestamptz not null default now(),
  primary key (username, word_id),
  constraint arabic_dictionary_review_state_username_not_blank check (btrim(username) <> ''),
  constraint arabic_dictionary_review_state_repetitions_check check (repetitions >= 0),
  constraint arabic_dictionary_review_state_interval_check check (interval_days >= 0),
  constraint arabic_dictionary_review_state_ease_check check (ease_factor >= 1.30 and ease_factor <= 4.00)
);

create index if not exists arabic_dictionary_roots_root_clean_idx on public.arabic_dictionary_roots (root_clean);
create index if not exists arabic_dictionary_words_lemma_clean_idx on public.arabic_dictionary_words (lemma_clean);
create index if not exists arabic_dictionary_words_root_id_idx on public.arabic_dictionary_words (root_id);
create index if not exists arabic_dictionary_translations_word_id_idx on public.arabic_dictionary_translations (word_id);
create index if not exists arabic_dictionary_derivatives_word_id_idx on public.arabic_dictionary_derivatives (word_id);
create index if not exists arabic_dictionary_review_state_due_at_idx on public.arabic_dictionary_review_state (username, due_at);

alter table public.arabic_dictionary_roots enable row level security;
alter table public.arabic_dictionary_words enable row level security;
alter table public.arabic_dictionary_translations enable row level security;
alter table public.arabic_dictionary_derivatives enable row level security;
alter table public.arabic_dictionary_preposition_meanings enable row level security;
alter table public.arabic_dictionary_bookmarks enable row level security;
alter table public.arabic_dictionary_review_state enable row level security;

create policy "Public dictionary roots are readable" on public.arabic_dictionary_roots for select using (true);
create policy "Public dictionary words are readable" on public.arabic_dictionary_words for select using (true);
create policy "Public dictionary translations are readable" on public.arabic_dictionary_translations for select using (true);
create policy "Public dictionary derivatives are readable" on public.arabic_dictionary_derivatives for select using (true);
create policy "Public dictionary preposition meanings are readable" on public.arabic_dictionary_preposition_meanings for select using (true);

comment on table public.arabic_dictionary_words is 'Standalone Arabic Dictionary data. Never use this table for Medina course vocabulary.';
