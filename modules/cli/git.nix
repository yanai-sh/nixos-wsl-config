# ~/.config/nixos/modules/cli/git.nix
_: {
  flake.modules.nixos.wsl = {
    pkgs,
    vars,
    ...
  }: {
    home-manager.users.${vars.username} = {
      home.packages = [pkgs.gh];

      programs = {
        git = {
          enable = true;
          settings = {
            user = {
              name = vars.fullName;
              email = vars.userEmail;
              signingkey = vars.sshPubKey;
            };
            commit.gpgsign = true;
            gpg.format = "ssh";
            init.defaultBranch = "main";
            pull.rebase = true;
            push.autoSetupRemote = true;
            core.editor = vars.editor;
            credential.helper = "!${pkgs.gh}/bin/gh auth git-credential";
          };
        };

        delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            navigate = true;
            line-numbers = true;
            side-by-side = true;
          };
        };
      };
    };
  };
}
