{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autoconf
    automake
    cmake
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

