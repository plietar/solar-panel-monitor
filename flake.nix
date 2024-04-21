{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    esp-dev = {
      url = "/Users/paul/Projects/CalanMai/nixpkgs-esp-dev/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    esp-compilers = {
      url = "/Users/paul/Projects/nix-esp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, esp-dev, esp-compilers, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              python310 = super.python310.override {
                packageOverrides = pself: psuper: {
                  objgraph = psuper.objgraph.overrideAttrs (old: { doInstallCheck = false; });
                  urllib3 = psuper.urllib3.overrideAttrs (old: rec {
                    version = "1.26.16";
                    format = "setuptools";
                    buildInputs = [ pself.setuptools ];
                    src = pself.fetchPypi {
                      inherit (old) pname;
                      inherit version;
                      hash = "sha256-jxNfZQJ1a95rKpsomJ31++h8mXDOyqaQQe3M5/BYmxQ=";
                    };
                  });
                };
              };
            })
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            (esp-dev.packages."${system}".esp-idf-full.override {
              python3 = pkgs.python310;
              toolsToInclude = [ ];
            })
            esp-compilers.packages."${system}".riscv32-esp-gcc
          ];
        };
      });
}
