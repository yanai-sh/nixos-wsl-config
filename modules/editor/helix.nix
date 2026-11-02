# ~/.config/nixos/modules/editor/helix.nix
_: {
  flake.modules.nixos.wsl = {
    pkgs,
    vars,
    ...
  }: {
    home-manager.users.${vars.username} = {
      home.packages = [
        pkgs.nixd
        pkgs.alejandra
      ];

      programs.helix = {
        enable = true;
        defaultEditor = true;

        settings.editor = {
          line-number = "relative";
          bufferline = "always";
          popup-border = "all";
          end-of-line-diagnostics = "hint";
          auto-format = true;
          color-modes = true;
          true-color = true;
          cursorline = true;
          inline-diagnostics.cursor-line = "warning";
          indent-guides.render = true;
          scrolloff = 5;
        };

        settings.keys = {
          insert.esc = ["collapse_selection" "normal_mode"];
          normal.esc = ["move_line_down" "goto_first_nonwhitespace"];
          select.esc = ["collapse_selection" "keep_primary_selection" "normal_mode"];
        };

        settings.keys.normal = {
          C-h = "select_prev_sibling";
          C-j = "shrink_selection";
          C-k = "expand_selection";
          C-l = "select_next_sibling";
          H = "goto_first_nonwhitespace";
          L = "goto_line_end";
        };

        settings.keys.insert = {
          j.k = "normal_mode";
          k.j = "normal_mode";
        };

        languages.language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.alejandra}/bin/alejandra";
            language-servers = ["nixd"];
          }
        ];
      };
    };
  };
}
