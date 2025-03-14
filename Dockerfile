FROM node:20-alpine AS builder

# Définition du répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et pnpm-lock.yml
COPY package.json pnpm-lock.yml ./

# Installation des dépendances
RUN npm install -g pnpm && pnpm install --production

# Copier le reste du projet
COPY . .

# Construction du projet
RUN pnpm run build

# Étape finale pour une image plus légère
FROM node:20-alpine

WORKDIR /app

# Copier uniquement les fichiers nécessaires
COPY --from=builder /app/package.json /app/pnpm-lock.yml ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Définition des variables d'environnement
ARG POSTGRES_URL
ARG POSTGRES_PRISMA_URL
ARG POSTGRES_URL_NON_POOLING
ARG POSTGRES_USER
ARG POSTGRES_HOST
ARG POSTGRES_PASSWORD
ARG POSTGRES_DATABASE

ENV POSTGRES_URL=$POSTGRES_URL \
    POSTGRES_PRISMA_URL=$POSTGRES_PRISMA_URL \
    POSTGRES_URL_NON_POOLING=$POSTGRES_URL_NON_POOLING \
    POSTGRES_USER=$POSTGRES_USER \
    POSTGRES_HOST=$POSTGRES_HOST \
    POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
    POSTGRES_DATABASE=$POSTGRES_DATABASE \
    NODE_ENV=production

# Exposer le port Next.js (3000 par défaut)
EXPOSE 3000

# Commande de démarrage
CMD ["pnpm", "run", "start"]