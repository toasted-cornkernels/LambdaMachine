{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ammonite
    # sbt
    scala
  ];
}

