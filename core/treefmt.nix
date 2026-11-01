{self, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    formatter = config.treefmt.build.wrapper;

    checks = {
      formatting = config.treefmt.build.check self;

      zsh-syntax =
        pkgs.runCommand "zsh-syntax-check" {
          nativeBuildInputs = [
            pkgs.findutils
            pkgs.zsh
          ];
          src = self;
        } ''
          while IFS= read -r -d "" file; do
            zsh -n "$file"
          done < <(
            find "$src/modules/zsh/config" \
              -type f \( -name ".zshrc" -o -name "*.zsh" \) -print0
          )
          touch "$out"
        '';

      starship-schema =
        pkgs.runCommand "starship-schema-check" {
          nativeBuildInputs = [pkgs.check-jsonschema];
          schema = pkgs.starship.passthru.jsonschema.config;
          src = self;
        } ''
          check-jsonschema \
            --force-filetype=toml \
            --schemafile "$schema" \
            "$src/modules/cli/starship/starship.toml"
          touch "$out"
        '';
    };

    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        alejandra.enable = true;
        deadnix.enable = true;
        statix.enable = true;
        shellcheck.enable = true;
        taplo.enable = true;
      };
    };
  };
}
