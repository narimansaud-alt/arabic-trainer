// lb.js — leaderboard tab. All reads here are public/non-sensitive
// (the `leaderboard` view exposes no password data, kept in sync with
// `users` by a database trigger — see the schema migration).
const LB_QUERY_TIMEOUT_MS = 7000;

function lbQueryErrorMessage() {
  return 'Сейчас данные рейтинга недоступны. Проверьте интернет и попробуйте позже.';
}

async function safeLbQuery(queryFactory, label) {
  try {
    const queryPromise = queryFactory();
    const promise = typeof withTimeout === 'function' ? withTimeout(queryPromise, LB_QUERY_TIMEOUT_MS, `lb-${label}`) : queryPromise;
    const result = await promise;
    if (!result || result.error) throw new Error((result && result.error && result.error.message) || `Leaderboard query failed: ${label}`);
    return Array.isArray(result.data) ? result.data : [];
  } catch (e) {
    ErrorLog.capture(e, { source: 'lb', action: label });
    return null;
  }
}

function setLbFilter(dim, val, btn) {
  Settings.lbFilters[dim] = val;
  const rowId = dim === 'type' ? 'lb-type-row' : 'lb-period-row';
  document.querySelectorAll('#' + rowId + ' .lb-pill').forEach((b) => b.classList.remove('active'));
  if (btn && btn.classList) btn.classList.add('active');
  if (dim === 'type') {
    const section = document.getElementById('lb-time-section');
    if (section) section.classList.toggle('hidden', ['fast', 'streak', 'daily'].includes(val));
  }
  loadLB();
}

async function loadLB() {
  const cont = document.getElementById('lb-content');
  if (!cont) return;
  cont.innerHTML = '<div class="lb-empty">Загрузка...</div>';
  const { type, period } = Settings.lbFilters;
  const username = typeof App?.username === 'string' && App.username ? App.username : null;

  if (type === 'fast') {
    const data = await safeLbQuery(() =>
      db.from('leaderboard').select('nickname,fast_mode_high_score').order('fast_mode_high_score', { ascending: false }).limit(20),
      'fast'
    );
    if (data === null) {
      cont.innerHTML = '<div class="lb-empty">' + lbQueryErrorMessage() + '</div>';
      return;
    }
    const items = data.map((r) => ({ name: r.nickname, val: (r.fast_mode_high_score || 0) + ' слов' }));
    cont.innerHTML = '';
    renderLbTable(cont, items, true);
    return;
  }

  if (type === 'streak') {
    const data = await safeLbQuery(() =>
      db.from('leaderboard').select('nickname,streak,max_streak,daily_goals_completed').order('streak', { ascending: false }).limit(20),
      'streak'
    );
    if (data === null) {
      cont.innerHTML = '<div class="lb-empty">' + lbQueryErrorMessage() + '</div>';
      return;
    }
    const items = data.map((r) => ({
      name: r.nickname,
      val: (r.streak || 0) + ' дн.',
      extra: 'Выполнено: ' + (r.daily_goals_completed || 0) + ' · макс. серия: ' + (r.max_streak || 0),
    }));
    cont.innerHTML = '';
    renderLbTable(cont, items, true);
    return;
  }

  if (type === 'daily') {
    const data = await safeLbQuery(() =>
      db
        .from('leaderboard')
        .select('nickname,daily_goals_completed,streak,daily_goal_minutes')
        .order('daily_goals_completed', { ascending: false })
        .order('streak', { ascending: false })
        .limit(20),
      'daily-goals'
    );
    if (data === null) {
      cont.innerHTML = '<div class="lb-empty">' + lbQueryErrorMessage() + '</div>';
      return;
    }
    const items = data.map((r) => ({
      name: r.nickname,
      val: (r.daily_goals_completed || 0) + ' дн.',
      extra: 'Серия: ' + (r.streak || 0) + ' · цель: ' + (r.daily_goal_minutes || 10) + ' мин.',
    }));
    cont.innerHTML = '';
    renderLbTable(cont, items, true);
    return;
  }

  // All-time score is the canonical total kept on users/leaderboard.
  // score_history is still used for time windows and the personal chart.
  if (period === 'all') {
    const data = await safeLbQuery(() =>
      db.from('leaderboard').select('nickname,total_score').order('total_score', { ascending: false }).limit(20),
      'score'
    );
    if (data === null) {
      cont.innerHTML = '<div class="lb-empty">' + lbQueryErrorMessage() + '</div>';
      return;
    }
    const d30 = new Date();
    d30.setDate(d30.getDate() - 30);
    const myData = username ? await safeLbQuery(() => db.from('score_history').select('points,created_at').eq('username', username).gte('created_at', d30.toISOString()), 'history-all') : [];
    if (myData === null) {
      cont.innerHTML = '<div class="lb-empty">' + lbQueryErrorMessage() + '</div>';
      return;
    }
    const items = data.map((r) => ({ name: r.nickname, val: (r.total_score || 0) + ' баллов' }));
    cont.innerHTML = '';
    const chart = buildChart(Array.isArray(myData) ? myData : []);
    if (chart) cont.innerHTML += chart;
    renderLbTable(cont, items, true);
    return;
  }

  // Period scores are aggregated from Moscow calendar periods:
  // day starts at 00:00 MSK, week starts on Sunday, month starts on the 1st.
  let q = db.from('score_history').select('username,points,course_name,created_at').like('course_name', 'Мединский курс%');
  const d = appPeriodStart(period);
  q = q.gte('created_at', d.toISOString());
  const d30 = new Date();
  d30.setDate(d30.getDate() - 30);
  const myData = username ? await safeLbQuery(() => db.from('score_history').select('points,created_at').eq('username', username).gte('created_at', d30.toISOString()), 'history-period') : [];
  let data = await safeLbQuery(() => q, 'period');
  if (data === null) {
    cont.innerHTML = '<div class="lb-empty">' + lbQueryErrorMessage() + '</div>';
    return;
  }
  if (myData === null) {
    cont.innerHTML = '<div class="lb-empty">' + lbQueryErrorMessage() + '</div>';
    return;
  }
  if (!Array.isArray(data)) data = [];
  const agg = {};
  (data || []).forEach((r) => {
    agg[r.username] = (agg[r.username] || 0) + r.points;
  });
  const sorted = Object.entries(agg).sort((a, b) => b[1] - a[1]).slice(0, 15);
  cont.innerHTML = '';
  const chart = buildChart(myData || []);
  if (chart) cont.innerHTML += chart;
  if (!sorted.length) {
    cont.innerHTML += '<div class="lb-empty">Нет данных</div>';
    return;
  }
  renderLbTable(cont, sorted.map(([name, val]) => ({ name, val: val + ' баллов' })), true);
}

function buildChart(records) {
  const days = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date(Date.now() - i * 24 * 60 * 60 * 1000);
    days.push(appDateKey(d));
  }
  const byDay = {};
  records.forEach((r) => {
    if (!r || !r.created_at) return;
    const d = appDateKey(new Date(r.created_at));
    if (!d) return;
    const points = Number(r.points);
    if (!Number.isFinite(points)) return;
    byDay[d] = (byDay[d] || 0) + points;
  });
  const vals = days.map((d) => byDay[d] || 0);
  const max = Math.max(...vals, 1);
  const dn = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];
  return `<div class="chart-card"><div class="chart-title">Мой прогресс — 7 дней</div><div class="chart-wrap">${days
    .map((d, i) => {
      const pct = Math.round((vals[i] / max) * 100);
      const isT = i === 6;
      return `<div class="chart-col"><div class="chart-val">${vals[i] || ''}</div><div class="chart-bar-wrap"><div class="chart-bar" style="height:${Math.max(
        pct,
        4
      )}%;background:${isT ? 'var(--gold)' : 'var(--green)'}"></div></div><div class="chart-label" style="${
        isT ? 'font-weight:700;color:var(--gold)' : ''
      }">${dn[new Date(d).getDay()]}</div></div>`;
    })
    .join('')}</div></div>`;
}

function renderLbTable(cont, rows, append) {
  if (!rows.length) {
    cont.innerHTML += '<div class="lb-empty">Пока нет результатов</div>';
    return;
  }
  const html =
    '<div class="lb-table">' +
    rows
      .map(
        (r, i) => `
    <div class="lb-item ${r.name === App.username ? 'is-current' : ''}">
      <div class="lb-rank ${i === 0 ? 't1' : i === 1 ? 't2' : i === 2 ? 't3' : ''}">${i + 1}.</div>
      <div class="lb-name ${r.name === App.username ? 'me' : ''}">${esc(r.name)}${
          r.name === App.username ? ' ← ты' : ''
        }${r.extra ? '<div style="font-size:10px;color:#e67e22">' + esc(r.extra) + '</div>' : ''}</div>
      <div class="lb-val">${esc(r.val)}</div>
    </div>`
      )
      .join('') +
    '</div>';
  if (append) cont.innerHTML += html;
  else cont.innerHTML = html;
}
