{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aspell
    hunspell
  ];
}

