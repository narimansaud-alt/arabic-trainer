// QAC-based study vocabulary. The underlying source and editorial method are
// versioned in data/quran-vocabulary.json; database rows carry small metadata.
function quranInputHint(word) {
  if (!isQuranVolume(word?.volume || App.volume)) return '';
  const meta = word?.vocabularyMeta || {};
  if (meta.inputForm === 'imperative') return 'Введите повеление одному мужчине — одну форму.';
  if (meta.inputForm === 'present') return 'Введите настоящее время, «он» — одну форму.';
  if (meta.kind === 'verb') return 'Введите одну форму прошедшего времени, «он». Не нужно писать пару времён.';
  return 'Введите словарную форму из карточки. Падежное окончание добавлять не нужно.';
}

function quranSourceLinks(meta) {
  return (meta?.sourceRecords || []).flatMap((record) => {
    try {
      const url = new URL(record.url);
      if (url.origin !== 'https://corpus.quran.com' || url.pathname !== '/search.jsp') return [];
      return ['<a href="' + esc(url.href) + '" target="_blank" rel="noopener noreferrer">Вхождения QAC</a>'];
    } catch (_) {
      return [];
    }
  }).join(' · ');
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

function renderQuranDictionary(words) {
  const introduction = '<section class="quran-dictionary-intro"><h2>' + esc(QURAN_COURSE_ID) + '</h2>' +
    '<p>20 блоков по 50 карточек, от более частых к менее частым. Это блоки словаря, не суры.</p>' +
    '<details><summary>Источник и способ подсчёта</summary><p>Основа — <a href="https://corpus.quran.com/lemmas.jsp?group=1" target="_blank" rel="noopener noreferrer">Quranic Arabic Corpus: имена и частицы</a> и <a href="https://corpus.quran.com/verbs.jsp" target="_blank" rel="noopener noreferrer">глаголы</a>. Метод разметки описан в <a href="https://aclanthology.org/L10-1190/" target="_blank" rel="noopener noreferrer">публикации Dukes и Habash (LREC 2010)</a>.</p>' +
    '<p>Число вхождений относится к словарной группе, включая её формы, а не только к написанию на карточке. Таблицы объединены; одинаковые написания сведены в одну карточку. Документированные смешения разных форм исправлены по указателю вхождений. Аффиксы и местоимения, не имеющие отдельной записи в этих таблицах, не включены. При равной частоте сохранён порядок исходных таблиц.</p>' +
    '<p>Для набора используется обычное арабское написание. Русские значения — наши краткие учебные пояснения по формам и контексту QAC, не авторский перевод Корана и не тафсир. Независимую богословскую редактуру они не проходили.</p>' +
    '<p>Данные QAC © 2011 Kais Dukes · <a href="https://corpus.quran.com/download/" target="_blank" rel="noopener noreferrer">источник и условия GPL</a>.</p></details></section>';
  if (!words.length) return introduction + '<div class="lb-empty">Ничего не найдено</div>';
  const sorted = [...words].sort((a, b) => (a.vocabularyMeta?.rank || 0) - (b.vocabularyMeta?.rank || 0));
  const groups = new Map();
  for (const word of sorted) {
    if (!groups.has(word.lesson)) groups.set(word.lesson, []);
    groups.get(word.lesson).push(word);
  }
  return introduction + [...groups].map(([block, items]) => {
    const rows = items.map((word) => {
      const meta = word.vocabularyMeta || {};
      return '<div class="quran-word"><div class="quran-word-main"><span class="dict-ar" dir="rtl" lang="ar">' + esc(word.ar) +
        '</span><span class="dict-ru">' + esc(word.ru) + '</span></div><div class="quran-word-meta">№ ' + esc(meta.rank) +
        ' · Вхождений группы: ' + esc(meta.frequency) + '</div><details class="quran-word-source"><summary>Проверить в источнике</summary>' +
        quranSourceLinks(meta) + (meta.note ? '<p>' + esc(meta.note) + '</p>' : '') + '</details></div>';
    }).join('');
    return '<section class="dict-section quran-word-section' + (Settings.dictView === 'table' ? ' quran-compact' : '') +
      '"><div class="dict-section-hdr">Блок ' + esc(block) + ' · ' + items.length + ' слов</div>' + rows + '</section>';
  }).join('');
}
