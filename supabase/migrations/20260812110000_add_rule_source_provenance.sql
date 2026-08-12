-- Preserve formulated Arabic rules separately from verbatim sharh evidence.
-- One rule may have multiple source fragments, each with its own PDF page range.

begin;

alter table public.rules
  add column if not exists rule_ar text;

create table if not exists public.rule_sources (
  id bigserial primary key,
  rule_id bigint not null references public.rules(id) on delete cascade,
  source_document text not null,
  source_text text not null,
  source_page_from integer not null,
  source_page_to integer not null,
  sort_order integer not null default 1,
  created_at timestamp with time zone default now(),
  constraint rule_sources_source_text_not_blank
    check (btrim(source_text) <> ''),
  constraint rule_sources_page_from_positive
    check (source_page_from > 0),
  constraint rule_sources_page_range_valid
    check (source_page_to >= source_page_from),
  constraint rule_sources_rule_sort_unique
    unique (rule_id, sort_order)
);

create index if not exists rule_sources_rule_sort_idx
  on public.rule_sources (rule_id, sort_order, id);

alter table public.rule_sources enable row level security;

-- Source excerpts are audit evidence, not public learning content.
-- RLS remains enabled without public policies; privileged server/database
-- access can verify them without exposing verbatim excerpts to the client.
revoke all on public.rule_sources from anon, authenticated;

comment on column public.rules.rule_ar is
  'Concise source-faithful Arabic formulation with fully checked vocalization; never stores verbatim source text.';

comment on table public.rule_sources is
  'Private verbatim source fragments kept separately from rules.rule_ar for provenance and model verification.';

comment on column public.rule_sources.source_text is
  'Verbatim fragment from the source document without correction, normalization, or added harakat.';

commit;
