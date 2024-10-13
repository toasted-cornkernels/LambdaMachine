{ config, pkgs, ... }:

{
  imports = [ ../common-configuration.nix ];
  environment.systemPackages = [ pkgs.home-manager ];
  environment.darwinConfig = "$HOME/LambdaMachine/Darwin/WorkMacBook1/darwin-configuration.nix";

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
      "appcleaner"
      "betterdisplay"
      "drawio"
      "fliqlo"
      "hammerspoon"
      "hhkb-studio"
      "microsoft-auto-update"
      "microsoft-teams"
      "monodraw"
      "mpv"
      "slack"
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
      "Magnet" = 441258766;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      "iMovie" = 408981434;
    };
  };
}