_: {
  flake.modules.nixos.wsl = {
    pkgs,
    inputs,
    vars,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      # Core CLI Utils
      git
      curl
      ripgrep
      fd
      jq
      gh
      superfile

      # AI & Agents
      inputs.llm-agents.packages.${vars.system}.cursor-agent

      # LSP Tools
      nil
      nixd
      alejandra
    ];
  };
}
