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
          "HEAD"
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
      "keymapp"
      "microsoft-auto-update"
      "microsoft-teams"
      "monodraw"
      "ungoogled-chromium"
      "uhk-agent"
      "visual-studio-code"
      "vlc"
      "webex"
      "zoom"
    ];
  };
}
