# ============================================
# Stage 1: Install dependencies
# ============================================
FROM node:22-alpine AS deps

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile


# ============================================
# Stage 2: Build application
# ============================================
FROM node:22-alpine AS build

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN yarn build


# ============================================
# Stage 3: Production image
# ============================================
FROM node:22-alpine AS production

WORKDIR /app

# System dependencies (fonts + crash-safe runtime)
RUN apk add --no-cache \
    fontconfig \
    ttf-dejavu \
    dumb-init

# Create non-root user (security best practice)
RUN addgroup -g 1001 -S nestjs && \
    adduser -S nestjs -u 1001

# Copy build output only
COPY --from=build /app/dist ./dist
COPY package.json ./

# Install only production dependencies
RUN yarn install --frozen-lockfile --production

# Fix permission
RUN chown -R nestjs:nestjs /app

USER nestjs

# Environment
ARG PORT=8102
ENV PORT=${PORT}

EXPOSE ${PORT}

# Proper signal handling
ENTRYPOINT ["dumb-init", "--"]

# Start NestJS app
CMD ["node", "dist/main.js"]