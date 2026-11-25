{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autoconf
    automake
    bazelisk
    cmake
    libtool
    gnumake
    gradle
    maven
    ninja
    pkg-config
    tldr
    (azure-cli.withExtensions [
      azure-cli-extensions.azure-devops
    ])
  ];
}

