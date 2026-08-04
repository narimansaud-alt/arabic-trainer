alter table public.rules
  add column if not exists sort_order integer,
  add column if not exists rule_kind text,
  add column if not exists summary text;

alter table public.rules
  drop constraint if exists rules_rule_kind_check;

alter table public.rules
  add constraint rules_rule_kind_check
  check (
    rule_kind is null
    or rule_kind in ('rule', 'example', 'table', 'irab', 'important', 'logic', 'note')
  );

with ordered as (
  select
    id,
    row_number() over (
      partition by course_name, lesson_number
      order by
        case when title ilike 'Таблица%' then 1 else 0 end,
        id
    )::integer as rn
  from public.rules
)
update public.rules as r
set sort_order = coalesce(r.sort_order, ordered.rn)
from ordered
where r.id = ordered.id;

update public.rules
set rule_kind = case
  when title ilike 'Таблица%' or content ilike '%<table%' then 'table'
  when title ilike '%Важно%' then 'important'
  else 'rule'
end
where rule_kind is null;

create index if not exists rules_course_lesson_sort_idx
  on public.rules (course_name, lesson_number, sort_order, id);
