-- Add the explicitly named Quran vocabulary to the existing protected workflows.
-- Function bodies below preserve the current production behavior and grants;
-- only course allowlisting changes. No scores, users or Medina data are rewritten.
begin;
create or replace function public.is_supported_learning_course(p_course_name text)
returns boolean language sql immutable parallel safe set search_path = public as $$
 select coalesce(p_course_name ~ '^Мединский курс \(Том [1-4]\)$' or p_course_name = '1000 самых частых слов Корана', false);
$$;
alter table public.daily_goal_progress drop constraint if exists daily_goal_progress_course_check;
alter table public.daily_goal_progress add constraint daily_goal_progress_course_check
 check (public.is_supported_learning_course(course_name));

CREATE OR REPLACE FUNCTION public.ensure_user_daily_goal(p_username text, p_course_name text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_today date := (now() at time zone 'Europe/Moscow')::date;
  v_minutes integer;
  v_target integer;
  v_base integer;
  v_remainder integer;
  v_new integer;
  v_review integer;
  v_typing integer;
  v_row public.daily_goal_progress%rowtype;
begin
  if not public.is_supported_learning_course(p_course_name) then
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

  v_target := v_minutes * 4;
  v_base := v_target / 3;
  v_remainder := mod(v_target, 3);
  v_new := v_base + case when v_remainder = 2 then 1 else 0 end;
  v_review := v_base + case when v_remainder >= 1 then 1 else 0 end;
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
$function$;

CREATE OR REPLACE FUNCTION public.get_public_leaderboard(p_type text DEFAULT 'score'::text, p_period text DEFAULT 'all'::text, p_username text DEFAULT NULL::text, p_limit integer DEFAULT 20)
 RETURNS TABLE("position" bigint, nickname text, score_value bigint, streak integer, daily_goal_minutes integer, period_start timestamp with time zone, is_current boolean)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
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
      and public.is_supported_learning_course(sh.course_name)
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
$function$;

CREATE OR REPLACE FUNCTION public.get_public_score_chart(p_username text, p_days integer DEFAULT 7)
 RETURNS TABLE(score_date date, points bigint)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
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
      and public.is_supported_learning_course(sh.course_name)
      and sh.created_at >= ((v_today - (v_days - 1))::timestamp at time zone 'Europe/Moscow')
      and sh.created_at < ((v_today + 1)::timestamp at time zone 'Europe/Moscow')
    group by (sh.created_at at time zone 'Europe/Moscow')::date
  )
  select c.day, coalesce(ds.day_points, 0)::bigint
  from calendar c
  left join daily_scores ds on ds.day = c.day
  order by c.day;
end;
$function$;

CREATE OR REPLACE FUNCTION public.log_user_score(p_username text, p_points integer, p_course_name text, p_event_id uuid)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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

  if not public.is_supported_learning_course(p_course_name) then
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
$function$;
-- Supabase's default privileges had granted anon/authenticated directly.
-- Revoking PUBLIC alone in the historical migrations did not remove those.
-- Client writes already use the authenticated Edge Function and service_role.
revoke all on function public.log_user_score(text, integer, text, uuid) from public, anon, authenticated;
grant execute on function public.log_user_score(text, integer, text, uuid) to service_role;
revoke all on function public.ensure_user_daily_goal(text, text) from public, anon, authenticated;
grant execute on function public.ensure_user_daily_goal(text, text) to service_role;
commit;
