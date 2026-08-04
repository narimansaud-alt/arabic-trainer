create table if not exists public.rule_sections (
  id bigserial primary key,
  rule_id bigint not null references public.rules(id) on delete cascade,
  section_type text not null default 'note',
  title text,
  content text not null,
  sort_order integer not null default 1,
  created_at timestamp with time zone default now(),
  constraint rule_sections_section_type_check
    check (section_type in ('rule', 'example', 'irab', 'table', 'important', 'logic', 'memorize', 'note')),
  constraint rule_sections_rule_sort_unique unique (rule_id, sort_order)
);

create index if not exists rule_sections_rule_sort_idx
  on public.rule_sections (rule_id, sort_order, id);

create index if not exists rule_sections_type_idx
  on public.rule_sections (section_type);

alter table public.rule_sections enable row level security;

drop policy if exists rule_sections_read on public.rule_sections;
create policy rule_sections_read
  on public.rule_sections
  for select
  to public
  using (true);

grant select on public.rule_sections to anon, authenticated;

with normalized as (
  select
    id as rule_id,
    regexp_replace(content, '<br\s*/?>\s*(И[‘''"`ʼ’]?раб\s*:)', '<br><br>\1', 'gi') as content
  from public.rules
),
parts as (
  select
    n.rule_id,
    btrim(p.part) as content,
    p.sort_order::integer
  from normalized n
  cross join lateral regexp_split_to_table(n.content, '(?i)(?:<br\s*/?>\s*){2,}') with ordinality as p(part, sort_order)
  where btrim(p.part) <> ''
),
typed as (
  select
    rule_id,
    case
      when content ~* '<table' then 'table'
      when content ~* 'И[‘''"`ʼ’]?раб|إعراب|إِعْرَاب' then 'irab'
      when content ~* 'Важно|Секрет|Запомн|Внимание' then 'important'
      when content ~* 'Пример|مثال' then 'example'
      when content ~* 'Логика|Суть|Как сказать|Как читать' then 'logic'
      when content ~* 'Знать наизусть|Наизусть' then 'memorize'
      when content ~* 'Правило|Новое правило|Вспоминаем' then 'rule'
      else 'note'
    end as section_type,
    case
      when content ~* '<table' then 'Таблица'
      when content ~* 'И[‘''"`ʼ’]?раб|إعراب|إِعْرَاب' then 'Разбор'
      when content ~* 'Важно|Секрет|Запомн|Внимание' then 'Важно'
      when content ~* 'Пример|مثال' then 'Пример'
      when content ~* 'Логика|Суть|Как сказать|Как читать' then 'Логика'
      when content ~* 'Знать наизусть|Наизусть' then 'Знать наизусть'
      when content ~* 'Правило|Новое правило|Вспоминаем' then 'Правило'
      else 'Пояснение'
    end as title,
    content,
    sort_order
  from parts
)
insert into public.rule_sections (rule_id, section_type, title, content, sort_order)
select rule_id, section_type, title, content, sort_order
from typed
on conflict (rule_id, sort_order) do nothing;
