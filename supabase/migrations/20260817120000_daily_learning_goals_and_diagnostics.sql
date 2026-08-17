-- Daily learning goals, streak completion, daily-goal leaderboard, and richer diagnostics.

alter table public.users
  add column if not exists daily_goal_minutes integer not null default 10,
  add column if not exists daily_goal_selected_at timestamptz,
  add column if not exists daily_goals_completed integer not null default 0,
  add column if not exists last_daily_goal_date date;

alter table public.users drop constraint if exists users_daily_goal_minutes_check;
alter table public.users
  add constraint users_daily_goal_minutes_check
  check (daily_goal_minutes in (5, 10, 20, 25, 30));

alter table public.users drop constraint if exists users_daily_goals_completed_check;
alter table public.users
  add constraint users_daily_goals_completed_check
  check (daily_goals_completed >= 0);

-- Preserve an existing legitimate streak when the new completion model starts.
update public.users
set last_daily_goal_date = last_activity::date
where last_daily_goal_date is null and last_activity is not null;

create table if not exists public.daily_goal_progress (
  username text not null references public.users(username) on delete cascade,
  goal_date date not null,
  course_name text not null,
  goal_minutes integer not null,
  target_tasks integer not null,
  new_target integer not null,
  review_target integer not null,
  typing_target integer not null,
  new_completed integer not null default 0,
  review_completed integer not null default 0,
  typing_completed integer not null default 0,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (username, goal_date),
  constraint daily_goal_progress_course_check
    check (course_name ~ '^Мединский курс \(Том [1-4]\)$'),
  constraint daily_goal_progress_minutes_check
    check (goal_minutes in (5, 10, 20, 25, 30)),
  constraint daily_goal_progress_targets_check
    check (
      target_tasks > 0
      and new_target >= 0
      and review_target >= 0
      and typing_target >= 0
      and new_target + review_target + typing_target = target_tasks
    ),
  constraint daily_goal_progress_completed_check
    check (
      new_completed between 0 and new_target
      and review_completed between 0 and review_target
      and typing_completed between 0 and typing_target
    )
);

create index if not exists daily_goal_progress_completed_idx
  on public.daily_goal_progress (goal_date desc, completed_at)
  where completed_at is not null;

alter table public.daily_goal_progress enable row level security;
revoke all on public.daily_goal_progress from public, anon, authenticated;
grant all on public.daily_goal_progress to service_role;

create or replace function public.ensure_user_daily_goal(
  p_username text,
  p_course_name text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_today date := (now() at time zone 'Europe/Moscow')::date;
  v_minutes integer;
  v_target integer;
  v_new integer;
  v_review integer;
  v_typing integer;
  v_row public.daily_goal_progress%rowtype;
begin
  if p_course_name !~ '^Мединский курс \(Том [1-4]\)$' then
    raise exception 'Unsupported course: %', p_course_name using errcode = '22023';
  end if;

  select daily_goal_minutes
    into v_minutes
  from public.users
  where username = p_username
  for update;

  if v_minutes is null then
    raise exception 'User not found: %', p_username using errcode = 'P0002';
  end if;

  v_target := v_minutes * 2;
  v_new := round(v_target * 0.20);
  v_review := round(v_target * 0.50);
  v_typing := v_target - v_new - v_review;

  insert into public.daily_goal_progress (
    username, goal_date, course_name, goal_minutes,
    target_tasks, new_target, review_target, typing_target
  ) values (
    p_username, v_today, p_course_name, v_minutes,
    v_target, v_new, v_review, v_typing
  )
  on conflict (username, goal_date) do update
  set course_name = excluded.course_name,
      updated_at = now()
  where public.daily_goal_progress.completed_at is null;

  select * into v_row
  from public.daily_goal_progress
  where username = p_username and goal_date = v_today;

  return to_jsonb(v_row);
end;
$$;

revoke all on function public.ensure_user_daily_goal(text, text) from public;
grant execute on function public.ensure_user_daily_goal(text, text) to service_role;

create or replace function public.set_user_daily_goal_minutes(
  p_username text,
  p_minutes integer
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_today date := (now() at time zone 'Europe/Moscow')::date;
  v_target integer;
  v_new integer;
  v_review integer;
  v_typing integer;
  v_applies_today boolean := false;
  v_row public.daily_goal_progress%rowtype;
begin
  if p_minutes not in (5, 10, 20, 25, 30) then
    raise exception 'Unsupported daily goal: %', p_minutes using errcode = '22023';
  end if;

  update public.users
  set daily_goal_minutes = p_minutes,
      daily_goal_selected_at = coalesce(daily_goal_selected_at, now())
  where username = p_username;

  if not found then
    raise exception 'User not found: %', p_username using errcode = 'P0002';
  end if;

  select * into v_row
  from public.daily_goal_progress
  where username = p_username and goal_date = v_today
  for update;

  if not found then
    v_applies_today := true;
  elsif v_row.completed_at is null
     and v_row.new_completed = 0
     and v_row.review_completed = 0
     and v_row.typing_completed = 0 then
    v_target := p_minutes * 2;
    v_new := round(v_target * 0.20);
    v_review := round(v_target * 0.50);
    v_typing := v_target - v_new - v_review;

    update public.daily_goal_progress
    set goal_minutes = p_minutes,
        target_tasks = v_target,
        new_target = v_new,
        review_target = v_review,
        typing_target = v_typing,
        updated_at = now()
    where username = p_username and goal_date = v_today
    returning * into v_row;
    v_applies_today := true;
  end if;

  return jsonb_build_object(
    'daily_goal_minutes', p_minutes,
    'daily_goal_selected_at', now(),
    'applies_today', v_applies_today,
    'goal', case when v_row.username is null then null else to_jsonb(v_row) end
  );
end;
$$;

revoke all on function public.set_user_daily_goal_minutes(text, integer) from public;
grant execute on function public.set_user_daily_goal_minutes(text, integer) to service_role;

create or replace function public.sync_user_daily_goal_progress(
  p_username text,
  p_course_name text,
  p_new_completed integer,
  p_review_completed integer,
  p_typing_completed integer
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_today date := (now() at time zone 'Europe/Moscow')::date;
  v_yesterday date := ((now() at time zone 'Europe/Moscow')::date - 1);
  v_row public.daily_goal_progress%rowtype;
  v_user public.users%rowtype;
  v_streak integer;
  v_completed_now boolean := false;
begin
  perform public.ensure_user_daily_goal(p_username, p_course_name);

  select * into v_row
  from public.daily_goal_progress
  where username = p_username and goal_date = v_today
  for update;

  if v_row.course_name <> p_course_name then
    raise exception 'Daily goal belongs to another course' using errcode = '22023';
  end if;

  if p_new_completed < 0 or p_new_completed > v_row.new_target
     or p_review_completed < 0 or p_review_completed > v_row.review_target
     or p_typing_completed < 0 or p_typing_completed > v_row.typing_target then
    raise exception 'Daily goal progress out of range' using errcode = '22003';
  end if;

  update public.daily_goal_progress
  set new_completed = greatest(new_completed, p_new_completed),
      review_completed = greatest(review_completed, p_review_completed),
      typing_completed = greatest(typing_completed, p_typing_completed),
      updated_at = now()
  where username = p_username and goal_date = v_today
  returning * into v_row;

  if v_row.completed_at is null
     and v_row.new_completed >= v_row.new_target
     and v_row.review_completed >= v_row.review_target
     and v_row.typing_completed >= v_row.typing_target then
    select * into v_user
    from public.users
    where username = p_username
    for update;

    if v_user.last_daily_goal_date is distinct from v_today then
      v_streak := case
        when v_user.last_daily_goal_date = v_yesterday then coalesce(v_user.streak, 0) + 1
        else 1
      end;

      update public.users
      set streak = v_streak,
          max_streak = greatest(coalesce(max_streak, 0), v_streak),
          last_activity = v_today,
          last_daily_goal_date = v_today,
          daily_goals_completed = coalesce(daily_goals_completed, 0) + 1
      where username = p_username;
      v_completed_now := true;
    end if;

    update public.daily_goal_progress
    set completed_at = coalesce(completed_at, now()),
        updated_at = now()
    where username = p_username and goal_date = v_today
    returning * into v_row;
  end if;

  select * into v_user from public.users where username = p_username;

  return jsonb_build_object(
    'goal', to_jsonb(v_row),
    'streak', coalesce(v_user.streak, 0),
    'max_streak', coalesce(v_user.max_streak, 0),
    'daily_goals_completed', coalesce(v_user.daily_goals_completed, 0),
    'completed_now', v_completed_now
  );
end;
$$;

revoke all on function public.sync_user_daily_goal_progress(text, text, integer, integer, integer) from public;
grant execute on function public.sync_user_daily_goal_progress(text, text, integer, integer, integer) to service_role;

alter table public.leaderboard
  add column if not exists daily_goals_completed integer not null default 0,
  add column if not exists daily_goal_minutes integer not null default 10;

create or replace function public.sync_leaderboard_from_users()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.leaderboard (
    nickname, total_score, fast_mode_high_score, streak, max_streak,
    daily_goals_completed, daily_goal_minutes, last_played
  ) values (
    new.username, coalesce(new.total_score, 0), coalesce(new.survival_record, 0),
    coalesce(new.streak, 0), coalesce(new.max_streak, 0),
    coalesce(new.daily_goals_completed, 0), coalesce(new.daily_goal_minutes, 10), now()
  )
  on conflict (nickname) do update set
    total_score = excluded.total_score,
    fast_mode_high_score = excluded.fast_mode_high_score,
    streak = excluded.streak,
    max_streak = excluded.max_streak,
    daily_goals_completed = excluded.daily_goals_completed,
    daily_goal_minutes = excluded.daily_goal_minutes,
    last_played = excluded.last_played;
  return new;
end;
$$;

update public.leaderboard l
set daily_goals_completed = coalesce(u.daily_goals_completed, 0),
    daily_goal_minutes = coalesce(u.daily_goal_minutes, 10)
from public.users u
where u.username = l.nickname;

alter table public.app_error_log
  add column if not exists kind text not null default 'error',
  add column if not exists severity text not null default 'error',
  add column if not exists fingerprint text,
  add column if not exists occurred_at timestamptz;

alter table public.app_error_log drop constraint if exists app_error_log_kind_check;
alter table public.app_error_log
  add constraint app_error_log_kind_check
  check (kind in ('error', 'unhandled-rejection', 'resource', 'api', 'invariant', 'pwa', 'diagnostic'));

alter table public.app_error_log drop constraint if exists app_error_log_severity_check;
alter table public.app_error_log
  add constraint app_error_log_severity_check
  check (severity in ('info', 'warning', 'error', 'fatal'));

create index if not exists app_error_log_fingerprint_created_idx
  on public.app_error_log (fingerprint, created_at desc)
  where fingerprint is not null;

create index if not exists app_error_log_kind_created_idx
  on public.app_error_log (kind, created_at desc);
