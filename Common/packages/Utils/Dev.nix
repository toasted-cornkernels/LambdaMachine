{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autoconf
    automake
    cscope
    ctags
    gnumake
    gradle
    maven
    ninja
    pkg-config
    tldr
  ];
}

