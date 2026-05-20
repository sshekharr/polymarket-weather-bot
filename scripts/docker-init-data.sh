#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
DATA="$ROOT/data"
SIM="$DATA/simulation.json"
LEGACY="$ROOT/simulation.json"

if [ -d "$LEGACY" ]; then
  echo "Removing mistaken simulation.json directory..."
  rm -rf "$LEGACY"
fi

mkdir -p "$DATA"
if [ ! -f "$SIM" ]; then
  cat >"$SIM" <<'EOF'
{
  "balance": 1000,
  "starting_balance": 1000,
  "positions": {},
  "trades": [],
  "total_trades": 0,
  "wins": 0,
  "losses": 0,
  "peak_balance": 1000
}
EOF
  echo "Created data/simulation.json"
fi
