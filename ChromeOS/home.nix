{ config, pkgs, ... }:

{
  home.username = "jslee";
  home.homeDirectory = "/home/jslee";

  home.stateVersion = "23.11";

  home.packages = [
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "emacs -Q";
  };

  programs.home-manager.enable = true;
}
