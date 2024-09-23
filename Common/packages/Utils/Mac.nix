{ pkgs, ... }:
{
  home.packages = with pkgs; [
    blueutil
    m-cli
    pinentry_mac
    terminal-notifier
  ];
}
