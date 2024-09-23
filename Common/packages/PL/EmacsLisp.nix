{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cask
  ];
}
