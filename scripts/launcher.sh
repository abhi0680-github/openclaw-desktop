#!/usr/bin/env bash

set -Eeuo pipefail

source /opt/openclaw-desktop/lib.sh

DISPLAY_NUM="${DISPLAY_NUM:-99}"

DISPLAY_WIDTH="${DISPLAY_WIDTH:-1920}"
DISPLAY_HEIGHT="${DISPLAY_HEIGHT:-1080}"
DISPLAY_DEPTH="${DISPLAY_DEPTH:-24}"

export DISPLAY=":${DISPLAY_NUM}"

mkdir -p "${LOG_DIR}"

#
# Start X server
#

log_info "Starting Xvfb..."

Xvfb "${DISPLAY}" \
    -screen 0 "${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x${DISPLAY_DEPTH}" \
    -ac \
    +extension RANDR \
    >"${LOG_DIR}/xvfb.log" 2>&1 &

XVFB_PID=$!

sleep 2

if ! kill -0 "${XVFB_PID}" 2>/dev/null
then
    die "Xvfb failed to start."
fi

#
# Start Openbox
#

log_info "Starting Openbox..."

openbox \
    >"${LOG_DIR}/openbox.log" 2>&1 &

OPENBOX_PID=$!

sleep 2

#
# Start x11vnc
#

log_info "Starting x11vnc..."

x11vnc \
    -display "${DISPLAY}" \
    -forever \
    -shared \
    -nopw \
    -rfbport 5900 \
    >"${LOG_DIR}/x11vnc.log" 2>&1 &

X11VNC_PID=$!

sleep 2

#
# Start noVNC
#

log_info "Starting noVNC..."

if [ -x /usr/share/novnc/utils/novnc_proxy ]
then

    /usr/share/novnc/utils/novnc_proxy \
        --listen 6080 \
        --vnc localhost:5900 \
        >"${LOG_DIR}/novnc.log" 2>&1 &

else

    websockify \
        --web=/usr/share/novnc \
        6080 \
        localhost:5900 \
        >"${LOG_DIR}/novnc.log" 2>&1 &

fi

sleep 2

#
# Diagnostics
#


log_info "======================================="
log_info "Runtime Diagnostics"
log_info "======================================="
log_info "DISPLAY=${DISPLAY}"
log_info "HOME=/home/node"
log_info "Workspace=/workspace"
log_info "OpenClaw Home=/home/node/.openclaw"
log_info "Chrome=$(google-chrome --version)"

if [ -f /home/node/.openclaw/openclaw.json ]
then
    log_info "Config: installed"
else
    log_warn "Config: not found"
fi
log_info "======================================="

#
# Prepare OpenClaw home
#
mkdir -p \
    /workspace

chown -R node:node \
    /workspace

#
# Install config if supplied
#
#if [ -f /config/openclaw.json ]
#then
#    log_info "Installing openclaw.json"
#    cp \
#        /config/openclaw.json \
#        /home/node/.openclaw/openclaw.json
#    chown node:node \
#        /home/node/.openclaw/openclaw.json
#fi

log_info "Launching OpenClaw..."
exec gosu node bash -c "
export DISPLAY=${DISPLAY}
exec openclaw gateway
"
