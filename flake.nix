# ~/.config/nixos/flake.nix
{
  description = "Dendritic NixOS-WSL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:mightyiam/import-tree";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    import-tree,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-linux" "x86_64-linux"];

      imports = [
        inputs.flake-parts.flakeModules.modules
        (import-tree ./core)
      ];
    };
}
