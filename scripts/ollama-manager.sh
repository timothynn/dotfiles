#!/usr/bin/env bash
# Ollama Management Script for Intel i5-6300U Laptop
# Comprehensive LLM management with resource monitoring

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
MODELS_DIR="$HOME/.ollama/models"
LOG_FILE="$HOME/.ollama/usage.log"

# Helper functions
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${WHITE}                    Ollama Manager                              ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo -e "${CYAN}▶ $1${NC}"
    echo ""
}

check_ollama() {
    if ! command -v ollama &> /dev/null; then
        echo -e "${RED}❌ Ollama is not installed!${NC}"
        echo "Install with: curl -fsSL https://ollama.com/install.sh | sh"
        exit 1
    fi
}

ensure_service() {
    if ! pgrep -x ollama > /dev/null; then
        echo -e "${YELLOW}⚠️  Ollama service not running. Starting...${NC}"
        ollama serve > /dev/null 2>&1 &
        sleep 2
        echo -e "${GREEN}✅ Ollama service started${NC}"
        echo ""
    fi
}

get_ram_usage() {
    free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2 }'
}

get_available_ram() {
    free -m | awk 'NR==2{printf "%.0fMB", $7}'
}

list_models() {
    print_section "Installed Models"
    
    if [ ! -d "$MODELS_DIR" ] || [ -z "$(ls -A $MODELS_DIR 2>/dev/null)" ]; then
        echo -e "${YELLOW}No models installed yet${NC}"
        echo ""
        return
    fi
    
    echo -e "${WHITE}Name                    Size        RAM Usage   Speed${NC}"
    echo "────────────────────────────────────────────────────────────"
    
    ollama list 2>/dev/null || echo "Unable to list models"
    echo ""
}

show_recommended_models() {
    print_section "Recommended Models for Your Laptop (7.4GB RAM)"
    
    cat << EOF
${GREEN}✅ Highly Recommended:${NC}
  📦 qwen2.5:3b          2-3GB RAM    ⭐⭐⭐⭐⭐  Best all-around
  📦 phi3:mini           2.3GB RAM    ⭐⭐⭐⭐    Fast coding
  📦 deepseek-r1:1.5b    1-2GB RAM    ⭐⭐⭐⭐⭐  Reasoning tasks
  📦 gemma:2b            1.6GB RAM    ⭐⭐⭐⭐⭐  Quick queries

${YELLOW}⚠️  Use Carefully:${NC}
  📦 llama3.2:3b         2-3GB RAM    ⭐⭐⭐⭐    General purpose
  📦 mistral:7b-q4       4-5GB RAM    ⭐⭐⭐      Better quality (slow)
  📦 deepseek-r1:7b-q4   5-6GB RAM    ⭐⭐       Best reasoning (very slow)

${RED}❌ Not Recommended (Too Large):${NC}
  📦 Any 13B+ models - Will be extremely slow or crash

EOF
}

install_model() {
    local model="$1"
    
    print_section "Installing Model: $model"
    
    # Check available RAM
    local available_ram=$(free -m | awk 'NR==2{print $7}')
    if [ "$available_ram" -lt 2000 ]; then
        echo -e "${RED}⚠️  Warning: Low available RAM (${available_ram}MB)${NC}"
        echo "Consider closing other applications first."
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    echo -e "${BLUE}📥 Downloading $model...${NC}"
    echo ""
    
    if ollama pull "$model"; then
        echo ""
        echo -e "${GREEN}✅ Successfully installed $model${NC}"
        
        # Log installation
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Installed: $model" >> "$LOG_FILE"
    else
        echo ""
        echo -e "${RED}❌ Failed to install $model${NC}"
    fi
    echo ""
}

remove_model() {
    local model="$1"
    
    echo -e "${YELLOW}⚠️  Removing model: $model${NC}"
    read -p "Are you sure? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if ollama rm "$model"; then
            echo -e "${GREEN}✅ Removed $model${NC}"
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Removed: $model" >> "$LOG_FILE"
        else
            echo -e "${RED}❌ Failed to remove $model${NC}"
        fi
    fi
    echo ""
}

test_model() {
    local model="$1"
    
    print_section "Testing Model: $model"
    
    echo -e "${CYAN}Starting model (this may take a moment)...${NC}"
    echo ""
    
    # Simple test prompt
    local prompt="Say 'Hello! I am working correctly.' in one sentence."
    
    echo -e "${WHITE}Prompt: $prompt${NC}"
    echo ""
    echo -e "${GREEN}Response:${NC}"
    
    time ollama run "$model" "$prompt"
    
    echo ""
}

benchmark_model() {
    local model="$1"
    
    print_section "Benchmarking Model: $model"
    
    echo -e "${CYAN}Running benchmark tests...${NC}"
    echo ""
    
    # Test prompts of varying complexity
    local prompts=(
        "What is 2+2?"
        "Write a Python function to calculate fibonacci numbers"
        "Explain the concept of machine learning in simple terms"
    )
    
    for i in "${!prompts[@]}"; do
        echo -e "${YELLOW}Test $((i+1))/3: ${prompts[$i]}${NC}"
        echo ""
        
        local start=$(date +%s)
        ollama run "$model" "${prompts[$i]}" > /dev/null 2>&1
        local end=$(date +%s)
        local duration=$((end - start))
        
        echo -e "${GREEN}✅ Completed in ${duration}s${NC}"
        echo ""
    done
    
    echo -e "${CYAN}Benchmark complete!${NC}"
    echo ""
}

show_resource_usage() {
    print_section "System Resources"
    
    # RAM usage
    local total_ram=$(free -m | awk 'NR==2{printf "%.0fMB", $2}')
    local used_ram=$(free -m | awk 'NR==2{printf "%.0fMB", $3}')
    local available_ram=$(free -m | awk 'NR==2{printf "%.0fMB", $7}')
    local ram_percent=$(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2}')
    
    echo -e "${WHITE}Memory:${NC}"
    echo "  Total:     $total_ram"
    echo "  Used:      $used_ram ($ram_percent)"
    echo "  Available: $available_ram"
    echo ""
    
    # Disk usage for models
    if [ -d "$MODELS_DIR" ]; then
        local models_size=$(du -sh "$MODELS_DIR" 2>/dev/null | cut -f1)
        echo -e "${WHITE}Ollama Models:${NC}"
        echo "  Location: $MODELS_DIR"
        echo "  Size:     $models_size"
        echo ""
    fi
    
    # Check if Ollama is running
    if pgrep -x ollama > /dev/null; then
        local ollama_pid=$(pgrep -x ollama)
        local ollama_mem=$(ps -p $ollama_pid -o rss= | awk '{printf "%.0fMB", $1/1024}')
        echo -e "${WHITE}Ollama Service:${NC}"
        echo "  Status:    ${GREEN}Running${NC}"
        echo "  PID:       $ollama_pid"
        echo "  Memory:    $ollama_mem"
    else
        echo -e "${WHITE}Ollama Service:${NC}"
        echo "  Status:    ${RED}Not running${NC}"
    fi
    echo ""
}

quick_install_recommended() {
    print_section "Quick Install - Recommended Models"
    
    echo "This will install the 4 recommended models for your laptop:"
    echo "  • Qwen 2.5 3B (2-3GB)"
    echo "  • Phi-3 Mini (2.3GB)"
    echo "  • DeepSeek R1 1.5B (1-2GB)"
    echo "  • Gemma 2B (1.6GB)"
    echo ""
    echo "Total download: ~7-9GB"
    echo "This may take 15-30 minutes depending on your internet speed."
    echo ""
    
    read -p "Continue? (y/N) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi
    
    ensure_service
    
    local models=("qwen2.5:3b" "phi3:mini" "deepseek-r1:1.5b" "gemma:2b")
    local total=${#models[@]}
    
    for i in "${!models[@]}"; do
        echo ""
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${WHITE}Installing model $((i+1))/$total: ${models[$i]}${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        
        ollama pull "${models[$i]}"
    done
    
    echo ""
    echo -e "${GREEN}✅ All recommended models installed!${NC}"
    echo ""
    echo "🎯 Quick start:"
    echo "  ai 'your question'        # Use Qwen 2.5 3B"
    echo "  ai-fast 'your question'   # Use Phi-3"
    echo "  ai-reason 'your question' # Use DeepSeek R1"
    echo "  ai-quick 'your question'  # Use Gemma"
    echo ""
}

show_usage_log() {
    print_section "Usage Log"
    
    if [ ! -f "$LOG_FILE" ]; then
        echo "No usage log yet"
        echo ""
        return
    fi
    
    echo -e "${WHITE}Recent activity:${NC}"
    tail -n 20 "$LOG_FILE"
    echo ""
}

cleanup_models() {
    print_section "Model Cleanup"
    
    echo "This will:"
    echo "  1. List all installed models"
    echo "  2. Show their sizes"
    echo "  3. Let you remove models interactively"
    echo ""
    
    read -p "Continue? (y/N) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi
    
    echo ""
    ollama list
    echo ""
    
    read -p "Enter model name to remove (or 'done' to finish): " model_name
    
    while [ "$model_name" != "done" ]; do
        if [ -n "$model_name" ]; then
            remove_model "$model_name"
        fi
        
        echo ""
        ollama list
        echo ""
        read -p "Enter model name to remove (or 'done' to finish): " model_name
    done
    
    echo -e "${GREEN}✅ Cleanup complete${NC}"
    echo ""
}

interactive_chat() {
    local model="${1:-qwen2.5:3b}"
    
    print_section "Interactive Chat with $model"
    
    echo -e "${CYAN}Starting interactive session...${NC}"
    echo -e "${YELLOW}Type 'exit' or press Ctrl+C to quit${NC}"
    echo ""
    
    ensure_service
    
    ollama run "$model"
}

show_help() {
    print_header
    
    cat << EOF
${WHITE}Usage:${NC} $0 [command] [options]

${CYAN}Commands:${NC}

  ${WHITE}list${NC}                List installed models
  ${WHITE}recommended${NC}         Show recommended models for your laptop
  ${WHITE}install <model>${NC}     Install a specific model
  ${WHITE}remove <model>${NC}      Remove a model
  ${WHITE}test <model>${NC}        Test a model with simple prompt
  ${WHITE}benchmark <model>${NC}   Benchmark model performance
  ${WHITE}resources${NC}           Show system resource usage
  ${WHITE}quick-install${NC}       Install all recommended models
  ${WHITE}chat [model]${NC}        Start interactive chat (default: qwen2.5:3b)
  ${WHITE}log${NC}                 Show usage log
  ${WHITE}cleanup${NC}             Interactive model cleanup
  ${WHITE}help${NC}                Show this help message

${CYAN}Examples:${NC}

  ${YELLOW}# List installed models${NC}
  $0 list

  ${YELLOW}# Install recommended model${NC}
  $0 install qwen2.5:3b

  ${YELLOW}# Quick install all recommended models${NC}
  $0 quick-install

  ${YELLOW}# Test a model${NC}
  $0 test phi3:mini

  ${YELLOW}# Start interactive chat${NC}
  $0 chat
  $0 chat deepseek-r1:1.5b

  ${YELLOW}# Check system resources${NC}
  $0 resources

  ${YELLOW}# Clean up unused models${NC}
  $0 cleanup

${CYAN}Recommended Models for Intel i5-6300U (7.4GB RAM):${NC}

  ${GREEN}qwen2.5:3b${NC}       - Best daily driver (2-3GB RAM)
  ${GREEN}phi3:mini${NC}        - Fast responses (2.3GB RAM)
  ${GREEN}deepseek-r1:1.5b${NC} - Good reasoning (1-2GB RAM)
  ${GREEN}gemma:2b${NC}         - Lightweight (1.6GB RAM)

${YELLOW}⚠️  Memory Management:${NC}
  • Close browsers and IDEs before using larger models
  • Stop databases when not needed
  • Use 'resources' command to check available RAM
  • Models use 1-6GB depending on size

EOF
}

# Main script
main() {
    check_ollama
    
    case "${1:-help}" in
        list)
            print_header
            list_models
            ;;
        recommended)
            print_header
            show_recommended_models
            ;;
        install)
            if [ -z "${2:-}" ]; then
                echo "Usage: $0 install <model>"
                exit 1
            fi
            print_header
            ensure_service
            install_model "$2"
            ;;
        remove)
            if [ -z "${2:-}" ]; then
                echo "Usage: $0 remove <model>"
                exit 1
            fi
            print_header
            remove_model "$2"
            ;;
        test)
            if [ -z "${2:-}" ]; then
                echo "Usage: $0 test <model>"
                exit 1
            fi
            print_header
            ensure_service
            test_model "$2"
            ;;
        benchmark)
            if [ -z "${2:-}" ]; then
                echo "Usage: $0 benchmark <model>"
                exit 1
            fi
            print_header
            ensure_service
            benchmark_model "$2"
            ;;
        resources)
            print_header
            show_resource_usage
            ;;
        quick-install)
            print_header
            quick_install_recommended
            ;;
        chat)
            print_header
            interactive_chat "${2:-qwen2.5:3b}"
            ;;
        log)
            print_header
            show_usage_log
            ;;
        cleanup)
            print_header
            cleanup_models
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo "Unknown command: $1"
            echo "Run '$0 help' for usage information"
            exit 1
            ;;
    esac
}

main "$@"
