# Bridge the Windows OpenSSH agent the same way FedoraLinux-44 does:
# wsl2-ssh-agent 0.9.7 listens on the user runtime socket and relays through
# Windows PowerShell. The private key stays in the Windows agent.
_: {
  flake.modules.nixos.wsl = {
    pkgs,
    vars,
    lib,
    ...
  }: {
    home-manager.users.${vars.username} = {
      systemd.user.services.wsl2-ssh-agent = {
        Unit = {
          Description = "Bridge the Windows OpenSSH agent into WSL";
          Documentation = "https://github.com/mame/wsl2-ssh-agent";
          ConditionPathExists = "/proc/sys/fs/binfmt_misc/WSLInterop";
        };
        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.wsl2-ssh-agent} --foreground --socket=%t/wsl2-ssh-agent.sock --powershell-path=/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe";
          Restart = "on-failure";
          RestartSec = "2s";
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}
