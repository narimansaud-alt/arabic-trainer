// dict.js — dictionary & rules tabs, plus the lesson-pill selector used
// on the training screen. All reads here are public reference data
// (words, rules) via the anon client.

function buildLessonPills(rowId, lessons, onSelect) {
  const row = document.getElementById(rowId);
  row.innerHTML = '';
  const allBtn = document.createElement('button');
  allBtn.className = 'lb-pill active';
  allBtn.textContent = 'Все';
  allBtn.onclick = () => {
    row.querySelectorAll('.lb-pill').forEach((b) => b.classList.remove('active'));
    allBtn.classList.add('active');
    onSelect('all');
  };
  row.appendChild(allBtn);
  Array.from(lessons)
    .sort((a, b) => (isNaN(a) || isNaN(b) ? String(a).localeCompare(String(b)) : parseFloat(a) - parseFloat(b)))
    .forEach((l) => {
      const btn = document.createElement('button');
      btn.className = 'lb-pill';
      btn.textContent = 'Ур. ' + l;
      btn.onclick = () => {
        row.querySelectorAll('.lb-pill').forEach((b) => b.classList.remove('active'));
        btn.classList.add('active');
        onSelect(String(l));
      };
      row.appendChild(btn);
    });
}

async function loadDict() {
  document.getElementById('cloud-status').textContent = 'Загрузка слов... ⏳';
  document.getElementById('btn-start').disabled = true;
  document.getElementById('btn-fav').disabled = true;
  const { data, error } = await db.from('words').select('*').eq('course_name', App.volume);
  if (error || !data || !data.length) {
    document.getElementById('cloud-status').textContent = '⚠️ Слова не найдены';
    document.getElementById('dict-content').innerHTML = '<div class="lb-empty">Слова ещё не добавлены</div>';
    return;
  }
  Dict.byLesson = {};
  Dict.allWords = [];
  const lessons = new Set();
  data.forEach((r) => {
    const k = r.lesson_number;
    if (!Dict.byLesson[k]) Dict.byLesson[k] = [];
    Dict.byLesson[k].push({ ar: r.word_ar, ru: r.word_ru, lesson: k });
    lessons.add(k);
    Dict.allWords.push({ ar: r.word_ar, ru: r.word_ru, lesson: k });
  });
  document.getElementById('cloud-status').textContent = '✅ Загружено: ' + Dict.allWords.length + ' слов';
  const g = document.getElementById('lesson-grid');
  g.innerHTML = '';
  Array.from(lessons)
    .sort((a, b) => (isNaN(a) || isNaN(b) ? String(a).localeCompare(String(b)) : parseFloat(a) - parseFloat(b)))
    .forEach((l) => {
      const btn = document.createElement('button');
      btn.className = 'lesson-pill';
      btn.dataset.lesson = l;
      btn.textContent = 'Ур. ' + l;
      btn.onclick = () => btn.classList.toggle('active');
      g.appendChild(btn);
    });
  document.getElementById('btn-start').disabled = false;
  document.getElementById('btn-fav').disabled = false;
  buildLessonPills('dict-lesson-row', lessons, (l) => {
    Settings.dictLesson = l;
    renderDict();
  });
  renderDict();
}

function setDictLesson(l, btn) {
  Settings.dictLesson = l;
  document.querySelectorAll('#dict-lesson-row .lb-pill').forEach((b) => b.classList.remove('active'));
  btn.classList.add('active');
  renderDict();
}
function setRulesLesson(l, btn) {
  Settings.rulesLesson = l;
  document.querySelectorAll('#rules-lesson-row .lb-pill').forEach((b) => b.classList.remove('active'));
  btn.classList.add('active');
  renderRules();
}

function renderDict() {
  const q = (document.getElementById('dict-search').value || '').trim().toLowerCase();
  let words = Dict.allWords;
  if (Settings.dictLesson !== 'all') words = words.filter((w) => String(w.lesson) === Settings.dictLesson);
  if (q) words = words.filter((w) => w.ar.includes(q) || w.ru.toLowerCase().includes(q));
  const cont = document.getElementById('dict-content');
  if (!words.length) {
    cont.innerHTML = '<div class="lb-empty">Ничего не найдено</div>';
    return;
  }
  if (Settings.dictLesson === 'all' && !q) {
    const byL = {};
    words.forEach((w) => {
      if (!byL[w.lesson]) byL[w.lesson] = [];
      byL[w.lesson].push(w);
    });
    cont.innerHTML = Object.keys(byL)
      .sort((a, b) => (isNaN(a) || isNaN(b) ? String(a).localeCompare(String(b)) : parseFloat(a) - parseFloat(b)))
      .map(
        (l) =>
          `<div class="dict-section"><div class="dict-section-hdr">📖 Урок ${l} — ${
            byL[l].length
          } слов</div>${byL[l]
            .map((w) => `<div class="dict-item"><span class="dict-ar">${w.ar}</span><span class="dict-ru">${w.ru}</span></div>`)
            .join('')}</div>`
      )
      .join('');
  } else {
    cont.innerHTML = `<div class="dict-section">${words
      .map((w) => `<div class="dict-item"><span class="dict-ar">${esc(w.ar)}</span><span class="dict-ru">${esc(w.ru)}</span></div>`)
      .join('')}</div>`;
  }
}

// RULES
async function loadRulesAll() {
  const vols = VOLUMES[currentCourseKey] || [];
  Dict.rules = [];
  for (const v of vols) {
    const { data } = await db.from('rules').select('*').eq('course_name', v.id).order('lesson_number');
    if (data && data.length) Dict.rules = Dict.rules.concat(data.map((r) => ({ ...r, volLabel: v.label })));
  }
  if (!Dict.rules.length) {
    document.getElementById('rules-content').innerHTML =
      '<div class="lb-empty">Правила ещё не добавлены.<br><small>Добавьте через Supabase → таблица rules</small></div>';
    return;
  }
  const lessons = new Set(Dict.rules.map((r) => r.lesson_number));
  buildLessonPills('rules-lesson-row', lessons, (l) => {
    Settings.rulesLesson = l;
    renderRules();
  });
  renderRules();
}

function togglePw(id, btn) {
  const inp = document.getElementById(id);
  if (inp.type === 'password') {
    inp.type = 'text';
    btn.textContent = '🙈';
  } else {
    inp.type = 'password';
    btn.textContent = '👁️';
  }
}

function wrapArabic(text) {
  if (!text) return text;
  return text.replace(
    /[؀-ۿݐ-ݿࢠ-ࣿﭐ-﷿ﹰ-﻿]+(?:[\s؀-ۿݐ-ݿࢠ-ࣿﭐ-﷿ﹰ-﻿]*[؀-ۿݐ-ݿࢠ-ࣿﭐ-﷿ﹰ-﻿]+)*/g,
    (m) => '<span class="ar-text">' + m + '</span>'
  );
}

function renderRules() {
  const q = (document.getElementById('rules-search').value || '').trim().toLowerCase();
  let rules = Dict.rules;
  if (Settings.rulesLesson !== 'all') rules = rules.filter((r) => String(r.lesson_number) === Settings.rulesLesson);
  if (q) rules = rules.filter((r) => r.title.toLowerCase().includes(q) || r.content.toLowerCase().includes(q));
  const cont = document.getElementById('rules-content');
  if (!rules.length) {
    cont.innerHTML = '<div class="lb-empty">Ничего не найдено</div>';
    return;
  }
  const grouped = {};
  rules.forEach((r) => {
    const k = r.lesson_number;
    if (!grouped[k]) grouped[k] = [];
    grouped[k].push(r);
  });
  Object.keys(grouped).forEach((k) => {
    grouped[k].sort((a, b) => {
      const aS = a.title.startsWith('Таблица') ? 1 : -1;
      const bS = b.title.startsWith('Таблица') ? 1 : -1;
      if (aS !== bS) return aS - bS;
      return a.id - b.id;
    });
  });
  const lessons = Object.keys(grouped).sort((a, b) => Number(a) - Number(b));
  cont.innerHTML = lessons
    .map((lesson) => {
      const items = grouped[lesson];
      return (
        '<div class="dict-section"><div class="rule-lesson-header">Урок ' +
        lesson +
        '</div>' +
        items
          .map((r, i) => '<div class="rule-item"><div class="rule-title">' + (i + 1) + '. ' + wrapArabic(r.title) + '</div><div class="rule-content">' + wrapArabic(r.content) + '</div></div>')
          .join('') +
        '</div>'
      );
    })
    .join('');
  cont.querySelectorAll('.rule-content table').forEach((t) => {
    const w = document.createElement('div');
    w.className = 'tbl-wrap';
    t.parentNode.insertBefore(w, t);
    w.appendChild(t);
  });
}

// TABS
function switchTab(t) {
  document.querySelectorAll('.tab-content').forEach((p) => p.classList.remove('active'));
  document.querySelectorAll('.app-tab').forEach((b) => b.classList.remove('active'));
  document.getElementById('tab-' + t).classList.add('active');
  document.getElementById('at-' + t).classList.add('active');
  if (t === 'lb') loadLB();
  if (t === 'dict') renderDict();
  if (t === 'rules') renderRules();
}

function selAll(v) {
  document.querySelectorAll('.lesson-pill').forEach((p) => p.classList.toggle('active', v));
}
