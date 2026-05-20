#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo "Vercel production deploy - health API only (NOT live trading)"
read -r -p "Type YES to deploy: " c
[[ "$c" == "YES" ]] || exit 0
npx vercel@latest --prod --yes
