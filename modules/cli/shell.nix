_: {
  flake.modules.nixos.wsl = {vars, ...}: {
    home-manager.users.${vars.username}.programs = {
      bash.enable = true;

      zoxide = {
        enable = true;
      };

      fzf.enable = true;
      bat.enable = true;

      eza = {
        enable = true;
        enableZshIntegration = true;
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
