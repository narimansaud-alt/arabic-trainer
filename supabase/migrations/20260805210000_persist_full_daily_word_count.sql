create or replace function public.sync_user_daily_words(
  p_username text,
  p_count integer
)
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_today date := (now() at time zone 'Europe/Moscow')::date;
  v_count integer;
begin
  if p_count < 0 or p_count > 1000000 then
    raise exception 'Daily count out of range: %', p_count using errcode = '22003';
  end if;

  update public.users
  set daily_words = case
        when last_count_date::date = v_today then greatest(coalesce(daily_words, 0), p_count)
        else p_count
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

revoke all on function public.sync_user_daily_words(text, integer) from public;
grant execute on function public.sync_user_daily_words(text, integer) to service_role;

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
        when last_count_date::date = v_today then least(coalesce(daily_words, 0) + 1, 1000000)
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
