#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT="openclaw-desktop"

#
# Directories
#

CONFIG_DIR="/config"
LOG_DIR="/logs"

OPENCLAW_HOME="/home/node/.openclaw"

#
# Logging
#

_timestamp()
{
    date "+%Y-%m-%d %H:%M:%S"
}

log_info()
{
    printf "[%s] [INFO ] %s\n" "$(_timestamp)" "$*"
}

log_warn()
{
    printf "[%s] [WARN ] %s\n" "$(_timestamp)" "$*" >&2
}

log_error()
{
    printf "[%s] [ERROR] %s\n" "$(_timestamp)" "$*" >&2
}

die()
{
    log_error "$*"
    exit 1
}

#
# Utilities
#

require_command()
{
    command -v "$1" >/dev/null 2>&1 \
        || die "Required command '$1' not found."
}

run_hooks()
{
    local hook

    [ -d "${CONFIG_DIR}/hooks" ] || return

    for hook in "${CONFIG_DIR}"/hooks/*.sh
    do
        [ -f "$hook" ] || continue

        log_info "Running hook: $(basename "$hook")"

        bash "$hook"
    done
}
