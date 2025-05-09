{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnutar
    gzip
  ];
}

