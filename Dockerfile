ARG OPENCLAW_VERSION=latest

FROM openclaw/openclaw:${OPENCLAW_VERSION}

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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
    rm -rf /var/lib/apt/lists/*

RUN wget -qO- https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor \
    > /usr/share/keyrings/google.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/entrypoint.sh /opt/openclaw-desktop/
COPY scripts/fixuid.sh     /opt/openclaw-desktop/
COPY scripts/launcher.sh   /opt/openclaw-desktop/
COPY scripts/lib.sh        /opt/openclaw-desktop/
RUN chmod +x /opt/openclaw-desktop/*.sh

ENTRYPOINT ["/opt/openclaw-desktop/entrypoint.sh"]
