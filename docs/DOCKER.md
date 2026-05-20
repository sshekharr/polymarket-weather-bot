# Docker — One-Click Guide

Docker runs the bot in an isolated container. **Secrets stay in `.env` on your machine** — they are not baked into the image.

## Install Docker Desktop (one time)

1. Download: https://www.docker.com/products/docker-desktop/
2. Install and start Docker Desktop (whale icon in system tray must be running).

## One-click (Windows)

| Double-click | Mode |
|--------------|------|
| `scripts\docker-run-local.bat` | **Signal** — no real money |
| `scripts\docker-run-local-paper.bat` | **Paper** — fake balance |
| `scripts\docker-run-production.bat` | **Live** — needs `.env` + type YES |

## One-click (Mac/Linux)

```bash
chmod +x scripts/docker-run-local.sh scripts/docker-run-production.sh
./scripts/docker-run-local.sh
# Live:
./scripts/docker-run-production.sh
```

## Manual commands

```bash
# Local / safe
docker compose --profile local up --build --abort-on-container-exit

# Paper
docker compose --profile paper up --build --abort-on-container-exit

# Production (requires .env)
docker compose --profile production up --build
```

## Paper / simulation file

Paper and production modes save state to **`data/simulation.json`** (not the project root).

One-click scripts run `docker-init-data` first so Docker does not create a wrong `simulation.json` **folder**.

If you already saw `EISDIR: illegal operation on a directory`:

1. Stop containers: `docker compose down`
2. If `simulation.json` in the project root is a **folder**, delete that folder.
3. Run `scripts\docker-run-local-paper.bat` again.

## Security notes

- **Do not** `COPY .env` into the Dockerfile (we don't).
- Use **burner wallet** only for `production` profile.
- Production compose uses `env_file: .env` — file stays on host.
- Firewall: container uses bridge network; egress still reaches Polymarket APIs.

See [SAFE_EXECUTION.md](./SAFE_EXECUTION.md).
