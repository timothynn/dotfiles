{
  description = "Node.js development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Node.js and package managers
            nodejs_24
            nodePackages.npm
            nodePackages.pnpm
            nodePackages.yarn
            
            # Development tools
            nodePackages.typescript
            nodePackages.typescript-language-server
            nodePackages.eslint
            nodePackages.prettier
            
            # Build tools
            nodePackages.vite
            nodePackages.webpack-cli
            
            # Testing
            nodePackages.jest
            
            # Utilities
            nodePackages.npm-check-updates
          ];
          
          shellHook = ''
            echo "📦 Node.js Development Environment"
            echo "Node version: $(node --version)"
            echo "npm version: $(npm --version)"
            echo ""
            echo "Available commands:"
            echo "  node, npm, pnpm, yarn"
            echo "  tsc, eslint, prettier"
            echo ""
            
            # Set npm prefix to local directory
            export NPM_CONFIG_PREFIX="$PWD/.npm-global"
            export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
          '';
        };
      }
    );
}
