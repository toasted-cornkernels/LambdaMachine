{ pkgs, ... }:
{
  home.packages = with pkgs; [
    janet
  ];
}
