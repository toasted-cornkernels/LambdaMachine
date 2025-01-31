{ pkgs, config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  imports = [
    ../../Common/modules/fzf.nix
    ../../Common/modules/htop.nix
    ../../Common/modules/tmux.nix
    ../../Common/modules/zoxide.nix
    ../../Common/modules/zsh.nix
    ../../Common/modules/starship.nix
  ];

  home.username = "jslee";
  home.homeDirectory = /Users/${home.username};

 home.file = {
    ".emacs.d" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/ELispMachine";
    };
    ".hammerspoon" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/FennelMachine";
    };
    #"RSS" = { # TODO submodule RSS
    #  enable = true;
    #  recursive = true;
    #};
    ".vimrc" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/VimConfig/.vimrc";
    };
    ".gnupg/gpg-agent.conf".text = ''
      enable-ssh-support
      pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
    '';
  };

  xdg = {
    enable = true;
    configFile = {
      nvim = {
        source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/NeovimConfig";
      };
    };
  }
};
