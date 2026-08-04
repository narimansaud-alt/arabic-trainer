// helpers.js — small, dependency-free utility functions.

function esc(s) {
  if (!s) return '';
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function rmH(t) {
  // Educational matching ignores marks, but keeps distinct Arabic letters.
  return String(t || '')
    .normalize('NFC')
    .replace(/[\u0617-\u061A\u064B-\u065F\u0670ـ]/gu, '')
    .replace(/\s+/gu, ' ')
    .trim();
}

function normalizeArabicAnswer(value, mode = Settings.answerCheck || 'learning') {
  const text = String(value || '').normalize('NFC').replace(/\s+/gu, ' ').trim();
  return mode === 'strict' ? text : rmH(text);
}

function isArabicAnswerCorrect(actual, expected, mode = Settings.answerCheck || 'learning') {
  return normalizeArabicAnswer(actual, mode) === normalizeArabicAnswer(expected, mode);
}

function answerCheckLabel(mode = Settings.answerCheck || 'learning') {
  return mode === 'strict' ? 'Строгий режим: проверяются буквы и огласовки' : 'Учебный режим: огласовки можно пропускать';
}

function setAnswerCheck(mode) {
  Settings.answerCheck = mode === 'strict' ? 'strict' : 'learning';
  localStorage.setItem('arabic_answer_check', Settings.answerCheck);
  updateAnswerCheckUI();
}

function updateAnswerCheckUI() {
  document.querySelectorAll('#answer-check-btns .answer-check-pill').forEach((button) => {
    button.classList.toggle('active', button.dataset.check === Settings.answerCheck);
  });
  const note = document.getElementById('answer-check-note');
  if (note) note.textContent = answerCheckLabel(Settings.answerCheck);
}

window.addEventListener('load', updateAnswerCheckUI);

function shuf(a) {
  const b = [...a];
  for (let i = b.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [b[i], b[j]] = [b[j], b[i]];
  }
  return b;
}

function showXP(pts) {
  const el = document.createElement('div');
  el.textContent = '+' + pts + ' XP';
  el.style.cssText =
    'position:fixed;top:80px;right:16px;z-index:9999;background:var(--gold);color:white;padding:7px 14px;border-radius:18px;font-weight:700;font-size:15px;animation:xpFloat 1.2s ease forwards;';
  document.body.appendChild(el);
  setTimeout(() => el.remove(), 1200);
}

function getDaysLabel(n) {
  if (n % 10 === 1 && n % 100 !== 11) return n + ' день';
  if ([2, 3, 4].includes(n % 10) && ![12, 13, 14].includes(n % 100)) return n + ' дня';
  return n + ' дней';
}

function showScreen(id) {
  document.querySelectorAll('.screen').forEach((s) => s.classList.remove('active'));
  document.getElementById(id).classList.add('active');
  window.scrollTo(0, 0);
  if (id !== 'screen-loading') localStorage.setItem('arabic_last_screen', id);
}
