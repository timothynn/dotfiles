#!/usr/bin/env bash
# Real-time Ollama resource monitor

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Function to get memory bar
get_memory_bar() {
    local used=$1
    local total=$2
    local percent=$(awk "BEGIN {printf \"%.0f\", ($used/$total)*100}")
    local bars=$(awk "BEGIN {printf \"%.0f\", ($percent/5)}")
    
    local color=$GREEN
    if [ $percent -gt 70 ]; then
        color=$YELLOW
    fi
    if [ $percent -gt 85 ]; then
        color=$RED
    fi
    
    printf "${color}"
    for ((i=0; i<bars; i++)); do
        printf "█"
    done
    for ((i=bars; i<20; i++)); do
        printf "░"
    done
    printf "${NC} %3d%%" "$percent"
}

# Main monitoring loop
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${WHITE}              Ollama Resource Monitor                           ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to exit${NC}"
echo ""

while true; do
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${WHITE}              Ollama Resource Monitor                           ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Timestamp
    echo -e "${CYAN}⏰ $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo ""
    
    # Memory usage
    read -r total used available <<< $(free -m | awk 'NR==2{print $2, $3, $7}')
    echo -e "${WHITE}💾 Memory Usage:${NC}"
    echo -n "   Total: ${total}MB | Used: ${used}MB | Available: ${available}MB"
    echo ""
    echo -n "   "
    get_memory_bar $used $total
    echo ""
    echo ""
    
    # Ollama service status
    if pgrep -x ollama > /dev/null; then
        local ollama_pid=$(pgrep -x ollama)
        local ollama_mem=$(ps -p $ollama_pid -o rss= | awk '{printf "%.0f", $1/1024}')
        local ollama_cpu=$(ps -p $ollama_pid -o %cpu= | awk '{printf "%.1f", $1}')
        
        echo -e "${WHITE}🤖 Ollama Service:${NC} ${GREEN}Running${NC}"
        echo "   PID:    $ollama_pid"
        echo "   Memory: ${ollama_mem}MB"
        echo "   CPU:    ${ollama_cpu}%"
    else
        echo -e "${WHITE}🤖 Ollama Service:${NC} ${RED}Not Running${NC}"
    fi
    echo ""
    
    # Loaded models
    echo -e "${WHITE}📦 Loaded Models:${NC}"
    if pgrep -x ollama > /dev/null; then
        local loaded=$(ollama ps 2>/dev/null | tail -n +2)
        if [ -n "$loaded" ]; then
            echo "$loaded" | while IFS= read -r line; do
                echo "   $line"
            done
        else
            echo "   None"
        fi
    else
        echo "   Service not running"
    fi
    echo ""
    
    # Installed models
    echo -e "${WHITE}📚 Installed Models:${NC}"
    local model_count=$(ollama list 2>/dev/null | tail -n +2 | wc -l)
    echo "   Total: $model_count models"
    
    if [ -d "$HOME/.ollama/models" ]; then
        local models_size=$(du -sh "$HOME/.ollama/models" 2>/dev/null | cut -f1)
        echo "   Size:  $models_size"
    fi
    echo ""
    
    # CPU usage
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo -e "${WHITE}⚡ CPU Usage:${NC} ${cpu_usage}%"
    echo ""
    
    # Disk space
    local disk_info=$(df -h / | tail -1 | awk '{print $3 " / " $2 " (" $5 ")"}')
    echo -e "${WHITE}💿 Disk Usage:${NC} $disk_info"
    echo ""
    
    # Temperature (if available)
    if command -v sensors &> /dev/null; then
        local temp=$(sensors 2>/dev/null | grep "Core 0" | awk '{print $3}' | head -1)
        if [ -n "$temp" ]; then
            echo -e "${WHITE}🌡️  CPU Temperature:${NC} $temp"
            echo ""
        fi
    fi
    
    # Recommendations
    echo -e "${CYAN}💡 Recommendations:${NC}"
    if [ $used -gt $((total * 80 / 100)) ]; then
        echo -e "   ${RED}⚠️  High memory usage - consider closing applications${NC}"
    elif [ $used -gt $((total * 60 / 100)) ]; then
        echo -e "   ${YELLOW}⚠️  Moderate memory usage - avoid large models${NC}"
    else
        echo -e "   ${GREEN}✅ Good memory available - ready for any model${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Press Ctrl+C to exit | Refreshing every 2 seconds...${NC}"
    
    sleep 2
done
