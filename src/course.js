// course.js — course & volume selection screens.

function goToCourse() {
  document.getElementById('course-hello').textContent =
    'السلام عليكم و رحمة الله وبركاته، ' + App.username + '!';
  updateStreakBanner();
  showScreen('screen-course');
}

let currentCourseKey = 'med';

function showVolumeScreen(courseName, key) {
  App.course = courseName;
  currentCourseKey = key;
  document.getElementById('vol-course-title').textContent = courseName;
  const subMap = {
    med: '4 тома — классический арабский',
  };
  document.getElementById('vol-course-sub').textContent = subMap[key] || 'Выберите том';
  const vols = VOLUMES[key] || [];
  const container = document.getElementById('vol-cards');
  container.innerHTML = vols
    .map(
      (v) => `
    <div class="vol-card" onclick="selectVolume('${v.id}')">
      <div class="vol-num">${v.label}</div>
      <div class="vol-body"><div class="vol-title">${v.label}</div></div>
      <div class="vol-arrow">›</div>
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
    localStorage.removeItem('arabic_last_tab');
  }
  App.volume = volumeId;
  currentCourseKey = getCourseKeyByVolume(volumeId) || currentCourseKey;
  localStorage.setItem('arabic_last_volume', volumeId);
  document.getElementById('s-uname').textContent = App.username;
  updateUI();
  updateStreakBanner();
  switchTab('train');
  showScreen('screen-app');
  await loadDict();
  await loadRulesAll();
  await updateStreak(false);
  updateStreakBanner();
}
