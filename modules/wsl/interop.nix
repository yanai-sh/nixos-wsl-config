# Curated Windows commands. Paths were recorded on this host while
# wsl.interop.includePath was still injecting the full Windows PATH.
_: {
  flake.modules.nixos.wsl = {
    pkgs,
    vars,
    lib,
    ...
  }: let
    windowsCommands = {
      pwsh = "/mnt/c/Users/Yanai/AppData/Local/Microsoft/WindowsApps/pwsh.exe";
      cmd = "/mnt/c/Windows/system32/cmd.exe";
      explorer = "/mnt/c/Windows/explorer.exe";
    };

    wrappers =
      lib.mapAttrs (
        name: path:
          pkgs.writeShellScriptBin name ''
            exec ${lib.escapeShellArg path} "$@"
          ''
      )
      windowsCommands;
  in {
    wsl.interop = {
      register = true;
      includePath = false;
    };

    # WSL itself also appends the Windows PATH through /etc/wsl.conf.
    # includePath only controls NixOS-WSL's own path filter.
    wsl.wslConf.interop = {
      enabled = true;
      appendWindowsPath = false;
    };

    home-manager.users.${vars.username}.home.packages =
      lib.attrValues wrappers
      ++ [
        (pkgs.writeShellApplication {
          name = "validate-wsl-interop";
          runtimeInputs = [pkgs.openssh];
          text = ''
            if [[ -z ''${SSH_AUTH_SOCK:-} || ! -S ''${SSH_AUTH_SOCK} ]]; then
              printf '%s\n' "SSH_AUTH_SOCK is not a live agent socket" >&2
              exit 1
            fi

            if ! ssh-add -l >/dev/null; then
              printf '%s\n' "ssh-add cannot list keys from the Windows agent" >&2
              exit 1
            fi

            for command_name in pwsh cmd explorer; do
              if ! command -v "$command_name" >/dev/null; then
                printf '%s\n' "missing Windows command: $command_name" >&2
                exit 1
              fi
            done
          '';
        })
      ];
  };
}
