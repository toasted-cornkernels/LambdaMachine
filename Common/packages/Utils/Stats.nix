{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cloc
    duf
    dust
    gdu
    gotop
    onefetch
    smartmontools
    tokei
  ];
}

