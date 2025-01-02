{ pkgs, ... }:
{
  home.packages = with pkgs; [
    opentyrian
    vitetris
    crispy-doom
  ];
}

