#!/bin/bash
# SMASH installation script

set -e

echo "Installing SMASH..."
echo ""

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not installed."
    echo "Please install Python 3 and try again."
    exit 1
fi

# Check for bash
if ! command -v bash &> /dev/null; then
    echo "Error: Bash is required but not installed."
    exit 1
fi

echo "Python 3 found: $(python3 --version)"
echo "Bash found: $(bash --version | head -1)"
echo ""

# Determine installation directory
if [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
elif [ -w "$HOME/.local/bin" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
else
    INSTALL_DIR="$HOME/bin"
    mkdir -p "$INSTALL_DIR"
fi

echo "Installing to: $INSTALL_DIR"

# Download or copy SMASH
if [ -f "smash" ]; then
    # Local installation
    cp smash "$INSTALL_DIR/smash"
    chmod +x "$INSTALL_DIR/smash"
    echo "Copied SMASH to $INSTALL_DIR"
else
    # Download from GitHub
    SMASH_URL="https://raw.githubusercontent.com/flaneurette/smash/main/smash"
    
    if command -v curl &> /dev/null; then
        curl -fsSL "$SMASH_URL" -o "$INSTALL_DIR/smash"
    elif command -v wget &> /dev/null; then
        wget -q "$SMASH_URL" -O "$INSTALL_DIR/smash"
    else
        echo "Error: Neither curl nor wget found."
        echo "   Please install one of them and try again."
        exit 1
    fi
    
    chmod +x "$INSTALL_DIR/smash"
    echo "Downloaded SMASH to $INSTALL_DIR"
fi

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "Warning: $INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add this to your ~/.bashrc or ~/.zshrc:"
    echo "    export PATH=\"\$PATH:$INSTALL_DIR\""
    echo ""
fi

# Test installation
echo ""
echo "Testing installation..."
if "$INSTALL_DIR/smash" -v &> /dev/null; then
    echo "SMASH installed successfully!"
    echo ""
    "$INSTALL_DIR/smash" -v
    echo ""
    echo "Try it out:"
    echo "    smash -h"
    echo ""
    echo "Create your first script:"
    echo "    echo 'let name = \"world\"; echo \"Hello, \" + name;' > hello.smash"
    echo "    smash hello.smash"
else
    echo "Installation verification failed"
    exit 1
fi
