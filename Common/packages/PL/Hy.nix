# This module has nothing to do with SK Hynix.

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python312Packages.hy
  ];
}
