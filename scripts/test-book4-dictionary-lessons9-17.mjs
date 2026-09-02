import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';
const source=JSON.parse(fs.readFileSync('data/book4-dictionary-lessons9-17.json','utf8'));
const migration=fs.readFileSync('supabase/migrations/20260902220000_import_book4_dictionary_lessons09_17.sql','utf8');
const context={Settings:{answerCheck:'learning'},console,window:{addEventListener(){}}};
vm.createContext(context);
vm.runInContext(fs.readFileSync('src/helpers.js','utf8'),context);
const dict=fs.readFileSync('src/dict.js','utf8');
const start=dict.indexOf('function makeDictBookRows(');
const end=dict.indexOf('\nfunction ',start+1);
vm.runInContext(dict.slice(start,end),context);
const counts={9:46,10:11,11:54,12:47,13:30,14:19,15:32,16:20,17:194};
const pages={185:14,186:14,187:10,188:8,189:14,190:15,191:16,192:14,193:15,194:8,195:14,196:7,197:14,198:14,199:9,200:13,201:2,202:14,203:15,204:15,205:15,206:15,207:15,208:15,209:15,210:15,211:12};
for(const [page,count] of Object.entries(pages))
  assert.equal(source.lessons.flatMap(l=>l.rows).filter(r=>r[0]===Number(page)).length,count);
for(const l of source.lessons) {
  assert.equal(l.lesson,l.printedLesson-17);
  const expected=l.rows.flatMap(([,ar,ru,plural,pluralRu],i)=>[
    {ar,ru,lesson:String(l.lesson),dictionaryRow:i+1,dictionaryForm:plural?'singular':'single'},
    ...(plural?[{ar:plural,ru:pluralRu,lesson:String(l.lesson),dictionaryRow:i+1,dictionaryForm:'plural'}]:[])
  ]);
  const pattern=/\('Мединский курс \(Том 4\)', '(9|1[0-7])', '([^']*)', '([^']*)', (\d+), '(single|singular|plural)'\)/gu;
  const actual=[...migration.matchAll(pattern)].filter(m=>Number(m[1])===l.lesson)
    .map(m=>({ar:m[2],ru:m[3],lesson:m[1],dictionaryRow:Number(m[4]),dictionaryForm:m[5]}));
  assert.deepEqual(actual,expected);
  assert.equal(actual.length,counts[l.lesson]);
  assert.equal(new Set(actual.map(w=>w.ar+'|'+w.ru)).size,actual.length,'no duplicate cards within a lesson');
  for(const row of l.rows.filter(r=>r[3])) {
    assert.ok(row[4], 'plural Russian is required');
    assert.notEqual(row[1],row[3], 'no identical singular/plural forms');
    if(row[1] !== 'سَحَابٌ') assert.notEqual(row[2],row[4], 'plural Russian differs except collective clouds');
  }
  context.records=actual;
  const table=vm.runInContext('makeDictBookRows(records)',context);
  assert.equal(table.length,l.rows.length);
  for(const [i,row] of table.entries()) {
    assert.equal(row.singular,l.rows[i][1]);
    assert.equal(row.plural||'',l.rows[i][3]||'');
    assert.equal(row.ru,l.rows[i][2]);
  }
  for(const w of actual) {
    assert.equal(w.ar,w.ar.normalize('NFC'));
    assert.ok(/[\u064B-\u0652]/u.test(w.ar));
    assert.ok(/[А-Яа-яЁё]/u.test(w.ru));
    for(const mode of ['learning','strict']) {
      assert.equal(context.isArabicAnswerCorrect(context.parseArabicAnswerSpec(w.ar).primary,w.ar,mode),true);
      if(w.ar.includes('/')) {
        assert.match(context.getArabicAnswerInputHint(w.ar),/обе формы/u);
        assert.equal(context.isArabicAnswerCorrect(w.ar.split('/')[0],w.ar,mode),false);
      } else if(w.ar.includes('،')) {
        for(const variant of w.ar.split('،'))
          assert.equal(context.isArabicAnswerCorrect(variant.trim(),w.ar,mode),true);
      }
    }
    assert.equal(context.isArabicAnswerCorrect(context.parseArabicAnswerSpec(w.ar).primary.replace(/[\u064B-\u0652]/gu,''),w.ar,'learning'),true);
  }
}
assert.match(migration,/except all select \* from book4_import_source/u);
assert.match(migration,/book4_import_untouched/u);
assert.match(migration,/where not exists/u);
console.log('Book 4 lessons 9-17: 347 photo rows / 453 cards, 106 plural translations, table pairing, both typing modes and variants passed.');
