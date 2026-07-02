// verbs.js — "Спряжение" tab: browse verb conjugation tables and drill them.
//
// All conjugation data is pre-generated offline by tools/gen_conjugations.py
// using libqutrub (a rule-based Arabic conjugator), then stored as-is in
// the `verb_conjugations` table. Nothing here computes grammar — it only
// reads and displays the already-correct tables and checks typed answers
// against them, exactly like the reference dictionary tab.

const VerbConj = { byLesson: {}, allVerbs: [] };
let renderedVerbs = [];
let currentDrillVerb = null;
let verbDrillAnswer = '';

const PERSON_LABELS = {
  هو: 'Он',
  هي: 'Она',
  أنت: 'Ты (м.)',
  أنتِ: 'Ты (ж.)',
  أنا: 'Я',
  هم: 'Они (м.)',
  هن: 'Они (ж.)',
  أنتم: 'Вы (м.)',
  أنتن: 'Вы (ж.)',
  نحن: 'Мы',
};
const PERSON_ORDER = ['هو', 'هي', 'أنت', 'أنتِ', 'أنا', 'هم', 'هن', 'أنتم', 'أنتن', 'نحن'];
const DUAL_LABELS = { هما: 'Они (двое)', 'هما مؤ': 'Они (двое, ж.)', أنتما: 'Вы (двое)', 'أنتما مؤ': 'Вы (двое, ж.)' };
const DUAL_ORDER = ['هما', 'هما مؤ', 'أنتما', 'أنتما مؤ'];
const TENSE_LABELS = { past: 'Прошедшее время', present: 'Настоящее время', imperative: 'Повелительное наклонение' };

async function loadVerbs() {
  document.getElementById('verb-content').innerHTML = '<div class="lb-empty">Загрузка...</div>';
  const { data, error } = await db.from('verb_conjugations').select('*').eq('course_name', App.volume);
  if (error || !data || !data.length) {
    document.getElementById('verb-content').innerHTML = '<div class="lb-empty">Глаголы для этого курса пока не добавлены</div>';
    return;
  }
  VerbConj.byLesson = {};
  VerbConj.allVerbs = [];
  const lessons = new Set();
  data.forEach((r) => {
    const v = { ar: r.verb_ar, ru: r.verb_ru, masdar: r.masdar, lesson: r.lesson_number, forms: r.forms };
    if (!VerbConj.byLesson[r.lesson_number]) VerbConj.byLesson[r.lesson_number] = [];
    VerbConj.byLesson[r.lesson_number].push(v);
    lessons.add(r.lesson_number);
    VerbConj.allVerbs.push(v);
  });
  buildLessonPills('verb-lesson-row', lessons, (l) => {
    Settings.verbLesson = l;
    renderVerbs();
  });
  renderVerbs();
}

function setVerbLesson(l, btn) {
  Settings.verbLesson = l;
  document.querySelectorAll('#verb-lesson-row .lb-pill').forEach((b) => b.classList.remove('active'));
  btn.classList.add('active');
  renderVerbs();
}

function renderVerbs() {
  const q = (document.getElementById('verb-search').value || '').trim().toLowerCase();
  let verbs = VerbConj.allVerbs;
  if (Settings.verbLesson !== 'all') verbs = verbs.filter((v) => String(v.lesson) === Settings.verbLesson);
  if (q) verbs = verbs.filter((v) => v.ar.includes(q) || v.ru.toLowerCase().includes(q));
  renderedVerbs = verbs;
  const cont = document.getElementById('verb-content');
  if (!verbs.length) {
    cont.innerHTML = '<div class="lb-empty">Ничего не найдено</div>';
    return;
  }
  cont.innerHTML =
    '<div class="dict-section">' +
    verbs
      .map(
        (v, i) =>
          '<div class="dict-item" style="cursor:pointer;" onclick="openVerbDetail(' +
          i +
          ')"><span class="dict-ar">' +
          esc(v.ar) +
          '</span><span class="dict-ru">' +
          esc(v.ru) +
          '</span></div>'
      )
      .join('') +
    '</div>';
}

function formRows(forms, order, labels) {
  return order
    .filter((p) => forms[p])
    .map((p) => '<div class="verb-form-row"><span class="verb-form-pron">' + labels[p] + '</span><span class="verb-form-ar">' + esc(forms[p]) + '</span></div>')
    .join('');
}

function renderConjugationTable(v) {
  let html = '';
  ['past', 'present', 'imperative'].forEach((tense) => {
    const forms = v.forms[tense];
    if (!forms) return;
    html += '<div class="verb-tense-title">' + TENSE_LABELS[tense] + '</div>' + formRows(forms, PERSON_ORDER, PERSON_LABELS);
  });
  const dualBlocks = ['past', 'present', 'imperative']
    .map((tense) => {
      const forms = v.forms[tense];
      if (!forms) return '';
      const rows = formRows(forms, DUAL_ORDER, DUAL_LABELS);
      return rows ? '<div class="verb-tense-title">' + TENSE_LABELS[tense] + ' (двойств.)</div>' + rows : '';
    })
    .join('');
  html += '<div class="verb-dual-toggle" onclick="toggleVerbDual(this)">Показать двойственное число ▾</div>';
  html += '<div class="hidden" id="verb-dual-block">' + dualBlocks + '</div>';
  if (v.masdar) {
    html += '<div class="verb-tense-title">Масдар</div><div class="verb-form-row"><span class="verb-form-pron">Отглагольное имя</span><span class="verb-form-ar">' + esc(v.masdar) + '</span></div>';
  }
  html += '<button class="btn-start green" style="margin-top:16px;" onclick="startVerbDrill()">🎯 Потренироваться</button>';
  return html;
}

function openVerbDetail(i) {
  currentDrillVerb = renderedVerbs[i];
  document.getElementById('verb-modal-title').textContent = currentDrillVerb.ar;
  document.getElementById('verb-modal-body').innerHTML = renderConjugationTable(currentDrillVerb);
  document.getElementById('verb-modal-overlay').classList.remove('hidden');
}

function closeVerbModal() {
  document.getElementById('verb-modal-overlay').classList.add('hidden');
  currentDrillVerb = null;
}

function toggleVerbDual(el) {
  const block = document.getElementById('verb-dual-block');
  block.classList.toggle('hidden');
  el.textContent = block.classList.contains('hidden') ? 'Показать двойственное число ▾' : 'Скрыть двойственное число ▴';
}

function startVerbDrill() {
  nextVerbDrillPrompt();
}

function nextVerbDrillPrompt() {
  const v = currentDrillVerb;
  const tenses = ['past', 'present'].filter((t) => v.forms[t]);
  const tense = tenses[Math.floor(Math.random() * tenses.length)];
  const persons = PERSON_ORDER.filter((p) => v.forms[tense][p]);
  const person = persons[Math.floor(Math.random() * persons.length)];
  verbDrillAnswer = v.forms[tense][person];
  document.getElementById('verb-modal-body').innerHTML =
    '<div style="text-align:center;margin-bottom:14px;">' +
    '<div class="verb-modal-title" style="font-size:26px;">' +
    esc(v.ar) +
    '</div>' +
    '<div style="font-size:14px;color:#666;margin-top:4px;">' +
    TENSE_LABELS[tense] +
    ' — ' +
    PERSON_LABELS[person] +
    '</div>' +
    '</div>' +
    '<input class="type-input" id="verb-drill-input" type="text" placeholder="اكتب بالعربية..." dir="rtl">' +
    '<div class="feedback" id="verb-drill-feedback"></div>' +
    '<button class="btn-start green" id="verb-drill-check" onclick="checkVerbDrill()">Проверить</button>';
  document.getElementById('verb-drill-input').focus();
}

function checkVerbDrill() {
  const inp = document.getElementById('verb-drill-input');
  const val = rmH(inp.value.trim());
  const correct = rmH(verbDrillAnswer);
  const fb = document.getElementById('verb-drill-feedback');
  inp.disabled = true;
  if (val === correct) {
    fb.className = 'feedback ok';
    fb.textContent = '✅ Правильно!';
  } else {
    fb.className = 'feedback err';
    fb.innerHTML = '❌ Правильно: <span style="font-family:Times New Roman,serif;font-size:22px;direction:rtl;">' + esc(verbDrillAnswer) + '</span>';
  }
  const btn = document.getElementById('verb-drill-check');
  btn.textContent = 'Далее →';
  btn.onclick = nextVerbDrillPrompt;
}
