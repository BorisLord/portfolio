# syntax=docker/dockerfile:1
# =============================================================================
# Portfolio — Static Astro site
# =============================================================================
#
#   docker build -t bobofolio .
#
# =============================================================================

# --- Stage 1: Build ---

FROM node:lts-alpine AS builder
WORKDIR /app
RUN corepack enable

COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm install --frozen-lockfile --ignore-scripts

COPY . .
RUN pnpm build

# --- Stage 2: Serve ---

FROM joseluisq/static-web-server:2-alpine
COPY --from=builder /app/dist /public
EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --spider http://127.0.0.1/ || exit 1

CMD ["static-web-server", "--port", "80", "--root", "/public", "--page404", "/public/404.html"]
