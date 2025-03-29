{ pkgs, ... }:
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
  ];
}

