{ config, pkgs, ... }:

{
  # Restic backup service
  # Configure this according to your backup destination
  # Uncomment and configure when ready to use
  
  # services.restic.backups = {
  #   homeBackup = {
  #     initialize = true;
  #     paths = [
  #       "/home/tim/Documents"
  #       "/home/tim/Pictures"
  #       "/home/tim/dev"
  #       "/home/tim/.dotfiles"
  #     ];
  #     
  #     exclude = [
  #       "/home/tim/.cache"
  #       "/home/tim/.local/share/Trash"
  #       "**node_modules"
  #       "**/.git"
  #       "**/target"
  #       "**/__pycache__"
  #     ];
  #     
  #     repository = "/mnt/backup/restic";  # Change to your backup location
  #     # Or use remote: "sftp:user@host:/backup"
  #     # Or use cloud: "s3:s3.amazonaws.com/bucket-name"
  #     
  #     passwordFile = "/home/tim/.config/restic/password";
  #     
  #     timerConfig = {
  #       OnCalendar = "daily";
  #       Persistent = true;
  #     };
  #     
  #     pruneOpts = [
  #       "--keep-daily 7"
  #       "--keep-weekly 4"
  #       "--keep-monthly 6"
  #     ];
  #   };
  # };

  # Syncthing for file synchronization
  services.syncthing = {
    enable = true;
    # The web UI will be available at http://127.0.0.1:8384
  };

  # Backup utilities
  home.packages = with pkgs; [
    restic       # Backup program
    rclone       # Cloud sync
    rsync        # File sync
    duplicati    # GUI backup tool
  ];

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
