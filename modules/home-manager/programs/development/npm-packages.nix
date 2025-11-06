{ config, pkgs, ... }:

{
  # Configure npm and install global packages
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
    cache=${config.home.homeDirectory}/.npm-cache
  '';

  # Add npm global bin to PATH
  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  # Install npm packages globally via shell hook
  home.activation.npmPackages = ''
    if [ -x "$(command -v npm)" ]; then
      # Ensure npm is configured correctly
      npm config set prefix ${config.home.homeDirectory}/.npm-global
      
      # Install GitHub Copilot CLI if not already installed
      if ! [ -x "$(command -v github-copilot-cli)" ]; then
        echo "Installing GitHub Copilot CLI via npm..."
        npm install -g @githubnext/github-copilot-cli
      fi
    fi
  '';

  # Alternative: use programs.npm if available in your Home Manager version
  # programs.npm = {
  #   enable = true;
  #   packages = [
  #     "@githubnext/github-copilot-cli"
  #   ];
  # };
}