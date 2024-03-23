{ config, pkgs, ... }:

{
  home.username = "jslee";
  home.homeDirectory =
    if pkgs.system == "aarch64-darwin" || pkgs.system == "x86_64-darwin" then
    "/Users/jslee" else "/home/jslee";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
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
    git-lfs
    glib
    glibc
    gmp
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
    mpv
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
  ] ++
  with haskellPackages; [
    ghcup
  ] ++
  with perl538Packages; [
    WWWYoutubeViewer
  ];

  # TODO
  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "emacs -Q";
  };

  programs.home-manager.enable = true;
}
