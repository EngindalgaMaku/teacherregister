# Teacher Registry API - Linux Deployment Guide

This guide explains how to deploy the Teacher Registry API to a Linux server, including deployment with Coolify.

## Prerequisites

1. **Linux Server** - Ubuntu 20.04/22.04 or similar Debian-based distribution
2. **Docker** - Installed and running on the server
3. **Git** - For cloning the repository
4. **Coolify** - If using Coolify for deployment

## Deployment Options

### Option 1: Manual Docker Deployment

1. **Clone the repository**:
   ```bash
   git clone [repository-url]
   cd teacher-registry
   ```

2. **Build and run with Docker**:
   ```bash
   docker build -t teacher-registry .
   docker run -d -p 8082:8082 --name teacher-registry teacher-registry
   ```

3. **Or use docker-compose**:
   ```bash
   docker-compose up -d
   ```

### Option 2: Coolify Deployment (Docker Method)

1. **Connect your Git repository to Coolify**
2. **Set the deployment configuration**:
   - **Build Pack**: Dockerfile
   - **Dockerfile Path**: ./Dockerfile
   - **Port**: 8082
   - **Environment Variables**:
     - `RUST_LOG=info` (optional, for logging)

3. **Deploy the application**

### Option 2b: Coolify Deployment (Static Build Pack)

If you're experiencing issues with Docker on your Coolify server, you can use the Static build pack:

1. **Ensure your repository includes**:
   - [coolify-static-deploy.sh](coolify-static-deploy.sh) (the build script for Static deployment)
   - All source code files including [src/main.rs](src/main.rs)
   - [Cargo.toml](Cargo.toml) and [Cargo.lock](Cargo.lock)

2. **In Coolify, configure the deployment**:
   - **Build Pack**: Static
   - **Build Command**: `bash coolify-static-deploy.sh`
   - **Start Command**: `./start.sh`
   - **Port**: 8082
   - **Environment Variables**:
     - `RUST_LOG=info` (optional, for logging)

3. **Deploy the application**

Coolify will automatically:
   - Run the build script to install Rust and compile the application
   - Create the public directory with the binary and start script
   - Run the application on port 8082

### Option 2c: Coolify Deployment (Nixpacks Build Pack)

Nixpacks is another option that can automatically build Rust applications:

1. **Ensure your repository includes**:
   - Your Rust source code
   - [start-nixpacks.sh](start-nixpacks.sh) (the start script)
   - [Cargo.toml](Cargo.toml) and [Cargo.lock](Cargo.lock)

2. **In Coolify, configure the deployment**:
   - **Build Pack**: Nixpacks
   - **Start Command**: `bash start-nixpacks.sh`
   - **Port**: 8082
   - **Environment Variables**:
     - `RUST_LOG=info` (optional, for logging)

3. **Deploy the application**

Coolify will use Nixpacks to automatically:
   - Detect the Rust application
   - Install Rust and necessary dependencies
   - Build the application
   - Start it using your start script

### Option 3: Manual Binary Deployment

1. **Build for Linux**:
   ```bash
   # On a Linux machine or using cross-compilation
   cargo build --release --target x86_64-unknown-linux-gnu
   ```

2. **Copy the binary to your server**:
   ```bash
   scp target/x86_64-unknown-linux-gnu/release/teacher-registry user@your-server:/path/to/deployment/
   ```

3. **Run the binary on the server**:
   ```bash
   ./teacher-registry
   ```

## Environment Variables

- `RUST_LOG` - Set logging level (info, debug, error, etc.)

## Firewall Configuration

Ensure port 8082 is open on your server's firewall:
```bash
# For UFW (Ubuntu)
sudo ufw allow 8082

# For iptables
sudo iptables -A INPUT -p tcp --dport 8082 -j ACCEPT
```

## Health Check

You can verify the API is running by accessing:
```
GET http://your-server-ip:8082/teachers
```

This should return an empty JSON object `{}` if the API is running correctly.

## Logs

View logs with:
```bash
# For Docker
docker logs teacher-registry

# For Coolify
# Check through Coolify dashboard

# For manual deployment
# Logs are printed to stdout
```

## Updating the Deployment

### With Docker
```bash
docker stop teacher-registry
docker rm teacher-registry
docker rmi teacher-registry
# Pull new code if using Git
git pull
# Rebuild and run
docker build -t teacher-registry .
docker run -d -p 8082:8082 --name teacher-registry teacher-registry
```

### With Coolify
Simply redeploy through the Coolify interface after pushing changes to your Git repository.

## Troubleshooting

### Port Already in Use
```bash
# Check what's using port 8082
sudo lsof -i :8082
# Kill the process if needed
sudo kill -9 [PID]
```

### Permission Denied
Ensure the binary has execute permissions:
```bash
chmod +x teacher-registry
```

### Network Issues
Verify the server can accept connections on port 8082:
```bash
# Test locally
curl http://localhost:8082/teachers
```