{ pkgs, ... }: {
  home.packages = with pkgs; [
    streamlink
    yt-dlp
    perl538Packages.WWWYoutubeViewer
    perl538Packages.LaTeXML
  ];
}

