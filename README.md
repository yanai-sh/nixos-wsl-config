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

## Native configuration files

Home Manager remains the deployment owner for dotfiles, while applications
with established configuration formats keep their source configuration in that
native format. Files are copied into the Nix store and linked into place, so
changes require `nh os switch` and participate in generations and rollback.

Zsh keeps its conventional entry point and fragments under
`modules/zsh/config/`. Home Manager generates `~/.zshrc` for managed
integrations, then that file sources `$XDG_CONFIG_HOME/zsh/.zshrc`, which loads
`rc.d/*.zsh` in lexical order. Starship reads the tracked `starship.toml`
directly through an XDG config link.

Use `fromTOML` or `fromJSON` only when settings need Nix-level composition,
host conditionals, or store-path interpolation. Out-of-store links and
secondary dotfile managers are intentionally avoided so that live
configuration cannot drift from the active Home Manager generation.

Repository checks validate Zsh syntax and Starship's TOML schema in addition
to formatting and Nix linting.

## Package scope

Personal command-line tools belong in the Home Manager `home.packages` list in
`core/packages.nix`. When Home Manager provides a `programs.<name>` module,
prefer enabling that module under `modules/` so installation and configuration
remain together. Reserve `environment.systemPackages` for recovery tools,
system administration, services, or commands required outside the user
environment.

For a package provided by nixpkgs, such as `htop`, add `htop` to
`home.packages` in `core/packages.nix`; no input or lock-file change is needed.

For a package not provided by nixpkgs, prefer a maintained flake that exports a
package for `aarch64-linux`. Add that flake under `inputs` in `flake.nix`, make
its nixpkgs input follow the root nixpkgs when supported, and add the exported
package to `home.packages`. The existing `llm-agents` input and its
`cursor-agent` package demonstrate this pattern. Regenerate and commit
`flake.lock` whenever an input is added or updated.

Avoid persistent `nix-env` and `nix profile` installations because they create
package state outside this repository.

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
