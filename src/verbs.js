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

// "Arabic dictionary" is intentionally separate from the Medina lesson
// dictionary. It uses Qutrub only for verb morphology and never reads or
// changes the course vocabulary.
let arabicDictVerb = null;
let arabicDictView = 'list';
let arabicDictTense = 'past';
let arabicDictVoice = 'active';

const ARABIC_DICT_PERSONS = [
  ['هو', 'Он'], ['هما', 'Они двое (м.)'], ['هم', 'Они (м.)'],
  ['هي', 'Она'], ['هما مؤ', 'Они двое (ж.)'], ['هن', 'Они (ж.)'],
  ['أنت', 'Ты (м.)'], ['أنتما', 'Вы двое (м.)'], ['أنتم', 'Вы (м.)'],
  ['أنتِ', 'Ты (ж.)'], ['أنتما مؤ', 'Вы двое (ж.)'], ['أنتن', 'Вы (ж.)'],
  ['أنا', 'Я'], ['نحن', 'Мы'],
];

const ARABIC_DICT_TENSES = {
  past: { ar: 'الماضي', ru: 'Прошедшее' },
  present: { ar: 'المضارع', ru: 'Настоящее' },
  subjunctive: { ar: 'المنصوب', ru: 'Сослагательное' },
  jussive: { ar: 'المجزوم', ru: 'Усечённое' },
  imperative: { ar: 'الأمر', ru: 'Повелительное' },
};

const ARABIC_DICT_REFERENCE = [
  ['I', 'فَعَلَ / يَفْعَلُ', 'Трёхбуквенная основа', 'كَتَبَ / يَكْتُبُ'],
  ['II', 'فَعَّلَ / يُفَعِّلُ', 'Усиление или побуждение', 'عَلَّمَ / يُعَلِّمُ'],
  ['III', 'فَاعَلَ / يُفَاعِلُ', 'Взаимное действие', 'شَارَكَ / يُشَارِكُ'],
  ['IV', 'أَفْعَلَ / يُفْعِلُ', 'Побуждение к действию', 'أَخْرَجَ / يُخْرِجُ'],
  ['V', 'تَفَعَّلَ / يَتَفَعَّلُ', 'Действие над собой', 'تَعَلَّمَ / يَتَعَلَّمُ'],
  ['VI', 'تَفَاعَلَ / يَتَفَاعَلُ', 'Взаимность', 'تَعَاوَنَ / يَتَعَاوَنُ'],
  ['VII', 'اِنْفَعَلَ / يَنْفَعِلُ', 'Изменение состояния', 'اِنْكَسَرَ / يَنْكَسِرُ'],
  ['VIII', 'اِفْتَعَلَ / يَفْتَعِلُ', 'Приобретение действия', 'اِجْتَمَعَ / يَجْتَمِعُ'],
  ['IX', 'اِفْعَلَّ / يَفْعَلُّ', 'Цвет или постоянный признак', 'اِحْمَرَّ / يَحْمَرُّ'],
  ['X', 'اِسْتَفْعَلَ / يَسْتَفْعِلُ', 'Просьба или поиск действия', 'اِسْتَخْرَجَ / يَسْتَخْرِجُ'],
  ['رباعي', 'فَعْلَلَ / يُفَعْلِلُ', 'Четырёхбуквенная основа', 'وَسْوَسَ / يُوَسْوِسُ'],
];

const ARABIC_DICT_DERIVATIVES = [
  ['المصدر', 'Масдар: название действия', 'فَعَلَ → فِعَالَة', 'دَرَسَ → دِرَاسَة'],
  ['اسم الفاعل', 'Действующее лицо или признак', 'فَاعِل', 'كَتَبَ → كَاتِب'],
  ['اسم المفعول', 'То, над чем совершено действие', 'مَفْعُول', 'كَتَبَ → مَكْتُوب'],
  ['اسم الزمان والمكان', 'Время или место действия', 'مَفْعِل / مَفْعَل', 'جَلَسَ → مَجْلِس'],
  ['اسم الآلة', 'Орудие действия', 'مِفْعَل / مِفْعَلَة', 'فَتَحَ → مِفْتَاح'],
  ['مصدر المرة', 'Однократное действие', 'فَعْلَة', 'ضَرَبَ → ضَرْبَة'],
  ['مصدر الهيئة', 'Вид или манера действия', 'فِعْلَة', 'جَلَسَ → جِلْسَة'],
  ['المصدر الميمي', 'Масдар с начальной م', 'مَفْعَل', 'دَخَلَ → مَدْخَل'],
  ['الصفة المشبهة', 'Постоянный признак', 'فَعِيل / فَعْلان', 'كَرُمَ → كَرِيم'],
  ['اسم التفضيل', 'Сравнительная степень', 'أَفْعَل', 'حَسُنَ → أَحْسَن'],
];

function arabicDictEsc(value) {
  if (typeof esc === 'function') return esc(String(value || ''));
  return String(value || '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
}

function renderArabicDictReference() {
  const grid = document.getElementById('verb-reference-grid');
  if (!grid) return;
  grid.innerHTML = ARABIC_DICT_REFERENCE.map(([number, formula, explanation, example]) =>
    '<article class="verb-reference-card"><strong>' + arabicDictEsc(formula) + '</strong><span>' + number + ' — ' + arabicDictEsc(explanation) + '</span><em dir="rtl">' + arabicDictEsc(example) + '</em></article>'
  ).join('');
}

function normalizeArabicDictPayload(payload) {
  if (!payload || typeof payload !== 'object') return null;
  if (payload.ok === false) return { ok: false, error: String(payload.error || 'Не удалось получить формы глагола.') };
  const verb = String(payload.verb || '').trim();
  const forms = payload.forms && typeof payload.forms === 'object' ? payload.forms : {};
  if (!verb) return null;
  return {
    ok: true,
    verb,
    future_type: String(payload.future_type || manualVerbVowel),
    forms: {
      past: forms.past && typeof forms.past === 'object' ? forms.past : {},
      present: forms.present && typeof forms.present === 'object' ? forms.present : {},
      imperative: forms.imperative && typeof forms.imperative === 'object' ? forms.imperative : {},
      all_forms: forms.all_forms && typeof forms.all_forms === 'object' ? forms.all_forms : {},
    },
    dictionary: Boolean(payload.dictionary),
    alternatives: Array.isArray(payload.alternatives) ? payload.alternatives.filter((item) => item && item.verb && item.future_type) : [],
  };
}

function arabicDictFindForms(verb, tense, voice) {
  const all = verb?.forms?.all_forms || {};
  const keys = Object.keys(all);
  const select = (needed, forbidden = []) => {
    const key = keys.find((item) => needed.every((part) => item.includes(part)) && forbidden.every((part) => !item.includes(part)));
    return key ? all[key] : null;
  };
  if (tense === 'past') return voice === 'passive' ? (select(['الماضي', 'المجهول']) || {}) : (select(['الماضي', 'المعلوم']) || verb.forms.past || {});
  if (tense === 'present') return voice === 'passive' ? (select(['المضارع', 'المجهول'], ['المنصوب', 'المجزوم']) || {}) : (select(['المضارع', 'المعلوم'], ['المنصوب', 'المجزوم']) || verb.forms.present || {});
  if (tense === 'subjunctive') return voice === 'passive' ? (select(['المنصوب', 'المجهول']) || {}) : (select(['المنصوب'], ['المجهول']) || {});
  if (tense === 'jussive') return voice === 'passive' ? (select(['المجزوم', 'المجهول']) || {}) : (select(['المجزوم'], ['المجهول']) || {});
  return verb.forms.imperative || select(['الأمر'], ['المؤكد']) || {};
}

function arabicDictRow(person, forms) {
  const value = forms[person[0]] || '—';
  return '<div class="verb-form-row"><span class="verb-form-pron">' + person[0] + '<small>' + person[1] + '</small></span><span class="verb-form-ar">' + arabicDictEsc(value) + '</span></div>';
}

function renderArabicDictDerivedForms() {
  return '<section class="verb-derived"><h4>الاشتقاقات — производные формы</h4><p>Формулы помогают понять устройство слова. Масдар и некоторые производные формы могут быть словарными, поэтому их нельзя всегда выводить только по шаблону.</p><div class="verb-derived-grid">' +
    ARABIC_DICT_DERIVATIVES.map(([ar, ru, formula, example]) => '<article class="verb-derived-item"><b>' + ar + '</b><span>' + ru + '</span><em dir="rtl">' + formula + ' · ' + example + '</em></article>').join('') +
    '</div></section>';
}

function renderArabicDictWorkspace() {
  if (!arabicDictVerb) return '';
  const forms = arabicDictFindForms(arabicDictVerb, arabicDictTense, arabicDictVoice);
  const tense = ARABIC_DICT_TENSES[arabicDictTense];
  const isImperative = arabicDictTense === 'imperative';
  const hasFullForms = Object.keys(arabicDictVerb.forms.all_forms || {}).length > 0;
  const toolbar = '<div class="verb-workspace-toolbar">' +
    '<button class="' + (arabicDictView === 'list' ? 'active' : '') + '" onclick="setArabicDictView(\'list\')">Список</button>' +
    '<button class="' + (arabicDictView === 'table' ? 'active' : '') + '" onclick="setArabicDictView(\'table\')">Таблица</button>' +
    '<button onclick="shareArabicDictVerb()">Поделиться</button>' +
    '<button class="' + (isArabicDictBookmarked() ? 'active' : '') + '" onclick="toggleArabicDictBookmark()">Закладка</button></div>';
  const tenseButtons = Object.entries(ARABIC_DICT_TENSES).map(([key, item]) => '<button class="' + (key === arabicDictTense ? 'active' : '') + '" onclick="setArabicDictTense(\'' + key + '\')">' + item.ar + '<small>' + item.ru + '</small></button>').join('');
  const voice = !isImperative ? '<div class="verb-segment"><button class="' + (arabicDictVoice === 'active' ? 'active' : '') + '" onclick="setArabicDictVoice(\'active\')">مبني للمعلوم<small>Действительный залог</small></button><button class="' + (arabicDictVoice === 'passive' ? 'active' : '') + '" onclick="setArabicDictVoice(\'passive\')">مبني للمجهول<small>Страдательный залог</small></button></div>' : '';
  const result = arabicDictView === 'table' ? renderArabicDictTable() : '<div class="verb-form-list">' + ARABIC_DICT_PERSONS.map((person) => arabicDictRow(person, forms)).join('') + '</div>';
  const notice = hasFullForms ? '' : '<p class="arabic-dict-help">Для этой сохранённой формы доступна базовая таблица. Полный набор залогов и наклонений появится после первого обновления морфологического расчёта.</p>';
  return toolbar + voice + '<div class="verb-segment">' + tenseButtons + '</div><div class="verb-result-heading"><b>' + tense.ar + '</b><span>' + tense.ru + (isImperative ? '' : arabicDictVoice === 'active' ? ' · действительный залог' : ' · страдательный залог') + '</span></div>' + notice + result + renderArabicDictDerivedForms();
}

function renderArabicDictTable() {
  const headers = [
    ['past', 'active', 'الماضي', 'Прошедшее'], ['past', 'passive', 'الماضي المجهول', 'Страдательный'],
    ['present', 'active', 'المضارع', 'Настоящее'], ['present', 'passive', 'المضارع المجهول', 'Страдательный'],
    ['subjunctive', 'active', 'المنصوب', 'Сослагательное'], ['jussive', 'active', 'المجزوم', 'Усечённое'], ['imperative', 'active', 'الأمر', 'Повеление'],
  ];
  return '<div class="verb-form-table-wrap"><table class="verb-form-table"><thead><tr><th>Местоимение</th>' + headers.map((item) => '<th>' + item[2] + '<br><small>' + item[3] + '</small></th>').join('') + '</tr></thead><tbody>' + ARABIC_DICT_PERSONS.map((person) => '<tr><td>' + person[1] + '</td>' + headers.map((head) => '<td>' + arabicDictEsc(arabicDictFindForms(arabicDictVerb, head[0], head[1])[person[0]] || '—') + '</td>').join('') + '</tr>').join('') + '</tbody></table></div>';
}

function refreshArabicDictWorkspace() {
  const body = document.getElementById('verb-modal-body');
  if (body && arabicDictVerb) body.innerHTML = renderArabicDictWorkspace();
}

function setArabicDictView(view) { arabicDictView = view === 'table' ? 'table' : 'list'; refreshArabicDictWorkspace(); }
function setArabicDictTense(tense) { if (ARABIC_DICT_TENSES[tense]) { arabicDictTense = tense; if (tense === 'imperative') arabicDictVoice = 'active'; refreshArabicDictWorkspace(); } }
function setArabicDictVoice(voice) { arabicDictVoice = voice === 'passive' ? 'passive' : 'active'; refreshArabicDictWorkspace(); }

function arabicDictBookmarks() { try { return JSON.parse(localStorage.getItem('arabic_dictionary_bookmarks') || '[]'); } catch (_) { return []; } }
function isArabicDictBookmarked() { return !!arabicDictVerb && arabicDictBookmarks().includes(arabicDictVerb.ar); }
function toggleArabicDictBookmark() {
  if (!arabicDictVerb) return;
  const entries = arabicDictBookmarks(); const index = entries.indexOf(arabicDictVerb.ar);
  if (index >= 0) entries.splice(index, 1); else entries.unshift(arabicDictVerb.ar);
  localStorage.setItem('arabic_dictionary_bookmarks', JSON.stringify(entries.slice(0, 100)));
  refreshArabicDictWorkspace();
}

async function shareArabicDictVerb() {
  if (!arabicDictVerb) return;
  const current = arabicDictFindForms(arabicDictVerb, arabicDictTense, arabicDictVoice);
  const sample = current['هو'] || current['أنا'] || '';
  const text = arabicDictVerb.ar + '\n' + ARABIC_DICT_TENSES[arabicDictTense].ar + ': ' + sample + '\nАрабский словарь';
  try {
    if (navigator.share) await navigator.share({ title: 'Арабский словарь', text });
    else if (navigator.clipboard) await navigator.clipboard.writeText(text);
  } catch (_) { /* Closing the native sharing panel is not an app error. */ }
}

function openArabicDictResult(json) {
  if (!json || !json.ok || !json.verb || !json.forms) return false;
  const title = document.getElementById('verb-modal-title');
  const sub = document.getElementById('verb-modal-sub');
  const body = document.getElementById('verb-modal-body');
  const overlay = document.getElementById('verb-modal-overlay');
  if (!title || !sub || !body || !overlay) return false;
  currentDrillVerb = { ar: json.verb, futureType: json.future_type, forms: json.forms, dictionary: !!json.dictionary, alternatives: json.alternatives || [] };
  arabicDictVerb = currentDrillVerb;
  arabicDictView = 'list'; arabicDictTense = 'past'; arabicDictVoice = 'active';
  title.textContent = json.verb; sub.textContent = 'تصريف الفعل — полный разбор фусха';
  body.innerHTML = renderArabicDictWorkspace(); overlay.classList.remove('hidden');
  return true;
}

window.addEventListener('DOMContentLoaded', () => {
  renderArabicDictReference();
  // Replace the compact legacy modal only after the original script finished
  // declaring its functions. The training screens remain independent.
  window.sanitizeConjugationPayload = normalizeArabicDictPayload;
  window.openVerbResult = openArabicDictResult;
});

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
    setIconLabel(btn, 'refresh', 'Спрягать');
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
      '<div class="feedback err" style="margin-bottom:12px;">Этого глагола нет в словаре, огласовка настоящего времени подобрана вручную (' +
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
  html += '<button class="btn-start green" style="margin-top:16px;" onclick="startVerbDrill()">' + uiIcon('target') + 'Потренироваться</button>';
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
    fb.textContent = 'Правильно';
  } else {
    fb.className = 'feedback err';
    fb.innerHTML = 'Правильный ответ: <span class="answer-ar" dir="rtl">' + esc(verbDrillAnswer) + '</span>';
  }
  btn.textContent = 'Далее →';
  btn.onclick = nextVerbDrillPrompt;
}
