{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python312
    pyright
    poetry
  ];
}

