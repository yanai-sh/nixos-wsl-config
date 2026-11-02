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
  # Public half of the key loaded in the Windows OpenSSH agent.
  # Git treats the key:: prefix as a literal public key, not a file path.
  sshPubKey = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUe9cd98c1pBnPkaXt79cX08x4yAchgwgdNWRH61i30 C:\\Users\\Yanai\\.ssh\\id_ed25519";
}
