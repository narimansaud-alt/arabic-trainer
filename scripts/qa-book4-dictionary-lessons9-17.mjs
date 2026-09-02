import fs from 'node:fs';
import assert from 'node:assert/strict';
import {chromium} from 'playwright';
const live=process.argv.includes('--live');
const source=JSON.parse(fs.readFileSync('data/book4-dictionary-lessons9-17.json','utf8'));
const backup=live?[]:JSON.parse(fs.readFileSync('.local/backups/book4-917-before-20260902.json','utf8'));
const expected=source.lessons.flatMap(l=>l.rows.flatMap(([,ar,ru,plural,pluralRu],i)=>
  [[ar,ru,plural?'singular':'single'],...(plural?[[plural,pluralRu,'plural']]:[])]
  .map(([word_ar,word_ru,dictionary_form])=>({course_name:source.course,lesson_number:String(l.lesson),
    word_ar,word_ru,dictionary_form,dictionary_row:i+1}))));
const fixture=backup.filter(w=>!(w.course_name===source.course&&source.lessons.some(l=>String(l.lesson)===w.lesson_number)))
  .concat(expected.map((w,i)=>({...w,id:50000+i})));
const output='.local/qa/book4-dictionary-9-17-'+(live?'live':'fixture');
fs.mkdirSync(output,{recursive:true});
const browser=await chromium.launch({headless:true,executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe'});
const reports=[];
try {
 for(const width of [390,1365]) {
  const context=await browser.newContext({viewport:{width,height:900},serviceWorkers:'block'});
  const page=await context.newPage();
  const errors=[];
  page.on('pageerror',e=>errors.push(e.message));
  page.on('console',m=>{if(m.type()==='error')errors.push(m.text())});
  await page.route('**/functions/v1/**',r=>r.fulfill({status:200,contentType:'application/json',body:'{}'}));
  await page.route('**/rest/v1/**',async route=>{
    const url=new URL(route.request().url());
    if(url.pathname.endsWith('/words')) {
      if(live) return route.continue();
      const course=url.searchParams.get('course_name')?.slice(3);
      const offset=Number(url.searchParams.get('offset')||0),limit=Number(url.searchParams.get('limit')||1000);
      return route.fulfill({status:200,contentType:'application/json',body:JSON.stringify(fixture.filter(w=>w.course_name===course).sort((a,b)=>Number(a.lesson_number)-Number(b.lesson_number)||a.id-b.id).slice(offset,offset+limit))});
    }
    return route.fulfill({status:200,contentType:'application/json',body:'[]'});
  });
  await page.goto('https://arabic-trainer.narimansaud.workers.dev/index.html',{waitUntil:'domcontentloaded'});
  await page.locator('#screen-login.active').waitFor();
  await page.evaluate(async course=>{
    App.username='isolated-book4-917-audit';
    App.volume=course;App.dailyGoalSelected=true;App.favorites=[];App.wordStats={};
    Api.call=async()=>({});
    showScreen('screen-app');switchTab('dict');
    await loadDict();
  },source.course);
  for(const l of source.lessons) {
    const lesson=String(l.lesson),rows=expected.filter(w=>w.lesson_number===lesson);
    await page.evaluate(lesson=>{
      showScreen('screen-app');switchTab('dict');
      Settings.dictLesson=lesson;Settings.dictView='list';
      document.getElementById('dict-search').value='';renderDict();
    },lesson);
    await page.locator('#dict-lesson-row button').filter({hasText:new RegExp('^Ур\\. '+lesson+'$')}).click();
    await page.locator('[data-dict-view="list"]').click();
    assert.equal(await page.locator('#dict-content .dict-item').count(),rows.length);
    const list=await page.locator('#dict-content .dict-item').evaluateAll(items=>items.map(item=>({
      ar:item.querySelector('.dict-ar').textContent.trim(),ru:item.querySelector('.dict-ru').textContent.trim()
    })));
    assert.deepEqual(list,rows.map(w=>({ar:w.word_ar,ru:w.word_ru})));
    const metrics=async selector=>page.locator(selector).evaluateAll(nodes=>({
      rtl:nodes.every(n=>getComputedStyle(n).direction==='rtl'),
      minPx:Math.min(...nodes.map(n=>parseFloat(getComputedStyle(n).fontSize))),
      clipped:nodes.some(n=>n.scrollWidth>n.clientWidth+1||n.scrollHeight>n.clientHeight+1),
      overflow:document.documentElement.scrollWidth>innerWidth+1
    }));
    const listMetrics=await metrics('#dict-content .dict-ar');
    assert.ok(listMetrics.rtl&&listMetrics.minPx>=20&&!listMetrics.clipped&&!listMetrics.overflow,JSON.stringify(listMetrics));
    await page.screenshot({path:output+'/'+width+'-lesson'+lesson+'-list.png',fullPage:true});
    await page.locator('[data-dict-view="table"]').click();
    const table=await page.locator('#dict-content tbody tr').evaluateAll(nodes=>nodes.map(n=>[...n.querySelectorAll('td')].map(n=>n.textContent.trim())));
    assert.deepEqual(table,l.rows.map(([,ar,ru,plural])=>[ru,plural||'—',ar]));
    const tableMetrics=await metrics('#dict-content .dict-book-ar');
    assert.ok(tableMetrics.rtl&&tableMetrics.minPx>=20&&!tableMetrics.clipped&&!tableMetrics.overflow,JSON.stringify(tableMetrics));
    await page.screenshot({path:output+'/'+width+'-lesson'+lesson+'-table.png',fullPage:true});
    const result=await page.evaluate(lesson=>{
      loadTrainingSetupPreferences();
      const words=Dict.byLesson[lesson];
      TrainingSetup.normalSelections[App.volume]={};
      const modes={};
      for(const mode of ['learn','type-ar','review','mix']) {
        TrainingSetup.normalSelections[App.volume][mode]=[lesson];
        modes[mode]=getTrainingSelectedWords(mode).map(w=>w.ar);
      }
      TrainingSetup.fastCatalog={[App.volume]:buildTrainingVolumeCatalog(Dict.allWords)};
      TrainingSetup.fastSelections={[App.volume]:[lesson]};
      modes.fast=getTrainingSelectedWords('fast').map(w=>w.ar);
      const counts=new Map();
      Dict.allWords.forEach(w=>counts.set(w.ar,(counts.get(w.ar)||0)+1));
      const freshWords=words.filter(w=>counts.get(w.ar)===1).sort((a,b)=>
        Number(b.dictionaryForm==='plural')-Number(a.dictionaryForm==='plural')).slice(0,13);
      const freshSet=new Set(freshWords.map(w=>w.ar));
      App.wordStats=Object.fromEntries(Dict.allWords.filter(w=>!freshSet.has(w.ar)).map(w=>[w.ar,{seen:2,level:3,next:null}]));
      const daily=[];
      for(const minutes of [5,10,20,25,30]) {
        const row=normalizeDailyGoalRow({...dailyGoalTargets(minutes),username:App.username,goal_date:appDateKey(),course_name:App.volume});
        const plan=buildDailyGoalPlan(row);
        const fresh=plan.tasks.filter(t=>t.category==='new');
        daily.push({minutes,total:plan.tasks.length,unique:new Set(plan.tasks.map(t=>t.word.ar)).size,
          categories:['new','review','typing'].map(c=>plan.tasks.filter(t=>t.category===c).length),
          ...(minutes===10?{freshIncluded:[...freshSet].every(ar=>fresh.some(t=>t.word.ar===ar&&t.word.lesson===lesson)), freshCount:freshSet.size,
            pluralRu:fresh.filter(t=>t.word.dictionaryForm==='plural').map(t=>t.word.ru)}:{})});
      }
      return {modes,daily};
    },lesson);
    for(const words of Object.values(result.modes)) assert.deepEqual(words,rows.map(w=>w.word_ar));
    const categories=[[7,7,6],[13,14,13],[27,27,26],[33,34,33],[40,40,40]];
    result.daily.forEach((d,i)=>{assert.equal(d.total,d.minutes*4);assert.equal(d.unique,d.total);assert.deepEqual(d.categories,categories[i]);});
    assert.equal(result.daily[1].freshIncluded,true);
    for(const ru of result.daily[1].pluralRu)
      assert.ok(expected.some(w=>w.dictionary_form==='plural'&&w.word_ru===ru),'daily plural '+ru);
    reports.push({width,lesson,cards:rows.length,tableRows:table.length,listMetrics,tableMetrics,modes:Object.keys(result.modes),daily:result.daily});
  }
  assert.deepEqual(errors,[]);
  await context.close();
 }
 fs.writeFileSync(output+'/report.json',JSON.stringify(reports,null,2));
 console.log(JSON.stringify(reports.map(r=>({width:r.width,lesson:r.lesson,cards:r.cards,tableRows:r.tableRows,modes:r.modes,daily:r.daily.map(d=>({minutes:d.minutes,total:d.total,unique:d.unique,categories:d.categories,freshIncluded:d.freshIncluded}))})),null,2));
} finally {await browser.close();}
