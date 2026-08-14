import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, '..');
const read = (name) => fs.readFileSync(path.join(root, name), 'utf8');
const fail = (message) => {
  console.error('Release check failed: ' + message);
  process.exitCode = 1;
};

const sw = read('sw.js');
for (const asset of ['./src/verb-rules.js', './src/verb-rules.css']) {
  const occurrences = sw.split("'" + asset + "'").length - 1;
  if (occurrences !== 2) fail('service worker must include ' + asset + ' once in each cache strategy');
}
if (!sw.includes('__BUILD_HASH__')) fail('service worker cache is not tied to the deployment hash');

const manifest = JSON.parse(read('manifest.json'));
if (manifest.id !== './') fail('PWA id must remain stable at ./');
const stablePwaName = '\u041c\u0435\u0434\u0438\u043d\u0441\u043a\u0438\u0439 \u043a\u0443\u0440\u0441 \u0438 \u0433\u043b\u0430\u0433\u043e\u043b\u044b';
if (manifest.name !== stablePwaName) fail('PWA name changed; Android will prompt installed users to rename the app');
const stablePwaShortName = '\u041c\u0435\u0434\u0438\u043d\u0441\u043a\u0438\u0439 \u043a\u0443\u0440\u0441';
if (manifest.short_name !== stablePwaShortName) fail('PWA launcher label changed');

const index = read('index.html');
const main = read('src/main.js');
const verbRules = read('src/verb-rules.js');
if (main.includes("window.addEventListener('error'") || main.includes("window.addEventListener('unhandledrejection'")) {
  fail('global error handlers must only be registered once in src/api.js');
}
if (!verbRules.includes('window.showVerbRules')) fail('verb rules entry point is missing');
if (!verbRules.includes('اَلْفِعْلُ الْمَاضِي') || !verbRules.includes('اَلْأَوْزَانُ')) fail('verb rules core sections are missing');
for (const retired of ['src/verbs.js', 'src/verb-study.js', 'src/verb-study.css', 'openVerbStudy()', 'screen-verb-study', 'screen-verbs']) {
  if (index.includes(retired) || sw.includes(retired)) fail('retired conjugation module is still published: ' + retired);
}

for (const name of ['src/verb-rules.js', 'src/verb-rules.css', 'src/streak.js', 'src/dict.js', 'sw.js']) {
  if (read(name).includes('\uFFFD')) fail(name + ' contains a replacement character');
}

if (!process.exitCode) console.log('Release checks passed.');
