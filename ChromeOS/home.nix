{ config, pkgs, ... }:

let lua52Packages = with lua52Packages; [ fennel ];
in {
  home.username = "jslee";
  home.homeDirectory = "/home/jslee";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    abcl
    chicken
    clojure
    cmake
    delta
    ecl
    emacs
    eza
    gcc-wrapper
    git
    gnumake
    guile
    home-manager-path
    hy
    janet
    libtool
    lua
    mpv-with-scripts
    picolisp
  ] ++ lua52Packages;

  home.file = { };
  home.sessionVariables = { EDITOR = "emacs -Q"; };

  programs.home-manager.enable = true;
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = [
      # TODO
    ];
  };
}
