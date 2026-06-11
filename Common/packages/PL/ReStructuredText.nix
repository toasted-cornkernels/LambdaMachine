{ pkgs, ... }:
with pkgs; {
  home.packages = with pkgs; [
    rst2pdf
 ];
}
