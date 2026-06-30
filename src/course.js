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
    huna: '2 тома — разговорный арабский',
    bayna: '4 тома по 2 части',
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
  App.volume = volumeId;
  document.getElementById('app-volume').textContent = volumeId;
  document.getElementById('app-user').textContent = App.username;
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
