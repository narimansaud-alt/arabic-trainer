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

const tom1 = await read('rules', {
  select: 'id,course_name,lesson_number,title,content,sort_order,rule_kind,summary',
  course_name: 'eq.Мединский курс (Том 1)',
  order: 'lesson_number.asc,sort_order.asc,id.asc',
  limit: '1000',
});
const tom2 = await read('rules', {
  select: 'id,lesson_number,title',
  course_name: 'eq.Мединский курс (Том 2)',
  order: 'lesson_number.asc,sort_order.asc,id.asc',
  limit: '1000',
});
const lessonNumbers = [...new Set(tom1.map((row) => Number(row.lesson_number)))].sort((a, b) => a - b);
const expectedLessons = Array.from({ length: 23 }, (_, index) => index + 1);
const internalParts = Object.fromEntries([4, 9, 13].map((lesson) => [lesson, tom1.filter((row) => Number(row.lesson_number) === lesson).some((row) => /Внутренняя структура/u.test(row.content))]));
const result = {
  tom1Rules: tom1.length,
  tom1Lessons: lessonNumbers,
  tom1HasExactlyLessons1to23: JSON.stringify(lessonNumbers) === JSON.stringify(expectedLessons),
  internalPartsPreserved: internalParts,
  tom1ArabicExamples: tom1.filter((row) => row.content.includes('iarab-example')).length,
  tom1Sections: (await read('rule_sections', { select: 'id', rule_id: `in.(${tom1.map((row) => row.id).join(',') || '0'})`, limit: '5000' })).length,
  tom2Rules: tom2.length,
  tom2Lessons: [...new Set(tom2.map((row) => Number(row.lesson_number)))].sort((a, b) => a - b),
};
if (!result.tom1HasExactlyLessons1to23 || !Object.values(internalParts).every(Boolean) || result.tom1Rules !== 76 || result.tom2Rules !== 42) {
  throw new Error(JSON.stringify(result, null, 2));
}
console.log(JSON.stringify(result, null, 2));
