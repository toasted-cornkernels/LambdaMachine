{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cmus
    ffmpeg
    graphicsmagick
    iina
    imagemagick
    # mpc-cli
    mupdf
    pandoc
    portaudio
    portmidi
    python312Packages.pygments
  ];
}

