# ~/.config/nixos/modules/zsh/rc.d/20-functions.zsh

# Drop into an ephemeral shell with one or more packages
# Usage: `try python3 nodejs ffmpeg`
# Note: Nix aggressively caches downloaded packages in `/nix/store/`.
#       The first time `try python3` is run, python will be downloaded and cached,
#       next time it is run it will load instantly. run clean-store (nh clean all)
#       to prompt nix gc and reclaim disk space.
function try() {
  if [ $# -eq 0 ]; then
    echo "Usage: try <pkg1> [pkg2...]"
    return 1
  fi

  local pkgs=()
  for pkg in "$@"; do
    pkgs+=("nixpkgs#${pkg}")
  done

  echo "Spawning ephemeral environment with: $@"
  nix shell "${pkgs[@]}"
}

# Run a single command from a package inline
# Usage: execute cowsay "Hello World"
function execute() {
  if [ $# -eq 0 ]; then
    echo "Usage: execute <pkg> [args...]"
    return 1
  fi

  local pkg="$1"
  shift # Remove package name so only args remain

  nix run "nixpkgs#${pkg}" -- "$@"
}

function nix_inspect() {
  if [ "$#" -ne 1 ] || [ -z "$1" ]; then
    echo "Usage: nix_inspect <package-name>"
    return 1
  fi

  nix run "nixpkgs#$1" -- --version
}
