{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jslee";
  home.homeDirectory =
    if pkgs.system == "aarch64-darwin" || pkgs.system == "x86_64-darwin" then
    "/Users/jslee" else "/home/jslee";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
      # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jslee/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacs -Q";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
