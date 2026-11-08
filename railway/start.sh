#!/bin/sh
set -eu
if [ -z "${PAGESIFT_API_KEYS:-}" ]; then
  echo "PAGESIFT_API_KEYS is empty; refusing to start an open scraping API." >&2
  exit 1
fi
DATA="${PAGESIFT_DATA_DIR:-/data}"
mkdir -p "$DATA"
chown -R pagesift:pagesift "$DATA" 2>/dev/null || true
export HOME="$DATA"
set -- serve --host "$PAGESIFT_HOST" --port "$PORT"
if [ -n "${PAGESIFT_PUBLIC_URL:-}" ]; then set -- "$@" --public-url "$PAGESIFT_PUBLIC_URL"; fi
exec setpriv --reuid=pagesift --regid=pagesift --init-groups -- pagesift "$@"
