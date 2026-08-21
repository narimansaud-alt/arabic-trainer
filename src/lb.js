// lb.js — leaderboard tab. All reads use narrow public RPCs that expose
// performance metrics only. Period aggregation stays inside PostgreSQL so a
// PostgREST row limit can never truncate the score history before summing it.
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
    if (section) section.classList.toggle('hidden', ['fast', 'daily'].includes(val));
  }
  loadLB();
}

async function loadLB() {
  const cont = document.getElementById('lb-content');
  if (!cont) return;
  cont.innerHTML = '<div class="lb-empty">Загрузка...</div>';
  const { type, period } = Settings.lbFilters;
  const username = typeof App?.username === 'string' && App.username ? App.username : null;
  const leaderboardPeriod = type === 'score' ? period : 'all';
  const leaderboardPromise = safeLbQuery(
    () => db.rpc('get_public_leaderboard', {
      p_type: type,
      p_period: leaderboardPeriod,
      p_username: username,
      p_limit: 20,
    }),
    `${type}-${leaderboardPeriod}`
  );
  const chartPromise = type === 'score' && username
    ? safeLbQuery(
      () => db.rpc('get_public_score_chart', { p_username: username, p_days: 7 }),
      'score-chart'
    )
    : Promise.resolve([]);
  const [data, chartData] = await Promise.all([leaderboardPromise, chartPromise]);

  if (data === null) {
    cont.innerHTML = '<div class="lb-empty">' + lbQueryErrorMessage() + '</div>';
    return;
  }

  const items = data.map((row) => {
    const score = Number(row.score_value) || 0;
    const item = {
      name: row.nickname,
      rank: Number(row.position) || 0,
      isCurrent: Boolean(row.is_current),
      val: score + (type === 'fast' ? ' слов' : type === 'daily' ? ' дн.' : ' баллов'),
    };
    if (type === 'daily') {
      item.extra = 'Серия: ' + (Number(row.streak) || 0) + ' · цель: ' + (Number(row.daily_goal_minutes) || 10) + ' мин.';
    }
    return item;
  });

  cont.innerHTML = '';
  if (type === 'score' && Array.isArray(chartData)) {
    const chart = buildChart(chartData);
    if (chart) cont.innerHTML += chart;
  }
  renderLbTable(cont, items, true);
}

function buildChart(records) {
  const days = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date(Date.now() - i * 24 * 60 * 60 * 1000);
    days.push(appDateKey(d));
  }
  const byDay = {};
  records.forEach((r) => {
    if (!r) return;
    const d = r.score_date || (r.created_at ? appDateKey(new Date(r.created_at)) : '');
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
      }">${dn[new Date(d + 'T12:00:00Z').getUTCDay()]}</div></div>`;
    })
    .join('')}</div></div>`;
}

function normalizedLbName(value) {
  return String(value || '').trim().toLocaleLowerCase();
}

function renderLbTable(cont, rows, append) {
  if (!rows.length) {
    cont.innerHTML += '<div class="lb-empty">Пока нет результатов</div>';
    return;
  }
  const currentName = normalizedLbName(App.username);
  let lastRank = 0;
  const rowHtml = rows.map((r, i) => {
    const rank = Number(r.rank) || i + 1;
    const isCurrent = Boolean(r.isCurrent) || (currentName && normalizedLbName(r.name) === currentName);
    const gap = i > 0 && rank > lastRank + 1
      ? '<div class="lb-rank-gap" aria-hidden="true">•••</div>'
      : '';
    lastRank = rank;
    return `${gap}
    <div class="lb-item ${isCurrent ? 'is-current' : ''}">
      <div class="lb-rank ${rank === 1 ? 't1' : rank === 2 ? 't2' : rank === 3 ? 't3' : ''}">${rank}.</div>
      <div class="lb-name ${isCurrent ? 'me' : ''}">${esc(r.name)}${
        isCurrent ? ' ← ты' : ''
      }${r.extra ? '<div style="font-size:10px;color:#e67e22">' + esc(r.extra) + '</div>' : ''}</div>
      <div class="lb-val">${esc(r.val)}</div>
    </div>`;
  }).join('');
  const html = '<div class="lb-table">' + rowHtml + '</div>';
  if (append) cont.innerHTML += html;
  else cont.innerHTML = html;
}
