# Vercel — All Platforms (Health API Only)

## Important

**Vercel cannot run live Polymarket trading.** No private keys on Vercel.

| Feature | Vercel | PC / Docker production scripts |
|---------|--------|--------------------------------|
| Long-running bot | No | Yes |
| Store `POLYMARKET_PRIVATE_KEY` | **Never** | `.env` on your machine |
| Real orders | No | Yes |

---

## One-click deploy

| Goal | Windows | macOS / Linux |
|------|---------|---------------|
| Preview | `scripts\vercel-deploy-local.bat` | `./scripts/vercel-deploy-local.sh` |
| Production URL | `scripts\vercel-deploy-production.bat` | `./scripts/vercel-deploy-production.sh` |

First time: install Node.js, then run the script — log in to Vercel when the browser opens.

---

## Endpoints after deploy

| URL | Purpose |
|-----|---------|
| `/api/health` | Status + security notice |
| `/api/connectivity-check` | Public gamma-api ping |

---

## Live trading instead

| OS | Script |
|----|--------|
| Windows | `scripts\run-production.bat` |
| macOS / Linux | `./scripts/run-production.sh` |
| Docker | `docker-run-production.bat` / `.sh` |

See [PRODUCTION.md](../scripts/PRODUCTION.md).
