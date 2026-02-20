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
        name = "railwaycat/emacsmacport/emacs-mac@30exp";
        args = [
          "HEAD"
          "with-imagemagick"
          "with-mac-metal"
          "with-starter"
          "with-emacs-big-sur-icon"
          "with-xwidgets"
          "with-unlimited-select"
        ];
      }
      "mpv"
      "tty-clock"
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
      "keymapp"
      "microsoft-auto-update"
      "microsoft-teams"
      "monodraw"
      "syncthing-app"
      "uhk-agent"
      "ungoogled-chromium"
      "visual-studio-code"
      "vlc"
      "webex"
      "zoom"
    ];
  };
}
