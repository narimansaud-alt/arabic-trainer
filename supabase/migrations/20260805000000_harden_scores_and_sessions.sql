create table if not exists public.user_sessions (
  token_hash text primary key,
  username text not null references public.users(username) on delete cascade,
  created_at timestamptz not null default now(),
  last_used_at timestamptz not null default now(),
  expires_at timestamptz not null
);

create index if not exists user_sessions_username_idx
  on public.user_sessions (username, expires_at);

create index if not exists user_sessions_expires_idx
  on public.user_sessions (expires_at);

alter table public.user_sessions enable row level security;
revoke all on public.user_sessions from anon, authenticated;
grant all on public.user_sessions to service_role;

alter table public.score_history
  add column if not exists event_id uuid;

create unique index if not exists score_history_event_id_uidx
  on public.score_history (event_id)
  where event_id is not null;

create table if not exists public.score_history_non_medina_archive_20260805
  (like public.score_history including all);

alter table public.score_history_non_medina_archive_20260805 enable row level security;
revoke all on public.score_history_non_medina_archive_20260805 from public, anon, authenticated;
grant all on public.score_history_non_medina_archive_20260805 to service_role;

insert into public.score_history_non_medina_archive_20260805
select * from public.score_history
where coalesce(course_name, '') !~ '^Мединский курс( \(Том [1-4]\))?$'
on conflict do nothing;

delete from public.score_history
where coalesce(course_name, '') !~ '^Мединский курс( \(Том [1-4]\))?$';

update public.score_history
set course_name = 'Мединский курс (Том 1)'
where course_name = 'Мединский курс';

update public.users u
set total_score = coalesce((
  select sum(sh.points)
  from public.score_history sh
  where sh.username = u.username
    and sh.course_name ~ '^Мединский курс \(Том [1-4]\)$'
), 0);

create or replace function public.increment_user_total_score(
  p_username text,
  p_points integer
)
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_total integer;
  v_points integer := coalesce(p_points, 0);
begin
  if v_points <= 0 then
    raise exception 'Negative or zero points not allowed: %', v_points using errcode = '22003';
  end if;

  if v_points > 500 then
    raise exception 'Points too large: %', v_points using errcode = '22003';
  end if;

  update public.users
  set total_score = coalesce(total_score, 0) + v_points
  where username = p_username
  returning total_score into v_total;

  if v_total is null then
    raise exception 'User not found: %', p_username using errcode = 'P0002';
  end if;

  return v_total;
end;
$$;

revoke all on function public.increment_user_total_score(text, integer) from public;
grant execute on function public.increment_user_total_score(text, integer) to service_role;

create or replace function public.log_user_score(
  p_username text,
  p_points integer,
  p_course_name text,
  p_event_id uuid
)
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_total integer;
  v_inserted integer;
begin
  if p_points <= 0 then
    raise exception 'Negative or zero points not allowed: %', p_points using errcode = '22003';
  end if;

  if p_points > 500 then
    raise exception 'Points too large: %', p_points using errcode = '22003';
  end if;

  if p_course_name !~ '^Мединский курс \(Том [1-4]\)$' then
    raise exception 'Unsupported course: %', p_course_name using errcode = '22023';
  end if;

  insert into public.score_history (username, course_name, points, event_id)
  values (p_username, p_course_name, p_points, p_event_id)
  on conflict (event_id) where event_id is not null do nothing;

  get diagnostics v_inserted = row_count;

  if v_inserted = 0 then
    select coalesce(total_score, 0) into v_total
    from public.users
    where username = p_username;
    return v_total;
  end if;

  update public.users
  set total_score = coalesce(total_score, 0) + p_points
  where username = p_username
  returning total_score into v_total;

  if v_total is null then
    raise exception 'User not found: %', p_username using errcode = 'P0002';
  end if;

  return v_total;
end;
$$;

revoke all on function public.log_user_score(text, integer, text, uuid) from public;
grant execute on function public.log_user_score(text, integer, text, uuid) to service_role;

create or replace function public.increment_user_daily_words(p_username text)
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_today date := (now() at time zone 'Europe/Moscow')::date;
  v_count integer;
begin
  update public.users
  set daily_words = case
        when last_count_date::date = v_today then least(coalesce(daily_words, 0) + 1, 30)
        else 1
      end,
      last_count_date = v_today
  where username = p_username
  returning daily_words into v_count;

  if v_count is null then
    raise exception 'User not found: %', p_username using errcode = 'P0002';
  end if;

  return v_count;
end;
$$;

revoke all on function public.increment_user_daily_words(text) from public;
grant execute on function public.increment_user_daily_words(text) to service_role;
