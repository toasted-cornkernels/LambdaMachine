{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nim
    nimble
    nimlangserver
  ];
}

