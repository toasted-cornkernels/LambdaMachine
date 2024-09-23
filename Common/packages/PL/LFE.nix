{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lfe
  ];
}

