# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

# Update and upgrade critical packages to address vulnerabilities
RUN apk --no-cache update && apk --no-cache upgrade \
    && apk add --no-cache \
    libexpat \
    libxml2 \
    libxslt

# Copy the build output from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
