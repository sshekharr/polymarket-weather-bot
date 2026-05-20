# Documentation

| Document | Who it is for |
|----------|----------------|
| [GETTING_STARTED.md](./GETTING_STARTED.md) | **Non-programmers** — Windows, Docker, Vercel |
| [DOCKER.md](./DOCKER.md) | **Docker** one-click |
| [VERCEL.md](./VERCEL.md) | **Vercel** (health API only — not trading) |
| [SECURITY_AUDIT.md](./SECURITY_AUDIT.md) | **Security review** — full 8-phase audit |
| [SAFE_EXECUTION.md](./SAFE_EXECUTION.md) | **Operators** — firewall, burner wallet |

## One-click scripts

### Windows — local PC

| Script | What it does |
|--------|----------------|
| `scripts\run-local.bat` | Safe — **no real money** |
| `scripts\run-local-paper.bat` | Paper — virtual balance |
| `scripts\run-production.bat` | Live — **real money** + `.env` |
| `scripts\run-positions.bat` | Show paper positions (works in cmd; fixes PowerShell npm block) |
| `scripts\run-reset.bat` | Reset virtual $1000 balance |

### Windows — Docker

| Script | What it does |
|--------|----------------|
| `scripts\docker-run-local.bat` | Safe in container |
| `scripts\docker-run-local-paper.bat` | Paper in container |
| `scripts\docker-run-production.bat` | Live in container + `.env` |

### Vercel (monitoring only)

| Script | What it does |
|--------|----------------|
| `scripts\vercel-deploy-local.bat` | Preview deploy `/api/health` |
| `scripts\vercel-deploy-production.bat` | Production health API — **not trading** |

macOS/Linux: `chmod +x scripts/*.sh` — see [GETTING_STARTED.md](./GETTING_STARTED.md).
