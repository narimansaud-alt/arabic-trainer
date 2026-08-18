// training-setup.js — mode-specific lesson and quantity selection.
// Ordinary modes use the active volume. Fast review can combine lessons
// from every Medina volume without changing App.volume or the open dictionary.

const TRAINING_SETUP_STORAGE_VERSION = 2;
const TRAINING_SETUP_STORAGE_PREFIX = 'arabic_training_setup_v2:';
const TRAINING_STANDARD_MODES = ['learn', 'type-ar', 'review', 'mix'];
const TRAINING_MODE_META = {
  learn: {
    title: 'Учить новые слова',
    note: 'Выберите уроки текущего тома и количество слов для изучения.',
  },
  'type-ar': {
    title: 'Арабский ввод',
    note: 'Выберите уроки текущего тома и количество письменных заданий.',
  },
  review: {
    title: 'Обычное повторение',
    note: 'Все слова выбранных уроков доступны для повторения, даже если срок ещё не наступил.',
  },
  mix: {
    title: 'Микс',
    note: 'В одной тренировке чередуются вопросы, варианты ответа и арабский ввод.',
  },
  fast: {
    title: 'Быстрое повторение',
    note: 'Можно объединить любые уроки из всех четырёх томов. На ответ даётся 7 секунд.',
  },
};

const TrainingSetup = {
  pageOpen: false,
  loadedFor: null,
  normalSelections: {},
  fastSelections: {},
  quantities: {},
  fastCatalog: {},
  fastCatalogLoaded: false,
  fastCatalogLoading: null,
  fastCatalogError: '',
  openFastVolumes: new Set(),
  starting: false,
};

function trainingSetupStorageKey() {
  return TRAINING_SETUP_STORAGE_PREFIX + String(App.username || 'guest');
}

function trainingVolumeIds() {
  return (VOLUMES.med || []).map((volume) => volume.id);
}

function trainingVolumeLabel(volumeId) {
  return findVolumeById(volumeId)?.label || String(volumeId || 'Том');
}

function normalizeTrainingLessons(value) {
  if (!Array.isArray(value)) return [];
  return [...new Set(value.map((lesson) => String(lesson)).filter((lesson) => /^\d+(?:\.\d+)?$/u.test(lesson)))].sort(sortTrainingLessons);
}

function sortTrainingLessons(a, b) {
  const an = Number(a);
  const bn = Number(b);
  if (Number.isFinite(an) && Number.isFinite(bn)) return an - bn;
  return String(a).localeCompare(String(b), 'ru');
}

function normalizeTrainingQuantity(value, fallback) {
  if (value === 'all') return 'all';
  const number = Math.floor(Number(value));
  return Number.isFinite(number) && number > 0 ? Math.min(number, 10000) : fallback;
}

function loadTrainingSetupPreferences() {
  const owner = String(App.username || 'guest');
  if (TrainingSetup.loadedFor === owner) return;

  TrainingSetup.loadedFor = owner;
  TrainingSetup.normalSelections = {};
  TrainingSetup.fastSelections = {};
  TrainingSetup.quantities = {
    learn: normalizeTrainingQuantity(Settings.qtyNormal, 15),
    'type-ar': normalizeTrainingQuantity(Settings.qtyNormal, 15),
    review: normalizeTrainingQuantity(Settings.qtyNormal, 15),
    mix: normalizeTrainingQuantity(Settings.qtyNormal, 15),
    fast: Settings.qtyFast === 'inf' ? 'all' : normalizeTrainingQuantity(Settings.qtyFast, 50),
  };
  TrainingSetup.openFastVolumes = new Set(App.volume ? [App.volume] : []);

  try {
    const saved = JSON.parse(localStorage.getItem(trainingSetupStorageKey()) || 'null');
    if (!saved || Number(saved.version) !== TRAINING_SETUP_STORAGE_VERSION) return;
    const validVolumes = new Set(trainingVolumeIds());

    Object.entries(saved.normalSelections || {}).forEach(([volumeId, modes]) => {
      if (!validVolumes.has(volumeId) || !modes || typeof modes !== 'object') return;
      TrainingSetup.normalSelections[volumeId] = {};
      TRAINING_STANDARD_MODES.forEach((mode) => {
        TrainingSetup.normalSelections[volumeId][mode] = normalizeTrainingLessons(modes[mode]);
      });
    });
    Object.entries(saved.fastSelections || {}).forEach(([volumeId, lessons]) => {
      if (validVolumes.has(volumeId)) TrainingSetup.fastSelections[volumeId] = normalizeTrainingLessons(lessons);
    });
    Object.keys(TRAINING_MODE_META).forEach((mode) => {
      TrainingSetup.quantities[mode] = normalizeTrainingQuantity(saved.quantities?.[mode], TrainingSetup.quantities[mode]);
    });
  } catch (error) {
    ErrorLog.capture(error, { source: 'training-setup', action: 'load-preferences' });
  }
}

function saveTrainingSetupPreferences() {
  loadTrainingSetupPreferences();
  try {
    localStorage.setItem(
      trainingSetupStorageKey(),
      JSON.stringify({
        version: TRAINING_SETUP_STORAGE_VERSION,
        normalSelections: TrainingSetup.normalSelections,
        fastSelections: TrainingSetup.fastSelections,
        quantities: TrainingSetup.quantities,
      })
    );
  } catch (error) {
    ErrorLog.capture(error, { source: 'training-setup', action: 'save-preferences' });
  }
}

function trainingWordFromRow(row, fallbackVolume) {
  return {
    id: row.id == null ? null : row.id,
    ar: String(row.word_ar || row.ar || ''),
    ru: String(row.word_ru || row.ru || ''),
    lesson: String(row.lesson_number ?? row.lesson ?? ''),
    volume: String(row.course_name || row.volume || fallbackVolume || ''),
    dictionaryRow: row.dictionary_row == null ? row.dictionaryRow ?? null : Number(row.dictionary_row),
    dictionaryForm: row.dictionary_form || row.dictionaryForm || '',
  };
}

async function fetchTrainingVolumeWords(volumeId) {
  const pageSize = 1000;
  const rows = [];
  for (let offset = 0; offset < 20000; offset += pageSize) {
    const result = await db
      .from('words')
      .select('*')
      .eq('course_name', volumeId)
      .order('lesson_number', { ascending: true })
      .order('id', { ascending: true })
      .range(offset, offset + pageSize - 1);
    if (result?.error) throw result.error;
    const page = Array.isArray(result?.data) ? result.data : [];
    rows.push(...page);
    if (page.length < pageSize) break;
  }
  return rows.map((row) => trainingWordFromRow(row, volumeId)).filter((word) => word.ar && word.ru && word.lesson);
}

function buildTrainingVolumeCatalog(words) {
  const byLesson = {};
  words.forEach((word) => {
    if (!byLesson[word.lesson]) byLesson[word.lesson] = [];
    byLesson[word.lesson].push(word);
  });
  return { allWords: words, byLesson };
}

async function ensureFastTrainingCatalog(force = false) {
  loadTrainingSetupPreferences();
  if (TrainingSetup.fastCatalogLoaded && !force) return TrainingSetup.fastCatalog;
  if (TrainingSetup.fastCatalogLoading && !force) return TrainingSetup.fastCatalogLoading;

  TrainingSetup.fastCatalogError = '';
  TrainingSetup.fastCatalogLoaded = false;
  TrainingSetup.fastCatalogLoading = (async () => {
    try {
      const volumeIds = trainingVolumeIds();
      const results = await Promise.all(volumeIds.map(async (volumeId) => [volumeId, await fetchTrainingVolumeWords(volumeId)]));
      TrainingSetup.fastCatalog = Object.fromEntries(results.map(([volumeId, words]) => [volumeId, buildTrainingVolumeCatalog(words)]));
      TrainingSetup.fastCatalogLoaded = true;
      TrainingSetup.fastCatalogError = '';
      return TrainingSetup.fastCatalog;
    } catch (error) {
      TrainingSetup.fastCatalog = {};
      TrainingSetup.fastCatalogLoaded = false;
      TrainingSetup.fastCatalogError = 'Не удалось загрузить словари всех томов. Проверьте интернет и повторите.';
      ErrorLog.capture(error, { source: 'training-setup', action: 'load-fast-catalog' });
      return null;
    } finally {
      TrainingSetup.fastCatalogLoading = null;
      renderTrainingModeSetup();
    }
  })();
  renderTrainingModeSetup();
  return TrainingSetup.fastCatalogLoading;
}

function normalTrainingSelection(mode = Settings.mode, volumeId = App.volume) {
  loadTrainingSetupPreferences();
  if (!TrainingSetup.normalSelections[volumeId]) TrainingSetup.normalSelections[volumeId] = {};
  if (!Array.isArray(TrainingSetup.normalSelections[volumeId][mode])) TrainingSetup.normalSelections[volumeId][mode] = [];
  return TrainingSetup.normalSelections[volumeId][mode];
}

function fastTrainingSelection(volumeId) {
  loadTrainingSetupPreferences();
  if (!Array.isArray(TrainingSetup.fastSelections[volumeId])) TrainingSetup.fastSelections[volumeId] = [];
  return TrainingSetup.fastSelections[volumeId];
}

function uniqueTrainingWordList(words) {
  const seen = new Set();
  return words.filter((word) => {
    const arabic = typeof rmH === 'function' ? rmH(word.ar) : word.ar;
    const key = `${arabic}|${String(word.ru || '').trim().toLowerCase()}`;
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
}

function getTrainingSelectedWords(mode = Settings.mode) {
  loadTrainingSetupPreferences();
  if (mode === 'fast') {
    const words = [];
    trainingVolumeIds().forEach((volumeId) => {
      const catalog = TrainingSetup.fastCatalog[volumeId];
      const lessons = fastTrainingSelection(volumeId);
      lessons.forEach((lesson) => {
        if (catalog?.byLesson?.[lesson]) words.push(...catalog.byLesson[lesson]);
      });
    });
    return uniqueTrainingWordList(words);
  }

  const words = [];
  normalTrainingSelection(mode, App.volume).forEach((lesson) => {
    if (Dict.byLesson[lesson]) words.push(...Dict.byLesson[lesson]);
  });
  return words;
}

function getTrainingSelectedLessonCount(mode = Settings.mode) {
  if (mode === 'fast') {
    return trainingVolumeIds().reduce((sum, volumeId) => {
      const valid = new Set(Object.keys(TrainingSetup.fastCatalog[volumeId]?.byLesson || {}));
      return sum + fastTrainingSelection(volumeId).filter((lesson) => valid.has(lesson)).length;
    }, 0);
  }
  const valid = new Set(Object.keys(Dict.byLesson || {}));
  return normalTrainingSelection(mode, App.volume).filter((lesson) => valid.has(lesson)).length;
}

function getTrainingModeLimit(mode, availableWords) {
  loadTrainingSetupPreferences();
  const available = Math.max(0, Number(availableWords) || 0);
  if (!available) return 0;
  const setting = TrainingSetup.quantities[mode];
  if (setting === 'all') return available;
  return Math.max(1, Math.min(available, Number(setting) || (mode === 'fast' ? 50 : 15)));
}

function toggleTrainingLesson(button) {
  const mode = button?.dataset?.mode || Settings.mode;
  const volumeId = button?.dataset?.volume || App.volume;
  const lesson = String(button?.dataset?.lesson || '');
  if (!lesson) return;
  const selection = mode === 'fast' ? fastTrainingSelection(volumeId) : normalTrainingSelection(mode, volumeId);
  const next = selection.includes(lesson) ? selection.filter((item) => item !== lesson) : [...selection, lesson].sort(sortTrainingLessons);
  if (mode === 'fast') TrainingSetup.fastSelections[volumeId] = next;
  else TrainingSetup.normalSelections[volumeId][mode] = next;
  saveTrainingSetupPreferences();
  renderTrainingModeSetup();
}

function setCurrentModeLessons(selectAll) {
  const mode = Settings.mode;
  if (mode === 'fast') return setAllFastTrainingLessons(selectAll);
  TrainingSetup.normalSelections[App.volume] ||= {};
  TrainingSetup.normalSelections[App.volume][mode] = selectAll ? Object.keys(Dict.byLesson || {}).sort(sortTrainingLessons) : [];
  saveTrainingSetupPreferences();
  renderTrainingModeSetup();
}

function setFastVolumeSelection(button, selectAll) {
  const volumeId = button?.dataset?.volume;
  if (!volumeId) return;
  TrainingSetup.fastSelections[volumeId] = selectAll
    ? Object.keys(TrainingSetup.fastCatalog[volumeId]?.byLesson || {}).sort(sortTrainingLessons)
    : [];
  saveTrainingSetupPreferences();
  renderTrainingModeSetup();
}

function setAllFastTrainingLessons(selectAll) {
  trainingVolumeIds().forEach((volumeId) => {
    TrainingSetup.fastSelections[volumeId] = selectAll
      ? Object.keys(TrainingSetup.fastCatalog[volumeId]?.byLesson || {}).sort(sortTrainingLessons)
      : [];
  });
  saveTrainingSetupPreferences();
  renderTrainingModeSetup();
}

function toggleFastTrainingVolume(button) {
  const volumeId = button?.dataset?.volume;
  if (!volumeId) return;
  if (TrainingSetup.openFastVolumes.has(volumeId)) TrainingSetup.openFastVolumes.delete(volumeId);
  else TrainingSetup.openFastVolumes.add(volumeId);
  renderTrainingModeSetup();
}

function setModeQuantity(value) {
  const mode = Settings.mode;
  const selectedWords = getTrainingSelectedWords(mode).length;
  if (!selectedWords) return;
  const number = Math.max(1, Math.min(selectedWords, Math.floor(Number(value) || 1)));
  TrainingSetup.quantities[mode] = number >= selectedWords ? 'all' : number;
  if (mode === 'fast') Settings.qtyFast = TrainingSetup.quantities[mode] === 'all' ? 'inf' : number;
  else Settings.qtyNormal = TrainingSetup.quantities[mode] === 'all' ? 'all' : number;
  saveTrainingSetupPreferences();
  updateTrainingQuantityView();
}

function setModeQuantityPreset(value) {
  const selectedWords = getTrainingSelectedWords(Settings.mode).length;
  if (!selectedWords) return;
  if (value === 'all') TrainingSetup.quantities[Settings.mode] = 'all';
  else {
    const number = Math.max(1, Math.min(selectedWords, Math.floor(Number(value) || 1)));
    TrainingSetup.quantities[Settings.mode] = number >= selectedWords ? 'all' : number;
  }
  saveTrainingSetupPreferences();
  renderTrainingModeSetup();
}

function updateTrainingQuantityView() {
  const mode = Settings.mode;
  const words = getTrainingSelectedWords(mode).length;
  const lessons = getTrainingSelectedLessonCount(mode);
  const slider = document.getElementById('mode-quantity-range');
  const valueEl = document.getElementById('mode-quantity-value');
  const maxEl = document.getElementById('mode-quantity-max');
  const summaryEl = document.getElementById('mode-selection-summary');
  const limit = getTrainingModeLimit(mode, words);
  const all = words > 0 && TrainingSetup.quantities[mode] === 'all';

  if (slider) {
    slider.max = String(Math.max(1, words));
    slider.value = String(Math.max(1, limit || 1));
    slider.disabled = !words;
    slider.setAttribute('aria-valuetext', all ? `Все, ${words} слов` : `${limit} слов`);
  }
  if (valueEl) valueEl.textContent = words ? (all ? `Все · ${words}` : `${limit}`) : '—';
  if (maxEl) maxEl.textContent = words ? `Всего доступно: ${words}` : 'Нет выбранных слов';
  if (summaryEl) {
    summaryEl.textContent = lessons
      ? `Выбрано: ${lessons} ${getRussianCountLabel(lessons, 'урок', 'урока', 'уроков')} · ${words} ${getRussianCountLabel(words, 'слово', 'слова', 'слов')}`
      : 'Сначала выберите хотя бы один урок.';
  }
  updateTrainingStartButtons(words);
}

function getRussianCountLabel(number, one, few, many) {
  const value = Math.abs(Number(number) || 0) % 100;
  const last = value % 10;
  if (value > 10 && value < 20) return many;
  if (last === 1) return one;
  if (last >= 2 && last <= 4) return few;
  return many;
}

function updateTrainingStartButtons(selectedWords = getTrainingSelectedWords(Settings.mode).length) {
  const unavailable = TrainingSetup.starting || !selectedWords || (Settings.mode === 'fast' && !TrainingSetup.fastCatalogLoaded);
  const start = document.getElementById('btn-start');
  const favorite = document.getElementById('btn-fav');
  if (start) {
    start.disabled = unavailable;
    const label = TrainingSetup.starting ? 'Подготовка...' : Settings.mode === 'fast' ? 'Начать быстрое повторение' : 'Начать тренировку';
    const icon = Settings.mode === 'fast' ? 'bolt' : 'play';
    if (typeof setIconLabel === 'function') setIconLabel(start, icon, label);
    else start.textContent = label;
  }
  if (favorite) {
    const difficult = new Set(Array.isArray(App.favorites) ? App.favorites : []);
    const difficultCount = getTrainingSelectedWords(Settings.mode).filter((word) => difficult.has(word.ar)).length;
    favorite.disabled = unavailable || !difficultCount;
    favorite.textContent = difficultCount ? `Только трудные слова · ${difficultCount}` : 'Трудных слов в выбранных уроках нет';
    favorite.setAttribute('aria-label', difficultCount ? `Начать тренировку: только трудные слова, ${difficultCount}` : 'В выбранных уроках нет трудных слов');
    favorite.title = difficultCount ? `Будут использованы только трудные слова из выбранных уроков: ${difficultCount}` : 'Добавьте слова звёздочкой или выберите уроки, где уже есть трудные слова';
  }
}

function setTrainingStartBusy(busy) {
  TrainingSetup.starting = Boolean(busy);
  updateTrainingStartButtons();
}

function renderTrainingLessonButtons(mode, volumeId, byLesson, selected) {
  return Object.keys(byLesson || {})
    .sort(sortTrainingLessons)
    .map((lesson) => {
      const active = selected.includes(lesson);
      const count = byLesson[lesson]?.length || 0;
      return `<button class="lesson-pill training-lesson-pill${active ? ' active' : ''}" type="button" data-mode="${esc(mode)}" data-volume="${esc(volumeId)}" data-lesson="${esc(lesson)}" aria-pressed="${active}" onclick="toggleTrainingLesson(this)"><span>Урок ${esc(lesson)}</span><small>${count} сл.</small></button>`;
    })
    .join('');
}

function renderNormalTrainingPicker(mode) {
  const lessons = Object.keys(Dict.byLesson || {}).sort(sortTrainingLessons);
  if (!lessons.length) return '<div class="training-empty">Слова текущего тома ещё загружаются.</div>';
  const selected = normalTrainingSelection(mode, App.volume);
  return `
    <div class="training-picker-toolbar">
      <span class="training-current-volume">${esc(trainingVolumeLabel(App.volume))}</span>
      <div class="training-picker-actions">
        <button type="button" onclick="setCurrentModeLessons(true)">Выбрать все</button>
        <button type="button" onclick="setCurrentModeLessons(false)">Снять все</button>
      </div>
    </div>
    <div class="lesson-grid training-lesson-grid">${renderTrainingLessonButtons(mode, App.volume, Dict.byLesson, selected)}</div>`;
}

function renderFastTrainingPicker() {
  if (!TrainingSetup.fastCatalogLoaded) {
    const message = TrainingSetup.fastCatalogError || 'Загружаю уроки всех четырёх томов…';
    return `<div class="training-empty${TrainingSetup.fastCatalogError ? ' is-error' : ''}">${esc(message)}${TrainingSetup.fastCatalogError ? '<button type="button" onclick="ensureFastTrainingCatalog(true)">Повторить</button>' : ''}</div>`;
  }

  const volumeCards = (VOLUMES.med || [])
    .map((volume) => {
      const byLesson = TrainingSetup.fastCatalog[volume.id]?.byLesson || {};
      const lessons = Object.keys(byLesson).sort(sortTrainingLessons);
      const selected = fastTrainingSelection(volume.id);
      const valid = new Set(lessons);
      const selectedCount = selected.filter((lesson) => valid.has(lesson)).length;
      const wordCount = lessons.reduce((sum, lesson) => sum + (byLesson[lesson]?.length || 0), 0);
      const isOpen = TrainingSetup.openFastVolumes.has(volume.id);
      return `
        <section class="fast-volume-picker${isOpen ? ' is-open' : ''}">
          <button class="fast-volume-toggle" type="button" data-volume="${esc(volume.id)}" aria-expanded="${isOpen}" onclick="toggleFastTrainingVolume(this)">
            <span><b>${esc(volume.label)}</b><small>${selectedCount} из ${lessons.length} уроков · ${wordCount} слов</small></span>
            <span class="fast-volume-chevron" aria-hidden="true">⌄</span>
          </button>
          <div class="fast-volume-lessons${isOpen ? '' : ' hidden'}">
            <div class="training-picker-actions fast-volume-actions">
              <button type="button" data-volume="${esc(volume.id)}" onclick="setFastVolumeSelection(this,true)"${lessons.length ? '' : ' disabled'}>Весь том</button>
              <button type="button" data-volume="${esc(volume.id)}" onclick="setFastVolumeSelection(this,false)"${selectedCount ? '' : ' disabled'}>Снять</button>
            </div>
            ${lessons.length ? `<div class="lesson-grid training-lesson-grid">${renderTrainingLessonButtons('fast', volume.id, byLesson, selected)}</div>` : '<div class="training-empty compact">В этом томе пока нет слов.</div>'}
          </div>
        </section>`;
    })
    .join('');

  return `
    <div class="training-picker-toolbar fast-picker-toolbar">
      <span class="training-current-volume">Все тома</span>
      <div class="training-picker-actions">
        <button type="button" onclick="setAllFastTrainingLessons(true)">Выбрать все</button>
        <button type="button" onclick="setAllFastTrainingLessons(false)">Снять все</button>
      </div>
    </div>
    <div class="fast-volume-list">${volumeCards}</div>`;
}

function renderTrainingQuantity() {
  const words = getTrainingSelectedWords(Settings.mode).length;
  const limit = getTrainingModeLimit(Settings.mode, words);
  const all = words > 0 && TrainingSetup.quantities[Settings.mode] === 'all';
  const presets = [10, 25, 50]
    .map((value) => `<button type="button" onclick="setModeQuantityPreset(${value})"${!words ? ' disabled' : ''}>${value}</button>`)
    .join('');
  return `
    <div class="training-quantity">
      <div class="training-quantity-head"><label for="mode-quantity-range">Количество слов</label><strong id="mode-quantity-value">${words ? (all ? `Все · ${words}` : limit) : '—'}</strong></div>
      <input id="mode-quantity-range" type="range" min="1" max="${Math.max(1, words)}" step="1" value="${Math.max(1, limit || 1)}" ${words ? '' : 'disabled'} oninput="setModeQuantity(this.value)">
      <div class="training-quantity-scale"><span>1</span><span id="mode-quantity-max">${words ? `Всего доступно: ${words}` : 'Нет выбранных слов'}</span></div>
      <div class="training-quantity-presets" aria-label="Быстрый выбор количества">${presets}<button type="button" onclick="setModeQuantityPreset('all')"${!words ? ' disabled' : ''}>Все</button></div>
    </div>`;
}

function openTrainingModeSetup() {
  TrainingSetup.pageOpen = true;
  const tab = document.getElementById('tab-train');
  if (tab) {
    tab.classList.add('training-mode-page-open');
    tab.scrollTop = 0;
  }
  renderTrainingModeSetup();
  if (typeof window?.scrollTo === 'function') window.scrollTo(0, 0);
}

function closeTrainingModeSetup() {
  TrainingSetup.pageOpen = false;
  const tab = document.getElementById('tab-train');
  const root = document.getElementById('training-mode-config');
  if (tab) {
    tab.classList.remove('training-mode-page-open');
    tab.scrollTop = 0;
  }
  root?.classList.add('hidden');
  if (typeof window?.scrollTo === 'function') window.scrollTo(0, 0);
}

function renderTrainingModeSetup() {
  const root = ensureTrainingModeConfigRoot();
  if (!root) return;
  loadTrainingSetupPreferences();
  const mode = TRAINING_MODE_META[Settings.mode] ? Settings.mode : 'learn';
  Settings.mode = mode;
  document.querySelectorAll('#mode-btns .mode-pill').forEach((button) => {
    const onclick = button.getAttribute?.('onclick') || '';
    const buttonMode = button.dataset.mode || onclick.match(/setMode\('([^']+)'/u)?.[1] || '';
    button.classList.toggle('active', buttonMode === mode);
  });
  const answerRow = document.querySelector('.answer-check-row');
  const startButton = document.getElementById('btn-start');
  const favoriteButton = document.getElementById('btn-fav');

  const meta = TRAINING_MODE_META[mode];
  const picker = mode === 'fast' ? renderFastTrainingPicker() : renderNormalTrainingPicker(mode);
  root.innerHTML = `
    <div class="training-mode-page-head">
      <button class="training-mode-back" type="button" onclick="closeTrainingModeSetup()" aria-label="Вернуться к выбору режима">← <span>Назад</span></button>
      <div class="training-mode-page-title"><span>Настройка режима</span><h2>${esc(meta.title)}</h2></div>
      <span class="training-mode-scope">${mode === 'fast' ? 'Тома 1–4' : esc(trainingVolumeLabel(App.volume))}</span>
    </div>
    <div class="training-mode-page-body">
      <p class="training-mode-note">${esc(meta.note)}</p>
      <section class="training-mode-section" aria-labelledby="training-lessons-title">
        <h3 class="training-mode-section-title" id="training-lessons-title">Выберите уроки</h3>
        <div class="training-picker">${picker}</div>
      </section>
      <section class="training-mode-section training-quantity-section" aria-labelledby="training-quantity-title">
        <h3 class="training-mode-section-title" id="training-quantity-title">Количество слов</h3>
        ${renderTrainingQuantity()}
      </section>
      <section class="training-mode-section training-answer-slot hidden" id="training-answer-slot" aria-label="Проверка арабского ввода"></section>
      <div class="training-selection-summary" id="mode-selection-summary" aria-live="polite"></div>
      <div class="training-mode-actions" id="training-mode-actions"></div>
    </div>`;

  const answerSlot = document.getElementById('training-answer-slot');
  const showAnswerOptions = ['learn', 'type-ar', 'mix'].includes(mode);
  if (answerRow && answerSlot) {
    answerRow.classList.toggle('hidden', !showAnswerOptions);
    answerSlot.classList.toggle('hidden', !showAnswerOptions);
    answerSlot.appendChild(answerRow);
  }
  const actions = document.getElementById('training-mode-actions');
  if (actions && startButton) actions.appendChild(startButton);
  if (actions && favoriteButton) actions.appendChild(favoriteButton);
  root.classList.toggle('hidden', !TrainingSetup.pageOpen);
  document.getElementById('tab-train')?.classList.toggle('training-mode-page-open', TrainingSetup.pageOpen);
  updateTrainingQuantityView();

  if (mode === 'fast' && !TrainingSetup.fastCatalogLoaded && !TrainingSetup.fastCatalogLoading && !TrainingSetup.fastCatalogError) {
    void ensureFastTrainingCatalog();
  }
}

function ensureTrainingModeConfigRoot() {
  const tab = document.getElementById('tab-train');
  if (!tab) return null;
  let root = document.getElementById('training-mode-config');
  if (!root) {
    root = document.createElement('div');
    root.id = 'training-mode-config';
    root.className = 'training-mode-config hidden';
    tab.appendChild(root);
  } else if (root.parentNode !== tab) {
    tab.appendChild(root);
  }
  const legacyLessonGrid = document.getElementById('lesson-grid');
  if (legacyLessonGrid?.closest) legacyLessonGrid.closest('.sc')?.classList.add('legacy-training-lessons');
  ['qty-normal', 'qty-fast'].forEach((id) => document.getElementById(id)?.closest?.('.sc')?.classList.add('legacy-training-quantity'));
  return root;
}

function resetFastTrainingCatalog() {
  TrainingSetup.fastCatalog = {};
  TrainingSetup.fastCatalogLoaded = false;
  TrainingSetup.fastCatalogLoading = null;
  TrainingSetup.fastCatalogError = '';
}
