#!/bin/bash
set -e

CADDYFILE="/etc/caddy/Caddyfile"
UPSTREAM_URL="http://victoriametrics.railway.internal:8428"

if [ -z "$API_KEY" ]; then
    echo "ERROR: API_KEY environment variable is required"
    exit 1
fi

echo "Auth proxy starting..."

cat > "$CADDYFILE" <<EOF
{
    admin off
    auto_https off
}

:8080 {
    @valid_api_key header X-API-Key ${API_KEY}
    @valid_bearer header Authorization "Bearer ${API_KEY}"

    handle /health {
        respond "OK" 200
    }

    handle @valid_api_key {
        reverse_proxy ${UPSTREAM_URL} {
            header_up Host {upstream_hostport}
            header_up X-Real-IP {remote_host}
            header_up -X-API-Key
        }
    }

    handle @valid_bearer {
        reverse_proxy ${UPSTREAM_URL} {
            header_up Host {upstream_hostport}
            header_up X-Real-IP {remote_host}
            header_up -Authorization
        }
    }

    respond "Unauthorized" 401
}
EOF

exec caddy run --config "$CADDYFILE" --adapter caddyfile
