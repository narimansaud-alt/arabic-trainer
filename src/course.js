// course.js вЂ” course & volume selection screens.

function goToCourse() {
  const courseHello = document.getElementById('course-hello');
  if (courseHello) {
    courseHello.textContent = 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ';
  }
  updateStreakBanner();
  showScreen('screen-course');
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
  showScreen('screen-volume');
}

async function selectVolume(volumeId) {
  const volumeChanged = Boolean(App.volume && App.volume !== volumeId);
  if (volumeChanged) {
    if (typeof resetQuizState === 'function') resetQuizState();
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
      withTimeout(loadDict(), 6000, 'load-dict'),
      withTimeout(loadRulesAll(), 6000, 'load-rules'),
      withTimeout(updateStreak(false), 2000, 'update-streak'),
    ]);
  } catch (e) {
    ErrorLog.capture(e, { source: 'course', action: 'select-volume-hydrate' });
  }
  updateStreakBanner();
}
