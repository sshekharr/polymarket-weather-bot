#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
[ -f .env ] || { echo "Create .env from .env.example"; exit 1; }
read -r -p "Type YES for LIVE Docker trading: " c
[ "$c" = "YES" ] || exit 0
bash "$(dirname "$0")/docker-init-data.sh"
docker compose --profile production up --build
