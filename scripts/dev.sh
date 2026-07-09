#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

source scripts/lib.sh

generate_runtime_env()
{
    cat > .env.runtime <<EOF
HOST_UID=$(id -u)
HOST_GID=$(id -g)
EOF
}

require_command docker

generate_runtime_env

case "${1:-help}" in

build)

    docker compose build

;;

up)

    docker compose up

;;

down)

    docker compose down

;;

logs)

    docker compose logs -f

;;

shell)

    docker exec -it openclaw-desktop bash

;;

rebuild)

    docker compose down

    docker compose build --no-cache

    docker compose up

;;

clean)

    docker compose down -v

;;

health)

    docker ps

;;

*)

cat <<EOF

Usage:

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
