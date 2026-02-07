FROM node:22-alpine AS build

WORKDIR /app

# Leverage Docker layer cache for dependencies
COPY package.json pnpm-lock.yaml ./

RUN corepack enable \
    && corepack prepare pnpm@latest --activate \
    && pnpm install --frozen-lockfile --prefer-offline

COPY . .

RUN pnpm build

FROM httpd:2.4-alpine AS runtime

RUN sed -i 's/#ErrorDocument 404 \/missing.html/ErrorDocument 404 \/404.html/' /usr/local/apache2/conf/httpd.conf

COPY --from=build /app/dist /usr/local/apache2/htdocs/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --spider http://localhost/ || exit 1

CMD ["httpd-foreground"]
