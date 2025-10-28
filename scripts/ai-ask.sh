#!/usr/bin/env bash
# Quick one-shot AI query without entering interactive mode

set -euo pipefail

# Default model
MODEL="${AI_MODEL:-qwen2.5:3b}"

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "❌ Ollama not installed"
    exit 1
fi

# Ensure service is running
if ! pgrep -x ollama > /dev/null; then
    echo "🚀 Starting Ollama service..."
    ollama serve > /dev/null 2>&1 &
    sleep 2
fi

# Check for query
if [ $# -eq 0 ]; then
    echo "Usage: ai-ask [options] <query>"
    echo ""
    echo "Options:"
    echo "  -m, --model <model>    Use specific model (default: qwen2.5:3b)"
    echo "  -f, --fast             Use phi3:mini for fast responses"
    echo "  -r, --reason           Use deepseek-r1:1.5b for reasoning"
    echo "  -q, --quick            Use gemma:2b for quick queries"
    echo "  -c, --code             Optimize for code-related queries"
    echo ""
    echo "Examples:"
    echo "  ai-ask 'What is Python?'"
    echo "  ai-ask --fast 'Quick fact about Mars'"
    echo "  ai-ask --reason 'Solve: If 5 machines make 5 widgets...'"
    echo "  ai-ask --code 'Write a function to reverse a string'"
    exit 1
fi

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--model)
            MODEL="$2"
            shift 2
            ;;
        -f|--fast)
            MODEL="phi3:mini"
            shift
            ;;
        -r|--reason)
            MODEL="deepseek-r1:1.5b"
            shift
            ;;
        -q|--quick)
            MODEL="gemma:2b"
            shift
            ;;
        -c|--code)
            MODEL="qwen2.5:3b"
            QUERY="You are a coding assistant. $*"
            shift $#
            break
            ;;
        *)
            QUERY="$*"
            shift $#
            break
            ;;
    esac
done

# Check if model exists
if ! ollama list 2>/dev/null | grep -q "^$MODEL"; then
    echo -e "${YELLOW}⚠️  Model $MODEL not found${NC}"
    echo "Available models:"
    ollama list
    echo ""
    echo "Install with: ollama pull $MODEL"
    exit 1
fi

# Show what we're doing
echo -e "${CYAN}🤖 Using model: ${GREEN}$MODEL${NC}"
echo -e "${CYAN}❓ Query: ${YELLOW}$QUERY${NC}"
echo ""

# Run query
ollama run "$MODEL" "$QUERY"

echo ""
