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
    echo "" >> "$CONFIG_FILE"
    IFS=',' read -ra TARGETS <<< "$SCRAPE_TARGETS"
    for target in $SCRAPE_TARGETS; do
        # Split by colon - format is "jobname:url"
        job=$(echo "$target" | cut -d':' -f1)
        url=$(echo "$target" | cut -d':' -f2-)
        
        cat >> "$CONFIG_FILE" <<EOF
  - job_name: '${job}'
    static_configs:
      - targets: ['${url}']
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

