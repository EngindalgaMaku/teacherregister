#!/bin/bash

# This is a simple debugging script to help find where files are located
echo "========= DEBUGGING INFO ========="
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la
echo "Environment variables:"
env | sort
echo "=================================="

# Try to find and run the teacher-registry binary
find / -name "teacher-registry" -type f 2>/dev/null

# Try different possible locations
if [ -f "./teacher-registry" ]; then
    chmod +x ./teacher-registry
    ./teacher-registry
elif [ -f "./public/teacher-registry" ]; then
    chmod +x ./public/teacher-registry
    ./public/teacher-registry
elif [ -f "/app/public/teacher-registry" ]; then
    chmod +x /app/public/teacher-registry
    /app/public/teacher-registry
else
    echo "ERROR: Could not find teacher-registry binary"
    exit 1
fi