#!/bin/sh
# Every download request needs COBALT_API_KEY, so a stranger who finds the URL can't spend
# the owner's bandwidth. Cobalt reads keys from a file; write it from the variable.
set -e
key=$(printf %s "$COBALT_API_KEY" | tr 'A-F' 'a-f')
if ! printf %s "$key" | grep -Eq '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'; then
  echo "COBALT_API_KEY must be a UUID like 3f2b8c1e-9a4d-4e7f-b6c5-1d2e3f4a5b6c" >&2
  exit 1
fi
printf '{"%s":{"name":"owner","limit":"unlimited"}}\n' "$key" > /tmp/keys.json
export API_KEY_URL=file:///tmp/keys.json API_AUTH_REQUIRED=1

# Cobalt fetches a YouTube PO token once at start and then every 5 minutes. On a fresh deploy
# the token server may still be booting, so wait up to a minute for it rather than start without one.
if [ -n "$YOUTUBE_SESSION_SERVER" ]; then
  for _ in $(seq 30); do
    wget -q -O /dev/null "${YOUTUBE_SESSION_SERVER%/}/ping" && break
    sleep 2
  done
fi
exec node src/cobalt
