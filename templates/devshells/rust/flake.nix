{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        
        # Use stable rust or specify version
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };
        
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Rust toolchain
            rustToolchain
            
            # Build tools
            cargo-watch
            cargo-edit
            cargo-outdated
            cargo-audit
            
            # Additional tools
            bacon  # Background rust code checker
            
            # System dependencies (common)
            pkg-config
            openssl
            
            # Optional: for cross-compilation
            # cargo-cross
          ];
          
          # Environment variables
          RUST_BACKTRACE = "1";
          
          shellHook = ''
            echo "🦀 Rust Development Environment"
            echo "Rust version: $(rustc --version)"
            echo "Cargo version: $(cargo --version)"
            echo ""
            echo "Available commands:"
            echo "  cargo, rustc, rust-analyzer"
            echo "  cargo-watch, cargo-edit, cargo-audit"
            echo ""
          '';
        };
      }
    );
}
