_: {
  flake.modules.nixos.wsl = {vars, ...}: {
    home-manager.users.${vars.username} = {
      catppuccin.starship.enable = false;

      programs.starship = {
        enable = true;
        settings = fromTOML (builtins.readFile ./starship.toml);
      };
    };
  };
}
