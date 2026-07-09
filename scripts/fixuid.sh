#!/usr/bin/env bash

set -Eeuo pipefail

source /opt/openclaw-desktop/lib.sh

HOST_UID="${HOST_UID:-1000}"
HOST_GID="${HOST_GID:-1000}"

log_info "Configuring runtime user"

log_info "UID=${HOST_UID}"

log_info "GID=${HOST_GID}"

#
# Change node uid/gid only if necessary
#

CURRENT_UID="$(id -u node)"
CURRENT_GID="$(id -g node)"

if [ "$CURRENT_GID" != "$HOST_GID" ]
then
    groupmod -o -g "$HOST_GID" node
fi

if [ "$CURRENT_UID" != "$HOST_UID" ]
then
    usermod -o -u "$HOST_UID" node
fi

mkdir -p \
    "$LOG_DIR" \
    "$RUNTIME_DIR"

chown -R node:node \
    /home/node \
    "$LOG_DIR" \
    "$RUNTIME_DIR"
