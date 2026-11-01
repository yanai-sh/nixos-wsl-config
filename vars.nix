# ~/.config/nixos/core/vars.nix
{
  # --- System Settings ---
  username = "yanai";
  hostname = "nixos-wsl";
  system = "aarch64-linux";
  flakePath = "/home/yanai/.config/nixos";
  systemStateVersion = "26.05";
  homeStateVersion = "26.05";
  timeZone = "Asia/Jerusalem";

  # --- User Identity ---
  fullName = "Yanai Klugman";
  userEmail = "me@yanai.sh";

  # --- User Configs ---
  editor = "hx";
  sshPubKey = "~/.ssh/id_ed25519.pub";
}
