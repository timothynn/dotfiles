{ config, pkgs, ... }:

{
  # AI/ML tools configuration with complete Ollama management
  home.packages = with pkgs; [
    ollama
  ];

  # Install all management scripts
  home.file = {
    # Main Ollama manager
    ".local/bin/ollama-manager" = {
      source = ../../../../scripts/ollama-manager.sh;
      executable = true;
    };
    
    # Quick AI switcher with fzf
    ".local/bin/ai-switch" = {
      source = ../../../../scripts/ai-switch.sh;
      executable = true;
    };
    
    # One-shot query tool
    ".local/bin/ai-ask" = {
      source = ../../../../scripts/ai-ask.sh;
      executable = true;
    };
    
    # Resource monitor
    ".local/bin/ai-monitor" = {
      source = ../../../../scripts/ai-monitor.sh;
      executable = true;
    };
    
    # Model comparison
    ".local/bin/ai-compare" = {
      source = ../../../../scripts/ai-compare.sh;
      executable = true;
    };
  };

  # Comprehensive shell aliases
  programs.zsh.shellAliases = {
    # Quick AI commands (using different models)
    ai = "ollama run qwen2.5:3b";
    ai-fast = "ollama run phi3:mini";
    ai-reason = "ollama run deepseek-r1:1.5b";
    ai-quick = "ollama run gemma:2b";
    
    # Management commands
    ai-list = "ollama list";
    ai-pull = "ollama pull";
    ai-rm = "ollama rm";
    ai-ps = "ollama ps";
    ai-stop = "ollama stop";
    
    # Custom script shortcuts
    aim = "ollama-manager";              # Main manager
    ais = "ai-switch";                   # Fuzzy finder switcher
    aiq = "ai-ask";                      # Quick query
    aimon = "ai-monitor";                # Resource monitor
    aicmp = "ai-compare";                # Compare models
    
    # Quick management
    ai-install = "ollama-manager quick-install";
    ai-clean = "ollama-manager cleanup";
    ai-status = "ollama-manager resources";
  };

  # Session variables for Ollama
  home.sessionVariables = {
    OLLAMA_MODELS = "${config.home.homeDirectory}/.ollama/models";
    AI_MODEL = "qwen2.5:3b";  # Default model
  };

  # Create Ollama config directory
  home.file.".ollama/.keep".text = "";
}
