{ pkgs, ... }:
{
  home.packages = with pkgs; [
    opentyrian
    vitetris
    chocolate-doom
    crispy-doom
  ];
}

