{ pkgs, config, ... }:

{
  environment = {
    systemPackages = [ pkgs.home-manager ];
    systemPath = [ "$HOME/.cargo/bin" ];
    # Nixpkgs' curl/OpenSSL ignore NIX_SSL_CERT_FILE and fall back to an
    # nss-cacert CApath that fails to verify (curl error 60), breaking e.g.
    # Elfeed. Point the standard OpenSSL variable at the bundle nix-darwin's
    # security.pki writes (the same one NIX_SSL_CERT_FILE names).
    variables.SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  };

  nix = {
    package = pkgs.nix;
    settings = { experimental-features = [ "nix-command" "flakes" ]; };
  };

  programs = {
    gnupg = { agent = { enable = true; }; };
    zsh = { enable = true; };
  };

  # Refresh Homebrew's cask/formula metadata on each switch; stale metadata
  # fails casks whose upstream replaced a download in place (checksum mismatch).
  homebrew.onActivation.autoUpdate = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  system = {
    stateVersion = 4;
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    defaults = {
      dock = {
        autohide = false;
        orientation = "bottom";
        mru-spaces = false;
        show-recents = false;
        show-process-indicators = false;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };
      spaces = { spans-displays = false; };
      WindowManager = {
        EnableStandardClickToShowDesktop = false;
        GloballyEnabled = false;
      };
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
