const CACHE = 'arabic-v__BUILD_HASH__';
const FILES = [
  './',
  './index.html',
  './icon.png',
  './manifest.json',
  './src/api.js',
  './src/state.js',
  './src/helpers.js',
  './src/auth.js',
  './src/announcement.js',
  './src/course.js',
  './src/streak.js',
  './src/lb.js',
  './src/dict.js',
  './src/quiz.js',
  './src/learn.js',
  './src/main.js',
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
  e.respondWith(
    caches.match(e.request).then(r => r || fetch(e.request))
  );
});

// Сообщаем странице что есть новая версия
self.addEventListener('message', e => {
  if (e.data === 'skipWaiting') self.skipWaiting();
});
