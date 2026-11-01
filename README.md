# NixOS-WSL configuration

Declarative, dendritic configuration for a single-user NixOS-WSL developer
workstation. The native platform is `aarch64-linux`; Linux software runs
natively rather than through x86_64 binfmt emulation. Windows interoperability
remains enabled, so Windows ARM64 executables run natively and Windows x64
executables can use Prism. Home Manager owns the user environment, Catppuccin
provides theming, and imported modules under `core/` and `modules/` compose the
host.

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

An older deployed configuration created mutable symlinks in `/usr/bin`. This
repository intentionally does not remove mutable host state during activation.
When migrating such a host, run the following carefully scoped command once as
root. It only removes symlinks directly under `/usr/bin` whose raw target
belongs to a NixOS system profile's `sw/bin`; it explicitly preserves
`/usr/bin/env`, paths with spaces, and every nonmatching entry. The command uses
absolute system-profile tools so deleting a legacy `/usr/bin` command cannot
interrupt the cleanup.

```bash
sudo /run/current-system/sw/bin/bash <<'EOF'
while IFS= read -r -d '' link; do
  target=$(/run/current-system/sw/bin/readlink -- "$link") || continue
    case "$target" in
      /nix/store/*-nixos-system-*/sw/bin/*)
      [ "$link" = /usr/bin/env ] ||
        /run/current-system/sw/bin/rm -- "$link"
        ;;
    esac
done < <(
  /run/current-system/sw/bin/find \
    -P /usr/bin -mindepth 1 -maxdepth 1 -type l -print0
)
EOF
```
