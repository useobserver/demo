#!/bin/sh
# Pushes one log line to Loki every 10 seconds so the demo LogQL
# aggregation (count_over_time) always has fresh data.
set -eu

echo "loki-logger: waiting for loki..."
until curl -sf http://loki:3100/ready >/dev/null 2>&1; do sleep 2; done
echo "loki-logger: pushing a line every 10s"

while true; do
  ns="$(date +%s)000000000"
  curl -sf -X POST http://loki:3100/loki/api/v1/push \
    -H 'Content-Type: application/json' \
    -d "{\"streams\":[{\"stream\":{\"app\":\"demo\",\"level\":\"info\"},\"values\":[[\"${ns}\",\"demo heartbeat tick\"]]}]}" \
    >/dev/null || echo "loki-logger: push failed (loki restarting?)"
  sleep 10
done
