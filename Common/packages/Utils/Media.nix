{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cmus
    ffmpeg
    graphicsmagick
    iina
    imagemagick
    mupdf
    pandoc
    portaudio
    portmidi
    python312Packages.pygments
  ];
}

