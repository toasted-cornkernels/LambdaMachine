{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nixfmt
    nix-tree
  ];
}

