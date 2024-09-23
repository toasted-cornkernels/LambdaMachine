{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mysql
    postgresql
    redis
  ];
}

