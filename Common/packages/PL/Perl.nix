{ pkgs, ... }:
{
  home.packages = with pkgs; [
    perl
    rakudo
    perlnavigator
  ];
}

