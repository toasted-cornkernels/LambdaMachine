{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nixfmt-classic
  ];
}

