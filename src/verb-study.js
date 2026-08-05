(function () {
  'use strict';

  var rootId = 'screen-verb-study';
  var endpoint = 'https://arabic-trainer-qutrub.narimansaud.workers.dev/conjugate';
  var state = { verb: '', forms: null, loading: false, error: '', modal: false, layout: 'list', mode: 'all' };
  var modes = [
    ['all', 'Все формы', 'جميع التصريفات', 'Полный обзор всех доступных форм.'],
    ['past-active', 'Прошедшее', 'الماضي المعلوم', 'Действие уже произошло.'],
    ['past-passive', 'Прошедшее, страд.', 'الماضي المجهول', 'Действие совершено над предметом.'],
    ['present-active', 'Настоящее', 'المضارع المعلوم', 'Настоящее или будущее действие.'],
    ['present-passive', 'Настоящее, страд.', 'المضارع المجهول', 'Действие над предметом в настоящем или будущем.'],
    ['subjunctive', 'Сослагательное', 'المضارع المنصوب', 'Употребляется, например, после أَنْ и لَنْ.'],
    ['jussive', 'Усечённое', 'المضارع المجزوم', 'Употребляется, например, после لَمْ.'],
    ['emphatic', 'Усиленное', 'المضارع المؤكد', 'Подчёркивает действие нуном усиления.'],
    ['imperative', 'Повелительное', 'الأمر', 'Просьба, приказ или совет для второго лица.'],
    ['imperative-emphatic', 'Усиленное повел.', 'الأمر المؤكد', 'Повелительная форма с усилением.']
  ];

  function esc(value) {
    return String(value == null ? '' : value).replace(/[&<>"']/g, function (char) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[char];
    });
  }

  function clean(value) {
    return String(value || '').replace(/[\u064B-\u065F\u0670]/g, '');
  }

  function modeInfo() {
    return modes.filter(function (item) { return item[0] === state.mode; })[0] || modes[0];
  }

  function matches(groupName, mode) {
    var name = clean(groupName);
    if (mode === 'all') return true;
    if (mode === 'past-active') return name.includes('الماضي') && name.includes('المعلوم');
    if (mode === 'past-passive') return name.includes('الماضي') && name.includes('المجهول');
    if (mode === 'present-active') return name.includes('المضارع') && name.includes('المعلوم') && !name.includes('المنصوب') && !name.includes('المجزوم') && !name.includes('المؤكد');
    if (mode === 'present-passive') return name.includes('المضارع') && name.includes('المجهول');
    if (mode === 'subjunctive') return name.includes('المنصوب');
    if (mode === 'jussive') return name.includes('المجزوم');
    if (mode === 'emphatic') return name.includes('المؤكد') && !name.includes('الأمر');
    if (mode === 'imperative') return name.includes('الأمر') && !name.includes('المؤكد');
    if (mode === 'imperative-emphatic') return name.includes('الأمر') && name.includes('المؤكد');
    return false;
  }

  function groups() {
    if (!state.forms) return [];
    var source = state.forms.all_forms || {};
    var result = Object.keys(source).map(function (name) {
      var values = source[name] || {};
      return {
        name: name,
        rows: Object.keys(values).filter(function (key) { return values[key]; }).map(function (key) {
          return { pronoun: key, form: values[key] };
        })
      };
    }).filter(function (group) { return group.rows.length; });

    if (!result.length) {
      [['الماضي المعلوم', state.forms.past], ['المضارع المعلوم', state.forms.present], ['الأمر', state.forms.imperative]].forEach(function (entry) {
        var values = entry[1] || {};
        var rows = Object.keys(values).filter(function (key) { return values[key]; }).map(function (key) {
          return { pronoun: key, form: values[key] };
        });
        if (rows.length) result.push({ name: entry[0], rows: rows });
      });
    }
    return result.filter(function (group) { return matches(group.name, state.mode); });
  }

  function renderGroup(group) {
    var content;
    if (state.layout === 'table') {
      content = '<div class="vs-table-wrap"><table class="vs-table"><thead><tr><th>Лицо</th><th>Форма</th></tr></thead><tbody>' +
        group.rows.map(function (row) {
          return '<tr><td class="vs-pronoun" dir="rtl">' + esc(row.pronoun) + '</td><td class="vs-result-form" dir="rtl">' + esc(row.form) + '</td></tr>';
        }).join('') + '</tbody></table></div>';
    } else {
      content = '<div class="vs-form-list">' + group.rows.map(function (row) {
        return '<div class="vs-form-row"><div class="vs-pronoun" dir="rtl">' + esc(row.pronoun) + '</div><div class="vs-result-form" dir="rtl">' + esc(row.form) + '</div></div>';
      }).join('') + '</div>';
    }
    return '<section class="vs-result-group"><h3 dir="rtl">' + esc(group.name) + '</h3>' + content + '</section>';
  }

  function modalHtml() {
    if (!state.modal) return '';
    var info = modeInfo();
    var resultGroups = groups();
    return '<div class="vs-modal" role="dialog" aria-modal="true" aria-label="Спряжения глагола"><div class="vs-modal-sheet">' +
      '<header class="vs-modal-head"><div><p class="vs-eyebrow">Спряжения глагола</p><h2 class="vs-modal-verb" dir="rtl">' + esc(state.verb) + '</h2></div><button class="vs-icon-button" data-action="close" aria-label="Закрыть">×</button></header>' +
      '<div class="vs-help"><strong>Подсказка</strong><span>«Список» удобен для чтения, «Таблица» — для сравнения форм по лицам.</span></div>' +
      '<div class="vs-view-switch"><button class="vs-view-button ' + (state.layout === 'list' ? 'active' : '') + '" data-layout="list">Список</button><button class="vs-view-button ' + (state.layout === 'table' ? 'active' : '') + '" data-layout="table">Таблица</button></div>' +
      '<section class="vs-mode-toolbar"><p><strong dir="rtl">' + esc(info[2]) + '</strong><span>' + esc(info[1]) + '</span></p><small>' + esc(info[3]) + '</small><div class="vs-modal-chips">' +
      modes.map(function (item) {
        return '<button class="vs-chip ' + (item[0] === state.mode ? 'active' : '') + '" data-mode="' + item[0] + '">' + esc(item[1]) + '</button>';
      }).join('') + '</div></section><div class="vs-results">' +
      (resultGroups.length ? resultGroups.map(renderGroup).join('') : '<div class="vs-empty">Для этого режима Qutrub не вернул формы глагола.</div>') +
      '</div></div></div>';
  }

  function render() {
    var root = document.getElementById(rootId);
    if (!root) return;
    root.innerHTML = '<main class="vs-page"><header class="vs-head"><button class="vs-back" data-action="back" aria-label="Назад">‹</button><div><h1>Спряжение глаголов</h1><p class="vs-sub">Фусха: формы строятся по правилам Qutrub.</p></div></header>' +
      '<section class="vs-card"><label class="vs-label" for="vs-input">Глагол в прошедшем времени</label><div class="vs-search"><input id="vs-input" class="vs-input" value="' + esc(state.verb) + '" placeholder="كَتَبَ" dir="rtl" autocomplete="off"><button class="vs-primary" data-action="conjugate" ' + (state.loading ? 'disabled' : '') + '>' + (state.loading ? 'Строим…' : 'Спрягать') + '</button></div><p class="vs-tip">Нажмите «Спрягать»: откроется окно со всеми формами. Внутри можно выбрать время, залог, наклонение и вид таблицы.</p>' + (state.error ? '<p class="vs-error">' + esc(state.error) + '</p>' : '') + '</section>' +
      '<section class="vs-card"><h2>Доступные режимы</h2><div class="vs-choice-grid"><div><strong>Времена</strong><span dir="rtl">الماضي · المضارع · الأمر</span></div><div><strong>Залоги</strong><span dir="rtl">المعلوم · المجهول</span></div><div><strong>Наклонения</strong><span dir="rtl">المرفوع · المنصوب · المجزوم · المؤكد</span></div></div></section></main>' + modalHtml();

    root.querySelectorAll('[data-action]').forEach(function (button) {
      button.onclick = function () {
        if (button.dataset.action === 'back' && window.showScreen) window.showScreen('screen-course');
        if (button.dataset.action === 'conjugate') conjugate();
        if (button.dataset.action === 'close') { state.modal = false; render(); }
      };
    });
    root.querySelectorAll('[data-layout]').forEach(function (button) {
      button.onclick = function () { state.layout = button.dataset.layout; render(); };
    });
    root.querySelectorAll('[data-mode]').forEach(function (button) {
      button.onclick = function () { state.mode = button.dataset.mode; render(); };
    });
    var input = root.querySelector('#vs-input');
    if (input) input.onkeydown = function (event) { if (event.key === 'Enter') conjugate(); };
  }

  function conjugate() {
    var input = document.getElementById('vs-input');
    state.verb = (input ? input.value : state.verb).trim();
    if (!state.verb) { state.error = 'Введите арабский глагол.'; render(); return; }

    state.loading = true;
    state.error = '';
    state.modal = false;
    render();
    fetch(endpoint + '?verb=' + encodeURIComponent(state.verb), { headers: { Accept: 'application/json' } })
      .then(function (response) {
        if (!response.ok) throw new Error('Qutrub временно недоступен.');
        return response.json();
      })
      .then(function (data) {
        if (!data || !data.ok || !data.forms) throw new Error('Не удалось построить формы этого глагола.');
        state.forms = data.forms;
        state.verb = data.verb || state.verb;
        state.mode = 'all';
        state.layout = 'list';
        state.modal = true;
      })
      .catch(function (error) {
        state.forms = null;
        state.error = error.message || 'Не удалось построить спряжение.';
      })
      .finally(function () {
        state.loading = false;
        render();
      });
  }

  window.openVerbStudy = function () {
    if (window.showScreen) window.showScreen(rootId);
    render();
  };
}());
