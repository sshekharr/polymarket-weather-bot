# Multi-stage build — local (signal) and production (execute) modes
FROM node:20-slim AS deps
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
  && rm -rf /var/lib/apt/lists/*
COPY package.json package-lock.json ./
COPY scripts/block-malicious-deps.cjs scripts/block-malicious-deps.cjs
RUN npm ci

FROM deps AS build
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

FROM node:20-slim AS runtime
WORKDIR /app
RUN groupadd -r botuser && useradd -r -g botuser botuser \
  && apt-get update && apt-get install -y --no-install-recommends ca-certificates \
  && rm -rf /var/lib/apt/lists/*
COPY package.json package-lock.json ./
COPY scripts/block-malicious-deps.cjs scripts/block-malicious-deps.cjs
RUN npm ci --omit=dev && npm cache clean --force
COPY --from=build /app/dist ./dist
RUN chown -R botuser:botuser /app
USER botuser

# signal = dry-run (default), paper, execute
ARG BOT_MODE=signal
ENV BOT_MODE=${BOT_MODE}
ENV NODE_ENV=production

# No secrets in image layers — pass .env at runtime via compose env_file
CMD ["sh", "-c", "case \"$BOT_MODE\" in execute) exec node dist/index.js --execute ;; paper) exec node dist/index.js --live ;; *) exec node dist/index.js ;; esac"]
