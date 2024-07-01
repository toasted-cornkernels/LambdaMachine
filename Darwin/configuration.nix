{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.home-manager ];
  environment.darwinConfig = "$HOME/LambdaMachine/Darwin/configuration.nix";

  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = { "extra-experimental-features" = [ "nix-command" "flakes" ]; };
  };

  programs = {
    gnupg.agent.enable = true;
    zsh = {
      enable = true;
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  system.stateVersion = 4;

# fonts.fontDir.enable = true;
# fonts.fonts = with pkgs; [ monaspace fira-code d2coding ];

  homebrew = {
    enable = true;
    taps = [
      "railwaycat/emacsmacport"
    ];
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
    casks = [
      "aldente"
      "alfred"
      "appcleaner"
      "balenaetcher"
      "basictex"
      "betterdisplay"
      "brave-browser"
      "firefox"
      "fliqlo"
      "hammerspoon"
      "hhkb-studio"
      "microsoft-auto-update"
      "microsoft-teams"
      "steam"
      "uhk-agent"
      "utm"
      "vlc"
      "wkhtmltopdf"
      "zoom"
      "handbrake"
      "cloudflare-warp"
    ];
    masApps = {
      "Hidden Bar" = 1452453066;
      "Dark Mode Wallpaper Switcher" = 1488154568;
      "Marked 2 - Markdown Preview" = 890031187;
      "TextSniper - OCR, Copy & Paste" = 1528890965;
      "Magnet" = 441258766;
      "KakaoTalk" = 869223134;
      "Dark Reader for Safari" = 1438243180;
      "AdGuard for Safari" = 1440147259;
    };
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
