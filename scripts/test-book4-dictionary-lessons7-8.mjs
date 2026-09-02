import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';
const source=JSON.parse(fs.readFileSync('data/book4-dictionary-lessons7-8.json','utf8'));
const migration=fs.readFileSync('supabase/migrations/20260902190000_import_book4_dictionary_lessons07_08.sql','utf8');
const context={Settings:{answerCheck:'learning'},console,window:{addEventListener(){}}};
vm.createContext(context);
vm.runInContext(fs.readFileSync('src/helpers.js','utf8'),context);
const dict=fs.readFileSync('src/dict.js','utf8');
const start=dict.indexOf('function makeDictBookRows(');
const end=dict.indexOf('\nfunction ',start+1);
vm.runInContext(dict.slice(start,end),context);
const plurals={
  7:['Серпы','Щёки'],
  8:['Затылки','Надобности, желания','Светильники','Ковры','Правители, губернаторы','Пешие','Стрелки','Голые','Воины','Босые']
};
const pages={180:13,181:8,182:13,183:15,184:11};
for(const [page,count] of Object.entries(pages))
  assert.equal(source.lessons.flatMap(l=>l.rows).filter(r=>r[0]===Number(page)).length,count);
for(const l of source.lessons) {
  assert.equal(l.lesson,l.printedLesson-17);
  const expected=l.rows.flatMap(([,ar,ru,plural,pluralRu],i)=>[
    {ar,ru,lesson:String(l.lesson),dictionaryRow:i+1,dictionaryForm:plural?'singular':'single'},
    ...(plural?[{ar:plural,ru:pluralRu,lesson:String(l.lesson),dictionaryRow:i+1,dictionaryForm:'plural'}]:[])
  ]);
  const pattern=/\('Мединский курс \(Том 4\)', '(7|8)', '([^']*)', '([^']*)', (\d+), '(single|singular|plural)'\)/gu;
  const actual=[...migration.matchAll(pattern)].filter(m=>Number(m[1])===l.lesson)
    .map(m=>({ar:m[2],ru:m[3],lesson:m[1],dictionaryRow:Number(m[4]),dictionaryForm:m[5]}));
  assert.deepEqual(actual,expected);
  assert.equal(actual.length,l.lesson===7?23:49);
  assert.deepEqual(actual.filter(w=>w.dictionaryForm==='plural').map(w=>w.ru),plurals[l.lesson]);
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
console.log('Book 4 lessons 7-8: 60 photo rows / 72 cards, 12 plural translations, table pairing, both typing modes and variants passed.');
