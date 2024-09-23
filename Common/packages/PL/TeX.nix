{ pkgs, ... }:
{
  home.packages = with pkgs; [
    texliveBasic
    texlab
    texlivePackages.texliveonfly
  ];
}

