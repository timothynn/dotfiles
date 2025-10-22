{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      # Get editor completions based on the config schema
      "$schema" = "https://starship.rs/config-schema.json";

      # Inserts a blank line between shell prompts
      add_newline = true;

      # Replace the "❯" symbol in the prompt with "➜"
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      # Disable the package module, hiding it from the prompt completely
      package.disabled = true;

      # Configure directory display
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      # Git configuration
      git_branch = {
        symbol = "🌱 ";
        truncation_length = 20;
      };

      git_status = {
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        renamed = "r";
        deleted = "✘";
      };

      # Language specific
      nix_shell = {
        format = "via [☃️  $state( \\($name\\))](bold blue) ";
      };
    };
  };
}