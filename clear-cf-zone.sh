#!/bin/bash
# Clear CloudFlare cache for a given zone under my creds
# example: clear-cf-zone 52b2e79b15430d2b3561965d878594ea for www-stage

echo "Clearing CloudFlare zone $1"
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$1/purge_cache" \
    -H "X-Auth-Email: $CF_USER" \
    -H "X-Auth-Key: $CF_SECRET" \
    -H "Content-Type: application/json" \
    --data '{"purge_everything":true}'
