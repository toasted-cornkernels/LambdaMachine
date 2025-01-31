{ config, lib, pkgs, ... }:

{
  environment.packages = with pkgs; [
    vim
    git
    wget
    curl
    openssh
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
    config = import ./home.nix;
    extraSpecialArgs = {
      lambdaMachineDir = "LambdaMachine";
    };
  };

  time.timeZone = "America/Los_Angeles";
}

