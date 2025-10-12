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
  };

  outputs = { self, nixpkgs, home-manager, hyprland, stylix, nixvim, ... }@inputs:
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
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs outputs; };
            home-manager.sharedModules = [
              nixvim.homeModules.nixvim
              stylix.homeModules.stylix
            ];
          }
        ];
      };
      
      # Helper function for generating home configs
      mkHome = modules: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs outputs; };
        modules = modules;
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
          stylix.homeModules.stylix
          nixvim.homeModules.nixvim
        ];
      };

      # Development shells
      devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          git
        ];
      };
    };
}
