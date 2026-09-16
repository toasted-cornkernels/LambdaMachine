{ lib, pkgs, username, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  imports = [ ../common-configuration.nix ];
  environment.systemPackages = [ pkgs.home-manager ];
  users.users.jlee4430 = {
    home = /Users/jlee4430;
  };

  homebrew = {
    enable = true;
    taps = [ "railwaycat/emacsmacport" ];
    brews = [
      {
        name = "railwaycat/emacsmacport/emacs-mac@30exp";
        args = [
          "with-imagemagick"
          "with-mac-metal"
          "with-starter"
          "with-emacs-big-sur-icon"
          "with-xwidgets"
          "with-unlimited-select"
        ];
      }
    ];
    casks = [
      "alfred"
      "betterdisplay"
      "fliqlo"
      "ghostty"
      "hammerspoon"
      "macvim-app"
      "visual-studio-code"
    ];
    masApps = { };
  };
}
