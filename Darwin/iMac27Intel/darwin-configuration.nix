{ pkgs, ... }:

{
  imports = [ ../common-configuration.nix ];
  environment.systemPackages = [ pkgs.home-manager ];
  environment.darwinConfig =
    "$HOME/LambdaMachine/Darwin/iMac27Intel/darwin-configuration.nix";

  homebrew = {
    enable = true;
    taps = [ "railwaycat/emacsmacport" ];
    brews = [
      {
        name = "railwaycat/emacsmacport/emacs-mac";
        args = [
          "with-imagemagick"
          "with-mac-metal"
          "with-starter"
          "with-emacs-big-sur-icon"
          "with-xwidgets"
        ];
      }
    ];
    casks = [
      "aldente"
      "alfred"
      "android-file-transfer"
      "appcleaner"
      "balenaetcher"
      "basictex"
      "betterdisplay"
      "brave-browser"
      "cloudflare-warp"
      "firefox"
      "fliqlo"
      "hammerspoon"
      "handbrake"
      "hhkb-studio"
      "microsoft-auto-update"
      "microsoft-teams"
      "mpv"
      "musicbrainz-picard"
      "proton-pass"
      "protonvpn"
      "steam"
      "uhk-agent"
      "utm"
      "vlc"
      "wkhtmltopdf"
      "xld"
      "zoom"
    ];
    masApps = {
      "AdGuard for Safari" = 1440147259;
      "Dark Mode Wallpaper Switcher" = 1488154568;
      "Dark Reader for Safari" = 1438243180;
      "Hidden Bar" = 1452453066;
      "KakaoTalk" = 869223134;
      "Magnet" = 441258766;
      "Marked 2 - Markdown Preview" = 890031187;
      "TextSniper - OCR, Copy & Paste" = 1528890965;
    };
  };
}