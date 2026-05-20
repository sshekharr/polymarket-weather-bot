#!/usr/bin/env bash
# One-click LOCAL mode (macOS/Linux) — signal scan, no real orders
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo ""
echo "========================================"
echo "  LOCAL / SAFE MODE (no real money)"
echo "========================================"
echo ""

bash "$ROOT/scripts/security-preflight.sh"

echo "==> npm install"
npm install
bash "$ROOT/scripts/security-preflight.sh"

echo "==> npm run build"
npm run build

echo "==> npm run signal (dry-run)"
npm run signal
