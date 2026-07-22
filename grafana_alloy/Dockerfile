ARG ALLOY_VERSION=v1.18.0

# Download and extract Alloy in a throwaway stage so unzip and the archive
# never land in the final image (curl and ca-certificates ship in the base).
FROM ghcr.io/hassio-addons/debian-base:7.8.2 AS downloader
ARG ALLOY_VERSION
ARG BUILD_ARCH
RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/* \
    && case "${BUILD_ARCH}" in \
        amd64) ALLOY_ARCH="amd64" ;; \
        aarch64) ALLOY_ARCH="arm64" ;; \
        *) echo "Unsupported arch: ${BUILD_ARCH}" && exit 1 ;; \
    esac \
    && curl -fsSL -o /tmp/alloy.zip \
        "https://github.com/grafana/alloy/releases/download/${ALLOY_VERSION}/alloy-linux-${ALLOY_ARCH}.zip" \
    && unzip /tmp/alloy.zip -d /tmp \
    && mv "/tmp/alloy-linux-${ALLOY_ARCH}" /alloy \
    && chmod +x /alloy

FROM ghcr.io/hassio-addons/debian-base:7.8.2
COPY --from=downloader /alloy /usr/bin/alloy
COPY rootfs /

CMD [ "/run.sh" ]
