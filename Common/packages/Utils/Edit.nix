{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vim
    neovim
    nano
  ]
}
