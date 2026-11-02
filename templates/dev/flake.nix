{
  description = "Project development shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    systems = ["aarch64-linux" "x86_64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        # Add project tools here. The host shell already provides direnv and nix-direnv.
        packages = [];
      };
    });
  };
}
