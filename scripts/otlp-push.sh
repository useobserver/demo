#!/bin/sh
# Pushes an OTLP/HTTP JSON gauge (demo.queue.depth) to the Observer
# agent's built-in OTLP receiver every 15 seconds.
#
# The value is the current clock second (0-59), so the metric sweeps
# through its healthy (<45) / degraded / unhealthy (>55) thresholds about
# once a minute — deliberately, so the demo shows live status flips.
set -eu

echo "otlp-pusher: waiting for the agent's OTLP receiver..."
sleep 10

echo "otlp-pusher: pushing demo.queue.depth every 15s"
while true; do
  val="$(date +%S | sed 's/^0//')"
  [ -z "$val" ] && val=0
  ns="$(date +%s)000000000"
  curl -sf -X POST "http://observer-agent:4318/v1/metrics" \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${OTLP_TOKEN}" \
    -d "{
      \"resourceMetrics\": [{
        \"resource\": { \"attributes\": [{ \"key\": \"service.name\", \"value\": { \"stringValue\": \"demo-queue\" } }] },
        \"scopeMetrics\": [{
          \"metrics\": [{
            \"name\": \"demo.queue.depth\",
            \"gauge\": { \"dataPoints\": [{ \"timeUnixNano\": \"${ns}\", \"asDouble\": ${val} }] }
          }]
        }]
      }]
    }" >/dev/null || echo "otlp-pusher: push failed (agent starting?)"
  sleep 15
done
