// dict.js вЂ” dictionary & rules tabs, plus the lesson-pill selector used
// on the training screen. All reads here are public reference data
// (words, rules) via the anon client.

function buildLessonPills(rowId, lessons, onSelect) {
  const row = document.getElementById(rowId);
  row.innerHTML = '';
  const allBtn = document.createElement('button');
  allBtn.className = 'lb-pill active';
  allBtn.textContent = 'Р’СЃРµ';
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
      btn.textContent = 'РЈСЂ. ' + l;
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
    .replace(/С‘/g, 'Рµ')
    .split(/[\s,;:()/]+/u)
    .filter((token) => token.length >= 3);
}

function normalizeArabicDictForm(value) {
  return String(value || '')
    .normalize('NFC')
    .replace(/[\u064B-\u065F\u0670ЩЂ]/gu, '')
    .replace(/[\s(),ШЊ]+/gu, '')
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
  if (firstHead === 'СЌС‚Рѕ' && secondHead === 'СЌС‚Рё') return true;
  if (/^(СЌС‚РѕС‚|СЌС‚Р°|С‚РѕС‚|С‚Р°)$/u.test(firstHead) && /^(СЌС‚Рё|С‚Рµ)$/u.test(secondHead)) return true;
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
      if (/[СЊР№Р±РІРіРґР¶Р·РєР»РјРЅРїСЂСЃС‚С„С…С†С‡С€С‰]/u.test(aLast) && /[С‹РёР°СЏРµ]/u.test(bLast)) return true;
      if (aLast === 'Р°' && /[С‹Рё]/u.test(bLast)) return true;
      if (aLast === 'СЏ' && bLast === 'Рё') return true;
      if (aLast === 'Рµ' && /[СЏРё]/u.test(bLast)) return true;
      return false;
    })
  );
}

function isDictionarySingularForm(arabic) {
  const normalized = normalizeArabicDictForm(arabic);
  if (['Щ‡Ш°Ш§', 'Щ‡Ш°Щ‡', 'Ш°Щ„Щѓ', 'ШЄЩ„Щѓ'].includes(normalized)) return true;
  const value = String(arabic || '').trim();
  return !/[\s()ШЊ,]/u.test(value) && /(?:ЩЊ|Ш©ЩЊ|Щ‘ЩЊ)$/u.test(value);
}

function isDictionaryPluralForm(arabic, singularRu, pluralRu) {
  const normalized = normalizeArabicDictForm(arabic);
  if (['Щ‡Ш¤Щ„Ш§ШЎ', 'ШЈЩ€Щ„Ш¦Щѓ', 'Щ‡Ш°Ш§Щ†', 'Щ‡Ш§ШЄШ§Щ†'].includes(normalized)) return true;
  const value = String(arabic || '').trim().split(/[\s(ШЊ,]/u)[0];
  if (/(?:Ш§ШЄ|Щ€Щ†|ЩЉЩ†|Ш§ШЎ|Ш§Щ†|Щ‰)[ЩЋЩЏЩђЩЊЩЌ]?$/u.test(value)) return true;
  return /[ЩЏЩЊЩЌ]$/u.test(value) && russianPluralDirection(singularRu, pluralRu);
}

const DICTIONARY_FORM_PAIRS = new Set([
  'Щ‡Ш°Ш§|Щ‡Ш¤Щ„Ш§ШЎ',
  'Щ‡Ш°Щ‡|Щ‡Ш¤Щ„Ш§ШЎ',
  'Ш°Щ„Щѓ|Ш§Щ€Щ„Ш¦Щѓ',
  'ШЄЩ„Щѓ|Ш§Щ€Щ„Ш¦Щѓ',
  'Ш§Щ†Ш§|Щ†Ш­Щ†',
  'Ш§Щ†ШЄ|Ш§Щ†ШЄЩ…',
  'Ш§Щ†ШЄЩЉ|Ш§Щ†ШЄЩ†',
  'Щ‡Щ€|Щ‡Щ…',
  'Щ‡ЩЉ|Щ‡Щ†',
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
    (lesson === null ? '' : '<div class="dict-book-title">РЈСЂРѕРє ' + esc(String(lesson)) + '</div>') +
    '<table class="dict-book-table"><thead><tr><th>РџРµСЂРµРІРѕРґ</th><th>РњРЅРѕР¶РµСЃС‚РІРµРЅРЅРѕРµ С‡РёСЃР»Рѕ</th><th>Р•РґРёРЅСЃС‚РІРµРЅРЅРѕРµ С‡РёСЃР»Рѕ</th></tr></thead><tbody>' +
    rows
      .map(
        (w) =>
          '<tr><td>' +
          esc(w.ru) +
          '</td><td class="dict-book-ar dict-book-plural" dir="rtl">' +
          (w.plural ? esc(w.plural) : '<span class="dict-book-dash">вЂ”</span>') +
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
    cont.innerHTML = '<div class="lb-empty">РќРёС‡РµРіРѕ РЅРµ РЅР°Р№РґРµРЅРѕ</div>';
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

function wrapArabic(text) {
  const groups = [];
  const protectedText = String(text || '').replace(
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
        phrase.length <= 34 && phrase.trim().split(/\s+/).length <= 4 && !/[ШЊШ›Шџ.!]/.test(phrase);
      const isSentence = phrase.trim().split(/\s+/).length > 4 || /[ШЊШ›Шџ.!]/.test(phrase);
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
  if (/Рё[вЂ'`КјвЂ™]?СЂР°Р±|ШҐШ№Ш±Ш§ШЁ|ШҐЩђШ№Щ’Ш±ЩЋШ§ШЁ/.test(plain)) return 'is-irab';
  if (/РІР°Р¶РЅРѕ|СЃРµРєСЂРµС‚|Р·Р°РїРѕРјРЅ|РІРЅРёРјР°РЅРёРµ/.test(plain)) return 'is-important';
  if (/РїСЂРёРјРµСЂ|Щ…Ш«Ш§Щ„/.test(plain)) return 'is-example';
  if (/Р»РѕРіРёРєР°|СЃСѓС‚СЊ|РєР°Рє СЃРєР°Р·Р°С‚СЊ|РєР°Рє С‡РёС‚Р°С‚СЊ/.test(plain)) return 'is-logic';
  if (/РїСЂР°РІРёР»Рѕ|РЅРѕРІРѕРµ РїСЂР°РІРёР»Рѕ|РІСЃРїРѕРјРёРЅР°РµРј/.test(plain)) return 'is-rule';
  return '';
}

function ruleBlockLabel(cls) {
  if (cls === 'is-rule') return 'РџСЂР°РІРёР»Рѕ';
  if (cls === 'is-example') return 'РџСЂРёРјРµСЂ';
  if (cls === 'is-irab') return 'Р Р°Р·Р±РѕСЂ';
  if (cls === 'is-important') return 'Р’Р°Р¶РЅРѕ';
  if (cls === 'is-logic') return 'Р›РѕРіРёРєР°';
  if (cls === 'is-table') return 'РўР°Р±Р»РёС†Р°';
  if (cls === 'is-memorize') return 'Р—РЅР°С‚СЊ РЅР°РёР·СѓСЃС‚СЊ';
  return 'РџРѕСЏСЃРЅРµРЅРёРµ';
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
  safe = safe.replace(/<br\s*\/?>\s*(Рё[вЂ'`КјвЂ™]?СЂР°Р±\s*:)/gi, '<br><br>$1');
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
  return rule.title.startsWith('РўР°Р±Р»РёС†Р°') ? 10000 + Number(rule.id || 0) : Number(rule.id || 0);
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
      ? 'РЎРІРѕРґРЅР°СЏ С‚Р°Р±Р»РёС†Р° СЃ РїСЂРёРјРµСЂР°РјРё РїРѕ С‚РµРјРµ СѓСЂРѕРєР°'
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
        '</span><b>' +
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
        '</span><b>' +
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
    '</span><span class="book-choice-copy"><span class="book-choice-title">Читать в приложении</span><span class="book-choice-sub">Полный экран, свайпы и сохранение страницы</span></span><span aria-hidden="true">›</span></button>' +
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
    '<div class="book-reader-foot"><button class="book-nav-btn" id="book-prev-btn" type="button" onclick="nextBookPage(-1)">←</button>' +
    '<input class="book-page-input" id="book-page-input" type="number" min="1" onchange="applyBookPageFromInput()" aria-label="Номер страницы">' +
    '<button class="book-nav-btn" id="book-next-btn" type="button" onclick="nextBookPage(1)">→</button></div></div>';
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

function bindBookReaderGestures() {
  const stage = document.getElementById('book-reader-stage');
  if (!stage) return;
  stage.addEventListener('pointerdown', (event) => {
    bookSwipeStartX = event.clientX;
  });
  stage.addEventListener('pointerup', (event) => {
    if (bookSwipeStartX == null) return;
    const delta = event.clientX - bookSwipeStartX;
    bookSwipeStartX = null;
    if (Math.abs(delta) < 45) return;
    nextBookPage(delta < 0 ? 1 : -1);
  });
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
      const content = r.sections && r.sections.length ? formatRuleSections(r.sections) : formatRuleContent(r.content);
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
  const sorted = [...sections].sort((a, b) => {
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
    '<div class="rules-home-head"><div><div class="rules-home-kicker">РџСЂР°РІРёР»Р° РєСѓСЂСЃР°</div><div class="rules-home-title">РЈСЂРѕРєРё</div><div class="rules-home-sub">РџСЂР°РІРёР»Р°, РїСЂРёРјРµСЂС‹, СЂР°Р·Р±РѕСЂС‹ Рё С‚Р°Р±Р»РёС†С‹.</div></div></div>' +
    '<div class="rules-lesson-grid">' +
    lessons
      .map((lesson) => {
        const items = grouped[lesson];
        const tables = items.filter((r) => r.rule_kind === 'table' || /<table[\s\S]*?>/i.test(r.content)).length;
        const words = ruleWordCountForLesson(lesson);
        return (
          '<button class="rules-lesson-tile" type="button" onclick="showRuleLesson(\'' +
          esc(String(lesson)) +
          '\')"><span class="rules-lesson-num">РЈСЂРѕРє ' +
          esc(String(lesson)) +
          '</span><span class="rules-lesson-label">Р§С‚Рѕ РІРЅСѓС‚СЂРё</span><span class="rules-lesson-name">' +
          esc(items[0]?.title || 'РџСЂР°РІРёР»Р° СѓСЂРѕРєР°') +
          '</span><span class="rules-lesson-stats">' +
          items.length +
          ' ' +
          (items.length === 1 ? 'РїСЂР°РІРёР»Рѕ' : items.length < 5 ? 'РїСЂР°РІРёР»Р°' : 'РїСЂР°РІРёР»') +
          (tables ? ' В· ' + tables + ' С‚Р°Р±Р».' : '') +
          (words ? ' В· ' + words + ' СЃР»РѕРІ' : '') +
          '</span><span class="rules-lesson-full-outline" aria-label="Р’СЃРµ РїСЂР°РІРёР»Р° СѓСЂРѕРєР°">' +
          lessonPreviewList(items) +
          '</span><span class="rules-lesson-open">РћС‚РєСЂС‹С‚СЊ СѓСЂРѕРє вЂє</span></button>'
        );
      })
      .join('') +
    '</div>';
}

function renderRulesSearch(cont, grouped, query) {
  const lessons = Object.keys(grouped).sort(lessonSort);
  cont.innerHTML =
    '<div class="rules-search-head"><button class="rules-back-btn" type="button" onclick="showRulesIndex()">в†ђ Р’СЃРµ СѓСЂРѕРєРё</button><div><div class="rules-home-kicker">РџРѕРёСЃРє</div><div class="rules-home-title">РќР°Р№РґРµРЅРѕ РІ ' +
    lessons.length +
    ' ' +
    (lessons.length === 1 ? 'СѓСЂРѕРєРµ' : 'СѓСЂРѕРєР°С…') +
    '</div></div></div>' +
    lessons
      .map((lesson) => {
        const items = grouped[lesson];
        return (
          '<div class="rule-lesson-card"><div class="rule-lesson-header compact"><div><div class="rule-lesson-kicker">РЈСЂРѕРє ' +
          esc(String(lesson)) +
          '</div><div class="rule-lesson-title">' +
          items.length +
          ' СЃРѕРІРїР°Рґ.</div></div><button class="rules-open-btn" type="button" onclick="showRuleLesson(\'' +
          esc(String(lesson)) +
          '\')">РћС‚РєСЂС‹С‚СЊ</button></div><div class="rule-list">' +
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
    '<div class="rule-detail-page"><div class="rule-detail-hero"><button class="rules-back-btn" type="button" onclick="goBackFromRuleLesson()">в†ђ Р’СЃРµ СѓСЂРѕРєРё</button><div class="rule-lesson-kicker">РЈСЂРѕРє ' +
    esc(String(lesson)) +
    '</div><div class="rule-detail-title">' +
    wrapArabic(esc(items[0]?.title || 'РџСЂР°РІРёР»Р° СѓСЂРѕРєР°')) +
    '</div><div class="rule-detail-sub">' +
    items.length +
    ' ' +
    (items.length === 1 ? 'РїСЂР°РІРёР»Рѕ' : items.length < 5 ? 'РїСЂР°РІРёР»Р°' : 'РїСЂР°РІРёР»') +
    (words ? ' В· ' + words + ' СЃР»РѕРІ РІ СѓСЂРѕРєРµ' : '') +
    '</div><div class="rule-detail-actions"><button type="button" onclick="openGrammarTable(\'pronouns\')">РњРµСЃС‚РѕРёРјРµРЅРёСЏ</button><button type="button" onclick="openGrammarTable(\'verbs\')">Р“Р»Р°РіРѕР»С‹</button></div></div>' +
    '<div class="rule-detail-outline"><div class="rule-outline-title">Р§С‚Рѕ РІРЅСѓС‚СЂРё</div><div class="rule-outline-sub">РљР°СЂС‚Р° РїСЂР°РІРёР» СѓСЂРѕРєР°.</div><div class="rule-outline-list">' +
    lessonOutline(items) +
    '</div></div><div class="rule-list">' +
    renderRuleCards(items, false) +
    '</div></div>';
  highlightRuleMatches(cont, query);
}

function renderRules() {
  const searchInput = document.getElementById('rules-search');
  const q = (searchInput?.value || '').trim().toLowerCase();
  const cont = document.getElementById('rules-content');

  if (!cont) return;

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
  const title = type === 'verbs' ? 'Глаголы по временам' : 'Местоимения';
  const sub =
    type === 'verbs'
      ? 'Полезные таблицы по спряжению и временам'
      : 'Кратко о личных местоимениях';
  const titleEl = document.getElementById('verb-modal-title');
  const subEl = document.getElementById('verb-modal-sub');
  const bodyEl = document.getElementById('verb-modal-body');
  const overlay = document.getElementById('verb-modal-overlay');

  if (!titleEl || !subEl || !bodyEl || !overlay) return;

  titleEl.textContent = title;
  subEl.textContent = sub;
  bodyEl.innerHTML = type === 'verbs' ? renderVerbReferenceTable() : renderPronounReferenceTable();
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
  const rows = [
    ['РЇ', '<span class="ar-text">ШЈЩЋЩ†ЩЋШ§</span>', '<span class="ar-text">ЩЂЩђЩЉ</span>', '<span class="ar-text">Щ„ЩђЩЉ / Ш№ЩђЩ†Щ’ШЇЩђЩЉ</span>'],
    ['РњС‹', '<span class="ar-text">Щ†ЩЋШ­Щ’Щ†ЩЏ</span>', '<span class="ar-text">ЩЂЩ†ЩЋШ§</span>', '<span class="ar-text">Щ„ЩЋЩ†ЩЋШ§ / Ш№ЩђЩ†Щ’ШЇЩЋЩ†ЩЋШ§</span>'],
    ['РўС‹ (Рј.)', '<span class="ar-text">ШЈЩЋЩ†Щ’ШЄЩЋ</span>', '<span class="ar-text">ЩЂЩѓЩЋ</span>', '<span class="ar-text">Щ„ЩЋЩѓЩЋ / Ш№ЩђЩ†Щ’ШЇЩЋЩѓЩЋ</span>'],
    ['РўС‹ (Р¶.)', '<span class="ar-text">ШЈЩЋЩ†Щ’ШЄЩђ</span>', '<span class="ar-text">ЩЂЩѓЩђ</span>', '<span class="ar-text">Щ„ЩЋЩѓЩђ / Ш№ЩђЩ†Щ’ШЇЩЋЩѓЩђ</span>'],
    ['РћРЅ', '<span class="ar-text">Щ‡ЩЏЩ€ЩЋ</span>', '<span class="ar-text">ЩЂЩ‡ЩЏ</span>', '<span class="ar-text">Щ„ЩЋЩ‡ЩЏ / Ш№ЩђЩ†Щ’ШЇЩЋЩ‡ЩЏ</span>'],
    ['РћРЅР°', '<span class="ar-text">Щ‡ЩђЩЉЩЋ</span>', '<span class="ar-text">ЩЂЩ‡ЩЋШ§</span>', '<span class="ar-text">Щ„ЩЋЩ‡ЩЋШ§ / Ш№ЩђЩ†Щ’ШЇЩЋЩ‡ЩЋШ§</span>'],
    ['РћРЅРё (Рј.)', '<span class="ar-text">Щ‡ЩЏЩ…Щ’</span>', '<span class="ar-text">ЩЂЩ‡ЩЏЩ…Щ’</span>', '<span class="ar-text">Щ„ЩЋЩ‡ЩЏЩ…Щ’ / Ш№ЩђЩ†Щ’ШЇЩЋЩ‡ЩЏЩ…Щ’</span>'],
    ['РћРЅРё (Р¶.)', '<span class="ar-text">Щ‡ЩЏЩ†Щ‘ЩЋ</span>', '<span class="ar-text">ЩЂЩ‡ЩЏЩ†Щ‘ЩЋ</span>', '<span class="ar-text">Щ„ЩЋЩ‡ЩЏЩ†Щ‘ЩЋ / Ш№ЩђЩ†Щ’ШЇЩЋЩ‡ЩЏЩ†Щ‘ЩЋ</span>'],
  ];
  return (
    '<div class="grammar-ref-note">Р‘С‹СЃС‚СЂР°СЏ С‚Р°Р±Р»РёС†Р° РґР»СЏ РїРѕРІС‚РѕСЂРµРЅРёСЏ: РѕС‚РґРµР»СЊРЅРѕРµ РјРµСЃС‚РѕРёРјРµРЅРёРµ, СЃР»РёС‚РЅРѕРµ РјРµСЃС‚РѕРёРјРµРЅРёРµ Рё С„РѕСЂРјС‹ РїСЂРёРЅР°РґР»РµР¶РЅРѕСЃС‚Рё.</div>' +
    grammarRefTable(['Р—РЅР°С‡РµРЅРёРµ', 'РћС‚РґРµР»СЊРЅРѕ', 'РЎР»РёС‚РЅРѕ', 'РЈ / РїСЂРёРЅР°РґР»РµР¶РёС‚'], rows)
  );
}

function renderVerbReferenceTable() {
  const rows = [
    ['РџСЂРѕС€РµРґС€РµРµ', '<span class="ar-text">ЩЃЩЋШ№ЩЋЩ„ЩЋ</span>', 'РґРµР№СЃС‚РІРёРµ СѓР¶Рµ РїСЂРѕРёР·РѕС€Р»Рѕ', '<span class="ar-text">Ш°ЩЋЩ‡ЩЋШЁЩЋ</span> вЂ” РѕРЅ РїРѕС€РµР»'],
    ['РќР°СЃС‚РѕСЏС‰РµРµ', '<span class="ar-text">ЩЉЩЋЩЃЩ’Ш№ЩЋЩ„ЩЏ</span>', 'РґРµР№СЃС‚РІРёРµ РїСЂРѕРёСЃС…РѕРґРёС‚ СЃРµР№С‡Р°СЃ РёР»Рё РѕР±С‹С‡РЅРѕ', '<span class="ar-text">ЩЉЩЋШ°Щ’Щ‡ЩЋШЁЩЏ</span> вЂ” РѕРЅ РёРґРµС‚'],
    ['Р‘СѓРґСѓС‰РµРµ Р±Р»РёР·РєРѕРµ', '<span class="ar-text">ШіЩЋЩЉЩЋЩЃЩ’Ш№ЩЋЩ„ЩЏ</span>', 'СЃРєРѕСЂРѕ / Р·Р°С‚РµРј СЃРґРµР»Р°РµС‚', '<span class="ar-text">ШіЩЋЩЉЩЋШ°Щ’Щ‡ЩЋШЁЩЏ</span> вЂ” РѕРЅ РїРѕР№РґРµС‚'],
    ['Р‘СѓРґСѓС‰РµРµ РѕР±С‰РµРµ', '<span class="ar-text">ШіЩЋЩ€Щ’ЩЃЩЋ ЩЉЩЋЩЃЩ’Ш№ЩЋЩ„ЩЏ</span>', 'СЃРґРµР»Р°РµС‚ РІ Р±СѓРґСѓС‰РµРј', '<span class="ar-text">ШіЩЋЩ€Щ’ЩЃЩЋ ЩЉЩЋШ°Щ’Щ‡ЩЋШЁЩЏ</span> вЂ” РѕРЅ РїРѕР№РґРµС‚'],
    ['РџРѕРІРµР»РёС‚РµР»СЊРЅРѕРµ', '<span class="ar-text">Ш§ЩђЩЃЩ’Ш№ЩЋЩ„Щ’</span>', 'РїСЂРёРєР°Р· / РїСЂРѕСЃСЊР±Р°', '<span class="ar-text">Ш§ЩђШ°Щ’Щ‡ЩЋШЁЩ’</span> вЂ” РёРґРё'],
    ['Р—Р°РїСЂРµС‚', '<span class="ar-text">Щ„ЩЋШ§ ШЄЩЋЩЃЩ’Ш№ЩЋЩ„Щ’</span>', 'РЅРµ РґРµР»Р°Р№', '<span class="ar-text">Щ„ЩЋШ§ ШЄЩЋШ°Щ’Щ‡ЩЋШЁЩ’</span> вЂ” РЅРµ РёРґРё'],
  ];
  return (
    '<div class="grammar-ref-note">РЁРїР°СЂРіР°Р»РєР° РїРѕ РІСЂРµРјРµРЅР°Рј. Р”Р»СЏ РїРѕР»РЅРѕРіРѕ СЃРїСЂСЏР¶РµРЅРёСЏ РѕС‚РєСЂРѕР№ СЂР°Р·РґРµР» вЂњР“Р»Р°РіРѕР»С‹ Рё СЃРїСЂСЏР¶РµРЅРёСЏвЂќ Рё РІРІРµРґРё Р°СЂР°Р±СЃРєРёР№ РіР»Р°РіРѕР».</div>' +
    grammarRefTable(['Р’СЂРµРјСЏ / С„РѕСЂРјР°', 'РЁР°Р±Р»РѕРЅ', 'РЎРјС‹СЃР»', 'РџСЂРёРјРµСЂ'], rows)
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
