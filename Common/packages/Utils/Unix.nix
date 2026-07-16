{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fswatch
    coreutils
    coreutils-prefixed
    moreutils
    nyancat
    rlwrap
    watchman
    ps
  ];
}
