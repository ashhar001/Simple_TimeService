# Build stage
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files for dependency installation
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Final stage
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Create a non-root user and group with explicit IDs
RUN addgroup -S appgroup -g 1001 && \
    adduser -S appuser -u 1001 -G appgroup -s /bin/sh

# Copy only the necessary files from the build stage:
COPY --from=build /app/node_modules ./node_modules
COPY index.js package.json ./

# Set ownership to the non-root user
RUN chown -R appuser:appgroup /app

# Set the user to run the application
USER appuser

# Expose the port the app will run on
EXPOSE 3000

# Define env variable
ENV PORT=3000 \
    NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q -O- http://localhost:3000/health || exit 1

# Start the application
CMD ["node", "index.js"]

