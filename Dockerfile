# ================================
# Build image
# ================================
FROM swift:5.9-jammy AS build

# Set up a build area
WORKDIR /build

# Copy Package.swift and resolve dependencies
COPY ./Package.* ./
RUN swift package resolve

# Copy entire repo into container
COPY . .

# Build the application with optimizations and static linking
RUN swift build -c release --static-swift-stdlib

# ================================
# Run image
# ================================
FROM ubuntu:22.04

# Install necessary runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libatomic1 \
        libicu70 \
        libxml2 \
        libcurl4 \
        libssl3 \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user and group with /app as its home directory
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor

# Switch to the new home directory
WORKDIR /app

# Copy built executable and resources from the build stage
COPY --from=build /build/.build/release/App ./
COPY --from=build /build/Public ./Public
COPY --from=build /build/Resources ./Resources

# Ensure all files are owned by the vapor user
RUN chown -R vapor:vapor /app

# Switch to the vapor user
USER vapor:vapor

# Expose the application port
EXPOSE 8080

# Set the entrypoint and default command
ENTRYPOINT ["./App"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
