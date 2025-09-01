#!/bin/bash

# Deployment script for Coolify without Docker

# Exit on any error
set -e

echo "Deploying Teacher Registry API to Coolify (non-Docker method)..."

# Check if required files exist
if [ ! -f "src/main.rs" ]; then
    echo "Error: src/main.rs not found"
    exit 1
fi

if [ ! -f "Cargo.toml" ]; then
    echo "Error: Cargo.toml not found"
    exit 1
fi

# Install Rust if not present (for Coolify build environment)
if ! command -v rustc &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    
    # Add to profile for future sessions
    echo 'source $HOME/.cargo/env' >> $HOME/.bashrc
    echo 'source $HOME/.cargo/env' >> $HOME/.profile
fi

# Update Rust
echo "Updating Rust..."
rustup update

# Add Linux target if cross-compiling
echo "Adding Linux target..."
rustup target add x86_64-unknown-linux-gnu

# Build for release
echo "Building application..."
cargo build --release --target x86_64-unknown-linux-gnu

# Check if build was successful
if [ ! -f "target/x86_64-unknown-linux-gnu/release/teacher-registry" ]; then
    echo "Error: Build failed. Binary not found."
    exit 1
fi

echo "Build successful!"

# Make binary executable
chmod +x target/x86_64-unknown-linux-gnu/release/teacher-registry

# Create a simple startup script
cat > start.sh << 'EOF'
#!/bin/bash
export RUST_LOG=info
./target/x86_64-unknown-linux-gnu/release/teacher-registry
EOF

chmod +x start.sh

echo "Deployment preparation completed!"
echo "To run the service:"
echo "  ./start.sh"
echo ""
echo "The application will listen on port 8082"