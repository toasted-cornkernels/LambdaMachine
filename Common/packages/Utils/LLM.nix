{ pkgs, ... }: {
  home.packages = with pkgs; [
    github-copilot-cli
    codex
    codex-acp
  ];
}
