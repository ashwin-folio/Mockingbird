#!/bin/bash
# Mockingbird Setup Script for macOS/Linux
# =========================================
# Run this script to set up Mockingbird

echo ""
echo "====================================="
echo "  Mockingbird Setup"
echo "====================================="
echo ""

# Check if Claude Code is installed
echo "Checking Claude Code installation..."
if command -v claude &> /dev/null; then
    CLAUDE_VERSION=$(claude --version 2>&1)
    echo "[OK] Claude Code is installed: $CLAUDE_VERSION"
else
    echo "[ERROR] Claude Code is not installed."
    echo "Please install from: https://claude.ai/download"
    exit 1
fi

# Get script directory and project path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_PATH="$PROJECT_DIR/.env"
ENV_EXAMPLE_PATH="$PROJECT_DIR/.env.example"

echo ""
echo "Checking environment configuration..."

if [ -f "$ENV_PATH" ]; then
    echo "[OK] .env file exists"

    # Check if API key is set
    if grep -q "OPENROUTER_API_KEY=sk-or-" "$ENV_PATH"; then
        echo "[OK] OpenRouter API key appears to be configured"
    else
        echo "[WARNING] OpenRouter API key may not be set correctly"
        echo "Please edit .env and add your API key from https://openrouter.ai/keys"
    fi
else
    echo "[INFO] .env file not found. Creating from template..."

    if [ -f "$ENV_EXAMPLE_PATH" ]; then
        cp "$ENV_EXAMPLE_PATH" "$ENV_PATH"
        echo "[OK] Created .env file from template"
        echo ""
        echo "IMPORTANT: Edit .env and add your OpenRouter API key"
        echo "Get your key from: https://openrouter.ai/keys"
    else
        echo "[ERROR] .env.example not found"
        exit 1
    fi
fi

# Check outputs directory
OUTPUTS_PATH="$PROJECT_DIR/outputs"
if [ ! -d "$OUTPUTS_PATH" ]; then
    mkdir -p "$OUTPUTS_PATH"
    echo "[OK] Created outputs directory"
fi

echo ""
echo "====================================="
echo "  Setup Complete!"
echo "====================================="
echo ""
echo "Next steps:"
echo "1. Make sure your OpenRouter API key is in .env"
echo "2. Run 'claude' in this directory to start Mockingbird"
echo "3. Claude will guide you through Figma authentication"
echo ""
echo "For help, see docs/SETUP_GUIDE.md"
