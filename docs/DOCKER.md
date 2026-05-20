# Docker — One-Click Guide (Windows, macOS, Linux)

Docker runs the bot in a container. Secrets stay in **`.env` on your host** — not baked into the image.

## Install Docker Desktop

https://www.docker.com/products/docker-desktop/

Start Docker before running any script below.

---

## One-click scripts

| Goal | Windows | macOS / Linux |
|------|---------|---------------|
| Safe (signal) | `scripts\docker-run-local.bat` | `./scripts/docker-run-local.sh` |
| Paper | `scripts\docker-run-local-paper.bat` | `docker compose --profile paper up --build` |
| **Live** | `scripts\docker-run-production.bat` | `./scripts/docker-run-production.sh` |

Live scripts run **`setup-env`** first (creates `.env`, opens editor), then ask for **`YES`**.

---

## Manual compose

```bash
# Safe
docker compose --profile local up --build --abort-on-container-exit

# Paper
docker compose --profile paper up --build --abort-on-container-exit

# Live (requires .env on host)
docker compose --profile production up --build
```

---

## Paper / simulation file

State is saved to **`data/simulation.json`** on your machine.

If you see `EISDIR` errors, run:

```bash
scripts/docker-init-data.ps1   # Windows
bash scripts/docker-init-data.sh
```

---

## Security

- Do not `COPY .env` into the image (we do not).
- Burner wallet only for `production` profile.
- See [SAFE_EXECUTION.md](./SAFE_EXECUTION.md).
