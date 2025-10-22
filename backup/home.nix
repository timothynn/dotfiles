{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tim";
  home.homeDirectory = "/home/tim";
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
  	hello
	nerd-fonts.jetbrains-mono
	tradingview
	vscode
	zsh
	gh
	devenv
	direnv
	emacs
	spotify
	ripgrep
	fd
	tldr
	zoxide
	pyprland
	wl-clipboard
	fastfetch
	clang
	xh
	choose
	bottom
	cava
	mailspring
	rofi
	aerc
	thunderbird
	qbittorrent
	python3
	mpv
	google-chrome
	vlc
	hyprsunset
	pyprland
	hyprlock
	hypridle
	hyprpaper
	pavucontrol
	pwvucontrol
	wlogout
	cliphist
	hyprpicker
	grimblast
	zellij
	starship
	zoxide
	fzf
	bat
	eza
	atuin
	zfs
	helix
	notion-app-enhanced
	xfce.thunar
	xfce.thunar-volman
	yazi
	imv
	zathura
	libreoffice-fresh
	vesktop
	telegram-desktop
	zoom-us
	slack
	teams-for-linux
	lazygit
	postman
	lazydocker
	btop
	bitwarden-desktop
	protonvpn-gui
	nix-tree
	nix-du
	nh
	github-copilot-cli
	claude-code	
	ollama
	gollama
	jan
	warp-terminal
	gemini-cli
	peazip
	p7zip
	unzip
	zstd
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    image = pkgs.fetchurl {
      url =
        "https://www.pixelstalk.net/wp-content/uploads/2025/05/A-dense-forest-with-towering-evergreens-and-a-glowing-mist-rising-from-the-ground.webp";
      hash = "sha256-e8RDn46vsP4b/kLAmYXKgBL12soOXJxAqpRvSruqbXA=";
    };
    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 18;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetbrainsMono Nerd Font";

      };
      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 11;
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
    targets = {
    	gtk.enable = true;
	qt = {
		enable = true;
		platform = "qtct";
	};
	xfce.enable = true;
	kde.enable = true;
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tim/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" "pkcs11" ];
  };
  services.udiskie.enable = true;

  programs.kitty = {
	enable = true;
	settings = {
		confirm_os_window_close = 0;
		enable_audio_bell = "no";
		hide_window_decorations = "yes";
		window_padding_width = 4;
		window_margin_width = 4;
	};
  };

  programs.zsh = {
	enable = true;
	shellAliases = {
		ls = "eza";
		hms = "home-manager switch";
		nrs = "sudo nixos-rebuild switch";
	};
	enableCompletion = true;
	syntaxHighlighting.enable = true;
	autosuggestion.enable = true;
	oh-my-zsh = {
		enable = true;
		plugins = [ "sudo" "git" "docker" "docker-compose" "aliases" "gh" ];
	};
  };
  programs.starship.enable = true;
  programs.cava.enable = true;
  programs.fzf.enable = true;
  programs.skim.enable = true;
  programs.eza = {
	enable = true;
	icons = "auto";
	git = true;
	colors = "never";
	enableZshIntegration = true;
  };

}

