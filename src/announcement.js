// announcement.js — public announcement popup (read-only public data).

async function checkAnnouncement() {
  const msgEl = document.getElementById('announcement-msg');
  const overlayEl = document.getElementById('announcement-overlay');
  if (!msgEl || !overlayEl) return;

  try {
    const { data, error } = await db
      .from('notifications')
      .select('message,id')
      .eq('is_active', true)
      .order('id', { ascending: false })
      .limit(1);

    if (error || !data || !data.length) return;

    const ann = data[0];
    const seenKey = 'ann_seen_' + ann.id;
    try {
      if (localStorage.getItem(seenKey)) return;
    } catch (e) {
      // non-fatal: show announcement even when storage is unavailable
    }

    msgEl.textContent = ann.message || '';
    overlayEl.classList.remove('hidden');

    try {
      localStorage.setItem(seenKey, '1');
    } catch (e) {
      // non-fatal: next run may show again if storage quota is blocked
    }
  } catch (e) {
    ErrorLog.capture(e, { source: 'announcement', action: 'load-notification' });
  }
}

function closeAnnouncement() {
  const overlayEl = document.getElementById('announcement-overlay');
  if (!overlayEl) return;
  overlayEl.classList.add('hidden');
}
