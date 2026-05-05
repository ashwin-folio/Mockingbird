#!/bin/bash
# Mockingbird Quick Start for macOS/Linux
# ========================================
# Run this script to start Mockingbird

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Change to project directory
cd "$PROJECT_DIR"

echo ""
echo "Starting Mockingbird..."
echo "Project directory: $PROJECT_DIR"
echo ""

# Check for .env
if [ ! -f "$PROJECT_DIR/.env" ]; then
    echo "[WARNING] .env file not found!"
    echo "Run scripts/setup.sh first or copy .env.example to .env"
    echo ""
fi

# Start Claude Code
claude
