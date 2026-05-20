#!/usr/bin/env bash
# Paper mode on PC (macOS / Linux) — virtual money only
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

bash "$ROOT/scripts/security-preflight.sh"
if [[ -f package-lock.json ]]; then npm ci; else npm install; fi
bash "$ROOT/scripts/docker-init-data.sh"
export SIMULATION_FILE="$ROOT/data/simulation.json"
npm run paper
