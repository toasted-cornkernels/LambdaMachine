{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mariadb
    postgresql
    redis
  ];
}

