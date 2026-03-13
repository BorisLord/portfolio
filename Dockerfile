# syntax=docker/dockerfile:1
# =============================================================================
# Portfolio — Static Astro site
# =============================================================================
#
#   docker build -t bobofolio .
#
# =============================================================================

# --- Stage 1: Build ---

FROM node:24-alpine3.23 AS builder
WORKDIR /app
RUN corepack enable

COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm install --frozen-lockfile --ignore-scripts

COPY . .
RUN pnpm build

# --- Stage 2: Serve ---

FROM httpd:2.4-alpine3.21
RUN apk upgrade --no-cache

RUN sed -i 's/#ErrorDocument 404 \/missing.html/ErrorDocument 404 \/404.html/' /usr/local/apache2/conf/httpd.conf

COPY --from=builder /app/dist /usr/local/apache2/htdocs/
EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --spider http://127.0.0.1/ || exit 1

CMD ["httpd-foreground"]
