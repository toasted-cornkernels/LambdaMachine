{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autoconf
    automake
    cmake
    gnumake
    gradle
    maven
    ninja
    pkg-config
    tldr
  ];
}

