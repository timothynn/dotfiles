{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    
    # Basic options
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      incsearch = true;
      hlsearch = true;
      scrolloff = 8;
      sidescrolloff = 8;
      mouse = "a";
    };

    # Global settings
    globals = {
      mapleader = " ";
    };

    # Key mappings
    keymaps = [
      {
        action = "<cmd>Ex<CR>";
        key = "<leader>pv";
        mode = "n";
      }
      {
        action = "<C-d>zz";
        key = "<C-d>";
        mode = "n";
      }
      {
        action = "<C-u>zz";
        key = "<C-u>";
        mode = "n";
      }
    ];

    # Plugins
    plugins = {
      # File explorer
      oil.enable = true;
      
      # Web devicons (explicitly enabled to avoid deprecation warning)
      web-devicons.enable = true;
      
      # Fuzzy finder
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      # Syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # LSP
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;  # Nix LSP
          lua_ls.enable = true;
          pyright.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };

      # Completion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };

      # Status line
      lualine.enable = true;

      # Git integration
      gitsigns.enable = true;

      # Auto pairs
      nvim-autopairs.enable = true;

      # Comments
      comment.enable = true;
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };
  };
}