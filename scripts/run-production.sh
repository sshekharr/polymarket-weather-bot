#!/usr/bin/env bash
# One-click PRODUCTION — real orders, burner wallet only
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo ""
echo "========================================"
echo "  PRODUCTION / LIVE TRADING"
echo "  Real money — burner wallet ONLY"
echo "========================================"
echo ""
read -r -p "Type YES to continue with LIVE trading: " confirm
if [ "$confirm" != "YES" ]; then
  echo "Cancelled."
  exit 0
fi

bash "$ROOT/scripts/security-preflight.sh" --require-env

npm install
bash "$ROOT/scripts/security-preflight.sh" --require-env
npm run build
npm run execute
