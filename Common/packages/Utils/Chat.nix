{ pkgs, ... }:
{
  home.packages = with pkgs; [
    matterbridge
  ];
}
