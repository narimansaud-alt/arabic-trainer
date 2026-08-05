(function () {
  'use strict';

  var rootId = 'screen-verb-study';
  var endpoint = 'https://arabic-trainer-qutrub.narimansaud.workers.dev/conjugate';
  var state = { verb: '', forms: null, loading: false, error: '', modal: '', layout: 'list', tense: 'all', voice: 'all', mood: 'all' };
  var persons = {
    'هُوَ': 'Он', 'هو': 'Он', 'هُمَا': 'Они двое', 'هما': 'Они двое',
    'هُمْ': 'Они', 'هم': 'Они', 'هِيَ': 'Она', 'هي': 'Она',
    'هُنَّ': 'Они (ж.)', 'هن': 'Они (ж.)', 'أَنْتَ': 'Ты (м.)', 'أنت': 'Ты',
    'أَنْتِ': 'Ты (ж.)', 'أنتِ': 'Ты (ж.)', 'أَنْتُمَا': 'Вы двое', 'أنتما': 'Вы двое',
    'أَنْتُمْ': 'Вы (м.)', 'أنتم': 'Вы (м.)', 'أَنْتُنَّ': 'Вы (ж.)', 'أنتن': 'Вы (ж.)',
    'أَنَا': 'Я', 'أنا': 'Я', 'نَحْنُ': 'Мы', 'نحن': 'Мы'
  };
  var modes = [
    ['all', 'Все формы', 'جميع التصريفات', 'Полный обзор всех времён, залогов и наклонений.'],
    ['past-active', 'Прошедшее', 'الماضي المعلوم', 'Прошедшее время, действительный залог.'],
    ['past-passive', 'Прошедшее, страдательное', 'الماضي المجهول', 'Прошедшее время, страдательный залог.'],
    ['present-active', 'Настоящее', 'المضارع المعلوم', 'Настоящее или будущее, действительный залог.'],
    ['present-passive', 'Настоящее, страдательное', 'المضارع المجهول', 'Настоящее или будущее, страдательный залог.'],
    ['subjunctive', 'Сослагательное', 'المضارع المنصوب', 'Употребляется, например, после أَنْ и لَنْ.'],
    ['jussive', 'Усечённое', 'المضارع المجزوم', 'Употребляется, например, после لَمْ.'],
    ['emphatic', 'Усиленное', 'المضارع المؤكد', 'Подчёркивает действие нуном усиления.'],
    ['imperative', 'Повелительное', 'الأمر', 'Просьба, приказ или совет для второго лица.'],
    ['imperative-emphatic', 'Усиленное повелительное', 'الأمر المؤكد', 'Повелительная форма с усилением.']
  ];
  var patterns = [
    ['I', 'فَعَلَ / يَفْعَلُ', 'Базовая трёхбуквенная порода. Гласная настоящего времени определяется словарём.', [['كَتَبَ / يَكْتُبُ', 'писать'], ['ذَهَبَ / يَذْهَبُ', 'идти']]],
    ['II', 'فَعَّلَ / يُفَعِّلُ', 'Усиление действия, интенсивность или побуждение к действию.', [['عَلَّمَ / يُعَلِّمُ', 'обучать'], ['كَسَّرَ / يُكَسِّرُ', 'разбивать на части']]],
    ['III', 'فَاعَلَ / يُفَاعِلُ', 'Часто выражает взаимное действие или действие, направленное на другого.', [['شَارَكَ / يُشَارِكُ', 'участвовать'], ['سَاعَدَ / يُسَاعِدُ', 'помогать']]],
    ['IV', 'أَفْعَلَ / يُفْعِلُ', 'Часто придаёт значение побуждения, введения в состояние или переходности.', [['أَخْرَجَ / يُخْرِجُ', 'выводить'], ['أَسْلَمَ / يُسْلِمُ', 'предаваться, принимать ислам']]],
    ['V', 'تَفَعَّلَ / يَتَفَعَّلُ', 'Возвратное значение или приобретение качества от II породы.', [['تَعَلَّمَ / يَتَعَلَّمُ', 'учиться'], ['تَكَسَّرَ / يَتَكَسَّرُ', 'ломаться на части']]],
    ['VI', 'تَفَاعَلَ / يَتَفَاعَلُ', 'Взаимность или действие нескольких участников.', [['تَعَاوَنَ / يَتَعَاوَنُ', 'сотрудничать'], ['تَشَارَكَ / يَتَشَارَكُ', 'делить, участвовать вместе']]],
    ['VII', 'اِنْفَعَلَ / يَنْفَعِلُ', 'Обычно возвратность или результат действия над предметом.', [['اِنْكَسَرَ / يَنْكَسِرُ', 'сломаться'], ['اِنْفَتَحَ / يَنْفَتِحُ', 'открываться']]],
    ['VIII', 'اِفْتَعَلَ / يَفْتَعِلُ', 'Участие субъекта в действии, усилие или принятие действия.', [['اِجْتَمَعَ / يَجْتَمِعُ', 'собираться'], ['اِحْتَمَلَ / يَحْتَمِلُ', 'переносить, терпеть']]],
    ['IX', 'اِفْعَلَّ / يَفْعَلُّ', 'Редкая порода, главным образом для цветов и физических качеств.', [['اِحْمَرَّ / يَحْمَرُّ', 'краснеть'], ['اِصْفَرَّ / يَصْفَرُّ', 'желтеть']]],
    ['X', 'اِسْتَفْعَلَ / يَسْتَفْعِلُ', 'Просьба, поиск, стремление или получение свойства.', [['اِسْتَخْرَجَ / يَسْتَخْرِجُ', 'извлекать'], ['اِسْتَغْفَرَ / يَسْتَغْفِرُ', 'просить прощения']]]
  ];

  function esc(value) {
    return String(value == null ? '' : value).replace(/[&<>"']/g, function (char) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[char];
    });
  }
  function clean(value) { return String(value || '').replace(/[\u064B-\u065F\u0670]/g, ''); }
  function personRu(value) { return persons[value] || persons[clean(value)] || 'Лицо'; }
  function groupInfo(name) {
    var value = clean(name);
    if (value.includes('الأمر') && value.includes('المؤكد')) return ['الأمر المؤكد', 'Усиленное повелительное'];
    if (value.includes('الأمر')) return ['الأمر', 'Повелительное'];
    if (value.includes('الماضي') && value.includes('المجهول')) return ['الماضي المجهول', 'Прошедшее, страдательный залог'];
    if (value.includes('الماضي')) return ['الماضي المعلوم', 'Прошедшее, действительный залог'];
    if (value.includes('المنصوب')) return ['المضارع المنصوب', 'Настоящее, сослагательное'];
    if (value.includes('المجزوم')) return ['المضارع المجزوم', 'Настоящее, усечённое'];
    if (value.includes('المؤكد')) return ['المضارع المؤكد', 'Настоящее, усиленное'];
    if (value.includes('المجهول')) return ['المضارع المجهول', 'Настоящее, страдательный залог'];
    return ['المضارع المعلوم', 'Настоящее, действительный залог'];
  }
  function matches(name) {
    var value = clean(name);
    if (state.tense === 'past' && !value.includes('الماضي')) return false;
    if (state.tense === 'present' && !value.includes('المضارع')) return false;
    if (state.tense === 'imperative' && !value.includes('الأمر')) return false;
    if (state.voice === 'active' && value.includes('المجهول')) return false;
    if (state.voice === 'passive' && !value.includes('المجهول')) return false;
    if (state.mood === 'plain' && (value.includes('المنصوب') || value.includes('المجزوم') || value.includes('المؤكد'))) return false;
    if (state.mood === 'subjunctive' && !value.includes('المنصوب')) return false;
    if (state.mood === 'jussive' && !value.includes('المجزوم')) return false;
    if (state.mood === 'emphatic' && !value.includes('المؤكد')) return false;
    return true;
  }
  function visibleGroups() {
    if (!state.forms) return [];
    var source = state.forms.all_forms || {};
    var groups = Object.keys(source).map(function (name) {
      var values = source[name] || {};
      return { name: name, rows: Object.keys(values).filter(function (key) { return values[key]; }).map(function (key) { return { pronoun: key, form: values[key] }; }) };
    }).filter(function (group) { return group.rows.length; });
    if (!groups.length) {
      [['الماضي المعلوم', state.forms.past], ['المضارع المعلوم', state.forms.present], ['الأمر', state.forms.imperative]].forEach(function (entry) {
        var values = entry[1] || {};
        var rows = Object.keys(values).filter(function (key) { return values[key]; }).map(function (key) { return { pronoun: key, form: values[key] }; });
        if (rows.length) groups.push({ name: entry[0], rows: rows });
      });
    }
    return groups.filter(function (group) { return matches(group.name); });
  }
  function renderGroup(group) {
    var title = groupInfo(group.name);
    var content = state.layout === 'table'
      ? '<div class="vs-table-wrap"><table class="vs-table"><thead><tr><th>Лицо</th><th>Перевод</th><th>Форма</th></tr></thead><tbody>' + group.rows.map(function (row) {
          return '<tr><td class="vs-pronoun" dir="rtl">' + esc(row.pronoun) + '</td><td class="vs-person-ru">' + esc(personRu(row.pronoun)) + '</td><td class="vs-result-form" dir="rtl">' + esc(row.form) + '</td></tr>';
        }).join('') + '</tbody></table></div>'
      : '<div class="vs-form-list">' + group.rows.map(function (row) {
          return '<div class="vs-form-row"><div><div class="vs-pronoun" dir="rtl">' + esc(row.pronoun) + '</div><small>' + esc(personRu(row.pronoun)) + '</small></div><div class="vs-result-form" dir="rtl">' + esc(row.form) + '</div></div>';
        }).join('') + '</div>';
    return '<section class="vs-result-group"><div class="vs-group-heading"><h3 dir="rtl">' + esc(title[0]) + '</h3><p>' + esc(title[1]) + '</p></div>' + content + '</section>';
  }
  function conjugationModal() {
    var groups = visibleGroups();
    return '<div class="vs-modal" role="dialog" aria-modal="true"><div class="vs-modal-sheet"><header class="vs-modal-head"><div><p class="vs-eyebrow">Спряжения глагола</p><h2 class="vs-modal-verb" dir="rtl">' + esc(state.verb) + '</h2></div><button class="vs-icon-button" data-action="close">×</button></header>' +
      '<section class="vs-result-workspace"><div class="vs-result-workspace-head"><div><h3>Формы глагола</h3><p>Выберите нужные параметры прямо здесь.</p></div><div class="vs-view-switch"><button class="vs-view-button ' + (state.layout === 'list' ? 'active' : '') + '" data-layout="list">Список</button><button class="vs-view-button ' + (state.layout === 'table' ? 'active' : '') + '" data-layout="table">Таблица</button></div></div>' +
      '<div class="vs-table-controls"><div class="vs-control-row"><span>Время</span><div><button class="vs-filter ' + (state.tense === 'all' ? 'active' : '') + '" data-filter="tense" data-value="all">Все</button><button class="vs-filter ' + (state.tense === 'past' ? 'active' : '') + '" data-filter="tense" data-value="past">الماضي</button><button class="vs-filter ' + (state.tense === 'present' ? 'active' : '') + '" data-filter="tense" data-value="present">المضارع</button><button class="vs-filter ' + (state.tense === 'imperative' ? 'active' : '') + '" data-filter="tense" data-value="imperative">الأمر</button></div></div>' +
      '<div class="vs-control-row"><span>Залог</span><div><button class="vs-filter ' + (state.voice === 'all' ? 'active' : '') + '" data-filter="voice" data-value="all">Все</button><button class="vs-filter ' + (state.voice === 'active' ? 'active' : '') + '" data-filter="voice" data-value="active">Действительный</button><button class="vs-filter ' + (state.voice === 'passive' ? 'active' : '') + '" data-filter="voice" data-value="passive">Страдательный</button></div></div>' +
      '<div class="vs-control-row"><span>Наклонение</span><div><button class="vs-filter ' + (state.mood === 'all' ? 'active' : '') + '" data-filter="mood" data-value="all">Все</button><button class="vs-filter ' + (state.mood === 'plain' ? 'active' : '') + '" data-filter="mood" data-value="plain">Обычное</button><button class="vs-filter ' + (state.mood === 'subjunctive' ? 'active' : '') + '" data-filter="mood" data-value="subjunctive">منصوب</button><button class="vs-filter ' + (state.mood === 'jussive' ? 'active' : '') + '" data-filter="mood" data-value="jussive">مجزوم</button><button class="vs-filter ' + (state.mood === 'emphatic' ? 'active' : '') + '" data-filter="mood" data-value="emphatic">مؤكد</button></div></div></div>' +
      '<div class="vs-help vs-inline-help"><strong>Подсказка</strong><span>Фильтры влияют только на показ форм ниже: их можно менять в любой момент без нового запроса.</span></div><div class="vs-results">' + (groups.length ? groups.map(renderGroup).join('') : '<div class="vs-empty">Для выбранных параметров Qutrub не вернул формы глагола.</div>') + '</div></section></div></div>';
  }
  function patternsModal() {
    return '<div class="vs-modal" role="dialog" aria-modal="true"><div class="vs-modal-sheet"><header class="vs-modal-head"><div><p class="vs-eyebrow">Краткая справка</p><h2>Породы глаголов — الأوزان</h2></div><button class="vs-icon-button" data-action="close">×</button></header><div class="vs-help"><strong>Как читать формулу</strong><span>ف — первая буква корня, ع — вторая, ل — третья. Формула показывает строение породы, а не перевод конкретного слова.</span></div><div class="vs-pattern-list">' + patterns.map(function (item) {
      return '<article class="vs-pattern-card"><div class="vs-pattern-top"><b>Порода ' + item[0] + '</b><strong dir="rtl">' + item[1] + '</strong></div><p>' + item[2] + '</p><div class="vs-pattern-examples">' + item[3].map(function (example) {
        return '<div><span dir="rtl">' + example[0] + '</span><small>' + example[1] + '</small></div>';
      }).join('') + '</div></article>';
    }).join('') + '</div></div></div>';
  }
  function render() {
    var root = document.getElementById(rootId);
    if (!root) return;
    root.innerHTML = '<main class="vs-page"><header class="vs-head"><button class="vs-back" data-action="back">‹</button><div><h1>Спряжение глаголов</h1><p class="vs-sub">Фусха: формы строятся по правилам Qutrub.</p></div></header><section class="vs-card"><label class="vs-label" for="vs-input">Глагол в прошедшем времени</label><div class="vs-search"><input id="vs-input" class="vs-input" value="' + esc(state.verb) + '" placeholder="كَتَبَ" dir="rtl" autocomplete="off"><button class="vs-primary" data-action="conjugate" ' + (state.loading ? 'disabled' : '') + '>' + (state.loading ? 'Строим…' : 'Спрягать') + '</button></div><p class="vs-tip">После нажатия откроются все формы с русским переводом лиц. Внутри можно выбрать время, залог, наклонение и вид.</p></section><section class="vs-card vs-pattern-entry"><div><p class="vs-eyebrow">Справка</p><h2>Породы глаголов</h2><p class="vs-copy">10 моделей фусха: формула, объяснение и два примера с переводом.</p></div><button class="vs-action" data-action="patterns">Открыть породы</button></section></main>' + (state.modal === 'conjugations' ? conjugationModal() : state.modal === 'patterns' ? patternsModal() : '');
    root.querySelectorAll('[data-action]').forEach(function (button) { button.onclick = function () {
      var action = button.dataset.action;
      if (action === 'back') {
        if (window.appNavigateBack) window.appNavigateBack('screen-course');
        else if (window.showScreen) window.showScreen('screen-course');
      }
      if (action === 'conjugate') conjugate();
      if (action === 'patterns') { state.modal = 'patterns'; render(); }
      if (action === 'close') { state.modal = ''; render(); }
    }; });
    root.querySelectorAll('[data-layout]').forEach(function (button) { button.onclick = function () { state.layout = button.dataset.layout; render(); }; });
    root.querySelectorAll('[data-filter]').forEach(function (button) {
      button.onclick = function () {
        state[button.dataset.filter] = button.dataset.value;
        render();
      };
    });
    var input = root.querySelector('#vs-input');
    if (input) input.onkeydown = function (event) { if (event.key === 'Enter') conjugate(); };
  }
  function conjugate() {
    var input = document.getElementById('vs-input');
    state.verb = (input ? input.value : state.verb).trim();
    if (!state.verb) { state.error = 'Введите арабский глагол.'; render(); return; }
    state.loading = true; state.error = ''; state.modal = ''; render();
    fetch(endpoint + '?verb=' + encodeURIComponent(state.verb), { headers: { Accept: 'application/json' } })
      .then(function (response) { if (!response.ok) throw new Error('Qutrub временно недоступен.'); return response.json(); })
      .then(function (data) {
        if (!data || !data.ok || !data.forms) throw new Error('Не удалось построить формы этого глагола.');
        state.forms = data.forms; state.verb = data.verb || state.verb; state.tense = 'all'; state.voice = 'all'; state.mood = 'all'; state.layout = 'list'; state.modal = 'conjugations';
      })
      .catch(function (error) { state.forms = null; state.error = error.message || 'Не удалось построить спряжение.'; })
      .finally(function () { state.loading = false; render(); });
  }
  window.openVerbStudy = function () { if (window.showScreen) window.showScreen(rootId); render(); };
}());
