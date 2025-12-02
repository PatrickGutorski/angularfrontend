# STAGE 1: Build the Angular app
FROM node:18-alpine AS build
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
# Replace 'production' with your specific configuration if needed
RUN npm run build --configuration=production

# STAGE 2: Serve with Nginx
FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output.
# IMPORTANT: Check your angular.json 'outputPath'.
# In Angular 17+, it is often dist/project-name/browser
COPY --from=build /app/dist/YOUR_PROJECT_NAME/browser /usr/share/nginx/html

# Copy our custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
