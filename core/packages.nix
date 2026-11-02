_: {
  flake.modules.nixos.wsl = {
    pkgs,
    inputs,
    vars,
    ...
  }: {
    home-manager.users.${vars.username}.home.packages = with pkgs; [
      # Core CLI Utils
      curl
      ripgrep
      fd
      jq
      superfile

      # AI & Agents
      inputs.llm-agents.packages.${vars.system}.cursor-agent
    ];
  };
}
