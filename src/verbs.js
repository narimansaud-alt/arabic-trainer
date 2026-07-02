// verbs.js — "Спряжение" tab: type any Arabic verb, get its conjugation
// table and drill it. Mirrors how qutrub.arabeyes.org itself works: the
// grammar comes from libqutrub (rule-based, not a language model), served
// by a small Cloudflare Python Worker (services/qutrub-worker). The vowel
// of the present tense (فتحة/ضمة/كسرة) is a property of the specific verb
// that can't be derived from spelling alone, so — same as the real
// Qutrub UI — the user picks it.
//
// Every verb the worker successfully conjugates gets cached into
// verb_conjugations (written by the worker itself via its own
// service-role key). This tab checks that cache first, so a verb only
// ever needs the live worker once.

const QUTRUB_WORKER_URL = 'https://arabic-trainer-qutrub.narimansaud.workers.dev';

let currentDrillVerb = null;
let verbDrillAnswer = '';
let selectedVerbVowel = 'ضمة';

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

function setVerbVowel(btn) {
  selectedVerbVowel = btn.dataset.v;
  document.querySelectorAll('#verb-vowel-row .lb-pill').forEach((b) => b.classList.remove('active'));
  btn.classList.add('active');
}

async function conjugateTypedVerb() {
  const verb = document.getElementById('verb-input').value.trim();
  const fb = document.getElementById('verb-input-feedback');
  fb.className = 'feedback';
  fb.textContent = '';
  if (!verb) {
    fb.className = 'feedback err';
    fb.textContent = 'Введите глагол в форме прошедшего времени (فَعَلَ)';
    return;
  }

  const btn = document.getElementById('verb-conjugate-btn');
  btn.disabled = true;
  btn.textContent = '⏳ Спрягаю...';
  try {
    const { data: cached } = await db.from('verb_conjugations').select('*').eq('verb_ar', verb).maybeSingle();
    let forms, verbRu, masdar;
    if (cached) {
      forms = cached.forms;
      verbRu = cached.verb_ru;
      masdar = cached.masdar;
    } else {
      const url = QUTRUB_WORKER_URL + '/conjugate?verb=' + encodeURIComponent(verb) + '&future_type=' + encodeURIComponent(selectedVerbVowel);
      const res = await fetch(url);
      const json = await res.json();
      if (!json.ok) {
        fb.className = 'feedback err';
        fb.textContent = '❌ Не получилось спрягать. Проверьте, что глагол в прошедшем времени и с огласовками, либо попробуйте другую огласовку.';
        return;
      }
      forms = json.forms;
    }
    currentDrillVerb = { ar: verb, ru: verbRu || '', masdar: masdar || null, forms };
    document.getElementById('verb-modal-title').textContent = verb;
    document.getElementById('verb-modal-body').innerHTML = renderConjugationTable(currentDrillVerb);
    document.getElementById('verb-modal-overlay').classList.remove('hidden');
  } catch (e) {
    fb.className = 'feedback err';
    fb.textContent = '⚠️ Сервис временно недоступен. Попробуйте ещё раз через пару секунд.';
  } finally {
    btn.disabled = false;
    btn.textContent = '🔁 Спрягать';
  }
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
