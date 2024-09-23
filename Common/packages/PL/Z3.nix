{ pkgs, ... }:
{
  home.packages = with pkgs; [
    z3
  ];
}
