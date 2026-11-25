{ config, nixpkgs-unstable, pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [ ./programs/zsh.nix ];

  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    CLICOLOR = 1;
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
  };

  home.sessionPath = [ "$HOME/.cargo/bin" ];

  # Hammerspoon (Lua 5.4) searches this directory before ~/.luarocks, so
  # FennelMachine's `require("fennel")` gets the Nix-pinned compiler instead of
  # whatever stale copy luarocks left behind.
  home.file.".local/share/hammerspoon/site/fennel.lua".source =
    "${pkgs.lua54Packages.fennel}/share/lua/5.4/fennel.lua";

  programs = {
    home-manager = { enable = true; };
    direnv = 
      let unstable = import nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
      };
    in {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv = { enable = true; };
      # package = unstable.direnv;
    };
  };

  fonts = { fontconfig.enable = true; };
}
