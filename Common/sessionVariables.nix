{ config, pkgs, lib, ... }: {
  home.sessionVariables = {
    EDITOR = "emacs -Q";
    PROMPT = "%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# ";
    # TODO select and port over from .zshrc, .zshenv
  };
}
