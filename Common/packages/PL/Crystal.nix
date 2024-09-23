{ pkgs, ... }:
{
  home.packages = with pkgs; [
   crystal
   crystalline
  ];
}

