#!/bin/bash

# Script to clean up repository for GitHub push

echo "Cleaning up repository for GitHub push..."

# Remove target directory from Git tracking but keep locally
echo "Removing large binary files from Git tracking..."
git rm -r --cached target/

# Remove any potential large files from debug directories
git rm -r --cached --ignore-unmatch target/debug/
git rm -r --cached --ignore-unmatch target/release/

# Add .gitignore file
echo "Adding .gitignore to Git..."
git add .gitignore

# Add all other files
echo "Adding source files to Git..."
git add src/ Cargo.toml Cargo.lock README.md DEPLOYMENT_LINUX.md coolify-static-deploy.sh start-nixpacks.sh teacher-registry.service Dockerfile docker-compose.yml build-linux.sh

# Create a commit
echo "Creating a clean commit..."
git commit -m "Clean repository: Remove binary files and add .gitignore"

echo "Repository cleaned and ready for push."
echo "You can now run: git push"