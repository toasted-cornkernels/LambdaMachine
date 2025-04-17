{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python312
    pyright
    poetry
    python312Packages.pip
  ];
}

