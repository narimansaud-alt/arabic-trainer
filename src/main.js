// main.js — settings, PWA install, lifecycle, and app bootstrap.
// This is the last script loaded; everything else must already be defined.

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
      Api.call('update-daily-count', { username: App.username, password: App.password, daily_words: App.dailyWords }).catch(() => {});
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

// INIT
window.addEventListener('load', async () => {
  loadQty();
  checkMidnightReset();
  const ok = await tryAutoLogin();
  if (ok) {
    const restored = await restoreProgress();
    if (!restored) goToCourse();
  } else {
    showScreen('screen-login');
  }
});
