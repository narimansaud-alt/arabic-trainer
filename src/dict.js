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
  if (data && data.length) {
    const ids = data.map((r) => r.id);
    let sectionsByRule = {};
    if (ids.length) {
      const { data: sections } = await db.from('rule_sections').select('*').in('rule_id', ids).order('sort_order');
      if (sections && sections.length) {
        sectionsByRule = sections.reduce((acc, section) => {
          if (!acc[section.rule_id]) acc[section.rule_id] = [];
          acc[section.rule_id].push(section);
          return acc;
        }, {});
      }
    }
    Dict.rules = data.map((r) => ({ ...r, sections: sectionsByRule[r.id] || [], volLabel: volume.label }));
  }
  if (!Dict.rules.length) {
    document.getElementById('rules-content').innerHTML =
      '<div class="lb-empty">Правила ещё не добавлены.<br><small>Добавьте через Supabase → таблица rules</small></div>';
    return;
  }
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
    return '<div class="rule-block ' + cls + '"><div class="rule-block-label">' + ruleBlockLabel(cls) + '</div>' + restored + '</div>';
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

function lessonTopics(items, limit = 3) {
  return items
    .slice(0, limit)
    .map((r) => '<span class="rule-topic-chip">' + wrapArabic(esc(r.title)) + '</span>')
    .join('');
}

function lessonOutline(items) {
  return items
    .map(
      (r, i) =>
        '<button class="rule-outline-row accent-' +
        ruleAccent(r, i) +
        '" type="button" onclick="document.getElementById(\'rule-card-' +
        esc(String(r.id)) +
        '\')?.scrollIntoView({behavior:\'smooth\',block:\'start\'})"><span>' +
        (i + 1) +
        '</span><b>' +
        wrapArabic(esc(r.title)) +
        '</b></button>'
    )
    .join('');
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
        (openCards ? ' open' : '') +
        '" id="rule-card-' +
        esc(String(r.id)) +
        '"><button class="rule-card-head" type="button" aria-expanded="' +
        (openCards ? 'true' : 'false') +
        '" onclick="toggleRuleCard(this)"><span class="rule-index">' +
        (i + 1) +
        '</span><span class="rule-title-wrap"><span class="rule-title">' +
        wrapArabic(esc(r.title)) +
        '</span><span class="rule-preview">' +
        wrapArabic(esc(rulePreview(r))) +
        '</span></span><span class="rule-chevron">›</span></button><div class="rule-card-body"><div class="rule-content">' +
        wrapArabic(content) +
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
    '<div class="rule-flow">' +
    sorted
      .map((section) => {
        const cls = 'is-' + (section.section_type || 'note');
        const label = esc(section.title || ruleBlockLabel(cls));
        return '<div class="rule-block ' + cls + '"><div class="rule-block-label">' + label + '</div>' + section.content + '</div>';
      })
      .join('') +
    '</div>'
  );
}

function renderRulesIndex(cont, grouped) {
  const lessons = Object.keys(grouped).sort(lessonSort);
  cont.innerHTML =
    '<div class="rules-home-head"><div><div class="rules-home-kicker">Правила курса</div><div class="rules-home-title">Уроки</div><div class="rules-home-sub">Правила, примеры, разборы и таблицы.</div></div></div>' +
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
          '</span><span class="rules-lesson-name">' +
          esc(items[0]?.title || 'Правила урока') +
          '</span><span class="rules-lesson-stats">' +
          items.length +
          ' ' +
          (items.length === 1 ? 'правило' : items.length < 5 ? 'правила' : 'правил') +
          (tables ? ' · ' + tables + ' табл.' : '') +
          (words ? ' · ' + words + ' слов' : '') +
          '</span><span class="rules-lesson-topics">' +
          lessonTopics(items, 2) +
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
          renderRuleCards(items, true) +
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
    '</div><div class="rule-detail-title">Правила и пояснения</div><div class="rule-detail-sub">' +
    items.length +
    ' ' +
    (items.length === 1 ? 'правило' : items.length < 5 ? 'правила' : 'правил') +
    (words ? ' · ' + words + ' слов в уроке' : '') +
    '</div><div class="rule-detail-actions"><button type="button" onclick="openGrammarTable(\'pronouns\')">Местоимения</button><button type="button" onclick="openGrammarTable(\'verbs\')">Глаголы</button></div></div>' +
    '<div class="rule-detail-outline"><div class="rule-outline-title">Темы урока</div><div class="rule-outline-sub">Карта правил урока.</div><div class="rule-outline-list">' +
    lessonOutline(items) +
    '</div></div><div class="rule-list">' +
    renderRuleCards(items, true) +
    '</div></div>';
  highlightRuleMatches(cont, query);
}

function renderRules() {
  const q = (document.getElementById('rules-search').value || '').trim().toLowerCase();
  let rules = Dict.rules;
  if (Settings.rulesLesson !== 'all') rules = rules.filter((r) => String(r.lesson_number) === Settings.rulesLesson);
  if (q) rules = rules.filter((r) => ruleSearchText(r).includes(q));
  const cont = document.getElementById('rules-content');
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
  const sub = type === 'verbs' ? 'الأَزْمِنَةُ وَالتَّصْرِيف' : 'الضَّمَائِر';
  document.getElementById('verb-modal-title').textContent = title;
  document.getElementById('verb-modal-sub').textContent = sub;
  document.getElementById('verb-modal-body').innerHTML = type === 'verbs' ? renderVerbReferenceTable() : renderPronounReferenceTable();
  document.getElementById('verb-modal-overlay').classList.remove('hidden');
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
    ['Я', '<span class="ar-text">أَنَا</span>', '<span class="ar-text">ـِي</span>', '<span class="ar-text">لِي / عِنْدِي</span>'],
    ['Мы', '<span class="ar-text">نَحْنُ</span>', '<span class="ar-text">ـنَا</span>', '<span class="ar-text">لَنَا / عِنْدَنَا</span>'],
    ['Ты (м.)', '<span class="ar-text">أَنْتَ</span>', '<span class="ar-text">ـكَ</span>', '<span class="ar-text">لَكَ / عِنْدَكَ</span>'],
    ['Ты (ж.)', '<span class="ar-text">أَنْتِ</span>', '<span class="ar-text">ـكِ</span>', '<span class="ar-text">لَكِ / عِنْدَكِ</span>'],
    ['Он', '<span class="ar-text">هُوَ</span>', '<span class="ar-text">ـهُ</span>', '<span class="ar-text">لَهُ / عِنْدَهُ</span>'],
    ['Она', '<span class="ar-text">هِيَ</span>', '<span class="ar-text">ـهَا</span>', '<span class="ar-text">لَهَا / عِنْدَهَا</span>'],
    ['Они (м.)', '<span class="ar-text">هُمْ</span>', '<span class="ar-text">ـهُمْ</span>', '<span class="ar-text">لَهُمْ / عِنْدَهُمْ</span>'],
    ['Они (ж.)', '<span class="ar-text">هُنَّ</span>', '<span class="ar-text">ـهُنَّ</span>', '<span class="ar-text">لَهُنَّ / عِنْدَهُنَّ</span>'],
  ];
  return (
    '<div class="grammar-ref-note">Быстрая таблица для повторения: отдельное местоимение, слитное местоимение и формы принадлежности.</div>' +
    grammarRefTable(['Значение', 'Отдельно', 'Слитно', 'У / принадлежит'], rows)
  );
}

function renderVerbReferenceTable() {
  const rows = [
    ['Прошедшее', '<span class="ar-text">فَعَلَ</span>', 'действие уже произошло', '<span class="ar-text">ذَهَبَ</span> — он пошел'],
    ['Настоящее', '<span class="ar-text">يَفْعَلُ</span>', 'действие происходит сейчас или обычно', '<span class="ar-text">يَذْهَبُ</span> — он идет'],
    ['Будущее близкое', '<span class="ar-text">سَيَفْعَلُ</span>', 'скоро / затем сделает', '<span class="ar-text">سَيَذْهَبُ</span> — он пойдет'],
    ['Будущее общее', '<span class="ar-text">سَوْفَ يَفْعَلُ</span>', 'сделает в будущем', '<span class="ar-text">سَوْفَ يَذْهَبُ</span> — он пойдет'],
    ['Повелительное', '<span class="ar-text">اِفْعَلْ</span>', 'приказ / просьба', '<span class="ar-text">اِذْهَبْ</span> — иди'],
    ['Запрет', '<span class="ar-text">لَا تَفْعَلْ</span>', 'не делай', '<span class="ar-text">لَا تَذْهَبْ</span> — не иди'],
  ];
  return (
    '<div class="grammar-ref-note">Шпаргалка по временам. Для полного спряжения открой раздел “Глаголы и спряжения” и введи арабский глагол.</div>' +
    grammarRefTable(['Время / форма', 'Шаблон', 'Смысл', 'Пример'], rows)
  );
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
