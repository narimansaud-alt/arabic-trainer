// state.js — central mutable app state.
//
// Note on the auth model: the client still needs to remember the
// The owner intentionally retains password persistence for convenient
// auto-login. A short-lived server session token is stored alongside it
// and is preferred for authenticated writes when available.

const App = {
  // session
  username: null,
  password: null, // intentionally retained for auto-login and session fallback
  sessionToken: null, // used for auto-login + write authorization after success
  course: null,
  volume: null,

  // synced from server
  totalScore: 0,
  survivalRecord: 0,
  streak: 0,
  maxStreak: 0,
  dailyWords: 0,
  lastCountDate: null,
  dailyGoalMinutes: 10,
  dailyGoalSelected: false,
  dailyGoalsCompleted: 0,
  lastDailyGoalDate: null,

  // local caches
  favorites: [],
  wordStats: {}, // word_ar -> {seen, level, next}
};

const Dict = {
  byLesson: {}, // lesson key -> word[]
  allWords: [],
  rules: [],
};

function safeGetStorage(key, fallback) {
  try {
    return localStorage.getItem(key);
  } catch (e) {
    return fallback;
  }
}

const Settings = {
  mode: 'learn',
  answerCheck: safeGetStorage('arabic_answer_check', 'learning') || 'learning',
  qtyNormal: 15,
  qtyFast: 50,
  lbFilters: { type: 'score', period: 'all' },
  dictLesson: 'all',
  dictView: safeGetStorage('arabic_dict_view', 'list') === 'table' ? 'table' : 'list',
  rulesLesson: 'all',
};

const APP_TIME_ZONE_OFFSET_MINUTES = 180; // Europe/Moscow, UTC+3

function appDateKey(date = new Date()) {
  const moscowTime = new Date(date.getTime() + APP_TIME_ZONE_OFFSET_MINUTES * 60 * 1000);
  return moscowTime.toISOString().split('T')[0];
}

function appPeriodStart(period) {
  const [year, month, day] = appDateKey().split('-').map(Number);
  let start = Date.UTC(year, month - 1, day, -APP_TIME_ZONE_OFFSET_MINUTES / 60, 0, 0, 0);
  if (period === 'week') {
    const dayOfWeek = new Date(Date.UTC(year, month - 1, day)).getUTCDay();
    const daysSinceMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
    start = Date.UTC(year, month - 1, day - daysSinceMonday, -APP_TIME_ZONE_OFFSET_MINUTES / 60, 0, 0, 0);
  } else if (period === 'month') {
    start = Date.UTC(year, month - 1, 1, -APP_TIME_ZONE_OFFSET_MINUTES / 60, 0, 0, 0);
  }
  return new Date(start);
}

function msUntilNextAppMidnight() {
  const [year, month, day] = appDateKey().split('-').map(Number);
  const nextMidnight = Date.UTC(year, month - 1, day + 1, -APP_TIME_ZONE_OFFSET_MINUTES / 60, 0, 0, 0);
  return Math.max(nextMidnight - Date.now(), 1000);
}

const VOLUMES = {
  med: [
    {
      id: 'Мединский курс (Том 1)',
      label: 'Том 1',
      sub: 'Уроки 1–23',
      book: {
        url: './books/ar_01_Lessons_in_Arabic_Language.pdf',
        title: 'Мединский курс (Том 1)',
        pageCount: 125,
        pagePattern: './books/tom1-pages/page-{page}.jpg',
        status: 'ready',
      },
    },
    {
      id: 'Мединский курс (Том 2)',
      label: 'Том 2',
      sub: 'Уроки 1–31',
      book: {
        url: './books/ar_02_Lessons_in_Arabic_Language.pdf',
        title: 'Мединский курс (Том 2)',
        pageCount: 223,
        pagePattern: './books/tom2-pages/page-{page}.jpg',
        status: 'ready',
      },
    },
    {
      id: 'Мединский курс (Том 3)',
      label: 'Том 3',
      sub: 'Уроки 1-17',
      book: {
        url: './books/ar_03_Lessons_in_Arabic_Language.pdf',
        title: 'Мединский курс (Том 3)',
        pageCount: 143,
        pagePattern: './books/tom3-pages/page-{page}.jpg',
        status: 'ready',
      },
    },
    {
      id: 'Мединский курс (Том 4)',
      label: 'Том 4',
      sub: 'Уроки 1-17',
      book: {
        url: 'https://www.fatwa-online.com/wp-content/uploads/madeenah-lessons-in-arabic-language-book-4.pdf',
        title: 'Мединский курс (Том 4)',
        pageCount: 161,
        pagePattern: './books/tom4-pages/page-{page}.jpg',
        status: 'ready',
      },
    },
  ],
};

function findVolumeById(volumeId) {
  for (const vols of Object.values(VOLUMES)) {
    const found = vols.find((v) => v.id === volumeId);
    if (found) return found;
  }
  return null;
}

function getCourseKeyByVolume(volumeId) {
  for (const [key, vols] of Object.entries(VOLUMES)) {
    if (vols.some((v) => v.id === volumeId)) return key;
  }
  return null;
}

function getVolumeBook(volumeId) {
  const volume = findVolumeById(volumeId);
  if (!volume || !volume.book) return null;
  if (!volume.book.url || volume.book.status !== 'ready') return null;
  return volume.book;
}

function resetApp() {
  App.username = null;
  App.password = null;
  App.sessionToken = null;
  App.course = null;
  App.volume = null;
  App.totalScore = 0;
  App.survivalRecord = 0;
  App.streak = 0;
  App.maxStreak = 0;
  App.dailyWords = 0;
  App.lastCountDate = null;
  App.dailyGoalMinutes = 10;
  App.dailyGoalSelected = false;
  App.dailyGoalsCompleted = 0;
  App.lastDailyGoalDate = null;
  App.favorites = [];
  App.wordStats = {};
  if (typeof resetDailyGoalState === 'function') resetDailyGoalState();
}
