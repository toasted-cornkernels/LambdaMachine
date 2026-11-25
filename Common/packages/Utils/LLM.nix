{ pkgs, ... }: {
  home.packages = with pkgs; [
    codex
    codex-acp
  ];
}
