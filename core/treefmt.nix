{self, ...}: {
  perSystem = {config, ...}: {
    formatter = config.treefmt.build.wrapper;

    checks.formatting = config.treefmt.build.check self;

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
