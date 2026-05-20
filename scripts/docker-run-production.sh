#!/usr/bin/env bash
# Docker PRODUCTION — real money (macOS / Linux). Burner wallet only.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo ""
echo "========================================"
echo "  DOCKER PRODUCTION - REAL MONEY"
echo "  Burner wallet only"
echo "========================================"
echo ""

bash "$ROOT/scripts/setup-env.sh"

read -r -p "Type YES to run LIVE trading in Docker: " confirm
if [[ "$confirm" != "YES" ]]; then
  echo "Cancelled."
  exit 0
fi

bash "$ROOT/scripts/security-preflight.sh" --require-env
bash "$ROOT/scripts/docker-init-data.sh"

docker compose --profile production up --build
