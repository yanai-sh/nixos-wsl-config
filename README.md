# NixOS-WSL configuration

Declarative, dendritic configuration for a single-user NixOS-WSL developer
workstation. The native platform is `aarch64-linux`; NixOS binfmt support keeps
`x86_64-linux` binaries available when needed. Home Manager owns the user
environment, Catppuccin provides theming, and imported modules under `core/` and
`modules/` compose the host.

The Nix registry and `NIX_PATH` both resolve `nixpkgs` to the deployed flake
lock. OpenSSH is disabled. NixOS-WSL masks the NixOS firewall service, so
Windows and Hyper-V are the network boundary.

## Operations

```console
# Update inputs, then review and validate the result
nix flake update
nix fmt -- --ci
nix flake check

# Apply this host configuration
sudo nixos-rebuild switch --flake .#nixos-wsl

# Roll back to the previous generation
sudo nixos-rebuild switch --rollback
```

`nh os switch` can also apply the configured flake from any directory.

## One-time migration

An older deployed configuration created 703 mutable symlinks in `/usr/bin`.
This repository intentionally does not remove mutable host state during
activation. After switching to this configuration, inspect and, if desired,
run the following carefully scoped command once as root. It only removes
symlinks directly under `/usr/bin` whose resolved target belongs to a NixOS
system profile's `sw/bin`; it explicitly preserves `/usr/bin/env`, paths with
spaces, and every nonmatching entry.

```bash
sudo bash <<'EOF'
find -P /usr/bin -mindepth 1 -maxdepth 1 -type l -print0 |
  while IFS= read -r -d '' link; do
    target=$(readlink -f -- "$link") || continue
    case "$target" in
      /nix/store/*-nixos-system-*/sw/bin/*)
        [ "$link" = /usr/bin/env ] || rm -- "$link"
        ;;
    esac
  done
EOF
```
