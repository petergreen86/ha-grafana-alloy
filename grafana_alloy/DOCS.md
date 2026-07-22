# Grafana Alloy

Runs [Grafana Alloy](https://grafana.com/docs/alloy/) inside a Home Assistant add-on. It scrapes the Home Assistant Prometheus metrics endpoint and remote-writes the metrics to Grafana Cloud.

## Prerequisites

### 1. Enable the Prometheus integration in Home Assistant

Add this to your `configuration.yaml` and restart Home Assistant:

```yaml
prometheus:
```

This exposes metrics at `/api/prometheus`. The add-on reaches it through the Supervisor proxy (`http://supervisor/core/api/prometheus`) using the add-on's Supervisor token, so no long-lived access token is required.

### 2. Get your Grafana Cloud Prometheus credentials

In Grafana Cloud: **Home → Connections → Add new connection → Prometheus / Hosted metrics**, or under **My Account → Stack → Prometheus → Send Metrics**. You need:

- **Remote write endpoint** — e.g. `https://prometheus-prod-XX-prod-REGION.grafana.net/api/prom/push`
- **Username / instance ID** — a numeric ID
- **API token / password** — a Grafana Cloud access policy token with `metrics:write` scope

## Configuration

| Option | Description |
|--------|-------------|
| `prometheus_url` | Grafana Cloud remote-write endpoint (must end in `/api/prom/push`). |
| `prometheus_username` | Grafana Cloud instance ID / username. |
| `api_key` | Grafana Cloud access policy token. |
| `scrape_interval` | How often to scrape HA metrics (e.g. `60s`). |

Example:

```yaml
prometheus_url: "https://prometheus-prod-13-prod-us-east-0.grafana.net/api/prom/push"
prometheus_username: "1234567"
api_key: "glc_eyJ..."
scrape_interval: "60s"
```

## Verifying

- Add-on log shows `Starting Grafana Alloy` and no remote-write errors.
- The Alloy UI is reachable via **Ingress** — open the add-on and click **Open Web UI** (or the Alloy sidebar panel). Note: Alloy serves some UI assets from absolute paths, so parts of the UI may not render fully behind the Ingress subpath; scraping and remote-write are unaffected.
- In Grafana Cloud, query `up{instance="homeassistant"}` — it should report `1`.

## Troubleshooting

- **401/403 on scrape** — confirm the Prometheus integration is enabled and `homeassistant_api: true` is set (it is, in this add-on).
- **401 on remote write** — check the token scope and that `prometheus_username` matches the instance ID for the endpoint's region.
- **No metrics** — confirm `up{instance="homeassistant"}` and check the add-on log for `remote_write` errors.
