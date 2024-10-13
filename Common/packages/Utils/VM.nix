{ pkgs, ... }:
{
  home.packages = with pkgs; [
    docker
    qemu
    colima
  ];
}
