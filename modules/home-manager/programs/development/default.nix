{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
  ];

  # Comprehensive development tools for all engineering roles
  home.packages = with pkgs; [
    # Version Control
    gh
    git-lfs
    lazygit
    delta
    diff-so-fancy
    
    # Development Environments
    devenv
    direnv
    
    # Programming Languages
    (python3.withPackages (ps: with ps; [
      # Data Science & ML
      pandas
      numpy
      scipy
      scikit-learn
      matplotlib
      seaborn
      jupyter
      ipython
      notebook
      jupyterlab
      plotly
      bokeh
      statsmodels
      
      # Data Engineering
      sqlalchemy
      psycopg2
      pymongo
      redis
      pyarrow
      
      # Development Tools
      pytest
      black
      flake8
      mypy
      ipdb
      pydantic
      fastapi
      flask
      requests
      httpx
      
      # GUI
      tkinter
    ]))
    
    # Python tools
    poetry
    pipenv
    uv
    ruff
    
    # JavaScript/TypeScript
    nodejs_22
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    bun
    
    # Rust
    rustup
    cargo
    rust-analyzer
    
    # Go
    go
    gopls
    golangci-lint
    
    # Java/JVM
    jdk17
    gradle
    maven
    
    # Database Clients
    dbeaver-bin
    pgcli
    mycli
    
    # API Development
    postman
    insomnia
    httpie
    xh
    
    # Container & Orchestration
    lazydocker
    kubectl
    kubectx
    k9s
    helm
    
    # Cloud CLIs
    awscli2
    google-cloud-sdk
    
    # AI/ML Tools
    github-copilot-cli
    ollama
    
    # Terminal Tools
    tmux
    
    # Build Tools
    cmake
    gnumake
    
    # Documentation
    pandoc
    
    # Text Processing
    jq
    yq-go
    
    # Performance Analysis
    hyperfine
  ];

  # Enable direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # VSCode configuration
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Python
      ms-python.python
      ms-python.vscode-pylance
      
      # JavaScript/TypeScript
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      
      # Rust
      rust-lang.rust-analyzer
      
      # Docker
      ms-azuretools.vscode-docker
      
      # Git
      eamodio.gitlens
      
      # Database
      mtxr.sqltools
      
      # YAML
      redhat.vscode-yaml
      
      # Nix
      jnoortheen.nix-ide
    ];
    
    userSettings = {
      "editor.fontSize" = 13;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
      "editor.formatOnSave" = true;
      "files.autoSave" = "afterDelay";
      "workbench.colorTheme" = "Catppuccin Mocha";
    };
  };
}
