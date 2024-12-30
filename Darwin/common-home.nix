{ ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [ ./programs/zsh.nix ];

  home.stateVersion = "23.11";

  home.sessionVariables = {
    EDITOR = "nvim";
    PROMPT = "%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# ";
    CLICOLOR = 1;
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
  };
  programs = {
    home-manager = { enable = true; };
    vim = { enable = true; };
  };
}
