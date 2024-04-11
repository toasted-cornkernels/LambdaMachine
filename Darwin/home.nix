{ config, pkgs, lib, ... }:

let
  perl538Packages = with pkgs.perl538Packages; [ WWWYoutubeViewer ];
  lua52Packages = with pkgs.lua52Packages; [ fennel ];
  x = 1;
in rec {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [ ../Common/programs/tmux.nix ];

  home.username = "jslee";
  home.homeDirectory = "/Users/${home.username}";
  home.stateVersion = "23.11";
  home.packages = with pkgs;
    [
      abcl
      agda
      alda
      autoconf
      automake
      babashka
      bat
      boost
      chicken
      cloc
      clojure
      clojure-lsp
      cmake
      coursier
      crystal
      ctags
      dafny
      delta
      deno
      dotnet-sdk_8
      duf
      ecl
      elixir
      eza
      fd
      ffmpeg
      fswatch
      fzf
      gambit
      gcc
      gd
      gh
      git
      git-lfs
      glib
      # glibc --> no aarch64
      gmp
      gnumake
      gnupg
      gnutar
      go
      gobject-introspection
      gpgme
      gradle
      graphicsmagick
      graphviz
      # grip --> no aarch64
      gtk3
      guile
      harfbuzz
      htop
      hy
      imagemagick
      isync
      janet
      # jenv
      # kawa
      kotlin
      kotlin-language-server
      krb5
      ktlint
      ledger
      leiningen
      libass
      libheif
      libtool
      # libvterm --> no aarch64
      llvm
      lua-language-server
      luarocks
      m-cli
      matterbridge
      maven
      mermaid-cli
      moreutils
      mpc-cli
      mpv
      mpfr
      mu
      mysql
      neomutt
      neovim
      netpbm
      newsboat
      nim
      ninja
      nodejs
      # nxengine-evo --> no darwin
      nyancat
      # obb --> borken
      opam
      opentyrian
      pandoc
      pango
      pangolin
      perl
      # picolisp --> borken
      pinentry_mac
      pkg-config
      plantuml
      poppler
      portaudio
      postgresql
      # pygments
      python310
      # python38
      # python39
      rakudo
      readline
      redis
      ripgrep
      roswell
      ruby
      # rust
      # rustup
      sbcl
      sbt
      scala
      skim
      # scala-cli
      silver-searcher
      smartmontools
      streamlink
      terminal-notifier
      tesseract
      texlab
      tldr
      tmux
      tokei
      tree
      # vapoursynth --> borken
      vim
      w3m
      wget
      xapian
      yarn
      yt-dlp
      z3
      zip
    ] ++ perl538Packages ++ lua52Packages;
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
    EDITOR = "emacs -Q";
    PROMPT = "%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# ";
    # TODO select and port over from .zshrc, .zshenv
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
    # wezterm = { # TODO port over wezterm.lua
    #   enable = true;
    # };
  };
}
