{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stack # TEMP
    ghcup # TEMP
  ];
}
