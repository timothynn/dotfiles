{ config, pkgs, ... }:

{
  # Development tools
  environment.systemPackages = with pkgs; [
    # Build tools
    clang
    gcc
  ];

  # Enable development services
  programs.git.enable = true;

  # Android development setup
  programs.adb.enable = true; # Enable Android Debug Bridge

  # Note: Android SDK is installed via android-studio in home-manager
  # which includes SDK, emulator, platform tools, and build tools
}
