{ pkgs, ... }: {
  home.packages = with pkgs; [
    streamlink
    yt-dlp
  ];
}

