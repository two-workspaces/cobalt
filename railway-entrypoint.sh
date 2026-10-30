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
exec node src/cobalt
