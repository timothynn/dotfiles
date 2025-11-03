{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  imports = [
    ./git.nix
  ];

  # Development tools
  home.packages =
    packages.vcs
    ++ packages.devUtils
    ++ (with pkgs; [
      # Languages
      (python3.withPackages (
        ps: with ps; [
          tkinter
          jupyter
          notebook
          jupyterlab
        ]
      ))
      nodejs

      # .NET SDK
      dotnet-sdk
      dotnet-aspnetcore

      # Java (required for Android development)
      jdk
      flutter

      # Android SDK and tools
      android-tools
      android-studio

      # Tools
      postman
      lazydocker

      # General development utilities (not in packages.nix yet)
      unzip
      which
      file

      # For emulation
      qemu

      # Office
      brave
    ]);

  # Enable direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
