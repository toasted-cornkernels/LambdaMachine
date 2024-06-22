{ pkgs, ... }:

let
  perl538Packages = with pkgs.perl538Packages; [ WWWYoutubeViewer LaTeXML ];
  lua52Packages = with pkgs.lua52Packages; [ fennel ];
  python312Packages = with pkgs.python312Packages; [ pygments ];
in rec {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [
    ../Common/programs/tmux.nix
    ../Common/programs/zsh.nix
    ./programs/zsh.nix
  ];

  home.username = "jslee";
  home.homeDirectory = "/Users/${home.username}";
  home.stateVersion = "23.11";
  home.packages = with pkgs;
    [
      # binutils
      # dark-mode-notify  # aarch64 Darwin only
      # glibc --> no aarch64
      # grip --> no darwin
      # jenv
      # kawa
      # libvterm  --> no darwin
      # mitscheme --> no darwin
      # nxengine-evo --> no darwin
      # obb --> borken
      # openvino
      # picolisp --> borken
      # pygments
      # python38
      # python39
      # rust
      # rustup
      # scala-cli
      # sdl12-compat
      # sdl2_net
      # sdl_image
      # sdl_mixer
      # sdl_ttf
      # sonic-pi
      # vapoursynth --> borken
      # zig
      abcl
      ack
      agda
      alda
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
      cmus
      commitizen
      coreutils
      coursier
      crystal
      cscope
      ctags
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
      hy
      id3lib
      idris
      idris2
      iina
      imagemagick
      isync
      janet
      kotlin
      kotlin-language-server
      krb5
      ktlint
      ledger
      leiningen
      lfe
      libass
      libffi
      libgccjit
      libheif
      librsvg
      libtool
      llvm
      lua-language-server
      luarocks
      lzlib
      m-cli
      matterbridge
      maven
      mermaid-cli
      moreutils
      mpc-cli
      mpfr
      mu
      mupdf
      mysql
      neomutt
      netpbm
      newsboat
      nil
      nim
      ninja
      nixfmt-classic
      nodejs
      nyancat
      onefetch
      opam
      openblas
      opentyrian
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
      python312
      qemu
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
      silver-searcher
      skim
      smartmontools
      streamlink
      swiProlog
      terminal-notifier
      tesseract
      texlab
      tldr
      tokei
      tree
      vitetris
      w3m
      wangle
      watchman
      wget
      xapian
      yarn
      youtube-dl
      yt-dlp
      z3
      zip
      zoxide
    ] ++ perl538Packages ++ lua52Packages ++ python312Packages;
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
    PROMPT = "%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# ";
    CLICOLOR = 1;
  };
  programs = {
    home-manager = { enable = true; };
    vim = {
      enable = true;
      defaultEditor = true;
    };
    # wezterm = { # TODO port over wezterm.lua
    #   enable = true;
    # };
  };
}
