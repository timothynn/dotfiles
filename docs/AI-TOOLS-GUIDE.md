# AI Tools Management Guide

Complete guide for managing local LLMs on your Intel i5-6300U laptop.

## 📦 What's Included

I've created **5 powerful helper scripts** for managing your local AI models:

### 1. **ollama-manager.sh** - Main Management Tool
Complete Ollama management with:
- Model installation and removal
- Resource monitoring
- Benchmarking
- Quick setup
- Usage logging
- Interactive cleanup

### 2. **ai-switch.sh** - Fuzzy Model Switcher
Quick model switching with:
- FZF integration
- Live preview
- Instant switching
- Visual selection

### 3. **ai-ask.sh** - One-Shot Queries
Fast single queries without interactive mode:
- Model-specific shortcuts
- Code optimization mode
- Quick responses
- No interactive session

### 4. **ai-monitor.sh** - Real-Time Monitor
Live resource monitoring showing:
- Memory usage with graphs
- CPU usage
- Loaded models
- System recommendations
- Auto-refresh every 2s

### 5. **ai-compare.sh** - Model Comparison
Compare multiple models with same prompt:
- Side-by-side comparison
- Response time tracking
- Memory usage comparison
- Quality assessment

## 📁 File Placement

### Scripts Location
```
~/.dotfiles/
├── scripts/
│   ├── ollama-manager.sh       # Main manager
│   ├── ai-switch.sh            # Model switcher
│   ├── ai-ask.sh               # Quick queries
│   ├── ai-monitor.sh           # Resource monitor
│   ├── ai-compare.sh           # Model comparison
│   └── setup-ollama.sh         # Initial setup
```

### Home Manager Module
```
~/.dotfiles/
└── modules/home-manager/programs/
    └── ai-tools/
        └── default.nix         # Integrates all scripts
```

## 🚀 Installation

### Step 1: Copy Script Files
```bash
cd ~/.dotfiles/scripts

# Copy all 5 helper scripts from the artifacts above
# Make them executable
chmod +x ollama-manager.sh ai-switch.sh ai-ask.sh ai-monitor.sh ai-compare.sh
```

### Step 2: Create Home Manager Module
```bash
mkdir -p ~/.dotfiles/modules/home-manager/programs/ai-tools
cd ~/.dotfiles/modules/home-manager/programs/ai-tools

# Copy the default.nix from artifact above
nano default.nix
```

### Step 3: Add to Imports
Edit `~/.dotfiles/modules/home-manager/programs/default.nix`:
```nix
{
  imports = [
    # ... existing imports ...
    ./ai-tools
  ];
}
```

### Step 4: Rebuild Home Manager
```bash
cd ~/.dotfiles
make switch-home
```

### Step 5: Install Models
```bash
# Quick install all recommended models
ollama-manager quick-install

# Or install individually
ollama-manager install qwen2.5:3b
```

## 💻 Usage Examples

### Basic AI Queries
```bash
# Use default model (Qwen 2.5 3B)
ai "What is machine learning?"

# Fast responses (Phi-3)
ai-fast "Quick fact about Mars"

# Reasoning tasks (DeepSeek R1)
ai-reason "Solve: If 5 machines make 5 widgets..."

# Quick queries (Gemma 2B)
ai-quick "What is 2+2?"
```

### One-Shot Queries (No Interactive Mode)
```bash
# Quick query without entering chat
ai-ask "Explain Python decorators"

# Fast mode
ai-ask --fast "What is TypeScript?"

# Reasoning mode
ai-ask --reason "Calculate compound interest"

# Code mode
ai-ask --code "Write a function to reverse a string"

# Custom model
ai-ask --model llama3.2:3b "Your question"
```

### Model Management
```bash
# List installed models
ollama-manager list
aim list  # Short alias

# Show recommended models
ollama-manager recommended

# Install a model
ollama-manager install phi3:mini

# Remove a model
ollama-manager remove gemma:2b

# Quick install all recommended
ollama-manager quick-install
ai-install  # Short alias

# Interactive cleanup
ollama-manager cleanup
ai-clean  # Short alias
```

### Model Switching
```bash
# Fuzzy finder model switcher
ai-switch
ais  # Short alias

# Use arrow keys to select, Enter to start chat
```

### Testing & Benchmarking
```bash
# Test a model with simple prompt
ollama-manager test qwen2.5:3b

# Benchmark model performance
ollama-manager benchmark phi3:mini

# Compare multiple models
ai-compare "Explain quantum computing"
aicmp "Explain quantum computing"  # Short alias
```

### Resource Monitoring
```bash
# Real-time resource monitor
ai-monitor
aimon  # Short alias

# Check current resources
ollama-manager resources
ai-status  # Short alias
```

### Interactive Chat
```bash
# Start chat with default model
ollama-manager chat

# Start chat with specific model
ollama-manager chat deepseek-r1:1.5b

# Or use Ollama directly
ollama run qwen2.5:3b
```

## 🎯 Complete Command Reference

### Quick Aliases (Always Available)
| Alias | Command | Model | Use Case |
|-------|---------|-------|----------|
| `ai` | `ollama run qwen2.5:3b` | Qwen 2.5 3B | Daily driver |
| `ai-fast` | `ollama run phi3:mini` | Phi-3 | Fast responses |
| `ai-reason` | `ollama run deepseek-r1:1.5b` | DeepSeek R1 | Reasoning |
| `ai-quick` | `ollama run gemma:2b` | Gemma 2B | Quick queries |

### Management Aliases
| Alias | Command | Description |
|-------|---------|-------------|
| `aim` | `ollama-manager` | Main manager |
| `ais` | `ai-switch` | Model switcher |
| `aiq` | `ai-ask` | Quick query |
| `aimon` | `ai-monitor` | Resource monitor |
| `aicmp` | `ai-compare` | Compare models |
| `ai-install` | `ollama-manager quick-install` | Install all |
| `ai-clean` | `ollama-manager cleanup` | Clean models |
| `ai-status` | `ollama-manager resources` | Check resources |

### Ollama Direct Commands
| Command | Description |
|---------|-------------|
| `ai-list` | List models |
| `ai-pull` | Pull/download model |
| `ai-rm` | Remove model |
| `ai-ps` | Show running models |
| `ai-stop` | Stop a model |

## 📊 Model Recommendations

### For Your Intel i5-6300U (7.4GB RAM)

| Model | RAM | Speed | Quality | Best For |
|-------|-----|-------|---------|----------|
| **qwen2.5:3b** | 2-3GB | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Daily driver |
| **phi3:mini** | 2.3GB | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Coding help |
| **deepseek-r1:1.5b** | 1-2GB | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Math/reasoning |
| **gemma:2b** | 1.6GB | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | Quick tasks |
| llama3.2:3b | 2-3GB | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | General purpose |
| deepseek-r1:7b-q4 | 5-6GB | ⭐⭐ | ⭐⭐⭐⭐⭐ | Heavy reasoning |

### Installation Guide
```bash
# Start with essentials (7-9GB download)
ollama-manager quick-install

# Or install one by one
ollama-manager install qwen2.5:3b
ollama-manager install phi3:mini
ollama-manager install deepseek-r1:1.5b
ollama-manager install gemma:2b
```

## 🔋 Performance Tips

### Maximize Performance
```bash
# 1. Check available RAM before using
ai-status

# 2. Close other applications
# Close browser tabs, stop databases, close IDEs

# 3. Use appropriate model size
# Small task? Use gemma:2b
# Complex task? Use qwen2.5:3b
# Need reasoning? Use deepseek-r1:1.5b

# 4. Monitor resources while running
# Open in another terminal
ai-monitor
```

### Save Battery
```bash
# Use smaller models
ai-quick "your question"  # Uses gemma:2b

# Stop model when done
ai-stop model-name

# Don't keep multiple models loaded
ollama ps  # Check what's running
```

### Memory Management
```bash
# Before running large model:
# 1. Stop databases
sudo systemctl stop postgresql redis mongodb

# 2. Close applications
# 3. Check available memory
ai-status

# 4. Run model
ai "your question"

# 5. Restart services after
sudo systemctl start postgresql redis
```

## 🎓 Practical Workflows

### Coding Assistant Workflow
```bash
# Quick syntax help
ai-ask --fast "Python list comprehension syntax"

# Code generation
ai-ask --code "Write a binary search function in Python"

# Debugging help
ai "Why is my function returning None?"

# Code review
ai-ask "Review this code: [paste code]"
```

### Learning & Research Workflow
```bash
# Quick facts
ai-quick "What is REST API?"

# Deep explanations
ai "Explain how neural networks work in detail"

# Problem solving
ai-reason "Solve this math problem step by step: ..."

# Compare explanations
ai-compare "Explain Docker containers"
```

### Data Science Workflow
```bash
# Quick queries about libraries
ai-fast "pandas merge vs join"

# Algorithm explanations
ai "Explain random forest algorithm"

# Code generation
ai-ask --code "Write sklearn pipeline for text classification"

# Debugging data issues
ai "Why am I getting NaN values in pandas?"
```

### Writing & Documentation
```bash
# Quick drafts
ai-quick "Write a short introduction about Python"

# Detailed writing
ai "Write comprehensive documentation for this API: ..."

# Proofreading
ai "Improve this text: [your text]"

# Ideas generation
ai "Give me 10 ideas for blog posts about DevOps"
```

## 🔍 Troubleshooting

### Models Not Loading
```bash
# Check service
ai-status

# Restart Ollama
pkill ollama
ollama serve > /dev/null 2>&1 &

# Re-pull model
ollama-manager install qwen2.5:3b
```

### Slow Responses
```bash
# Check resources
ai-monitor

# Try smaller model
ai-quick "your question"

# Close other apps
# Stop databases: sudo systemctl stop postgresql redis mongodb
```

### Out of Memory
```bash
# Remove unused models
ai-clean

# Use smallest model
ai-quick "your question"

# Check disk space
df -h
```

### Command Not Found
```bash
# Rebuild home-manager
cd ~/.dotfiles
make switch-home

# Source zshrc
source ~/.zshrc

# Check installation
which ollama-manager
```

## 📚 Advanced Usage

### Environment Variables
```bash
# Set default model
export AI_MODEL="phi3:mini"
ai "question"  # Uses phi3:mini

# Set Ollama host
export OLLAMA_HOST="0.0.0.0:11434"
```

### Scripting with AI
```bash
# Use in scripts
response=$(ai-ask "Generate random password" | tail -1)
echo "Password: $response"

# Batch processing
cat questions.txt | while read question; do
    ai-ask "$question" >> answers.txt
done
```

### Integration with Other Tools
```bash
# Pipe to AI
git diff | ai-ask "Explain these changes"

# Use with fzf
model=$(ollama list | tail -n +2 | fzf | awk '{print $1}')
ollama run "$model"
```

## 📈 Usage Statistics

```bash
# View usage log
ollama-manager log

# Log location
cat ~/.ollama/usage.log

# Model storage
du -sh ~/.ollama/models
```

## ✅ Quick Start Checklist

- [ ] Copy all 5 scripts to `~/.dotfiles/scripts/`
- [ ] Make scripts executable (`chmod +x`)
- [ ] Create AI tools module in home-manager
- [ ] Add module to imports
- [ ] Rebuild home-manager (`make switch-home`)
- [ ] Install recommended models (`ai-install`)
- [ ] Test basic commands (`ai "hello"`)
- [ ] Try model switcher (`ais`)
- [ ] Monitor resources (`aimon`)
- [ ] Set up for your workflow

## 🎉 You're All Set!

You now have a complete AI assistant system on your laptop with:
- 🤖 Multiple AI models optimized for your hardware
- ⚡ Fast, efficient management tools
- 📊 Real-time resource monitoring
- 🔄 Easy model switching
- 💻 Perfect integration with your workflow

**Start chatting:** `ai "Let's get started!"`

---

*Optimized for Intel i5-6300U with 7.4GB RAM*
