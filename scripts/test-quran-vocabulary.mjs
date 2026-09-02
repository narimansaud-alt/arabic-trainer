import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';
import crypto from 'node:crypto';
const read = name => fs.readFileSync(name, 'utf8');
const data = JSON.parse(read('data/quran-academy-vocabulary.json'));
const nouns = JSON.parse(read('data/quran-academy-study-source.json'));
const verbs = JSON.parse(read('data/quran-academy-verb-source.json'));
assert.equal(data.words.length, 759);
assert.equal(data.sha256, crypto.createHash('sha256').update(JSON.stringify(data.words)).digest('hex'));
assert.equal(new Set(data.words.map(w => w.ar)).size, data.words.length);
const keys = data.words.flatMap(w => w.sourceRows.map(r => r.key));
assert.equal(keys.length, nouns.rows.length + verbs.rows.length);
assert.equal(new Set(keys).size, keys.length, 'Every source row mapped exactly once');
for (let i = 0; i < nouns.rows.length; i++) assert.ok(keys.includes('word-' + (i + 1)));
for (let i = 0; i < verbs.rows.length; i++) assert.ok(keys.includes('verb-' + (i + 1)));
assert.deepEqual([...new Set(data.words.flatMap(w => w.sourceRows.map(r => r.page)))].sort((a,b) => a-b),
 Array.from({length:38}, (_,i) => i+7));
const blocks = new Map();
for (const [i,w] of data.words.entries()) {
 assert.equal(w.rank,i+1);
 assert.equal(w.block,Math.floor(i/50)+1);
 assert.equal(w.ar,w.ar.normalize('NFC'));
 assert.ok(/[а-яё]/iu.test(w.ru) && !/[a-z\u0621-\u064a]/iu.test(w.ru), 'Untranslated gloss/answer leak: '+w.ar);
 assert.ok(!/[\u0653-\u0655\u0671\u06d6-\u06ed]/u.test(w.ar), 'Ordinary keyboard spelling: '+w.ar);
 assert.ok(w.sourceRows.every(r => r.pdfPage === r.page+2));
 blocks.set(w.block,(blocks.get(w.block)||0)+1);
}
assert.equal(blocks.size,16);
assert.deepEqual([...blocks.values()], [...Array(15).fill(50),9]);
const byAr = ar => data.words.find(w => w.ar === ar.normalize('NFC'));
for (const [ar,ru] of [['أَبْنَاء',null],['أَبْوَاب','Двери; врата'],['جِبَال','Горы'],['أَفْوَاه','Рты; уста'],
 ['آتَى','Давать; даровать'],['أَدْرَى','Давать знать; извещать'],['كَفَّرَ','Искупать; стирать (грехи)']]) {
 if (ru) assert.equal(byAr(ar)?.ru,ru);
}
assert.equal(byAr('مَاء')?.ru,'Вода');
assert.equal(byAr('يَذَرُ')?.inputForm,'present');
assert.ok(!byAr('وَذَرَ'));
assert.equal(byAr('كَادَ')?.verbForms.length,2);
assert.match(byAr('تَوَّاب')?.ru,/Принимающий покаяние/);
assert.match(byAr('حَيَّ')?.ru,/Жить/);
assert.ok(!/приветств/iu.test(byAr('حَيَّ').ru));
const memory = new Map();
const context = {console,URL,Date,Math,Set,Map,Promise,crypto,
 localStorage:{getItem:k=>memory.get(k)||null,setItem:(k,v)=>memory.set(k,v),removeItem:k=>memory.delete(k)},
 document:{getElementById(){return null;},querySelectorAll(){return [];},querySelector(){return null;}},
 window:{addEventListener(){},scrollTo(){}},
 setTimeout(){return 1;},clearTimeout(){},setInterval(){return 1;},clearInterval(){},
 ErrorLog:{capture(e){throw e;},invariant(ok,msg){assert.ok(ok,msg);},diagnostic(){}},
 alert(){},Api:{call:async()=>({})}
};
vm.createContext(context);
for (const file of ['state','helpers','quran-vocab','training-setup','quiz','daily'])
 vm.runInContext(read('src/'+file+'.js'),context,{filename:file+'.js'});
const run = code => vm.runInContext(code,context);
context.rows=data.words.map(w=>({id:10000+w.rank,course_name:data.course,lesson_number:String(w.block),word_ar:w.ar,word_ru:w.ru,
 vocabulary_meta:{dataset:data.revision,rank:w.rank,kind:w.kind,inputForm:w.inputForm}}));
run("App.username='quran-test';App.volume=QURAN_COURSE_ID;Dict.allWords=rows.map(r=>trainingWordFromRow(r));Dict.byLesson=buildTrainingVolumeCatalog(Dict.allWords).byLesson;loadTrainingSetupPreferences();");
assert.equal(run('QURAN_DATASET_REVISION'),data.revision);
assert.equal(run('QURAN_COURSE_TITLE'),data.title);
for (const mode of ['learn','type-ar','review','mix']) {
 context.mode=mode;
 assert.equal(run("TrainingSetup.normalSelections[App.volume] ||= {};TrainingSetup.normalSelections[App.volume][mode]=['1','2'];getTrainingSelectedWords(mode).length"),100);
}
assert.equal(run('trainingVolumeIds().length'),5);
assert.equal(run("TrainingSetup.fastCatalog[App.volume]=buildTrainingVolumeCatalog(Dict.allWords);TrainingSetup.fastSelections[App.volume]=['16'];getTrainingSelectedWords('fast').length"),9);
run("for(const w of Dict.allWords){for(const part of parseArabicAnswerSpec(w.ar).parts){if(!isArabicAnswerCorrect(part,w.ar,'strict')||!isArabicAnswerCorrect(rmH(part),w.ar,'learning')) throw new Error('Input: '+w.ar);}if(isArabicAnswerCorrect('xyz',w.ar,'learning')||isQuranAlternateAnswerCorrect('xyz',w,'learning'))throw new Error('False accept');if(copyTrainingWord(w).vocabularyMeta.dataset!==QURAN_DATASET_REVISION)throw new Error('Lost metadata');}");
run("for(const w of Dict.allWords.filter(w=>w.vocabularyMeta.inputForm==='construction')) {const input=w.ar.replace(/[.ـ]/g,' ').replace(/\\s+/g,' ').trim();if(!isQuranAlternateAnswerCorrect(input,w,'strict')||!isQuranAlternateAnswerCorrect(rmH(input),w,'learning'))throw new Error('Construction: '+w.ar);}");
const html=run('renderQuranDictionary(Dict.allWords.slice(0,50))');
assert.match(html,/759 карточек/);
assert.match(html,/Блок 1/);
assert.match(html,/Understand Al-Qur’an Academy/);
assert.ok(!/1000|Вхождений группы|quran-word-meta|quran-word-source|частотности/.test(html));
assert.equal((html.match(/class="quran-word"/g)||[]).length,50);
assert.match(run("quranInputHint(Dict.allWords.find(w=>w.vocabularyMeta.inputForm==='present'))"),/настоящее время/);
assert.match(run("quranInputHint(Dict.allWords.find(w=>w.vocabularyMeta.inputForm==='past'))"),/прошедшего/);
assert.match(run("quranInputHint(Dict.allWords.find(w=>w.vocabularyMeta.kind==='plural'))"),/множественное/);
assert.match(run("quranInputHint(Dict.allWords.find(w=>w.vocabularyMeta.inputForm==='past-phrase'))"),/вместе/);
assert.match(run("quranInputHint(Dict.allWords.find(w=>w.vocabularyMeta.inputForm==='construction'))"),/без многоточия/);
assert.equal(run("quranInputHint({volume:VOLUMES.med[0].id})"),'');
run("var twins=Dict.allWords.filter(w=>w.ru==='Спасать; избавлять');");
assert.ok(run('twins.length>=2'));
assert.equal(run("isQuranAlternateAnswerCorrect(twins[1].ar,twins[0],'learning')"),true);
for(const minutes of [5,10,20,25,30]) {
 context.minutes=minutes;
 const plan=JSON.parse(JSON.stringify(run("buildDailyGoalPlan({...dailyGoalTargets(minutes),goal_date:appDateKey(),course_name:App.volume})")));
 assert.equal(plan.tasks.length,minutes*4);
 assert.equal(new Set(plan.tasks.map(t=>t.word.ar)).size,minutes*4);
 assert.ok(plan.tasks.every(t=>t.word.volume===data.course&&t.word.vocabularyMeta.dataset===data.revision));
 const counts=Object.fromEntries(['new','review','typing'].map(c=>[c,plan.tasks.filter(t=>t.category===c).length]));
 assert.ok(Math.max(...Object.values(counts))-Math.min(...Object.values(counts))<=1);
 if(minutes===10) assert.deepEqual(counts,{new:13,review:14,typing:13});
 context.plan=plan;
 assert.equal(run("dailyPlanMatches(plan,{...dailyGoalTargets(minutes),goal_date:appDateKey(),course_name:App.volume})"),true);
 const before=plan.tasks.length;
 run("applyDailyServerProgress(plan,{new_completed:3,review_completed:4,typing_completed:2})");
 assert.equal(plan.tasks.filter(t=>t.done).length,9);
 assert.equal(plan.tasks.length,before);
 run('delete plan.tasks[0].word.vocabularyMeta.dataset');
 assert.equal(run("dailyPlanMatches(plan,{...dailyGoalTargets(minutes),goal_date:appDateKey(),course_name:App.volume})"),false);
}
assert.equal(run("quranProgressIsStale({volume:App.volume,queue:Dict.allWords.slice(0,2)})"),false);
assert.equal(run("quranProgressIsStale({volume:VOLUMES.med[0].id,queue:[{ar:'كِتَابٌ',ru:'Книга'}]})"),false);
context.legacy={username:'quran-test',volume:data.course,mode:'type-ar',queue:[{ar:'قديم',ru:'старый',volume:data.course}]};
memory.set('arabic_progress',JSON.stringify(context.legacy));
assert.equal(await run('restoreProgress({skipPrompt:true})'),false);
assert.equal(memory.has('arabic_progress'),false);
// Saved legacy Quran blocks are not silently applied to different words.
// The student's Medina selections and quantities stay unchanged.
memory.set('arabic_training_setup_v2:quran-test',JSON.stringify({version:2,normalSelections:{[data.course]:{learn:['20']},'Мединский курс (Том 1)':{learn:['2']}},fastSelections:{[data.course]:['20'],'Мединский курс (Том 2)':['3']},quantities:{learn:25}}));
run('TrainingSetup.loadedFor=null;loadTrainingSetupPreferences()');
assert.equal(run('TrainingSetup.normalSelections[QURAN_COURSE_ID]'),undefined);
assert.equal(run("TrainingSetup.normalSelections[VOLUMES.med[0].id].learn[0]"),'2');
assert.equal(run('TrainingSetup.quantities.learn'),25);
const api=read('supabase/functions/api/index.ts');
const allow=api.match(/function isSupportedLearningCourse\(courseName: string\) \{[\s\S]*?\n\}/)[0].replace(': string','');
run(allow);
assert.equal(run('isSupportedLearningCourse(QURAN_COURSE_ID)'),true);
for(const asset of ['src/quran-vocab.js','src/quran-vocab.css']) assert.ok(read('index.html').includes(asset));
console.log('Academy Quran vocabulary: 759 cards / 16 blocks, all 763 source rows, input variants, five modes, daily quotas and legacy-cache safeguards passed.');
