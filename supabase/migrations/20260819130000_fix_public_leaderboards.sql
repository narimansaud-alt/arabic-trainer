-- Canonical, complete public leaderboards.
-- Period totals are calculated inside PostgreSQL so PostgREST's row limit
-- cannot truncate score_history before aggregation.

create or replace function public.sync_leaderboard_from_users()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
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

drop trigger if exists trg_sync_leaderboard on public.users;
create trigger trg_sync_leaderboard
after insert or update of
  total_score,
  survival_record,
  streak,
  max_streak,
  daily_goals_completed,
  daily_goal_minutes
on public.users
for each row execute function public.sync_leaderboard_from_users();

-- A completed daily plan is authoritative evidence that the day was earned.
-- GREATEST preserves any legitimate historical count that predates this table.
with completed as (
  select username, count(*)::integer as completed_count
  from public.daily_goal_progress
  where completed_at is not null
  group by username
)
update public.users u
set daily_goals_completed = greatest(
  coalesce(u.daily_goals_completed, 0),
  completed.completed_count
)
from completed
where completed.username = u.username
  and coalesce(u.daily_goals_completed, 0) < completed.completed_count;

-- Backfill every public cache row, including users whose only recent change
-- was the selected daily-goal duration.
insert into public.leaderboard (
  nickname, total_score, fast_mode_high_score, streak, max_streak,
  daily_goals_completed, daily_goal_minutes, last_played
)
select
  u.username,
  coalesce(u.total_score, 0),
  coalesce(u.survival_record, 0),
  coalesce(u.streak, 0),
  coalesce(u.max_streak, 0),
  coalesce(u.daily_goals_completed, 0),
  coalesce(u.daily_goal_minutes, 10),
  now()
from public.users u
on conflict (nickname) do update set
  total_score = excluded.total_score,
  fast_mode_high_score = excluded.fast_mode_high_score,
  streak = excluded.streak,
  max_streak = excluded.max_streak,
  daily_goals_completed = excluded.daily_goals_completed,
  daily_goal_minutes = excluded.daily_goal_minutes,
  last_played = excluded.last_played;

create or replace function public.get_public_leaderboard(
  p_type text default 'score',
  p_period text default 'all',
  p_username text default null,
  p_limit integer default 20
)
returns table (
  "position" bigint,
  nickname text,
  score_value bigint,
  streak integer,
  daily_goal_minutes integer,
  period_start timestamptz,
  is_current boolean
)
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_type text := lower(btrim(coalesce(p_type, 'score')));
  v_period text := lower(btrim(coalesce(p_period, 'all')));
  v_username_key text := lower(btrim(coalesce(p_username, '')));
  v_limit integer := least(greatest(coalesce(p_limit, 20), 1), 100);
  v_period_start timestamptz;
begin
  if v_type not in ('score', 'fast', 'daily') then
    raise exception 'Unsupported leaderboard type: %', p_type using errcode = '22023';
  end if;

  if v_period not in ('all', 'day', 'week', 'month') then
    raise exception 'Unsupported leaderboard period: %', p_period using errcode = '22023';
  end if;

  if v_type <> 'score' then
    v_period := 'all';
  end if;

  if v_period = 'all' then
    return query
    with ranked as (
      select
        row_number() over (
          order by
            case v_type
              when 'score' then coalesce(u.total_score, 0)
              when 'fast' then coalesce(u.survival_record, 0)
              else coalesce(u.daily_goals_completed, 0)
            end desc,
            case when v_type = 'daily' then coalesce(u.streak, 0) else 0 end desc,
            lower(btrim(u.username)),
            u.username
        ) as rank_no,
        u.username as row_nickname,
        case v_type
          when 'score' then coalesce(u.total_score, 0)::bigint
          when 'fast' then coalesce(u.survival_record, 0)::bigint
          else coalesce(u.daily_goals_completed, 0)::bigint
        end as row_score,
        coalesce(u.streak, 0)::integer as row_streak,
        coalesce(u.daily_goal_minutes, 10)::integer as row_goal_minutes,
        lower(btrim(u.username)) = v_username_key as row_is_current
      from public.users u
    )
    select
      r.rank_no,
      r.row_nickname,
      r.row_score,
      r.row_streak,
      r.row_goal_minutes,
      null::timestamptz,
      r.row_is_current
    from ranked r
    where r.rank_no <= v_limit
       or (v_username_key <> '' and r.row_is_current)
    order by r.rank_no;
    return;
  end if;

  v_period_start := case v_period
    when 'day' then
      date_trunc('day', now() at time zone 'Europe/Moscow') at time zone 'Europe/Moscow'
    when 'week' then
      date_trunc('week', now() at time zone 'Europe/Moscow') at time zone 'Europe/Moscow'
    when 'month' then
      date_trunc('month', now() at time zone 'Europe/Moscow') at time zone 'Europe/Moscow'
  end;

  return query
  with period_scores as (
    select
      sh.username,
      sum(sh.points)::bigint as points
    from public.score_history sh
    where sh.created_at >= v_period_start
      and sh.course_name ~ '^Мединский курс \(Том [1-4]\)$'
    group by sh.username
  ), candidates as (
    select
      u.username as row_nickname,
      coalesce(ps.points, 0)::bigint as row_score,
      coalesce(u.streak, 0)::integer as row_streak,
      coalesce(u.daily_goal_minutes, 10)::integer as row_goal_minutes,
      lower(btrim(u.username)) = v_username_key as row_is_current
    from public.users u
    left join period_scores ps on ps.username = u.username
    where coalesce(ps.points, 0) > 0
       or (v_username_key <> '' and lower(btrim(u.username)) = v_username_key)
  ), ranked as (
    select
      row_number() over (
        order by c.row_score desc, lower(btrim(c.row_nickname)), c.row_nickname
      ) as rank_no,
      c.*
    from candidates c
  )
  select
    r.rank_no,
    r.row_nickname,
    r.row_score,
    r.row_streak,
    r.row_goal_minutes,
    v_period_start,
    r.row_is_current
  from ranked r
  where r.rank_no <= v_limit
     or (v_username_key <> '' and r.row_is_current)
  order by r.rank_no;
end;
$$;

revoke all on function public.get_public_leaderboard(text, text, text, integer) from public;
grant execute on function public.get_public_leaderboard(text, text, text, integer)
  to anon, authenticated, service_role;

comment on function public.get_public_leaderboard(text, text, text, integer) is
  'Canonical public Medina leaderboard. Period boundaries use Europe/Moscow; weeks begin Monday. Returns top N plus the current user true rank.';

create or replace function public.get_public_score_chart(
  p_username text,
  p_days integer default 7
)
returns table (
  score_date date,
  points bigint
)
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_days integer := least(greatest(coalesce(p_days, 7), 1), 31);
  v_today date := (now() at time zone 'Europe/Moscow')::date;
  v_username text;
begin
  select u.username
  into v_username
  from public.users u
  where lower(btrim(u.username)) = lower(btrim(coalesce(p_username, '')))
  order by case when u.username = p_username then 0 else 1 end, u.username
  limit 1;

  if v_username is null then
    return;
  end if;

  return query
  with calendar as (
    select gs::date as day
    from generate_series(
      v_today - (v_days - 1),
      v_today,
      interval '1 day'
    ) gs
  ), daily_scores as (
    select
      (sh.created_at at time zone 'Europe/Moscow')::date as day,
      sum(sh.points)::bigint as day_points
    from public.score_history sh
    where sh.username = v_username
      and sh.course_name ~ '^Мединский курс \(Том [1-4]\)$'
      and sh.created_at >= ((v_today - (v_days - 1))::timestamp at time zone 'Europe/Moscow')
      and sh.created_at < ((v_today + 1)::timestamp at time zone 'Europe/Moscow')
    group by (sh.created_at at time zone 'Europe/Moscow')::date
  )
  select c.day, coalesce(ds.day_points, 0)::bigint
  from calendar c
  left join daily_scores ds on ds.day = c.day
  order by c.day;
end;
$$;

revoke all on function public.get_public_score_chart(text, integer) from public;
grant execute on function public.get_public_score_chart(text, integer)
  to anon, authenticated, service_role;

comment on function public.get_public_score_chart(text, integer) is
  'Public per-day Medina score totals for the personal chart, grouped by Europe/Moscow calendar dates.';
