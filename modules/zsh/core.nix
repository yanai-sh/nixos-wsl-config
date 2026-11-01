_: {
  flake.modules.nixos.wsl = {
    pkgs,
    vars,
    ...
  }: {
    programs.zsh.enable = true;
    users.users.${vars.username}.shell = pkgs.zsh;

    environment.sessionVariables.COLORTERM = "truecolor";

    programs.nh = {
      enable = true;
      clean.enable = true;
      flake = vars.flakePath;
    };

    home-manager.users.${vars.username} = {
      config,
      lib,
      ...
    }: {
      xdg.configFile."zsh".source = ./config;

      home.packages = [pkgs.zsh-completions];

      home.sessionVariables = {
        EDITOR = vars.editor;
        VISUAL = vars.editor;
        PAGER = "bat";
      };

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        dotDir = config.home.homeDirectory;

        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        autocd = true;

        # Third-Party (Using Nixpkgs built-in packages)
        plugins = [
          {
            name = "zsh-autopair";
            file = "autopair.zsh";
            src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
          }
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
          }
        ];

        # Load the conventional native configuration after managed integrations.
        initContent = lib.mkOrder 1500 ''
          source "${config.xdg.configHome}/zsh/.zshrc"
        '';
      };
    };
  };
}
