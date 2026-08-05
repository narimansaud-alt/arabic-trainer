(function () {
  'use strict';

  var rootId = 'screen-verb-study';
  var endpoint = 'https://arabic-trainer-qutrub.narimansaud.workers.dev/conjugate';
  var state = { verb: '', forms: null, loading: false, error: '', modal: '', layout: 'table', tableMode: 'single', tense: 'past', voice: 'active', mood: 'plain' };
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
  function orderPersonRows(rows) {
    var order = ['هُوَ', 'هُمَا', 'هُمْ', 'هِيَ', 'هُمَا', 'هُنَّ', 'أَنْتَ', 'أَنْتُمَا', 'أَنْتُمْ', 'أَنْتِ', 'أَنْتُمَا', 'أَنْتُنَّ', 'أَنَا', 'نَحْنُ'];
    var rest = (rows || []).slice();
    var sorted = [];
    order.forEach(function (pronoun) {
      var target = clean(pronoun);
      var index = rest.findIndex(function (row) { return clean(row.pronoun) === target; });
      if (index >= 0) sorted.push(rest.splice(index, 1)[0]);
    });
    return sorted.concat(rest);
  }
  function groupInfo(name) {
    var value = clean(name);
    if (value.includes('الأمر') && value.includes('المؤكد')) return ['اَلْأَمْرُ الْمُؤَكَّدُ', 'Усиленное повелительное наклонение'];
    if (value.includes('الأمر')) return ['اَلْأَمْرُ', 'Повелительное наклонение'];
    if (value.includes('الماضي') && value.includes('المجهول')) return ['اَلْمَاضِي الْمَبْنِيُّ لِلْمَجْهُولِ', 'Прошедшее время · страдательный залог'];
    if (value.includes('الماضي')) return ['اَلْمَاضِي الْمَبْنِيُّ لِلْمَعْلُومِ', 'Прошедшее время · действительный залог'];
    if (value.includes('المنصوب')) return ['اَلْمُضَارِعُ الْمَنْصُوبُ', 'Настоящее время · сослагательное наклонение'];
    if (value.includes('المجزوم')) return ['اَلْمُضَارِعُ الْمَجْزُومُ', 'Настоящее время · усечённое наклонение'];
    if (value.includes('المؤكد')) return ['اَلْمُضَارِعُ الْمُؤَكَّدُ', 'Настоящее время · усиленное наклонение'];
    if (value.includes('المجهول')) return ['اَلْمُضَارِعُ الْمَبْنِيُّ لِلْمَجْهُولِ', 'Настоящее время · страдательный залог'];
    return ['اَلْمُضَارِعُ الْمَرْفُوعُ الْمَبْنِيُّ لِلْمَعْلُومِ', 'Настоящее время · действительный залог'];
  }  function matches(name) {
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
  function allGroups() {
    if (!state.forms) return [];
    var source = state.forms.all_forms || {};
    var groups = Object.keys(source).map(function (name) {
      var values = source[name] || {};
      return { name: name, rows: orderPersonRows(Object.keys(values).filter(function (key) { return values[key]; }).map(function (key) { return { pronoun: key, form: values[key] }; })) };
    }).filter(function (group) { return group.rows.length; });
    if (!groups.length) {
      [['الماضي المعلوم', state.forms.past], ['المضارع المعلوم', state.forms.present], ['الأمر', state.forms.imperative]].forEach(function (entry) {
        var values = entry[1] || {};
        var rows = orderPersonRows(Object.keys(values).filter(function (key) { return values[key]; }).map(function (key) { return { pronoun: key, form: values[key] }; }));
        if (rows.length) groups.push({ name: entry[0], rows: rows });
      });
    }
    return groups;
  }

  function visibleGroups() {
    return allGroups().filter(function (group) { return matches(group.name); });
  }

  function findFormGroup(kind, voice) {
    var groups = allGroups();
    return groups.filter(function (group) {
      var name = clean(group.name);
      var wantedVoice = voice === 'passive' ? name.includes('المجهول') : !name.includes('المجهول');
      if (!wantedVoice) return false;
      if (kind === 'past') return name.includes('الماضي');
      if (kind === 'present') return name.includes('المضارع') && !name.includes('المنصوب') && !name.includes('المجزوم') && !name.includes('المؤكد');
      return name.includes('الأمر') && !name.includes('المؤكد');
    })[0] || { rows: [] };
  }

  function formFor(group, pronoun) {
    return (group.rows || []).filter(function (row) { return row.pronoun === pronoun; })[0]?.form || '—';
  }

  function generalTable() {
    var past = findFormGroup('past', state.voice);
    var present = findFormGroup('present', state.voice);
    var imperative = state.voice === 'active' ? findFormGroup('imperative', 'active') : { rows: [] };
    var personRows = past.rows.length ? past.rows : present.rows;
    if (!personRows.length) return '<div class="vs-empty">Для выбранного залога Qutrub не вернул базовые формы.</div>';
    return '<section class="vs-result-group vs-general-table"><div class="vs-group-heading"><div><h3>Общая таблица</h3><p>Прошедшее, настоящее и повелительное в одной строке.</p></div><span dir="rtl">الماضي · المضارع · الأمر</span></div><div class="vs-table-wrap"><table class="vs-table"><thead><tr><th>Лицо</th><th>Перевод</th><th>Формы</th></tr></thead><tbody>' +
      personRows.map(function (row) {
        return '<tr><td class="vs-pronoun" dir="rtl">' + esc(row.pronoun) + '</td><td class="vs-person-ru">' + esc(personRu(row.pronoun)) + '</td><td class="vs-general-forms" dir="rtl"><div><small>اَلْمَاضِي</small><b>' + esc(formFor(past, row.pronoun)) + '</b></div><div><small>اَلْمُضَارِعُ</small><b>' + esc(formFor(present, row.pronoun)) + '</b></div><div><small>اَلْأَمْرُ</small><b>' + esc(formFor(imperative, row.pronoun)) + '</b></div></td></tr>';
      }).join('') + '</tbody></table></div></section>';
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
    var resultHtml = state.tableMode === 'general' ? generalTable() : (groups.length ? groups.map(renderGroup).join('') : '<div class="vs-empty">Для выбранных параметров Qutrub не вернул формы глагола.</div>');
    return '<div class="vs-modal" role="dialog" aria-modal="true"><div class="vs-modal-sheet"><header class="vs-modal-head"><div><p class="vs-eyebrow">Спряжения глагола</p><h2 class="vs-modal-verb" dir="rtl">' + esc(state.verb) + '</h2></div><button class="vs-icon-button" data-action="close">×</button></header>' +
      '<section class="vs-result-workspace '+(state.tableMode === 'general' ? 'is-general' : '')+'"><div class="vs-table-kind"><button class="vs-kind-button '+(state.tableMode === 'single' ? 'active' : '')+'" data-table-mode="single">Обычная</button><button class="vs-kind-button '+(state.tableMode === 'general' ? 'active' : '')+'" data-table-mode="general">Общая таблица</button></div><div class="vs-result-workspace-head"><div><h3>Формы глагола</h3><p>Выберите нужные параметры прямо здесь.</p></div><div class="vs-view-switch"><button class="vs-view-button ' + (state.layout === 'list' ? 'active' : '') + '" data-layout="list">Список</button><button class="vs-view-button ' + (state.layout === 'table' ? 'active' : '') + '" data-layout="table">Таблица</button></div></div>' +
      '<div class="vs-table-controls"><div class="vs-control-row"><span>Время</span><div><button class="vs-filter ' + (state.tense === 'all' ? 'active' : '') + '" data-filter="tense" data-value="all">Все</button><button class="vs-filter ' + (state.tense === 'past' ? 'active' : '') + '" data-filter="tense" data-value="past">اَلْمَاضِي</button><button class="vs-filter ' + (state.tense === 'present' ? 'active' : '') + '" data-filter="tense" data-value="present">اَلْمُضَارِعُ</button><button class="vs-filter ' + (state.tense === 'imperative' ? 'active' : '') + '" data-filter="tense" data-value="imperative">اَلْأَمْرُ</button></div></div>' +
      '<div class="vs-control-row"><span>Залог · اَلصِّيغَةُ</span><div><button class="vs-filter ' + (state.voice === 'all' ? 'active' : '') + '" data-filter="voice" data-value="all">Все</button><button class="vs-filter vs-voice-filter ' + (state.voice === 'active' ? 'active' : '') + '" data-filter="voice" data-value="active"><b dir="rtl">اَلْمَبْنِيُّ لِلْمَعْلُومِ</b><small>Действительный залог</small></button><button class="vs-filter vs-voice-filter ' + (state.voice === 'passive' ? 'active' : '') + '" data-filter="voice" data-value="passive"><b dir="rtl">اَلْمَبْنِيُّ لِلْمَجْهُولِ</b><small>Страдательный залог</small></button></div></div>' +
      '<div class="vs-control-row"><span>Наклонение</span><div><button class="vs-filter ' + (state.mood === 'all' ? 'active' : '') + '" data-filter="mood" data-value="all">Все</button><button class="vs-filter ' + (state.mood === 'plain' ? 'active' : '') + '" data-filter="mood" data-value="plain">Обычное</button><button class="vs-filter ' + (state.mood === 'subjunctive' ? 'active' : '') + '" data-filter="mood" data-value="subjunctive">اَلْمَنْصُوبُ</button><button class="vs-filter ' + (state.mood === 'jussive' ? 'active' : '') + '" data-filter="mood" data-value="jussive">اَلْمَجْزُومُ</button><button class="vs-filter ' + (state.mood === 'emphatic' ? 'active' : '') + '" data-filter="mood" data-value="emphatic">اَلْمُؤَكَّدُ</button></div></div></div>' +
      '<div class="vs-help vs-inline-help"><strong>Подсказка</strong><span>Фильтры влияют только на показ форм ниже: их можно менять в любой момент без нового запроса.</span></div><div class="vs-results">' + (groups.length ? groups.map(renderGroup).join('') : '<div class="vs-empty">Для выбранных параметров Qutrub не вернул формы глагола.</div>') + '</div></section></div></div>';
  }
  function bottomFilters() {
    function item(filter, value, arabic, russian, active) {
      return '<button class="vs-bottom-filter ' + (active ? 'active' : '') + '" data-filter="' + filter + '" data-value="' + value + '"><b dir="rtl">' + arabic + '</b><small>' + russian + '</small></button>';
    }
    return '<nav class="vs-bottom-filters" aria-label="Фильтры формы глагола">'
      + item('tense', 'past', 'اَلْمَاضِي', 'Прошедшее', state.tense === 'past')
      + item('tense', 'present', 'اَلْمُضَارِعُ', 'Настоящее', state.tense === 'present' && state.mood === 'plain')
      + item('mood', 'subjunctive', 'اَلْمَنْصُوبُ', 'Сослагательное', state.mood === 'subjunctive')
      + item('mood', 'jussive', 'اَلْمَجْزُومُ', 'Усечённое', state.mood === 'jussive')
      + item('mood', 'emphatic', 'اَلْمُؤَكَّدُ', 'Усиленное', state.mood === 'emphatic')
      + item('tense', 'imperative', 'اَلْأَمْرُ', 'Повелительное', state.tense === 'imperative')
      + '</nav>';
  }
  function patternsConcepts() {
    return '<section class="vs-pattern-concepts" aria-label="Справка по породам и производным формам">'
      + '<article class="vs-pattern-concept vs-pattern-intro"><div class="vs-pattern-concept-kicker">КАК ЧИТАТЬ СПРАВКУ · دَلِيلُ القِرَاءَةِ</div><h3>Сначала порода, затем форма и значение</h3><p>Порода <strong>اَلْوَزْنُ</strong> показывает модель, по которой построен глагол. От неё зависят огласовки, смысловые оттенки и многие производные слова. Ниже каждая тема отделена: сначала правило, затем понятные примеры.</p></article>'
      + '<article class="vs-pattern-concept"><div class="vs-pattern-concept-kicker">ПРАВИЛО 1 · اَلْمَبْنِيُّ لِلْمَعْلُومِ وَالْمَبْنِيُّ لِلْمَجْهُولِ</div><h3>Два залога глагола</h3><div class="vs-contrast"><div><strong lang="ar" dir="rtl">اَلْمَبْنِيُّ لِلْمَعْلُومِ</strong><b>Действительный залог</b><p>Исполнитель действия назван и стоит в роли подлежащего.</p><span lang="ar" dir="rtl">كَتَبَ الطَّالِبُ الدَّرْسَ</span><small>Студент написал урок.</small></div><div><strong lang="ar" dir="rtl">اَلْمَبْنِيُّ لِلْمَجْهُولِ</strong><b>Страдательный залог</b><p>Важен предмет или результат, а исполнитель не называется.</p><span lang="ar" dir="rtl">كُتِبَ الدَّرْسُ</span><small>Урок был написан.</small></div></div><p class="vs-pattern-explain">В страдательном залоге меняются огласовки глагола, а бывший объект действия становится подлежащим. Например: <span lang="ar" dir="rtl">فَتَحَ الرَّجُلُ الْبَابَ</span> — «мужчина открыл дверь»; <span lang="ar" dir="rtl">فُتِحَ الْبَابُ</span> — «дверь была открыта».</p></article>'
      + '<article class="vs-pattern-concept"><div class="vs-pattern-concept-kicker">ПРАВИЛО 2 · اَلْمَصْدَرُ</div><h3>Масдар: название действия</h3><p><strong lang="ar" dir="rtl">اَلْمَصْدَرُ</strong> — это отглагольное существительное: оно не указывает ни на время, ни на лицо, а называет само действие.</p><div class="vs-example-pairs"><div><span lang="ar" dir="rtl">كَتَبَ — كِتَابَةً</span><small>писать — письмо, писание</small></div><div><span lang="ar" dir="rtl">تَعَلَّمَ — تَعَلُّمًا</span><small>учиться — обучение</small></div></div><p class="vs-pattern-explain">У I породы масдар часто нужно узнавать из словаря: моделей несколько. У производных пород он обычно строится по устойчивой модели, которая указана в сводной таблице внизу.</p></article>'
      + '<article class="vs-pattern-concept"><div class="vs-pattern-concept-kicker">ПРАВИЛО 3 · اَلْمُشْتَقَّاتُ</div><h3>Производные формы от глагола</h3><p>От глагола могут образовываться слова для деятеля, объекта, места, инструмента и качества. Они помогают узнавать смысл слова по его строению.</p><div class="vs-derived-grid"><div><strong lang="ar" dir="rtl">اِسْمُ الْفَاعِلِ</strong><b>Действительное причастие</b><span><em lang="ar" dir="rtl">كَاتِبٌ</em> — пишущий, автор.</span></div><div><strong lang="ar" dir="rtl">اِسْمُ الْمَفْعُولِ</strong><b>Страдательное причастие</b><span><em lang="ar" dir="rtl">مَكْتُوبٌ</em> — написанный.</span></div><div><strong lang="ar" dir="rtl">اِسْمُ الزَّمَانِ وَالْمَكَانِ</strong><b>Время или место действия</b><span><em lang="ar" dir="rtl">مَكْتَبٌ</em> — место письма, кабинет.</span></div><div><strong lang="ar" dir="rtl">اِسْمُ الْآلَةِ</strong><b>Инструмент действия</b><span><em lang="ar" dir="rtl">مِفْتَاحٌ</em> — ключ, то, чем открывают.</span></div><div><strong lang="ar" dir="rtl">الصِّفَةُ الْمُشَبَّهَةُ</strong><b>Постоянное качество</b><span><em lang="ar" dir="rtl">كَبِيرٌ</em> — большой.</span></div><div><strong lang="ar" dir="rtl">اِسْمُ التَّفْضِيلِ</strong><b>Сравнительная степень</b><span><em lang="ar" dir="rtl">أَكْبَرُ</em> — больше, самый большой.</span></div></div><p class="vs-pattern-explain">Не каждая форма образуется от любого глагола. Таблица показывает модели, но точное значение и употребление всегда проверяются по словарю.</p></article>'
      + '<div class="vs-matrix-divider"><span>СВОДНАЯ ТАБЛИЦА · جَدْوَلُ الأَوْزَانِ</span><strong>Породы I–X: основные модели</strong><small>Таблица служит справочником и прокручивается по горизонтали.</small></div>'
      + '</section>';
  }
  function patternsMatrix() {
    return patternsConcepts() + patternsMatrixTable();
  }

  function patternsMatrixTable() {
    var rows = [
      ['I','فَعَلَ','يَفْعَلُ','فَاعِل','مَفْعُول','فُعِلَ','يُفْعَلُ','مَصْدَرٌ مُتَنَوِّع','اِفْعَلْ','لَا تَفْعَلْ'],
      ['II','فَعَّلَ','يُفَعِّلُ','مُفَعِّل','مُفَعَّل','فُعِّلَ','يُفَعَّلُ','تَفْعِيل','فَعِّلْ','لَا تُفَعِّلْ'],
      ['III','فَاعَلَ','يُفَاعِلُ','مُفَاعِل','مُفَاعَل','فُوعِلَ','يُفَاعَلُ','مُفَاعَلَة','فَاعِلْ','لَا تُفَاعِلْ'],
      ['IV','أَفْعَلَ','يُفْعِلُ','مُفْعِل','مُفْعَل','أُفْعِلَ','يُفْعَلُ','إِفْعَال','أَفْعِلْ','لَا تُفْعِلْ'],
      ['V','تَفَعَّلَ','يَتَفَعَّلُ','مُتَفَعِّل','مُتَفَعَّل','تُفُعِّلَ','يُتَفَعَّلُ','تَفَعُّل','تَفَعَّلْ','لَا تَتَفَعَّلْ'],
      ['VI','تَفَاعَلَ','يَتَفَاعَلُ','مُتَفَاعِل','مُتَفَاعَل','تُفُوعِلَ','يُتَفَاعَلُ','تَفَاعُل','تَفَاعَلْ','لَا تَتَفَاعَلْ'],
      ['VII','اِنْفَعَلَ','يَنْفَعِلُ','مُنْفَعِل','—','اُنْفُعِلَ','يُنْفَعَلُ','اِنْفِعَال','اِنْفَعِلْ','لَا تَنْفَعِلْ'],
      ['VIII','اِفْتَعَلَ','يَفْتَعِلُ','مُفْتَعِل','مُفْتَعَل','اُفْتُعِلَ','يُفْتَعَلُ','اِفْتِعَال','اِفْتَعِلْ','لَا تَفْتَعِلْ'],
      ['IX','اِفْعَلَّ','يَفْعَلُّ','مُفْعَلّ','—','—','—','اِفْعِلَال','—','—'],
      ['X','اِسْتَفْعَلَ','يَسْتَفْعِلُ','مُسْتَفْعِل','مُسْتَفْعَل','اُسْتُفْعِلَ','يُسْتَفْعَلُ','اِسْتِفْعَال','اِسْتَفْعِلْ','لَا تَسْتَفْعِلْ']
    ];
    var headings = ['Порода|اَلْوَزْنُ','Прошедшее|اَلْمَاضِي','Настоящее|اَلْمُضَارِعُ','Действ. причастие|اِسْمُ الْفَاعِلِ','Страд. причастие|اِسْمُ الْمَفْعُولِ','Страд. прошедшее|اَلْمَاضِي لِلْمَجْهُولِ','Страд. настоящее|اَلْمُضَارِعُ لِلْمَجْهُولِ','Масдар|اَلْمَصْدَرُ','Повелительное|اَلْأَمْرُ','Запрет|اَلنَّهْيُ'];
    return '<section class="vs-pattern-matrix"><h3><span dir="rtl">جَدْوَلُ الأَوْزَانِ</span><small>Общая таблица пород</small></h3><p>Формулы для ориентира. У I породы масдар и гласная настоящего времени уточняются по словарю.</p><div class="vs-pattern-matrix-wrap"><table><thead><tr>' + headings.map(function (heading) { var parts = heading.split('|'); return '<th><span>' + parts[0] + '</span><b dir="rtl">' + parts[1] + '</b></th>'; }).join('') + '</tr></thead><tbody>' + rows.map(function (row) { return '<tr>' + row.map(function (cell, index) { return '<td class="' + (index === 0 ? 'vs-pattern-number' : '') + '" dir="' + (index ? 'rtl' : 'ltr') + '">' + cell + '</td>'; }).join('') + '</tr>'; }).join('') + '</tbody></table></div></section>';
  }
  function patternTitle(number) {
    var titles = {
      I: ['اَلْبَابُ الْأَوَّلُ', 'I порода — основная трёхбуквенная'],
      II: ['اَلْبَابُ الثَّانِي', 'II порода — усиление или побуждение'],
      III: ['اَلْبَابُ الثَّالِثُ', 'III порода — взаимодействие'],
      IV: ['اَلْبَابُ الرَّابِعُ', 'IV порода — побуждение к действию'],
      V: ['اَلْبَابُ الْخَامِسُ', 'V порода — возвратное значение'],
      VI: ['اَلْبَابُ السَّادِسُ', 'VI порода — взаимное действие'],
      VII: ['اَلْبَابُ السَّابِعُ', 'VII порода — результат действия'],
      VIII: ['اَلْبَابُ الثَّامِنُ', 'VIII порода — участие субъекта'],
      IX: ['اَلْبَابُ التَّاسِعُ', 'IX порода — цвета и качества'],
      X: ['اَلْبَابُ الْعَاشِرُ', 'X порода — поиск или просьба']
    };
    return titles[number] || ['اَلْوَزْنُ', 'Порода глагола'];
  }
  function patternsModal() {
    return '<div class="vs-modal" role="dialog" aria-modal="true"><div class="vs-modal-sheet"><header class="vs-modal-head"><div><p class="vs-eyebrow">Краткая справка</p><h2>Породы глаголов — الأوزان</h2></div><button class="vs-icon-button" data-action="close">×</button></header><div class="vs-help"><strong>Как читать формулу</strong><span>ف — первая буква корня, ع — вторая, ل — третья. Формула показывает строение породы, а не перевод конкретного слова.</span></div><div class="vs-pattern-list">' + patterns.map(function (item) {
      var title = patternTitle(item[0]);
      return '<article class="vs-pattern-card"><div class="vs-pattern-top"><div><b dir="rtl">' + title[0] + '</b><small>' + title[1] + '</small></div><strong dir="rtl">' + item[1] + '</strong></div><p>' + item[2] + '</p><div class="vs-pattern-examples">' + item[3].map(function (example) {
        return '<div><span dir="rtl">' + example[0] + '</span><small>' + example[1] + '</small></div>';
      }).join('') + '</div></article>';
    }).join('') + '</div>' + patternsMatrix() + '</div></div>';
  }
  function render() {
    var root = document.getElementById(rootId);
    if (!root) return;
    root.innerHTML = '<main class="vs-page"><header class="vs-head"><button class="vs-back" data-action="back">‹</button><div><h1>Спряжение глаголов</h1><p class="vs-sub">Фусха: формы строятся по правилам Qutrub.</p></div></header><section class="vs-card"><label class="vs-label" for="vs-input">Глагол в прошедшем времени</label><div class="vs-search"><input id="vs-input" class="vs-input" value="' + esc(state.verb) + '" placeholder="كَتَبَ" dir="rtl" autocomplete="off"><button class="vs-primary" data-action="conjugate" ' + (state.loading ? 'disabled' : '') + '>' + (state.loading ? 'Строим…' : 'Спрягать') + '</button></div><p class="vs-tip">После нажатия откроются все формы с русским переводом лиц. Внутри можно выбрать время, залог, наклонение и вид.</p></section><section class="vs-card vs-pattern-entry"><div><p class="vs-eyebrow">Справка</p><h2>Породы глаголов</h2><p class="vs-copy">10 моделей фусха: формула, объяснение и два примера с переводом.</p></div><button class="vs-action" data-action="patterns">Открыть породы</button></section></main>' + (state.modal === 'conjugations' ? conjugationModal() : state.modal === 'patterns' ? patternsModal() : '');
    var resultWorkspace = root.querySelector('.vs-result-workspace');
    if (resultWorkspace) resultWorkspace.insertAdjacentHTML('beforeend', bottomFilters());
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
    root.querySelectorAll('[data-table-mode]').forEach(function (button) { button.onclick = function () { state.tableMode = button.dataset.tableMode; render(); }; });
    root.querySelectorAll('[data-filter]').forEach(function (button) {
      button.onclick = function () {
        state[button.dataset.filter] = button.dataset.value;
        if (button.dataset.filter === 'tense') state.mood = 'plain';
        if (button.dataset.filter === 'mood' && button.dataset.value !== 'plain') state.tense = 'present';
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
        state.forms = data.forms; state.verb = data.verb || state.verb; state.tableMode = 'single'; state.tense = 'past'; state.voice = 'active'; state.mood = 'plain'; state.layout = 'table'; state.modal = 'conjugations';
      })
      .catch(function (error) { state.forms = null; state.error = error.message || 'Не удалось построить спряжение.'; })
      .finally(function () { state.loading = false; render(); });
  }
  window.openVerbStudy = function () { if (window.showScreen) window.showScreen(rootId); render(); };
}());
