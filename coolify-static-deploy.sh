#!/bin/bash

# Build script for Static deployment in Coolify
# This script builds the Rust application and prepares it for static deployment

# Exit on any error
set -e

echo "Building Teacher Registry API for Coolify (Static deployment)..."

# Install Rust if not already installed
if ! command -v rustc &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi

# Ensure we have the latest Rust
rustup update

# Add the Linux target
rustup target add x86_64-unknown-linux-gnu

# Create the public directory required by Coolify Static deployment
mkdir -p public

# Build for release
echo "Building application..."
cargo build --release

# Check if the build was successful
if [ ! -f "target/release/teacher-registry" ]; then
    echo "Error: Build failed. Binary not found."
    exit 1
fi

# Copy the binary to the public directory
cp target/release/teacher-registry public/

# Create a start script in the public directory
cat > public/start.sh << 'EOF'
#!/bin/bash
export RUST_LOG=info

# Print current directory and contents for debugging
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

# Make the binary executable
chmod +x ./teacher-registry

# Run the application
./teacher-registry
EOF

# Make the start script executable
chmod +x public/start.sh

echo "Build successful!"
echo "The application binary and start script are in the 'public' directory"
echo "For Coolify deployment with Static build pack:"
echo "1. Set 'Start Command' to './start.sh'"
echo "2. Set 'Port' to '8082'"