#!/bin/sh
HASH=${CF_PAGES_COMMIT_SHA:-$(date +%s)}
SHORT=$(echo "$HASH" | cut -c1-8)
sed "s/__BUILD_HASH__/$SHORT/g" sw.js > sw_tmp.js && mv sw_tmp.js sw.js
echo "Build hash: $SHORT"
