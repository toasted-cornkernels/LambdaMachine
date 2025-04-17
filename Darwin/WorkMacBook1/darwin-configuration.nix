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
      "aldente"
      "alfred"
      "appcleaner"
      "betterdisplay"
      "drawio"
      "fliqlo"
      "ghostty"
      "hammerspoon"
      "hhkb-studio"
      "microsoft-auto-update"
      "microsoft-teams"
      "monodraw"
      "uhk-agent"
      "visual-studio-code"
      "vlc"
      "webex"
      "wkhtmltopdf"
      "zoom"
    ];
    masApps = {
      "AdGuard for Safari" = 1440147259;
      "Dark Mode Wallpaper Switcher" = 1488154568;
      "Dark Reader for Safari" = 1438243180;
      "Hidden Bar" = 1452453066;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      "iMovie" = 408981434;
    };
  };
}
