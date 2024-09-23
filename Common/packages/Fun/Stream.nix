{ pkgs, ... }: {
  home.packages = with pkgs; [
    streamlink
    youtube-dl
    yt-dlp
    perl538Packages.WWWYoutubeViewer
    perl538Packages.LaTeXML
  ];
}

