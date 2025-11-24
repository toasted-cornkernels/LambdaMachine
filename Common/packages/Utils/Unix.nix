{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fswatch
    coreutils-prefixed
    moreutils
    nyancat
    rlwrap
    watchman
    ps
  ];
}
