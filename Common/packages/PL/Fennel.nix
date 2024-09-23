{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fennel
  ];
}

