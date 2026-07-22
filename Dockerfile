ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG ALLOY_VERSION=v1.18.0
ARG BUILD_ARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip gettext-base ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

RUN case "${BUILD_ARCH}" in \
        amd64) ALLOY_ARCH="amd64" ;; \
        aarch64) ALLOY_ARCH="arm64" ;; \
        *) echo "Unsupported arch: ${BUILD_ARCH}" && exit 1 ;; \
    esac \
    && curl -fsSL -o /tmp/alloy.zip \
        "https://github.com/grafana/alloy/releases/download/${ALLOY_VERSION}/alloy-linux-${ALLOY_ARCH}.zip" \
    && unzip /tmp/alloy.zip -d /tmp \
    && mv "/tmp/alloy-linux-${ALLOY_ARCH}" /usr/bin/alloy \
    && chmod +x /usr/bin/alloy \
    && rm -f /tmp/alloy.zip

COPY rootfs /

CMD [ "/run.sh" ]
