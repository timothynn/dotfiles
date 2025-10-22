{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    settings = {
      user.name = "tim";  # Change this to your actual name
      user.email = "timothynn08@gmail.com";  # Change this to your actual email
      
      init.defaultBranch = "main";
      push.default = "simple";
      pull.rebase = false;
      core.editor = "nvim";
      
      # Automatic remote setup
      push.autoSetupRemote = true;
      branch.autosetupmerge = "always";
      branch.autosetuprebase = "always";
      remote.pushDefault = "origin";
      
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
      
      # Aliases
      alias.st = "status";
      alias.co = "checkout";
      alias.br = "branch";
      alias.ci = "commit";
      alias.ca = "commit -a";
      alias.cam = "commit -am";
      alias.cl = "clone";
      alias.df = "diff";
      alias.lg = "log --oneline --graph --decorate";
      alias.lga = "log --oneline --graph --decorate --all";
      alias.ls = "log --pretty=format:'%C(yellow)%h %C(blue)%ad %C(red)%d %C(reset)%s %C(green)[%cn]' --decorate --date=short";
      alias.unstage = "reset HEAD --";
      alias.last = "log -1 HEAD";
      alias.visual = "!gitk";
    };
  };
}
