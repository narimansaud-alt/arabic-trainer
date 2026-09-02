import fs from 'node:fs/promises';
import crypto from 'node:crypto';
const path = 'data/quran-frequency-source.json';
const data = JSON.parse(await fs.readFile(path, 'utf8'));
const decode = s => s.replace(/<[^>]*>/g, '').replace(/&amp;/g,'&').replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&quot;/g,'"').replace(/&#39;/g,"'").replace(/&nbsp;/g,' ').trim();
let cursor = 0;
const results = new Array(data.words.length);
await Promise.all(Array.from({length: 4}, async () => {
  while (cursor < data.words.length) {
    const word = data.words[cursor++];
    const cache = '.local/quran-frequency-source/context-' + word.rank + '.html';
    let html;
    try { html = await fs.readFile(cache, 'utf8'); } catch {
      const r = await fetch(word.source, {signal: AbortSignal.timeout(30000)});
      if (!r.ok) throw new Error(word.source + ': ' + r.status);
      html = await r.text();
      await fs.writeFile(cache, html);
    }
    const count = Number(html.match(/Results <b>1<\/b> to <b>\d+<\/b> of <b>(\d+)<\/b>/)?.[1]);
    if (word.rank === 132) {
      const morePath = '.local/quran-frequency-source/context-132-page-2.html';
      let more;
      try { more = await fs.readFile(morePath, 'utf8'); } catch {
        const response = await fetch(word.source + '&page=2', {signal:AbortSignal.timeout(30000)});
        if (!response.ok) throw new Error('Could not verify complete sons/sonny group');
        more = await response.text();
        await fs.writeFile(morePath, more);
      }
      html += more;
    }
    const occurrences = [...html.matchAll(/<td class="c2"><a name="\(([^)]+)\)"[^>]*>([\s\S]*?)<\/a><\/td><td class="c3">([\s\S]*?)<\/td>/g)].map(m => ({
      location:m[1], gloss:decode(m[2]), form:decode(m[3].match(/<span class="auu">([\s\S]*?)<\/span>/)?.[1] || '')
    }));
    if (count !== word.frequency || !occurrences.length) throw new Error('Frequency/context mismatch rank ' + word.rank + ': ' + count + ' / ' + word.frequency);
    results[word.rank - 1] = {rank:word.rank, verifiedFrequency:count, sha256:crypto.createHash('sha256').update(html).digest('hex'), occurrences};
    if (word.rank % 100 === 0) console.log('Verified source contexts:', word.rank);
  }
}));
await fs.writeFile('data/quran-frequency-context.json', JSON.stringify({source:data.source, words:results}, null, 2) + '\n');
console.log('All ' + data.words.length + ' frequencies matched source concordances.');
