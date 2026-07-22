ARG ALLOY_VERSION=v1.18.0

# Pull the Alloy binary straight from Grafana's official multi-arch image.
# buildx --platform selects the matching arch; no download or unzip needed.
FROM grafana/alloy:${ALLOY_VERSION} AS alloy

FROM ghcr.io/hassio-addons/debian-base:7.8.2
COPY --from=alloy /bin/alloy /usr/bin/alloy
COPY rootfs /

CMD [ "/run.sh" ]
