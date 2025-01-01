# ================================
# Build Stage
# ================================
FROM swift:6.0-jammy AS build

# Set up a build area
WORKDIR /build

# Install only necessary tools for the build stage
RUN apt-get update && apt-get install -y --no-install-recommends \
    libatomic1 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Copy Package.swift and resolve dependencies
COPY ./Package.* ./
RUN swift package resolve

# Copy the entire application
COPY . .

# Build the application in release mode
RUN swift build -c release --static-swift-stdlib

# ================================
# Runtime Stage
# ================================
FROM ubuntu:22.04 AS runtime

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libatomic1 \
    libicu70 \
    libxml2 \
    libcurl4 \
    libssl3 \
    tzdata \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group for the app
RUN useradd --user-group --create-home --system vapor

# Set up the app directory
WORKDIR /app

# Copy the built executable and resources from the build stage
COPY --from=build /build/.build/release/App ./
COPY --from=build /build/Public ./Public
COPY --from=build /build/Resources ./Resources

# Ensure all files are owned by the vapor user
RUN chown -R vapor:vapor /app

# Switch to the vapor user for better security
USER vapor

# Expose the application's port
EXPOSE 8080

# Set the entrypoint and default command
ENTRYPOINT ["./App"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
