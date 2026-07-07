# Build stage: install production dependencies with npm
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# Runtime stage: app + node_modules only, no npm.
# npm isn't needed to run the app, and removing it also removes its bundled
# dependencies (picomatch, sigstore) that carry known CVEs.
FROM node:22-alpine
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY . .
RUN rm -rf /usr/local/lib/node_modules /usr/local/bin/npm /usr/local/bin/npx
EXPOSE 3000
USER node
CMD ["node", "server.js"]
