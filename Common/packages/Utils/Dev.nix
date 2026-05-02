{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autoconf
    automake
    bazelisk
    cmake
    gnumake
    gradle
    maven
    ninja
    pkg-config
    tldr
  ];
}

