{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "tim";  # Change this to your actual name
    userEmail = "timothynn08@gmail.com";  # Change this to your actual email
    
    extraConfig = {
      init.defaultBranch = "main";
      push.default = "simple";
      pull.rebase = false;
      core.editor = "nvim";
      
      # Better diffs
      diff.tool = "vimdiff";
      merge.tool = "vimdiff";
      
      # Colors
      color.ui = true;
      color.branch = "auto";
      color.diff = "auto";
      color.status = "auto";
      
      # Performance
      core.preloadindex = true;
      core.fscache = true;
      gc.auto = 256;
    };
    
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      ca = "commit -a";
      cam = "commit -am";
      cl = "clone";
      df = "diff";
      lg = "log --oneline --graph --decorate";
      lga = "log --oneline --graph --decorate --all";
      ls = "log --pretty=format:'%C(yellow)%h %C(blue)%ad %C(red)%d %C(reset)%s %C(green)[%cn]' --decorate --date=short";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
    };
  };
}
