-- Keep the four-tasks-per-minute density while distributing the three daily
-- categories as evenly as possible. For totals with a remainder, review gets
-- the first extra task and new words get the second. Thus 40 tasks become
-- 13 new + 14 review + 13 typing. Existing in-progress or completed plans are
-- preserved; only untouched plans for the current Moscow day are rebalanced.

begin;

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
  v_base integer;
  v_remainder integer;
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
  v_base integer;
  v_remainder integer;
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
    v_target := p_minutes * 4;
    v_base := v_target / 3;
    v_remainder := mod(v_target, 3);
    v_new := v_base + case when v_remainder = 2 then 1 else 0 end;
    v_review := v_base + case when v_remainder >= 1 then 1 else 0 end;
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

update public.daily_goal_progress
set target_tasks = goal_minutes * 4,
    new_target = ((goal_minutes * 4) / 3)
      + case when mod(goal_minutes * 4, 3) = 2 then 1 else 0 end,
    review_target = ((goal_minutes * 4) / 3)
      + case when mod(goal_minutes * 4, 3) >= 1 then 1 else 0 end,
    typing_target = (goal_minutes * 4)
      - (((goal_minutes * 4) / 3)
        + case when mod(goal_minutes * 4, 3) = 2 then 1 else 0 end)
      - (((goal_minutes * 4) / 3)
        + case when mod(goal_minutes * 4, 3) >= 1 then 1 else 0 end),
    updated_at = now()
where goal_date = (now() at time zone 'Europe/Moscow')::date
  and completed_at is null
  and new_completed = 0
  and review_completed = 0
  and typing_completed = 0;

commit;
