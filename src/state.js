// state.js — central mutable app state.
//
// Note on the auth model: the client still needs to remember the
// user's password (in memory + localStorage) to re-prove ownership on
// every write call to the Edge Function, since this app intentionally
// has no session/JWT layer (see auth.js for the rationale). This is
// the same trust model the legacy app used (it stored a password hash
// in localStorage); the difference now is the server independently
// re-verifies it with bcrypt on every write, instead of trusting a
// client-supplied username with no proof.

const App = {
  // session
  username: null,
  password: null, // kept only in memory + localStorage for re-auth on writes; never sent anywhere except over HTTPS to our own Edge Function
  course: null,
  volume: null,

  // synced from server
  totalScore: 0,
  survivalRecord: 0,
  streak: 0,
  maxStreak: 0,
  dailyWords: 0,
  lastCountDate: null,

  // local caches
  favorites: [],
  wordStats: {}, // word_ar -> {seen, level, next}
};

const Dict = {
  byLesson: {}, // lesson key -> word[]
  allWords: [],
  rules: [],
};

const Settings = {
  mode: 'learn',
  answerCheck: localStorage.getItem('arabic_answer_check') || 'learning',
  qtyNormal: 15,
  qtyFast: 50,
  lbFilters: { type: 'score', period: 'all' },
  dictLesson: 'all',
  dictView: localStorage.getItem('arabic_dict_view') === 'table' ? 'table' : 'list',
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
    start = Date.UTC(year, month - 1, day - dayOfWeek, -APP_TIME_ZONE_OFFSET_MINUTES / 60, 0, 0, 0);
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
      sub: 'Уроки 1–5+',
      book: {
        url: './books/ar_02_Lessons_in_Arabic_Language.pdf',
        title: 'Мединский курс (Том 2)',
        status: 'not-uploaded',
      },
    },
    { id: 'Мединский курс (Том 3)', label: 'Том 3', sub: 'В разработке', book: null },
    { id: 'Мединский курс (Том 4)', label: 'Том 4', sub: 'В разработке', book: null },
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
  App.course = null;
  App.volume = null;
  App.totalScore = 0;
  App.survivalRecord = 0;
  App.streak = 0;
  App.maxStreak = 0;
  App.dailyWords = 0;
  App.lastCountDate = null;
  App.favorites = [];
  App.wordStats = {};
}
