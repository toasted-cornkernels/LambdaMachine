{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  imports = [ ../common-configuration.nix ];
  environment.systemPackages = [ pkgs.home-manager ];
  users.users.jslee = {
    home = /Users/jslee;
  };

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
      "mpv"
    ];
    casks = [
      "alfred"
      "android-file-transfer"
      "appcleaner"
      "balenaetcher"
      "basictex"
      "betterdisplay"
      "brave-browser"
      "crossover"
      "firefox"
      "fliqlo"
      "ghostty"
      "hammerspoon"
      "hhkb-studio"
      "proton-pass"
      "protonvpn"
      "syncthing"
      "uhk-agent"
      "utm"
      "vlc"
      "wkhtmltopdf"
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
