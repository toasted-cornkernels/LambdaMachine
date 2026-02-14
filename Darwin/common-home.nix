{ config, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [ ./programs/zsh.nix ];

  home.stateVersion = "25.11";

  home.sessionVariables = {
    EDITOR = "nvim";
    CLICOLOR = 1;
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
  };

  home.sessionPath = [ "$HOME/.cargo/bin" ];

  programs = {
    home-manager = { enable = true; };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv = { enable = true; };
    };
  };

  fonts = { fontconfig.enable = true; };
}
