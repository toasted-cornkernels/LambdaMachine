{ config, lib, pkgs, ... }:

{
  user = {
    shell = "${pkgs.zsh}/bin/zsh";
  };

  terminal = {
    font = "${pkgs.d2coding}/share/fonts/truetype/D2Coding.ttf";
  };

  environment.packages = with pkgs; [
    vim
    emacs
    # git
    wget
    curl
    openssh
    gcc
    gawk
    home-manager
  ];

  environment = {
    motd = "";
    etcBackupExtension = ".bak";
  };

  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  home-manager = {
    config = ./home.nix;
    extraSpecialArgs = {
      lambdaMachineDir = "LambdaMachine";
    };
  };

  time.timeZone = "America/New_York";
}

