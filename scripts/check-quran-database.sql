-- Run INSIDE a transaction together with the two Quran migrations, then ROLLBACK.
-- Only a temporary test account is touched; never use a student's account.
do $qa$
declare
 v_user text := 'qa-quran-' || gen_random_uuid()::text;
 v_event uuid := gen_random_uuid();
 v_course text := '1000 самых частых слов Корана';
 v_goal jsonb;
 v_period text;
 v_points bigint;
begin
 if (select count(*) from public.words where course_name=v_course) <> 1000 then raise exception 'Wrong card count'; end if;
 if (select count(distinct lesson_number) from public.words where course_name=v_course) <> 20 then raise exception 'Wrong block count'; end if;
 if exists(select 1 from public.words where course_name=v_course group by lesson_number having count(*)<>50) then raise exception 'Wrong block size'; end if;
 if has_function_privilege('anon','public.log_user_score(text,integer,text,uuid)','execute') then raise exception 'Anonymous score write'; end if;
 if has_function_privilege('anon','public.ensure_user_daily_goal(text,text)','execute') then raise exception 'Anonymous goal write'; end if;
 if public.is_supported_learning_course(null) or public.is_supported_learning_course('not-a-course') then raise exception 'Invalid allowlist'; end if;

 insert into public.users(username,daily_goal_minutes) values(v_user,10);
 if public.log_user_score(v_user,25,v_course,v_event) <> 25 then raise exception 'Score missing'; end if;
 if public.log_user_score(v_user,25,v_course,v_event) <> 25 then raise exception 'Score duplicated'; end if;
 foreach v_period in array array['all','day','week','month'] loop
  select score_value into v_points from public.get_public_leaderboard('score',v_period,v_user,20) where is_current;
  if v_points is distinct from 25::bigint then raise exception 'Missing Quran score in %: %',v_period,v_points; end if;
 end loop;
 select sum(points) into v_points from public.get_public_score_chart(v_user,7);
 if v_points is distinct from 25::bigint then raise exception 'Chart missing Quran score'; end if;
 v_goal := public.ensure_user_daily_goal(v_user,v_course);
 if (v_goal->>'target_tasks')::int <> 40 or (v_goal->>'new_target')::int <> 13 or (v_goal->>'review_target')::int <> 14 or (v_goal->>'typing_target')::int <> 13 then raise exception 'Goal quotas wrong'; end if;
 perform public.ensure_user_daily_goal(v_user,'Мединский курс (Том 1)');
 if (select count(*) from public.daily_goal_progress where username=v_user) <> 1 then raise exception 'Switching course duplicated day'; end if;
 begin
  perform public.log_user_score(v_user,1,'not-a-course',gen_random_uuid());
  raise exception 'Unsupported course accepted';
 exception when sqlstate '22023' then null;
 end;
 begin
  perform public.log_user_score(v_user,501,v_course,gen_random_uuid());
  raise exception 'Score cap bypassed';
 exception when sqlstate '22003' then null;
 end;
end $qa$;
