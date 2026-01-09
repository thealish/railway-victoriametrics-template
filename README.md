# VictoriaMetrics Monitoring Stack

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/YOUR_TEMPLATE_ID)

Complete monitoring stack on Railway: metrics collection, storage, and visualization.

## Services

| Service | Port | Visibility | Purpose |
|---------|------|------------|---------|
| victoriametrics | 8428 | Internal | Time series database |
| vmagent | 8429 | Internal | Metrics collector (scrapes your apps) |
| grafana | 3000 | Public | Dashboards |
| auth-proxy | 8080 | Public | External API access with API key |

## How It Works

```
Your Railway Apps (/metrics) <--- vmagent (scrapes) ---> VictoriaMetrics
                                                               |
External Apps ---> Auth Proxy (API Key) ---------------------->|
                                                               v
                                            Grafana (dashboards)
```

## Configuration

### VictoriaMetrics

| Variable | Description | Default |
|----------|-------------|---------|
| `RETENTION_PERIOD` | Data retention in months | `1` |
| `SEARCH_LATENCY_OFFSET` | Time offset for queries | `30s` |
| `MAX_UNIQUE_TIMESERIES` | Max unique time series | `300000` |

### vmagent

| Variable | Description | Default |
|----------|-------------|---------|
| `SCRAPE_INTERVAL` | How often to scrape targets | `15s` |
| `SCRAPE_TARGETS` | Targets to scrape (see below) | None |

### Grafana

| Variable | Description | Default |
|----------|-------------|---------|
| `GF_SECURITY_ADMIN_USER` | Admin username | `admin` |
| `GF_SECURITY_ADMIN_PASSWORD` | Admin password | `admin` |

### Auth Proxy

| Variable | Description | Required |
|----------|-------------|----------|
| `API_KEY` | API key for external access | Yes |

## Adding Scrape Targets

Configure vmagent to scrape your apps by setting `SCRAPE_TARGETS`:

```
SCRAPE_TARGETS=myapp:myapp.railway.internal:3000/metrics,api:api.railway.internal:8080/metrics
```

Format: `jobname:host:port/path`

Your apps need to expose a `/metrics` endpoint in Prometheus format.

## Usage

### Grafana

Access Grafana at your Railway domain. VictoriaMetrics is pre-configured as datasource.

Default login: `admin` / `admin` (change via env vars)

### External Metrics (via Auth Proxy)

For apps outside Railway, push metrics through the auth proxy:

```yaml
# prometheus.yml
remote_write:
  - url: https://YOUR_AUTH_PROXY_DOMAIN/api/v1/write
    headers:
      X-API-Key: your-api-key
```

### Query API

```bash
curl -H "X-API-Key: your-api-key" \
  "https://YOUR_AUTH_PROXY_DOMAIN/api/v1/query?query=up"
```

## Exposing Metrics from Your Apps

Add a `/metrics` endpoint to your Railway apps. Example for Node.js:

```javascript
const client = require('prom-client');
client.collectDefaultMetrics();

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});
```

Then add your app to vmagent's `SCRAPE_TARGETS`.

## Resources

- [VictoriaMetrics Docs](https://docs.victoriametrics.com/)
- [vmagent Docs](https://docs.victoriametrics.com/vmagent/)
- [Grafana Docs](https://grafana.com/docs/)
- [Railway Docs](https://docs.railway.app/)
