# Step-by-Step Guide (No Programming Experience)

This bot checks weather forecasts and Polymarket temperature markets. You can run it **without real money** first.

**Rules:**

- Use a **burner wallet** (new MetaMask account) for live trading — never your main wallet.
- **Do not** put your private key on Vercel.
- Production scripts **create `.env` for you** on every OS before live trading.

Full script list: [../scripts/PRODUCTION.md](../scripts/PRODUCTION.md)

---

## Choose how you run the bot

| Way | Windows | macOS / Linux | Real money? |
|-----|---------|---------------|-------------|
| **On your PC** | `run-local.bat` / `run-production.bat` | `run-local.sh` / `run-production.sh` | Production only |
| **Docker** | `docker-run-*.bat` | `docker-run-*.sh` | Production only |
| **Vercel** | `vercel-deploy-*.bat` | `vercel-deploy-*.sh` | **Never** |

---

# Windows

## 1 — Install Node.js (once)

1. **https://nodejs.org/** → download **LTS** → install.
2. In **cmd**: `node -v` should print a version.

## 2 — Safe test (no money)

Double-click **`scripts\run-local.bat`** — no `.env` needed.

## 3 — Paper (fake money)

Double-click **`scripts\run-local-paper.bat`**

## 4 — Live (real money)

1. New **burner** MetaMask account + small pUSD on Polymarket.
2. Double-click **`scripts\run-production.bat`**
3. Notepad opens → paste private key + proxy address → **save** → close.
4. Type **`YES`**.

**`.env` only (no trading):** `scripts\setup-env.cmd`

---

# macOS / Linux

## 1 — Install Node.js (once)

Install from **https://nodejs.org/** or your package manager. Check: `node -v`

## 2 — Make scripts executable (once)

```bash
cd /path/to/polymarket-weather-trading-bot-main
chmod +x scripts/*.sh
```

## 3 — Safe test (no money)

```bash
./scripts/run-local.sh
```

## 4 — Paper (fake money)

```bash
./scripts/run-local-paper.sh
```

Or: `npm run paper` (after `npm ci` and `npm run build`).

## 5 — Live (real money)

```bash
./scripts/run-production.sh
```

1. Creates/edits **`.env`** (TextEdit on Mac, nano on Linux).
2. Type **`YES`**
3. Installs, builds, runs live orders.

**`.env` only:**

```bash
./scripts/setup-env.sh
# or: npm run setup:env:unix
```

---

# Docker (Windows, macOS, Linux)

## Install Docker Desktop

**https://www.docker.com/products/docker-desktop/** — start the app before running scripts.

Details: [DOCKER.md](./DOCKER.md)

| Goal | Windows | macOS / Linux |
|------|---------|---------------|
| Safe | `scripts\docker-run-local.bat` | `./scripts/docker-run-local.sh` |
| Paper | `scripts\docker-run-local-paper.bat` | `npm run paper` or compose profile `paper` |
| Live | `scripts\docker-run-production.bat` | `./scripts/docker-run-production.sh` |

Live Docker scripts run **setup-env** first, then ask for **`YES`**.

---

# Vercel (health check only — all OS)

| Goal | Windows | macOS / Linux |
|------|---------|---------------|
| Preview | `scripts\vercel-deploy-local.bat` | `./scripts/vercel-deploy-local.sh` |
| Production URL | `scripts\vercel-deploy-production.bat` | `./scripts/vercel-deploy-production.sh` |

Visit `/api/health` after deploy. **Never** add wallet keys on Vercel.

[VERCEL.md](./VERCEL.md)

---

## npm commands (any OS)

| Command | Platform |
|---------|----------|
| `npm run setup:env` | Windows |
| `npm run setup:env:unix` | macOS / Linux |
| `npm run production:live` | Windows |
| `npm run production:live:unix` | macOS / Linux |
| `npm run docker:production` | Docker |

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `npm.ps1 cannot be loaded` (Windows) | Use `.bat` scripts or `npm.cmd` |
| Missing `.env` | Run `setup-env` for your OS (see [PRODUCTION.md](../scripts/PRODUCTION.md)) |
| Docker `EISDIR simulation.json` | Run `docker-init-data` / use `data/simulation.json` |
| `sleek-pretty` error | Old infected repo — use this cleaned copy only |
| Positions after Docker paper | `scripts\run-positions.bat` or set `SIMULATION_FILE=./data/simulation.json` |

---

## Security

- [SECURITY_AUDIT.md](./SECURITY_AUDIT.md)
- [SAFE_EXECUTION.md](./SAFE_EXECUTION.md)

## Old `sleek-pretty` malware

If you ran an old copy: rotate keys, new wallet, delete `node_modules`, reinstall.
