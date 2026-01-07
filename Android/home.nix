{ pkgs, config, lambdaMachineDir, userName, userHomeDir, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
rec {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [
    ../Common/modules/fzf.nix
    ../Common/modules/htop.nix
    # ../Common/modules/tmux.nix
    ../Common/modules/zoxide.nix
    ../Common/modules/zsh.nix
    ../Common/modules/starship.nix
    ../Common/modules/newsboat.nix

    ../Common/packages/Fun/Games.nix
    ../Common/packages/Fun/Stream.nix

    ../Common/packages/Lib/Lib.nix

    ../Common/packages/PL/CSharp.nix
    ../Common/packages/PL/C_C++.nix
    ../Common/packages/PL/Clojure.nix
    ../Common/packages/PL/CommonLisp.nix
    ../Common/packages/PL/EmacsLisp.nix
    ../Common/packages/PL/Go.nix
    ../Common/packages/PL/Graphviz.nix

    ../Common/packages/PL/Hy.nix
    ../Common/packages/PL/Janet.nix
    ../Common/packages/PL/JavaScript.nix
    ../Common/packages/PL/LFE.nix
    ../Common/packages/PL/Lua.nix
    ../Common/packages/PL/Nix.nix
    ../Common/packages/PL/Perl.nix
    ../Common/packages/PL/Python.nix
    ../Common/packages/PL/Racket.nix
    ../Common/packages/PL/Ruby.nix
    ../Common/packages/PL/Rust.nix
    ../Common/packages/PL/Scheme.nix
    ../Common/packages/PL/Yaml.nix

    ../Common/packages/Utils/Browser.nix
    ../Common/packages/Utils/Chat.nix
    ../Common/packages/Utils/Compress.nix
    ../Common/packages/Utils/DB.nix
    ../Common/packages/Utils/Dev.nix
    ../Common/packages/Utils/Encrypt.nix
    ../Common/packages/Utils/Edit.nix
    ../Common/packages/Utils/Financial.nix
    ../Common/packages/Utils/Fonts.nix
    ../Common/packages/Utils/Mail.nix
    ../Common/packages/Utils/Media.nix
    ../Common/packages/Utils/News.nix
    ../Common/packages/Utils/Runtimes.nix
    ../Common/packages/Utils/Search.nix
    ../Common/packages/Utils/Shell.nix
    ../Common/packages/Utils/Spell.nix
    ../Common/packages/Utils/Stats.nix
    ../Common/packages/Utils/Unix.nix
    ../Common/packages/Utils/VC.nix
    ../Common/packages/Utils/Web.nix
  ];

  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    CLICOLOR = 1;
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
  };

  programs = { home-manager = { enable = true; }; };

  fonts = {
    fontconfig.enable = true;
  };

 home.file = {
    ".emacs.d" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/ELispMachine";
    };
    ".vimrc" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/dots/.vimrc";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      nvim = {
        source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/NeovimConfig";
      };
    };
  };
}
