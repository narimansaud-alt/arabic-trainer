import assert from 'node:assert/strict';
import fs from 'node:fs';

const source = fs.readFileSync(new URL('../src/verb-rules.js', import.meta.url), 'utf8');
const styles = fs.readFileSync(new URL('../src/verb-rules.css', import.meta.url), 'utf8');
const negation = source.match(/function negationContent\(\) \{([\s\S]*?)\r?\n  \}\r?\n\r?\n  function prohibitionContent/u)?.[1] || '';
const prohibition = source.match(/function prohibitionContent\(\) \{([\s\S]*?)\r?\n  \}\r?\n\r?\n  function voiceContent/u)?.[1] || '';

assert.match(source, /\['prohibition', 'Запрет: формы по лицам', 'اَلنَّهْيُ'/u, 'prohibition must be a standalone topic');
assert.match(source, /if \(id === 'prohibition'\) return prohibitionContent\(\)/u, 'the standalone prohibition topic must render');
assert.doesNotMatch(negation, /لَا تَكْتُبْ/u, 'prohibition must not remain inside the negation lesson');
assert.match(prohibition, /لَا النَّافِيَةُ/u, 'the prohibition lesson must distinguish negation');
assert.match(prohibition, /لَا النَّاهِيَةُ/u, 'the prohibition particle must be named');

for (const form of ['لَا تَكْتُبْ', 'لَا تَكْتُبَا', 'لَا تَكْتُبُوا', 'لَا تَكْتُبِي', 'لَا تَكْتُبْنَ']) {
  assert.match(source, new RegExp(form, 'u'), `missing prohibition form: ${form}`);
}

assert.match(source, /ar\(row\[4\]\) \+ '<br><span>' \+ row\[5\]/u, 'Arabic and Russian explanations must use separate direction spans');
assert.match(styles, /\.vr-table:has\(th:nth-child\(5\)\)\{min-width:860px;table-layout:auto\}/u, 'the five-column prohibition table must scroll instead of squeezing on mobile');
assert.match(styles, /\.vr-table:has\(th:nth-child\(5\)\) \.vr-ar\{font-size:22px/u, 'mobile Arabic forms in the prohibition table must remain large');
console.log('Verb prohibition checks passed.');
