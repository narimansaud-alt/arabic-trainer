// Academy-based study vocabulary; original Russian meanings and provenance:
// data/quran-academy-vocabulary.json. The legacy course ID preserves scores.
function quranInputHint(word) {
  if (!isQuranVolume(word?.volume || App.volume)) return '';
  const meta = word?.vocabularyMeta || {};
  if (meta.inputForm === 'imperative') return 'Введите повеление одному мужчине — одну форму.';
  if (meta.inputForm === 'present') return 'Введите настоящее время, «он» — одну форму.';
  if (meta.inputForm === 'past-phrase') return 'Введите глагол в прошедшем времени, «он», вместе со словом после него.';
  if (meta.inputForm === 'construction') return 'Введите обе части конструкции через пробел, без многоточия и вставки слов.';
  if (meta.inputForm === 'past') return 'Введите одну форму прошедшего времени, «он». Не нужно писать пару времён.';
  if (meta.kind === 'plural') return 'Введите множественное число из карточки.';
  if (meta.kind === 'dual') return 'Введите двойственное число — форму для двух.';
  if (meta.kind === 'attached') return 'Введите только слитное местоимение, без слова перед ним.';
  return 'Введите словарную форму из карточки. Падежное окончание добавлять не нужно.';
}

function quranGlossParts(word) {
  return String(word?.ru || '').toLowerCase().replace(/ё/g, 'е').split(/[;,]/u).map(s => s.trim()).filter(Boolean);
}

function quranGlossesOverlap(first, second) {
  const parts = new Set(quranGlossParts(first));
  return quranGlossParts(second).some(part => parts.has(part));
}

function isQuranAlternateAnswerCorrect(value, word, mode) {
  if (!isQuranVolume(word?.volume || App.volume)) return false;
  if (word.vocabularyMeta?.inputForm === 'construction') {
    const parts = text => String(text || '').replace(/[.\u2026ـ]/gu, ' ').replace(/\s+/gu, ' ').trim();
    if (isArabicAnswerCorrect(parts(value), parts(word.ar), mode)) return true;
  }
  // Identical Russian prompts must not require guessing which synonym the
  // scheduler chose. Different requested verb forms are not interchangeable.
  const ru = String(word.ru || '').trim().toLowerCase();
  const form = word.vocabularyMeta?.inputForm;
  return Dict.allWords.some(candidate =>
    isQuranVolume(candidate.volume) &&
    candidate.ru.trim().toLowerCase() === ru &&
    candidate.vocabularyMeta?.inputForm === form &&
    isArabicAnswerCorrect(value, candidate.ar, mode));
}

function quranTasksAreCurrent(tasks, fallbackVolume) {
  return Array.isArray(tasks) && tasks.every(task => {
    const word = task?.word || task?.w || task;
    return !isQuranVolume(word?.volume || fallbackVolume) || word?.vocabularyMeta?.dataset === QURAN_DATASET_REVISION;
  });
}

function quranProgressIsStale(progress) {
  const words = [...(progress.queue || []), ...(progress.learnCards || []),
    ...(progress.dailyTasks || []), ...(progress.sessionInitialWords || [])];
  return !quranTasksAreCurrent(words, progress.volume);
}

function renderQuranDictionary(words) {
  const total = Dict.allWords.filter(word => isQuranVolume(word.volume)).length;
  const introduction = '<section class="quran-dictionary-intro"><h2>' + esc(QURAN_COURSE_TITLE) + '</h2>' +
    '<p>' + total + ' карточек · блоки по 50.</p>' +
    '<details><summary>Источник</summary><p>По подборке «85% of Qur’anic Words», д-р Абдульазиз Абдуррахим, <a href="https://understandquran.com/e-books/" target="_blank" rel="noopener noreferrer">Understand Al-Qur’an Academy</a>. Русские значения подготовлены для тренажёра: это не официальный перевод Академии и не перевод аятов.</p></details></section>';
  if (!words.length) return introduction + '<div class="lb-empty">Ничего не найдено</div>';
  const sorted = [...words].sort((a, b) => (a.vocabularyMeta?.rank || 0) - (b.vocabularyMeta?.rank || 0));
  const groups = new Map();
  for (const word of sorted) {
    if (!groups.has(word.lesson)) groups.set(word.lesson, []);
    groups.get(word.lesson).push(word);
  }
  return introduction + [...groups].map(([block, items]) => {
    const rows = items.map((word) => {
      return '<div class="quran-word"><div class="quran-word-main"><span class="dict-ar" dir="rtl" lang="ar">' + esc(word.ar) +
        '</span><span class="dict-ru">' + esc(word.ru) + '</span></div></div>';
    }).join('');
    return '<section class="dict-section quran-word-section' + (Settings.dictView === 'table' ? ' quran-compact' : '') +
      '"><div class="dict-section-hdr">Блок ' + esc(block) + ' · ' + items.length + ' слов</div>' + rows + '</section>';
  }).join('');
}
