{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autoconf
    automake
    bazelisk
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

