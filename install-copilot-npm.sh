#!/usr/bin/env bash

# Script to install GitHub Copilot CLI via npm
# This is an alternative to the nixpkgs version

echo "Installing GitHub Copilot CLI via npm..."

# Install the official GitHub Copilot CLI
npm install -g @githubnext/github-copilot-cli

# Verify installation
if command -v github-copilot-cli &> /dev/null; then
    echo "✅ GitHub Copilot CLI installed successfully via npm"
    github-copilot-cli --version
else
    echo "❌ Installation failed"
    exit 1
fi

echo "You can now use: github-copilot-cli"
echo "Or set up aliases in your shell config"