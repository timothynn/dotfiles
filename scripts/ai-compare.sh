#!/usr/bin/env bash
# Compare multiple AI models with the same prompt

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Check Ollama
if ! command -v ollama &> /dev/null; then
    echo "❌ Ollama not installed"
    exit 1
fi

# Ensure service running
if ! pgrep -x ollama > /dev/null; then
    echo "🚀 Starting Ollama service..."
    ollama serve > /dev/null 2>&1 &
    sleep 2
fi

# Usage
if [ $# -eq 0 ]; then
    echo "Usage: ai-compare <prompt>"
    echo ""
    echo "This will run your prompt against all installed models and compare:"
    echo "  • Response time"
    echo "  • Response quality"
    echo "  • Memory usage"
    echo ""
    echo "Example:"
    echo "  ai-compare 'Explain what is machine learning'"
    exit 1
fi

PROMPT="$*"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${WHITE}                AI Model Comparison                             ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Prompt:${NC} ${YELLOW}$PROMPT${NC}"
echo ""

# Get installed models
models=$(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}')

if [ -z "$models" ]; then
    echo "❌ No models installed"
    exit 1
fi

# Test each model
while IFS= read -r model; do
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}Testing: ${GREEN}$model${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Get initial memory
    mem_before=$(free -m | awk 'NR==2{print $3}')
    
    # Time the response
    start=$(date +%s)
    response=$(ollama run "$model" "$PROMPT" 2>&1)
    end=$(date +%s)
    duration=$((end - start))
    
    # Get memory after
    mem_after=$(free -m | awk 'NR==2{print $3}')
    mem_used=$((mem_after - mem_before))
    
    # Display results
    echo -e "${GREEN}Response:${NC}"
    echo "$response"
    echo ""
    echo -e "${YELLOW}⏱️  Time: ${duration}s${NC}"
    echo -e "${YELLOW}💾 Memory: ${mem_used}MB${NC}"
    
    # Wait a bit before next model
    sleep 2
    
done <<< "$models"

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${WHITE}                Comparison Complete                             ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
