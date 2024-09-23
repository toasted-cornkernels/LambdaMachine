{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnutar
    zip
  ];
}

