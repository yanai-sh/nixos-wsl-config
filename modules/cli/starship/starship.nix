_: {
  flake.modules.nixos.wsl = {vars, ...}: {
    home-manager.users.${vars.username} = {
      catppuccin.starship.enable = false;

      programs.starship.enable = true;
      xdg.configFile."starship.toml".source = ./starship.toml;
    };
  };
}
