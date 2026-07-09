#!/usr/bin/env bash

set -Eeuo pipefail

source /opt/openclaw-desktop/lib.sh

log_info "OpenClaw Desktop starting"

require_command gosu
require_command Xvfb
require_command x11vnc
require_command openbox

/opt/openclaw-desktop/fixuid.sh

run_hooks

exec /opt/openclaw-desktop/launcher.sh
