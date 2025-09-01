#!/bin/bash

# Build script for Linux deployment without Docker

# Exit on any error
set -e

echo "Building Teacher Registry API for Linux..."

# Check if rust is installed
if ! command -v rustc &> /dev/null
then
    echo "Rust is not installed. Please install Rust first:"
    echo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
fi

# Check if we're on Linux or cross-compiling from Windows
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Building natively on Linux..."
    cargo build --release --target x86_64-unknown-linux-gnu
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo "Cross-compiling from Windows to Linux..."
    
    # Check if cross-compilation target is installed
    if ! rustc --print target-list | grep -q "x86_64-unknown-linux-gnu"; then
        echo "Installing Linux target..."
        rustup target add x86_64-unknown-linux-gnu
    fi
    
    # Install cross-compilation tools if needed
    if ! command -v gcc &> /dev/null
    then
        echo "GCC is not installed. Please install GCC for cross-compilation."
        exit 1
    fi
    
    # Build for Linux
    cargo build --release --target x86_64-unknown-linux-gnu
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo "Build completed successfully!"
echo "Binary location: target/x86_64-unknown-linux-gnu/release/teacher-registry"

# Create deployment package
echo "Creating deployment package..."
mkdir -p deploy
cp target/x86_64-unknown-linux-gnu/release/teacher-registry deploy/
cp README.md deploy/ 2>/dev/null || echo "No README.md to copy"
cp DEPLOYMENT_LINUX.md deploy/ 2>/dev/null || echo "No DEPLOYMENT_LINUX.md to copy"

echo "Deployment package created in 'deploy' directory"
echo "You can now upload the binary to your Coolify server"