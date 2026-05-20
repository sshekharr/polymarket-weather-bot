# Documentation

| Document | Audience |
|----------|----------|
| [GETTING_STARTED.md](./GETTING_STARTED.md) | **Everyone** — Windows, macOS, Linux, Docker, Vercel |
| [../scripts/PRODUCTION.md](../scripts/PRODUCTION.md) | **Live trading** — all production scripts by OS |
| [DOCKER.md](./DOCKER.md) | Docker one-click |
| [VERCEL.md](./VERCEL.md) | Vercel (health only) |
| [SECURITY_AUDIT.md](./SECURITY_AUDIT.md) | Security audit |
| [SAFE_EXECUTION.md](./SAFE_EXECUTION.md) | Hardening |

## Production (live trading) — by OS

| OS | Setup `.env` | Live on PC | Live in Docker |
|----|--------------|------------|----------------|
| **Windows** | `scripts\setup-env.cmd` | `scripts\run-production.bat` | `scripts\docker-run-production.bat` |
| **macOS / Linux** | `./scripts/setup-env.sh` | `./scripts/run-production.sh` | `./scripts/docker-run-production.sh` |

All production scripts: create `.env` → confirm `YES` → preflight → install → build → execute.

**Vercel:** monitoring only — not for trading.

## Safe / paper (no real money)

| OS | Signal | Paper |
|----|--------|-------|
| Windows | `run-local.bat` | `run-local-paper.bat` |
| macOS / Linux | `run-local.sh` | `npm run paper` |
| Docker | `docker-run-local.bat` / `.sh` | `docker-run-local-paper.bat` |
