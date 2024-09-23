{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    fizz
    wget
  ];
}

