# Build stage
FROM node:18-alpine AS build

# Set working directory for the build stage
WORKDIR /app

# Copy package files for dependency installation
COPY package*.json ./

# Install dependencies only for production
RUN npm ci --only=production

# Final stage
FROM node:18-alpine

# Create app directory for the final stage
WORKDIR /app

# Create a non-root user and group with explicit IDs for security
RUN addgroup -S appgroup -g 1001 && \
    adduser -S appuser -u 1001 -G appgroup -s /bin/sh

# Copy only the necessary files from the build stage to the final stage
COPY --from=build /app/node_modules ./node_modules
COPY index.js package.json ./

# Set ownership of the app directory to the non-root user
RUN chown -R appuser:appgroup /app

# Set the user to run the application as the non-root user
USER appuser

# Expose the port the app will run on
EXPOSE 3000

# Define environment variables for the app
ENV PORT=3000 \
    NODE_ENV=production

# Health check to ensure the app is running
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q -O- http://localhost:3000/health || exit 1

# Command to start the application
CMD ["node", "index.js"]

