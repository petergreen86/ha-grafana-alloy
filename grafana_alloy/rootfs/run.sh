#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

export GRAFANA_CLOUD_PROMETHEUS_URL
export GRAFANA_CLOUD_PROMETHEUS_USER
export GRAFANA_CLOUD_API_KEY
export SCRAPE_INTERVAL

GRAFANA_CLOUD_PROMETHEUS_URL="$(bashio::config 'prometheus_url')"
GRAFANA_CLOUD_PROMETHEUS_USER="$(bashio::config 'prometheus_username')"
GRAFANA_CLOUD_API_KEY="$(bashio::config 'api_key')"
SCRAPE_INTERVAL="$(bashio::config 'scrape_interval')"

if bashio::config.is_empty 'prometheus_url'; then
    bashio::exit.nok "prometheus_url is not set"
fi
if bashio::config.is_empty 'prometheus_username'; then
    bashio::exit.nok "prometheus_username is not set"
fi
if bashio::config.is_empty 'api_key'; then
    bashio::exit.nok "api_key is not set"
fi

bashio::log.info "Rendering Alloy config (scrape_interval=${SCRAPE_INTERVAL})"
envsubst '${SCRAPE_INTERVAL}' \
    < /etc/alloy/config.alloy.tmpl \
    > /etc/alloy/config.alloy

bashio::log.info "Starting Grafana Alloy"
exec alloy run /etc/alloy/config.alloy \
    --storage.path=/data \
    --server.http.listen-addr=0.0.0.0:12345
