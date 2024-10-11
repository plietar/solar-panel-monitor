{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    esp-dev.url = "github:mirrexagon/nixpkgs-esp-dev";
    esp-toolchain.url = "github:plietar/nixpkgs-esp-toolchain";
    kicad-parts.url = "github:plietar/kicad-parts";

    esp-dev.inputs.nixpkgs.follows = "nixpkgs";
    esp-toolchain.inputs.nixpkgs.follows = "nixpkgs";
    kicad-parts.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    perSystem = { pkgs, inputs', ... }: {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          (inputs'.esp-dev.packages.esp-idf-full.override {
            toolsToInclude = [ ];
          })
          inputs'.esp-toolchain.packages.riscv32-esp-gcc-20240530
        ];
      };
      devShells.ci = pkgs.mkShell {
        buildInputs = [
          inputs'.esp-dev.packages.esp-idf-esp32c3
        ];
      };
      devShells.hardware = pkgs.mkShell {
        buildInputs = [
          inputs'.kicad-parts.packages.interactive-html-bom
          pkgs.kicad-small
        ];
      };
    };

    systems = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
