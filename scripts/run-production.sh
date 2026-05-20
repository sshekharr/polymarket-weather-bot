#!/usr/bin/env bash
# One-click PRODUCTION — real Polymarket orders (macOS / Linux). Burner wallet only.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo ""
echo "========================================"
echo "  PRODUCTION / LIVE TRADING"
echo "  Real money - burner wallet ONLY"
echo "========================================"
echo ""
echo "Use a NEW burner wallet and small pUSD only."
echo ""

bash "$ROOT/scripts/setup-env.sh"

read -r -p "Type YES to continue with LIVE trading: " confirm
if [[ "$confirm" != "YES" ]]; then
  echo "Cancelled."
  exit 0
fi

bash "$ROOT/scripts/security-preflight.sh" --require-env
bash "$ROOT/scripts/docker-init-data.sh"

echo ""
echo "==> Installing dependencies..."
if [[ -f package-lock.json ]]; then
  npm ci
else
  npm install
fi

bash "$ROOT/scripts/security-preflight.sh" --require-env

echo ""
echo "==> Building..."
npm run build

if [[ -f "$ROOT/data/simulation.json" ]]; then
  export SIMULATION_FILE="$ROOT/data/simulation.json"
fi

echo ""
echo "==> Starting LIVE trading..."
npm run execute

echo ""
echo "Done."
