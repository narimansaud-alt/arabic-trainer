import fs from 'node:fs';
import path from 'node:path';
import vm from 'node:vm';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, '..');
const read = (name) => fs.readFileSync(path.join(root, name), 'utf8');
const fail = (message) => {
  console.error('Release check failed: ' + message);
  process.exitCode = 1;
};

const sw = read('sw.js');
for (const asset of ['./src/verb-study.js', './src/verb-study.css']) {
  const occurrences = sw.split("'" + asset + "'").length - 1;
  if (occurrences !== 2) fail('service worker must include ' + asset + ' once in each cache strategy');
}
if (!sw.includes('__BUILD_HASH__')) fail('service worker cache is not tied to the deployment hash');

const verbStudy = read('src/verb-study.js');
if (!verbStudy.includes('AbortController')) fail('Qutrub request has no cancellation support');
if (!verbStudy.includes("'<div class=\"vs-results\">' + resultHtml")) fail('general conjugation table result is not rendered');

const marker = '  window.openVerbStudy = function';
const instrumented = verbStudy.replace(marker, '  globalThis.__verbStudyTest = { state, visibleGroups, generalTable };\n' + marker);
if (instrumented === verbStudy) {
  fail('verb filter test hook could not be installed');
} else {
  const sandbox = { console, AbortController, setTimeout, clearTimeout, document: { getElementById: () => null } };
  sandbox.window = sandbox;
  vm.runInNewContext(instrumented, sandbox);
  const test = sandbox.__verbStudyTest;
  const row = { 'هُوَ': 'فَعَلَ' };
  test.state.forms = { all_forms: {
    'الماضي المعلوم': row,
    'الماضي المجهول': row,
    'المضارع المعلوم': row,
    'المضارع المجهول': row,
    'المضارع المنصوب': row,
    'المضارع المجهول المنصوب': row,
    'المضارع المجزوم': row,
    'المضارع المجهول المجزوم': row,
    'الأمر': row,
    'الأمر المؤكد': row,
  } };
  const expectGroups = (tense, voice, mood, expected) => {
    Object.assign(test.state, { tense, voice, mood });
    const actual = test.visibleGroups().map((item) => item.name).sort();
    if (JSON.stringify(actual) !== JSON.stringify([...expected].sort())) {
      fail('wrong conjugation filter result for ' + [tense, voice, mood].join('/'));
    }
  };
  expectGroups('past', 'active', 'plain', ['الماضي المعلوم']);
  expectGroups('past', 'passive', 'plain', ['الماضي المجهول']);
  expectGroups('present', 'active', 'subjunctive', ['المضارع المنصوب']);
  expectGroups('present', 'passive', 'subjunctive', ['المضارع المجهول المنصوب']);
  expectGroups('imperative', 'active', 'plain', ['الأمر']);
  test.state.voice = 'all';
  const generalSections = (test.generalTable().match(/vs-general-table/g) || []).length;
  if (generalSections !== 2) fail('general table does not render both voices');
}

for (const name of ['src/verb-study.js', 'src/streak.js', 'src/dict.js', 'sw.js']) {
  if (read(name).includes('\uFFFD')) fail(name + ' contains a replacement character');
}

if (!process.exitCode) console.log('Release checks passed.');
