{ config, pkgs, ... }:

{
  # AI/ML tools configuration
  home.packages = with pkgs; [
    ollama
    # gollama  # Optional: TUI for Ollama
  ];

  # Ollama shell aliases
  programs.zsh.shellAliases = {
    # Quick AI commands
    ai = "ollama run qwen2.5:3b";
    ai-fast = "ollama run phi3:mini";
    ai-reason = "ollama run deepseek-r1:1.5b";
    ai-quick = "ollama run gemma:2b";
    ai-list = "ollama list";
    ai-pull = "ollama pull";
    ai-stop = "ollama stop";
    ai-ps = "ollama ps";
  };

  # Create helper script for model setup
  home.file.".local/bin/setup-ollama-models" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Setup recommended Ollama models for laptop
      
      echo "🤖 Setting up Ollama models for your laptop..."
      echo ""
      
      # Start Ollama service
      if ! pgrep -x ollama > /dev/null; then
        echo "Starting Ollama service..."
        ollama serve > /dev/null 2>&1 &
        sleep 2
      fi
      
      # Recommended models for Intel i5-6300U with 7.4GB RAM
      echo "📥 Pulling recommended models..."
      echo ""
      
      echo "1/4: Qwen 2.5 3B (Best all-around - 2GB)"
      ollama pull qwen2.5:3b
      
      echo ""
      echo "2/4: Phi-3 Mini (Fast - 2.3GB)"
      ollama pull phi3:mini
      
      echo ""
      echo "3/4: DeepSeek R1 1.5B (Reasoning - 1GB)"
      ollama pull deepseek-r1:1.5b
      
      echo ""
      echo "4/4: Gemma 2B (Lightweight - 1.6GB)"
      ollama pull gemma:2b
      
      echo ""
      echo "✅ Setup complete!"
      echo ""
      echo "🎯 Usage:"
      echo "  ai 'your question'        # Use Qwen 2.5 3B"
      echo "  ai-fast 'your question'   # Use Phi-3"
      echo "  ai-reason 'your question' # Use DeepSeek R1"
      echo "  ai-quick 'your question'  # Use Gemma"
      echo ""
      echo "📊 Installed models:"
      ollama list
    '';
  };

  # Session variables for Ollama
  home.sessionVariables = {
    OLLAMA_MODELS = "${config.home.homeDirectory}/.ollama/models";
  };
}
