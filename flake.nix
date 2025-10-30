{
  description = "NixOS and Home Manager configuration for tim";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    
    # Stylix for theming
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # NUR - Nix User Repository (for Firefox extensions)
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, stylix, nixvim, nur, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      
      # Helper function for generating system configs
      mkSystem = modules: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs; };
        modules = modules ++ [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;  # Temporarily disable to fix nixpkgs config conflict
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs outputs; };
            home-manager.sharedModules = [
              nixvim.homeModules.nixvim
              stylix.homeModules.stylix
              # Add NUR overlay for Firefox extensions
              { nixpkgs.overlays = [ nur.overlays.default ]; }
            ];
          }
        ];
      };
      
      # Helper function for generating home configs
      mkHome = modules: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nur.overlays.default ];  # Add NUR overlay
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs outputs; };
        modules = modules ++ [
          nixvim.homeModules.nixvim
          stylix.homeModules.stylix
        ];
      };
    in
    {
      # NixOS configurations
      nixosConfigurations = {
        # Main desktop configuration
        nixos = mkSystem [
          ./hosts/nixos
          stylix.nixosModules.stylix
          hyprland.nixosModules.default
        ];
      };

      # Standalone home manager configuration
      homeConfigurations = {
        "tim@nixos" = mkHome [
          ./home/tim
        ];
      };

      # Development shells
      devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          git
          nixfmt
        ];
      };
    };
}
