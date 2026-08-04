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
const QUTRUB_TIMEOUT_MS = 12000;

function escapeJsSingle(value) {
  return String(value || '')
    .replace(/\\/g, '\\\\')
    .replace(/'/g, "\\'")
    .replace(/\r?\n/g, ' ')
    .replace(/\r/g, ' ');
}

function sanitizeConjugationPayload(payload) {
  if (!payload || typeof payload !== 'object') return null;
  if (payload.ok === false) {
    return { ok: false, error: String(payload.error || 'Невозможно получить корректный ответ по этому глаголу.') };
  }
  const verb = String(payload.verb || '').trim();
  const forms = payload.forms || {};
  if (!verb || !forms || typeof forms !== 'object') {
    return null;
  }
  return {
    ok: true,
    verb,
    future_type: String(payload.future_type || manualVerbVowel),
    forms: {
      past: forms.past && typeof forms.past === 'object' ? forms.past : {},
      present: forms.present && typeof forms.present === 'object' ? forms.present : {},
      imperative: forms.imperative && typeof forms.imperative === 'object' ? forms.imperative : {},
    },
    dictionary: Boolean(payload.dictionary),
    alternatives: (Array.isArray(payload.alternatives) ? payload.alternatives : [])
      .map((alt) => ({
        verb: String(alt?.verb || '').trim(),
        future_type: String(alt?.future_type || '').trim(),
      }))
      .filter((alt) => alt.verb && alt.future_type),
  };
}

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
  if (!btn || !btn.dataset) return;
  manualVerbVowel = btn.dataset.v;
  document.querySelectorAll('#verb-manual-vowel-row .lb-pill').forEach((b) => b.classList.remove('active'));
  if (btn.classList) btn.classList.add('active');
}

async function fetchConjugation(params) {
  const requestedVerb = String(params?.verb || '').trim();
  const controller = new AbortController();
  const url = QUTRUB_WORKER_URL + '/conjugate?' + new URLSearchParams(params).toString();
  const timeoutId = setTimeout(() => {
    controller.abort();
  }, QUTRUB_TIMEOUT_MS);
  try {
    const res = await fetch(url, {
      signal: controller.signal,
    });
    if (!res.ok) {
      return {
        ok: false,
        error: `Worker error ${res.status}: не удалось выполнить запрос.`,
      };
    }
    const raw = await res.json();
    const normalized = sanitizeConjugationPayload(raw);
    if (!normalized) {
      return { ok: false, error: 'Неполный ответ сервиса спряжения.' };
    }
    if (normalized.verb.toLowerCase() !== requestedVerb.toLowerCase()) {
      normalized.verb = requestedVerb;
    }
    return normalized;
  } catch (e) {
    if (e?.name === 'AbortError') {
      ErrorLog.capture(e, { source: 'verbs', action: 'fetch-conjugation-timeout' });
      return { ok: false, error: 'Таймаут соединения с сервисом спряжения (12 сек).' };
    }
    ErrorLog.capture(e, { source: 'verbs', action: 'fetch-conjugation' });
    return { ok: false, error: 'Сервис временно недоступен. Попробуйте ещё раз через пару секунд.' };
  } finally {
    clearTimeout(timeoutId);
  }
}

async function conjugateTypedVerb() {
  const input = document.getElementById('verb-input');
  const fb = document.getElementById('verb-input-feedback');
  const btn = document.getElementById('verb-conjugate-btn');

  if (!input || !fb || !btn) return;

  const verb = input.value.trim();
  fb.className = 'feedback';
  fb.textContent = '';
  if (!verb) {
    fb.className = 'feedback err';
    fb.textContent = 'Введите глагол в прошедшем времени (فَعَلَ)';
    return;
  }

  btn.disabled = true;
  btn.textContent = '⏳ Спрягаю...';
  try {
    const json = await fetchConjugation({ verb, future_type: manualVerbVowel });
    if (!json.ok) {
      fb.className = 'feedback err';
      fb.textContent = json.error || 'Проблема при запросе к сервису. Попробуйте ещё раз.';
      return;
    }
    const rendered = openVerbResult(json);
    if (!rendered) {
      fb.className = 'feedback err';
      fb.textContent = 'Результат от сервиса пришел в неожиданном формате. Попробуйте ещё раз.';
    }
  } catch (e) {
    ErrorLog.capture(e, { source: 'verbs', action: 'render-conjugation' });
    fb.className = 'feedback err';
    fb.textContent = 'Не удалось показать спряжение. Попробуйте ещё раз.';
  } finally {
    btn.disabled = false;
    btn.textContent = '🔁 Спрягать';
  }
}

function openVerbResult(json) {
  if (!json || !json.ok || !json.verb || !json.forms) return false;
  const title = document.getElementById('verb-modal-title');
  const sub = document.getElementById('verb-modal-sub');
  const body = document.getElementById('verb-modal-body');
  const overlay = document.getElementById('verb-modal-overlay');
  if (!title || !sub || !body || !overlay) return false;
  currentDrillVerb = {
    ar: json.verb,
    futureType: json.future_type,
    forms: json.forms,
    dictionary: !!json.dictionary,
    alternatives: json.alternatives || [],
  };
  title.textContent = json.verb;
  sub.textContent = 'تصريف الفعل';
  body.innerHTML = renderConjugationTable(currentDrillVerb);
  overlay.classList.remove('hidden');
  return true;
}

async function pickVerbAlternative(altVerb, altFutureType) {
  const body = document.getElementById('verb-modal-body');
  if (!body) return;
  const prevHtml = body.innerHTML;
  if (!currentDrillVerb) {
    body.innerHTML = prevHtml;
    return;
  }
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
    if (!openVerbResult(json)) {
      body.innerHTML = prevHtml;
    }
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
            escapeJsSingle(a.verb) +
            "', '" +
            escapeJsSingle(a.future_type) +
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
  const overlay = document.getElementById('verb-modal-overlay');
  if (overlay) overlay.classList.add('hidden');
  currentDrillVerb = null;
}

function toggleVerbDual(el) {
  const block = document.getElementById('verb-dual-block');
  if (!block || !el || !el.textContent) return;
  block.classList.toggle('hidden');
  el.textContent = block.classList.contains('hidden') ? 'Показать двойственное число ▾' : 'Скрыть двойственное число ▴';
}

function toggleVerbAlternatives(el) {
  const block = document.getElementById('verb-alt-block');
  if (!block || !el || !el.textContent) return;
  block.classList.toggle('hidden');
  el.textContent = block.classList.contains('hidden') ? 'Есть другое значение этого глагола ▾' : 'Скрыть другие значения ▴';
}

function startVerbDrill() {
  nextVerbDrillPrompt();
}

function nextVerbDrillPrompt() {
  const v = currentDrillVerb;
  const modalBody = document.getElementById('verb-modal-body');
  const feedback = document.getElementById('verb-drill-feedback');
  if (!v || !v.forms || !modalBody) {
    if (modalBody) {
      modalBody.innerHTML = '<div class="verb-empty">Не удалось загрузить задание. Нажмите ещё раз.</div>';
    }
    if (feedback) {
      feedback.className = 'feedback err';
      feedback.textContent = 'Нет данных для тренировки. Попробуйте еще раз.';
    }
    return;
  }
  const tenses = ['past', 'present'].filter((t) => v.forms[t]);
  if (!tenses.length) {
    modalBody.innerHTML = '<div class="verb-empty">Нет доступных форм для тренировки.</div>';
    return;
  }
  const tense = tenses[Math.floor(Math.random() * tenses.length)];
  const persons = PERSON_ORDER.filter((p) => v.forms[tense][p]);
  if (!persons.length) {
    modalBody.innerHTML = '<div class="verb-empty">Нет доступных форм для выбранного времени.</div>';
    return;
  }
  const person = persons[Math.floor(Math.random() * persons.length)];
  verbDrillAnswer = v.forms[tense][person];
  modalBody.innerHTML =
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
  const input = document.getElementById('verb-drill-input');
  if (input) input.focus();
}

function normHamzaSeat(t) {
  // Different hamza seats (أ إ آ ؤ ئ ء) are a spelling detail, not a
  // grammatical one — don't fail a drill answer over which seat the
  // learner used.
  return t.replace(/[إأآؤئ]/g, 'ء');
}

function checkVerbDrill() {
  const inp = document.getElementById('verb-drill-input');
  const btn = document.getElementById('verb-drill-check');
  const fb = document.getElementById('verb-drill-feedback');
  if (!inp || !btn || !fb || !verbDrillAnswer) return;

  const val = normHamzaSeat(rmH(inp.value.trim()));
  const correct = normHamzaSeat(rmH(verbDrillAnswer));
  inp.disabled = true;
  if (val === correct) {
    fb.className = 'feedback ok';
    fb.textContent = '✅ Правильно!';
  } else {
    fb.className = 'feedback err';
    fb.innerHTML = '❌ Правильно: <span style="font-family:Times New Roman,serif;font-size:22px;direction:rtl;">' + esc(verbDrillAnswer) + '</span>';
  }
  btn.textContent = 'Далее →';
  btn.onclick = nextVerbDrillPrompt;
}
