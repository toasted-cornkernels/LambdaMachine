{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fswatch
    moreutils
    nyancat
    rlwrap
    watchman
    neovim
  ];
}
