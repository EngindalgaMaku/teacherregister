# Use Rust official image for building
FROM rust:1.70 as builder

# Create app directory
WORKDIR /app

# Copy manifests
COPY ./Cargo.toml ./Cargo.toml
COPY ./Cargo.lock ./Cargo.lock

# Copy source code
COPY ./src ./src

# Build for release
RUN cargo build --release

# Use a minimal base image for the runtime
FROM debian:bullseye-slim

# Install ca-certificates for HTTPS requests
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy the binary from builder stage
COPY --from=builder /app/target/release/teacher-registry .

# Expose port
EXPOSE 8082

# Run the binary
CMD ["./teacher-registry"]