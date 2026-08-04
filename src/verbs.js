// verbs.js — "Спряжение" tab: type any Arabic verb, get its conjugation
// table and drill it. Mirrors how qutrub.arabeyes.org itself works: the
// grammar comes from libqutrub (rule-based, not a language model), served
// by a small Cloudflare Python Worker (services/qutrub-worker). The vowel
// of the present tense (فتحة/ضمة/كسرة) is looked up by the worker in its
// own verb dictionary (arramooz/libqutrub's triverbtable) — the client no
// longer has to ask the user to guess it. When a verb has more than one
// dictionary entry (different meanings conjugate differently), the worker
// picks the primary one and lists the rest as `alternatives`.
//
// Every dictionary-confirmed verb the worker conjugates gets cached
// server-side into verb_conjugations, so a given (verb, meaning) only
// ever needs the live worker once.

const QUTRUB_WORKER_URL = 'https://arabic-trainer-qutrub.narimansaud.workers.dev';

let currentDrillVerb = null;
let verbDrillAnswer = '';
let manualVerbVowel = 'ضمة';

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
const VOWEL_LABELS = { ضمة: 'ضمة (у)', فتحة: 'فتحة (а)', كسرة: 'كسرة (и)' };

function setVerbVowel(btn) {
  manualVerbVowel = btn.dataset.v;
  document.querySelectorAll('#verb-manual-vowel-row .lb-pill').forEach((b) => b.classList.remove('active'));
  btn.classList.add('active');
}

async function fetchConjugation(params) {
  const url = QUTRUB_WORKER_URL + '/conjugate?' + new URLSearchParams(params).toString();
  const res = await fetch(url);
  return res.json();
}

async function conjugateTypedVerb() {
  const verb = document.getElementById('verb-input').value.trim();
  const fb = document.getElementById('verb-input-feedback');
  fb.className = 'feedback';
  fb.textContent = '';
  if (!verb) {
    fb.className = 'feedback err';
    fb.textContent = 'Введите глагол в прошедшем времени (فَعَلَ)';
    return;
  }

  const btn = document.getElementById('verb-conjugate-btn');
  btn.disabled = true;
  btn.textContent = '⏳ Спрягаю...';
  try {
    const json = await fetchConjugation({ verb, future_type: manualVerbVowel });
    if (!json.ok) {
      fb.className = 'feedback err';
      fb.textContent = '❌ Не получилось спрягать. Проверьте написание глагола (форма прошедшего времени).';
      return;
    }
    openVerbResult(json);
  } catch (e) {
    fb.className = 'feedback err';
    fb.textContent = '⚠️ Сервис временно недоступен. Попробуйте ещё раз через пару секунд.';
  } finally {
    btn.disabled = false;
    btn.textContent = '🔁 Спрягать';
  }
}

function openVerbResult(json) {
  currentDrillVerb = {
    ar: json.verb,
    futureType: json.future_type,
    forms: json.forms,
    dictionary: !!json.dictionary,
    alternatives: json.alternatives || [],
  };
  document.getElementById('verb-modal-title').textContent = json.verb;
  document.getElementById('verb-modal-sub').textContent = 'تصريف الفعل';
  document.getElementById('verb-modal-body').innerHTML = renderConjugationTable(currentDrillVerb);
  document.getElementById('verb-modal-overlay').classList.remove('hidden');
}

async function pickVerbAlternative(altVerb, altFutureType) {
  const body = document.getElementById('verb-modal-body');
  const prevHtml = body.innerHTML;
  body.innerHTML = '<div style="text-align:center;padding:20px;">⏳ Спрягаю...</div>';
  try {
    const json = await fetchConjugation({
      verb: currentDrillVerb.ar,
      variant_verb: altVerb,
      variant_future_type: altFutureType,
    });
    if (!json.ok) {
      body.innerHTML = prevHtml;
      return;
    }
    openVerbResult(json);
  } catch (e) {
    body.innerHTML = prevHtml;
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
  if (!v.dictionary) {
    html +=
      '<div class="feedback err" style="margin-bottom:12px;">⚠️ Этого глагола нет в словаре, огласовка настоящего времени подобрана вручную (' +
      esc(VOWEL_LABELS[v.futureType] || v.futureType) +
      '). Если формы выглядят странно — попробуйте другую огласовку ниже и спрягите заново.</div>' +
      '<div class="lb-row-btns" id="verb-manual-vowel-row" style="margin-bottom:12px;">' +
      Object.keys(VOWEL_LABELS)
        .map(
          (k) =>
            '<button class="lb-pill' +
            (k === manualVerbVowel ? ' active' : '') +
            '" data-v="' +
            k +
            '" onclick="setVerbVowel(this)">' +
            VOWEL_LABELS[k] +
            '</button>'
        )
        .join('') +
      '</div>' +
      '<button class="btn-start" style="margin-bottom:16px;" onclick="closeVerbModal();conjugateTypedVerb();">Спрягать заново</button>';
  } else if (v.alternatives.length) {
    html +=
      '<div class="verb-dual-toggle" style="margin-bottom:10px;" onclick="toggleVerbAlternatives(this)">Есть другое значение этого глагола ▾</div>' +
      '<div class="hidden" id="verb-alt-block" style="margin-bottom:12px;">' +
      v.alternatives
        .map(
          (a) =>
            '<button class="lb-pill" style="margin:0 4px 4px 0;" onclick="pickVerbAlternative(\'' +
            a.verb +
            "', '" +
            a.future_type +
            '\')">' +
            esc(a.verb) +
            ' (' +
            esc(VOWEL_LABELS[a.future_type] || a.future_type) +
            ')</button>'
        )
        .join('') +
      '</div>';
  }
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
  html += '<button class="btn-start green" style="margin-top:16px;" onclick="startVerbDrill()">🎯 Потренироваться</button>';
  return html;
}

function closeVerbModal(fromHistory = false) {
  if (!fromHistory && history.state && history.state.app === 'arabic-trainer' && history.state.appModal) {
    history.back();
    return;
  }
  document.getElementById('verb-modal-overlay').classList.add('hidden');
  currentDrillVerb = null;
}

function toggleVerbDual(el) {
  const block = document.getElementById('verb-dual-block');
  block.classList.toggle('hidden');
  el.textContent = block.classList.contains('hidden') ? 'Показать двойственное число ▾' : 'Скрыть двойственное число ▴';
}

function toggleVerbAlternatives(el) {
  const block = document.getElementById('verb-alt-block');
  block.classList.toggle('hidden');
  el.textContent = block.classList.contains('hidden') ? 'Есть другое значение этого глагола ▾' : 'Скрыть другие значения ▴';
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

function normHamzaSeat(t) {
  // Different hamza seats (أ إ آ ؤ ئ ء) are a spelling detail, not a
  // grammatical one — don't fail a drill answer over which seat the
  // learner used.
  return t.replace(/[إأآؤئ]/g, 'ء');
}

function checkVerbDrill() {
  const inp = document.getElementById('verb-drill-input');
  const val = normHamzaSeat(rmH(inp.value.trim()));
  const correct = normHamzaSeat(rmH(verbDrillAnswer));
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
