{ config, pkgs, lib, ... }: {
  home.sessionVariables = {
    EDITOR = "emacs -Q";
    PROMPT = "%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# ";
    CLICOLOR = 1;
    CASE_SENSITIVE = "true";
    HYPHEN_INSENSITIVE = "true";
    COMPLETION_WAITING_DOTS = "true";
    ZSH_DISABLE_COMPFIX = "true";
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
  };
}
