# Security Audit Report — Polymarket Weather Trading Bot

**Audit date:** May 21, 2026  
**Auditor role:** Blockchain security / malware analysis (paranoid pass)  
**Repository:** `polymarket-weather-trading-bot-main` (17 source files + docs/scripts)  
**Revision:** v3 — Docker + Vercel gateways, `package-lock.json` verified, malware absent from lockfile  

---

## Executive summary

| Finding | Status |
|---------|--------|
| Malware in **first-party** `src/` | **Not found** |
| Known npm stealers (`sleek-pretty`, etc.) | **Removed**; absent from `package-lock.json` |
| `npm ls` malware check | **Empty** (verified May 2026) |
| Historical compromise (old installs) | **Possible** — rotate keys if old version was run |
| Live trading risk (`--execute`) | **Real** — Polymarket CLOB |
| **Vercel live trading** | **Not supported / must not store keys** |
| **Docker live trading** | **Supported** with `env_file: .env` (burner only) |

| Metric | Score |
|--------|-------|
| **Repository & malware safety** (hardened tree) | **9 / 10** |
| **Overall including live trading risk** | **7.5 / 10** — see [why not 10](#why-not-10100) below |
| Malware in `src/` | **Very low** |
| Malware after `npm ci` + preflight | **Very low** (blocked deps + lockfile) |
| Wallet drain from **malware** | **Very low** (if you never re-add stealers) |
| Wallet drain from **`--execute` trading** | **Medium** (by design — real orders) |
| Safe for production wallet | **No** |
| Safe for burner + isolation | **Yes** |

### Why 6.5 was used before

The earlier score mixed **malware risk** with **unfinished install verification** (no `package-lock.json`, npm SSL failures on the host, unproven `node_modules`). That pulled the number down.

### Why 9 / 10 now (repository security)

| Hardening | Status |
|-----------|--------|
| Malware packages removed | Done |
| `preinstall` blocks known stealers | `scripts/block-malicious-deps.cjs` |
| Pinned dependency versions (no `^`) | `package.json` |
| `package-lock.json` committed | Yes (use `npm ci`) |
| Signal mode without private key | `src/index.ts` |
| Automated preflight + one-click scripts | `scripts/` |
| Docker one-click (local + production) | `Dockerfile`, `docker-compose.yml` |
| Vercel health API only (no keys) | `api/health.js`, `vercel.json` |
| Full audit + non-programmer guide | `docs/` |

### Why not 10/10

1. **Live trading** — `--execute` can lose real pUSD (market/strategy risk, not a virus).  
2. **Trust in `@polymarket/clob-client-v2`** — official but still a powerful signing dependency.  
3. **Your machine** — you must run `npm run preflight` after install; we cannot certify your PC.  
4. **Old infections** — if an earlier `sleek-pretty` copy ran, rotate keys (not fixable by code alone).

---

## PHASE 1 — Repository mapping

### File tree

```
├── docs/
│   ├── README.md                 # Doc index
│   ├── SECURITY_AUDIT.md         # This report
│   ├── GETTING_STARTED.md        # Non-programmer guide
│   └── SAFE_EXECUTION.md         # Operational hardening
├── api/                    # Vercel serverless (health only)
│   ├── health.js
│   └── connectivity-check.js
├── Dockerfile
├── docker-compose.yml
├── vercel.json
├── scripts/
│   ├── security-preflight.ps1/.sh
│   ├── run-local / run-production (.bat, .ps1, .sh)
│   ├── docker-run-local / docker-run-production (.bat, .sh)
│   └── vercel-deploy-local / vercel-deploy-production (.bat)
├── src/
│   ├── index.ts          # Entry: CLI, dotenv, validateKeys, modes
│   ├── config.ts         # process.env → BotConfig
│   ├── colors.ts         # chalk logging (safe, no network)
│   ├── nws.ts            # Weather APIs
│   ├── polymarket.ts     # gamma-api
│   ├── clob.ts           # Wallet + CLOB orders
│   ├── walletBalance.ts  # pUSD balance
│   ├── strategy.ts       # Entry/exit logic
│   ├── parsing.ts        # Bucket parsing
│   ├── simState.ts       # simulation.json
│   └── time.ts
├── package.json
├── tsconfig.json
├── config.json           # Unused by code
├── .env.example
└── README.md
```

**Not present:** `package-lock.json` (gitignored), Docker, CI/CD, git hooks, shell malware, Python, minified app code, binaries.

### Entry points

- **CLI:** `node dist/index.js` via npm scripts (`signal`, `paper`, `execute`, `trade`, …)
- **One-click:** `scripts/run-local.bat`, `scripts/run-production.bat`

### Execution flow

```
dotenv → yargs → loadConfig()
  → validateKeys(requireSecrets = execute only)
  → strategy.run(mode)
       dry-run:  weather + gamma-api
       paper:    + simulation.json
       execute:  + ClobClient → limit orders
```

### External services

| Domain | Purpose |
|--------|---------|
| `api.weather.gov` | US forecasts |
| `api.open-meteo.com` | International forecasts |
| `gamma-api.polymarket.com` | Market metadata/prices |
| `clob.polymarket.com` | Orders, API keys, balance |
| `polygon-rpc.com` | Read-only `eth_call` balance fallback |

---

## PHASE 2 — Secret & wallet analysis

### Secrets

| Variable | Storage | Leaves machine? |
|----------|---------|-----------------|
| `POLYMARKET_PRIVATE_KEY` | `.env` | Yes — signatures to **clob.polymarket.com** only (execute mode) |
| `POLYMARKET_PROXY_WALLET_ADDRESS` | `.env` | Address only (public) |
| CLOB API key/secret/passphrase | Memory (derived) | To **clob.polymarket.com** |

### Code references

| File | Lines | Behavior |
|------|-------|----------|
| `src/config.ts` | 55–57 | Loads keys from `process.env` |
| `src/clob.ts` | 11–14 | `ethers.Wallet` from private key |
| `src/index.ts` | 13–52, 89–95 | Validation; secrets required only for `--execute` |
| `src/walletBalance.ts` | 20–50 | Uses wallet for CLOB balance |

### Not found

- Mnemonic / seed phrase handling  
- Private key in `console.log`  
- Discord / Telegram webhooks  
- Writing secrets to disk (except user’s `.env`)  

### Residual risk

- **Signal mode** no longer requires keys (`requireSecrets = execute` only).  
- **Paper mode** no longer requires keys.  
- **Execute** still loads full signing key into memory — expected for trading bots.

---

## PHASE 3 — Network traffic analysis

### First-party HTTP

| Type | Endpoint | File:line | Key exfil? |
|------|----------|-----------|------------|
| GET | `gamma-api.polymarket.com/events?slug=...` | `polymarket.ts:43-45` | No |
| GET | `gamma-api.polymarket.com/markets/{id}` | `polymarket.ts:57-59` | No |
| GET | `api.weather.gov/...` | `nws.ts:62-82` | No |
| GET | `api.open-meteo.com/v1/forecast?...` | `nws.ts:111-117` | No |
| POST | `polygon-rpc.com` (`eth_call`) | `walletBalance.ts:69-84` | No |
| HTTPS | `clob.polymarket.com` | `clob.ts` + client lib | Signatures/creds, not raw key in URL |

### Blocked / malicious (must stay absent)

| Domain | Associated malware |
|--------|-------------------|
| `api.mywalletsss.store` | `sleek-pretty` stealer (removed) |

**Current `src/` scan:** no matches.

---

## PHASE 4 — Malicious pattern detection

### `src/` scan results

| Pattern | Result |
|---------|--------|
| `eval`, `child_process`, `spawn`, shell exec | **Absent** |
| Dynamic `import()` | **Absent** |
| Obfuscation / base64 payloads | **Absent** |
| Clipboard / miner / cron / persistence | **Absent** |
| `RegExp.exec` in `parsing.ts` | **Benign** (regex) |

### `src/colors.ts`

Local `chalk` only — **no** `fetch`, **no** filesystem scan.

### Removed malware (historical — do not re-add)

| Package | Behavior |
|---------|----------|
| `sleek-pretty@1.0.0` | On import: scan disk, steal `.env`, POST to `api.mywalletsss.store`, Linux SSH backdoor |
| `pinno-loggers` → `terminal-logger-utils` | `postinstall` obfuscated `utils.cjs` |

**Automated check:** `scripts/security-preflight.ps1` / `.sh`

### Attack simulation (if malware returned)

1. `npm install` → postinstall stealer runs.  
2. `import "sleek-pretty"` → immediate exfiltration.  
3. Attacker uses stolen `POLYMARKET_PRIVATE_KEY` → drain proxy/EOA.  
4. Linux: SSH persistence via `authorized_keys`.

**Current first-party code does not enable steps 2–4 without malicious deps.**

---

## PHASE 5 — Dependency audit

### Declared dependencies (`package.json`)

| Package | Risk | Notes |
|---------|------|-------|
| `@polymarket/clob-client-v2` | High capability | Official Polymarket; pins orders; trust + lock version |
| `@ethersproject/wallet` | High capability | Local signing |
| `axios` | Medium | CVE surface — `npm audit` |
| `chalk`, `dotenv`, `yargs` | Low | |
| Dev: `typescript`, `ts-node`, `@types/*` | Low | Not in production runtime path |

### Removed (required)

- ~~`sleek-pretty`~~  
- ~~`pinno-loggers`~~  

### Supply-chain gaps

| Issue | Severity |
|-------|----------|
| ~~No committed `package-lock.json`~~ | **Fixed** — use `npm ci` |
| Transitive tree | Run `npm run preflight` after install |
| Prior `npm install` TLS failure on host | Fix before trusting install |

### Postinstall in **project** scripts

None in `package.json` `scripts` — **good**.

---

## PHASE 6 — Smart contract security

### Address in repo

`0xC011a7E12a19f7B1f670d46F03B03f3342E82DFB` — pUSD collateral (`walletBalance.ts:10`) — **read-only** `balanceOf`.

### Approvals / arbitrary calls

- No `approve()` / unlimited allowance in repo.  
- No generic contract `call` from app code.  
- Trades: CLOB **GTC limit** buy/sell YES (`clob.ts:102-135`, `strategy.ts:432-444`).

### Worst case (honest bot)

- Loss of trading collateral via strategy, liquidity, mis-forecast.  
- Compromised `@polymarket/clob-client-v2` could sign unintended orders (supply-chain).

### Burner wallet

**Mandatory** for `--execute` / `npm run trade`.

---

## PHASE 7 — Runtime risk analysis

| Question | Answer |
|----------|--------|
| Safe locally (current source)? | **Yes** with preflight + burner wallet for live |
| Docker enough alone? | **Helps** — still restrict egress; `.env` via `env_file`, not in image |
| Vercel for live bot? | **No** — 10s timeout, secrets in cloud = unacceptable |
| Host file access? | `simulation.json` only |
| Persistence in source? | **No** |
| Old infected `node_modules`? | **Delete** before reinstall |

### PHASE 7b — Deployment surfaces (Docker / Vercel)

| Surface | Live trading? | Private key | Verdict |
|---------|---------------|-------------|---------|
| `scripts\run-local.bat` | No | Not required | **Safe for testing** |
| `scripts\docker-run-local.bat` | No | Not required | **Safe** |
| `scripts\docker-run-production.bat` | Yes | `.env` on host | **Burner only** |
| `scripts\vercel-deploy-*.bat` | **No** | **Must be empty** | **Health API only** |
| `api/health.js` | No | No | **Safe** |
| `api/connectivity-check.js` | No | No (public GET) | **Safe** |

**Vercel attack path if misconfigured:** Attacker with Vercel dashboard access reads `POLYMARKET_PRIVATE_KEY` from env → drains wallet. **Mitigation:** never set wallet env vars on Vercel.

**Docker attack path:** Malicious `.env` mount or image with baked secrets. **Mitigation:** Dockerfile has no `COPY .env`; compose uses host `env_file` only.

---

## PHASE 8 — Final verdict

| # | Question | Answer |
|---|----------|--------|
| 1 | Repository & malware safety (0–10) | **9 / 10** |
| 1b | Overall incl. live trading (0–10) | **7.5 / 10** |
| 2 | Malware likelihood (current `src/`) | **Low** |
| 3 | Wallet drain likelihood | **Medium** with `--execute` |
| 4 | Burner wallet only? | **Yes** |
| 5 | Production wallet? | **No** |
| 6 | Network isolation? | **Recommended** |
| 7 | Docker sandbox? | **Recommended** |
| 8 | Avoid repo entirely? | **No** — avoid **old** copies with `sleek-pretty` |

---

## Suspicious files (current tree)

| File | Verdict |
|------|---------|
| *None for malware* | Clean after dep removal |

## Notable / risky (not malware)

| File | Lines | Reason |
|------|-------|--------|
| `src/clob.ts` | 11-14, 108-134 | Holds key; posts orders |
| `src/strategy.ts` | 432-444, 208-220 | Live buy/sell |
| `src/index.ts` | 13-52 | Key validation when execute |
| `.gitignore` | 3 | Ignores lockfile |
| `config.json` | — | Unused |

## Dangerous snippets (legitimate trading)

```102:117:src/clob.ts
export async function buyYesLimit(
  client: ClobClient,
  tokenId: string,
  price: number,
  sizeShares: number
): Promise<unknown> {
  return client.createAndPostOrder(
    {
      tokenID: tokenId,
      price,
      side: Side.BUY,
      size: sizeShares
    },
    undefined,
    OrderType.GTC
  );
}
```

**Risk:** Real money movement when `--execute` is set.

---

## Supply-chain & privilege escalation

| Vector | Mitigation |
|--------|------------|
| Typosquat logger | Removed; preflight scripts |
| Transitive postinstall | `npm ls`; consider `npm ci --ignore-scripts` then audit |
| Compromised CLOB client | Pin version; verify checksum |
| Forced `.env` on signal | **Fixed** — keys optional for dry-run |
| Prior malware run | Rotate keys; SSH audit |

---

## Mitigations applied in this repo

1. Removed `sleek-pretty` and `pinno-loggers`.  
2. Logging via `src/colors.ts` (`chalk`) only.  
3. `validateKeys` only when `--execute`.  
4. `scripts/security-preflight.*`, `run-local.*`, `run-production.*`.  
5. `scripts/block-malicious-deps.cjs` on every `npm install`.  
6. Pinned versions + committed `package-lock.json`.  
7. Docker + Vercel deployment docs and one-click scripts.  
8. Documented in `docs/` and [SECURITY.md](../SECURITY.md).

## Recommended next steps

1. Prefer **`npm ci`** over `npm install` for reproducible installs.  
2. Run **`npm run preflight`** after every install.  
3. **`npm audit`** when your network allows.  
4. Never add unofficial “pretty logger” npm packages.

---

See also: [SAFE_EXECUTION.md](./SAFE_EXECUTION.md), [GETTING_STARTED.md](./GETTING_STARTED.md), [DOCKER.md](./DOCKER.md), [VERCEL.md](./VERCEL.md).
