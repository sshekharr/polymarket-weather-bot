#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo "Vercel preview deploy - health API only (no wallet keys)"
npx vercel@latest --yes
