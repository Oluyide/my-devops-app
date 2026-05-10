# syntax=docker/dockerfile:1.7

# ---- Stage 1: deps ----
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev --no-audit --no-fund \
 && npm cache clean --force

# ---- Stage 2: runtime ----
FROM node:20-alpine AS runtime

RUN apk add --no-cache wget \
 && addgroup -S app && adduser -S app -G app

WORKDIR /app
ENV NODE_ENV=production \
    PORT=3000

COPY --from=deps --chown=app:app /app/node_modules ./node_modules
COPY --chown=app:app package.json server.js ./

USER app
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:3000/health > /dev/null || exit 1

CMD ["node", "server.js"]
