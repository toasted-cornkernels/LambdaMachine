{ pkgs, ... }:
{
  home.packages = with pkgs; [
    isync
    mu
    neomutt
  ];
}

