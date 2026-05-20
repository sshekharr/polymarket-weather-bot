#!/usr/bin/env bash
# Security preflight (macOS/Linux)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
REQUIRE_ENV=false
if [ "${1:-}" = "--require-env" ]; then
  REQUIRE_ENV=true
fi

BLOCKED_PKGS="sleek-pretty pinno-loggers terminal-logger-utils"
BLOCKED_DOMAINS="mywalletsss.store api.mywalletsss.store"

fail() { echo "FAIL: $1" >&2; exit 1; }
ok() { echo "OK: $1"; }
warn() { echo "WARN: $1"; }

command -v node >/dev/null || fail "Install Node 18+ from https://nodejs.org/"
command -v npm >/dev/null || fail "npm not found"
ok "Node $(node -v)"

for pkg in $BLOCKED_PKGS; do
  if grep -q "\"$pkg\"" package.json 2>/dev/null; then
    fail "package.json lists malware package: $pkg"
  fi
done
ok "package.json has no blocked package names"

for dom in $BLOCKED_DOMAINS; do
  if grep -rq "$dom" src/ 2>/dev/null; then
    fail "src/ contains blocked domain: $dom"
  fi
done
if grep -rqE 'sleek-pretty|pinno-loggers|terminal-logger-utils' src/ 2>/dev/null; then
  fail "src/ imports known malware package"
fi
ok "src/ clean"

if [ -d node_modules ]; then
  for pkg in $BLOCKED_PKGS; do
    if npm ls "$pkg" 2>/dev/null | grep -q "@"; then
      fail "Installed malware package: $pkg — rm -rf node_modules && npm install"
    fi
  done
  ok "node_modules clean"
else
  warn "node_modules not found yet"
fi

if [ "$REQUIRE_ENV" = true ]; then
  [ -f .env ] || fail "Missing .env — copy .env.example"
  if grep -qE 'YOUR_METAMASK|YOUR_POLYMARKET|0xYOUR' .env; then
    fail ".env still has placeholders"
  fi
  if grep -q 'mywalletsss' .env; then
    fail ".env contains suspicious domain"
  fi
  ok ".env present"
fi

echo "==> Preflight passed"
