// announcement.js — public announcement popup. Read-only, public data.
//
// NOTE: the legacy app queried a table called `announcements`, which
// never existed in the schema (the real table is `notifications`) —
// so this popup silently never showed anything in production. Fixed
// here to point at the real table.

async function checkAnnouncement() {
  try {
    const { data } = await db
      .from('notifications')
      .select('message,id')
      .eq('is_active', true)
      .order('id', { ascending: false })
      .limit(1);
    if (!data || !data.length) return;
    const ann = data[0];
    const seenKey = 'ann_seen_' + ann.id;
    if (localStorage.getItem(seenKey)) return;
    document.getElementById('announcement-msg').textContent = ann.message;
    document.getElementById('announcement-overlay').classList.remove('hidden');
    localStorage.setItem(seenKey, '1');
  } catch (e) {
    console.log('Announcement check failed', e);
  }
}

function closeAnnouncement() {
  document.getElementById('announcement-overlay').classList.add('hidden');
}
