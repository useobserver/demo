#!/bin/sh
# Indexes one document into Elasticsearch every 15 seconds so the demo
# aggregation (value_count over the last 5 minutes) always has data.
set -eu

echo "es-seeder: waiting for elasticsearch..."
until curl -sf http://elasticsearch:9200/_cluster/health >/dev/null 2>&1; do sleep 3; done

# Index with an explicit date mapping so @timestamp range queries work.
curl -sf -X PUT http://elasticsearch:9200/demo-events \
  -H 'Content-Type: application/json' \
  -d '{"mappings":{"properties":{"@timestamp":{"type":"date"},"kind":{"type":"keyword"}}}}' \
  >/dev/null 2>&1 || true

echo "es-seeder: indexing a document every 15s"
while true; do
  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  curl -sf -X POST http://elasticsearch:9200/demo-events/_doc \
    -H 'Content-Type: application/json' \
    -d "{\"@timestamp\":\"${now}\",\"kind\":\"tick\"}" \
    >/dev/null || echo "es-seeder: index failed (es restarting?)"
  sleep 15
done
