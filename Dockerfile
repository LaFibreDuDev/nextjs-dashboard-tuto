FROM node:22-alpine AS base
RUN corepack enable && corepack prepare pnpm@latest --activate

# ── Étape 1 : installation des dépendances ────────────────────────────────────
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# ── Étape 2 : build de l'application ─────────────────────────────────────────
FROM base AS builder
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED=1

# On utilise `next build` standard (sans --experimental-build-mode compile)
# pour produire l'output standalone nécessaire au conteneur
RUN pnpm next build

# ── Étape 3 : image de production (minimale) ──────────────────────────────────
FROM node:22-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs && \
    adduser  --system --uid 1001 nextjs

# Standalone output : contient uniquement ce qui est nécessaire au runtime
COPY --from=builder --chown=nextjs:nodejs /app/public                    ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone          ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static              ./.next/static

USER nextjs

EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

CMD ["node", "server.js"]
