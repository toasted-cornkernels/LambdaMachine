{ pkgs, config, lambdaMachineDir, ... }:
let inherit (config.lib.file) mkOutOfStoreSymlink;
in rec {
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
    ../Common/modules/starship.nix

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

    ./programs/zsh.nix
  ];

  home.packages = with pkgs; [ mpv emacs29 ];

  home.sessionVariables = {
    EDITOR = "nvim";
    CLICOLOR = 1;
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
  };

  home.username = "jslee";
  home.homeDirectory = "/home/${home.username}";
  home.stateVersion = "23.11";

  home.file = {
    ".emacs.d" = {
      source = mkOutOfStoreSymlink
        "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/ELispMachine";
    };
    ".vimrc" = {
      source = mkOutOfStoreSymlink
        "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/VimConfig/.vimrc";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      nvim = {
        source = mkOutOfStoreSymlink
          "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/NeovimConfig";
      };
    };
    desktopEntries = {
      Emacs = {
        name = "Emacs";
        genericName = "Text Editor";
        comment = "Edit text";
        icon = ../ExternalConfigs/assets/CrostiniEmacs.png;
        exec = "${pkgs.emacs29}/bin/emacs";
        terminal = false;
        mimeType = [
          "text/plain"
          "text/english"
          "text/plain"
          "text/x-makefile"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tcl"
          "text/x-tex"
          "application/x-shellscript"
          "text/x-c"
          "text/x-c++"
        ];
        categories = [ "Development" "TextEditor" ];
      };
    };
  };

  programs = { home-manager = { enable = true; }; };
}
