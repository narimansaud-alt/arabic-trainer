-- Normalize punctuation and replace two accidental look-alike characters.
begin;

with cleaned as (
  select
    id,
    replace(replace(
      regexp_replace(replace(replace(title, chr(4316), chr(1606)), chr(1508), chr(1601)), '[[:space:]]+([,.;:!?])', E'\\1', 'g'),
      '( ', '('
    ), ' )', ')') as title,
    replace(replace(
      regexp_replace(replace(replace(content, chr(4316), chr(1606)), chr(1508), chr(1601)), '[[:space:]]+([,.;:!?])', E'\\1', 'g'),
      '( ', '('
    ), ' )', ')') as content
  from public.rules
)
update public.rules as rule
set title = cleaned.title, content = cleaned.content
from cleaned
where rule.id = cleaned.id
  and (rule.title, rule.content) is distinct from (cleaned.title, cleaned.content);

with cleaned as (
  select
    id,
    replace(replace(
      regexp_replace(replace(replace(title, chr(4316), chr(1606)), chr(1508), chr(1601)), '[[:space:]]+([,.;:!?])', E'\\1', 'g'),
      '( ', '('
    ), ' )', ')') as title,
    replace(replace(
      regexp_replace(replace(replace(content, chr(4316), chr(1606)), chr(1508), chr(1601)), '[[:space:]]+([,.;:!?])', E'\\1', 'g'),
      '( ', '('
    ), ' )', ')') as content
  from public.rule_sections
)
update public.rule_sections as section
set title = cleaned.title, content = cleaned.content
from cleaned
where section.id = cleaned.id
  and (section.title, section.content) is distinct from (cleaned.title, cleaned.content);

commit;
