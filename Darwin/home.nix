{ config, pkgs, lib, ... }:

let
  haskellPackages = with haskellPackages; [ ghcup ];
  perl538Packages = with perl538Packages; [ WWWYoutubeViewer ];
  lua52Packages = with lua52Packages; [ fennel ];

in rec {
  home.username = "jslee";
  home.homeDirectory = if lib.stdenv.isDarwin then
    "/Users/${home.username}"
  else
    "/home/${home.username}";
  home.stateVersion = "23.11";
  home.packages = with pkgs;
    [
      abcl
      agda
      alda
      ammonite
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
      dotnet
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
      glibc
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
      grip
      gtk3
      guile
      harfbuzz
      htop
      hy
      imagemagick
      isync
      janet
      jenv
      kawa
      kotlin
      kotlin-language-server
      krb5
      ktlint
      ledger
      leiningen
      libass
      libheif
      libtool
      libvterm
      llvm
      lua-language-server
      luarocks
      m-cli
      matterbridge
      maven
      mermaid-cli
      moreutils
      mpc-cli
      mpfr
      mpv-with-scripts
      mu
      mysql
      neomutt
      neovim
      netpbm
      newsboat
      nim
      ninja
      nodejs
      nxengine-evo
      nyancat
      obb
      opam
      opentyrian
      pandoc
      pango
      pangolin
      perl
      picolisp
      pinentry_mac
      pkg-config
      plantuml
      poppler
      portaudio
      postgresql
      pygments
      python310
      python38
      python39
      rakudo
      readline
      redis
      ripgrep
      roswell
      ruby
      rust
      rustup
      sbcl
      sbt
      scala
      scala-cli
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
      vapoursynth
      vim
      w3m
      wget
      xapian
      yarn
      youtube-viewer
      yt-dlp
      z3
      zip
    ] ++ haskellPackages ++ perl538Packages;
  home.file = {
    # TODO
    # .zshrc: aarch64-darwin, x86_64-darwin, chromebook, guix
    # .zshenv: aarch64-darwin, x86_64-darwin, chromebook, guix
    # .tmux.conf (nix module)
    # .vimrc
    # wezterm
    # ELispMachine (git submodule)
    # FennelMachine (git submodule)
    # NeovimConfig (git submodule)
    # RSS (git submodule)
  };
  home.sessionVariables = {
    EDITOR = "emacs -Q";
    PROMPT = "%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# ";
    # TODO
  };
  programs.home-manager.enable = true;
}
