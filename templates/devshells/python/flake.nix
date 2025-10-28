{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Python with packages
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          # Core packages
          pip
          setuptools
          wheel
          
          # Development tools
          black
          flake8
          mypy
          pytest
          pytest-cov
          ipython
          
          # Common libraries
          requests
          numpy
          pandas
          # Add your packages here
        ]);
        
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            pythonEnv
            
            # Additional tools
            poetry
            ruff  # Fast Python linter
            
            # System dependencies (if needed)
            # postgresql
            # redis
          ];
          
          shellHook = ''
            echo "🐍 Python Development Environment"
            echo "Python version: $(python --version)"
            echo ""
            echo "Available commands:"
            echo "  python, pip, pytest, black, flake8, mypy"
            echo ""
            
            # Set up virtual environment if it doesn't exist
            if [ ! -d .venv ]; then
              echo "Creating virtual environment..."
              python -m venv .venv
            fi
            
            # Activate virtual environment
            source .venv/bin/activate
            
            # Set environment variables
            export PYTHONPATH="$PWD:$PYTHONPATH"
          '';
        };
      }
    );
}
