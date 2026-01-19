{ pkgs, config, lambdaMachineDir, ... }:
let inherit (config.lib.file) mkOutOfStoreSymlink;
in rec {

  home.sessionPath = [ "/opt/homebrew/bin" ];
  imports = [
    ../common-home.nix

    ../../Common/modules/fzf.nix
    ../../Common/modules/htop.nix
    ../../Common/modules/tmux.nix
    ../../Common/modules/zoxide.nix
    ../../Common/modules/zsh.nix
    ../../Common/modules/starship.nix
    ../../Common/modules/newsboat.nix

    ../../Common/packages/Fun/Games.nix
    ../../Common/packages/Fun/Stream.nix

    ../../Common/packages/Lib/Lib.nix

    ../../Common/packages/PL/Agda.nix
    ../../Common/packages/PL/CSharp.nix
    ../../Common/packages/PL/C_C++.nix
    ../../Common/packages/PL/Clojure.nix
    ../../Common/packages/PL/CommonLisp.nix
    ../../Common/packages/PL/Crystal.nix
    ../../Common/packages/PL/Elixir.nix
    ../../Common/packages/PL/EmacsLisp.nix
    ../../Common/packages/PL/Go.nix
    ../../Common/packages/PL/Graphviz.nix
    ../../Common/packages/PL/Haskell.nix
    ../../Common/packages/PL/Hy.nix
    ../../Common/packages/PL/Idris.nix
    ../../Common/packages/PL/Janet.nix
    ../../Common/packages/PL/JavaScript.nix
    ../../Common/packages/PL/Kotlin.nix
    ../../Common/packages/PL/LFE.nix
    ../../Common/packages/PL/Lua.nix
    ../../Common/packages/PL/Mermaid.nix
    ../../Common/packages/PL/Nim.nix
    ../../Common/packages/PL/Nix.nix
    ../../Common/packages/PL/OCaml.nix
    ../../Common/packages/PL/Perl.nix
    ../../Common/packages/PL/Prolog.nix
    ../../Common/packages/PL/Python.nix
    ../../Common/packages/PL/Racket.nix
    ../../Common/packages/PL/Ruby.nix
    ../../Common/packages/PL/Rust.nix
    ../../Common/packages/PL/Scala.nix
    ../../Common/packages/PL/Scheme.nix
    ../../Common/packages/PL/Shell.nix
    ../../Common/packages/PL/TeX.nix
    ../../Common/packages/PL/Yaml.nix
    ../../Common/packages/PL/Z3.nix

    ../../Common/packages/Utils/Android.nix
    ../../Common/packages/Utils/Browser.nix
    ../../Common/packages/Utils/Chat.nix
    ../../Common/packages/Utils/Compress.nix
    ../../Common/packages/Utils/DB.nix
    ../../Common/packages/Utils/Dev.nix
    ../../Common/packages/Utils/Edit.nix
    ../../Common/packages/Utils/Encrypt.nix
    ../../Common/packages/Utils/Financial.nix
    ../../Common/packages/Utils/Fonts.nix
    ../../Common/packages/Utils/Mac.nix
    ../../Common/packages/Utils/Mail.nix
    ../../Common/packages/Utils/Media.nix
    ../../Common/packages/Utils/News.nix
    ../../Common/packages/Utils/Runtimes.nix
    ../../Common/packages/Utils/Search.nix
    ../../Common/packages/Utils/Shell.nix
    ../../Common/packages/Utils/Spell.nix
    ../../Common/packages/Utils/Stats.nix
    ../../Common/packages/Utils/Unix.nix
    ../../Common/packages/Utils/VC.nix
    ../../Common/packages/Utils/VM.nix
    ../../Common/packages/Utils/Web.nix

    ../programs/zsh.nix
  ];

  home.username = "jslee";
  home.homeDirectory = /Users/${home.username};

  home.file = {
    ".emacs.d" = {
      source = mkOutOfStoreSymlink
        "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/ELispMachine";
    };
    ".hammerspoon" = {
      source = mkOutOfStoreSymlink
        "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/FennelMachine";
    };
    #"RSS" = { # TODO submodule RSS
    #  enable = true;
    #  recursive = true;
    #};
    ".vimrc" = {
      source = mkOutOfStoreSymlink
        "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/dots/.vimrc";
    };
    ".gnupg/gpg-agent.conf".text = ''
      enable-ssh-support
      pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
    '';
    ".w3m/keymap" = {
      source = mkOutOfStoreSymlink
        "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/dots/.w3m/keymap";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      nvim = {
        source = mkOutOfStoreSymlink
          "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/NeovimConfig";
      };
      ghostty = {
        source = mkOutOfStoreSymlink
          "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/dots/ghostty";
      };
    };
  };
}
