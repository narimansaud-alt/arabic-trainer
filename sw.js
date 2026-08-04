const CACHE = 'arabic-v__BUILD_HASH__';
const FILES = [
  './',
  './index.html',
  './medina-course-icon-512.png',
  './medina-course-icon-192.png',
  './manifest.json?v=3',
  './src/api.js',
  './src/state.js',
  './src/helpers.js',
  './src/auth.js',
  './src/announcement.js',
  './src/course.js',
  './src/streak.js',
  './src/lb.js',
  './src/dict.js',
  './src/verbs.js',
  './src/quiz.js',
  './src/learn.js',
  './src/main.js',
  './books/ar_01_Lessons_in_Arabic_Language.pdf',
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(FILES)));
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  if (e.request.mode === 'navigate') {
    e.respondWith(
      fetch(e.request).then(response => {
        const copy = response.clone();
        caches.open(CACHE).then(cache => cache.put('./index.html', copy));
        return response;
      }).catch(() => caches.match('./index.html').then(r => r || caches.match('./')))
    );
    return;
  }
  e.respondWith(
    caches.match(e.request).then(r => r || fetch(e.request))
  );
});

// Сообщаем странице что есть новая версия
self.addEventListener('message', e => {
  if (e.data === 'skipWaiting') self.skipWaiting();
});
