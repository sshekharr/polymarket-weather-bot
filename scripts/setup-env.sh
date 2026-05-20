#!/usr/bin/env bash
# Create or fix .env from .env.example (macOS / Linux)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo ""
echo "==> Environment file setup (.env)"

if [[ ! -f .env.example ]]; then
  echo "FAIL: .env.example is missing"
  exit 1
fi

NEED_EDIT=0
if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "OK: Created .env from .env.example"
  NEED_EDIT=1
else
  echo "OK: .env already exists"
fi

if grep -qE 'YOUR_METAMASK|YOUR_POLYMARKET|0xYOUR' .env 2>/dev/null; then
  NEED_EDIT=1
fi

if [[ "$NEED_EDIT" == 1 ]]; then
  echo ""
  echo "--------------------------------------------------------"
  echo " EDIT .env BEFORE LIVE TRADING"
  echo "--------------------------------------------------------"
  echo " 1. Use a NEW burner wallet - never your main account"
  echo " 2. POLYMARKET_PRIVATE_KEY = 64 hex characters"
  echo " 3. POLYMARKET_PROXY_WALLET_ADDRESS = polymarket.com/settings"
  echo " 4. Fund only small pUSD you can afford to lose"
  echo "--------------------------------------------------------"
  echo ""
  if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Opening .env in TextEdit..."
    open -e .env || true
    echo "Save in TextEdit, then press Enter here..."
    read -r
  elif [[ -n "${EDITOR:-}" ]]; then
    $EDITOR .env
  else
    nano .env
  fi
fi

if grep -qE 'YOUR_METAMASK|YOUR_POLYMARKET|0xYOUR' .env; then
  echo "FAIL: .env still has placeholder values"
  exit 1
fi

if ! grep -qE '^POLYMARKET_PRIVATE_KEY=' .env; then
  echo "FAIL: POLYMARKET_PRIVATE_KEY missing in .env"
  exit 1
fi

if ! grep -qE '^POLYMARKET_PROXY_WALLET_ADDRESS=' .env; then
  echo "FAIL: POLYMARKET_PROXY_WALLET_ADDRESS missing in .env"
  exit 1
fi

echo "OK: .env is ready"
exit 0
