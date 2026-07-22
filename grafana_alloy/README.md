# Home Assistant Add-on: Grafana Alloy

Scrape Home Assistant's Prometheus metrics with [Grafana Alloy](https://grafana.com/docs/alloy/) and remote-write them to Grafana Cloud.

## How it works

```
Home Assistant  --/api/prometheus-->  Grafana Alloy  --remote_write-->  Grafana Cloud
   (prometheus integration)          (this add-on)                     (hosted metrics)
```

Alloy scrapes HA through the Supervisor proxy using the add-on's Supervisor token — no long-lived access token needed. See [DOCS.md](DOCS.md) for setup and configuration.

## Quick start

1. Enable the Prometheus integration in HA (`prometheus:` in `configuration.yaml`, then restart).
2. Install this add-on, fill in your Grafana Cloud endpoint, username, and token.
3. Start the add-on and query `up{instance="homeassistant"}` in Grafana.
