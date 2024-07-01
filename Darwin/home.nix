{ pkgs, ... }:

let
  perl538Packages = with pkgs.perl538Packages; [ WWWYoutubeViewer LaTeXML ];
  python312Packages = with pkgs.python312Packages; [ hy pygments ];
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
    ../Common/programs/zoxide.nix
    ../Common/programs/fzf.nix
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
      fb303
      fbthrift
      fd
      ffmpeg
      fizz
      fnlfmt
      folly
      fswatch
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
      (lua5_3_compat.withPackages (ps:
        with ps; [
          fennel
          luafilesystem
          readline
          luasocket
          (lua5_3.pkgs.buildLuarocksPackage {
            pname = "jeejah";
            lua = lua5_3;
            version = "0.3.2-1";
            knownRockspec = (pkgs.fetchurl {
              url = "https://luarocks.org/jeejah-0.3.2-1.rockspec";
              sha256 = "sha256-Ouj+umHFOLtGwwMKochvG1fqIyRMdPzXg9039jD/bPk=";
            }).outPath;
            disabled = luaOlder "5.1";
            src = fetchFromGitLab {
              owner = "technomancy";
              repo = "jeejah";
              rev = "1555350e1e5eb77625334db1fba3c79b8c2c30a2";
              sha256 = "sha256-DyJJprTj9WjnhCC5CqudObLuae43zJD0VY9svGbqz10=";
            };
            propagatedBuildInputs = [ luasocket ];
            meta = { };
          })
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
