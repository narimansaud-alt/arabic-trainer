import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const read = (name) => fs.readFileSync(new URL(name, root), 'utf8');
const html = read('index.html');
const quiz = read('src/quiz.js');
const learn = read('src/learn.js');
const styles = read('src/training-setup.css');

const selector = html.match(/<script id="pwa-manifest-selector">([\s\S]*?)<\/script>/u)?.[1];
assert.ok(selector, 'the platform-specific manifest selector must exist');

function manifestLinksFor(navigatorValue) {
  const links = [];
  const context = {
    navigator: navigatorValue,
    document: {
      createElement() { return {}; },
      head: { appendChild(link) { links.push({ rel: link.rel, href: link.href }); } },
    },
  };
  vm.createContext(context);
  vm.runInContext(selector, context);
  return links;
}

assert.deepEqual(
  manifestLinksFor({ userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X)', platform: 'iPhone', maxTouchPoints: 5 }),
  [],
  'iPhone must not receive the legacy Android manifest name',
);
assert.deepEqual(
  manifestLinksFor({ userAgent: 'Mozilla/5.0 (Macintosh)', platform: 'MacIntel', maxTouchPoints: 5 }),
  [],
  'iPad desktop-class user agent must be detected',
);
assert.deepEqual(
  manifestLinksFor({ userAgent: 'Mozilla/5.0 (Linux; Android 15)', platform: 'Linux armv8l', maxTouchPoints: 5 }),
  [{ rel: 'manifest', href: './manifest.json' }],
  'Android must retain the stable manifest identity',
);

assert.match(
  html,
  /<div id="word-display"><\/div>\s*<div class="quiz-word-source hidden" id="q-source"><\/div>/u,
  'the source label must follow the displayed word in the card',
);
assert.match(quiz, /wordDisplay\.insertAdjacentElement\('afterend', el\)/u, 'fallback source insertion must remain below the word');
assert.match(learn, /function renderLearnQ\(\) \{[\s\S]*?renderQuizWordSource\(curWord\);/u, 'learn mode must update the word source');
assert.match(styles, /\.quiz-word-source \{[\s\S]*?margin: 11px auto 0;[\s\S]*?background: transparent;/u, 'source must use secondary styling below the word');
assert.match(styles, /#screen-quiz \.word-card \{\s*flex-direction: column;/u, 'word card must stack the source below the word');

console.log('PWA platform naming and quiz source layout checks passed.');
