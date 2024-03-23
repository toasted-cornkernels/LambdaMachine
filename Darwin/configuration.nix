{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.home-manager
    ];

  # Use a custom configuration.nix location.
  # TODO: Make a git repo called LambdaMachine and point it to its local clone
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/LambdaMachine/Darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = [
        "nix-command"
        "flakes"
      ]
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    gnupg.agent.enable = true;
    zsh = {
      enable = true;
      security.pam.enableSudoTouchIdAuth = true;
    }
  }

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    monaspace
    fira-code
    d2coding
  ];

  homebrew = {
    enable = true;
    brews = [
      {
        "railwaycat/emacsmacport/emacs-mac";
        args = [
          "with-emacs-big-sur-icon"
          "with-imagemagick"
          "with-mac-metal"
          "with-starter"
          "with-xwidgets"
        ]
      }
      "blueutil"
    ];
    casks = [
      "aldente"
      "alfred"
      "appcleaner"
      "basictex"
      "betterdisplay"
      "brave-browser"
      "firefox"
      "cloudflare-warp"
      "hammerspoon"
      "microsoft-auto-update"
      "microsoft-teams"
      "wkhtmltopdf"
      "zoom"
      "wezterm"
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
      "Vimari" = 1480933944;
    }
  };

  system = {
    keyboard = {
      remapCapsLockToControl = true
    };
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
      spaces = {
        spans-displays = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };
      startup = {
        chime = false;
      };
      NSGlobalDomain = {
        "com.apple.mouse.tapBehavior" = 1;
      };
      trackpad = {
        TrackpadThreeFingerDrag = true;
      }
    };
  }
}
