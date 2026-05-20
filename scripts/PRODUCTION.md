# Production scripts (all platforms)

**Burner wallet only.** Never use your main MetaMask account.

Every production path runs **`setup-env`** first (creates `.env` from `.env.example` and opens an editor if needed).

---

## Windows

| Goal | Script |
|------|--------|
| Create/fix `.env` only | `scripts\setup-env.cmd` |
| Live trading (PC) | `scripts\run-production.bat` |
| Live trading (Docker) | `scripts\docker-run-production.bat` |
| Live trading (PowerShell) | `scripts\run-production.ps1` |

```cmd
npm run setup:env
npm run production:live
```

---

## macOS / Linux

Make scripts executable once:

```bash
chmod +x scripts/*.sh
```

| Goal | Script |
|------|--------|
| Create/fix `.env` only | `./scripts/setup-env.sh` |
| Paper (PC) | `./scripts/run-local-paper.sh` |
| Live trading (PC) | `./scripts/run-production.sh` |
| Live trading (Docker) | `./scripts/docker-run-production.sh` |

```bash
npm run setup:env:unix
npm run production:live:unix
```

---

## Vercel (all OS — monitoring only)

| Goal | Windows | macOS / Linux |
|------|---------|----------------|
| Preview deploy | `scripts\vercel-deploy-local.bat` | `./scripts/vercel-deploy-local.sh` |
| Production URL | `scripts\vercel-deploy-production.bat` | `./scripts/vercel-deploy-production.sh` |

**Do not** set `POLYMARKET_PRIVATE_KEY` on Vercel. See [VERCEL.md](../docs/VERCEL.md).

---

## Production flow (same on every OS)

1. **setup-env** — copy `.env.example` → `.env`, edit keys  
2. **Confirm** — type `YES`  
3. **security-preflight** — malware + `.env` checks  
4. **npm ci** / install  
5. **npm run build**  
6. **npm run execute** (or Docker compose `production` profile)

---

## npm scripts

| Command | Platform |
|---------|----------|
| `npm run setup:env` | Windows |
| `npm run setup:env:unix` | macOS / Linux |
| `npm run production:live` | Windows |
| `npm run production:live:unix` | macOS / Linux |
| `npm run docker:production` | Docker (all OS with Docker) |
