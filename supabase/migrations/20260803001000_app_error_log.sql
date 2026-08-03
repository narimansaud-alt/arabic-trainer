create table if not exists public.app_error_log (
  id bigserial primary key,
  created_at timestamptz not null default now(),
  username text,
  source text,
  message text not null,
  stack text,
  url text,
  user_agent text,
  app_version text,
  context jsonb,
  client_ip text,
  cf_ray text
);

create index if not exists app_error_log_created_at_idx
  on public.app_error_log (created_at desc);

create index if not exists app_error_log_username_created_at_idx
  on public.app_error_log (username, created_at desc);

alter table public.app_error_log enable row level security;

revoke all on public.app_error_log from anon, authenticated;
grant all on public.app_error_log to service_role;
grant usage, select on sequence public.app_error_log_id_seq to service_role;
