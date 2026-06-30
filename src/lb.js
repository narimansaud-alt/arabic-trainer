// lb.js — leaderboard tab. All reads here are public/non-sensitive
// (the `leaderboard` view exposes no password data, kept in sync with
// `users` by a database trigger — see the schema migration).

function setLbFilter(dim, val, btn) {
  Settings.lbFilters[dim] = val;
  const rowId = dim === 'type' ? 'lb-type-row' : 'lb-period-row';
  document.querySelectorAll('#' + rowId + ' .lb-pill').forEach((b) => b.classList.remove('active'));
  btn.classList.add('active');
  if (dim === 'type') {
    document.getElementById('lb-time-section').classList.toggle('hidden', ['fast', 'streak'].includes(val));
  }
  loadLB();
}

async function loadLB() {
  const cont = document.getElementById('lb-content');
  cont.innerHTML = '<div class="lb-empty">Загрузка...</div>';
  const { type, period } = Settings.lbFilters;

  if (type === 'fast') {
    const { data } = await db
      .from('leaderboard')
      .select('nickname,fast_mode_high_score')
      .order('fast_mode_high_score', { ascending: false })
      .limit(20);
    const items = (data || []).map((r) => ({ name: r.nickname, val: (r.fast_mode_high_score || 0) + ' слов' }));
    cont.innerHTML = '';
    renderLbTable(cont, items, true);
    return;
  }

  if (type === 'streak') {
    const { data } = await db
      .from('leaderboard')
      .select('nickname,streak,max_streak')
      .order('streak', { ascending: false })
      .limit(20);
    const items = (data || []).map((r) => ({
      name: r.nickname,
      val: (r.streak || 0) + ' дн.',
      extra: r.max_streak > 0 ? 'Макс: ' + r.max_streak + ' дн.' : '',
    }));
    cont.innerHTML = '';
    renderLbTable(cont, items, true);
    return;
  }

  // Score, optionally windowed by period — aggregated from score_history.
  let q = db.from('score_history').select('username,points,course_name,created_at');
  if (period !== 'all') {
    const d = new Date();
    if (period === 'day') d.setHours(0, 0, 0, 0);
    else if (period === 'week') d.setDate(d.getDate() - 7);
    else if (period === 'month') d.setMonth(d.getMonth() - 1);
    q = q.gte('created_at', d.toISOString());
  }
  const d30 = new Date();
  d30.setDate(d30.getDate() - 30);
  const { data: myData } = await db
    .from('score_history')
    .select('points,created_at')
    .eq('username', App.username)
    .gte('created_at', d30.toISOString());
  const { data } = await q;
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
  renderLbTable(cont, sorted.map(([name, val]) => ({ name, val: val + ' 🌟' })), true);
}

function buildChart(records) {
  const days = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date();
    d.setDate(d.getDate() - i);
    days.push(d.toISOString().split('T')[0]);
  }
  const byDay = {};
  records.forEach((r) => {
    const d = r.created_at ? r.created_at.split('T')[0] : null;
    if (d) byDay[d] = (byDay[d] || 0) + r.points;
  });
  const vals = days.map((d) => byDay[d] || 0);
  const max = Math.max(...vals, 1);
  const dn = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];
  return `<div class="chart-card"><div class="chart-title">📈 Мой прогресс — 7 дней</div><div class="chart-wrap">${days
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
  const m = ['🥇', '🥈', '🥉'];
  const html =
    '<div class="lb-table">' +
    rows
      .map(
        (r, i) => `
    <div class="lb-item" style="${r.name === App.username ? 'background:#e8f5ee;' : ''}">
      <div class="lb-rank ${i === 0 ? 't1' : i === 1 ? 't2' : i === 2 ? 't3' : ''}">${m[i] || i + 1 + '.'}</div>
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
