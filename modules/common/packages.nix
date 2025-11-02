# Centralized Package Registry
# Single source of truth for all package installations
# Categorized by domain to eliminate duplication
{ pkgs }:

{
  # === VERSION CONTROL ===
  vcs = with pkgs; [
    git
    gh
    lazygit
  ];

  # === SYSTEM MONITORING ===
  monitoring = with pkgs; [
    bottom
    htop
  ];

  # === DEVELOPMENT UTILITIES ===
  devUtils = with pkgs; [
    hyperfine # Benchmarking
    direnv
    devenv
  ];

  # === NETWORK TOOLS ===
  network = with pkgs; [
    curl
    dog # Modern dig
    netcat
    nmap
  ];

  # === BACKUP & SYNC ===
  backup = with pkgs; [
    restic
    rclone
    rsync
  ];

  # === FILE MANAGEMENT ===
  files = with pkgs; [
    yazi # Terminal file manager
    xfce.thunar # GUI file manager
    xfce.thunar-volman # Thunar volume manager
    kdePackages.dolphin # KDE file manager
    peazip
    p7zip
    unzip
    zstd
  ];

  # === NIX HELPERS ===
  nixHelpers = with pkgs; [
    nix-tree
    nix-du
    nh
  ];

  # === SHELL UTILITIES ===
  shellUtils = with pkgs; [
    tldr
    dust
    procs
    choose
    sd
    tokei
    gitui
  ];

  # === CLIPBOARD & SCREENSHOTS ===
  desktop = with pkgs; [
    wl-clipboard
    cliphist
    grimblast
    hyprpicker
  ];

  # === AUDIO/VIDEO ===
  audioVideo = with pkgs; [
    pavucontrol
    pwvucontrol
  ];

  # === HYPRLAND EXTRAS ===
  hyprland = with pkgs; [
    pyprland
    hyprsunset
    hyprlock
    hypridle
    hyprpaper
  ];

  # === CONTAINERS ===
  containers = with pkgs; [
    buildah
    skopeo
    dive
  ];

  # === KUBERNETES ===
  kubernetes = with pkgs; [
    kubectl
    kubectx
    k9s
    helm
    kustomize
    stern
  ];

  # === INFRASTRUCTURE AS CODE ===
  iac = with pkgs; [
    terraform
    ansible
  ];

  # === API TESTING ===
  apiTools = with pkgs; [
    insomnia
    bruno
    httpie
    xh
    grpcurl
    evans
  ];

  # === LOAD TESTING ===
  loadTesting = with pkgs; [
    k6
    hey
    wrk
  ];

  # === SECURITY ===
  security = with pkgs; [
    sops
    age
    trivy
    openssl
    mkcert
  ];

  # === PROTOCOL BUFFERS ===
  protobuf = with pkgs; [
    protobuf
    buf
  ];

  # === DOCUMENTATION ===
  docs = with pkgs; [
    mkdocs
  ];
}
