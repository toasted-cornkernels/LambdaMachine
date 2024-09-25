{ pkgs, ... }:

rec {
  nixpkgs = { config = { allowUnfree = false; }; };

  imports = [
    ../common-home.nix

    ../../Common/modules/fzf.nix
    ../../Common/modules/htop.nix
    ../../Common/modules/tmux.nix
    ../../Common/modules/zoxide.nix
    ../../Common/modules/zsh.nix

    ../../Common/packages/PL/Go.nix
    ../../Common/packages/PL/Ruby.nix
    ../../Common/packages/PL/Python.nix
    ../../Common/packages/PL/Yaml.nix

    ../../Common/packages/Utils/Compress.nix
    ../../Common/packages/Utils/Dev.nix
    ../../Common/packages/Utils/Mac.nix
    ../../Common/packages/Utils/Search.nix
    ../../Common/packages/Utils/Shell.nix
    ../../Common/packages/Utils/Stats.nix
    ../../Common/packages/Utils/Unix.nix
    ../../Common/packages/Utils/VC.nix
    ../../Common/packages/Utils/Web.nix

    ../programs/zsh.nix
  ];

  home.username = "jslee";
  home.homeDirectory = "/Users/${home.username}";
    # home.file = {
  #   "ELispMachine" = { # TODO submodule ELispMachine
  #     source = "TODO";
  #     recursive = true;
  #   };
  #   "NeovimConfig" = { # TODO submodule NeovimConfig
  #     source = "TODO";
  #     recursive = true;
  #   };
  #   "FennelMachine" = { # TODO submodule FennelMachine
  #     source = "TODO";
  #     recursive = true;
  #   };
  #   #"RSS" = { # TODO submodule RSS
  #   #  enable = true;
  #   #  recursive = true;
  #   #};
  # };
}
