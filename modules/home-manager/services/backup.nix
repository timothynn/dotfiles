{ config, pkgs, ... }:

let
  packages = import ../../common/packages.nix { inherit pkgs; };
in
{
  # Syncthing for file synchronization
  services.syncthing = {
    enable = true;
    # The web UI will be available at http://127.0.0.1:8384
  };

  # Backup utilities - using centralized package list
  home.packages =
    packages.backup
    ++ (with pkgs; [
      duplicati # GUI backup tool
    ]);

  # Backup script for manual backups
  home.file.".local/bin/backup-now" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Quick backup script
      set -euo pipefail

      BACKUP_DIR="''${BACKUP_DIR:-/mnt/backup}"
      SOURCE_DIRS=(
        "$HOME/Documents"
        "$HOME/Pictures"
        "$HOME/dev"
        "$HOME/.dotfiles"
      )

      echo "🔄 Starting backup to $BACKUP_DIR..."

      for dir in "''${SOURCE_DIRS[@]}"; do
        if [[ -d "$dir" ]]; then
          echo "📦 Backing up $dir..."
          rsync -av --delete \
            --exclude='.cache' \
            --exclude='node_modules' \
            --exclude='.git' \
            --exclude='target' \
            --exclude='__pycache__' \
            "$dir" "$BACKUP_DIR/"
        fi
      done

      echo "✅ Backup completed!"
    '';
  };

  # Restore script
  home.file.".local/bin/backup-restore" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Restore from backup
      set -euo pipefail

      BACKUP_DIR="''${BACKUP_DIR:-/mnt/backup}"

      echo "🔄 Restoring from $BACKUP_DIR..."
      echo "⚠️  This will overwrite existing files!"
      read -p "Continue? (y/N) " -n 1 -r
      echo

      if [[ $REPLY =~ ^[Yy]$ ]]; then
        rsync -av "$BACKUP_DIR/" "$HOME/"
        echo "✅ Restore completed!"
      else
        echo "❌ Restore cancelled"
      fi
    '';
  };
}
