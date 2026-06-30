// streak.js — daily streak banner and the "30 words before midnight" counter.
//
// The actual streak increment is now computed server-side (see the
// Edge Function's 'update-streak' action) from `last_activity`,
// rather than trusting a client-calculated streak number — this
// closes the "tampered client claims itself extra days" gap that
// existed when `users` was directly writable from the browser.

async function updateStreak(doIncrement) {
  if (!doIncrement) {
    // Local-only check: if the user skipped a day, show 0 until the
    // server recomputes on their next 'update-streak' call.
    const today = new Date().toISOString().split('T')[0];
    updateUI();
    return;
  }
  try {
    const { streak, max_streak } = await Api.call('update-streak', {
      username: App.username,
      password: App.password,
    });
    App.streak = streak;
    App.maxStreak = max_streak;
  } catch (e) {
    console.log('updateStreak failed', e);
  }
  updateUI();
}

async function addDailyWord() {
  const today = new Date().toISOString().split('T')[0];
  if (App.lastCountDate !== today) {
    App.dailyWords = 0;
    App.lastCountDate = today;
  }
  App.dailyWords++;
  updateStreakBanner();
  try {
    await Api.call('update-daily-count', {
      username: App.username,
      password: App.password,
      daily_words: App.dailyWords,
    });
  } catch (e) {
    /* non-fatal, will resync on next load */
  }
  if (App.dailyWords === 30) {
    await updateStreak(true);
    updateStreakBanner();
  }
}

function checkMidnightReset() {
  const today = new Date().toISOString().split('T')[0];
  if (App.lastCountDate && App.lastCountDate !== today) {
    App.dailyWords = 0;
    App.lastCountDate = today;
    updateStreakBanner();
  }
  const now = new Date();
  const midnight = new Date(now);
  midnight.setHours(24, 0, 0, 0);
  const msToMidnight = midnight - now;
  setTimeout(() => {
    checkMidnightReset();
  }, msToMidnight);
}

function updateStreakBanner() {
  const days = App.streak || 0;
  const cnt = App.dailyWords || 0;
  const pct = Math.min((cnt / 30) * 100, 100);
  document.getElementById('banner-days').textContent = days;
  const lbl = document.getElementById('banner-days-label');
  if (lbl) lbl.textContent = getDaysLabel(days);
  document.getElementById('banner-today-count').textContent = cnt + ' / 30 слов';
  document.getElementById('streak-bar-fill').style.width = pct + '%';
  if (cnt >= 30) {
    document.getElementById('banner-hint').classList.add('hidden');
    document.getElementById('streak-done').classList.remove('hidden');
  } else {
    document.getElementById('banner-hint').classList.remove('hidden');
    document.getElementById('streak-done').classList.add('hidden');
  }
  loadStreakRank();
}

async function loadStreakRank() {
  if (!App.username) return;
  try {
    const { data } = await db
      .from('leaderboard')
      .select('nickname,streak')
      .order('streak', { ascending: false });
    if (!data || !data.length) return;
    const rank = data.findIndex((u) => u.nickname === App.username) + 1;
    const el = document.getElementById('banner-rank');
    if (el) {
      if (rank > 0) {
        el.textContent =
          '📊 ' +
          (rank === 1 ? '🥇' : rank === 2 ? '🥈' : rank === 3 ? '🥉' : '#' + rank) +
          ' место в рейтинге «Серия дней»';
      } else {
        el.textContent = '';
      }
    }
  } catch (e) {
    /* non-fatal */
  }
}

function updateUI() {
  document.getElementById('app-streak').textContent = '🔥 ' + (App.streak || 0);
  document.getElementById('app-score').textContent = (App.totalScore || 0) + ' 🌟';
}
