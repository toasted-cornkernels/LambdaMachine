{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dafny
  ];
}

