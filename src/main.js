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
  btn.classList.add('active');
}

function setQty(type, val, btn) {
  if (type === 'normal') {
    Settings.qtyNormal = val;
    document.querySelectorAll('#qty-normal .qty-pill').forEach((p) => p.classList.remove('active'));
    localStorage.setItem('aqn', val);
  } else {
    Settings.qtyFast = val;
    document.querySelectorAll('#qty-fast .qty-pill').forEach((p) => p.classList.remove('active'));
    localStorage.setItem('aqf', val);
  }
  btn.classList.add('active');
}
function loadQty() {
  const n = localStorage.getItem('aqn'),
    f = localStorage.getItem('aqf');
  if (n) {
    Settings.qtyNormal = isNaN(n) ? n : parseInt(n);
    document.querySelectorAll('#qty-normal .qty-pill').forEach((p) => p.classList.toggle('active', p.dataset.val === n));
  }
  if (f) {
    Settings.qtyFast = isNaN(f) ? f : parseInt(f);
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
      Api.call('update-daily-count', { username: App.username, password: App.password, daily_words: App.dailyWords }, { keepalive: true }).catch(() => {});
    }
  } else {
    checkMidnightReset();
  }
});

// KEYBOARD
document.addEventListener('keypress', (e) => {
  if (e.key !== 'Enter') return;
  const s = document.querySelector('.screen.active')?.id;
  if (s === 'screen-login') {
    loginMode === 'login' ? doLogin() : doRegister();
  } else if (s === 'screen-quiz') {
    if (!document.getElementById('type-area').classList.contains('hidden')) checkTyped();
    else if (!document.getElementById('btn-next').classList.contains('hidden')) goNext();
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

// INIT
window.addEventListener('load', async () => {
  loadQty();
  checkMidnightReset();
  const ok = await tryAutoLogin();
  if (ok) {
    const restored = await restoreProgress();
    if (!restored) {
      const lastScreen = localStorage.getItem('arabic_last_screen');
      const lastVolume = localStorage.getItem('arabic_last_volume');
      const lastTab = localStorage.getItem('arabic_last_tab');
      if (lastScreen === 'screen-app' && lastVolume) {
        if (!findVolumeById(lastVolume)) {
          localStorage.removeItem('arabic_last_volume');
          goToCourse();
          return;
        }
        App.volume = lastVolume;
        currentCourseKey = getCourseKeyByVolume(lastVolume) || currentCourseKey;
        document.getElementById('s-uname').textContent = App.username;
        updateUI();
        await loadDict();
        await loadRulesAll();
        await updateStreak(false);
        showScreen('screen-app');
        switchTab(lastTab && document.getElementById('tab-' + lastTab) ? lastTab : 'train');
      } else {
        goToCourse();
      }
    }
  } else {
    showScreen('screen-login');
  }
});
