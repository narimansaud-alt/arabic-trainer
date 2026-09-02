// course.js вЂ” course & volume selection screens.

function goToCourse() {
  updateStreakBanner();
  if (typeof maybePromptDailyGoalChoice === 'function' && maybePromptDailyGoalChoice()) return;
  showVolumeScreen('Мединский курс', 'med');
}

let currentCourseKey = 'med';

function showVolumeScreen(courseName, key) {
  const titleEl = document.getElementById('vol-course-title');
  const subEl = document.getElementById('vol-course-sub');
  const container = document.getElementById('vol-cards');

  App.course = courseName;
  currentCourseKey = key;

  if (!titleEl || !subEl || !container) return;

  titleEl.textContent = courseName;
  const subMap = {
    med: '4 тома — классический арабский',
  };
  subEl.textContent = subMap[key] || 'Выберите курс';

  const vols = VOLUMES[key] || [];
  container.innerHTML = vols
    .map(
      (v) =>
        `<div class="vol-card" onclick="selectVolume('${v.id}')">
      <div class="vol-num">${v.label}</div>
      <div class="vol-body"><div class="vol-title">${v.label}</div></div>
      <div class="vol-arrow">→</div>
    </div>`
    )
    .join('');
  if (key === 'med') {
    container.insertAdjacentHTML('beforeend', '<button class="vol-card quran-course-card" type="button" onclick="selectVolume(QURAN_COURSE_ID)"><div class="vol-body"><div class="vol-title">' + esc(QURAN_COURSE_ID) + '</div><div class="quran-course-sub">Отдельный словарь и тренировки · 20 блоков по 50 слов</div></div><div class="vol-arrow" aria-hidden="true">→</div></button>');
  }
  showScreen('screen-volume');
}

function openCourseSettings() {
  showScreen('screen-app');
  switchTab('settings');
  if (typeof updateDailyGoalSettingsUI === 'function') updateDailyGoalSettingsUI();
}

async function selectVolume(volumeId) {
  if (typeof closeTrainingModeSetup === 'function') closeTrainingModeSetup();
  const volumeChanged = Boolean(App.volume && App.volume !== volumeId);
  if (volumeChanged) {
    if (typeof resetQuizState === 'function') resetQuizState();
    document.getElementById('training-mode-next')?.classList.add('hidden');
    Settings.mode = 'learn';
    Settings.answerCheck = 'learning';
    updateAnswerCheckUI();
    Settings.dictLesson = 'all';
    Settings.rulesLesson = 'all';
    try {
      localStorage.removeItem('arabic_last_tab');
    } catch (e) {
      /* non-fatal */
    }
  }
  App.volume = volumeId;
  for (const tab of ['book', 'rules']) {
    const button = document.getElementById('at-' + tab);
    if (button) button.style.display = isQuranVolume(volumeId) ? 'none' : '';
  }
  if (isQuranVolume(volumeId)) Dict.rules = [];
  currentCourseKey = getCourseKeyByVolume(volumeId) || currentCourseKey;
  try {
    localStorage.setItem('arabic_last_volume', volumeId);
  } catch (e) {
    /* non-fatal */
  }
  const unameEl = document.getElementById('s-uname');
  if (unameEl) unameEl.textContent = App.username;
  updateUI();
  updateStreakBanner();
  switchTab('train');
  showScreen('screen-app');
  try {
    await Promise.all([
      withTimeout(loadDict(), 12000, 'load-dict'),
      isQuranVolume(volumeId) ? Promise.resolve() : withTimeout(loadRulesAll(), 12000, 'load-rules'),
    ]);
    if (typeof loadDailyGoal === 'function') await loadDailyGoal();
    if (typeof restoreProgress === 'function') await restoreProgress();
  } catch (e) {
    ErrorLog.capture(e, { source: 'course', action: 'select-volume-hydrate' });
  }
  updateStreakBanner();
}
