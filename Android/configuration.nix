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

  android-integration = {
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
  };

  home-manager = {
    config = ./home.nix;
    extraSpecialArgs = {
      lambdaMachineDir = "LambdaMachine";
    };
  };

  time.timeZone = "America/New_York";
}

