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

function stripArabicTatweel(value) {
  return String(value || '').replace(/ـ/gu, '');
}

function normalizeArabicAnswer(value, mode = Settings.answerCheck || 'learning') {
  const text = stripArabicTatweel(value)
    .normalize('NFC')
    .replace(/\s*\/\s*/gu, '/')
    .replace(/\s+/gu, ' ')
    .trim();
  return mode === 'strict' ? text : rmH(text);
}

function parseArabicAnswerSpec(expected) {
  const source = String(expected || '').normalize('NFC').trim();
  const slashParts = source
    .split(/\s*\/\s*/gu)
    .map((part) => part.trim())
    .filter(Boolean);
  if (slashParts.length > 1) {
    return { kind: 'required-pair', source, parts: slashParts, primary: slashParts.join('/'), hasTatweel: source.includes('ـ') };
  }

  const parenthetical = source.match(/^(.+?)\s*\(\s*([^()]*)\s*\)\s*$/u);
  if (parenthetical) {
    const main = parenthetical[1].trim();
    const note = parenthetical[2].trim();
    if (/[\u0600-\u06ff]/u.test(note)) {
      if (rmH(note).startsWith('ي')) {
        return { kind: 'required-pair', source, parts: [main, note], primary: main + '/' + note, hasTatweel: source.includes('ـ') };
      }
      return { kind: 'alternatives', source, parts: [main, note], primary: main, hasTatweel: source.includes('ـ') };
    }
    return { kind: 'single', source, parts: [main], primary: main, hasTatweel: source.includes('ـ') };
  }

  const alternatives = source
    .split(/\s*،\s*/gu)
    .map((part) => part.trim())
    .filter(Boolean);
  if (alternatives.length > 1) {
    return { kind: 'alternatives', source, parts: alternatives, primary: alternatives[0], hasTatweel: source.includes('ـ') };
  }

  return { kind: 'single', source, parts: [source], primary: source, hasTatweel: source.includes('ـ') };
}

function normalizeRequiredPairInput(value, mode) {
  const source = String(value || '').normalize('NFC').trim();
  const parenthetical = source.match(/^(.+?)\s*\(\s*([^()]*)\s*\)\s*$/u);
  const canonical =
    parenthetical && /[\u0600-\u06ff]/u.test(parenthetical[2])
      ? parenthetical[1].trim() + '/' + parenthetical[2].trim()
      : source;
  const parts = canonical
    .split(/\s*\/\s*/gu)
    .map((part) => part.trim())
    .filter(Boolean);
  return parts.map((part) => normalizeArabicAnswer(part, mode));
}

function isArabicAnswerCorrect(actual, expected, mode = Settings.answerCheck || 'learning') {
  const spec = parseArabicAnswerSpec(expected);
  if (spec.kind === 'required-pair') {
    const actualParts = normalizeRequiredPairInput(actual, mode);
    const expectedParts = spec.parts.map((part) => normalizeArabicAnswer(part, mode));
    return actualParts.length === expectedParts.length && actualParts.every((part, index) => part === expectedParts[index]);
  }

  const normalizedActual = normalizeArabicAnswer(actual, mode);
  return spec.parts.some((part) => normalizedActual === normalizeArabicAnswer(part, mode));
}

function getArabicAnswerInputHint(expected) {
  const spec = parseArabicAnswerSpec(expected);
  const hints = [];
  if (spec.kind === 'required-pair') {
    hints.push('Введите обе формы через «/»: прошедшее / настоящее-будущее.');
  } else if (spec.kind === 'alternatives') {
    hints.push('Достаточно ввести один из вариантов.');
  }
  if (spec.hasTatweel) hints.push('Знак присоединения «ـ» вводить не нужно.');
  return hints.join(' ');
}

function getArabicAnswerHintTarget(expected) {
  return stripArabicTatweel(parseArabicAnswerSpec(expected).primary);
}

function answerCheckLabel(mode = Settings.answerCheck || 'learning') {
  return mode === 'strict' ? 'Строгий режим: проверяются буквы и огласовки' : 'Учебный режим: огласовки можно пропускать';
}

function setAnswerCheck(mode) {
  Settings.answerCheck = mode === 'strict' ? 'strict' : 'learning';
  try {
    localStorage.setItem('arabic_answer_check', Settings.answerCheck);
  } catch (e) {
    /* non-fatal: settings will reset on next load in storage-disabled modes */
  }
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
  const screens = document.querySelectorAll('.screen');
  if (!screens.length) return;
  const target = document.getElementById(id);
  if (!target) return;
  screens.forEach((s) => s.classList.remove('active'));
  target.classList.add('active');
  window.scrollTo(0, 0);
  if (id !== 'screen-loading') {
    try {
      localStorage.setItem('arabic_last_screen', id);
    } catch (e) {
      /* non-fatal */
    }
  }
}
