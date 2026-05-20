# Step-by-Step Guide (No Programming Experience)

This bot checks weather forecasts and Polymarket temperature markets. You can run it **without real money** first.

**Rules:**

- Use a **burner wallet** (new MetaMask account) for live trading — never your main wallet.
- **Do not** put your private key on Vercel (cloud website hosting).
- Prefer **local** or **Docker** for real trading.

---

## Choose how you want to run the bot

| Way | Best for | Real money? |
|-----|----------|-------------|
| **A. Windows double-click** | Easiest on Windows | Only with `run-production.bat` |
| **B. Docker** | Isolation, same on Mac/Windows | Only with `docker-run-production.bat` |
| **C. Vercel (cloud)** | Health check URL only | **Never** — not for trading |

---

# Way A — Windows (no Docker)

## Part 1 — Install Node.js (one time)

1. Go to **https://nodejs.org/**
2. Download **LTS**, install with defaults.
3. Press **Windows key**, type `cmd`, Enter.
4. Type `node -v` — you should see a version like `v20.x.x`.

## Part 2 — Get the project folder

Example: `C:\Users\YourName\Desktop\polymarket-weather-trading-bot-main`

## Part 3 — Safe test (no money)

1. Open folder → `scripts`
2. Double-click **`run-local.bat`**
3. Wait (first time installs packages). Colored text = weather + markets. **No bets placed.**

No `.env` file needed for this step.

## Part 4 — Paper trading (pretend money)

1. Double-click **`run-local-paper.bat`**
2. Still **no real money** — uses `simulation.json` on your PC.

## Part 5 — Live trading (real money)

1. MetaMask → **new account** (burner).
2. Copy **private key** and Polymarket **proxy address** from polymarket.com/settings.
3. Copy `.env.example` → rename to **`.env`**, fill in keys (Notepad).
4. Double-click **`run-production.bat`**
5. Type **`YES`** only if you accept real losses.

---

# Way B — Docker (recommended for isolation)

## Part 1 — Install Docker Desktop

1. **https://www.docker.com/products/docker-desktop/**
2. Install and **start** Docker (whale icon running).

Details: [DOCKER.md](./DOCKER.md)

## Part 2 — One-click Docker

| Double-click | What happens |
|--------------|----------------|
| **`scripts\docker-run-local.bat`** | Safe scan, no real money |
| **`scripts\docker-run-local-paper.bat`** | Fake money |
| **`scripts\docker-run-production.bat`** | Real trading — needs `.env` + YES |

First Docker run downloads a image (5–15 minutes once).

---

# Way C — Vercel (cloud — NOT for trading)

Use this only to get a **status webpage**, not to trade.

1. Install Node.js (Part 1 above).
2. Double-click **`scripts\vercel-deploy-local.bat`**
3. Log in to Vercel in the browser.
4. Visit: `https://your-project.vercel.app/api/health`

**Never** add `POLYMARKET_PRIVATE_KEY` in Vercel settings.

Full explanation: [VERCEL.md](./VERCEL.md)

---

## If something goes wrong

| Problem | Fix |
|---------|-----|
| `npm.ps1 cannot be loaded` / execution policy | Use **`scripts\run-positions.bat`** or open **cmd.exe** (not PowerShell), or run: `npm.cmd run positions` |
| SSL / certificate error on `npm install` | Try home Wi‑Fi; see IT for work VPN |
| `sleek-pretty` in red error | Old infected copy — use this cleaned repo only |
| Docker “not running” | Start Docker Desktop |
| Live mode “missing .env” | Create `.env` from `.env.example` |
| Vercel timeout | Normal — Vercel cannot run the full trading loop |
| Positions empty after Docker paper | State is in **`data\simulation.json`** — use `scripts\run-positions.bat` |

---

## Security check (optional)

```powershell
cd C:\Users\Chama\Desktop\polymarket-weather-trading-bot-main
npm run preflight
```

- Full audit: [SECURITY_AUDIT.md](./SECURITY_AUDIT.md)
- Hardening: [SAFE_EXECUTION.md](./SAFE_EXECUTION.md)

---

## Quick reference — all one-click scripts

### Windows — on your PC

| Goal | Script |
|------|--------|
| Safe test | `scripts\run-local.bat` |
| Paper | `scripts\run-local-paper.bat` |
| Live | `scripts\run-production.bat` |
| View positions | `scripts\run-positions.bat` |
| Reset paper $1000 | `scripts\run-reset.bat` |

### Windows — Docker

| Goal | Script |
|------|--------|
| Safe | `scripts\docker-run-local.bat` |
| Paper | `scripts\docker-run-local-paper.bat` |
| Live | `scripts\docker-run-production.bat` |

### Vercel (health only)

| Goal | Script |
|------|--------|
| Preview URL | `scripts\vercel-deploy-local.bat` |
| Production URL | `scripts\vercel-deploy-production.bat` |

---

## Old version warning

An older copy had malware package **`sleek-pretty`** that stole `.env` files.

If you used that version:

1. Move funds off that wallet.
2. Create a **new** wallet and new `.env`.
3. Delete `node_modules` and run `run-local.bat` again.

---

## More help

- [README.md](../README.md) — technical details  
- [DOCKER.md](./DOCKER.md) — Docker  
- [VERCEL.md](./VERCEL.md) — Vercel limits  
