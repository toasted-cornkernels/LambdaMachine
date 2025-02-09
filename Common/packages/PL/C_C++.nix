{ pkgs, ... }:
{
  home.packages = with pkgs; [
   cmake
   # gcc
   stdman
   # libclang
 ];
}

