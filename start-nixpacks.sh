#!/bin/bash

# Start script for Nixpacks deployment in Coolify
# This script should be set as the START COMMAND in Coolify

# Make sure the binary is executable
chmod +x /app/target/release/teacher-registry

# Set environment variables
export RUST_LOG=${RUST_LOG:-info}

# Run the application
echo "Starting Teacher Registry API..."
exec /app/target/release/teacher-registry