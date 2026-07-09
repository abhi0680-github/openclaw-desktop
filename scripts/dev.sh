#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

#
# Detect docker compose
#

if command -v docker-compose >/dev/null 2>&1
then
    COMPOSE="docker-compose"
else
    COMPOSE="docker compose"
fi

#
# Create runtime directories
#

prepare_runtime()
{
    mkdir -p \
        logs \
        workspace \
        openclaw-home
}

#
# Update UID/GID inside .env
#

update_env()
{
    [ -f .env ] || cp .env.example .env

    grep -v '^HOST_UID=' .env |
    grep -v '^HOST_GID=' > .env.tmp

    cat >> .env.tmp <<EOF
HOST_UID=$(id -u)
HOST_GID=$(id -g)
EOF

    mv .env.tmp .env
}

prepare_runtime
update_env

case "${1:-help}" in

build)

    $COMPOSE build

;;

up)

    $COMPOSE up

;;

down)

    $COMPOSE down

;;

logs)

    $COMPOSE logs -f

;;

shell)

    docker exec -it openclaw-desktop bash

;;

rebuild)

    $COMPOSE down

    $COMPOSE build --no-cache

    $COMPOSE up

;;

clean)

    $COMPOSE down -v

;;

health)

    docker ps

;;

*)

cat <<EOF

Usage

build
up
down
logs
shell
rebuild
clean
health

EOF

;;

esac
