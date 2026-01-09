#!/bin/sh
set -e

CONFIG_FILE="/etc/vmagent/scrape.yml"
REMOTE_WRITE_URL="http://victoriametrics.railway.internal:8428/api/v1/write"

mkdir -p /etc/vmagent

cat > "$CONFIG_FILE" <<EOF
global:
  scrape_interval: ${SCRAPE_INTERVAL:-15s}

scrape_configs:
  - job_name: 'vmagent'
    static_configs:
      - targets: ['localhost:8429']
EOF

if [ -n "$SCRAPE_TARGETS" ]; then
    echo "$SCRAPE_TARGETS" | tr ',' '\n' | while read -r target; do
        job=$(echo "$target" | cut -d':' -f1)
        host_port=$(echo "$target" | cut -d':' -f2-)
        
        cat >> "$CONFIG_FILE" <<EOF
  - job_name: '${job}'
    static_configs:
      - targets: ['${host_port}']
EOF
    done
fi

echo "vmagent starting..."
echo "Remote write: ${REMOTE_WRITE_URL}"
echo "Scrape config:"
cat "$CONFIG_FILE"

exec /vmagent-prod \
    -promscrape.config="$CONFIG_FILE" \
    -remoteWrite.url="$REMOTE_WRITE_URL" \
    -httpListenAddr=:8429
