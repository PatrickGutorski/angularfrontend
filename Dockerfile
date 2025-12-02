# STAGE 1: Build
# Use 'slim' (Debian) instead of 'alpine'.
# Alpine often fails when building Angular via QEMU (ARM64 emulation).
FROM node:20-slim AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the source code
COPY . .

# Increase memory limit to prevent crashes during heavy builds
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Run the build
# We use '--' to ensure arguments are passed correctly to ng build
RUN npm run build -- --configuration=production

# STAGE 2: Serve
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output
# 1. We use 'angularfrontend' because that is the name in your angular.json
# 2. We use '/browser' because you are using the new "@angular/build:application" builder
COPY --from=build /app/dist/angularfrontend/browser /usr/share/nginx/html

# Copy your custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
