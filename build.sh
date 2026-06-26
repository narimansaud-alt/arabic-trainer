#!/bin/sh
# Подставляет хэш коммита в sw.js при деплое на Cloudflare Pages
HASH=${CF_PAGES_COMMIT_SHA:-$(date +%s)}
SHORT=${HASH:0:8}
sed "s/__BUILD_HASH__/$SHORT/g" sw.js > sw.js.tmp && mv sw.js.tmp sw.js
echo "Build hash: $SHORT"
