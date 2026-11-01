# ~/.config/nixos/modules/cli/git.nix
_: {
  flake.modules.nixos.wsl = {
    pkgs,
    vars,
    ...
  }: {
    home-manager.users.${vars.username}.programs = {
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
          credential.helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
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
}
