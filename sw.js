const CACHE = 'arabic-__BUILD_HASH__';
const FILES = [
  './',
  './index.html',
  './medina-premium-icon-512.png',
  './medina-premium-icon-192.png',
  './manifest.json?v=6',
  './manifest.json',
  './assets/fonts/local-fonts.css?v=7',
  './assets/fonts/ui-font-01.woff2',
  './assets/fonts/ui-font-02.woff2',
  './assets/fonts/ui-font-03.woff2',
  './assets/fonts/ui-font-04.woff2',
  './assets/fonts/ui-font-05.woff2',
  './assets/fonts/ui-font-06.woff2',
  './assets/fonts/ui-font-07.woff2',
  './assets/fonts/ui-font-08.woff2',
  './assets/fonts/ui-font-09.woff2',
  './assets/fonts/ui-font-10.woff2',
  './assets/fonts/ui-font-11.woff2',
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

const SHOULD_NETWORK_FIRST = [
  './manifest.json',
  './manifest.json?v=6',
  './medina-premium-icon-512.png',
  './medina-premium-icon-512.png?v=6',
  './medina-premium-icon-192.png',
  './medina-premium-icon-192.png?v=6',
  './medina-premium-icon-192.png'
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
  const requested = normalizeRequestUrl(e.request.url);
  if (SHOULD_NETWORK_FIRST.includes(requested)) {
    e.respondWith(
      fetch(e.request).then(response => {
        const copy = response.clone();
        caches.open(CACHE).then(c => c.put(e.request, copy));
        return response;
      }).catch(() => caches.match(e.request))
    );
    return;
  }
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

function normalizeRequestUrl(rawUrl) {
  const url = new URL(rawUrl);
  const path = url.pathname.replace(/^\//, './');
  if (path === './manifest.json') return './manifest.json';
  if (path === './medina-premium-icon-192.png') return './medina-premium-icon-192.png';
  if (path === './medina-premium-icon-512.png') return './medina-premium-icon-512.png';
  return path;
}

// Сообщаем странице что есть новая версия
self.addEventListener('message', e => {
  if (e.data === 'skipWaiting') self.skipWaiting();
});
