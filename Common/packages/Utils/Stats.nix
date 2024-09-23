{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cloc
    duf
    dust
    gotop
    onefetch
    smartmontools
    tokei
  ];
}

