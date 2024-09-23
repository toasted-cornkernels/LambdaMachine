{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.home-manager ];
  environment.darwinConfig = "$HOME/LambdaMachine/Darwin/WorkMacBook/darwin-configuration.nix";

  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = { "extra-experimental-features" = [ "nix-command" "flakes" ]; };
  };

  programs = {
    gnupg.agent.enable = true;
    zsh = { enable = true; };
  };

  security.pam.enableSudoTouchIdAuth = true;

  nixpkgs.config.allowUnfree = false;
  nixpkgs.config.allowUnsupportedSystem = false;

  system.stateVersion = 4;

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
      "blueutil"
    ];
    casks = [ "hammerspoon" "zoom" ];
    masApps = { };
  };

  system = {
    keyboard = { remapCapsLockToControl = true; };
    defaults = {
      dock = {
        autohide = false;
        orientation = "bottom";
        mru-spaces = true;
        show-recents = false;
        show-process-indicators = false;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };
      spaces = { spans-displays = false; };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };
      NSGlobalDomain = { "com.apple.mouse.tapBehavior" = 1; };
      trackpad = { TrackpadThreeFingerDrag = true; };
    };
    startup = { chime = false; };
  };
}
