#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo "Docker LOCAL (signal) — no real money"
command -v docker >/dev/null || { echo "Install Docker Desktop"; exit 1; }
bash "$(dirname "$0")/docker-init-data.sh"
docker compose --profile local up --build --abort-on-container-exit
