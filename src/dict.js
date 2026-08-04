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
  Dict.rules = [];
  Settings.rulesLesson = 'all';
  const volume = findVolumeById(App.volume);
  if (!volume) return;
  const { data } = await db.from('rules').select('*').eq('course_name', App.volume).order('lesson_number');
  if (data && data.length) Dict.rules = data.map((r) => ({ ...r, volLabel: volume.label }));
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

function stripRuleHtml(html) {
  const div = document.createElement('div');
  div.innerHTML = String(html || '').replace(/<br\s*\/?>/gi, ' ');
  return div.textContent.replace(/\s+/g, ' ').trim();
}

function ruleBlockClass(blockHtml) {
  const plain = stripRuleHtml(blockHtml).toLowerCase();
  if (/и[‘'`ʼ’]?раб|إعراب|إِعْرَاب/.test(plain)) return 'is-irab';
  if (/важно|секрет|запомн|внимание/.test(plain)) return 'is-important';
  if (/пример|مثال/.test(plain)) return 'is-example';
  if (/логика|суть|как сказать|как читать/.test(plain)) return 'is-logic';
  if (/правило|новое правило|вспоминаем/.test(plain)) return 'is-rule';
  return '';
}

function formatRuleContent(html) {
  if (!html) return '';
  const tables = [];
  let safe = String(html).replace(/<table[\s\S]*?<\/table>/gi, (m) => {
    const idx = tables.length;
    tables.push(m);
    return '%%RULE_TABLE_' + idx + '%%';
  });
  safe = safe.replace(/<br\s*\/?>\s*(и[‘'`ʼ’]?раб\s*:)/gi, '<br><br>$1');
  const parts = safe
    .split(/(?:<br\s*\/?>\s*){2,}/i)
    .map((part) => part.trim())
    .filter(Boolean);
  const blocks = (parts.length ? parts : [safe]).map((part) => {
    const restored = part.replace(/%%RULE_TABLE_(\d+)%%/g, (_, i) => tables[Number(i)] || '');
    const cls = ruleBlockClass(restored);
    return '<div class="rule-block ' + cls + '">' + restored + '</div>';
  });
  return '<div class="rule-flow">' + blocks.join('') + '</div>';
}

function highlightRuleMatches(root, query) {
  if (!query) return;
  const needle = query.toLowerCase();
  const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
    acceptNode(node) {
      if (!node.nodeValue || !node.nodeValue.toLowerCase().includes(needle)) return NodeFilter.FILTER_REJECT;
      if (node.parentElement && ['MARK', 'SCRIPT', 'STYLE'].includes(node.parentElement.tagName)) return NodeFilter.FILTER_REJECT;
      return NodeFilter.FILTER_ACCEPT;
    },
  });
  const nodes = [];
  while (walker.nextNode()) nodes.push(walker.currentNode);
  nodes.forEach((node) => {
    const text = node.nodeValue;
    const lower = text.toLowerCase();
    const frag = document.createDocumentFragment();
    let pos = 0;
    let idx = lower.indexOf(needle);
    while (idx !== -1) {
      if (idx > pos) frag.appendChild(document.createTextNode(text.slice(pos, idx)));
      const mark = document.createElement('mark');
      mark.textContent = text.slice(idx, idx + query.length);
      frag.appendChild(mark);
      pos = idx + query.length;
      idx = lower.indexOf(needle, pos);
    }
    if (pos < text.length) frag.appendChild(document.createTextNode(text.slice(pos)));
    node.parentNode.replaceChild(frag, node);
  });
}

function toggleRuleCard(btn) {
  const card = btn.closest('.rule-card');
  if (!card) return;
  const open = !card.classList.contains('open');
  card.classList.toggle('open', open);
  btn.setAttribute('aria-expanded', open ? 'true' : 'false');
}

function ruleSortValue(rule) {
  const n = Number(rule.sort_order);
  if (Number.isFinite(n) && n > 0) return n;
  return rule.title.startsWith('Таблица') ? 10000 + Number(rule.id || 0) : Number(rule.id || 0);
}

function ruleAccent(rule, idx) {
  const accents = {
    table: 1,
    example: 2,
    irab: 3,
    important: 4,
    logic: 5,
    note: 0,
  };
  return accents[rule.rule_kind] ?? idx % 6;
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
      const byOrder = ruleSortValue(a) - ruleSortValue(b);
      if (byOrder !== 0) return byOrder;
      return a.id - b.id;
    });
  });
  const lessons = Object.keys(grouped).sort((a, b) => Number(a) - Number(b));
  cont.innerHTML = lessons
    .map((lesson) => {
      const items = grouped[lesson];
      const openCards = q || Settings.rulesLesson !== 'all';
      return (
        '<div class="rule-lesson-card"><div class="rule-lesson-header">' +
        '<div class="rule-lesson-kicker">Урок ' +
        lesson +
        '</div><div class="rule-lesson-title">Что нужно запомнить</div><div class="rule-lesson-meta">' +
        items.length +
        ' ' +
        (items.length === 1 ? 'правило' : items.length < 5 ? 'правила' : 'правил') +
        '</div></div><div class="rule-topic-list">' +
        items.map((r) => '<span class="rule-topic-chip">' + wrapArabic(esc(r.title)) + '</span>').join('') +
        '</div><div class="rule-list">' +
        items
          .map((r, i) => {
            const rawPreview = r.summary || (/<table[\s\S]*?>/i.test(r.content) ? 'Сводная таблица с примерами по теме урока' : stripRuleHtml(r.content));
            const preview = rawPreview.slice(0, 170);
            return (
              '<div class="rule-card accent-' +
              ruleAccent(r, i) +
              (openCards ? ' open' : '') +
              '"><button class="rule-card-head" type="button" aria-expanded="' +
              (openCards ? 'true' : 'false') +
              '" onclick="toggleRuleCard(this)"><span class="rule-index">' +
              (i + 1) +
              '</span><span class="rule-title-wrap"><span class="rule-title">' +
              wrapArabic(esc(r.title)) +
              '</span><span class="rule-preview">' +
              wrapArabic(esc(preview + (preview.length >= 170 ? '...' : ''))) +
              '</span></span><span class="rule-chevron">›</span></button><div class="rule-card-body"><div class="rule-content">' +
              wrapArabic(formatRuleContent(r.content)) +
              '</div></div></div>'
            );
          })
          .join('') +
        '</div>' +
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
  highlightRuleMatches(cont, q);
}

// TABS
function switchTab(t) {
  document.querySelectorAll('.tab-content').forEach((p) => p.classList.remove('active'));
  document.querySelectorAll('.app-tab').forEach((b) => b.classList.remove('active'));
  document.getElementById('tab-' + t).classList.add('active');
  const tabBtn = document.getElementById('at-' + t);
  if (tabBtn) tabBtn.classList.add('active');
  localStorage.setItem('arabic_last_tab', t);
  if (t === 'lb') loadLB();
  if (t === 'dict') renderDict();
  if (t === 'rules') renderRules();
}

function selAll(v) {
  document.querySelectorAll('.lesson-pill').forEach((p) => p.classList.toggle('active', v));
}
