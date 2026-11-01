# Drop into an ephemeral shell with one or more packages.
# Usage: try python3 nodejs ffmpeg
function try() {
  if (( $# == 0 )); then
    print -u2 "Usage: try <pkg1> [pkg2...]"
    return 1
  fi

  local -a packages
  local package
  for package in "$@"; do
    packages+=("nixpkgs#${package}")
  done

  print "Spawning ephemeral environment with: $*"
  nix shell "${packages[@]}"
}

# Run a single command from a package inline.
# Usage: execute cowsay "Hello World"
function execute() {
  if (( $# == 0 )); then
    print -u2 "Usage: execute <pkg> [args...]"
    return 1
  fi

  local package="$1"
  shift

  nix run "nixpkgs#${package}" -- "$@"
}

# Print the version exposed by a package's default executable.
# Usage: nix_inspect ripgrep
function nix_inspect() {
  if (( $# != 1 )) || [[ -z "$1" ]]; then
    print -u2 "Usage: nix_inspect <package-name>"
    return 1
  fi

  nix run "nixpkgs#$1" -- --version
}
