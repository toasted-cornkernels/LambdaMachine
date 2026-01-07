{ pkgs, ... }: {
  home.packages = with pkgs; [
    streamlink
    yt-dlp
    perl5Packages.WWWYoutubeViewer
  ];
}

