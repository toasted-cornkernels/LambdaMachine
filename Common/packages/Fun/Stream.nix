{ pkgs, ... }: {
  home.packages = with pkgs; [
    streamlink
    yt-dlp
    perl540Packages.WWWYoutubeViewer
  ];
}

