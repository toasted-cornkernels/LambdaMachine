{ config, pkgs, ... }:

let lua52Packages = with pkgs.lua52Packages; [ fennel ];
in rec {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [ ../Common/programs/tmux.nix ];

  home.username = "jslee";
  home.homeDirectory = "/home/${home.username}";
  home.stateVersion = "23.11";
  home.packages = with pkgs;
    [
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
      mpv
      picolisp
    ] ++ lua52Packages;

  home.file = {
    # TODO
  };
  home.sessionVariables = {
    EDITOR = "emacs -Q";
    PROMPT = "%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# ";
  };
  programs = {
    home-manager = { enable = true; };
    # zsh = let # TODO port over .zshrc, .zshenv
    #   aarch64-darwin-config = 1; # TODO
    #   x86_64-darwin-config = 1; # TODO
    #   penguin-config = 1; # TODO
    #   guix-config = 1; # TODO
    # in { enable = true; };
    # vim = { # TODO port over .vimrc
    #   enable = true;
    # };
  };
}
