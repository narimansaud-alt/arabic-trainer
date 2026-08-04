import fs from 'node:fs';

const apiSource = fs.readFileSync('src/api.js', 'utf8');
const url = apiSource.match(/const SUPA_URL = '([^']+)'/u)?.[1];
const key = apiSource.match(/const SUPA_ANON_KEY = '([^']+)'/u)?.[1];
if (!url || !key) throw new Error('Supabase connection settings were not found in src/api.js');

async function read(path, query) {
  const response = await fetch(`${url}/rest/v1/${path}?${new URLSearchParams(query)}`, {
    headers: { apikey: key, authorization: `Bearer ${key}` },
  });
  const body = await response.text();
  if (!response.ok) throw new Error(`${path}: ${response.status} ${body}`);
  return JSON.parse(body);
}

const course = 'Мединский курс (Том 1)';
const rules = await read('rules', { select: '*', course_name: `eq.${course}`, order: 'lesson_number.asc,sort_order.asc,id.asc', limit: '1000' });
const ids = rules.map((rule) => rule.id);
const sections = ids.length
  ? await read('rule_sections', { select: '*', rule_id: `in.(${ids.join(',')})`, order: 'rule_id.asc,sort_order.asc,id.asc', limit: '5000' })
  : [];
const output = process.argv[2] || 'backups/medina-book1-import/tom1_rules_before_archive.json';
fs.writeFileSync(output, JSON.stringify({ exportedAt: new Date().toISOString(), course, rules, sections }, null, 2), 'utf8');
console.log(JSON.stringify({ output, rules: rules.length, sections: sections.length }, null, 2));
