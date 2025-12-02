# STAGE 1: Build the Angular app
FROM node:18-alpine AS build

WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./
RUN npm ci

# Copy the rest of the code and build the app
COPY . .
RUN npm run build --configuration=production

# STAGE 2: Serve with Nginx
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output from the previous stage
# NOTE: Replace 'your-project-name' with the project name from your angular.json file
COPY --from=build /app/dist/your-project-name/browser /usr/share/nginx/html

# Copy our custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
