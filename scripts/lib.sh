#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT="openclaw-desktop"

log()
{
    printf "\n[%s] %s\n" "$PROJECT" "$*"
}

warn()
{
    printf "\n[%s] WARNING: %s\n" "$PROJECT" "$*" >&2
}

die()
{
    printf "\n[%s] ERROR: %s\n" "$PROJECT" "$*" >&2
    exit 1
}

require_command()
{
    command -v "$1" >/dev/null 2>&1 \
        || die "Required command '$1' not found."
}
