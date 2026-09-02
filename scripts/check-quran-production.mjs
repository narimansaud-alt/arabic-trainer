// Read-only reference-data verification and deliberately unauthenticated API checks.
import fs from 'node:fs';
import assert from 'node:assert/strict';
const api=fs.readFileSync('src/api.js','utf8');
const value=name=>api.match(new RegExp("const\\s+"+name+"\\s*=\\s*['\"]([^'\"]+)['\"]"))[1];
const base=value('SUPA_URL'),key=value('SUPA_ANON_KEY');
const headers={apikey:key,authorization:'Bearer '+key,'content-type':'application/json'};
const data=JSON.parse(fs.readFileSync('data/quran-vocabulary.json','utf8'));
const qs=new URLSearchParams({select:'id,word_ar,word_ru,lesson_number,vocabulary_meta',course_name:'eq.'+data.course});
const response=await fetch(base+'/rest/v1/words?'+qs,{headers,signal:AbortSignal.timeout(20000)});
assert.equal(response.status,200);
const words=(await response.json()).sort((a,b)=>a.vocabulary_meta.rank-b.vocabulary_meta.rank);
assert.equal(words.length,1000);
assert.equal(new Set(words.map(w=>w.id)).size,1000);
for(const [i,w] of words.entries()) {
 assert.equal(w.word_ar,data.words[i].ar);
 assert.equal(w.word_ru,data.words[i].ru);
 assert.equal(w.lesson_number,String(data.words[i].block));
 assert.equal(w.vocabulary_meta.frequency,data.words[i].frequency);
}
for(const period of ['all','day','week','month']) {
 const result=await fetch(base+'/rest/v1/rpc/get_public_leaderboard',{method:'POST',headers,
  body:JSON.stringify({p_type:'score',p_period:period,p_limit:1}),signal:AbortSignal.timeout(20000)});
 assert.equal(result.status,200,period);
 assert.ok(Array.isArray(await result.json()));
}
for(const endpoint of ['api-v2','api']) {
 const result=await fetch(base+'/functions/v1/'+endpoint,{method:'POST',headers,
  body:JSON.stringify({action:'log-score',username:'quran-unauthenticated-check',course_name:data.course,points:1}),
  signal:AbortSignal.timeout(20000)});
 assert.equal(result.status,401,endpoint+' must reject writes without an account credential');
}
const gate=await fetch(base+'/functions/v1/api-v2',{method:'POST',headers:{'content-type':'application/json'},
 body:JSON.stringify({action:'get-state'}),signal:AbortSignal.timeout(20000)});
assert.equal(gate.status,401,'JWT gate remains enabled');
console.log('Production: 1000 exact words and metadata; four public score periods OK; both APIs reject unauthenticated writes; v2 JWT gate intact.');
