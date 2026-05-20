# Safe Execution Guide

Use this with [SECURITY_AUDIT.md](./SECURITY_AUDIT.md). **Never use your main MetaMask wallet.**

## Quick path

1. Run safe mode several times:
   - Windows: `scripts\run-local.bat`
   - macOS/Linux: `./scripts/run-local.sh`
2. Use a **new burner wallet** and small pUSD only.
3. Run production (creates `.env` automatically):
   - Windows: `scripts\run-production.bat`
   - macOS/Linux: `./scripts/run-production.sh`
   - Docker: `docker-run-production.bat` / `.sh`

See [../scripts/PRODUCTION.md](../scripts/PRODUCTION.md).

## If you used an old copy of this repo

Older versions included malware (`sleek-pretty`). If you ever ran `npm install` or `npm start` on that copy:

- **Rotate** `POLYMARKET_PRIVATE_KEY` (new wallet, move funds off the old one).
- **Linux:** check `~/.ssh/authorized_keys` for unknown keys.
- Delete old `node_modules` before reinstalling.

## Burner wallet rules

- Create a **new** MetaMask account used only for this bot.
- Fund Polymarket proxy with **small** pUSD you can lose.
- Set CLOB allowance on [polymarket.com](https://polymarket.com) — minimum needed.
- Never paste your seed phrase into any file or chat.

## Test order

| Step | Command | Real money? |
|------|---------|-------------|
| 1 | `run-local.bat` (signal) | No |
| 2 | `run-local.ps1 -Paper` | No (virtual `simulation.json`) |
| 3 | `run-production.bat` once | **Yes** |
| 4 | `npm run trade` (30 min loop) | **Yes** — only when confident |

Signal mode does **not** require a private key in `.env` (after security fix in `src/index.ts`).

## Network allowlist (firewall)

Allow outbound **only** to:

- `api.weather.gov`
- `api.open-meteo.com`
- `gamma-api.polymarket.com`
- `clob.polymarket.com`
- Your Polygon RPC (default in code: `polygon-rpc.com`)

**Block everything else**, especially unknown domains. If you see `mywalletsss.store`, stop immediately — that is malware.

## Monitor outbound traffic

**Windows:** Resource Monitor → Network, or Wireshark.

**What to watch for:** POST requests to unknown hosts, uploads of `.env` content, connections to `api.mywalletsss.store`.

## Docker (optional hardening)

```dockerfile
FROM node:20-slim
RUN useradd -m botuser
USER botuser
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
# Pass .env at runtime — do not bake secrets into the image
CMD ["npm", "run", "signal"]
```

- Do not mount your entire home directory.
- Use host firewall rules on the container network.
- Read-only root filesystem where possible.

## Least privilege

- Dedicated Windows/macOS user account for the bot.
- No admin rights required.
- `.env` file permissions: only your user can read (Windows: Properties → Security).

## Prevent draining (beyond malware)

- Low `MAX_TRADES_PER_RUN` in `.env` during testing.
- `npm run execute` once before `npm run trade`.
- Compare Polymarket UI orders with bot logs every run.
