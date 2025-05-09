{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fswatch
    coreutils
    moreutils
    nyancat
    rlwrap
    watchman
    ps
  ];
}
