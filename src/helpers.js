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
  // Strip Arabic harakat/diacritics for loose matching.
  return t.replace(/[\u0617-\u061A\u064B-\u0652]/g, '').trim();
}

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
}
