{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ack
    bat
    eza
    fd
    ripgrep
    silver-searcher
    skim
    tree
    file-rename
  ];
}

