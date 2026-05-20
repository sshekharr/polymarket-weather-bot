# Vercel — What It Can and Cannot Do

## Important

**Vercel is NOT for live Polymarket trading.**

| Feature | Vercel | Docker / local scripts |
|---------|--------|-------------------------|
| Long-running bot loop | No (serverless timeout) | Yes |
| Store private key safely | **Never put keys on Vercel** | `.env` on your PC |
| Real `--execute` orders | **Not supported** | Yes |
| Health / connectivity check | Yes | Yes |

## What we deploy to Vercel

| URL | Purpose |
|-----|---------|
| `/api/health` | Status + security notice (no secrets) |
| `/api/connectivity-check` | Public gamma-api ping (read-only) |

## One-click deploy (Windows)

| Script | Action |
|--------|--------|
| `scripts\vercel-deploy-local.bat` | Preview deploy (`npx vercel`) |
| `scripts\vercel-deploy-production.bat` | Production deploy — **health API only** |

## First-time Vercel setup

1. Create account: https://vercel.com
2. Install Node.js (for `npx vercel`).
3. Double-click `scripts\vercel-deploy-local.bat`.
4. Log in in the browser when prompted.
5. Open the URL shown + `/api/health`.

## Environment variables on Vercel

**Do not add:**

- `POLYMARKET_PRIVATE_KEY`
- `POLYMARKET_PROXY_WALLET_ADDRESS`

If you need automation with real money, use **Docker** on a VPS or your PC with [DOCKER.md](./DOCKER.md), not Vercel.

## Live trading path

Use one of:

- `scripts\run-production.bat`
- `scripts\docker-run-production.bat`
