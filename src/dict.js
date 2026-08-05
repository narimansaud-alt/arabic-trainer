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
  const cloudStatus = document.getElementById('cloud-status');
  const btnStart = document.getElementById('btn-start');
  const btnFav = document.getElementById('btn-fav');
  const dictContent = document.getElementById('dict-content');
  const g = document.getElementById('lesson-grid');

  if (cloudStatus) cloudStatus.textContent = 'Загрузка слов...';
  if (btnStart) btnStart.disabled = true;
  if (btnFav) btnFav.disabled = true;

  let words = [];
  try {
    const result = await db
      .from('words')
      .select('*')
      .eq('course_name', App.volume)
      .order('lesson_number', { ascending: true })
      .order('id', { ascending: true });
    if (result?.error) throw result.error;
    words = result?.data || [];
  } catch (e) {
    ErrorLog.capture(e, { source: 'dictionary', action: 'load-words', volume: App.volume });
    if (cloudStatus) cloudStatus.textContent = 'Ошибка загрузки слов';
    if (dictContent) dictContent.innerHTML = '<div class="lb-empty">Ошибка чтения словаря</div>';
    if (btnStart) btnStart.disabled = false;
    if (btnFav) btnFav.disabled = false;
    return;
  }

  if (!words.length) {
    if (cloudStatus) cloudStatus.textContent = 'Пусто: словарь не найден';
    if (dictContent) dictContent.innerHTML = '<div class="lb-empty">Словарь пуст</div>';
    if (btnStart) btnStart.disabled = false;
    if (btnFav) btnFav.disabled = false;
    return;
  }

  Dict.byLesson = {};
  Dict.allWords = [];
  const lessons = new Set();

  words.forEach((r) => {
    const k = r.lesson_number;
    if (!Dict.byLesson[k]) Dict.byLesson[k] = [];
    Dict.byLesson[k].push({ ar: r.word_ar, ru: r.word_ru, lesson: k });
    lessons.add(k);
    Dict.allWords.push({ ar: r.word_ar, ru: r.word_ru, lesson: k });
  });

  if (cloudStatus) cloudStatus.textContent = 'Загружено: ' + Dict.allWords.length + ' слов';

  if (!g) {
    if (btnStart) btnStart.disabled = false;
    if (btnFav) btnFav.disabled = false;
    return;
  }

  g.innerHTML = '';
  Array.from(lessons)
    .sort((a, b) => (isNaN(a) || isNaN(b) ? String(a).localeCompare(String(b)) : parseFloat(a) - parseFloat(b)))
    .forEach((l) => {
      const btn = document.createElement('button');
      btn.className = 'lesson-pill';
      btn.dataset.lesson = l;
      btn.textContent = 'Урок ' + l;
      btn.onclick = () => btn.classList.toggle('active');
      g.appendChild(btn);
    });

  if (btnStart) btnStart.disabled = false;
  if (btnFav) btnFav.disabled = false;
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

function setDictView(view) {
  if (view !== 'list' && view !== 'table') return;
  Settings.dictView = view;
  try {
    localStorage.setItem('arabic_dict_view', view);
  } catch (e) {
    /* non-fatal */
  }
  document.querySelectorAll('[data-dict-view]').forEach((btn) => {
    btn.classList.toggle('active', btn.dataset.dictView === view);
  });
  renderDict();
}

function dictBookTokens(value) {
  return String(value || '')
    .toLowerCase()
    .replace(/ё/g, 'е')
    .split(/[\s,;:()/]+/u)
    .filter((token) => token.length >= 3);
}

function normalizeArabicDictForm(value) {
  return String(value || '')
    .normalize('NFC')
    .replace(/[\u064B-\u065F\u0670ـ]/gu, '')
    .replace(/[\s(),،]+/gu, '')
    .trim();
}

function normalizeRussianDictForm(value) {
  return String(value || '')
    .toLowerCase()
    .replace(/[В«В»"'.,:;!?()]/gu, ' ')
    .replace(/\s+/gu, ' ')
    .trim();
}

function sharesRussianStem(first, second) {
  const firstText = normalizeRussianDictForm(first);
  const secondText = normalizeRussianDictForm(second);
  const firstHead = firstText.split(' ')[0];
  const secondHead = secondText.split(' ')[0];
  if (firstHead === 'это' && secondHead === 'эти') return true;
  if (/^(этот|эта|тот|та)$/u.test(firstHead) && /^(эти|те)$/u.test(secondHead)) return true;
  const firstTokens = dictBookTokens(first);
  const secondTokens = dictBookTokens(second);
  return firstTokens.some((a) => secondTokens.some((b) => a.slice(0, 3) === b.slice(0, 3)));
}

function russianPluralDirection(first, second) {
  const firstTokens = dictBookTokens(first);
  const secondTokens = dictBookTokens(second);
  return firstTokens.some((a) =>
    secondTokens.some((b) => {
      if (a.slice(0, 3) !== b.slice(0, 3)) return false;
      const aLast = a.slice(-1);
      const bLast = b.slice(-1);
      if (aLast === bLast) return false;
      if (/[ьйбвгджзклмнпрстфхцчшщ]/u.test(aLast) && /[ыиаяе]/u.test(bLast)) return true;
      if (aLast === 'а' && /[ыи]/u.test(bLast)) return true;
      if (aLast === 'я' && bLast === 'и') return true;
      if (aLast === 'е' && /[яи]/u.test(bLast)) return true;
      return false;
    })
  );
}

function isDictionarySingularForm(arabic) {
  const normalized = normalizeArabicDictForm(arabic);
  if (['هذا', 'هذه', 'ذلك', 'تلك'].includes(normalized)) return true;
  const value = String(arabic || '').trim();
  return !/[\s()،,]/u.test(value) && /(?:ٌ|ةٌ|ٌّ)$/u.test(value);
}

function isDictionaryPluralForm(arabic, singularRu, pluralRu) {
  const normalized = normalizeArabicDictForm(arabic);
  if (['هؤلاء', 'أولئك', 'هذان', 'هاتان'].includes(normalized)) return true;
  const value = String(arabic || '').trim().split(/[\s(،,]/u)[0];
  if (/(?:ات|ون|ين|اء|ان|ى)[ٌٍَُِ]?$/u.test(value)) return true;
  return /[ٌٍُ]$/u.test(value) && russianPluralDirection(singularRu, pluralRu);
}

const DICTIONARY_FORM_PAIRS = new Set([
  'هذا|هؤلاء',
  'هذه|هؤلاء',
  'ذلك|اولئك',
  'تلك|اولئك',
  'انا|نحن',
  'انت|انتم',
  'انتي|انتن',
  'هو|هم',
  'هي|هن',
]);

function isDictionaryPair(singular, plural) {
  const key = normalizeArabicDictForm(singular.ar) + '|' + normalizeArabicDictForm(plural.ar);
  if (DICTIONARY_FORM_PAIRS.has(key)) return true;
  return (
    isDictionarySingularForm(singular.ar) &&
    isDictionaryPluralForm(plural.ar, singular.ru, plural.ru) &&
    sharesRussianStem(singular.ru, plural.ru)
  );
}

function makeDictBookRows(words) {
  const rows = [];
  for (let index = 0; index < words.length; index += 1) {
    const singular = words[index];
    const plural = words[index + 1];
    if (
      plural &&
      singular.lesson === plural.lesson &&
      isDictionaryPair(singular, plural)
    ) {
      rows.push({ ru: singular.ru, singular: singular.ar, plural: plural.ar });
      index += 1;
      continue;
    }
    rows.push({ ru: singular.ru, singular: singular.ar, plural: '' });
  }
  return rows;
}

function renderDictBook(words, lesson) {
  const rows = makeDictBookRows(words);
  return (
    '<div class="dict-book">' +
    (lesson === null ? '' : '<div class="dict-book-title">Урок ' + esc(String(lesson)) + '</div>') +
    '<table class="dict-book-table"><thead><tr><th>Перевод</th><th>Множественное число</th><th>Единственное число</th></tr></thead><tbody>' +
    rows
      .map(
        (w) =>
          '<tr><td>' +
          esc(w.ru) +
          '</td><td class="dict-book-ar dict-book-plural" dir="rtl">' +
          (w.plural ? esc(w.plural) : '<span class="dict-book-dash">—</span>') +
          '</td><td class="dict-book-ar" dir="rtl">' +
          esc(w.singular) +
          '</td></tr>'
      )
      .join('') +
    '</tbody></table></div>'
  );
}

function renderDict() {
  document.querySelectorAll('[data-dict-view]').forEach((btn) => {
    btn.classList.toggle('active', btn.dataset.dictView === Settings.dictView);
  });
  const q = (document.getElementById('dict-search').value || '').trim().toLowerCase();
  let words = Dict.allWords;
  if (Settings.dictLesson !== 'all') words = words.filter((w) => String(w.lesson) === Settings.dictLesson);
  if (q) words = words.filter((w) => w.ar.includes(q) || w.ru.toLowerCase().includes(q));
  const cont = document.getElementById('dict-content');
  if (!words.length) {
    cont.innerHTML = '<div class="lb-empty">Ничего не найдено</div>';
    return;
  }
  if (Settings.dictView === 'table') {
    if (Settings.dictLesson === 'all' && !q) {
      const byLesson = {};
      words.forEach((w) => {
        if (!byLesson[w.lesson]) byLesson[w.lesson] = [];
        byLesson[w.lesson].push(w);
      });
      cont.innerHTML = Object.keys(byLesson)
        .sort((a, b) => (isNaN(a) || isNaN(b) ? String(a).localeCompare(String(b)) : Number(a) - Number(b)))
        .map((lesson) => renderDictBook(byLesson[lesson], lesson))
        .join('');
    } else {
      cont.innerHTML = renderDictBook(words, null);
    }
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
          `<div class="dict-section"><div class="dict-section-hdr">Урок ${l} — ${
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
// RULES
async function loadRulesAll() {
  Dict.rules = [];
  Settings.rulesLesson = 'all';
  const volume = findVolumeById(App.volume);
  const rulesContent = document.getElementById('rules-content');
  if (!volume) {
    if (rulesContent) rulesContent.innerHTML = '<div class="lb-empty">Текущего курса не найдено.</div>';
    return;
  }

  let data = [];
  try {
    const result = await db.from('rules').select('*').eq('course_name', App.volume).order('lesson_number');
    if (result?.error) throw result.error;
    data = result?.data || [];
  } catch (e) {
    if (rulesContent) {
      rulesContent.innerHTML =
        '<div class="lb-empty">Правила временно недоступны. Проверьте Supabase.</div>';
    }
    return;
  }

  if (data && data.length) {
    const ids = data.map((r) => r.id);
    let sectionsByRule = {};
    if (ids.length) {
      try {
        const result = await db.from('rule_sections').select('*').in('rule_id', ids).order('sort_order');
        const sections = result?.data || [];
        if (sections && sections.length) {
          sectionsByRule = sections.reduce((acc, section) => {
            if (!acc[section.rule_id]) acc[section.rule_id] = [];
            acc[section.rule_id].push(section);
            return acc;
          }, {});
        }
      } catch (e) {
        sectionsByRule = {};
      }
    }
    Dict.rules = data.map((r) => ({ ...r, sections: sectionsByRule[r.id] || [], volLabel: volume.label }));
  }

  if (!Dict.rules.length) {
    if (rulesContent)
      rulesContent.innerHTML =
      '<div class="lb-empty">Правила ещё не найдены.<br><small>Выполните миграцию Supabase для таблицы rules</small></div>';
    return;
  }

  renderRules();
}

const RULE_ALLOWED_TAGS = new Set([
  'A', 'B', 'BLOCKQUOTE', 'BR', 'CAPTION', 'CODE', 'DIV', 'EM', 'H1', 'H2', 'H3', 'H4',
  'H5', 'H6', 'HR', 'I', 'LI', 'OL', 'P', 'PRE', 'SMALL', 'SPAN', 'STRONG', 'SUB', 'SUP',
  'TABLE', 'TBODY', 'TD', 'TFOOT', 'TH', 'THEAD', 'TR', 'U', 'UL'
]);
const RULE_ALLOWED_ATTRIBUTES = new Set(['class', 'dir', 'lang', 'colspan', 'rowspan', 'scope', 'abbr']);
const RULE_BLOCKED_TAGS = new Set(['SCRIPT', 'STYLE', 'IFRAME', 'OBJECT', 'EMBED', 'SVG', 'MATH', 'FORM', 'INPUT', 'BUTTON']);

function sanitizeRuleHtml(value) {
  const template = document.createElement('template');
  template.innerHTML = String(value || '');
  Array.from(template.content.querySelectorAll('*')).forEach((node) => {
    if (RULE_BLOCKED_TAGS.has(node.tagName)) {
      node.remove();
      return;
    }
    if (!RULE_ALLOWED_TAGS.has(node.tagName)) {
      node.replaceWith(...Array.from(node.childNodes));
      return;
    }
    Array.from(node.attributes).forEach((attribute) => {
      if (!RULE_ALLOWED_ATTRIBUTES.has(attribute.name.toLowerCase())) node.removeAttribute(attribute.name);
    });
  });
  return template.innerHTML;
}

function wrapArabic(text) {
  const groups = [];
  const protectedText = sanitizeRuleHtml(text).replace(
    /(\(\s*)([\u0600-\u06FF]+(?:\s+[\u0600-\u06FF]+)*)(\s*\))/gu,
    (_, opening, phrase, closing) => {
      const token = '@@ARABIC_GROUP_' + groups.length + '@@';
      groups.push('<span class="ar-inline" dir="rtl">' + opening + phrase + closing + '</span>');
      return token;
    }
  );
  return protectedText
    .replace(/[\u0600-\u06FF]+(?:\s+[\u0600-\u06FF]+)*/gu, (phrase) => {
      const isShortTerm =
        phrase.length <= 34 && phrase.trim().split(/\s+/).length <= 4 && !/[،؛؟.!]/.test(phrase);
      const isSentence = phrase.trim().split(/\s+/).length > 4 || /[،؛؟.!]/.test(phrase);
      const className = isSentence ? 'ar-sentence' : isShortTerm ? 'ar-term' : 'ar-text';
      return '<span class="' + className + '" dir="rtl">' + phrase + '</span>';
    })
    .replace(/@@ARABIC_GROUP_(\d+)@@/g, (_, index) => groups[Number(index)] || '');
}

function togglePw(id, btn) {
  const inp = document.getElementById(id);
  if (!inp || !btn) return;
  const show = inp.type === 'password';
  inp.type = show ? 'text' : 'password';
  btn.innerHTML = uiIcon(show ? 'eye-off' : 'eye');
  btn.setAttribute('aria-label', show ? 'Скрыть пароль' : 'Показать пароль');
}
function stripRuleHtml(html) {
  const div = document.createElement('div');
  div.innerHTML = String(html || '').replace(/<br\s*\/?>/gi, ' ');
  return div.textContent.replace(/\s+/g, ' ').trim();
}

function ruleBlockClass(blockHtml) {
  const plain = stripRuleHtml(blockHtml).toLowerCase();
  if (/<table[\s\S]*?>/i.test(blockHtml)) return 'is-table';
  if (/и[‘'`ʼ’]?раб|إعراب|إِعْرَاب/.test(plain)) return 'is-irab';
  if (/важно|секрет|запомн|внимание/.test(plain)) return 'is-important';
  if (/пример|مثال/.test(plain)) return 'is-example';
  if (/логика|суть|как сказать|как читать/.test(plain)) return 'is-logic';
  if (/правило|новое правило|вспоминаем/.test(plain)) return 'is-rule';
  return '';
}

function ruleBlockLabel(cls) {
  if (cls === 'is-rule') return 'Правило';
  if (cls === 'is-example') return 'Пример';
  if (cls === 'is-irab') return 'Разбор';
  if (cls === 'is-important') return 'Важно';
  if (cls === 'is-logic') return 'Логика';
  if (cls === 'is-table') return 'Таблица';
  if (cls === 'is-memorize') return 'Знать наизусть';
  return 'Пояснение';
}

function renderRuleSubpanel(rawHtml, index, forcedClass) {
  const restored = String(rawHtml || '');
  const cls = forcedClass || ruleBlockClass(restored);
  const content = wrapArabic(restored);
  const label = ruleBlockLabel(cls);
  return (
    '<div class="rule-subpanel ' +
    cls +
    '"><div class="rule-subpanel-head"><span class="rule-subpanel-num">' +
    (index + 1) +
    '</span><span class="rule-subpanel-label">' +
    label +
    '</span></div><div class="rule-subpanel-body"><div class="rule-subpanel-content">' +
    content +
    '</div></div></div>'
  );
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
  const blocks = (parts.length ? parts : [safe]).map((part, idx) => {
    const restored = part.replace(/%%RULE_TABLE_(\d+)%%/g, (_, i) => tables[Number(i)] || '');
    const cls = ruleBlockClass(restored);
    return renderRuleSubpanel(restored, idx, cls);
  });
  return '<div class="rule-subpanel-list">' + blocks.join('') + '</div>';
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
  const parent = card.closest('.rule-list');
  const open = !card.classList.contains('open');
  if (open && parent) {
    parent.querySelectorAll('.rule-card').forEach((item) => {
      if (item !== card) item.classList.remove('open');
    });
    parent.querySelectorAll('.rule-card-head').forEach((item) => item.setAttribute('aria-expanded', 'false'));
  }
  card.classList.toggle('open', open);
  btn.setAttribute('aria-expanded', open ? 'true' : 'false');
  if (open) pushRuleCardHistory(card.dataset.ruleId);
  if (open) {
    const firstPanel = card.querySelector('.rule-subpanel-head');
    if (firstPanel) {
      const firstPanelNode = firstPanel.closest('.rule-subpanel');
      card.querySelectorAll('.rule-subpanel').forEach((panel) => panel.classList.remove('open'));
      card.querySelectorAll('.rule-subpanel-head').forEach((head) => head.setAttribute('aria-expanded', 'false'));
      if (firstPanelNode) {
        firstPanelNode.classList.add('open');
        firstPanel.setAttribute('aria-expanded', 'true');
      }
    }
  }
  if (!open) {
    card.querySelectorAll('.rule-subpanel').forEach((panel) => panel.classList.remove('open'));
    card.querySelectorAll('.rule-subpanel-head').forEach((head) => head.setAttribute('aria-expanded', 'false'));
    if (history.state && String(history.state.ruleCardId || '') === String(card.dataset.ruleId || '')) {
      if (window.history && history.replaceState) {
        history.replaceState({ app: 'arabic-trainer', appView: 'rule-lesson', lesson: String(Settings.rulesLesson) }, '', window.location.href);
      }
    }
  }
  document.querySelectorAll('.rule-outline-row[data-card]').forEach((row) => {
    if (row.getAttribute('data-card') === card.id) row.classList.toggle('active', open);
    else if (open) row.classList.remove('active');
  });
}

function toggleRuleSubpanel(btn) {
  const panel = btn.closest('.rule-subpanel');
  if (!panel) return;
  const list = panel.closest('.rule-subpanel-list');
  const open = !panel.classList.contains('open');
  if (open && list) {
    list.querySelectorAll('.rule-subpanel').forEach((item) => {
      if (item !== panel) item.classList.remove('open');
    });
    list.querySelectorAll('.rule-subpanel-head').forEach((item) => item.setAttribute('aria-expanded', 'false'));
  }
  panel.classList.toggle('open', open);
  btn.setAttribute('aria-expanded', open ? 'true' : 'false');
  if (open) pushRuleCardHistory(panel.closest('.rule-card')?.dataset.ruleId);
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

function groupRulesByLesson(rules) {
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
  return grouped;
}

function lessonSort(a, b) {
  return isNaN(a) || isNaN(b) ? String(a).localeCompare(String(b)) : Number(a) - Number(b);
}

function rulePreview(rule) {
  const firstTextSection = (rule.sections || []).find((s) => s.section_type !== 'table');
  const raw =
    rule.summary ||
    (firstTextSection
      ? stripRuleHtml(firstTextSection.content)
      : /<table[\s\S]*?>/i.test(rule.content)
      ? 'Сводная таблица с примерами по теме урока'
      : stripRuleHtml(rule.content));
  const preview = raw.slice(0, 170);
  return preview + (preview.length >= 170 ? '...' : '');
}

function ruleSearchText(rule) {
  return [rule.title, rule.summary, rule.content]
    .concat((rule.sections || []).flatMap((s) => [s.title, s.content]))
    .filter(Boolean)
    .join(' ')
    .toLowerCase();
}

function ruleWordCountForLesson(lesson) {
  return (Dict.byLesson[String(lesson)] || []).length;
}

function lessonTopics(items, limit = items.length) {
  return items
    .slice(0, limit || items.length)
    .map((r) => '<span class="rule-topic-chip">' + wrapArabic(esc(r.title)) + '</span>')
    .join('');
}

function lessonPreviewList(items) {
  return items
    .map(
      (r, i) =>
        '<span class="rules-lesson-preview-row accent-' +
        ruleAccent(r, i) +
        '"><span class="rules-lesson-preview-num">' +
        (i + 1) +
        '</span><b class="rules-preview-title">' +
        wrapArabic(esc(r.title)) +
        '</b></span>'
    )
    .join('');
}

function lessonOutline(items) {
  return items
    .map(
      (r, i) =>
        '<button class="rule-outline-row accent-' +
        ruleAccent(r, i) +
        '" type="button" onclick="openRuleCardById(&quot;' +
        esc(String(r.id)) +
        '&quot;,false)" data-card="rule-card-' +
        esc(String(r.id)) +
        '"><span>' +
        (i + 1) +
        '</span><b class="rule-outline-title-text">' +
        wrapArabic(esc(r.title)) +
        '</b></button>'
    )
    .join('');
}

function openRuleCardById(id, skipHistory = false) {
  const card = document.getElementById('rule-card-' + id);
  if (!card) return;
  const targetCardId = 'rule-card-' + id;
  document.querySelectorAll('.rule-outline-row[data-card]').forEach((row) => {
    row.classList.toggle('active', row.getAttribute('data-card') === targetCardId);
  });
  card.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function pushRuleCardHistory(ruleId) {
  if (!window.history || !history.pushState) return;
  history.pushState({ app: 'arabic-trainer', appView: 'rule-lesson', lesson: String(Settings.rulesLesson), ruleCardId: String(ruleId) }, '', window.location.href);
}

function closeAllRuleCards(scope) {
  const lists = scope ? [scope] : document.querySelectorAll('.rule-list');
  lists.forEach((list) => {
    list.querySelectorAll('.rule-card').forEach((card) => {
      card.classList.remove('open');
      const head = card.querySelector('.rule-card-head');
      if (head) head.setAttribute('aria-expanded', 'false');
      card.querySelectorAll('.rule-subpanel').forEach((item) => item.classList.remove('open'));
      card.querySelectorAll('.rule-subpanel-head').forEach((btn) => btn.setAttribute('aria-expanded', 'false'));
    });
  });
  document.querySelectorAll('.rule-outline-row[data-card]').forEach((row) => row.classList.remove('active'));
}

let currentBookPage = 1;

function getBookStorageKey(volumeId) {
  return 'arabic_book_page_' + String(volumeId);
}

function bookPageFromInput(page) {
  const parsed = parseInt(String(page), 10);
  if (!Number.isFinite(parsed)) return 1;
  return Math.max(1, parsed);
}

function buildBookPageAssetUrl(book, page) {
  const pattern = book && book.pagePattern;
  if (!pattern) return '';
  const pageNumber = String(bookPageFromInput(page)).padStart(3, '0');
  return pattern.replace('{page}', pageNumber);
}

function setBookPage(volumeId, page) {
  if (!volumeId) return;
  const book = getVolumeBook(volumeId);
  if (!book) return;
  const maxPage = Number(book.pageCount) > 0 ? Number(book.pageCount) : Number.MAX_SAFE_INTEGER;
  const newPage = Math.min(bookPageFromInput(page), maxPage);
  currentBookPage = newPage;
  try {
    localStorage.setItem(getBookStorageKey(volumeId), String(newPage));
  } catch (e) {
    /* non-fatal */
  }

  const image = document.getElementById('book-page-image');
  const input = document.getElementById('book-page-input');
  const status = document.getElementById('book-page-status');
  const previous = document.getElementById('book-prev-btn');
  const next = document.getElementById('book-next-btn');
  if (!input) return;

  input.value = String(newPage);
  input.max = String(maxPage);
  if (image && buildBookPageAssetUrl(book, newPage)) {
    image.src = buildBookPageAssetUrl(book, newPage);
    image.alt = 'Страница ' + newPage + ' из ' + maxPage;
  }
  if (status) status.textContent = 'Страница ' + newPage + ' из ' + maxPage;
  if (previous) previous.disabled = newPage <= 1;
  if (next) next.disabled = newPage >= maxPage;
}

let currentBookVolumeId = null;
let bookSwipeStartX = null;
let bookKeyHandler = null;
let currentBookZoom = 1;
let bookPointers = new Map();
let bookPinchStartDistance = 0;
let bookPinchStartZoom = 1;
let bookPanStart = null;

function getBookPointerDistance() {
  const points = Array.from(bookPointers.values());
  if (points.length < 2) return 0;
  return Math.hypot(points[0].x - points[1].x, points[0].y - points[1].y);
}

function renderBookTab() {
  const cont = document.getElementById('book-content');
  if (!cont) return;
  const volumes = VOLUMES.med || [];
  cont.innerHTML =
    '<div class="sc"><div class="sc-title">Выберите том</div><div class="book-volume-grid">' +
    volumes
      .map((volume) => {
        const ready = Boolean(getVolumeBook(volume.id));
        return (
          '<button class="book-volume-card" type="button" ' +
          (ready ? 'onclick="showBookFormats(\'' + esc(volume.id) + '\')"' : 'disabled') +
          '><span class="book-choice-icon">' +
          uiIcon('book') +
          '</span><span class="book-choice-copy"><span class="book-choice-title">' +
          esc(volume.label) +
          '</span><span class="book-choice-sub">' +
          (ready ? esc(volume.sub || 'Книга доступна') : 'Книга ещё не добавлена') +
          '</span></span><span aria-hidden="true">›</span></button>'
        );
      })
      .join('') +
    '</div></div>';
}

function showBookFormats(volumeId) {
  const cont = document.getElementById('book-content');
  const volume = findVolumeById(volumeId);
  const book = volume ? getVolumeBook(volume.id) : null;
  if (!cont || !volume || !book) {
    if (cont) cont.innerHTML = '<div class="lb-empty">Книга этого тома пока недоступна.</div>';
    return;
  }
  currentBookVolumeId = volume.id;
  cont.innerHTML =
    '<div class="sc"><button class="book-format-btn" type="button" onclick="renderBookTab()">← Все тома</button>' +
    '<div class="sc-title" style="margin-top:16px;">' +
    esc(book.title || volume.label) +
    '</div><div class="book-action-grid">' +
    '<button class="book-action-card" type="button" onclick="openBookInApp(\'' +
    esc(volume.id) +
    '\')"><span class="book-choice-icon">' +
    uiIcon('book') +
    '</span><span class="book-choice-copy"><span class="book-choice-title">Читать в приложении</span><span class="book-choice-sub">Полный экран, масштаб, свайпы и сохранение страницы</span></span><span aria-hidden="true">›</span></button>' +
    '<a class="book-action-card" href="' +
    esc(book.url) +
    '" target="_blank" rel="noopener"><span class="book-choice-icon">' +
    uiIcon('file') +
    '</span><span class="book-choice-copy"><span class="book-choice-title">Открыть PDF</span><span class="book-choice-sub">Исходный файл в отдельном окне</span></span><span aria-hidden="true">↗</span></a>' +
    '</div></div>';
}

function openBookInApp(volumeId) {
  const cont = document.getElementById('book-content');
  const volume = findVolumeById(volumeId);
  const book = volume ? getVolumeBook(volume.id) : null;
  if (!cont || !volume || !book) return;
  currentBookVolumeId = volume.id;
  let savedPage = 1;
  try {
    savedPage = bookPageFromInput(localStorage.getItem(getBookStorageKey(volume.id)));
  } catch (e) {
    ErrorLog.capture(e, { source: 'book', action: 'read-saved-page', volume: volume.id });
  }
  currentBookPage = Math.min(savedPage, Number(book.pageCount) || savedPage);
  cont.innerHTML =
    '<div class="book-reader-fullscreen" id="book-reader-fullscreen">' +
    '<div class="book-reader-head"><button class="book-nav-btn" type="button" onclick="closeBookReader()">← Закрыть</button>' +
    '<div class="book-reader-title">' +
    esc(book.title || volume.label) +
    '</div><div class="book-reader-page" id="book-page-status"></div></div>' +
    '<div class="book-reader-stage" id="book-reader-stage"><img class="book-page-image" id="book-page-image" alt="Страница книги" loading="eager"></div>' +
    '<div class="book-reader-foot"><div class="book-reader-controls"><button class="book-nav-btn" id="book-prev-btn" type="button" onclick="nextBookPage(-1)">←</button>' +
    '<input class="book-page-input" id="book-page-input" type="number" min="1" onchange="applyBookPageFromInput()" aria-label="Номер страницы">' +
    '<button class="book-nav-btn" id="book-next-btn" type="button" onclick="nextBookPage(1)">→</button></div>' +
    '<div class="book-zoom-controls"><button class="book-nav-btn" type="button" onclick="setBookZoom(currentBookZoom - 0.25)" aria-label="Уменьшить страницу">−</button>' +
    '<button class="book-nav-btn book-zoom-value" id="book-zoom-value" type="button" onclick="setBookZoom(1)" aria-label="Сбросить масштаб">100%</button>' +
    '<button class="book-nav-btn" type="button" onclick="setBookZoom(currentBookZoom + 0.25)" aria-label="Увеличить страницу">+</button></div></div></div>';
  setBookZoom(1);
  setBookPage(volume.id, currentBookPage);
  bindBookReaderGestures();
  const reader = document.getElementById('book-reader-fullscreen');
  if (reader?.requestFullscreen) {
    reader.requestFullscreen().catch((e) => ErrorLog.capture(e, { source: 'book', action: 'request-fullscreen' }));
  }
}

function nextBookPage(delta) {
  if (!currentBookVolumeId) return;
  setBookPage(currentBookVolumeId, currentBookPage + Number(delta || 0));
}

function applyBookPageFromInput() {
  const input = document.getElementById('book-page-input');
  if (!currentBookVolumeId || !input) return;
  setBookPage(currentBookVolumeId, input.value);
}

function setBookZoom(value) {
  const stage = document.getElementById('book-reader-stage');
  const image = document.getElementById('book-page-image');
  const label = document.getElementById('book-zoom-value');
  currentBookZoom = Math.min(3, Math.max(1, Math.round(Number(value || 1) * 20) / 20));
  if (stage) stage.classList.toggle('is-zoomed', currentBookZoom > 1);
  if (image) image.style.width = currentBookZoom > 1 ? currentBookZoom * 100 + '%' : '';
  if (label) label.textContent = Math.round(currentBookZoom * 100) + '%';
  if (stage && currentBookZoom === 1) {
    stage.scrollLeft = 0;
    stage.scrollTop = 0;
  }
}

function setBookZoomAtPoint(value, clientX, clientY) {
  const stage = document.getElementById('book-reader-stage');
  if (!stage) {
    setBookZoom(value);
    return;
  }
  const beforeZoom = currentBookZoom;
  const rect = stage.getBoundingClientRect();
  const pointX = Math.max(0, Math.min(rect.width, clientX - rect.left));
  const pointY = Math.max(0, Math.min(rect.height, clientY - rect.top));
  const contentX = (stage.scrollLeft + pointX) / beforeZoom;
  const contentY = (stage.scrollTop + pointY) / beforeZoom;
  setBookZoom(value);
  stage.scrollLeft = contentX * currentBookZoom - pointX;
  stage.scrollTop = contentY * currentBookZoom - pointY;
}

function bindBookReaderGestures() {
  const stage = document.getElementById('book-reader-stage');
  if (!stage) return;
  bookPointers = new Map();
  stage.addEventListener('pointerdown', (event) => {
    bookPointers.set(event.pointerId, { x: event.clientX, y: event.clientY });
    if (stage.setPointerCapture) stage.setPointerCapture(event.pointerId);
    bookSwipeStartX = event.clientX;
    bookPanStart = {
      x: event.clientX,
      y: event.clientY,
      left: stage.scrollLeft,
      top: stage.scrollTop
    };
    if (bookPointers.size >= 2) {
      bookSwipeStartX = null;
      bookPanStart = null;
      bookPinchStartDistance = getBookPointerDistance();
      bookPinchStartZoom = currentBookZoom;
    }
  }, { passive: false });
  stage.addEventListener('pointermove', (event) => {
    if (!bookPointers.has(event.pointerId)) return;
    bookPointers.set(event.pointerId, { x: event.clientX, y: event.clientY });
    if (bookPointers.size >= 2 && bookPinchStartDistance > 0) {
      event.preventDefault();
      const points = Array.from(bookPointers.values());
      const centerX = (points[0].x + points[1].x) / 2;
      const centerY = (points[0].y + points[1].y) / 2;
      setBookZoomAtPoint(bookPinchStartZoom * (getBookPointerDistance() / bookPinchStartDistance), centerX, centerY);
      return;
    }
    if (currentBookZoom > 1 && bookPanStart) {
      event.preventDefault();
      stage.scrollLeft = bookPanStart.left + (bookPanStart.x - event.clientX);
      stage.scrollTop = bookPanStart.top + (bookPanStart.y - event.clientY);
    }
  }, { passive: false });
  stage.addEventListener('pointerup', (event) => {
    const wasPinching = bookPointers.size >= 2;
    bookPointers.delete(event.pointerId);
    if (stage.hasPointerCapture && stage.hasPointerCapture(event.pointerId)) stage.releasePointerCapture(event.pointerId);
    if (wasPinching) {
      bookSwipeStartX = null;
      bookPanStart = null;
      if (bookPointers.size < 2) bookPinchStartDistance = 0;
      return;
    }
    if (bookSwipeStartX == null) return;
    const delta = event.clientX - bookSwipeStartX;
    bookSwipeStartX = null;
    bookPanStart = null;
    if (currentBookZoom > 1) return;
    if (Math.abs(delta) < 45) return;
    nextBookPage(delta < 0 ? 1 : -1);
  });
  stage.addEventListener('pointercancel', (event) => {
    bookPointers.delete(event.pointerId);
    bookSwipeStartX = null;
    bookPanStart = null;
    if (bookPointers.size < 2) bookPinchStartDistance = 0;
  });
  stage.addEventListener('dblclick', () => setBookZoom(currentBookZoom > 1 ? 1 : 2));
  stage.addEventListener('wheel', (event) => {
    if (!event.ctrlKey) return;
    event.preventDefault();
    setBookZoom(currentBookZoom + (event.deltaY < 0 ? 0.25 : -0.25));
  }, { passive: false });
  bookKeyHandler = (event) => {
    if (event.key === 'ArrowRight') nextBookPage(1);
    if (event.key === 'ArrowLeft') nextBookPage(-1);
    if (event.key === 'Escape' && !document.fullscreenElement) closeBookReader();
  };
  document.addEventListener('keydown', bookKeyHandler);
}

function closeBookReader() {
  if (bookKeyHandler) document.removeEventListener('keydown', bookKeyHandler);
  bookKeyHandler = null;
  currentBookZoom = 1;
  if (document.fullscreenElement && document.exitFullscreen) {
    document.exitFullscreen().catch((e) => ErrorLog.capture(e, { source: 'book', action: 'exit-fullscreen' }));
  }
  if (currentBookVolumeId) showBookFormats(currentBookVolumeId);
  else renderBookTab();
}

function pushAppHistoryState(state) {
  if (!window.history || !history.pushState) return;
  history.pushState({ app: 'arabic-trainer', ...state }, '', window.location.href);
}

function showRuleLesson(lesson, pushHistory = true) {
  Settings.rulesLesson = String(lesson);
  renderRules();
  if (pushHistory) pushAppHistoryState({ appView: 'rule-lesson', lesson: String(lesson) });
}

function showRulesIndex(pushHistory = false) {
  Settings.rulesLesson = 'all';
  renderRules();
  if (pushHistory) pushAppHistoryState({ appView: 'rules-index' });
}

function goBackFromRuleLesson() {
  if (history.state && history.state.app === 'arabic-trainer' && history.state.appView === 'rule-lesson') {
    history.back();
    return;
  }
  showRulesIndex(false);
}

function renderRuleCards(items, openCards) {
  return items
    .map((r, i) => {
      const hasFilledSections = r.sections && r.sections.some((section) =>
        String(section.content || '').replace(/<[^>]*>/g, '').replace(/&nbsp;/gi, '').trim()
      );
      const content = hasFilledSections ? formatRuleSections(r.sections) : formatRuleContent(r.content);
      return (
        '<div class="rule-card accent-' +
        ruleAccent(r, i) +
        '' +
        '" id="rule-card-' +
        esc(String(r.id)) +
        '" data-rule-id="' +
        esc(String(r.id)) +
        '"><div class="rule-card-head"><span class="rule-index">' +
        (i + 1) +
        '</span><span class="rule-title-wrap"><span class="rule-title">' +
        wrapArabic(esc(r.title)) +
        '</span><span class="rule-preview">' +
        wrapArabic(esc(rulePreview(r))) +
        '</span></span></div><div class="rule-card-body"><div class="rule-content">' +
        content +
        '</div></div></div>'
      );
    })
    .join('');
}

function formatRuleSections(sections) {
  const sorted = sections
    .filter((section) => String(section.content || '').replace(/<[^>]*>/g, '').replace(/&nbsp;/gi, '').trim())
    .sort((a, b) => {
    const byOrder = Number(a.sort_order || 0) - Number(b.sort_order || 0);
    if (byOrder !== 0) return byOrder;
    return Number(a.id || 0) - Number(b.id || 0);
  });
  return (
    '<div class="rule-subpanel-list">' +
    sorted
      .map((section, index) => {
        const cls = 'is-' + (section.section_type || 'note');
        const sectionContent = wrapArabic(section.content || '');
        const label = esc(section.title || ruleBlockLabel(cls));
        return (
          '<div class="rule-subpanel ' +
          cls +
          '"><div class="rule-subpanel-head"><span class="rule-subpanel-num">' +
          (index + 1) +
          '</span><span class="rule-subpanel-label">' +
          label +
          '</span></div><div class="rule-subpanel-body"><div class="rule-subpanel-content">' +
          sectionContent +
          '</div></div></div>'
        );
      })
      .join('') +
    '</div>'
  );
}

function renderRulesIndex(cont, grouped) {
  const lessons = Object.keys(grouped).sort(lessonSort);
  cont.innerHTML =
    '<div class="rules-home-head"><div class="rules-home-title-row"><div><div class="rules-home-kicker">Правила курса</div><div class="rules-home-title">Уроки</div></div><button class="rules-verb-badge" type="button" onclick="showVerbRules()"><span class="rules-verb-badge-ar" lang="ar" dir="rtl">فِعْلٌ</span><span>Правила глаголов</span></button></div><div class="rules-home-sub">Правила, примеры, разборы и таблицы.</div></div>' +
    '<div class="rules-lesson-grid">' +
    lessons
      .map((lesson) => {
        const items = grouped[lesson];
        const tables = items.filter((r) => r.rule_kind === 'table' || /<table[\s\S]*?>/i.test(r.content)).length;
        const words = ruleWordCountForLesson(lesson);
        return (
          '<button class="rules-lesson-tile" type="button" onclick="showRuleLesson(\'' +
          esc(String(lesson)) +
          '\')"><span class="rules-lesson-num">Урок ' +
          esc(String(lesson)) +
          '</span><span class="rules-lesson-label">Что внутри</span><span class="rules-lesson-stats">' +
          items.length +
          ' ' +
          (items.length === 1 ? 'правило' : items.length < 5 ? 'правила' : 'правил') +
          (tables ? ' · ' + tables + ' табл.' : '') +
          (words ? ' · ' + words + ' слов' : '') +
          '</span><span class="rules-lesson-full-outline" aria-label="Все правила урока">' +
          lessonPreviewList(items) +
          '</span><span class="rules-lesson-open">Открыть урок ›</span></button>'
        );
      })
      .join('') +
    '</div>';
}

function renderRulesSearch(cont, grouped, query) {
  const lessons = Object.keys(grouped).sort(lessonSort);
  cont.innerHTML =
    '<div class="rules-search-head"><button class="rules-back-btn" type="button" onclick="showRulesIndex()">← Все уроки</button><div><div class="rules-home-kicker">Поиск</div><div class="rules-home-title">Найдено в ' +
    lessons.length +
    ' ' +
    (lessons.length === 1 ? 'уроке' : 'уроках') +
    '</div></div></div>' +
    lessons
      .map((lesson) => {
        const items = grouped[lesson];
        return (
          '<div class="rule-lesson-card"><div class="rule-lesson-header compact"><div><div class="rule-lesson-kicker">Урок ' +
          esc(String(lesson)) +
          '</div><div class="rule-lesson-title">' +
          items.length +
          ' совпад.</div></div><button class="rules-open-btn" type="button" onclick="showRuleLesson(\'' +
          esc(String(lesson)) +
          '\')">Открыть</button></div><div class="rule-list">' +
          renderRuleCards(items, false) +
          '</div></div>'
        );
      })
      .join('');
  highlightRuleMatches(cont, query);
}

function renderRuleLessonDetail(cont, lesson, items, query) {
  const words = ruleWordCountForLesson(lesson);
  cont.innerHTML =
    '<div class="rule-detail-page"><div class="rule-detail-hero"><button class="rules-back-btn" type="button" onclick="goBackFromRuleLesson()">← Все уроки</button><div class="rule-lesson-kicker">Урок ' +
    esc(String(lesson)) +
    '</div><div class="rule-detail-title" dir="auto">' +
    'Правила урока' +
    '</div><div class="rule-detail-sub">' +
    items.length +
    ' ' +
    (items.length === 1 ? 'правило' : items.length < 5 ? 'правила' : 'правил') +
    (words ? ' · ' + words + ' слов в уроке' : '') +
    '</div><div class="rule-detail-actions cheat-sheets"><button type="button" onclick="openGrammarTable(\'pronouns\')">Местоимения</button><button type="button" onclick="openGrammarTable(\'verbs\')">Глаголы</button></div></div>' +
    '<div class="rule-detail-outline"><div class="rule-outline-title">Содержание урока</div><div class="rule-outline-sub">Все правила урока. Нажмите на пункт, чтобы перейти к пояснению.</div><div class="rule-outline-list">' +
    lessonOutline(items) +
    '</div></div><div class="rule-list">' +
    renderRuleCards(items, false) +
    '</div></div>';
  highlightRuleMatches(cont, query);
}

function ruleLessonPlainText() {
  const page = document.querySelector('#rules-content .rule-detail-page');
  return page ? page.innerText.replace(/\n{3,}/g, '\n\n').trim() : '';
}

async function copyRuleLesson(button) {
  const text = ruleLessonPlainText();
  if (!text) return;
  try {
    await navigator.clipboard.writeText(text);
  } catch (e) {
    const area = document.createElement('textarea');
    area.value = text;
    area.setAttribute('readonly', '');
    area.style.cssText = 'position:fixed;opacity:0;pointer-events:none;';
    document.body.appendChild(area);
    area.select();
    document.execCommand('copy');
    area.remove();
  }
  if (button) {
    const original = button.textContent;
    button.textContent = 'Скопировано';
    setTimeout(() => { button.textContent = original; }, 1600);
  }
}

function downloadRuleLesson() {
  const text = ruleLessonPlainText();
  if (!text) return;
  const lesson = String(Settings.rulesLesson || 'all').replace(/[^0-9A-Za-z_-]/g, '');
  const blob = new Blob(['\uFEFF' + text], { type: 'text/plain;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = 'medinsky-kurs-pravila-urok-' + (lesson || 'all') + '.txt';
  document.body.appendChild(link);
  link.click();
  link.remove();
  setTimeout(() => URL.revokeObjectURL(url), 0);
}

function renderRules() {
  const searchInput = document.getElementById('rules-search');
  const q = (searchInput?.value || '').trim().toLowerCase();
  const cont = document.getElementById('rules-content');

  if (!cont) return;

  if (Settings.rulesLesson === 'verb-rules' && typeof window.renderVerbRules === 'function') {
    window.renderVerbRules(cont);
    return;
  }

  let rules = Dict.rules;
  if (Settings.rulesLesson !== 'all') rules = rules.filter((r) => String(r.lesson_number) === Settings.rulesLesson);
  if (q) rules = rules.filter((r) => ruleSearchText(r).includes(q));

  if (!rules.length) {
    cont.innerHTML = '<div class="lb-empty">Ничего не найдено</div>';
    return;
  }
  const grouped = groupRulesByLesson(rules);
  if (!q && Settings.rulesLesson === 'all') renderRulesIndex(cont, grouped);
  else if (Settings.rulesLesson !== 'all') renderRuleLessonDetail(cont, Settings.rulesLesson, grouped[Settings.rulesLesson] || rules, q);
  else renderRulesSearch(cont, grouped, q);

  cont.querySelectorAll('.rule-content table').forEach((t) => {
    const w = document.createElement('div');
    w.className = 'tbl-wrap';
    t.parentNode.insertBefore(w, t);
    w.appendChild(t);
  });
}

function openGrammarTable(type, pushHistory = true) {
  const isVerbCheatSheet = type === 'verbs';
  const title = isVerbCheatSheet ? 'Шпаргалка по глаголам' : 'Местоимения';
  const sub = isVerbCheatSheet ? 'Прошедшее, настоящее, будущее и запрет' : 'Отдельные и слитные личные местоимения';
  const titleEl = document.getElementById('verb-modal-title');
  const subEl = document.getElementById('verb-modal-sub');
  const bodyEl = document.getElementById('verb-modal-body');
  const overlay = document.getElementById('verb-modal-overlay');

  if (!titleEl || !subEl || !bodyEl || !overlay) return;

  titleEl.textContent = title;
  subEl.textContent = sub;
  bodyEl.innerHTML = isVerbCheatSheet && typeof window.renderVerbCheatSheet === 'function'
    ? window.renderVerbCheatSheet()
    : renderPronounReferenceTable();
  overlay.classList.remove('hidden');
  if (pushHistory) pushAppHistoryState({ appModal: 'grammar-table', table: type, appView: 'rule-lesson', lesson: Settings.rulesLesson });
}

function grammarRefTable(headers, rows) {
  return (
    '<div class="grammar-ref-wrap"><table class="grammar-ref-table"><thead><tr>' +
    headers.map((h) => '<th>' + h + '</th>').join('') +
    '</tr></thead><tbody>' +
    rows.map((row) => '<tr>' + row.map((cell) => '<td>' + cell + '</td>').join('') + '</tr>').join('') +
    '</tbody></table></div>'
  );
}

function renderPronounReferenceTable() {
  const thirdPerson = [
    ['Он', '<span class="ar-text">هُوَ</span>', '<span class="ar-text">ـهُ</span>', '<span class="ar-text">كِتَابُهُ</span>'],
    ['Они двое (м.)', '<span class="ar-text">هُمَا</span>', '<span class="ar-text">ـهُمَا</span>', '<span class="ar-text">كِتَابُهُمَا</span>'],
    ['Они (м.)', '<span class="ar-text">هُمْ</span>', '<span class="ar-text">ـهُمْ</span>', '<span class="ar-text">كِتَابُهُمْ</span>'],
    ['Она', '<span class="ar-text">هِيَ</span>', '<span class="ar-text">ـهَا</span>', '<span class="ar-text">كِتَابُهَا</span>'],
    ['Они двое (ж.)', '<span class="ar-text">هُمَا</span>', '<span class="ar-text">ـهُمَا</span>', '<span class="ar-text">كِتَابُهُمَا</span>'],
    ['Они (ж.)', '<span class="ar-text">هُنَّ</span>', '<span class="ar-text">ـهُنَّ</span>', '<span class="ar-text">كِتَابُهُنَّ</span>'],
  ];
  const secondPerson = [
    ['Ты (м.)', '<span class="ar-text">أَنْتَ</span>', '<span class="ar-text">ـكَ</span>', '<span class="ar-text">كِتَابُكَ</span>'],
    ['Вы двое (м.)', '<span class="ar-text">أَنْتُمَا</span>', '<span class="ar-text">ـكُمَا</span>', '<span class="ar-text">كِتَابُكُمَا</span>'],
    ['Вы (м.)', '<span class="ar-text">أَنْتُمْ</span>', '<span class="ar-text">ـكُمْ</span>', '<span class="ar-text">كِتَابُكُمْ</span>'],
    ['Ты (ж.)', '<span class="ar-text">أَنْتِ</span>', '<span class="ar-text">ـكِ</span>', '<span class="ar-text">كِتَابُكِ</span>'],
    ['Вы двое (ж.)', '<span class="ar-text">أَنْتُمَا</span>', '<span class="ar-text">ـكُمَا</span>', '<span class="ar-text">كِتَابُكُمَا</span>'],
    ['Вы (ж.)', '<span class="ar-text">أَنْتُنَّ</span>', '<span class="ar-text">ـكُنَّ</span>', '<span class="ar-text">كِتَابُكُنَّ</span>'],
  ];
  const firstPerson = [
    ['Я', '<span class="ar-text">أَنَا</span>', '<span class="ar-text">ـِي / ـنِي</span>', '<span class="ar-text">كِتَابِي / رَآنِي</span>'],
    ['Мы', '<span class="ar-text">نَحْنُ</span>', '<span class="ar-text">ـنَا</span>', '<span class="ar-text">كِتَابُنَا</span>'],
  ];
  const headers = ['Значение', 'Отдельно', 'Слитно', 'Пример'];
  return (
    '<div class="grammar-ref-note">Отдельное местоимение пишется самостоятельным словом. Слитное присоединяется к существительному, предлогу или глаголу. Мужские и женские формы показаны раздельно.</div>' +
    '<h3 class="grammar-ref-section-title">3-е лицо — الغَائِبُ</h3>' + grammarRefTable(headers, thirdPerson) +
    '<h3 class="grammar-ref-section-title">2-е лицо — المُخَاطَبُ</h3>' + grammarRefTable(headers, secondPerson) +
    '<h3 class="grammar-ref-section-title">1-е лицо — المُتَكَلِّمُ</h3>' + grammarRefTable(headers, firstPerson)
  );
}

// TABS
function switchTab(t) {
  document.querySelectorAll('.tab-content').forEach((p) => p.classList.remove('active'));
  document.querySelectorAll('.app-tab').forEach((b) => b.classList.remove('active'));
  const tab = document.getElementById('tab-' + t);
  const tabBtn = document.getElementById('at-' + t);
  if (!tab || !tabBtn) return;

  tab.classList.add('active');
  tabBtn.classList.add('active');

  try {
    localStorage.setItem('arabic_last_tab', t);
  } catch (e) {
    /* non-fatal */
  }

  if (t === 'lb') loadLB();
  if (t === 'dict') renderDict();
  if (t === 'rules') renderRules();
  if (t === 'book') renderBookTab();
}

function selAll(v) {
  document.querySelectorAll('.lesson-pill').forEach((p) => p.classList.toggle('active', v));
}
