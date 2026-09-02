// Isolated browser QA: fixture reference data and mocked protected writes.
// Never log in as a student. Usage: node scripts/qa-quran-vocabulary.mjs [baseURL]
import assert from 'node:assert/strict';
import fs from 'node:fs';
import {chromium} from 'playwright';
const data=JSON.parse(fs.readFileSync('data/quran-vocabulary.json','utf8'));
const rows=data.words.map(w=>({id:20000+w.rank,word_ar:w.ar,word_ru:w.ru,
 course_name:data.course,lesson_number:String(w.block),dictionary_form:'single',
 vocabulary_meta:{rank:w.rank,sourceRank:w.sourceRank,frequency:w.frequency,kind:w.kind,
 inputForm:w.sourceRank===250?'present':w.sourceRank===1000?'imperative':w.kind==='verb'?'past':'lemma',
 sourceRecords:w.sourceRecords,note:w.note}}));
const browser=await chromium.launch({headless:true,executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe'});
try {
 const context=await browser.newContext({viewport:{width:390,height:844},serviceWorkers:'block'});
 const page=await context.newPage();
 const errors=[];
 page.on('pageerror',e=>errors.push(e.message));
 page.on('dialog',d=>d.accept());
 await page.route('**/rest/v1/**',async route=>{
  const url=new URL(route.request().url());
  let body=[];
  if(url.pathname.endsWith('/words')) {
   const selected=url.searchParams.get('course_name');
   if(selected==='eq.'+data.course) {
    const offset=Number(url.searchParams.get('offset')||0);
    const limit=Number(url.searchParams.get('limit')||1000);
    body=rows.slice(offset,offset+limit);
   } else body=[{id:1,course_name:selected?.slice(3)||'Мединский курс (Том 1)',lesson_number:'1',word_ar:'كِتَابٌ',word_ru:'Книга'}];
  }
  await route.fulfill({status:200,contentType:'application/json',body:JSON.stringify(body)});
 });
 await page.goto((process.argv[2]||'http://127.0.0.1:8767')+'/index.html',{waitUntil:'domcontentloaded'});
 await page.waitForFunction(()=>typeof renderQuranDictionary==='function');
 await page.locator('#screen-login.active').waitFor({state:'visible'});
 await page.evaluate(()=>{
  App.username='isolated-quran-qa';App.dailyGoalSelected=true;
  window.__qaWrites=[];
  Api.call=async(action,body)=>{
   window.__qaWrites.push({action,body});
   if(action==='get-daily-goal') return {goal:{...dailyGoalTargets(10),goal_date:appDateKey(),course_name:App.volume,new_completed:0,review_completed:0,typing_completed:0},daily_goal_minutes:10};
   return {total_score:10};
  };
  showVolumeScreen('Мединский курс','med');
 });
 await page.locator('.quran-course-card').click();
 await page.waitForFunction(()=>Dict.allWords.length===1000);
 assert.equal(await page.locator('#at-book').isVisible(),false);
 assert.equal(await page.locator('#at-rules').isVisible(),false);
 await page.locator('#at-dict').click();
 assert.equal(await page.locator('.quran-word').count(),1000);
 await page.locator('#dict-lesson-row button').filter({hasText:/^Блок 2$/}).click();
 assert.equal(await page.locator('.quran-word').count(),50);
 await page.locator('[data-dict-view="table"]').click();
 assert.equal(await page.locator('.quran-compact').count(),1);
 await page.locator('.quran-dictionary-intro summary').click();
 assert.ok(await page.getByText('Источник и способ подсчёта').isVisible());
 fs.mkdirSync('.local/qa/quran',{recursive:true});
 await page.screenshot({path:'.local/qa/quran/dictionary-390.png',fullPage:false});
 await page.locator('#at-train').click();
 await page.locator('#mode-btns .mode-pill').filter({hasText:'Арабский ввод'}).click();
 await page.locator('#training-mode-next').click();
 await page.locator('.training-lesson-pill[data-lesson="1"]').click();
 assert.equal(await page.locator('#mode-quantity-max').textContent(),'Всего доступно: 50');
 await page.evaluate(()=>setModeQuantityPreset(10));
 await page.locator('#btn-start').click();
 await page.waitForFunction(()=>Boolean(curWord?.vocabularyMeta));
 assert.equal(await page.locator('#type-format-hint').isVisible(),true);
 assert.ok((await page.locator('#q-source').textContent()).includes('Блок 1'));
 const input=page.locator('#type-input');
 await input.fill(await page.evaluate(()=>curWord.ar));
 await page.evaluate(()=>checkTyped());
 await page.waitForFunction(()=>document.getElementById('feedback').classList.contains('ok'));
 await page.screenshot({path:'.local/qa/quran/input-390.png',fullPage:false});
 const result=await page.evaluate(()=>{
  const first=copyTrainingWord(curWord);
  resetQuizState();
  showScreen('screen-app');
  switchTab('train');
  Settings.mode='fast';TrainingSetup.pageOpen=true;
  return {rank:first.vocabularyMeta.rank,writes:window.__qaWrites.map(w=>w.action)};
 });
 await page.evaluate(()=>ensureFastTrainingCatalog(true));
 await page.evaluate(()=>renderTrainingModeSetup());
 assert.equal(await page.locator('.fast-volume-picker').count(),5);
 await page.evaluate(()=>setAllFastTrainingLessons(false));
 const quranToggle=page.locator('.fast-volume-toggle').filter({hasText:'Слова Корана'});
 if(await quranToggle.getAttribute('aria-expanded')!=='true') await quranToggle.click();
 await page.locator('.training-lesson-pill[data-lesson="20"]').last().click();
 assert.equal(await page.evaluate(()=>getTrainingSelectedWords('fast').length),50);
 await page.screenshot({path:'.local/qa/quran/fast-390.png',fullPage:false});
 const widths=[];
 for(const width of [320,390,768,1280]) {
  await page.setViewportSize({width,height:900});
  widths.push(await page.evaluate(()=>({width:innerWidth,body:document.documentElement.scrollWidth})));
 }
 assert.ok(widths.every(m=>m.body<=m.width+1),JSON.stringify(widths));
 await page.evaluate(()=>selectVolume(VOLUMES.med[0].id));
 assert.equal(await page.locator('#at-book').isVisible(),true);
 assert.equal(await page.locator('#at-rules').isVisible(),true);
 assert.deepEqual(errors,[]);
 console.log(JSON.stringify({dictionary:1000,blocks:20,typing:'accepted',fastCatalog:5,widths,errors,...result},null,2));
} finally {await browser.close();}
