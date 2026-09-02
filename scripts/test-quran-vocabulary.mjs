import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';
const read = name => fs.readFileSync(name,'utf8');
const data=JSON.parse(read('data/quran-vocabulary.json'));
const source=JSON.parse(read('data/quran-frequency-source.json'));
const evidence=JSON.parse(read('data/quran-frequency-context.json'));
assert.equal(data.words.length,1000);
assert.equal(new Set(data.words.map(w=>w.ar.normalize('NFC'))).size,1000);
const blocks=new Map();
for(const [i,w] of data.words.entries()) {
  assert.equal(w.rank,i+1);
  assert.equal(w.block,Math.floor(i/50)+1);
  assert.ok(w.ru && /[а-яё]/i.test(w.ru));
  assert.ok(!/[a-z\u0621-\u064a]/i.test(w.ru.replace(/\b[IVX]+\b/g,'')),'No untranslated gloss/answer leak '+w.rank);
  assert.ok(!/[\u0653-\u0655\u0671\u06d6-\u06ed]/u.test(w.ar),'Ordinary spelling '+w.rank);
  assert.ok(w.frequency>=8);
  if(i) assert.ok(w.frequency<=data.words[i-1].frequency);
  for(const r of w.sourceRecords) {
    assert.equal(r.rawFrequency,source.words[r.sourceRank-1].frequency);
    assert.equal(r.rawFrequency,evidence.words[r.sourceRank-1].verifiedFrequency);
    assert.equal(new URL(r.url).hostname,'corpus.quran.com');
  }
  blocks.set(w.block,(blocks.get(w.block)||0)+1);
}
assert.equal(blocks.size,20);
assert.ok([...blocks.values()].every(n=>n===50));
const bySource=n=>data.words.find(w=>w.sourceRank===n);
assert.equal(bySource(181).ar,'مَاء');
assert.equal(bySource(40).ar,'جَاءَ');
assert.equal(bySource(721).ar.normalize('NFC'),'حَاجَّ'.normalize('NFC'));
assert.equal(bySource(163).ar,'قُرْآن');
assert.equal(bySource(34).ar,'هَذَا');
assert.equal(bySource(18).ar,'ذَلِكَ');
assert.equal(bySource(71).ar,'إِلَه');
assert.equal(bySource(198).ar.normalize('NFC'),'لَكِنَّ'.normalize('NFC'));
assert.equal(bySource(64).ar.normalize('NFC'),'اِتَّقَى'.normalize('NFC'));
assert.equal(bySource(132).frequency,74);
assert.equal(bySource(382).frequency,39);
assert.equal(bySource(777).frequency,14);
assert.equal(bySource(777).kind,'mixed');
assert.match(bySource(777).ru,/Падать/);
assert.ok(!bySource(888));

const context={console,URL,Date,Math,Set,Map,Promise,crypto,
 localStorage:{getItem(){return null;},setItem(){},removeItem(){}},
 document:{getElementById(){return null;},querySelectorAll(){return [];},querySelector(){return null;}},
 window:{addEventListener(){},scrollTo(){}},
 setTimeout(){return 1;},clearTimeout(){},setInterval(){return 1;},clearInterval(){},
 ErrorLog:{capture(e){throw e;},invariant(ok,msg){assert.ok(ok,msg);},diagnostic(){}},
 alert(){},Api:{call:async()=>({})}
};
vm.createContext(context);
for(const file of ['state','helpers','quran-vocab','training-setup','quiz','daily'])
 vm.runInContext(read('src/'+file+'.js'),context,{filename:file+'.js'});
context.rows=data.words.map(w=>({
 id:10000+w.rank,course_name:data.course,lesson_number:String(w.block),
 word_ar:w.ar,word_ru:w.ru,vocabulary_meta:{rank:w.rank,sourceRank:w.sourceRank,frequency:w.frequency,kind:w.kind,
 inputForm:w.sourceRank===250?'present':w.sourceRank===1000?'imperative':w.kind==='verb'?'past':'lemma',
 sourceRecords:w.sourceRecords,note:w.note}
}));
vm.runInContext("App.username='quran-test';App.volume=QURAN_COURSE_ID;Dict.allWords=rows.map(r=>trainingWordFromRow(r));Dict.byLesson=buildTrainingVolumeCatalog(Dict.allWords).byLesson;loadTrainingSetupPreferences();",context);
for(const mode of ['learn','type-ar','review','mix']) {
  context.mode=mode;
  assert.equal(vm.runInContext("TrainingSetup.normalSelections[App.volume] ||= {}; TrainingSetup.normalSelections[App.volume][mode]=['1','2'];getTrainingSelectedWords(mode).length",context),100);
}
assert.equal(vm.runInContext("trainingVolumeIds().length",context),5);
assert.equal(vm.runInContext("TrainingSetup.fastCatalog[App.volume]=buildTrainingVolumeCatalog(Dict.allWords);TrainingSetup.fastSelections[App.volume]=['20'];getTrainingSelectedWords('fast').length",context),50);
vm.runInContext("for(const w of Dict.allWords){if(!isArabicAnswerCorrect(w.ar,w.ar,'learning')||!isArabicAnswerCorrect(w.ar,w.ar,'strict'))throw new Error(w.ar);if(isArabicAnswerCorrect('xyz',w.ar,'learning'))throw new Error('False accept');if(copyTrainingWord(w).vocabularyMeta.rank!==w.vocabularyMeta.rank)throw new Error('Lost metadata');}",context);
const html=vm.runInContext("renderQuranDictionary(Dict.allWords.slice(0,50))",context);
assert.match(html,/Вхождений группы/);
assert.match(html,/Блок 1/);
assert.match(html,/corpus.quran.com/);
assert.equal((html.match(/class="quran-word"/g)||[]).length,50);
assert.equal(vm.runInContext("quranSourceLinks({sourceRecords:[{url:'javascript:alert(1)'}]})",context),'');
assert.match(vm.runInContext("quranInputHint(Dict.allWords.find(w=>w.vocabularyMeta.sourceRank===250))",context),/настоящее время/);
assert.match(vm.runInContext("quranInputHint(Dict.allWords.find(w=>w.vocabularyMeta.sourceRank===1000))",context),/повеление/);
assert.match(vm.runInContext("quranInputHint(Dict.allWords.find(w=>w.vocabularyMeta.sourceRank===7))",context),/прошедшего/);
assert.equal(vm.runInContext("quranInputHint({volume:VOLUMES.med[0].id})",context),'');
assert.equal(vm.runInContext("quranGlossesOverlap({ru:'Путь; дорога'},{ru:'дорога'})",context),true);
vm.runInContext("var twins=Dict.allWords.filter(w=>w.ru==='Поклясться');",context);
assert.ok(vm.runInContext("twins.length>=2",context));
assert.equal(vm.runInContext("isQuranAlternateAnswerCorrect(twins[1].ar,twins[0],'learning')",context),true);
assert.equal(vm.runInContext("isQuranAlternateAnswerCorrect('xyz',twins[0],'learning')",context),false);
for(const minutes of [5,10,20,25,30]) {
 context.minutes=minutes;
 const plan=JSON.parse(JSON.stringify(vm.runInContext("buildDailyGoalPlan({...dailyGoalTargets(minutes),goal_date:appDateKey(),course_name:App.volume})",context)));
 assert.equal(plan.tasks.length,minutes*4);
 assert.equal(new Set(plan.tasks.map(t=>t.word.ar)).size,minutes*4);
 assert.ok(plan.tasks.every(t=>t.word.volume===data.course && t.word.vocabularyMeta.rank));
 const counts=Object.fromEntries(['new','review','typing'].map(c=>[c,plan.tasks.filter(t=>t.category===c).length]));
 assert.ok(Math.max(...Object.values(counts))-Math.min(...Object.values(counts))<=1);
 if(minutes===10) assert.deepEqual(counts,{new:13,review:14,typing:13});
}
const api=read('supabase/functions/api/index.ts');
const allow=api.match(/function isSupportedLearningCourse\(courseName: string\) \{[\s\S]*?\n\}/)[0].replace(': string','');
vm.runInContext(allow,context);
assert.equal(vm.runInContext('isSupportedLearningCourse(QURAN_COURSE_ID)',context),true);
assert.equal(vm.runInContext("isSupportedLearningCourse('Произвольный курс')",context),false);
assert.equal((api.match(/!isSupportedLearningCourse\(/g)||[]).length,3);
for(const asset of ['src/quran-vocab.js','src/quran-vocab.css']) {
 assert.ok(read('index.html').includes(asset));
 assert.equal(read('sw.js').split("'./"+asset+"'").length-1,2);
}
console.log('Quran vocabulary: 1000 source-backed cards, 20 blocks, both input checks, all modes and five daily quotas passed.');
