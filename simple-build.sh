#!/bin/bash

# Alternative build script for Static deployment in Coolify

# Exit on any error
set -e

echo "Building Teacher Registry API for Coolify (Alternative method)..."

# Debug information
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

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

# Build for release
echo "Building application..."
cargo build --release

# Check if the build was successful
if [ ! -f "target/release/teacher-registry" ]; then
    echo "Error: Build failed. Binary not found."
    exit 1
fi

# Create the static files folder that Coolify expects
mkdir -p ./public

# Copy our binary directly to the root and public directories
cp target/release/teacher-registry ./
cp target/release/teacher-registry ./public/

# Create a simple startup script in both locations
cat > start.sh << 'EOF'
#!/bin/bash
chmod +x ./teacher-registry
exec ./teacher-registry
EOF

cp start.sh ./public/

# Make scripts executable
chmod +x start.sh
chmod +x ./public/start.sh
chmod +x teacher-registry
chmod +x ./public/teacher-registry

echo "Build successful!"
echo "The application is ready to run with start.sh"