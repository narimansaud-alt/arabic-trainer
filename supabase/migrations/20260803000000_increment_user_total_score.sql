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
begin
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

revoke all on function public.increment_user_total_score(text, integer) from public;
grant execute on function public.increment_user_total_score(text, integer) to service_role;
