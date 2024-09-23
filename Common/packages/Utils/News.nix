{ pkgs, ... }:
{
  home.packages = with pkgs; [
    newsboat
  ];
}
