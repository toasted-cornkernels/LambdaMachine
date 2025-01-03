{ pkgs, ... }: rec {
  nix = {
    package = pkgs.nix;
    settings = { experimental-features = [ "nix-command" "flakes" ]; };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [
    ../Common/modules/fzf.nix
    ../Common/modules/htop.nix
    ../Common/modules/tmux.nix
    ../Common/modules/zoxide.nix
    ../Common/modules/zsh.nix

    ../Common/packages/Fun/Games.nix
    ../Common/packages/Fun/Stream.nix

    ../Common/packages/PL/C_C++.nix
    ../Common/packages/PL/Clojure.nix
    ../Common/packages/PL/CommonLisp.nix
    ../Common/packages/PL/EmacsLisp.nix
    ../Common/packages/PL/Hy.nix
    ../Common/packages/PL/Janet.nix
    ../Common/packages/PL/JavaScript.nix
    ../Common/packages/PL/Lua.nix
    ../Common/packages/PL/OCaml.nix
    ../Common/packages/PL/Python.nix
    ../Common/packages/PL/Ruby.nix
    ../Common/packages/PL/Racket.nix
    ../Common/packages/PL/Scheme.nix
    ../Common/packages/PL/Yaml.nix
    ../Common/packages/PL/Nix.nix

    ../Common/packages/Utils/Browser.nix
    ../Common/packages/Utils/Compress.nix
    ../Common/packages/Utils/Dev.nix
    ../Common/packages/Utils/Financial.nix
    ../Common/packages/Utils/Search.nix
    ../Common/packages/Utils/News.nix
    ../Common/packages/Utils/Spell.nix
    ../Common/packages/Utils/Stats.nix
    ../Common/packages/Utils/Unix.nix
    ../Common/packages/Utils/VC.nix
    ../Common/packages/Utils/Web.nix
  ];

  home.username = "jslee";
  home.homeDirectory = "/home/${home.username}";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    mpv
    emacs29
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    CLICOLOR = 1;
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
  };
  programs = {
    home-manager = { enable = true; };
    vim = { enable = true; };
  };
}
