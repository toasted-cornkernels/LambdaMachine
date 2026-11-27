{ pkgs, lib, ... }:
let
  # nixpkgs marks rdrview Linux-only because of libseccomp, but upstream builds
  # on Darwin too (run it with --disable-sandbox there).
  rdrview = pkgs.rdrview.overrideAttrs (old: {
    buildInputs = [ pkgs.curl pkgs.libxml2 ]
      ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.libseccomp ]
      ++ lib.optionals pkgs.stdenv.isDarwin [ pkgs.libiconv ];
    meta = old.meta // { platforms = lib.platforms.unix; };
  });
in
{
  home.packages = with pkgs; [
    cmus
    ffmpeg
    graphicsmagick
    imagemagick
    mupdf
    pandoc
    portaudio
    portmidi
    python312Packages.pygments
    python3Packages.youtube-transcript-api
    rdrview

  ];
}

