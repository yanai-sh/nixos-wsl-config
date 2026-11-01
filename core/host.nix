# ~/.config/nixos/core/host.nix
{
  self,
  inputs,
  ...
}: let
  vars = import ../vars.nix;
in {
  flake.nixosConfigurations.${vars.hostname} = inputs.nixpkgs.lib.nixosSystem {
    inherit (vars) system;
    specialArgs = {inherit vars inputs;};

    modules = [
      inputs.nixos-wsl.nixosModules.default
      inputs.home-manager.nixosModules.default
      self.modules.nixos.wsl
    ];
  };

  flake.modules.nixos.wsl = {
    pkgs,
    vars,
    ...
  }: {
    # --- Platform & Architecture ---
    nixpkgs.hostPlatform = vars.system;
    nixpkgs.config.allowUnfree = true;

    # --- System & Networking ---
    networking.hostName = vars.hostname;
    # NixOS-WSL masks firewall.service; Windows and Hyper-V provide the
    # effective network boundary for this single-user workstation.
    networking.firewall.enable = false;
    system.stateVersion = vars.systemStateVersion;
    time.timeZone = vars.timeZone;

    # --- Nix Daemon Settings ---
    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    nix.settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command"];
      trusted-users = ["root" vars.username];
    };

    # --- Security & Users ---
    security.sudo.wheelNeedsPassword = false;
    users.users.${vars.username} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };

    # --- WSL Integration ---
    wsl = {
      enable = true;
      defaultUser = vars.username;
      interop = {
        register = true;
        includePath = true;
      };
    };

    # --- Dynamic Linker (FHS Emulation for Cursor & Language Servers) ---
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        curl
        expat
        glibc
        icu
        krb5
        libsecret
        libuv
        nspr
        nss
        openssl
        stdenv.cc.cc.lib
        util-linux
        zlib
      ];
    };

    # --- Home Manager ---
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      sharedModules = [inputs.catppuccin.homeModules.catppuccin];

      users.${vars.username} = {
        home.stateVersion = vars.homeStateVersion;
        catppuccin = {
          enable = true;
          autoEnable = true;
          flavor = "mocha";
        };
      };
    };
  };
}
