{ pkgs, ... }:

rec {
  nixpkgs = { config = { allowUnfree = false; }; };

  imports = [
    ../../Common/programs/tmux.nix
    ../../Common/programs/zsh.nix
    ../../Common/programs/zoxide.nix
    ../../Common/programs/fzf.nix
    ../../Common/programs/htop.nix
    ../programs/zsh.nix
  ];

  home.username = "jslee";
  home.homeDirectory = "/Users/${home.username}";
  home.stateVersion = "23.11";
  home.packages = with pkgs;
    [
      abcl
      ack
      agda
      ammonite
      asdf
      aspell
      autoconf
      automake
      babashka
      bat
      blueutil
      boost
      cask
      chez
      chicken
      cloc
      clojure
      clojure-lsp
      cmake
      commitizen
      coreutils
      coursier
      crystal
      cscope
      ctags
      curl
      dafny
      delta
      deno
      dotnet-sdk_8
      duf
      dust
      ecl
      edencommon
      elixir
      eza
      fd
      ffmpeg
      fizz
      fnlfmt
      fswatch
      gambit
      gcc
      gh
      git
      git-lfs
      glib
      gmp
      gnumake
      gnupg
      gnutar
      go
      gobject-introspection
      gopls
      gotop
      gpgme
      gradle
      graphicsmagick
      graphviz
      gtk3
      guile
      harfbuzz
      htop
      hunspell
      idris
      idris2
      iina
      imagemagick
      isync
      janet
      kotlin
      kotlin-language-server
      ktlint
      leiningen
      lfe
      libass
      libffi
      libgccjit
      libheif
      libtool
      llvm
      lua-language-server
      lzlib
      m-cli
      maven
      mermaid-cli
      moreutils
      mpc-cli
      mpfr
      mu
      mysql
      nil
      nim
      ninja
      nixfmt-classic
      nodejs
      onefetch
      opam
      openblas
      pandoc
      pango
      pangolin
      perl
      pinentry_mac
      pkg-config
      plantuml
      poppler
      postgresql
      powershell
      python312
      racket-minimal
      rakudo
      readline
      redis
      ripgrep
      rlwrap
      roswell
      ruby
      rust-analyzer
      sbcl
      sbt
      scala
      silver-searcher
      skim
      smartmontools
      swiProlog
      terminal-notifier
      tesseract
      texlab
      tldr
      tokei
      tree
      wangle
      watchman
      wget
      xapian
      yarn
      z3
      zip
      (lua5_3_compat.withPackages (ps:
        with ps; [
          fennel
          luafilesystem
          readline
          luasocket
        ]))
    ] ++ perl538Packages ++ python312Packages;
  # home.file = {
  #   "ELispMachine" = { # TODO submodule ELispMachine
  #     source = "TODO";
  #     recursive = true;
  #   };
  #   "NeovimConfig" = { # TODO submodule NeovimConfig
  #     source = "TODO";
  #     recursive = true;
  #   };
  #   "FennelMachine" = { # TODO submodule FennelMachine
  #     source = "TODO";
  #     recursive = true;
  #   };
  #   #"RSS" = { # TODO submodule RSS
  #   #  enable = true;
  #   #  recursive = true;
  #   #};
  # };
  home.sessionVariables = {
    EDITOR = "nvim";
    PROMPT = "%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# ";
    CLICOLOR = 1;
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
    TEST = 1;
  };
  programs = {
    home-manager = { enable = true; };
    vim = { enable = true; };
  };
}
