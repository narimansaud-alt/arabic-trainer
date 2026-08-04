// main.js — settings, PWA install, lifecycle, and app bootstrap.
// This is the last script loaded; everything else must already be defined.

window.addEventListener('error', (e) => {
  ErrorLog.capture(e.error || e.message, {
    source: 'window-error',
    filename: e.filename,
    lineno: e.lineno,
    colno: e.colno,
  });
});

window.addEventListener('unhandledrejection', (e) => {
  ErrorLog.capture(e.reason || 'Unhandled promise rejection', {
    source: 'unhandledrejection',
  });
});

function setMode(m, btn) {
  Settings.mode = m;
  document.querySelectorAll('#mode-btns .mode-pill').forEach((b) => b.classList.remove('active'));
  if (btn && btn.classList) btn.classList.add('active');
}

function setQty(type, val, btn) {
  const specialVal = type === 'normal' && val === 'all' ? 'all' : type === 'fast' && val === 'inf' ? 'inf' : null;
  const parsedVal = parseInt(val, 10);
  const nextVal = specialVal || parsedVal;
  if (!specialVal && (!Number.isFinite(parsedVal) || parsedVal <= 0)) return;
  if (type === 'normal') {
    Settings.qtyNormal = nextVal;
    document.querySelectorAll('#qty-normal .qty-pill').forEach((p) => p.classList.remove('active'));
    try {
      localStorage.setItem('aqn', String(nextVal));
    } catch (e) {
      /* non-fatal */
    }
  } else {
    Settings.qtyFast = nextVal;
    document.querySelectorAll('#qty-fast .qty-pill').forEach((p) => p.classList.remove('active'));
    try {
      localStorage.setItem('aqf', String(nextVal));
    } catch (e) {
      /* non-fatal */
    }
  }
  if (btn && btn.classList) btn.classList.add('active');
}
function loadQty() {
  let n, f;
  try {
    n = localStorage.getItem('aqn');
    f = localStorage.getItem('aqf');
  } catch (e) {
    n = null;
    f = null;
  }
  if (n) {
    const parsed = parseInt(n, 10);
    if (n === 'all') Settings.qtyNormal = 'all';
    else if (Number.isFinite(parsed) && parsed > 0) Settings.qtyNormal = parsed;
    document.querySelectorAll('#qty-normal .qty-pill').forEach((p) => p.classList.toggle('active', p.dataset.val === n));
  }
  if (f) {
    const parsed = parseInt(f, 10);
    if (f === 'inf') Settings.qtyFast = 'inf';
    else if (Number.isFinite(parsed) && parsed > 0) Settings.qtyFast = parsed;
    document.querySelectorAll('#qty-fast .qty-pill').forEach((p) => p.classList.toggle('active', p.dataset.val === f));
  }
}

// PWA INSTALL
let deferredInstallPrompt = null;
window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault();
  deferredInstallPrompt = e;
  const btn = document.getElementById('btn-install-pwa');
  if (btn) btn.style.display = 'block';
});
window.addEventListener('appinstalled', () => {
  deferredInstallPrompt = null;
  const btn = document.getElementById('btn-install-pwa');
  if (btn) btn.style.display = 'none';
});
async function installPWA() {
  if (!deferredInstallPrompt) return;
  deferredInstallPrompt.prompt();
  const { outcome } = await deferredInstallPrompt.userChoice;
  if (outcome === 'accepted') deferredInstallPrompt = null;
}

// VISIBILITY — save everything when app is minimized
document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'hidden') {
    saveProgress();
    if (App.username && App.dailyWords > 0) {
      Api.call(
        'update-daily-count',
        { username: App.username, password: App.password, daily_words: App.dailyWords },
        { keepalive: true, timeoutMs: 2500 }
      ).catch(() => {});
    }
  } else {
    checkMidnightReset();
  }
});

function withTimeout(promise, timeoutMs, label) {
  return new Promise((resolve, reject) => {
    let done = false;
    const timer = setTimeout(() => {
      if (done) return;
      done = true;
      reject(new Error(`Timeout: ${label}`));
    }, timeoutMs);
    promise
      .then((value) => {
        if (done) return;
        done = true;
        clearTimeout(timer);
        resolve(value);
      })
      .catch((err) => {
        if (done) return;
        done = true;
        clearTimeout(timer);
        reject(err);
      });
  });
}

async function bootstrapApp() {
  let ok = false;
  try {
    ok = await withTimeout(tryAutoLogin(), 4500, 'auto-login');
  } catch (e) {
    ErrorLog.capture(e, { source: 'app-bootstrap', phase: 'auto-login' });
  }
  if (!ok) {
    showScreen('screen-login');
    return;
  }

  let restored = false;
  try {
    restored = await withTimeout(restoreProgress({ skipPrompt: true }), 1500, 'restore-progress');
  } catch (e) {
    restored = false;
    ErrorLog.capture(e, { source: 'app-bootstrap', phase: 'restore-progress' });
  }

  if (restored) {
    return;
  }

  let lastScreen = null,
    lastVolume = null,
    lastTab = null;
  try {
    lastScreen = localStorage.getItem('arabic_last_screen');
    lastVolume = localStorage.getItem('arabic_last_volume');
    lastTab = localStorage.getItem('arabic_last_tab');
  } catch (e) {
    lastScreen = null;
    lastVolume = null;
    lastTab = null;
  }
  if (lastScreen === 'screen-app' && lastVolume) {
    if (!findVolumeById(lastVolume)) {
      try {
        localStorage.removeItem('arabic_last_volume');
      } catch (e) {
        /* non-fatal */
      }
      goToCourse();
      return;
    }
    App.volume = lastVolume;
    currentCourseKey = getCourseKeyByVolume(lastVolume) || currentCourseKey;
    document.getElementById('s-uname').textContent = App.username;
    updateUI();
    try {
      await Promise.all([
        withTimeout(loadDict(), 6000, 'load-dict'),
        withTimeout(loadRulesAll(), 6000, 'load-rules'),
        withTimeout(updateStreak(false), 2000, 'update-streak'),
      ]);
    } catch (e) {
      ErrorLog.capture(e, { source: 'app-bootstrap', phase: 'data-hydration' });
    }
    showScreen('screen-app');
    switchTab(lastTab && document.getElementById('tab-' + lastTab) ? lastTab : 'train');
  } else {
    goToCourse();
  }
}

// KEYBOARD
document.addEventListener('keypress', (e) => {
  if (e.key !== 'Enter') return;
  const s = document.querySelector('.screen.active')?.id;
  if (s === 'screen-login') {
    loginMode === 'login' ? doLogin() : doRegister();
  } else if (s === 'screen-quiz') {
    const typeArea = document.getElementById('type-area');
    const btnNext = document.getElementById('btn-next');
    if (typeArea && !typeArea.classList.contains('hidden')) checkTyped();
    else if (btnNext && !btnNext.classList.contains('hidden')) goNext();
  }
});

window.addEventListener('popstate', (e) => {
  const state = e.state || {};
  const modal = document.getElementById('verb-modal-overlay');
  const modalOpen = modal && !modal.classList.contains('hidden');

  if (modalOpen && state.appModal !== 'grammar-table') {
    closeVerbModal(true);
  }

  if (state.app === 'arabic-trainer' && state.appModal === 'grammar-table') {
    openGrammarTable(state.table || 'pronouns', false);
    return;
  }

  if (state.app === 'arabic-trainer' && state.appView === 'rule-lesson') {
    if (document.querySelector('.screen.active')?.id !== 'screen-app') showScreen('screen-app');
    switchTab('rules');
    showRuleLesson(state.lesson, false);
    if (state.ruleCardId) {
      const card = document.getElementById('rule-card-' + state.ruleCardId);
      if (card) {
        openRuleCardById(state.ruleCardId, true);
      } else {
        closeAllRuleCards();
      }
    } else {
      closeAllRuleCards();
    }
    return;
  }

  if (state.app === 'arabic-trainer' && state.appView === 'rules-index') {
    if (document.querySelector('.screen.active')?.id !== 'screen-app') showScreen('screen-app');
    switchTab('rules');
    showRulesIndex(false);
    closeAllRuleCards();
    return;
  }

  if (document.querySelector('.tab-content.active')?.id === 'tab-rules' && Settings.rulesLesson !== 'all') {
    showRulesIndex(false);
  }
});

// Keep Android/system Back inside the PWA. Every screen transition gets a
// history entry; on the root screen we restore a guard entry instead of exit.
let appScreenHistoryReady = false;
let appScreenHistoryRestoring = false;
const APP_NAVIGATION_SCREENS = new Set(['screen-course', 'screen-volume', 'screen-app', 'screen-verbs', 'screen-quiz', 'screen-results']);

function setupAppScreenHistory() {
  if (appScreenHistoryReady || typeof window.showScreen !== 'function') return;
  appScreenHistoryReady = true;
  const baseShowScreen = window.showScreen;
  window.appNavigateBack = function appNavigateBack(fallbackScreen) {
    if (history.state?.appNavigation && !history.state.root) {
      history.back();
      return;
    }
    appScreenHistoryRestoring = true;
    try { baseShowScreen(fallbackScreen); } finally { appScreenHistoryRestoring = false; }
  };
  window.showScreen = function trackedShowScreen(screenId) {
    const previousScreen = document.querySelector('.screen.active')?.id || '';
    const result = baseShowScreen.apply(this, arguments);
    if (!APP_NAVIGATION_SCREENS.has(screenId) || appScreenHistoryRestoring || previousScreen === screenId) return result;
    const state = { appNavigation: true, screen: screenId };
    if (!history.state?.appNavigation) {
      history.replaceState({ ...state, root: true }, '');
      history.pushState({ ...state, guard: true }, '');
    } else {
      history.pushState(state, '');
    }
    return result;
  };
  window.addEventListener('popstate', (event) => {
    const state = event.state;
    if (!state?.appNavigation || !APP_NAVIGATION_SCREENS.has(state.screen)) return;
    appScreenHistoryRestoring = true;
    try { baseShowScreen(state.screen); } finally { appScreenHistoryRestoring = false; }
    if (state.root) history.pushState({ appNavigation: true, screen: state.screen, guard: true }, '');
  });
}

window.addEventListener('load', setupAppScreenHistory);

// INIT
window.addEventListener('load', async () => {
  loadQty();
  checkMidnightReset();
  try {
    await withTimeout(bootstrapApp(), 10000, 'app-bootstrap');
  } catch (e) {
    ErrorLog.capture(e, { source: 'app-bootstrap' });
    showScreen('screen-login');
  }
});

