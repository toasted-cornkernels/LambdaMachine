{ config, pkgs, lib, ... }:

let
  perl538Packages = with pkgs.perl538Packages; [ WWWYoutubeViewer ];
  lua52Packages = with pkgs.lua52Packages; [ fennel ];
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
      # glibc --> no aarch64
      # grip --> no aarch64
      # jenv
      # kawa
      # libvterm --> no aarch64
      # nxengine-evo --> no darwin
      # obb --> borken
      # picolisp --> borken
      # pygments
      # python38
      # python39
      # rust
      # rustup
      # scala-cli
      # vapoursynth --> borken
      abcl
      ack
      agda
      alda
      ammonite-repl
      asdf
      aspell
      autoconf
      automake
      babashka
      bat
      binutils
      blueutil
      boost
      cask
      chezscheme
      chicken
      cloc
      clojure
      clojure-lsp
      cmake
      cmus
      commitizen
      coreutils
      coursier
      crystal
      cscope
      ctags
      dafny
      dark-mode-notify  # Darwin only
      delta
      deno
      dotnet-sdk_8
      duf
      dust
      ecl
      edencommon
      editorconfig
      elixir
      eza
      fb303
      fbthrift
      fd
      ffmpeg
      fizz
      fnlfmt
      folly
      fswatch
      fzf
      gambit
      gcc
      gd
      gh
      ghcup
      git
      git-delta
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
      grip
      gtk3
      guile
      harfbuzz
      howdoi
      htop
      hunspell
      hy
      id3lib
      idris
      idris2
      imagemagick
      isync
      janet
      jenv
      kawa
      kotlin
      kotlin-language-server
      krb5
      ktlint
      latexml
      ledger
      leiningen
      lfe
      libass
      libffi
      libgccjit
      libheif
      librsvg
      libtool
      libvterm
      llvm
      lua-language-server
      luarocks
      lzlib
      m-cli
      matterbridge
      maven
      mermaid-cli
      minimal-racket
      mit-scheme
      moreutils
      mpc-cli
      mpfr
      mpv
      mu
      mupdf
      mysql
      neomutt
      neovim
      netpbm
      newlisp
      newsboat
      nil
      nim
      ninja
      nixfmt
      node
      nodejs
      nyancat
      onefetch
      opam
      openblas
      opentyrian
      openvino
      pandoc
      pango
      pangolin
      perl
      pinentry_mac
      pkg-config
      plantuml
      poppler
      portaudio
      portmidi
      postgresql
      powershell
      pygments
      python38
      python39
      python310
      qemu
      qt
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
      # sdl12-compat
      # sdl2_net
      # sdl_image
      # sdl_mixer
      # sdl_ttf
      silver-searcher
      skim
      smartmontools
      sonic-pi
      streamlink
      swiProlog
      terminal-notifier
      tesseract
      tetris
      texlab
      the_silver_searcher
      tldr
      tmux
      tokei
      tree
      vapoursynth
      vim
      w3m
      wangle
      watchman
      wget
      xapian
      yarn
      youtube-dl
      yt-dlp
      z3
      zig
      zip
      zoxide
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
