// Reproducible primary-source import. Raw pages are cached unchanged locally.
import fs from 'node:fs/promises';
import crypto from 'node:crypto';
const base = 'https://corpus.quran.com';
const cache = '.local/quran-frequency-source';
await fs.mkdir(cache, { recursive: true });
const decode = (s) => s.replace(/<[^>]*>/g, '').replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&nbsp;/g, ' ').trim();
async function page(url, name) {
  const path = cache + '/' + name + '.html';
  try { return await fs.readFile(path, 'utf8'); } catch {}
  const response = await fetch(url, { signal: AbortSignal.timeout(30000) });
  if (!response.ok) throw new Error(url + ': ' + response.status);
  const text = await response.text();
  await fs.writeFile(path, text);
  return text;
}
const rows = [];
const pages = [];
for (const kind of ['lemmas', 'verbs']) {
  for (let n = 1; n <= 20; n++) {
    const url = base + '/' + kind + '.jsp?' + (kind === 'lemmas' ? 'group=1&' : '') + 'page=' + n;
    const html = await page(url, kind + '-' + n);
    pages.push({ url, sha256: crypto.createHash('sha256').update(html).digest('hex') });
    let count = 0;
    for (const tr of html.matchAll(/<tr>\s*([\s\S]*?)<\/tr>/g)) {
      const cells = [...tr[1].matchAll(/<td[^>]*>([\s\S]*?)<\/td>/g)].map(m => m[1]);
      if (cells.length !== (kind === 'lemmas' ? 4 : 5) || !tr[1].includes('class="at"')) continue;
      const href = tr[1].match(/href="([^"]+)"/)?.[1];
      const frequency = Number(decode(cells[kind === 'lemmas' ? 2 : 3]));
      if (!href || !frequency) throw new Error('Malformed source row');
      rows.push({
        key: decode(href), sourceArabic: decode(cells[0]), frequency,
        kind: kind === 'verbs' ? 'verb' : 'lemma',
        grammar: decode(cells[kind === 'lemmas' ? 3 : 2]),
        gloss: kind === 'verbs' ? decode(cells[4]) : '',
        source: base + decode(href), sourceOrder: rows.length
      });
      count++;
    }
    if (count !== 50) throw new Error(url + ': expected 50, got ' + count);
    console.log(kind, n, count);
  }
}
if (new Set(rows.map(r => r.key)).size !== rows.length) throw new Error('Duplicate primary-source keys');
rows.sort((a,b) => b.frequency-a.frequency || a.sourceOrder-b.sourceOrder);
const words = rows.slice(0, 1050).map((r,i) => ({rank:i+1, ...r}));
await fs.mkdir('data', { recursive: true });
await fs.writeFile('data/quran-frequency-source.json', JSON.stringify({
  source: 'Quranic Arabic Corpus',
  copyright: 'Copyright © Kais Dukes, 2009–2017. Quranic Arabic Corpus v0.4; GNU General Public License; https://corpus.quran.com/download/',
  retrieved: new Date().toISOString().slice(0,10),
  method: 'Merge grouped non-verb lemmas and verb root/form concordance; descending source frequency; ties use source table order (non-verbs first). Prefixes/suffixes and items without a lemma in these tables are not counted as separate vocabulary entries. Not a raw-token frequency list.',
  pages, words
}, null, 2) + '\n');
console.log('Imported', words.length, 'entries; minimum frequency', words.at(-1).frequency);
