{ pkgs, ... }:
{
  home.packages = with pkgs; [
    commitizen
    delta
    gh
    git
    git-lfs
  ];
}

