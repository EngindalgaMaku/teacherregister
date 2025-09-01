#!/bin/bash

# Start script for the Teacher Registry API

# Print current directory and contents for debugging
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

# Try to find the binary
if [ -f "./teacher-registry" ]; then
    BINARY_PATH="./teacher-registry"
elif [ -f "./public/teacher-registry" ]; then
    BINARY_PATH="./public/teacher-registry"
elif [ -f "/app/public/teacher-registry" ]; then
    BINARY_PATH="/app/public/teacher-registry"
else
    echo "ERROR: Could not find teacher-registry binary"
    exit 1
fi

# Set log level if not already set
export RUST_LOG=${RUST_LOG:-info}

# Display startup information
echo "Starting Teacher Registry API..."
echo "Binary path: $BINARY_PATH"
echo "Port: 8082"
echo "Log level: $RUST_LOG"

# Make binary executable
chmod +x "$BINARY_PATH"

# Run the application
exec "$BINARY_PATH"