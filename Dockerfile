FROM node:lts-alpine AS build

WORKDIR /app

COPY . .

RUN npm install

RUN npm run build

FROM httpd:2.4-alpine AS runtime

COPY --from=build /app/dist /usr/local/apache2/htdocs/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --spider http://localhost/ || exit 1

CMD ["httpd-foreground"]
