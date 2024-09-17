{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    esp-dev = {
      url = "github:mirrexagon/nixpkgs-esp-dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    esp-toolchain = {
      url = "github:plietar/nixpkgs-esp-toolchain";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, esp-dev, esp-toolchain, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; }; in {
        packages.interactive-html-bom = pkgs.callPackage ./interactive-html-bom.nix { };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            (esp-dev.packages."${system}".esp-idf-full.override {
              python3 = pkgs.python310;
              toolsToInclude = [ ];
            })
            esp-toolchain.packages."${system}".riscv32-esp-gcc-20230208
          ];
        };

        devShells.hardware = pkgs.mkShell {
          buildInputs = [
            self.packages."${system}".interactive-html-bom
            (pkgs.kicad.override { with3d = false; })
          ];
        };

        devShells.ci = pkgs.mkShell {
          buildInputs = [
            esp-dev.packages."${system}".esp-idf-esp32c3
          ];
        };
      });
}
