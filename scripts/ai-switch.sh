#!/usr/bin/env bash
# Quick AI model switcher with fuzzy finder

set -euo pipefail

# Check dependencies
if ! command -v ollama &> /dev/null; then
    echo "❌ Ollama not installed"
    exit 1
fi

if ! command -v fzf &> /dev/null; then
    echo "❌ fzf not installed (should be in your config)"
    exit 1
fi

# Ensure Ollama is running
if ! pgrep -x ollama > /dev/null; then
    echo "🚀 Starting Ollama service..."
    ollama serve > /dev/null 2>&1 &
    sleep 2
fi

# Get list of installed models
models=$(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}')

if [ -z "$models" ]; then
    echo "❌ No models installed"
    echo "Run: ollama-manager quick-install"
    exit 1
fi

# Use fzf to select model
selected=$(echo "$models" | fzf \
    --prompt="Select AI model: " \
    --height=40% \
    --border=rounded \
    --preview="echo 'Model: {}' && echo '' && ollama show {} 2>/dev/null | head -20" \
    --preview-window=right:50%:wrap \
    --header="Use arrow keys to select, Enter to confirm")

if [ -n "$selected" ]; then
    echo "🤖 Starting $selected..."
    echo "Type your question or 'exit' to quit"
    echo ""
    
    ollama run "$selected"
fi
