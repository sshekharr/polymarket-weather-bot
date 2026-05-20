# Security Policy

## Supported secure revision

Use only this repository revision with:

- No `sleek-pretty`, `pinno-loggers`, or `terminal-logger-utils` in `package.json`
- `scripts/block-malicious-deps.cjs` running on every `npm install`
- Committed `package-lock.json` (install with `npm ci` when possible)

## Security score (what “9/10” means)

| Score | Meaning |
|-------|---------|
| **9 / 10** | **Repository & malware safety** — clean source, blocked stealers, lockfile, preflight scripts |
| **N/A → 10** | Impossible for any bot that signs live trades — financial loss from markets/strategy is separate |

**Not scored as malware:** losing money because forecasts were wrong or because you ran `--execute`. Use a burner wallet and small size.

## If you used an old copy with `sleek-pretty`

1. Rotate `POLYMARKET_PRIVATE_KEY` immediately.
2. Linux: audit `~/.ssh/authorized_keys`.
3. Delete `node_modules`, run `npm ci`, then `npm run preflight`.

## Reporting

Open a GitHub issue with “Security” in the title. Do not post private keys or `.env` contents.

Full audit: [docs/SECURITY_AUDIT.md](docs/SECURITY_AUDIT.md)
