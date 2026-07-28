ARG OPENCLAW_VERSION=latest

FROM openclaw/openclaw:${OPENCLAW_VERSION}

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        supervisor \
        gosu \
        openbox \
        novnc \
        websockify \
        wget \
        curl \
        gnupg \
        x11-utils \
        x11vnc \
        xdotool \
        xvfb \
        supervisor \
        procps \
        ca-certificates && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

RUN wget -qO- https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor \
    > /usr/share/keyrings/google.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/ /opt/openclaw-desktop/
COPY supervisor/ /etc/supervisor/
RUN chmod +x /opt/openclaw-desktop/*.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD pgrep -f "openclaw gateway" >/dev/null || exit 1

ENTRYPOINT ["/opt/openclaw-desktop/entrypoint.sh"]
